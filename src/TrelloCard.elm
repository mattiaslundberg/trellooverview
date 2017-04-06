module TrelloCard exposing (..)

import Json.Decode exposing (map4, field, int, string, Decoder, decodeString, list)
import List exposing (head, tail, filter, length)


type alias TrelloCard =
    { time : Int
    , id : String
    , name : String
    , listId : String
    , boardId : String
    }


cardDecoder : Decoder TrelloCard
cardDecoder =
    map4 (TrelloCard 0) (field "id" string) (field "name" string) (field "idList" string) (field "idBoard" string)
