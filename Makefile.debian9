.PHONY: debian9 image publicimage

IMAGE := nginx-vts-builder
CONTAINER := nginx-vts-builder

debian9: image
	docker run -it --name $(CONTAINER)  $(IMAGE):debian-9
	docker cp $(CONTAINER):/output .
	docker rm $(CONTAINER)

image: Dockerfile.debian9
	docker build -t $(IMAGE):debian-9 -f Dockerfile.debian9 .

publicimage:
	docker build -t alexdzyoba/$(IMAGE):debian-9 -f Dockerfile.debian9 .
	docker push alexdzyoba/$(IMAGE):debian-9

