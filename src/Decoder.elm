module Decoder exposing (..)

import Models exposing (..)
import List exposing (filter, append)
import List.Extra exposing (uniqueBy)
import Json.Decode exposing (..)


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


listDecoder : Decoder TrelloList
listDecoder =
    Json.Decode.map3 (TrelloList []) (field "name" string) (field "id" string) (field "idBoard" string)


updateLists : List TrelloList -> TrelloBoard -> TrelloBoard
updateLists lists board =
    let
        listsWithDuplicates =
            filter (\c -> c.boardId == board.id)
                (append board.lists
                    lists
                )

        allLists =
            uniqueBy (\l -> l.id) listsWithDuplicates
    in
        { board
            | lists = allLists
        }


decodeLists : List TrelloBoard -> String -> List TrelloBoard
decodeLists boards payload =
    case decodeString (list listDecoder) payload of
        Ok lists ->
            List.map (updateLists lists) boards

        Err message ->
            Debug.log message
                boards


updateCards : List TrelloCard -> TrelloList -> TrelloList
updateCards cards list =
    let
        cardsWithDuplicates =
            filter (\c -> c.listId == list.id) (append list.cards cards)

        allCards =
            uniqueBy (\c -> c.id) cardsWithDuplicates
    in
        { list | cards = allCards }


updateBoardWithCard : List TrelloCard -> TrelloBoard -> TrelloBoard
updateBoardWithCard cards board =
    { board | lists = List.map (updateCards cards) board.lists }


decodeCards : List TrelloBoard -> String -> List TrelloBoard
decodeCards boards payload =
    case decodeString (list cardDecoder) payload of
        Ok cards ->
            List.map (updateBoardWithCard cards) boards

        Err message ->
            Debug.log message
                boards


cardDecoder : Decoder TrelloCard
cardDecoder =
    map4 TrelloCard (field "id" string) (field "name" string) (field "idList" string) (field "idBoard" string)
