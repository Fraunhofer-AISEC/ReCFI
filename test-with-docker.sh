docker-compose -f RCFI-Docker/docker-compose.yaml build

mkdir -p docker-build-debug
mkdir -p docker-test-results
docker-compose -f RCFI-Docker/docker-compose.yaml \
	run --rm \
    -u $(id -u ${USER}):$(id -g ${USER}) \
	-v "$(pwd)"/docker-build-debug:/home/builder/llvm-project/docker-build-dir:rw \
    -v "$(pwd)"/docker-test-results:/home/builder/llvm-project/docker-test-results:rw \
	rcfi-tester rcfi-test/test.sh docker-build-dir docker-test-results
