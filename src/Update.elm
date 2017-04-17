module Update exposing (..)

import Models exposing (..)
import List exposing (..)
import Ports exposing (..)
import Models exposing (..)
import Decoder exposing (..)
import BoardHelpers exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Update time ->
            ( model, getBoardListCmd model.isAuthorized )

        ToggleSettings ->
            ( { model | showSettings = not model.showSettings }, Cmd.none )

        Authorize ->
            ( { model | allowLogin = True }, trelloAuthorize "" )

        IsAuthorized _ ->
            ( { model | isAuthorized = True }, trelloListBoards "" )

        IsNotAuthorized _ ->
            ( { model | isAuthorized = False }, localStorageGet "trello_token" )

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
            ( { model | boards = updateBoardsWithProgressRe model.boards board val }, localStorageSet (LocalStorage (getReKey board) (val)) )

        LocalStorageGot ls ->
            handleLocalStorageGot model ls


getBoardListCmd : Bool -> Cmd Msg
getBoardListCmd isAuthorized =
    if isAuthorized then
        trelloListBoards ""
    else
        Cmd.none


handleLocalStorageGot : Model -> LocalStorage -> ( Model, Cmd Msg )
handleLocalStorageGot model ls =
    case ls.key of
        "trello_token" ->
            ( model, trelloAuthorize "" )

        _ ->
            let
                updatedBoards =
                    handleLocalStorageGotSetting model.boards ls
            in
                ( { model | boards = updatedBoards }, getAfterStorageCommands ls updatedBoards )


getBoardCommands : TrelloBoard -> Maybe (Cmd msg)
getBoardCommands board =
    if board.show then
        Just (Cmd.batch [ (trelloListLists board.id), (getProgressFromStorageCmd board) ])
    else
        Nothing


getAfterStorageCommands : LocalStorage -> List TrelloBoard -> Cmd msg
getAfterStorageCommands ls boards =
    getBoardByStorageKey boards ls.key
        |> Maybe.andThen getBoardCommands
        |> Maybe.withDefault Cmd.none


getProgressFromStorageCmd : TrelloBoard -> Cmd msg
getProgressFromStorageCmd board =
    if (String.isEmpty board.inProgressRe) && board.show then
        localStorageGet (getReKey board)
    else
        Cmd.none


handleLocalStorageGotSetting : List TrelloBoard -> LocalStorage -> List TrelloBoard
handleLocalStorageGotSetting boards ls =
    if String.startsWith "show-" ls.key then
        handleLocalStorageGotShow boards ls
    else if String.startsWith "progress-" ls.key then
        handleLocalStorageGotRe boards ls
    else
        boards


handleLocalStorageGotShow : List TrelloBoard -> LocalStorage -> List TrelloBoard
handleLocalStorageGotShow boards ls =
    case getBoardByStorageKey boards ls.key of
        Just board ->
            updateBoardsWithShow boards board (String.startsWith "T" ls.value)

        Nothing ->
            boards


handleLocalStorageGotRe : List TrelloBoard -> LocalStorage -> List TrelloBoard
handleLocalStorageGotRe boards ls =
    case getBoardByStorageKey boards ls.key of
        Just board ->
            updateBoardsWithProgressRe boards board ls.value

        Nothing ->
            boards


getListUpdateCommands : List TrelloList -> Cmd msg
getListUpdateCommands lists =
    lists
        |> map .id
        |> map trelloListCards
        |> Cmd.batch


getBoardListCommands : List TrelloBoard -> Cmd msg
getBoardListCommands boards =
    Cmd.batch (map (\b -> localStorageGet (getShowKey b)) boards)


getSaveSelectionCommands : List TrelloBoard -> List (Cmd msg)
getSaveSelectionCommands boards =
    map (\b -> localStorageSet (LocalStorage (getShowKey b) (toString b.show))) boards


getProgressCommands : List TrelloBoard -> List (Cmd msg)
getProgressCommands boards =
    map (\b -> getProgressFromStorageCmd b) boards


getSelectBoardCommands : List TrelloBoard -> Cmd msg
getSelectBoardCommands boards =
    Cmd.batch (getProgressCommands boards ++ getSaveSelectionCommands boards)


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
