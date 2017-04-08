module TrelloBoard exposing (..)

import Json.Decode exposing (map2, field, int, string, Decoder, decodeString, list)
import List exposing (head, tail, filter, map, length, append, sum)
import List.Extra exposing (uniqueBy)
import TrelloList exposing (..)
import TrelloCard exposing (..)


-- MODEL


type alias TrelloBoard =
    { show : Bool
    , lists : List TrelloList
    , id : String
    , name :
        String
    }


listCount : TrelloBoard -> Int
listCount board =
    length board.lists


cardCount : TrelloBoard -> Int
cardCount board =
    let
        cards =
            (map (\l -> (length l.cards)) board.lists)
    in
        sum cards


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
    map2 (TrelloBoard False []) (field "id" string) (field "name" string)


decodeBoards : String -> List TrelloBoard
decodeBoards payload =
    case decodeString (list boardDecoder) payload of
        Ok val ->
            val

        Err message ->
            Debug.log message
                []


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


updateCards : List TrelloCard -> TrelloList -> TrelloList
updateCards cards list =
    let
        cardsWithDuplicates =
            filter (\c -> c.listId == list.id) (append list.cards cards)

        allCards =
            uniqueBy (\c -> c.id) cardsWithDuplicates
    in
        { list | cards = allCards }


updateListsWithCard : List TrelloCard -> List TrelloList -> List TrelloList
updateListsWithCard cards lists =
    map (updateCards cards) lists


updateBoardWithCard : List TrelloCard -> TrelloBoard -> TrelloBoard
updateBoardWithCard cards board =
    { board | lists = map (updateCards cards) board.lists }


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


getBoardTimeSummary : TrelloBoard -> Bool -> Bool -> Float
getBoardTimeSummary board includeDone includeNotDone =
    board.lists
        |> List.map (getTimeFromList includeDone includeNotDone)
        |> List.sum


getBoardsToShow : List TrelloBoard -> List TrelloBoard
getBoardsToShow boards =
    List.filter .show boards


getBoardTimeSummaryDisplay : TrelloBoard -> String
getBoardTimeSummaryDisplay board =
    let
        timeDone =
            getBoardTimeSummary board True False

        timeRemaining =
            getBoardTimeSummary board False True

        percentage =
            100 * (timeRemaining / (timeDone + timeRemaining))
    in
        "Done: "
            ++ (toString timeDone)
            ++ " "
            ++ "Remaining: "
            ++ (toString timeRemaining)
            ++ " "
            ++ "Percentage done: "
            ++ (toString percentage)
            ++ "%"
