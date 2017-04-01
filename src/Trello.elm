port module Trello exposing (..)


port trelloAuthorized : String -> Cmd msg


port trelloAuthorizeResponsed : (Bool -> msg) -> Sub msg
