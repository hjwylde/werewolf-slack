{-|
Module      : Werewolf.Slack.Application

Copyright   : (c) Henry J. Wylde, 2016
License     : BSD3
Maintainer  : public@hjwylde.com
-}

{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}

module Werewolf.Slack.Application (
    -- * Application
    runApplication,
) where

import Control.Concurrent
import Control.Monad.Extra
import Control.Monad.Reader
import Control.Monad.State

import qualified Data.ByteString.Char8      as BSC
import qualified Data.ByteString.Lazy.Char8 as BSLC
import           Data.Maybe

import Network.HTTP.Client      hiding (queryString)
import Network.HTTP.Client.TLS
import Network.HTTP.Types
import Network.Wai              hiding (Response, requestBody, responseStatus)
import Network.Wai.Handler.Warp

import Werewolf.Slack.Options
import Werewolf.Slack.Werewolf

runApplication :: (MonadIO m, MonadReader Options m) => m ()
runApplication = do
    options <- ask

    manager <- liftIO $ newManager tlsManagerSettings

    liftIO $ run (optPort options) (application options manager)

application :: Options -> Manager -> Application
application options manager request respond
    | isNothing mToken                          = debugRequest >> badRequest
    | fromJust mToken /= optToken options       = debugRequest >> unauthorized
    | isNothing mUser || isNothing mUserCommand = debugRequest >> badRequest
    | otherwise                                 = debugRequest >> forkIO (evalStateT (runReaderT action options) manager) >> ok
    where
        debugRequest = when (optDebug options) $ print request

        ok              = respond $ responseLBS status200 [] (BSLC.pack $ unwords [":wolf:", fromJust mUserCommand, ":moon:"])
        badRequest      = respond $ responseLBS status400 [] "bad request"
        unauthorized    = respond $ responseLBS status401 [] "unauthorized"

        param name      = join . lookup name $ queryString request
        mToken          = BSC.unpack <$> param "token"
        mUser           = BSC.unpack <$> param "user_name"
        mUserCommand    = BSC.unpack <$> param "text"
        action          = fromJust $ execute <$> mToken <*> mUser <*> mUserCommand
