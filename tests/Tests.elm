module Tests exposing (..)

import Test exposing (..)
import CardTime
import SummaryTime
import TrelloApiTests
import BoardHelperTests
import UpdateTests


all : Test
all =
    describe "Time"
        [ CardTime.all
        , SummaryTime.all
        , TrelloApiTests.all
        , BoardHelperTests.all
        , UpdateTests.all
        ]
