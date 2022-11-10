using Agents
using Random
using InteractiveDynamics
using CairoMakie

@agent tcell ContinuousAgent{2} begin
    speed::Float64
    activated::Bool
    visual_distance::Float64
end

@agent dcell ContinuousAgent{2} begin
    speed::Float64
    activated::Bool
    visual_distance::Float64
end


function initialize_model(; 
    n_dcell = 5, 
    n_tcell = 10, 
    speed = 5.0,
    extent = (300,300),    
    visual_distance = 5.0,
    activated_status= false,
    tuple = (1.0,1.0),
    )

    space2d = ContinuousSpace(extent; spacing = 3)
    
    cells = Union{tcell, dcell}
    model = ABM(cells, space2d ; 
        scheduler = Schedulers.randomly)

    for _ in 1:n_tcell
        add_agent!(
            tcell, model, tuple, speed, activated_status, visual_distance
        )
    end
    
    for _ in 1:n_dcell
        add_agent!(
            dcell, model, tuple, speed, activated_status, visual_distance,
        )
    end

    return model
end

a = initialize_model()

figure, = abmplot(a; )
figure

# function agent_step!(cells, model)
#     neighbot_ids = nearby_ids(cells, model, cells.visual_distance)
#     N = 0
# end

    
    # for id in nearby_ids
    #     neighbor = model[id].pos
    #     heading  = neighbor .- cells.pos






