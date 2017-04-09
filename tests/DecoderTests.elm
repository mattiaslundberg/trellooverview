module DecoderTests exposing (..)

import Array
import Expect
import String
import Test exposing (..)
import Fuzz exposing (string)
import Models exposing (..)
import Views exposing (..)
import Decoder exposing (..)


all : Test
all =
    describe "Test json decoder"
        [ test "Get board list" <|
            \() ->
                let
                    json =
                        "[{\"id\": \"someid\", \"name\": \"somename\"}]"
                in
                    Expect.equal
                        [ TrelloBoard False [] "" "someid" "somename" ]
                        (decodeBoards json)
        , fuzz string "No bords in random string" <|
            \s ->
                s
                    |> decodeBoards
                    |> Expect.equal []
        , test "Get List list" <|
            \() ->
                let
                    json =
                        "[{\"name\": \"somename\", \"id\": \"someid\", \"idBoard\": \"board\"}]"
                in
                    Expect.equal
                        [ TrelloList [] "somename" "someid" "board" ]
                        (decodeLists json)
        , test "Get Card list" <|
            \() ->
                let
                    json =
                        "[{\"id\": \"id\", \"name\": \"name\", \"idList\": \"list\", \"idBoard\": \"board\"}]"
                in
                    Expect.equal
                        [ TrelloCard "id" "name" "list" "board" ]
                        (decodeCards json)
        ]
