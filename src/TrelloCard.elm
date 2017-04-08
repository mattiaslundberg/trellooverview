module TrelloCard exposing (..)

import List exposing (head, tail, filter, length)
import Regex exposing (..)
import String
import Models exposing (..)


findTime : String -> Maybe String
findTime s =
    case List.head (findTimeInString s) of
        Just val ->
            val

        Nothing ->
            Nothing


getTimeFromCard : TrelloCard -> Float
getTimeFromCard card =
    case findTime card.name of
        Just val ->
            case String.toFloat val of
                Ok v ->
                    v

                Err msg ->
                    0.0

        Nothing ->
            0.0


findTimeInString : String -> List (Maybe String)
findTimeInString s =
    case List.head (find (AtMost 1) (regex ".* \\(([\\d\\.\\,]+)\\)") s) of
        Just val ->
            val.submatches

        Nothing ->
            []
