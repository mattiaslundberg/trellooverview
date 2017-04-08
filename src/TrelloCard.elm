module TrelloCard exposing (..)

import Json.Decode exposing (map4, field, int, string, Decoder, decodeString, list)
import List exposing (head, tail, filter, length)
import Regex exposing (..)
import String
import Models exposing (..)



cardDecoder : Decoder TrelloCard
cardDecoder =
    map4 TrelloCard (field "id" string) (field "name" string) (field "idList" string) (field "idBoard" string)


findTimeInString : String -> List (Maybe String)
findTimeInString s =
    case List.head (find (AtMost 1) (regex ".* \\(([\\d\\.\\,]+)\\)") s) of
        Just val ->
            val.submatches

        Nothing ->
            []


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
