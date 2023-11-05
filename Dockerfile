	FROM openjdk:8
	ADD jarstaging/com/valaxy/demo-workshop/2.1.2/demo-workshop-2.0.2.jar Project.jar
	ENTRYPOINT ["java", "-jar", "Project.jar"]