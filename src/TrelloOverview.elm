module TrelloOverview exposing (..)

import Trello exposing (..)
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
    Model False ! [trelloAuthorize ""]



-- MODEL


type alias Model =
    { isAuthorized : Bool
    }


type Msg
    = IsAuhorized
    | AuthorizedStatus Bool
    | BoardList (List String)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        IsAuhorized ->
            ( model, trelloAuthorized "" )

        AuthorizedStatus isAuthorized ->
            ( Model isAuthorized, trelloListBoards "" )

        BoardList boards ->
            ( model, Cmd.none )


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
    [ trelloAuthorizedResponse AuthorizedStatus
    , trelloBoards BoardList
    ]



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ class "wrapper" ]
        [ text ("authorized: " ++ toString model.isAuthorized) ]
