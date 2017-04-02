module TrelloCard exposing (..)

import Json.Decode exposing (map2, field, int, string, Decoder, decodeString, list)
import List exposing (head, tail, filter, map, length)


type alias TrelloCard =
    { name : String
    , boardId : String
}

cardDecoder : Decoder TrelloCard
cardDecoder =
    map2 TrelloCard (field "name" string) (field "idBoard" string)
