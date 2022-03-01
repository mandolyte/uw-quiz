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
    Element.rgb255 6 176 242


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
    { answers = A1
    }


type alias Form =
    { answers : Answers
    }


type Msg
    = Update Form


update msg _ =
    case Debug.log "msg" msg of
        Update new ->
            new


type Answers
    = A1
    | A2
    | A3
    | A4


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
                { selected = Just model.answers
                , onChange = \new -> Update { model | answers = new }
                , label = Input.labelAbove [ Font.size 20, paddingXY 0 12 ] (text "This is the quiz question? Please select one:")
                , options =
                    [ Input.option A1 (text "This is the first answer")
                    , Input.option A2 (text "This is the second answer")
                    , Input.option A3 (text "All of the above")
                    , Input.option A4 (text "None of the above")
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
