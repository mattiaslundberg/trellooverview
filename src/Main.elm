module Main exposing (..)

import Ports exposing (..)
import Models exposing (..)
import Views exposing (view)
import Html exposing (program)
import Subscriptions exposing (subscriptions)
import Update exposing (update)


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
