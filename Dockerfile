FROM haskell:7.10.3

RUN stack install werewolf-slack-0.2.0.1 werewolf-0.4.12.0
ENTRYPOINT ["werewolf-slack"]

EXPOSE 8080
