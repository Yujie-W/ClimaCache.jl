#######################################################################################################################################################################################################
#
# Changes to this type
# General
#     2022-Jun-02: add abstract type for LIDF algorithms
#
#######################################################################################################################################################################################################
"""

$(TYPEDEF)

Hierarchy of AbstractLIDFAlgorithm:
- [`VerhoefLIDF`](@ref)

"""
abstract type AbstractLIDFAlgorithm{FT<:AbstractFloat} end


#######################################################################################################################################################################################################
#
# Changes to this structure
# General
#     2022-Jun-02: migrate from CanopyLayers
#     2022-Jun-02: rename Canopy4RT to HyperspectralMLCanopy
#     2022-Jun-02: abstractize LIDF as a field
#
#######################################################################################################################################################################################################
"""

$(TYPEDEF)

Structure for Verhoef LIDF algorithm

# Fields

$(TYPEDFIELDS)

"""
Base.@kwdef mutable struct VerhoefLIDF{FT<:AbstractFloat} <: AbstractLIDFAlgorithm{FT}
    # General model information
    "Leaf inclination angle distribution function parameter a"
    A::FT = 0
    "Leaf inclination angle distribution function parameter b"
    B::FT = 0
end


#######################################################################################################################################################################################################
#
# Changes to this type
# General
#     2022-Jun-02: add abstract type for canopy structure
#
#######################################################################################################################################################################################################
"""

$(TYPEDEF)

Hierarchy of AbstractCanopy:
- [`BroadbandSLCanopy`](@ref)
- [`HyperspectralMLCanopy`](@ref)

"""
abstract type AbstractCanopy{FT<:AbstractFloat} end


#######################################################################################################################################################################################################
#
# Changes to this structure
# General
#     2022-Jun-15: add struct for broadband radiative transfer scheme such as two leaf model
#     2022-Jun-15: add more cache variables
#     2022-Jun-15: add radiation profile
#     2022-Jun-15: remove RATIO_HV to compute the coefficient numerically
#     2022-Jun-16: remove some cache variables
#     2022-Jun-16: add fields: ??_INCL_BNDS
#
#######################################################################################################################################################################################################
"""

$(TYPEDEF)

Structure to save single layer broadband canopy parameters

# Fields

$(TYPEDFIELDS)

"""
Base.@kwdef mutable struct BroadbandSLCanopy{FT<:AbstractFloat} <: AbstractCanopy{FT}
    # Dimensions
    "Dimension of inclination angles"
    DIM_INCL::Int = 9

    # Embedded structures
    "Leaf inclination angle distribution function algorithm"
    LIDF::Union{VerhoefLIDF{FT}} = VerhoefLIDF{FT}()
    "Canopy radiation profiles"
    RADIATION::BroadbandSLCanopyRadiationProfile{FT} = BroadbandSLCanopyRadiationProfile{FT}(DIM_INCL = DIM_INCL)

    # Geometry information
    "Inclination angle distribution"
    P_INCL::Vector{FT} = ones(FT, DIM_INCL) ./ DIM_INCL
    "Bounds of inclination angles `[??]`"
    ??_INCL_BNDS::Matrix{FT} = FT[ collect(FT, range(0, 90; length=DIM_INCL+1))[1:end-1] collect(FT, range(0, 90; length=DIM_INCL+1))[2:end] ]
    "Mean inclination angles `[??]`"
    ??_INCL::Vector{FT} = [ (??_INCL_BNDS[_i,1] + ??_INCL_BNDS[_i,2]) / 2 for _i in 1:DIM_INCL ]

    # Prognostic variables
    "Clumping index"
    ci::FT = 1
    "Leaf area index"
    lai::FT = 3
end


