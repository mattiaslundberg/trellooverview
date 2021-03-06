module TrelloApi exposing (..)

import Http
import Json.Decode exposing (..)
import List exposing (filter, append)
import List.Extra exposing (uniqueBy)
import Models exposing (..)


getBoardListCmd : Model -> Cmd Msg
getBoardListCmd model =
    if model.isAuthorized then
        Http.send BoardList (getBoardList model)
    else
        Cmd.none


getBoardList : Model -> Http.Request (List TrelloBoard)
getBoardList model =
    Http.get (buildBoardUrl model) (list boardDecoder)


buildBoardUrl : Model -> String
buildBoardUrl model =
    "https://api.trello.com/1/members/me"
        ++ "/boards?key=35a2be579776824775ad4d6f05d4852b"
        ++ "&fields=name%2C%20id"
        ++ "&token="
        ++ model.token


boardDecoder : Decoder TrelloBoard
boardDecoder =
    map2 (TrelloBoard False [] "") (field "id" string) (field "name" string)


getListList : Model -> String -> Http.Request (List TrelloList)
getListList model boardId =
    Http.get (buildListUrl model boardId) (list listDecoder)


buildListUrl : Model -> String -> String
buildListUrl model boardId =
    "https://api.trello.com/1/boards/"
        ++ boardId
        ++ "/lists?key=35a2be579776824775ad4d6f05d4852b"
        ++ "&cards=open"
        ++ "&token="
        ++ model.token


listDecoder : Decoder TrelloList
listDecoder =
    map4 TrelloList
        (field "cards" (list cardDecoder))
        (field "name" string)
        (field "id" string)
        (field "idBoard" string)


cardDecoder : Decoder TrelloCard
cardDecoder =
    map4 TrelloCard (field "id" string) (field "name" string) (field "idList" string) (field "idBoard" string)


updateLists : List TrelloList -> TrelloBoard -> TrelloBoard
updateLists lists board =
    let
        listsWithDuplicates =
            filter (\c -> c.boardId == board.id)
                (append board.lists
                    lists
                )

        allLists =
            uniqueBy (\l -> l.id) listsWithDuplicates
    in
        { board
            | lists = allLists
        }
