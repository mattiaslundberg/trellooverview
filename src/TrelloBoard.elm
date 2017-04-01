module TrelloBoard exposing (..)

import Json.Decode exposing (..)


-- MODEL


type alias TrelloBoard =
    { id : String
    , name :
        String
        -- , cards : String
    }


boardDecoder : Decoder TrelloBoard
boardDecoder =
    map2 TrelloBoard (field "id" string) (field "name" string)


decodeBoards : String -> List TrelloBoard
decodeBoards payload =
    case decodeString (list boardDecoder) payload of
        Ok val ->
            val

        Err message ->
            []
