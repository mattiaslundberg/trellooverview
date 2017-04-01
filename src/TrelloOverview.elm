module TrelloOverview exposing (..)

import Trello exposing (trelloAuthorized, trelloAuthorizeResponsed)
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
        , subscriptions = always Sub.none
        , view = view
        , update = update
        }


init : ( Model, Cmd Msg )
init =
    Model False ! []



-- MODEL


type alias Model =
    { isAuthorized : Bool
    }



-- model : Model
-- model =
--     Model False
-- UPDATE


type Msg
    = Check
    | AuthorizedStatus Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Check ->
            ( model, trelloAuthorized "" )

        AuthorizedStatus isAuthorized ->
            ( Model isAuthorized, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ class "wrapper" ]
        [ text ("authorized: " ++ toString model.isAuthorized) ]
