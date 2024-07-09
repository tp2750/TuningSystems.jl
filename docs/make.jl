cd(@__DIR__)
using Pkg
Pkg.activate("."); Pkg.instantiate()
using TuningSystems
using Documenter
using Literate

DocMeta.setdocmeta!(TuningSystems, :DocTestSetup, :(using TuningSystems); recursive=true)

Literate.markdown("./src/tutorial.jl", "./src")

makedocs(;
    modules=[TuningSystems],
    authors="Thomas Poulsen <ta.poulsen@gmail.com> and contributors",
    sitename="TuningSystems.jl",
    format=Documenter.HTML(;
        canonical="https://tp2750.github.io/TuningSystems.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
#        "Home" => "index.md",
        "Tutorial" => "tutorial.md",
#        "API" => "api.md",
    ],
)

deploydocs(;
    repo="github.com/tp2750/TuningSystems.jl",
    devbranch="main",
)
