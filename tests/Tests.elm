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
                        card = TrelloCard "123" "Some (4)" "123" "123"
                    in
                        Expect.equal 4 (getTimeFromCard card)
            , test "Zero time for non-estimated card" <|
                \() ->
                    let
                        card = TrelloCard "123" "Some" "123" "123"
                    in
                        Expect.equal 0 (getTimeFromCard card)
            ]
        ]
