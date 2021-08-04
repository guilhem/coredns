ARG BUILD_TYPE=multi-stage

FROM golang:1.16 as build-multi-stage

WORKDIR /app
COPY . .
RUN make

FROM scratch as build-outside

COPY coredns /app/coredns

FROM build-${BUILD_TYPE} AS after-condition

FROM gcr.io/distroless/static

COPY --from=after-condition /app/coredns /coredns

EXPOSE 53 53/udp
ENTRYPOINT ["/coredns"]
