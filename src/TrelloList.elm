module TrelloList exposing (..)

import Regex exposing (..)
import TrelloCard exposing (..)
import Json.Decode exposing (map3, field, int, string, Decoder, decodeString, list)
import List exposing (head, tail, filter, map, length)


type alias TrelloList =
    { cards : List TrelloCard
    , name : String
    , id : String
    , boardId : String
    }


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



-- This should be a user-configurable expression

remainingRe : String
remainingRe =
    "Version .*"


listIsRemaining : String -> Bool
listIsRemaining list =
    listMatches list remainingRe


summarizeCards : List TrelloCard -> Float
summarizeCards cards =
    cards
        |> List.map getTimeFromCard
        |> List.sum


getTimeFromList : Bool -> Bool -> TrelloList -> Float
getTimeFromList includeDone includeNotDone list =
    let
        doneCount =
            if includeDone && (listIsDone list.name) then
                (summarizeCards list.cards)
            else
                0

        remainingCount =
            if includeNotDone && (listIsRemaining list.name) then
                (summarizeCards list.cards)
            else
                0
    in
        doneCount + remainingCount
