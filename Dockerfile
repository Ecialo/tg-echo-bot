# Original recipe by Tim Spence: https://medium.com/permutive/optimized-docker-builds-for-haskell-76a9808eb10b

FROM haskell:latest AS dependencies

RUN mkdir /opt/build
WORKDIR /opt/build

# GHC dynamically links its compilation targets to lib gmp
RUN apt-get update \
  && apt-get download libgmp10
RUN mv libgmp*.deb libgmp.deb

# Docker build should not use cached layer if any of these is modified
COPY stack.yaml package.yaml stack.yaml.lock /opt/build/
RUN stack build --system-ghc --dependencies-only


# -----

FROM haskell:latest AS build

COPY --from=dependencies /root/.stack /root/.stack
COPY . /opt/build/

WORKDIR /opt/build

RUN stack build --system-ghc

RUN mv "$(stack path --local-install-root --system-ghc)/bin" /opt/build/bin


# -----

# TODO: It's possible to shrink the image further by using alpine:latest and replacing `apt update && apt install ...` with `apk add ...`
FROM ubuntu:latest AS app
RUN mkdir -p /opt/app
WORKDIR /opt/app

# Install lib gmp
COPY --from=dependencies /opt/build/libgmp.deb /tmp
RUN apt update && \
    apt install libgmp10 ca-certificates --yes

COPY --from=build /opt/build/bin .

ENTRYPOINT ["/opt/app/tg-echo-drill-exe"]
