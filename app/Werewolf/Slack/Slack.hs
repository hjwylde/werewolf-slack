{-|
Module      : Werewolf.Slack.Slack

Copyright   : (c) Henry J. Wylde, 2016
License     : BSD3
Maintainer  : public@hjwylde.com
-}

{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}

module Werewolf.Slack.Slack (
    -- * Slack
    notify,
) where

import Control.Monad.Extra
import Control.Monad.Reader
import Control.Monad.State

import Data.Aeson

import Network.HTTP.Client
import Network.HTTP.Types.Method

import Werewolf.Slack.Options

notify :: (MonadIO m, MonadReader Options m, MonadState Manager m) => Maybe String -> String -> m ()
notify mTo message = do
    manager <- get

    initialRequest  <- asks optWebhookUrl >>= liftIO . parseUrl
    let request     = initialRequest { method = methodPost, requestBody = body }

    whenM (asks optDebug) $ liftIO (print request)

    response <- liftIO $ httpLbs request manager

    whenM (asks optDebug) $ liftIO (print response)
    where
        body    = RequestBodyLBS $ encode payload
        payload = object
            [ "channel" .= mTo
            , "text" .= message
            ]
