.PHONY: debian11 image publicimage

IMAGE := nginx-vts-builder
CONTAINER := nginx-vts-builder

debian9: image
	docker run -it --name $(CONTAINER)  $(IMAGE):debian-11
	docker cp $(CONTAINER):/output .
	docker rm $(CONTAINER)

image: Dockerfile.debian9
	docker build -t $(IMAGE):debian-11 -f Dockerfile.debian11 .

publicimage:
	docker build -t alexdzyoba/$(IMAGE):debian-11 -f Dockerfile.debian11 .
	docker push alexdzyoba/$(IMAGE):debian-11
