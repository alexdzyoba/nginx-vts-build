# nginx-vts-build

nginx distribution with VTS module

## Quick start

Just run `make` in the directory. It will create a builder image
(nginx-vts-builder) and then compile nginx with VTS module inside. The result
will be copied to the host and can be found in `output` directory.

