# syntax=docker/dockerfile:experimental
FROM gradle:7.6.2-jdk17 AS build
WORKDIR /workspace/app

# Copy only gradle files to container so we can install them
COPY ./build.gradle ./settings.gradle /workspace/app/

# install dependencies. This will be cached by the docker layered cache. This command will fail because the
# app code is still missing, so we return 0 so docker thinks the command executed successfully (but the
# dependencies are still downloaded even if the command fails so now we have them cached)
RUN gradle clean build -x test || return 0

# Now copy the actual app code and build it
COPY . /workspace/app
RUN gradle clean build -x test
RUN mkdir -p build/dependency && (cd build/dependency; jar -xf ../libs/*-SNAPSHOT.jar)

FROM eclipse-temurin:17-jdk
VOLUME /tmp
ARG DEPENDENCY=/workspace/app/build/dependency
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app
ENTRYPOINT ["java","-cp","app:app/lib/*","de.unistuttgart.iste.gits.template.TemplateForMicroservicesApplication"]