module TrelloOverview exposing (..)

import Html exposing (Html, button, div, text, span, program, table, tr, td, input)
import Html.Attributes exposing (style, class, classList, placeholder)
import Html.Events exposing (onClick, onInput)
import List exposing (..)
import Ports exposing (..)
import TrelloBoard exposing (..)


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



-- MODEL


type alias Model =
    { isAuthorized : Bool
    , boards : List TrelloBoard
    }


type Msg
    = IsAuhorized
    | AuthorizedStatus Bool
    | BoardList String
    | ListList String
    | CardList String
    | SelectBoard TrelloBoard
    | LocalStorageGot String
    | ReChange TrelloBoard String


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
            ( {model | boards = updateBoardsWithProgressRe model.boards board val }, Cmd.none)

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



-- VIEW


displayListSummary : TrelloBoard -> Html Msg
displayListSummary board =
    div
        [ class "list-summary" ]
        [ text (board.name ++ " " ++ (toString (listCount board)) ++ " lists and " ++ (toString (cardCount board)) ++ " cards") ]


displayBoardSelector : TrelloBoard -> Html Msg
displayBoardSelector board =
    div [ onClick (SelectBoard board), class "board-selector" ]
        [ div []
            [ text (board.name ++ " " ++ (toString board.show))
            ]
        , input [ placeholder "Done.*", onInput (ReChange board) ] []
        ]


displayTimeSummary : TrelloBoard -> Html Msg
displayTimeSummary board =
    div [ class "board-timing" ]
        [ text (board.name ++ " " ++ (getBoardTimeSummaryDisplay board))
        ]


view : Model -> Html Msg
view model =
    let
        boards =
            getBoardsToShow model.boards
    in
        div
            [ class "wrapper" ]
            [ div [] (List.map displayBoardSelector model.boards)
            , div [ class "board-wrapper" ]
                (List.map displayListSummary boards)
            , div [ class "summary-wrapper" ]
                (List.map displayTimeSummary boards)
            ]
