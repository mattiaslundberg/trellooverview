module Models exposing (..)


type alias Model =
    { isAuthorized : Bool
    , showSettings : Bool
    , boards : List TrelloBoard
    }


type Msg
    = IsAuhorized
    | ToggleSettings
    | AuthorizedStatus Bool
    | BoardList String
    | ListList String
    | CardList String
    | SelectBoard TrelloBoard
    | LocalStorageGot String
    | ReChange TrelloBoard String


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
