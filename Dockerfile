FROM haskell:7.10.3

RUN stack install werewolf-slack werewolf
ENTRYPOINT ["werewolf-slack"]

EXPOSE 8080
