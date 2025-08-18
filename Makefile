build: Dockerfile entrypoint.sh scripts/ms-teams-wrapper
	docker build --platform=linux/arm64 -t slithy/ms-teams:latest .

install:
	docker run -it --rm --volume /usr/local/bin:/target slithy/ms-teams:latest install

uninstall:
	docker run -it --rm --volume /usr/local/bin:/target slithy/ms-teams:latest uninstall

clean:
	docker rm -v `docker ps --filter status=exited -q 2>/dev/null` 2>/dev/null
	docker rmi `docker images --filter dangling=true -q 2>/dev/null` 2>/dev/null

