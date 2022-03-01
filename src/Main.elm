module Main exposing (..)

{-| -}

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region


white =
    Element.rgb 1 1 1


grey =
    Element.rgb 0.9 0.9 0.9


blue =
    Element.rgb 0 0 0.8


red =
    Element.rgb 0.8 0 0


darkBlue =
    Element.rgb 0 0 0.9


main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


init =
    { username = ""
    , password = ""
    , agreeTOS = False
    , comment = "Extra hot sauce?\n\n\nYes pls"
    , lunch = Gyro
    , spiciness = 2
    }


type alias Form =
    { username : String
    , password : String
    , agreeTOS : Bool
    , comment : String
    , lunch : Lunch
    , spiciness : Float
    }


type Msg
    = Update Form


update msg _ =
    case Debug.log "msg" msg of
        Update new ->
            new


type Lunch
    = Burrito
    | Taco
    | Gyro


view model =
    Element.layout
        [ Font.size 20
        ]
    <|
        Element.column
            [ width (px 800)
            , height shrink
            , centerY
            , centerX
            , spacing 36
            , padding 10
            ]
            [ el
                [ Region.heading 1
                , alignLeft
                , Font.size 36
                ]
                (text "This the title for the quiz")
            , Input.radio
                [ spacing 12
                , padding 10
                , Background.color grey
                ]
                { selected = Just model.lunch
                , onChange = \new -> Update { model | lunch = new }
                , label = Input.labelAbove [ Font.size 20, paddingXY 0 12 ] (text "This is the quiz question? Please select one:")
                , options =
                    [ Input.option Gyro (text "This is the first answer")
                    , Input.option Burrito (text "This is the second answer")
                    , Input.option Taco (text "All of the above")
                    , Input.option Taco (text "None of the above")
                    ]
                }
            , Input.button
                [ Background.color blue
                , Font.color white
                , Border.color darkBlue
                , paddingXY 32 16
                , Border.rounded 3

                -- , width fill
                ]
                { onPress = Nothing
                , label = Element.text "Continue"
                }
            ]
