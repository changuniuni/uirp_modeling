using Agents
using Random


mutable struct dcell <: AbstractAgent
    pos :: Tuple{float, float}
    speed::Float64
    activated::Bool
end

mutable struct tcell <: AbstractAgent
    pos::Tuple{float, float}
    speed::Float64
    activated::Bool
end



function initialize_model(; 
    n_dcell = 5, 
    n_tcell = 10, 
    speed = 1.0, 
    extent = (100,100),    
    )

    space2d = ContinuousSpace(extent; spacing = 3.0)
    
    model = ABM(Union{dcell, tcell}, space2d),  scheduler = Schedulers.Randomly()

    # model_dcell = ABM(DCell, space2d, scheduler = Schedulers.Randomly())
    # model_tcell = ABM(TCell, space2d,  scheduler = Schedulers.Randomly())

    for _ in 1:n_tcell
        add_agent!(
            tcell, model, speed
        )
    end
    
    for _ in 1:n_dcell
        add_agent!(
            dcell, model, speed
        )
    end
    return model
end


