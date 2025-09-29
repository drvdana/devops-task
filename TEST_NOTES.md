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
- I'm using a service type of NodePort here. I think this will have to change for when I'm not testing locally. (Update: I'll leave it)
3. Github Actions ci deploy
- I'm using Github Actions because it has been a while. I used Jenkins extensively at my last job, so this is a nice change of pace.
- The k3s pre-built install is buggy. In the interest of making it work I'm including the sha256 of the version of the install script I manually verified.
  - I said in the commit, but if the k3s install script changes, this would need to update its sha256sum using: `curl -sfL https://get.k3s.io | sha256sum`
- I'm going back and forth in my mind about running the test script during CI or during the Docker build. I'm going to leave it in the Docker build for now so developers get test feedback earlier.
- I ended up needing a few commits to get this working. I rebased and squashed to reduce commit spam.
