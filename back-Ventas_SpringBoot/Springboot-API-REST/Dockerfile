# etapa 1
FROM maven:3.9.11-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# etapa 2
FROM eclipse-temurin:17-jdk
WORKDIR /app
RUN useradd -m appuser
COPY --from=build /app/target/*.jar app.jar
RUN chown -R appuser:appuser app.jar
USER appuser
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]