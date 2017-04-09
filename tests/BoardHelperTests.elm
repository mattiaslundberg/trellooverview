module BoardHelperTests exposing (..)

import Array
import Expect
import String
import Test exposing (..)
import Fuzz exposing (string)
import Models exposing (..)
import Views exposing (..)
import Decoder exposing (..)
import BoardHelpers exposing (..)


all : Test
all =
    describe "BoardHelpers"
        [ test "Get board id" <|
            \() ->
                "some-hello"
                    |> getBoardIdByStorageKey
                    |> Expect.equal (Just "hello")
        , test "Get no board from existing string" <|
            \() ->
                "some-hello"
                    |> getBoardByStorageKey []
                    |> Expect.equal Nothing
        , test "Get board from string" <|
            \() ->
                let
                    board =
                        TrelloBoard False [] "" "hello" "name"
                in
                    "some-hello"
                        |> getBoardByStorageKey [ board ]
                        |> Expect.equal (Just board)
        ]
