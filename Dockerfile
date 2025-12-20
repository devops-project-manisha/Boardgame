FROM eclipse-temurin:17.0.17_10-jre-alpine-3.22
COPY /target/*.jar app.jar
WORKDIR /app
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]