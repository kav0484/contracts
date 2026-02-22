PROTO_ROOT=.
DOCKER_IAMGE=proto-builder

.PHONY: docker-build gen clean


docker-build:
	docker build -t $(DOCKER_IAMGE) .

gen: docker-build
	docker run --rm -v $(abspath $(PROTO_ROOT)):/app $(DOCKER_IAMGE) \
	bash -c '\
		set -e; \
		for dir in account pagination; do \
		echo ">> Processing $$dir"; \
		mkdir -p /app/$$dir/go; \
		cd /app/$$dir; \
			for file in *.proto; do \
				echo " Generating $$dir/$$file"; \
				protoc \
			  		-I . \
			  	 	-I /app \
			  		-I /usr/local/include/googleapis \
			  		--go_out=go \
			  		--go_opt=path=source_relative \
			  		--go-grpc_out=go \
			  		--go-grpc_opt=path=source_relative \
			  		$$file; \
			done; \
		done \
		'

clean: find account pagination -type d -name go exec rm -rf {}