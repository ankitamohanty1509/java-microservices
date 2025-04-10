FROM openjdk:11-jre-slim
COPY target/*.jar /app/
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
