-- IMPORT MODULES

import XMonad
import XMonad.Util.EZConfig
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.ThreeColumns
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.Spacing
import XMonad.Util.Run
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Renamed
import XMonad.Util.SpawnOnce
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageHelpers
import System.IO

main :: IO ()
main = xmonad 
	. ewmh 
	. ewmhFullscreen
	. docks
	. withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
	$ myConfig 

-- MAIN CONFIGURATION
-- Have fun !

myConfig = def
	{ modMask = mod1Mask -- defines the modkey as Alt
	, layoutHook = myLayout -- custom layouts
	, manageHook = myManageHook -- manage specific windows
	, startupHook = myStartupHook -- autostart programmes of your choice
	}
	`additionalKeysP` myKeys -- configure keybindings/shortcuts with ezconfig

-- XMOBAR CONFIGURATION
myXmobarPP :: PP
myXmobarPP = def
    { ppCurrent = wrap " " "" . xmobarBorder "Top" "#ffffff" 2
    , ppHidden = white . wrap " " ""
    , ppHiddenNoWindows = grey . wrap " " ""
    , ppTitle = const ""  -- This removes window title
    , ppLayout = const ""  -- This removes layout text
    }
  where

-- COLORS
    white = xmobarColor "#ffffff" ""
    grey  = xmobarColor "#888888" ""
 
-- DEFINE KEYBINDINGS
myKeys :: [(String, X ())]
myKeys =
	[("M-<Return>", spawn "kitty") -- launch the kitty terminal
	,("M-z", spawn "brave-browser-stable") -- launch the brave-browser
	,("M-S-u", spawn "pactl set-sink-volume @DEFAULT_SINK@ +2%") -- make the volume go (u)p
	,("M-S-d", spawn "pactl set-sink-volume @DEFAULT_SINK@ -2%") -- make volume go (d)own 
	,("M-S-m", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle") -- toggle mute 
        ,("M-S-l", spawn "lux -s 15%") -- make the brightness (l)ower
        ,("M-S-h", spawn "lux -a 15%") -- make the brightness (h)igher
	,("M-x", spawn "i3lock") -- lock the screen
	,("M-r", spawn "rofi -show drun") -- launch rofi without dmenu
	,("<Print>", spawn "scrot") -- take a fullscreen screenshot
	,("M-<Print>", spawn "scrot -s") -- take a screenshot from a specific area
	]

-- MANAGE HOOK
myManageHook :: ManageHook
myManageHook = composeAll
	[ isDialog --> doFloat -- makes dialog boxes float
	, isFullscreen --> doFullFloat
	]

-- CUSTOM LAYOUTS, ADDING GAPS, SPACING, ETC...
myLayout = renamed [Replace ""] 
	$ smartBorders -- This removes borders when window is fullscreen 
	$ spacing 8 
	$ tiled ||| Mirror tiled ||| Full ||| threeCol
	where
	 tiled	= Tall 1 (3/100) (1/2) -- tall layout 
	 threeCol = ThreeColMid 1 (3/100) (1/2) -- three column layout

-- AUTOSTART
myStartupHook = do
	spawn "nm-applet"
	spawn "xwallpaper --zoom ~/Pictures/wallpapers/Bentheim.jpg"
