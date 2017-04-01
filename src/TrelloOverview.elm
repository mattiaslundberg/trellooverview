module TrelloOverview exposing (..)

import Trello exposing (..)
import TrelloBoard exposing (..)
import Html exposing (Html, button, div, text, span, program, table, tr, td)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style, class, classList)
import Random exposing (..)
import Array exposing (..)
import Tuple
import Task
import Time


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
    | SelectBoard TrelloBoard


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        IsAuhorized ->
            ( model, trelloAuthorized "" )

        AuthorizedStatus isAuthorized ->
            ( { model | isAuthorized = isAuthorized }, trelloListBoards "" )

        BoardList boards ->
            ( { model | boards = decodeBoards boards }, Cmd.none )

        SelectBoard board ->
            ( { model | boards = toogleBoard board model.boards }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ trelloAuthorizedResponse AuthorizedStatus
        , trelloBoards BoardList
        ]



-- VIEW


displayBoard : TrelloBoard -> Html Msg
displayBoard board =
    div [ onClick (SelectBoard board) ] [ text (board.name ++ (toString board.show)) ]


view : Model -> Html Msg
view model =
    div
        [ class "wrapper" ]
        [ div []
            [ text ("authorized: " ++ toString model.isAuthorized)
            ]
        , div [] (List.map displayBoard model.boards)
        ]
