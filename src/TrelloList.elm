module TrelloList exposing (..)

import Regex exposing (..)
import TrelloCard exposing (..)
import Json.Decode exposing (map3, field, int, string, Decoder, decodeString, list)
import List exposing (head, tail, filter, map, length)
import Models exposing (..)



listDecoder : Decoder TrelloList
listDecoder =
    map3 (TrelloList []) (field "name" string) (field "id" string) (field "idBoard" string)


listMatches : String -> String -> Bool
listMatches list re =
    case List.head (find (AtMost 1) (regex re) list) of
        Just val ->
            True

        Nothing ->
            False



-- This should be a user-configurable expression


doneRe : String
doneRe =
    "Done.*"


listIsDone : String -> Bool
listIsDone list =
    listMatches list doneRe


listIsRemaining : String -> String -> Bool
listIsRemaining inProgressRe list =
    listMatches list inProgressRe


summarizeCards : List TrelloCard -> Float
summarizeCards cards =
    cards
        |> List.map getTimeFromCard
        |> List.sum


getTimeFromList : String -> Bool -> Bool -> TrelloList -> Float
getTimeFromList inProgressRe includeDone includeNotDone list =
    let
        doneCount =
            if includeDone && (listIsDone list.name) then
                (summarizeCards list.cards)
            else
                0

        remainingCount =
            if includeNotDone && (listIsRemaining inProgressRe list.name) then
                (summarizeCards list.cards)
            else
                0
    in
        doneCount + remainingCount
