# Changelog

### Upcoming

*Revisions*

* Bumped max version constraint of werewolf.

### v1.0.1.1

*Revisions*

* Bumped max version constraint of werewolf. ([#18](https://github.com/hjwylde/werewolf/issues/18))

### v1.0.1.0

*Revisions*

* Changed the default port to 80.
* Removed the binary header and updated the program description.

### v1.0.0.0

*Major*

* Initial stable release!

### v0.4.0.0

*Major*

* Renamed `--authentication-token` to `--webhook-url`. ([#15](https://github.com/hjwylde/werewolf/issues/15))
* Renamed `--validation-token` to `--token`. ([#15](https://github.com/hjwylde/werewolf/issues/15))
* Removed `--channel-name` option. ([#16](https://github.com/hjwylde/werewolf/issues/16))

*Minor*

* Split out Dockerfile into its own repository. ([#13](https://github.com/hjwylde/werewolf/issues/13))

*Revisions*

* Changed 202 response to 200. ([#17](https://github.com/hjwylde/werewolf/issues/17))

### v0.3.0.2

*Revisions*

* Removed werewolf version specification from stack.yaml.

### v0.3.0.1

*Revisions*

* Added version to werewolf in Dockerfile.

### v0.3.0.0

*Major*

* Added support for werewolf v0.5.0.0. ([#12](https://github.com/hjwylde/werewolf/issues/12))

### v0.2.0.2

*Revisions*

* Added version to werewolf in Dockerfile.

### v0.2.0.1

*Revisions*

* Added version to werewolf-slack in Dockerfile. ([#11](https://github.com/hjwylde/werewolf/issues/11))

### v0.2.0.0

*Major*

* Added options for specifying the Slack access token, channel name and port to run the server on. ([#6](https://github.com/hjwylde/werewolf/issues/6))

*Minor*

* Added a `--validation-token` option and validation. ([#9](https://github.com/hjwylde/werewolf/issues/9))
* Added a `--debug` flag. ([#4](https://github.com/hjwylde/werewolf/issues/4))

*Revisions*

* Fingers crossed fixed a bug with UTF-8 parsing of an accented e. ([#10](https://github.com/hjwylde/werewolf/issues/10))

### v0.1.0.0

*Major*

* Initial version that connects Slack with the werewolf binary. ([#1](https://github.com/hjwylde/werewolf/issues/1))

*Minor*

* Added a Dockerfile. ([#5](https://github.com/hjwylde/werewolf/issues/5))
