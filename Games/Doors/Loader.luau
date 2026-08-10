local BaseUrl = (getgenv().AbysallBaseUrl or "https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/"):gsub("/?$", "/")
if game.PlaceId ~= 6516141723 then
    loadstring(game:HttpGet(BaseUrl .. "Games/Doors/Main.luau"))()
else
    loadstring(game:HttpGet(BaseUrl .. "Games/Doors/Lobby.luau"))()
end
