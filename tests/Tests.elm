module Tests exposing (..)

import Test exposing (..)
import CardTime
import SummaryTime
import DecoderTests
import BoardHelperTests
import UpdateTests


all : Test
all =
    describe "Time"
        [ CardTime.all
        , SummaryTime.all
        , DecoderTests.all
        , BoardHelperTests.all
        , UpdateTests.all
        ]
