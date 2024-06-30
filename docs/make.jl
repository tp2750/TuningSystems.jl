using TuningSystems
using Documenter

DocMeta.setdocmeta!(TuningSystems, :DocTestSetup, :(using TuningSystems); recursive=true)

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
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/tp2750/TuningSystems.jl",
    devbranch="main",
)
