1. Deployable Docker Image
- Dockerfile split into a builder and runner phase, to minimize image size and rebuild times
- Took it as a challenge to use the build/test/run shell scripts
  - This may not be ideal, as `sh` does not include things like `source` that the scripts use, so had to use `bash`
  - The benefit is to reuse things that developers are theoretically already using
  - It is definitely a hack, as I'm reusing WORKDIR in both phases and they cannot be different due to hardcoding the python bin path
- I tried this with `buildah` and `podman` and made it work that way
  - `buildah bud --format docker -t helloapp .`
  - `podman run --rm -p 8080:8080 helloapp`
