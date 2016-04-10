.PHONY: all version build build_release release run

NAME=ianhilt/octobercms
VERSION=1.0
RELEASE=0

all: build

version:
	sed 's/VERSION/$(VERSION)/g' Dockerfile-release > Dockerfile-release-$(VERSION).$(RELEASE)

build:
	docker build -t $(NAME):$(VERSION) --rm .

build_release: version
	docker build -f Dockerfile-release-$(VERSION).$(RELEASE) -t $(NAME):$(VERSION).$(RELEASE) --rm .
	docker tag -f $(NAME):$(VERSION).$(RELEASE) $(NAME):latest
	rm Dockerfile-release-$(VERSION).$(RELEASE)

release: build_release
	docker push $(NAME):$(VERSION).$(RELEASE) && docker push $(NAME):latest
	@echo "*** Don't forget to create a tag. git tag $(VERSION).$(RELEASE) && git push origin $(VERSION).$(RELEASE)"

run:
	docker-compose up
