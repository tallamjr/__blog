name := "SimpleApp"

version := "1.0"

scalaVersion := "2.12.8"

enablePlugins(JavaAppPackaging)

enablePlugins(DockerPlugin)

// change the name of the project adding the prefix of the user
packageName in Docker := "tallamjr/" +  packageName.value
//the base docker images
dockerBaseImage := "java:8-jre"
//the exposed port
dockerExposedPorts := Seq(9000)
//exposed volumes
dockerExposedVolumes := Seq("/opt/docker/logs")
