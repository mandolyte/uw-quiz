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
import List.Extra exposing (getAt, updateIf)


white : Color
white =
    Element.rgb 1 1 1

grey : Color
grey =
    Element.rgb 0.9 0.9 0.9

blue : Color
blue =
    Element.rgb255 6 176 242

red : Color
red =
    Element.rgb 0.8 0 0

darkBlue : Color
darkBlue =
    Element.rgb 0 0 0.9


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type alias Answer =
    { id : String
    , description : String
    }


type alias Question =
    { id : String
    , description : String
    , selectedAnswer : String
    , correctAnswer : String
    , answers : List Answer
    }


type alias Model =
    { title : String
    , currentQuestion : String
    , questions : List Question
    , scratch : String
    }


init : Model
init =
    Model "Title of Quiz"
        "q1"
        [ Question "q1"
            "¿This is question 1?"
            ""
            "a1"
            [ Answer "a1" "This is answer 1."
            , Answer "a2" "This is answer 2."
            , Answer "a3" "All of above."
            , Answer "a4" "None of above."
            ]
        , Question "q2"
            "¿This is question 2?"
            ""
            "a8"
            [ Answer "a5" "This is q2, answer 1."
            , Answer "a6" "This is q2, answer 2."
            , Answer "a7" "All of above."
            , Answer "a8" "None of above."
            ]
        ]
        ""


nextEntry : Model -> Model
nextEntry model =
    if model.currentQuestion == "q2" then
        { model | currentQuestion = "q1" }

    else
        { model | currentQuestion = "q2" }


type Msg
    = Update String String
    | NextEntry


update : Msg -> Model -> Model
update msg model =
    case Debug.log "msg" msg of
        Update newq newa ->
            let
                result = 
                    updateIf 
                        (\q -> q.id == newq) 
                        (\q -> 
                            { answers = q.answers
                            , correctAnswer = q.correctAnswer
                            , description = q.description
                            , id = q.id
                            , selectedAnswer = newa
                            }
                        )
                        model.questions
            in
                Debug.log "let" { model | questions = result, scratch = newa }
                

        NextEntry ->
            model |> nextEntry


makeInput : Answer -> Input.Option String Msg
makeInput answer =
    Input.option answer.id (Element.text answer.description)

view : Model -> Html Msg
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
            , padding 100
            ]
            [ el
                [ Region.heading 1
                , alignLeft
                , Font.size 36
                ]
                (Element.text model.title)
            , viewQuestion model
            , Input.button
                [ Background.color blue
                , Font.color white
                , Border.color darkBlue
                , paddingXY 32 16
                , Border.rounded 3

                -- , width fill
                ]
                { onPress = Just NextEntry
                , label = Element.text "Continue"
                }
            ]


viewQuestion : Model -> Element Msg
viewQuestion model =
    let
        curQuestionList =
            List.filter (\question -> question.id == model.currentQuestion) model.questions

        curQuestion =
            getAt 0 curQuestionList 

        curQuestionDescription =
            case curQuestion of
                Nothing ->
                    ""

                Just q ->
                    q.description

        curQuestionAnswers =
            case curQuestion of
                Nothing ->
                    []

                Just q ->
                    q.answers
    in
    Input.radio
        [ spacing 12
        , padding 10
        , Background.color grey
        ]
        { selected = Just model.scratch
        , onChange = \new -> Update (model.currentQuestion) new
        , label = Input.labelAbove [ Font.size 20, paddingXY 0 12 ] (Element.text curQuestionDescription)
        , options = List.map makeInput curQuestionAnswers
        }


{- Code Graveyard
        -- curQuestion2 = find (\q -> q.id == model.currentQuestion ) model.questions
        -- justCurQuestion =
        --     case curQuestion of
        --         Just x ->
        --             x

        --         Nothing ->
        --             { answers = []
        --             , correctAnswer = AnswerId "a0"
        --             , description = "String"
        --             , id = QuestionId "q0"
        --             , selectedAnswer = AnswerId "a0"
        --             }

        -- curQuestionIdAsString =
        --     case curQuestion of
        --         Nothing ->
        --             ""

        --         Just q ->
        --             questionIdAsString q.id



-}