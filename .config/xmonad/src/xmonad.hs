import XMonad 
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig
import XMonad.Util.Hacks
import XMonad.Util.SpawnOnce
import Data.Semigroup (All)

main :: IO ()
main = xmonad
  . ewmhFullscreen
  . ewmh
  . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
  $ myConfig

myModMask :: KeyMask
myModMask = mod4Mask -- win

myTerminal :: String
myTerminal = "kitty"

myBrowser :: String
myBrowser = "firefox"

myAppLauncher :: String
myAppLauncher = "rofi -show run"

myConfig = def
  { modMask = myModMask
  , terminal = myTerminal
  , focusedBorderColor = "#eee"
  , startupHook = myStartupHook
  , layoutHook = avoidStruts $ smartBorders $ layoutHook def
  , handleEventHook = myEventHook
  , normalBorderColor = "#333" 
  , focusFollowsMouse = True
  , clickJustFocuses = True
  }
  `additionalKeysP`
    [ ("M-S-r", spawn "xmonad --recompile; killall xmobar; xmonad --restart")
    , ("M-S-b" , spawn myBrowser)
    , ("M-p" , spawn myAppLauncher)
    , ("M-S-s" , spawn "maim -s | xclip -selection clipboard -t image/png -i")
    , ("<XF86MonBrightnessUp>", spawn "lux -a 5%")    
    , ("<XF86MonBrightnessDown>", spawn "lux -s 5%")
    , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ && volnoti-show $(amixer get Master | grep -Po \"[0-9]+(?=%)\" | tail -1)")
    , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- && volnoti-show $(amixer get Master | grep -Po \"[0-9]+(?=%)\" | tail -1)")
    , ("<XF86AudioMute>", spawn "amixer set Master toggle; if amixer get Master | grep -Fq \"[off]\"; then volnoti-show -m; else volnoti-show $(amixer get Master | grep -Po \"[0-9]+(?=%)\" | tail -1); fi")
    ]

myXmobarPP :: PP
myXmobarPP = def
    { ppOrder = \(ws:_) -> [ws]
    , ppSep = " | "
    , ppCurrent = wrap "" "" . xmobarBorder "Bottom" "yellow" 2 . xmobarColor "#aaa" ""
    }

myStartupHook :: X ()
myStartupHook = do
  spawnOnce "feh --bg-scale $HOME/wallpaper.png"
--  spawnOnce "xcape -t 300 -e 'Control_L=Escape'"
  spawnOnce "nm-applet --indicator &"
  spawnOnce "volnoti -t 1"
  spawnOnce "lxqt-powermanagement &"
  spawnOnce "picom &"
  spawn "$HOME/.config/xmobar/scripts/trayer-run.sh"
  setWMName "LG3D"

myEventHook :: Event -> X All
myEventHook = trayerAboveXmobarEventHook <> trayerPaddingXmobarEventHook
