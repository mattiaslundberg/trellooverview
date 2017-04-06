module TrelloCard exposing (..)

import Json.Decode exposing (map3, field, int, string, Decoder, decodeString, list)
import List exposing (head, tail, filter, length)


type alias TrelloCard =
    { time : Int
    , name : String
    , listId : String
    , boardId : String
    }


cardDecoder : Decoder TrelloCard
cardDecoder =
    map3 (TrelloCard 0) (field "name" string) (field "idList" string) (field "idBoard" string)
