{-|
Module      : Main

Copyright   : (c) Henry J. Wylde, 2016
License     : BSD3
Maintainer  : public@hjwylde.com
-}

module Main (
    -- * Main
    main,
) where

import System.Environment

import Werewolf.Slack.Application

main :: IO ()
main = getArgs >>= runApplication
