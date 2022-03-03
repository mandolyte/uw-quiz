-- Goal update question 2 with a7

import List.Extra exposing (..)

type AnswerId = AnswerId String


type QuestionId = QuestionId String


answerIdAsString : AnswerId -> String
answerIdAsString (AnswerId idString) = idString


questionIdAsString : QuestionId -> String
questionIdAsString (QuestionId idString) = idString


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

myModel = 
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

-- let
--     result = 
--         find (\q -> q.id == QuestionId "q2") myModel.questions
-- in
--     case result of
        
--         Just q -> 
--             q.selectedAnswer = AnswerId "a7"
        
--         Nothing -> 
--             { answers = []
--             , correctAnswer = AnswerId ""
--             , description = ""
--             , id = QuestionId ""
--             , selectedAnswer : AnswerId ""
--             }

-- updateIf : (a -> Bool) -> (a -> a) -> List a -> List a

-- result = find (\q -> q.id == QuestionId "q2") myModel.questions

-- result.selectedAnswer = AnswerId "a7"

-- result

finder = find (\q -> q.id == QuestionId "q2") myModel.questions

result = 
    updateIf 
        (\q -> q.id == QuestionId "q2") 
        (\q -> 
            { answers = q.answers
            , correctAnswer = q.correctAnswer
            , description = q.description
            , id = q.id
            , selectedAnswer = AnswerId "a7"
            }
        )
        myModel.questions

result

newModel = { myModel | questions = result }


[1,2,3,4]


newModel
