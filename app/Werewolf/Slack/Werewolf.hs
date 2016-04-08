{-|
Module      : Werewolf.Slack.Werewolf

Copyright   : (c) Henry J. Wylde, 2016
License     : BSD3
Maintainer  : public@hjwylde.com
-}

{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Werewolf.Slack.Werewolf (
    -- * Werewolf
    execute,
) where

import Control.Monad.Extra
import Control.Monad.Reader
import Control.Monad.State

import           Data.Aeson
import qualified Data.Text               as T
import qualified Data.Text.Lazy          as TL
import           Data.Text.Lazy.Encoding

import Game.Werewolf

import Network.HTTP.Client hiding (Response)

import System.Process

import Werewolf.Slack.Options
import Werewolf.Slack.Slack

execute :: (MonadIO m, MonadReader Options m, MonadState Manager m) => String -> String -> String -> m ()
execute tag user userCommand = whenJustM (interpret tag user userCommand) handle

interpret :: MonadIO m => String -> String -> String -> m (Maybe Response)
interpret tag user userCommand = do
    stdout <- liftIO $ readCreateProcess (proc command arguments) ""

    return (decode (encodeUtf8 $ TL.pack stdout) :: Maybe Response)
    where
        atUser      = if take 1 user == "@" then user else '@':user
        command     = "werewolf"
        arguments   = ["--caller", atUser, "--tag", tag, "interpret", "--"] ++ words userCommand

handle :: (MonadIO m, MonadReader Options m, MonadState Manager m) => Response -> m ()
handle response = do
    whenM (asks optDebug) $ liftIO (print response)

    forM_ (messages response) $ \(Message mTo message) ->
        notify (T.unpack <$> mTo) (T.unpack message)
