module Views exposing (..)

import Models exposing (..)
import Html exposing (Html, button, div, text, span, program, table, tr, td, input)
import Html.Attributes exposing (style, class, classList, placeholder)
import Html.Events exposing (onClick, onInput)
import List exposing (map, length, sum, length)
import Regex exposing (..)


findTime : String -> Maybe String
findTime s =
    case List.head (findTimeInString s) of
        Just val ->
            val

        Nothing ->
            Nothing


getTimeFromCard : TrelloCard -> Float
getTimeFromCard card =
    case findTime card.name of
        Just val ->
            case String.toFloat val of
                Ok v ->
                    v

                Err msg ->
                    0.0

        Nothing ->
            0.0


findTimeInString : String -> List (Maybe String)
findTimeInString s =
    case List.head (find (AtMost 1) (regex ".* \\(([\\d\\.\\,]+)\\)") s) of
        Just val ->
            val.submatches

        Nothing ->
            []


getBoardsToShow : List TrelloBoard -> List TrelloBoard
getBoardsToShow boards =
    List.filter .show boards


cardCount : TrelloBoard -> Int
cardCount board =
    let
        cards =
            (map (\l -> (length l.cards)) board.lists)
    in
        sum cards


listMatches : String -> String -> Bool
listMatches list re =
    case List.head (find (AtMost 1) (regex re) list) of
        Just val ->
            True

        Nothing ->
            False



-- This should be a user-configurable expression


doneRe : String
doneRe =
    "Done.*"


listIsDone : String -> Bool
listIsDone list =
    listMatches list doneRe


listIsRemaining : String -> String -> Bool
listIsRemaining inProgressRe list =
    listMatches list inProgressRe


summarizeCards : List TrelloCard -> Float
summarizeCards cards =
    cards
        |> List.map getTimeFromCard
        |> List.sum


getTimeFromList : String -> Bool -> Bool -> TrelloList -> Float
getTimeFromList inProgressRe includeDone includeNotDone list =
    let
        doneCount =
            if includeDone && (listIsDone list.name) then
                (summarizeCards list.cards)
            else
                0

        remainingCount =
            if includeNotDone && (listIsRemaining inProgressRe list.name) then
                (summarizeCards list.cards)
            else
                0
    in
        doneCount + remainingCount


displayListSummary : TrelloBoard -> Html Msg
displayListSummary board =
    div
        [ class "list-summary" ]
        [ text (board.name ++ " " ++ (toString (length board.lists)) ++ " lists and " ++ (toString (cardCount board)) ++ " cards") ]


displayBoardSelector : TrelloBoard -> Html Msg
displayBoardSelector board =
    div [ class "board-selector" ]
        [ div [ onClick (SelectBoard board) ]
            [ text (board.name ++ " " ++ (toString board.show))
            ]
        , input [ placeholder "Version.*", onInput (ReChange board) ] []
        ]


getBoardTimeSummary : TrelloBoard -> Bool -> Bool -> Float
getBoardTimeSummary board includeDone includeNotDone =
    board.lists
        |> List.map (getTimeFromList board.inProgressRe includeDone includeNotDone)
        |> List.sum


getBoardTimeSummaryDisplay : TrelloBoard -> String
getBoardTimeSummaryDisplay board =
    let
        timeDone =
            getBoardTimeSummary board True False

        timeRemaining =
            getBoardTimeSummary board False True

        percentage =
            round (100 * (timeRemaining / (timeDone + timeRemaining)))
    in
        "Done: "
            ++ (toString timeDone)
            ++ " "
            ++ "Remaining: "
            ++ (toString timeRemaining)
            ++ " "
            ++ "Percentage remaining: "
            ++ (toString percentage)
            ++ "%"


displayTimeSummary : TrelloBoard -> Html Msg
displayTimeSummary board =
    div [ class "board-timing" ]
        [ text (board.name ++ " " ++ (getBoardTimeSummaryDisplay board))
        ]


displaySettingButton : Html Msg
displaySettingButton =
    button [ class "settings-button", onClick ToggleSettings ] [ text "Toggle Settings" ]


displaySettings : Model -> Html Msg
displaySettings model =
    if model.showSettings then
        div [] (List.map displayBoardSelector model.boards)
    else
        div [] []


view : Model -> Html Msg
view model =
    let
        boards =
            getBoardsToShow model.boards
    in
        div
            [ class "wrapper" ]
            [ displaySettingButton
            , (displaySettings model)
            , div [ class "board-wrapper" ]
                (List.map displayListSummary boards)
            , div [ class "summary-wrapper" ]
                (List.map displayTimeSummary boards)
            ]
