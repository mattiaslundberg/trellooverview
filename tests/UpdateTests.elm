module UpdateTests exposing (..)

import Expect
import Test exposing (..)
import Models exposing (..)
import Update exposing (..)


all : Test
all =
    describe "Update"
        [ test "Update board with progress regex" <|
            \() ->
                let
                    board =
                        TrelloBoard False [] "old" "someid" "somename"
                in
                    Expect.equal
                        [ TrelloBoard False [] "new" "someid" "somename" ]
                        (updateBoardsWithProgressRe [ board ] board "new")
        , test "Don't update non-matching board with progress regex" <|
            \() ->
                let
                    board =
                        TrelloBoard False [] "old" "otherid" "somename"
                in
                    Expect.equal
                        [ board ]
                        (updateBoardsWithProgressRe [ board ] (TrelloBoard False [] "" "someid" "somename") "new")
        ]
