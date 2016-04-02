FROM haskell:7.10.3

RUN stack install werewolf-slack-0.2.0.0 werewolf
ENTRYPOINT ["werewolf-slack"]

EXPOSE 8080
