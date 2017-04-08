module Tests exposing (..)

import Array
import Test exposing (..)
import Expect
import String
import TrelloCard exposing (..)
import TrelloList exposing (..)
import TrelloBoard exposing (..)


all : Test
all =
    describe "TrelloCard"
        [ describe "Get estimation from trelloCard name"
            [ test "Get time from single number" <|
                \() ->
                    let
                        card =
                            TrelloCard "123" "Some (4)" "123" "123"
                    in
                        Expect.equal 4 (getTimeFromCard card)
            , test "Zero time for non-estimated card" <|
                \() ->
                    let
                        card =
                            TrelloCard "123" "Some" "123" "123"
                    in
                        Expect.equal 0 (getTimeFromCard card)
            , test "Get non-integer time" <|
                \() ->
                    let
                        card =
                            TrelloCard "123" "Some (3.4)" "123" "123"
                    in
                        Expect.equal 3.4 (getTimeFromCard card)
            , test "Get time larger than 10" <|
                \() ->
                    let
                        card =
                            TrelloCard "123" "Some (34)" "123" "123"
                    in
                        Expect.equal 34 (getTimeFromCard card)
            ]
        , describe "Summarize for boards"
            [ test "Summarize for simple board" <|
                \() ->
                    let
                        board =
                            TrelloBoard True [ TrelloList [ TrelloCard "1" "Some (5)" "1" "2", TrelloCard "" "Other (5)" "" "" ] "123" "132" "123" ] "123" "123"
                    in
                        Expect.equal 10 (getBoardTimeSummary board True True)
            ]
        , describe "Summarize for Lists"
            [ test "Includes done list when flag is set" <|
                \() ->
                    let
                        list =
                            TrelloList [ TrelloCard "1" "Some (1)" "1" "2" ] "Done" "123" "123"
                    in
                        Expect.equal 1 (getTimeFromList True False list)
            , test "Excludes done list when flag is not set" <|
                \() ->
                    let
                        list =
                            TrelloList [ TrelloCard "1" "Some (1)" "1" "2" ] "Done" "123" "123"
                    in
                        Expect.equal 0 (getTimeFromList False False list)
            , test "Includes notdone list when flag is set" <|
                \() ->
                    let
                        list =
                            TrelloList [ TrelloCard "1" "Some (1)" "1" "2" ] "Something" "123" "123"
                    in
                        Expect.equal 1 (getTimeFromList False True list)
            , test "Excludes notdone list when flag is not set" <|
                \() ->
                    let
                        list =
                            TrelloList [ TrelloCard "1" "Some (1)" "1" "2" ] "Something" "123" "123"
                    in
                        Expect.equal 0 (getTimeFromList False False list)
            ]
        ]
