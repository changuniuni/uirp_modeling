using Agents



mutable struct DCell <: AbstractAgent
    id ::Int
    pos :: Tuple{int, int}
    speed::Float64
end

mutable struct TCell <: AbstractAgent
    id::Int
    pos::Tuple{int, int}
    speed::Float64

end



function initialize_model(; 
    n_dcell = 5, 
    n_tcell = 10, 
    speed = 1.0, 
    extent = (100,100),    
    )

    space2d = ContinuousSpace(extent; spacing = 3.0)
    model_dcell = ABM(DCell, space2d, scheduler = Schedulers.Randomly())
    model_tcell = ABM(TCell, space2d,  scheduler = Schedulers.Randomly())

    for _ in 1:n_tcell
        add_agent!(
            model_tcell,
            speed,
        )
    for _ in 1:n_dcell
        add_agent!(
            model_dcell,
            speed
        )
    end
    return model_dcell, model_tcell
end



