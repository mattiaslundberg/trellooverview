module TrelloList exposing (..)

import TrelloCard exposing (..)
import Json.Decode exposing (map2, field, int, string, Decoder, decodeString, list)
import List exposing (head, tail, filter, map, length)


type alias TrelloList =
    { cards: List TrelloCard
        ,name : String
    , boardId : String
    }


listDecoder : Decoder TrelloList
listDecoder =
    map2 (TrelloList []) (field "name" string) (field "idBoard" string)
