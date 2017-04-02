port module Ports exposing (..)


port trelloAuthorized : String -> Cmd msg


port trelloAuthorizedResponse : (Bool -> msg) -> Sub msg


port trelloAuthorize : String -> Cmd msg


port trelloListBoards : String -> Cmd msg


port trelloBoards : (String -> msg) -> Sub msg


port localStorageSet : String -> Cmd msg


port localStorageGet : String -> Cmd msg


port localStorageGot : (String -> msg) -> Sub msg
