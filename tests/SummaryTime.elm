module SummaryTime exposing (..)

import Array
import Expect
import String
import Test exposing (..)
import Models exposing (..)
import Views exposing (..)


all : Test
all =
    describe "Summarize times"
        [ test "Summarize for simple board" <|
            \() ->
                let
                    board =
                        TrelloBoard True
                            [ TrelloList
                                [ TrelloCard "1" "Some (5)" "1" "2"
                                , TrelloCard "" "Other (5)" "" ""
                                ]
                                "Version 2"
                                "132"
                                "123"
                            ]
                            ".*"
                            "123"
                            "123"
                in
                    Expect.equal
                        10
                        (getBoardTimeSummary board True True)
        , test "Includes done list when flag is set" <|
            \() ->
                let
                    list =
                        TrelloList
                            [ TrelloCard "1" "Some (1)" "1" "2"
                            ]
                            "Done"
                            "123"
                            "123"
                in
                    Expect.equal 1 (getTimeFromList "Version.*" True False list)
        , test "Excludes done list when flag is not set" <|
            \() ->
                let
                    list =
                        TrelloList [ TrelloCard "1" "Some (1)" "1" "2" ] "Done" "123" "123"
                in
                    Expect.equal 0 (getTimeFromList "Version.*" False False list)
        , test "Includes notdone list when flag is set" <|
            \() ->
                let
                    list =
                        TrelloList
                            [ TrelloCard "1" "Some (1)" "1" "2"
                            ]
                            "Version 2"
                            "123"
                            "123"
                in
                    Expect.equal
                        1
                        (getTimeFromList "Version.*" False True list)
        , test "Excludes notdone list when flag is not set" <|
            \() ->
                let
                    list =
                        TrelloList
                            [ TrelloCard "1" "Some (1)" "1" "2"
                            ]
                            "Version 2"
                            "123"
                            "123"
                in
                    Expect.equal
                        0
                        (getTimeFromList "Some.*" False False list)
        ]
