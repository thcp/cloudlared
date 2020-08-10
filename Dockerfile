# use a distroless base image with glibc
FROM gcr.io/distroless/base-debian10:nonroot
LABEL maintainer="https://github.com/thcp"
# copy our compiled binary
COPY cloudflared /usr/local/bin/

# run as non-privileged user
USER nonroot

# command / entrypoint of container
ENTRYPOINT ["cloudflared", "--no-autoupdate"]
CMD ["version"]