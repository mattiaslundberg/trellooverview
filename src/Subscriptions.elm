module Subscriptions exposing (..)

import Models exposing (..)
import Ports exposing (..)
import Time exposing (every, minute)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ trelloIsAuthorized IsAuthorized
        , trelloIsNotAuthorized IsNotAuthorized
        , localStorageGot LocalStorageGot
        , every minute Update
        ]
