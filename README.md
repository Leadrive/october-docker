# Setup

To run this docker image, run the following commands.

```bash
$ docker-compose build
$ docker-compose up
```

Then, run `docker exec octoberdocker_web_1 composer install`.

# Build Process
To start development for a new release, first bump the version in the Makefile.
If a configuration has changed, bump the RELEASE.
Then do cool code stuff and commit your changes.
When you're ready to build and release, run the following
```bash
$ make && make release
```
Note that this will try to push the image you just created to the referenced docker hub namespace. So if you don't have that, just run `make build_release`.

Tag the release.
```bash
$ git tag -m "Release VERSION" VERSION
```

***TEST ALL THE THINGS***
