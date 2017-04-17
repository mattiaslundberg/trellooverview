module BoardHelpers exposing (..)

import Models exposing (..)


getBoardByStorageKey : List TrelloBoard -> String -> Maybe TrelloBoard
getBoardByStorageKey boards key =
    key
        |> getBoardIdByStorageKey
        |> Maybe.andThen (getBoardById boards)


getBoardIdByStorageKey : String -> Maybe String
getBoardIdByStorageKey key =
    key |> getBoardIdList |> Maybe.andThen List.head


getBoardIdList : String -> Maybe (List String)
getBoardIdList key =
    key
        |> String.split "-"
        |> List.tail


getBoardById : List TrelloBoard -> String -> Maybe TrelloBoard
getBoardById boards id =
    List.head (List.filter (\b -> b.id == id) boards)


getShowKey : TrelloBoard -> String
getShowKey board =
    "show-" ++ board.id


getReKey : TrelloBoard -> String
getReKey board =
    "progress-" ++ board.id
