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

import Data.Aeson

import Network.HTTP.Client
import Network.HTTP.Client.TLS
import Network.HTTP.Types.Method

import Werewolf.Slack.Options

url :: MonadReader Options m => m String
url = asks $ ("https://hooks.slack.com/services/" ++) . optAccessToken

notify :: (MonadIO m, MonadReader Options m) => String -> String -> m ()
notify to message = do
    manager <- liftIO $ newManager tlsManagerSettings

    initialRequest  <- url >>= liftIO . parseUrl
    let request     = initialRequest { method = methodPost, requestBody = body }

    response <- liftIO $ httpLbs request manager

    whenM (asks optDebug) $ liftIO (print response)
    where
        body    = RequestBodyLBS $ encode payload
        payload = object
            [ "channel" .= to
            , "text" .= message
            ]
