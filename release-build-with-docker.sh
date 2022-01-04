docker-compose -f RCFI-Docker/docker-compose.yaml build

mkdir -p docker-build-release
docker-compose -f RCFI-Docker/docker-compose.yaml \
	run --rm \
	-u $(id -u ${USER}):$(id -g ${USER}) \
	-v "$(pwd)"/docker-build-release:/home/builder/llvm-project/docker-build-dir:rw \
	-e BUILD_DEBUG="NO" \
	llvm-builder ./build.sh docker-build-dir