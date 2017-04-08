module TrelloBoard exposing (..)

import List exposing (head, tail, filter, map, length, append, sum)
import List.Extra exposing (uniqueBy)
import TrelloList exposing (..)
import TrelloCard exposing (..)
import Models exposing (..)


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


updateBoardWithProgressRe : String -> TrelloBoard -> TrelloBoard
updateBoardWithProgressRe re board =
    { board | inProgressRe = re }


updateBoardsWithProgressRe : List TrelloBoard -> TrelloBoard -> String -> List TrelloBoard
updateBoardsWithProgressRe boards board re =
    List.map (updateBoardWithProgressRe re) boards


getBoardTimeSummary : TrelloBoard -> Bool -> Bool -> Float
getBoardTimeSummary board includeDone includeNotDone =
    board.lists
        |> List.map (getTimeFromList board.inProgressRe includeDone includeNotDone)
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
            round (100 * (timeRemaining / (timeDone + timeRemaining)))
    in
        "Done: "
            ++ (toString timeDone)
            ++ " "
            ++ "Remaining: "
            ++ (toString timeRemaining)
            ++ " "
            ++ "Percentage remaining: "
            ++ (toString percentage)
            ++ "%"
