module Update exposing (..)

import Models exposing (..)
import Html.Events exposing (onClick, onInput)
import List exposing (..)
import Ports exposing (..)
import Models exposing (..)
import Views exposing (view)
import Html exposing (program)
import Decoder exposing (..)
import BoardHelpers exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleSettings ->
            ( { model | showSettings = not model.showSettings }, Cmd.none )

        AuthorizedStatus isAuthorized ->
            ( { model | isAuthorized = isAuthorized }, trelloListBoards "" )

        ListList lists ->
            let
                updatedLists =
                    decodeLists lists
            in
                ( { model | boards = List.map (updateLists updatedLists) model.boards }, getListUpdateCommands updatedLists )

        CardList payload ->
            let
                updatedBoards =
                    List.map (updateBoardWithCard (decodeCards payload)) model.boards
            in
                ( { model | boards = updatedBoards }, Cmd.none )

        BoardList boards ->
            let
                updatedBoards =
                    decodeBoards boards
            in
                ( { model | boards = updatedBoards }, getBoardListCommands updatedBoards )

        SelectBoard board ->
            let
                boards =
                    toogleVisibilityForMatches board model.boards
            in
                ( { model | boards = boards }, getSelectBoardCommands boards )

        ReChange board val ->
            ( { model | boards = updateBoardsWithProgressRe model.boards board val }, localStorageSet (LocalStorage ("progress-" ++ board.id) (val)) )

        LocalStorageGot ls ->
            let
                updatedBoards =
                    handleLocalStorageGot model.boards ls
            in
                ( { model | boards = updatedBoards }, getAfterStorageCommands ls updatedBoards )


getAfterStorageCommands : LocalStorage -> List TrelloBoard -> Cmd msg
getAfterStorageCommands ls boards =
    let
        boardIds : List String
        boardIds =
            map .id (filter .show boards)
    in
        case getBoardByStorageKey boards ls.key of
            Just board ->
                if board.show then
                    Cmd.batch [ (trelloListLists board.id), (getProgressFromStorageCmd board) ]
                else
                    Cmd.none

            Nothing ->
                Cmd.none


getProgressFromStorageCmd : TrelloBoard -> Cmd msg
getProgressFromStorageCmd board =
    if (String.isEmpty board.inProgressRe) && board.show then
        localStorageGet ("progress-" ++ board.id)
    else
        Cmd.none


handleLocalStorageGot : List TrelloBoard -> LocalStorage -> List TrelloBoard
handleLocalStorageGot boards ls =
    if String.startsWith "show-" ls.key then
        case getBoardByStorageKey boards ls.key of
            Just board ->
                updateBoardsWithShow boards board (String.startsWith "T" ls.value)

            Nothing ->
                boards
    else if String.startsWith "progress-" ls.key then
        case getBoardByStorageKey boards ls.key of
            Just board ->
                updateBoardsWithProgressRe boards board ls.value

            Nothing ->
                boards
    else
        boards


getListUpdateCommands : List TrelloList -> Cmd msg
getListUpdateCommands lists =
    lists
        |> map .id
        |> map trelloListCards
        |> Cmd.batch


getBoardListCommands : List TrelloBoard -> Cmd msg
getBoardListCommands boards =
    let
        boardIds : List String
        boardIds =
            map .id (filter .show boards)

        selectionCommands =
            map (\b -> localStorageGet ("show-" ++ b)) (map .id boards)
    in
        Cmd.batch selectionCommands


getSelectBoardCommands : List TrelloBoard -> Cmd msg
getSelectBoardCommands boards =
    let
        boardIds : List String
        boardIds =
            map .id (filter .show boards)

        loadReFromStorageCommands =
            map (\b -> getProgressFromStorageCmd b) boards

        selectionCommands =
            map (\b -> localStorageSet (LocalStorage ("show-" ++ b.id) (toString b.show))) boards
    in
        Cmd.batch (loadReFromStorageCommands ++ selectionCommands)


toogleVisibilityIfMatch : TrelloBoard -> TrelloBoard -> TrelloBoard
toogleVisibilityIfMatch a b =
    if a.id == b.id then
        { b | show = not b.show }
    else
        b


toogleVisibilityForMatches : TrelloBoard -> List TrelloBoard -> List TrelloBoard
toogleVisibilityForMatches board boards =
    map (toogleVisibilityIfMatch board) boards


updateBoardWithProgressRe : String -> String -> TrelloBoard -> TrelloBoard
updateBoardWithProgressRe id re board =
    if id == board.id then
        { board | inProgressRe = re }
    else
        board


updateBoardsWithProgressRe : List TrelloBoard -> TrelloBoard -> String -> List TrelloBoard
updateBoardsWithProgressRe boards board re =
    List.map (updateBoardWithProgressRe board.id re) boards


updateBoardWithShow : String -> Bool -> TrelloBoard -> TrelloBoard
updateBoardWithShow id show board =
    if id == board.id then
        { board | show = show }
    else
        board


updateBoardsWithShow : List TrelloBoard -> TrelloBoard -> Bool -> List TrelloBoard
updateBoardsWithShow boards board show =
    List.map (updateBoardWithShow board.id show) boards
