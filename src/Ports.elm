port module Ports exposing (..)

import Models exposing (LocalStorage)


port trelloAuthorized : String -> Cmd msg


port trelloAuthorizedResponse : (Bool -> msg) -> Sub msg


port trelloAuthorize : String -> Cmd msg


port trelloListBoards : String -> Cmd msg


port trelloBoards : (String -> msg) -> Sub msg


port trelloListLists : String -> Cmd msg


port trelloList : (String -> msg) -> Sub msg


port trelloListCards : String -> Cmd msg


port trelloCards : (String -> msg) -> Sub msg


port localStorageSet : LocalStorage -> Cmd msg


port localStorageGet : String -> Cmd msg


port localStorageGot : (LocalStorage -> msg) -> Sub msg
