ads_servers_escape_menu = ads_servers_escape_menu or {}

----- CONFIGURATION BEGIN -----
	-- Main settings:
	local YourOwnBanner = true
	local Banners = {
		{
			banner="https://puu.sh/quBxW.gif",
			server="555.555.555.555:27015",
			title="l'Université Jean Potage",
		},
	}
	-- Language:
	local TitleMessage = "Connexion à un autre serveur"
	local ConfirmMessage = "Êtes-vous sûr de vouloir vous déconnecter et rejoindre %s ?"
	local Yes = "Oui"
	local Cancel = "Annuler"
	-- Custom Escape menu:
	local function CustomEscapeVisible()
		return IsValid( CustomUI ) and CustomUI:IsVisible()
	end
----- CONFIGURATION END -----

if IsValid( ads_servers_escape_menu.ads ) then
	ads_servers_escape_menu.ads:Remove()
	ads_servers_escape_menu.ads = nil
end

local ads
local function LoadAds()
	ads_servers_escape_menu.ads = vgui.Create( "DHTML" )
	ads = ads_servers_escape_menu.ads
	local h = ( 136*( #Banners + ( YourOwnBanner and 1 or 0 ) ) )-8
	ads:SetSize( 512,h )
	ads:SetPos( ScrW()-512-8,ScrH()-50-8-h )
	local html = {}
	table.insert( html, [[
<html>
<head>
	<style>
		body {
			overflow: hidden;
			margin: 0px;
		}
		img {
			width: 512px;
			height: 128px;
			cursor: pointer;
		}
		img.newad {
			cursor: auto;
		}
		table {
			margin: -8px 0px;
			border-spacing: 0px 8px;
		}
		td {
			padding: 0px;
		}
	</style>
</head>
<body>
<table>]] )
	ads:AddFunction( "game", "connect", function( address, title )
		local ConfirmMessage = string.format( ConfirmMessage, title )
		Derma_Query( ConfirmMessage, TitleMessage, Yes, function()
			local ply = LocalPlayer()
			if IsValid( ply ) then
				ply:ConCommand( 'connect '..address..'\n' )
			else
				RunConsoleCommand( "connect", address ) -- can fail
			end
		end, Cancel, nil )
	end )
	for _,banner in ipairs( Banners ) do
		table.insert( html, [[<tr><td><img src="]]..banner.banner..[[" onclick="game.connect( ']]..banner.server..[[', ']]..string.Replace( banner.title, "'", "\\'" )..[[' );"/></td></tr>]] )
	end
	if YourOwnBanner then
		table.insert( html, [[<tr><td><img class="newad" src="data:image/png;base64,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"/></td></tr>]] )
	end
	table.insert( html, [[
</table>
</body>
</html>]] )
	html = table.concat( html )
	ads:SetHTML( html )
	ads:MakePopup()
end

local function EscapeMenuVisible()
	if gui.IsGameUIVisible() then
		return true, false
	elseif CustomEscapeVisible() then
		return true, true
	else
		return false, false
	end
end

local WasVisib, WasAlter = false, false
local EscVisib, EscAlter
hook.Add( "PreRender", "ads_servers_escape_menu", function()
	EscVisib, EscAlter = EscapeMenuVisible()
	if EscVisib then
		if LoadAds and not IsValid( ads ) then
			LoadAds()
			LoadAds = nil -- free memory
		end
		ads:SetVisible( true )
		if EscAlter then
			ads:MoveToFront()
		end
		WasVisib = true
		WasAlter = EscAlter
	elseif IsValid( ads ) then
		ads:SetVisible( false )
		WasVisib, WasAlter = false, false
	end
end )