#######################################################################################################################################################################################################
#
# Changes to this structure
# General
#     2022-Jun-02: migrate from CanopyLayers
#     2022-Jun-02: rename Canopy4RT to HyperspectralMLCanopy
#     2022-Jun-02: abstractize LIDF as a field
#     2022-Jun-07: add cache variable _1_AZI, _COS??_??_INCL, _COS_??_INCL_AZI, _COS??_??_INCL_AZI
#     2022-Jun-07: remove cache variable _cos_??_azi_raa, _vol_scatter
#     2022-Jun-09: add new field: APAR_CAR, RADIATION, WLSET
#     2022-Jun-13: use Union instead of Abstract... for type definition
#     2022-Jun-15: rename to HyperspectralMLCanopyOpticalProperty and HyperspectralMLCanopyRadiationProfile
#     2022-Jun-16: remove some cache variables
#     2022-Jul-22: remove field APAR_CAR
#
#######################################################################################################################################################################################################
"""

$(TYPEDEF)

Structure to save multiple layer hyperspectral canopy parameters

# Fields

$(TYPEDFIELDS)

"""
Base.@kwdef mutable struct HyperspectralMLCanopy{FT<:AbstractFloat} <: AbstractCanopy{FT}
    # Dimensions
    "Dimension of azimuth angles"
    DIM_AZI::Int = 36
    "Dimension of inclination angles"
    DIM_INCL::Int = 9
    "Dimension of canopy layers"
    DIM_LAYER::Int = 20

    # General model information
    "Hot spot parameter"
    HOT_SPOT::FT = 0.05

    # Embedded structures
    "Leaf inclination angle distribution function algorithm"
    LIDF::Union{VerhoefLIDF{FT}} = VerhoefLIDF{FT}()
    "Canopy optical properties"
    OPTICS::HyperspectralMLCanopyOpticalProperty{FT} = HyperspectralMLCanopyOpticalProperty{FT}()
    "Canopy radiation profiles"
    RADIATION::HyperspectralMLCanopyRadiationProfile{FT} = HyperspectralMLCanopyRadiationProfile{FT}()
    "Wave length set used to paramertize other variables"
    WLSET::WaveLengthSet{FT} = WaveLengthSet{FT}()

    # Geometry information
    "Inclination angle distribution"
    P_INCL::Vector{FT} = ones(FT, DIM_INCL) ./ DIM_INCL
    "Mean azimuth angles `[??]`"
    ??_AZI::Vector{FT} = collect(FT, range(0, 360; length=DIM_AZI+1))[1:end-1] .+ 360 / DIM_AZI / 2
    "Bounds of inclination angles `[??]`"
    ??_INCL_BNDS::Matrix{FT} = FT[ collect(FT, range(0, 90; length=DIM_INCL+1))[1:end-1] collect(FT, range(0, 90; length=DIM_INCL+1))[2:end] ]
    "Mean inclination angles `[??]`"
    ??_INCL::Vector{FT} = [ (??_INCL_BNDS[_i,1] + ??_INCL_BNDS[_i,2]) / 2 for _i in 1:DIM_INCL ]
    "Clumping structure a"
    ??_A::FT = 1
    "Clumping structure b"
    ??_B::FT = 0

    # Prognostic variables
    "Clumping index"
    ci::FT = 1
    "Leaf area index"
    lai::FT = 3

    # Cache variables
    "Ones with the length of ??_AZI"
    _1_AZI::Vector{FT} = ones(FT, DIM_AZI)
    "Cosine of ??_AZI"
    _COS_??_AZI::Vector{FT} = cosd.(??_AZI)
    "Square of cosine of ??_INCL"
    _COS??_??_INCL::Vector{FT} = cosd.(??_INCL) .^ 2
    "Square of cosine of ??_INCL at different azimuth angles"
    _COS??_??_INCL_AZI::Matrix{FT} = (cosd.(??_INCL) .^ 2) * _1_AZI'
    "Cache for level boundary locations"
    _x_bnds::Vector{FT} = collect(FT, range(0, -1; length=DIM_LAYER+1))
end
