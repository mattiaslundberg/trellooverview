module Tests exposing (..)

import Array
import Test exposing (..)
import Expect
import String
import TrelloCard exposing (..)


all : Test
all =
    describe "TrelloCard"
        [ describe "Get estimation from trelloCard name"
            [ test "" <|
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
        ]
