{-|
Module      : Werewolf.Slack.Werewolf

Copyright   : (c) Henry J. Wylde, 2016
License     : BSD3
Maintainer  : public@hjwylde.com
-}

module Werewolf.Slack.Werewolf (
    -- * Werewolf
    executeUserCommand,
) where

import Control.Monad.Extra

import           Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as BSLC
import           Data.Maybe
import qualified Data.Text                  as T

import Game.Werewolf

import System.Process

import Werewolf.Slack.Slack

executeUserCommand :: String -> String -> String -> IO ()
executeUserCommand accessToken user userCommand = do
    stdout          <- readCreateProcess (proc command arguments) ""
    let mResponse   = decode (BSLC.pack stdout) :: Maybe Response

    whenJust mResponse $ \response ->
        forM_ (messages response) $ \(Message mTo message) ->
            notify accessToken (fromMaybe channelName (T.unpack <$> mTo)) (T.unpack message)
    where
        atUser      = if take 1 user == "@" then user else '@':user
        command     = "werewolf"
        arguments   = ["--caller", atUser, "interpret", "--"] ++ words userCommand

channelName :: String
channelName = "#werewolf"
