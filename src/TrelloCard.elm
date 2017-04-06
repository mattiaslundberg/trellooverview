module TrelloCard exposing (..)

import Json.Decode exposing (map, field, int, string, Decoder, decodeString, list)
import List exposing (head, tail, filter, length)


type alias TrelloCard =
    { time : Int
    , name : String
    }


cardDecoder : Decoder TrelloCard
cardDecoder =
    map (TrelloCard 0) (field "name" string)
