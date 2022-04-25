CONTAINER=ferimer/ferimer:http2https

build:
	docker build -t ${CONTAINER} .

publish: build
	docker push ${CONTAINER}

