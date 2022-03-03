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


type AnswerId
    = AnswerId String


type QuestionId
    = QuestionId String


answerIdAsString : AnswerId -> String
answerIdAsString (AnswerId idString) =
    idString


questionIdAsString : QuestionId -> String
questionIdAsString (QuestionId idString) =
    idString


type alias Answer =
    { id : AnswerId
    , description : String
    }


type alias Question =
    { id : QuestionId
    , description : String
    , selectedAnswer : AnswerId
    , correctAnswer : AnswerId
    , answers : List Answer
    }


type alias Model =
    { title : String
    , currentQuestion : QuestionId
    , questions : List Question
    , scratch : String
    }


init : Model
init =
    Model "This the title for the quiz"
        (QuestionId "q1")
        [ Question (QuestionId "q1")
            "This is question 1?"
            (AnswerId "")
            (AnswerId "a1")
            [ Answer (AnswerId "a1") "This is answer 1."
            , Answer (AnswerId "a2") "This is answer 2."
            , Answer (AnswerId "a3") "All of above."
            , Answer (AnswerId "a4") "None of above."
            ]
        , Question (QuestionId "q2")
            "This is question 2?"
            (AnswerId "")
            (AnswerId "a8")
            [ Answer (AnswerId "a5") "This is q2, answer 1."
            , Answer (AnswerId "a6") "This is q2, answer 2."
            , Answer (AnswerId "a7") "All of above."
            , Answer (AnswerId "a8") "None of above."
            ]
        ]
        ""


nextEntry : Model -> Model
nextEntry model =
    if model.currentQuestion == QuestionId "q2" then
        { model | currentQuestion = QuestionId "q1" }

    else
        { model | currentQuestion = QuestionId "q2" }


type Msg
    = Update QuestionId AnswerId
    | NextEntry


update : Msg -> Model -> Model
update msg model =
    case Debug.log "msg" msg of
        Update (QuestionId newq) (AnswerId newa) ->
            let
                result = 
                    updateIf 
                        (\q -> q.id == QuestionId newq) 
                        (\q -> 
                            { answers = q.answers
                            , correctAnswer = q.correctAnswer
                            , description = q.description
                            , id = q.id
                            , selectedAnswer = AnswerId newa
                            }
                        )
                        model.questions
            in
                Debug.log "let" { model | questions = result, scratch = newa }
                

        NextEntry ->
            model |> nextEntry


makeInput : Answer -> Input.Option String Msg
makeInput answer =
    Input.option (answerIdAsString answer.id) (Element.text answer.description)

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
            , padding 10
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

        justCurQuestion =
            case curQuestion of
                Just x ->
                    x

                Nothing ->
                    { answers = []
                    , correctAnswer = AnswerId "a0"
                    , description = "String"
                    , id = QuestionId "q0"
                    , selectedAnswer = AnswerId "a0"
                    }


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
        , onChange = \new -> Update (model.currentQuestion) (AnswerId new)
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