module Models exposing (..)

import Time exposing (Time)
import Http


type alias Model =
    { isAuthorized : Bool
    , allowLogin : Bool
    , showSettings : Bool
    , boards : List TrelloBoard
    , token : String
    }


type Msg
    = ToggleSettings
    | Authorize
    | IsAuthorized Bool
    | IsNotAuthorized Bool
    | BoardList (Result Http.Error (List TrelloBoard))
    | ListList (Result Http.Error (List TrelloList))
    | CardList String
    | SelectBoard TrelloBoard
    | LocalStorageGot LocalStorage
    | ReChange TrelloBoard String
    | Update Time


type alias LocalStorage =
    { key : String, value : String }


type alias TrelloBoard =
    { show : Bool
    , lists : List TrelloList
    , inProgressRe : String
    , id : String
    , name :
        String
    }


type alias TrelloList =
    { cards : List TrelloCard
    , name : String
    , id : String
    , boardId : String
    }


type alias TrelloCard =
    { id : String
    , name : String
    , listId : String
    , boardId : String
    }
