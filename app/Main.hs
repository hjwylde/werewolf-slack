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

import Control.Monad.Reader

import Options.Applicative

import System.Environment

import Werewolf.Slack.Application
import Werewolf.Slack.Options

main :: IO ()
main = getArgs >>= run

run :: [String] -> IO ()
run args = handleParseResult (execParserPure werewolfSlackPrefs werewolfSlackInfo args) >>= handle

handle :: Options -> IO ()
handle = runReaderT runApplication
