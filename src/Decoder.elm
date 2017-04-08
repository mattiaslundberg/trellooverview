module Decoder exposing (..)

import Json.Decode exposing (map4, map2, field, int, string, Decoder, decodeString, list)


boardDecoder : Decoder TrelloBoard
boardDecoder =
    map2 (TrelloBoard False [] "") (field "id" string) (field "name" string)


decodeBoards : String -> List TrelloBoard
decodeBoards payload =
    case decodeString (list boardDecoder) payload of
        Ok val ->
            val

        Err message ->
            Debug.log message
                []


decodeLists : List TrelloBoard -> String -> List TrelloBoard
decodeLists boards payload =
    case decodeString (list listDecoder) payload of
        Ok lists ->
            map (updateLists lists) boards

        Err message ->
            Debug.log message
                boards


decodeCards : List TrelloBoard -> String -> List TrelloBoard
decodeCards boards payload =
    case decodeString (list cardDecoder) payload of
        Ok cards ->
            map (updateBoardWithCard cards) boards

        Err message ->
            Debug.log message
                boards


cardDecoder : Decoder TrelloCard
cardDecoder =
    map4 TrelloCard (field "id" string) (field "name" string) (field "idList" string) (field "idBoard" string)
