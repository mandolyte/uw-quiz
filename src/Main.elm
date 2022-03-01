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

type alias Answer =
    { id : String
    , text : String
    }

type alias Model =
  { title: String
  , currentAnswer: String
  , answers: List Answer
  , question: String
  }

init : Model
init = 
    Model "This the title for the quiz" "" 
        [ Answer "A1" "This is the first answer"
        , Answer "A2" "This is the second answer"
        , Answer "A3" "All of the above"
        , Answer "A4" "None of the above"
        ]
        "This is a question?"

type Msg
    = Update Model


update msg _ =
    case Debug.log "msg" msg of
        Update new ->
            new


makeInput : Answer -> Input.Option String Msg
makeInput answer = Input.option answer.id (Element.text answer.text)

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
                (text model.title)
            , Input.radio
                [ spacing 12
                , padding 10
                , Background.color grey
                ]
                { selected = Just model.currentAnswer
                , onChange = \new -> Update { model | currentAnswer = new }
                , label = Input.labelAbove [ Font.size 20, paddingXY 0 12 ] (text model.question)
                , options = List.map makeInput model.answers 
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
