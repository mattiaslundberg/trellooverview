module TrelloCard exposing (..)

import Json.Decode exposing (map4, field, int, string, Decoder, decodeString, list)
import List exposing (head, tail, filter, length)
import Regex exposing (..)

type alias TrelloCard =
    { id : String
    , name : String
    , listId : String
    , boardId : String
    }


cardDecoder : Decoder TrelloCard
cardDecoder =
    map4 TrelloCard (field "id" string) (field "name" string) (field "idList" string) (field "idBoard" string)


findTime : String -> Maybe String
findTime s =
    let
      matches = find (AtMost 1) (regex ".* \\((\\d)\\)") s
    in
      Debug.log (toString matches)
      Just "0"


getTimeFromCard : TrelloCard -> Int
getTimeFromCard card =
    let
        matches = findTime card.name
    in
        Debug.log (toString matches)
        0
