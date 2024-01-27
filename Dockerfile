# Use Alpine Linux for small container size.
FROM alpine:3.19

# Update apk index
RUN apk update
# Install runtime dependencies
RUN apk add libstdc++ openssl-dev
# Install build dependencies
RUN apk add build-base boost-dev

# Copy over source files
WORKDIR /dnsseed
COPY Makefile *.h *.cpp ./

# Make binary
RUN make dnsseed

# Copy binary to /usr/local/bin
RUN cp dnsseed /usr/local/bin

# Remove build dependencies
RUN apk del --purge build-base boost-dev
# Clean apk cache
RUN apk cache clean
RUN rm -rf /var/cache/apk/*

# Reset workdir
WORKDIR /

# Remove source files
RUN rm -rf /dnsseed

# Expose port 5353
EXPOSE 5353

# Run dnsseed
ENTRYPOINT [ "/usr/local/bin/dnsseed" ]
CMD [ "-s", "seed.tradecraft.io", "-s", "us-west-2.aws.seed.tradecraft.io", "-s", "eu-west-1.aws.seed.tradecraft.io", "-s", "ap-northeast-1.aws.node.tradecraft.io", "-h", "seed.tradecraft.localhost", "-n", "node.tradecraft.localhost", "-m", "seed@tradecraft.io", "-p", "5353", "--p2port", "8639", "--magic", "2cfe7e6d", "--minheight", "1" ]
