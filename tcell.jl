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


cells = Union{tcell, dcell}

function initialize_model(; 
    n_dcell = 5, 
    n_tcell = 10, 
    speed = 50.0,
    extent = (300,300),    
    visual_distance = 5.0,
    activated_status= false,
    temp_tuple = (1.0,1.0),
    )

    space2d = ContinuousSpace(extent; spacing = 3)
    
    model = ABM(cells, space2d ; 
        scheduler = Schedulers.randomly)

    for _ in 1:n_tcell
        add_agent!(
            tcell, model, temp_tuple, speed, activated_status, visual_distance
        )
    end
    
    for _ in 1:n_dcell
        add_agent!(
            dcell, model, temp_tuple, speed, activated_status, visual_distance,
        )
    end

    return model
end

const cell_polygon = Polygon(Point2f[(-0.5, -0.5), (1, 0), (-0.5, 0.5)])
function cell_marker(b::cells)
    φ = atan(b.vel[2], b.vel[1]) #+ π/2 + π
    scale(rotate2D(cell_polygon, φ), 2)
end


function agent_step!(cells, model)
    direction = (2,-3)
    walk!(cells, direction, model; ifempty = false)
end


CairoMakie.activate!()

ac(tell) = :black
ac(dcell) = :blue

as(cells) = 30
# as(tcell) = 10


model = initialize_model()
abmvideo("./tcell.mp4", model, agent_step!;
title = "imuune cell", framerate  = 15, frames = 100, as, ac, am = cell_marker)

