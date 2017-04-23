module DecoderTests exposing (..)

import Expect
import Test exposing (..)
import Models exposing (..)
import Decoder exposing (..)
import Json.Decode exposing (decodeString, list)


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
                        (Ok [ TrelloBoard False [] "" "someid" "somename" ])
                        (decodeString (list boardDecoder) json)
        , test "Get List list" <|
            \() ->
                let
                    json =
                        "[{\"name\": \"somename\", \"id\": \"someid\", \"idBoard\": \"board\"}]"
                in
                    Expect.equal
                        (Ok [ TrelloList [] "somename" "someid" "board" ])
                        (decodeString (list listDecoder) json)
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
