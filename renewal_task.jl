using Agents
using Random
using InteractiveDynamics
using CairoMakie

@agent tcell ContinuousAgent{2} begin
    activation_status::Float64
    has_been_activated::Bool
    time_after_activation::Int
    is_currently_activated::Bool
end

@agent dcell ContinuousAgent{2} begin
    activation_status::Float64
    time_after_activation::Int
    is_currently_activated::Bool
    neighbor_tcell_id::Int
end


cells = Union{tcell, dcell}

function initialize_model(; 
    n_dcell = 10, 
    n_tcell = 20, 
    speed = 5,
    extent = (900,900),    
    visual_distance = 5.0,
    activation_status = 0.0,
    has_been_activated = false,
    time_after_activation = 0, 
    is_currently_activated = false,
    neighbor_tcell_id = -1,
    )

    space2d = ContinuousSpace(extent; spacing = 10,)
    
    model = ABM(cells, space2d , rng = MersenneTwister(10), properties = Dict(:dt => 1.0); 
        scheduler = Schedulers.randomly)

    #scale the random number
    
    for _ in 1:n_tcell
        pos = Tuple(rand(model.rng, 2)) .* 900
        vel = sincos(2π * rand(model.rng)) .* speed 
        add_agent!(
            pos, tcell, model , vel, activation_status, has_been_activated, time_after_activation, is_currently_activated
        )
    end
    
    for _ in 1:n_dcell
        pos = Tuple(rand(model.rng, 2)) .* 900
        vel = sincos(2π * rand(model.rng)) .* speed .* 0.6
        add_agent!(
            pos, dcell, model, vel, activation_status, time_after_activation, is_currently_activated, neighbor_tcell_id
        )
    end
    
    return model
end


model = initialize_model()
# 1 time step = i minute
# t cell - d cell interaction lasts for 1440 time steps

function agent_step!(cells, model; speed = 5,)
    if cells isa dcell # d cell case
        neighbor_ids = nearby_ids(cells, model, 10) #set boundary for neighbor as 10
        if cells.time_after_activation == 0 # d cell is not currently activated
            for id in neighbor_ids
                neighbor = model[id]
                if neighbor isa tcell && neighbor.has_been_activated == false
                    neighbor.has_been_activated = true
                    cells.neighbor_tcell_id = id
                    cells.time_after_activation = 1
                    neighbor.time_after_activation = 1
                    cells.vel = (0,0)
                    neighbor.vel = (0,0)
                end
                break
            end
        elseif cells.time_after_activation < 1440
            id = cells.neighbor_tcell_id
            neighbor = model[id]
            cells.time_after_activation += 1
            neighbor.time_after_activation += 1
            cells.vel = (0,0)
            neighbor.vel = (0,0)
        else
            id = cells.neighbor_tcell_id
            neighbor = model[id]
            cells.neighbor_tcell_id = -1
            cells.time_after_activation = 0
            neighbor.time_after_activation += 1
            neighbor.vel =  sincos(2π * rand(model.rng)) .* speed 
            cells.vel = sincos(2π * rand(model.rng)) .* speed .* 0.6 
        end

    else #t cell case
        if cells.time_after_activation > 0 && cells.time_after_activation < 1440
            cells.activation_status += 1/240  # +1/4 hour
        elseif cells.time_after_activation >= 1440
            cells.activation_status -= 1/60 # -1/hour
        end

        if cells.activation_status >= 3
            cells.is_currently_activated = true
        else
            cells.is_currently_activated = false
        end
    end

    if cells.time_after_activation > 0 && cells.time_after_activation < 1440
        cells.vel = (0,0)
    else
        if cells isa tcell
            cells.vel =  sincos(2π * rand(model.rng)) .* speed
        else
            cells.vel = sincos(2π * rand(model.rng)) .* speed .* 0.6
        end
    end

    move_agent!(cells, model, model.dt)
end

CairoMakie.activate!()


istcell(a) = a isa tcell
isdcell(a) = a isa dcell
iscurrently_activated(a) = a.is_currently_activated == true

steps = 10000
adata = [(istcell,count),(isdcell,count), (iscurrently_activated, count)]
adf, mdf= run!(model, agent_step!, steps; adata)

function plot_population(adf, mdf)
    figure = Figure(resolution = (600, 400))
    ax = figure[1, 1] = Axis(figure; xlabel = "Step", ylabel = "Population")
    tcell_l = lines!(ax, adf.step, adf.count_istcell, color = :black)
    dcell_l = lines!(ax, adf.step, adf.count_isdcell, color = :blue)
    activated_l = lines!(ax, adf.step, adf.count_iscurrently_activated, color = :orange)
    figure[1, 2] = Legend(figure, [tcell_l, dcell_l, activated_l], ["tcell","dcell","activated"])
    figure
end

plot_population(adf, mdf)



# ashape(a) = :circle
# asize(a) = a isa dcell ? 20 : 10
# acolor(a) = (a isa tcell && a.time_after_activation >= 1440) ? :blue : :black
# # acolor(a) = a.activation_status > 0 ? :blue : :black

# abmvideo("tcell.mp4", model, agent_step!;
# title = "immune cell", framerate  = 100, frames = 10000, as=asize, am = ashape, ac = acolor)
            


