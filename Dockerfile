# Compiler image
# -------------------------------------------------------------------------------------------------
FROM alpine:3.13.5 AS compiler

WORKDIR /root

RUN apk --no-cache add \
    gcc \
    g++ \
    build-base \
    cmake \
    gmp-dev \
    git

COPY . .
RUN /bin/sh ./make_devel.sh

# Runtime image
# -------------------------------------------------------------------------------------------------
FROM alpine:3.13.5 AS runtime

WORKDIR /root

RUN apk --no-cache add \
    gmp-dev \
    libsodium-dev

COPY --from=compiler /root/build /usr/lib/skynet-plotter
RUN ln -s /usr/lib/skynet-plotter/skynet_plot /usr/bin/skynet_plot

ENTRYPOINT ["/usr/bin/skynet_plot"]
