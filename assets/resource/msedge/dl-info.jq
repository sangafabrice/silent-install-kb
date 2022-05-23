.[0].Releases |
map(select(.Platform=="Windows" and .Architecture=="x64")) |
.[] |
{
    "Version": .ProductVersion,
    "Link": .Artifacts[0].Location
}