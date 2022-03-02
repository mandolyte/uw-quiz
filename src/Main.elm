module Main exposing (..)

{-| -}

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Html exposing (..)

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

type AnswerId = AnswerId String
type QuestionId = QuestionId String

type alias Answer =
    { id : AnswerId
    , description : String
    }

type alias Question =
    { id: QuestionId
    , description: String
    , selectedAnswer: AnswerId
    , correctAnswer: AnswerId
    , answers: List Answer
    }

type alias Model =
    { title: String
    , currentQuestion: QuestionId
    , questions: List Question
    }

init : Model
init = 
    Model "This the title for the quiz" "q1"
    [ Question "q1" "This is question 1?" "" "a1"
        [ Answer "a1" "This is answer 1."
        , Answer "a2" "This is answer 2."
        , Answer "a3" "All of above."
        , Answer "a4" "None of above."
        ]
    , Question "q2" "This is question 2?" "" "a8"
        [ Answer "a5" "This is answer 1."
        , Answer "a6" "This is answer 2."
        , Answer "a7" "All of above."
        , Answer "a8" "None of above."
        ]
    ]

type Msg
    = Update Model


update msg _ =
    case Debug.log "msg" msg of
        Update new ->
            new


makeInput : Answer -> Input.Option String Msg
makeInput answer = Input.option answer.id (Element.text answer.description)

isCurrentQuestion question = if question.id == model.currentQuestion then True else False

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
                (Element.text model.title)
            , viewQuestion List.filter isCurrentQuestion model.questions -- how do I specify which question to show
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

viewQuestion : Question -> Element Msg
viewQuestion question = 
    Input.radio
        [ spacing 12
        , padding 10
        , Background.color grey
        ]
        { selected = Just question.selectedAnswer
        , onChange = \new -> Update { question | selectedAnswer = new }
        , label = Input.labelAbove [ Font.size 20, paddingXY 0 12 ] (Element.text question.description)
        , options = List.map makeInput question.answers 
        }
        