module TrelloBoard exposing (..)

import Json.Decode exposing (map2, field, int, string, Decoder, decodeString, list)
import List exposing (head, tail, filter, map, length, append)
import TrelloCard exposing (..)


-- MODEL


type alias TrelloBoard =
    { show : Bool
    , cards : List TrelloCard
    , id : String
    , name :
        String
    }


cardCount : TrelloBoard -> Int
cardCount board =
  length board.cards


toogleVisibilityIfMatch : TrelloBoard -> TrelloBoard -> TrelloBoard
toogleVisibilityIfMatch a b =
    if a.id == b.id then
        { b | show = not b.show }
    else
        b


toogleBoard : TrelloBoard -> List TrelloBoard -> List TrelloBoard
toogleBoard board boards =
    map (toogleVisibilityIfMatch board) boards


boardDecoder : Decoder TrelloBoard
boardDecoder =
    map2 (TrelloBoard True []) (field "id" string) (field "name" string)


decodeBoards : String -> List TrelloBoard
decodeBoards payload =
    case decodeString (list boardDecoder) payload of
        Ok val ->
            val

        Err message ->
          Debug.log message
            []


updateCards : (List TrelloCard) -> TrelloBoard -> TrelloBoard
updateCards cards board =
  { board | cards = filter (\c -> c.boardId == board.id) (append board.cards cards) }


decodeCards : List TrelloBoard -> String -> List TrelloBoard
decodeCards boards payload =
    case decodeString (list cardDecoder) payload of
      Ok cards ->
        map (updateCards cards) boards

      Err message ->
        Debug.log message
        boards