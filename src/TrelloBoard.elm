module TrelloBoard exposing (..)

import List exposing (head, tail, filter, map, length, append, sum)
import List.Extra exposing (uniqueBy)
import Models exposing (..)


listCount : TrelloBoard -> Int
listCount board =
    length board.lists


toogleVisibilityIfMatch : TrelloBoard -> TrelloBoard -> TrelloBoard
toogleVisibilityIfMatch a b =
    if a.id == b.id then
        { b | show = not b.show }
    else
        b


toogleBoard : TrelloBoard -> List TrelloBoard -> List TrelloBoard
toogleBoard board boards =
    map (toogleVisibilityIfMatch board) boards


updateBoardWithProgressRe : String -> TrelloBoard -> TrelloBoard
updateBoardWithProgressRe re board =
    { board | inProgressRe = re }


updateBoardsWithProgressRe : List TrelloBoard -> TrelloBoard -> String -> List TrelloBoard
updateBoardsWithProgressRe boards board re =
    List.map (updateBoardWithProgressRe re) boards
