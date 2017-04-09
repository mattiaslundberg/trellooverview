module BoardHelpers exposing (..)

import Models exposing (..)


getBoardByStorageKey : List TrelloBoard -> String -> Maybe TrelloBoard
getBoardByStorageKey boards key =
    case getBoardIdByStorageKey key of
        Just id ->
            List.head (List.filter (\b -> b.id == id) boards)

        Nothing ->
            Nothing


getBoardIdByStorageKey : String -> Maybe String
getBoardIdByStorageKey key =
    case getBoardIdList key of
        Just s ->
            List.head s

        Nothing ->
            Nothing


getBoardIdList : String -> Maybe (List String)
getBoardIdList key =
    key
        |> String.split "-"
        |> List.tail
