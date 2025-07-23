# Makefile for Kinova Gen3 Docker Workspace
# Usage: make <target>

# Image and container names
IMAGE_NAME = kinova-gen3-dev
CONTAINER_NAME = kinova-gen3-dev
WORKSPACE_DIR = $(PWD)/kinova_ws

.PHONY: help build-docker run-docker-gpu start-docker-gpu enter-docker-gpu stop-docker-gpu

help:
	@echo "Kinova Gen3 Docker Workspace Makefile"
	@echo "--------------------------------------"
	@echo "Available targets:"
	@echo "  build-docker        Build the Docker image."
	@echo "  run-docker-gpu      Run and enter the Docker container with GPU support (auto-remove on exit)."
	@echo "  start-docker-gpu    Start the Docker container with GPU support in detached mode."
	@echo "  enter-docker-gpu    Enter the running Docker container (GPU)."
	@echo "  stop-docker-gpu     Stop the running Docker container (GPU)."
	@echo "  help                Show this help message."

# Build the Docker image
build-docker:
	docker build -t $(IMAGE_NAME) -f docker/Dockerfile .

# Run and enter the Docker container with GPU support (auto-remove on exit)
run-docker-gpu:
	docker run -it --rm --gpus all --net=host --privileged \
		-v $(WORKSPACE_DIR):/root/kinova_ws \
		--name $(CONTAINER_NAME) \
		$(IMAGE_NAME)

# Start the Docker container with GPU support in detached mode
start-docker-gpu:
	docker run -d --gpus all --net=host --privileged \
		-v $(WORKSPACE_DIR):/root/kinova_ws \
		--name $(CONTAINER_NAME) \
		$(IMAGE_NAME) tail -f /dev/null

# Enter the running Docker container (GPU)
enter-docker-gpu:
	docker exec -it $(CONTAINER_NAME) bash

# Stop the running Docker container (GPU)
stop-docker-gpu:
	docker stop $(CONTAINER_NAME) || true
	docker rm $(CONTAINER_NAME) || true
