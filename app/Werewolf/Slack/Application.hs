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

import qualified Data.ByteString.Char8      as BSC
import qualified Data.ByteString.Lazy.Char8 as BSLC
import           Data.Maybe

import Network.HTTP.Types
import Network.Wai              hiding (Response, requestBody, responseStatus)
import Network.Wai.Handler.Warp

import Werewolf.Slack.Options
import Werewolf.Slack.Werewolf

runApplication :: (MonadIO m, MonadReader Options m) => m ()
runApplication = do
    options <- ask

    liftIO $ run (optPort options) (application options)

application :: Options -> Application
application options request respond
    | isNothing mToken                              = debugRequest >> badRequest
    | fromJust mToken /= optValidationToken options = debugRequest >> unauthorized
    | isNothing mUser || isNothing mUserCommand     = debugRequest >> badRequest
    | otherwise                                     = debugRequest >> forkIO (runReaderT action options) >> accepted
    where
        debugRequest    = when (optDebug options) $ print request

        accepted        = respond $ responseLBS status202 [] (BSLC.pack $ unwords [":wolf:", fromJust mUserCommand, ":moon:"])
        badRequest      = respond $ responseLBS status400 [] "bad request"
        unauthorized    = respond $ responseLBS status401 [] "unauthorized"

        param name      = join . lookup name $ queryString request
        mToken          = BSC.unpack <$> param "token"
        mUser           = BSC.unpack <$> param "user_name"
        mUserCommand    = BSC.unpack <$> param "text"
        action          = fromJust $ execute <$> mUser <*> mUserCommand
