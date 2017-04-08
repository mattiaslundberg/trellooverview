module TrelloOverview exposing (..)

import Html.Events exposing (onClick, onInput)
import List exposing (..)
import Ports exposing (..)
import TrelloBoard exposing (..)
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
    Model False [] ! [ trelloAuthorize "" ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        IsAuhorized ->
            ( model, trelloAuthorized "" )

        AuthorizedStatus isAuthorized ->
            ( { model | isAuthorized = isAuthorized }, trelloListBoards "" )

        BoardList boards ->
            let
                updatedBoards =
                    decodeBoards boards

                boardsToLoad =
                    map (\b -> b.id) (filter (\b -> b.show) updatedBoards)
            in
                ( { model | boards = updatedBoards }
                , Cmd.batch
                    (map
                        trelloListLists
                        boardsToLoad
                    )
                )

        ListList lists ->
            let
                updatedBoards =
                    decodeLists model.boards lists

                boardsToLoad =
                    filter (\b -> b.show) updatedBoards

                listsToLoad =
                    concat (map (\b -> b.lists) boardsToLoad)
            in
                ( { model | boards = updatedBoards }
                , Cmd.batch
                    (map
                        trelloListCards
                        (map (\l -> l.id) listsToLoad)
                    )
                )

        CardList cards ->
            ( { model | boards = decodeCards model.boards cards }, Cmd.none )

        SelectBoard board ->
            let
                boards =
                    toogleBoard board model.boards

                boardsToLoad =
                    map (\b -> b.id) (filter (\b -> b.show) boards)
            in
                ( { model | boards = boards }
                , Cmd.batch
                    (map trelloListLists
                        boardsToLoad
                    )
                )

        ReChange board val ->
            ( { model | boards = updateBoardsWithProgressRe model.boards board val }, Cmd.none )

        LocalStorageGot value ->
            ( model, Cmd.none )



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
