1. Deployable Docker Image
- Dockerfile split into a builder and runner phase, to minimize image size and rebuild times
- I took it as a challenge to use the build/test/run shell scripts
  - This may not be ideal, as `sh` does not include things like `source` that the scripts use, so had to use `bash`
  - The benefit is to reuse things that developers are theoretically already using
  - It is definitely a hack, as I'm reusing WORKDIR in both phases and they cannot be different due to hardcoding the python bin path
  - A different solution here would be to run the `pip install` and `python -m unittest` commands directly and have more direct control over the build environment and what gets cached
- I tried this with `buildah` and `podman` and made it work that way
  - `buildah bud --format docker -t helloapp .`
  - `podman run --rm -p 8080:8080 helloapp`
2. Kubernetes deployment
- I used k3s as I'm on Linux
- I've never used this combination of technologies before. Interesting that I had to generate a local tarball and import it into k3s.
  - `buildah push helloapp:lastest docker-archive:helloapp.tar`
    - note: I only got this to work with `docker-archive`, not `oci-archive`
  - `sudo k3s ctr -n k8s.io images import helloapp.tar`
- I'm using a type of NodePort here. I think this will have to change for when I'm not testing locally.
