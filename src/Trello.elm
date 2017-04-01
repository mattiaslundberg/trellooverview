port module Trello exposing (..)


port trelloAuthorized : String -> Cmd msg


port trelloAuthorizedResponse : (Bool -> msg) -> Sub msg


port trelloAuthorize : String -> Cmd msg


port trelloListBoards : String -> Cmd msg


port trelloBoards : (String -> msg) -> Sub msg
