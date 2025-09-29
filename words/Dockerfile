# ⚠️ IMPORTANT NOTE
# This Dockerfile has been deliberately written with many stages,
# to show how this _could_ be done. In the real world, we would
# likely pick one specific way to build our images, or maybe two
# (perahaps using a full JDK locally for easier debug, and then
# native-image in prod if we need the ultra-fast start times and
# smaller images at the expense of longer builds and potentiel
# issues with introspection), so our Dockerfile wouldn't be that
# long. We could also have written multiple Dockerfiles.

FROM maven
WORKDIR /src

# Copy the file describing the dependencies first.
COPY pom.xml .

# Use maven to install the dependencies.
RUN --mount=type=cache,target=/root/.m2 \
    mvn verify

# Now, copy the source files for our application.
# Remember that when copying a directory, we generally
# *do not* to do "COPY src ." otherwise the content of
# "src" gets copied to the directory (instead of
# creating a subdirectory named "src").
COPY src src

# Build the code. Note: this will place multiple
# JAR files in a directory named "target". There
# will be our compiled code ("words.jar") but also
# its dependencies.
RUN --mount=type=cache,target=/root/.m2 \
    mvn verify

# run-with-jre: run with a "normal" JRE.
# We pick an older JRE, which will be much smaller.
# We also pick one based on Alpine, which will also
# result in a smaller image at the end.
FROM eclipse-temurin:8-jre-alpine AS run-with-jre

# Copy the "target" directory.
COPY --from=0 /src/target /target

# We use the "exec" shell built-in here, to make
# sure that the program executes as PID 1 and
# therefore receives signals correctly.
CMD exec java -Xmx8m -Xms8m -jar target/words.jar

# In this stage, we use jlink to build a custom JVM.
FROM eclipse-temurin:17-alpine AS jlink
WORKDIR target

# Obtain the compiled JAR file from the initial build stage.
COPY --from=0 /src/target .

# Compute the list of modules used by our JAR file.
RUN jdeps --print-module-deps --ignore-missing-deps words.jar > java.modules

# Generate a JVM with the corresponding modules.
RUN jlink --strip-debug --add-modules $(cat java.modules) --output /java

# Now put together an image with the JVM and our JAR file.
FROM alpine AS run-with-jlink
COPY --from=0 /src/target /target
COPY --from=jlink /java /java
CMD exec /java/bin/java -Xmx8m -Xms8m -jar /target/words.jar

# In this stage, we use native-image to build a native binary
# (as opposed to a JAR file).
# Note: this can be very slow on older machines! (5-10 minutes.)
FROM ghcr.io/graalvm/native-image-community:25 AS native-image-glibc
WORKDIR /target

# Obtain the JAR file.
COPY --from=0 /src/target /target

# Generate the binary file.
RUN native-image -jar words.jar

# Now put together an image to run the native binary.
FROM ubuntu AS run-with-native-image-glibc
COPY --from=native-image-glibc /target/words .
CMD ["./words"]

# And finally, do the same thing, but to generate a static binary.
# This requires using musl with native image.
FROM ghcr.io/graalvm/native-image-community:25-muslib AS native-image-muslib
WORKDIR /target
COPY --from=0 /src/target /target
RUN native-image -jar words.jar --static --libc=musl
FROM scratch AS run-with-native-image-static
COPY --from=native-image-muslib /target/words .
CMD ["./words"]

