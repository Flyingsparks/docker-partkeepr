## flyingsparks/partkeepr docker image repository

This image was originally forked from `mhubig/partkeepr` docker. As this was no longer being kept in sync with the latest partkeepr releases, I have forked the container.

This is the repository for the trusted builds of the `flyingsparks/partkeepr` docker
image. Releases are made with the help of [git-flow (AVH Edition)][1] and kept
in sync with the [partkeepr][2] releases.

To use it, you need to have a working [docker][3] installation. Than run the
following command:

    $ docker run -d -p 8080:80 --name partkeepr flyingsparks/partkeepr

[1]: https://github.com/petervanderdoes/gitflow
[2]: http://www.partkeepr.org
[3]: https://www.docker.io
