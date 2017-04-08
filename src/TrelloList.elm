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


listIsDone : String -> Bool
listIsDone list =
    case List.head (find (AtMost 1) (regex ".*Done.*") list) of
        Just val ->
            True

        Nothing ->
            False


summarizeCards : List TrelloCard -> Float
summarizeCards cards =
    cards
        |> List.map getTimeFromCard
        |> List.sum


getTimeFromList : Bool -> Bool -> TrelloList -> Float
getTimeFromList includeDone includeNotDone list =
    case listIsDone list.name of
        True ->
            if includeDone then
                summarizeCards list.cards
            else
                0

        False ->
            if includeNotDone then
                summarizeCards list.cards
            else
                0
