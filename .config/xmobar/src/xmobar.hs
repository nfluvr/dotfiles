import Xmobar

config :: Config
config =
    defaultConfig
        { font = "MesloLGS Nerd Font 12"
        , additionalFonts = ["Noto Color Emoji 10"]
        , textOffsets = [-1]
        , allDesktops = True
        , bgColor = "#000000"
        , fgColor = "#bababa"
        , position = TopH 26
        , commands =
            [ Run XMonadLog
            , Run $ Cpu
                [ "-t", "CPU: <total>%"
                ] 10
            , Run $ Memory 
                [ "-t", "Mem: <used>G"
                , "-d", "1"
                , "--"
                , "--scale", "1024"
                ] 10
            , Run $ DiskU [("/", "SSD: <used>/<size>"), ("sda3", "<usedbar>")]
                [ "-L", "20"
                , "-H", "50"
                , "-m", "1"
                , "-p", "3"
                ] 10
            , Run $ Kbd
                [ ("us", "<fn=1>\x1F1FA\x1F1F8</fn>")
                , ("ru", "ru")
                , ("ua", "<fn=1>\x1f1fa\x1f1e6</fn>")
                ]
            , Run $ Date "%a %_d %b, %H:%M" "date" 10
            , Run $ XPropertyLog "_XMONAD_TRAYPAD"
            ]
        , template = " %XMonadLog% | %cpu% | %memory% | %disku% }%date%{ %kbd% %_XMONAD_TRAYPAD%"
        , alignSep = "}{"
        }

main :: IO ()
main = xmobar config
