#######################################################################################################################################################################################################
#
# Changes to this structure
# General
#     2022-May-25: add Root structure
#     2022-Jul-15: add fields e, ∂e∂t
#     2022-Jul-19: use kwdef for the constructor
#
#######################################################################################################################################################################################################
"""

$(TYPEDEF)

Structure to save root parameters

# Fields

$(TYPEDFIELDS)

"""
Base.@kwdef mutable struct Root{FT<:AbstractFloat}
    # parameters that do not change with time
    "[`RootHydraulics`](@ref) type root hydraulic system"
    HS::RootHydraulics{FT} = RootHydraulics{FT}()

    # prognostic variables that change with time (# TODO: add wood storage as well)
    "Total stored energy in water `[J]`"
    e::FT = T₂₅() * sum(HS.v_storage) * CP_L_MOL(FT)
    "Current temperature"
    t::FT = T₂₅()

    # diagnostic variables that change with time
    "Marginal increase in energy `[W]`"
    ∂e∂t::FT = 0
end
