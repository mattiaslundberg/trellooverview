module Main exposing (..)

import Html.Events exposing (onClick, onInput)
import List exposing (..)
import Ports exposing (..)
import Models exposing (..)
import Views exposing (view)
import Html exposing (program)
import Decoder exposing (..)


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    Model False False [] ! [ trelloAuthorize "" ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleSettings ->
            ( { model | showSettings = not model.showSettings }, Cmd.none )

        IsAuhorized ->
            ( model, trelloAuthorized "" )

        AuthorizedStatus isAuthorized ->
            ( { model | isAuthorized = isAuthorized }, trelloListBoards "" )

        ListList lists ->
            let
                updatedBoards =
                    decodeLists model.boards lists
            in
                ( { model | boards = updatedBoards }, getListUpdateCommands updatedBoards )

        CardList cards ->
            ( { model | boards = decodeCards model.boards cards }, Cmd.none )

        BoardList boards ->
            let
                updatedBoards =
                    decodeBoards boards
            in
                ( { model | boards = updatedBoards }, getBoardUpdateCommands updatedBoards )

        SelectBoard board ->
            let
                boards =
                    toogleBoard board model.boards
            in
                ( { model | boards = boards }, getBoardUpdateCommands boards )

        ReChange board val ->
            ( { model | boards = updateBoardsWithProgressRe model.boards board val }, localStorageSet (LocalStorage ("progress-" ++ board.id) (val)) )

        LocalStorageGot ls ->
            case getBoardByStorageKey model.boards ls.key of
                Just board ->
                    ( { model | boards = updateBoardsWithProgressRe model.boards board ls.value }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )


getListUpdateCommands : List TrelloBoard -> Cmd msg
getListUpdateCommands boards =
    boards
        |> filter .show
        |> map .lists
        |> concat
        |> map .id
        |> map trelloListCards
        |> Cmd.batch


getBoardUpdateCommands : List TrelloBoard -> Cmd msg
getBoardUpdateCommands boards =
    let
        boardIds : List String
        boardIds =
            map .id (filter .show boards)

        loadListCommands =
            map trelloListLists boardIds

        loadFromStorageCommands =
            map (\b -> localStorageGet ("progress-" ++ b)) boardIds
    in
        Cmd.batch (loadListCommands ++ loadFromStorageCommands)


getBoardByStorageKey : List TrelloBoard -> String -> Maybe TrelloBoard
getBoardByStorageKey boards key =
    let
        id =
            getBoardIdByStorageKey key
    in
        case id of
            Just i ->
                List.head (List.filter (\b -> b.id == i) boards)

            Nothing ->
                Nothing


getBoardIdByStorageKey : String -> Maybe String
getBoardIdByStorageKey key =
    let
        parts =
            key
                |> String.split "-"
                |> List.tail
    in
        case parts of
            Just s ->
                List.head s

            Nothing ->
                Nothing


toogleVisibilityIfMatch : TrelloBoard -> TrelloBoard -> TrelloBoard
toogleVisibilityIfMatch a b =
    if a.id == b.id then
        { b | show = not b.show }
    else
        b


toogleBoard : TrelloBoard -> List TrelloBoard -> List TrelloBoard
toogleBoard board boards =
    map (toogleVisibilityIfMatch board) boards


updateBoardWithProgressRe : String -> TrelloBoard -> TrelloBoard
updateBoardWithProgressRe re board =
    { board | inProgressRe = re }


updateBoardsWithProgressRe : List TrelloBoard -> TrelloBoard -> String -> List TrelloBoard
updateBoardsWithProgressRe boards board re =
    List.map (updateBoardWithProgressRe re) boards



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ trelloAuthorizedResponse AuthorizedStatus
        , trelloBoards BoardList
        , localStorageGot LocalStorageGot
        , trelloList ListList
        , trelloCards CardList
        ]
