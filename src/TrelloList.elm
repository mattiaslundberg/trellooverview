module TrelloList exposing (..)

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


getTimeFromList : TrelloList -> Float
getTimeFromList list =
    List.sum (List.map getTimeFromCard list.cards)
