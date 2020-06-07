---
draft: false
title: "Packaging Scala Applications"
author: "Tarek Allam Jr"
date: 2020-02-10
category: tutorials
tags: [reproducibility, programming]
---

Scala compiles down to Java byte code, which can then be run on any system running the JVM. It
would be nice if one could extend this to native system binaries that can be run anywhere. Here I
walk through the steps of getting SBT-Native-Packager to create a native binary as well as a docker
image that can run my 'Hello World' application.

<!--more-->

For this short post, I have created a "simpleApp" which is a simple "Hello, World!" application in
Scala. The example code for this post is in the standard maven directory layout, i.e:

```bash
.
├── build.sbt
├── project
│   ├── build.properties
│   ├── plugins.sbt
│   ├── project
│   └── target
├── src
│   ├── main
│   │   └── scala
│   │       └── simple
│   │           └── SimpleApp.scala
│   └── test
│       └── scala
│           └── simple
└── target

```

and with the `SimpleApp.scala` code looking like so:

```python
package simple;

object SimpleApp {
def main(args: Array[String]): Unit = {
  println("Hello, world!")
}
}

```

Assuming you are familiar with `sbt`, one can use the following to compile the program to
Java byte code and run:

```bash
$ cd simpleApp
$ sbt clean compile run
[info] Loading settings for project simpleapp-build from plugins.sbt ...
[info] Loading project definition from /Users/tallamjr/www/blog/code/posts/2020-02-10-SBT-native-packaging/simpleApp/project
[info] Loading settings for project simpleapp from build.sbt ...
[info] Set current project to SimpleSBTProject (in build file:/Users/tallamjr/www/blog/code/posts/2020-02-10-SBT-native-packaging/simpleApp/)
[info] Executing in batch mode. For better performance use sbt's shell
[success] Total time: 0 s, completed 21-May-2020 11:16:49
[info] Compiling 1 Scala source to /Users/tallamjr/www/blog/code/posts/2020-02-10-SBT-native-packaging/simpleApp/target/scala-2.12/classes ...
[success] Total time: 5 s, completed 21-May-2020 11:16:54
[info] running simple.SimpleApp
Hello, world!
[success] Total time: 0 s, completed 21-May-2020 11:16:54
```
Alternativly:

```bash
$ sbt "runMain simple.SimpleApp"
[info] Loading settings for project simpleapp-build from plugins.sbt ...
[info] Loading project definition from /Users/tallamjr/www/blog/code/posts/2020-02-10-SBT-native-packaging/simpleApp/project
[info] Loading settings for project simpleapp from build.sbt ...
[info] Set current project to SimpleSBTProject (in build file:/Users/tallamjr/www/blog/code/posts/2020-02-10-SBT-native-packaging/simpleApp/)
[info] Compiling 1 Scala source to /Users/tallamjr/www/blog/code/posts/2020-02-10-SBT-native-packaging/simpleApp/target/scala-2.12/classes ...
[info] running simple.SimpleApp
Hello, world!
[success] Total time: 4 s, completed 21-May-2020 11:22:34

```

Ok, great. We have a running Scala application built and run with `sbt`. But the point of this post
is that we want to run a native binary...

To achieve this `sbt-native-packager` plugin is used. Before we use it, one must ensure the plugin
is "installed" in the `project/plugins.sbt` file like so:

```bash
$ cat -n project/plugins.sbt

 1  logLevel := Level.Warn
 2
 3  // for autoplugins
 4  addSbtPlugin("com.typesafe.sbt" % "sbt-native-packager" % "1.6.1")
```

Furthermore we need to ensure we have set the right variables in the `build.sbt` file such as:

```bash
$ sed -n 1,7p build.sbt

name := "SimpleSBTProject"

version := "1.0"

scalaVersion := "2.12.8"

enablePlugins(JavaAppPackaging)
```

With these two modified files and the project directory set up the way it is, we are ready to create
our binary using the `stage` directive for `sbt`.

```bash
$ sbt clean compile stage

[info] Loading settings for project simpleapp-build from plugins.sbt ...
[info] Loading project definition from /Users/tallamjr/www/blog/code/posts/2020-02-10-SBT-native-packaging/simpleApp/project
[info] Loading settings for project simpleapp from build.sbt ...
[info] Set current project to SimpleSBTProject (in build file:/Users/tallamjr/www/blog/code/posts/2020-02-10-SBT-native-packaging/simpleApp/)
[info] Executing in batch mode. For better performance use sbt's shell
[success] Total time: 0 s, completed 21-May-2020 11:29:50
[info] Compiling 1 Scala source to /Users/tallamjr/www/blog/code/posts/2020-02-10-SBT-native-packaging/simpleApp/target/scala-2.12/classes ...
[success] Total time: 5 s, completed 21-May-2020 11:29:55
[info] Main Scala API documentation to /Users/tallamjr/www/blog/code/posts/2020-02-10-SBT-native-packaging/simpleApp/target/scala-2.12/api...
[info] Wrote /Users/tallamjr/www/blog/code/posts/2020-02-10-SBT-native-packaging/simpleApp/target/scala-2.12/simplesbtproject_2.12-1.0.pom
model contains 3 documentable templates
[info] Main Scala API documentation successful.
[success] Total time: 2 s, completed 21-May-2020 11:29:56

```

Using `stage` creates a new set of files, found in the `target/universal` directory:

```bash
$ tree target/universal/
target/universal/
├── scripts
│   └── bin
│       ├── simplesbtproject
│       └── simplesbtproject.bat
└── stage
    ├── bin
    │   ├── simplesbtproject
    │   └── simplesbtproject.bat
    └── lib
        ├── org.scala-lang.scala-library-2.12.8.jar
        └── simplesbtproject.simplesbtproject-1.0.jar

5 directories, 6 files

```

Notice it creates a Unix and Windows version.

Now let's run it...

```bash
$ ./target/universal/stage/bin/simplesbtproject

Hello, world!
```

Success, we can run a single "binary" for our application. I put binary in quotation marks there
because it is not exactly a binary file that is created, and one would still need Java installed on
the system, but it allows a user to run a command like the above which is better suited for
production settings.

Ok, now that we can do this, "What about making a Docker image!" I hear you cry. This can also be
done with some minor additions to the `build.sbt` file with:

```bash
$ sed -n 9,18p build.sbt

enablePlugins(DockerPlugin)

// change the name of the project adding the prefix of the user
packageName in Docker := "tallamjr/" +  packageName.value
//the base docker images
dockerBaseImage := "java:8-jre"
//the exposed port
dockerExposedPorts := Seq(9000)
//exposed volumes
dockerExposedVolumes := Seq("/opt/docker/logs")

```

With this in place, we can use `publishLocal` to create a docker image locally, which, when built we
will run.

Just to convince ourselves a new docker images is created `docker images` reveals only other
projects after doing a `docker system prune -a`:

```bash
$ docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
machcoll_bluebird   latest              140ca65afae2        2 months ago        1.15GB
machcoll-img        dev-1bea126         38298723afa1        2 months ago        1.01GB
nats-metrics-img    master-9a39559      3af43d2f4bd7        2 months ago        1.1GB

```

Running `sbt publish:Local` creates the docker image for us (I have excluded much of the output for
brevity)

```bash
$ sbt publish:Local
...
[info] Built image tallamjr/simpleapp with tags [1.0]
[success] Total time: 53 s, completed 21-May-2020 11:46:06
```

Now when we do `docker images` again we should see our new docker image:

```bash
$ docker images

REPOSITORY           TAG                 IMAGE ID            CREATED              SIZE
tallamjr/simpleapp   1.0                 6eb32a8b2939        About a minute ago   317MB
machcoll_bluebird    latest              140ca65afae2        2 months ago         1.15GB
machcoll-img         dev-1bea126         38298723afa1        2 months ago         1.01GB
nats-metrics-img     master-9a39559      3af43d2f4bd7        2 months ago         1.1GB
java                 8-jre               e44d62cf8862        3 years ago          311MB

```

Let's test this:

```bash
$ docker run tallamjr/simpleapp:1.0

Hello, world!
```

So there we have it! `sbt-native-packager` is able to also publish to a docker registry and in
addition to standard scripts like the one above, one can also [create other formats](https://www.scala-sbt.org/sbt-native-packager/gettingstarted.html#create-a-package)

    universal:packageBin - Generates a universal zip file
    universal:packageZipTarball - Generates a universal tgz file
    debian:packageBin - Generates a deb
    docker:publishLocal - Builds a Docker image using the local Docker server
    rpm:packageBin - Generates an rpm
    universal:packageOsxDmg - Generates a DMG file with the same contents as the universal zip/tgz.
    windows:packageBin - Generates an MSI


For more check out the great documentation [here](https://www.scala-sbt.org/sbt-native-packager/index.html)

All the code for this post is available on [Github](https://github.com/tallamjr/blog/tree/master/code/posts)

<!-- {{< figure src="/blog/img/posts/2016-11-12-Matlab-R-Julia-Notebooks/newprojectlist.png" class="alignright">}} -->

<!-- - [Scala and SBT Introduction](#scala) -->
<!-- - [SBT-Native-Packager](#native) -->
<!-- - [Docker](#docker) -->

<!-- ```python -->
<!-- print(f"Numpy: {np.__version__}") -->
<!-- ``` -->

<!-- Say if I said something here -->

<!-- ```bash -->
<!-- $ echo "Hello World!" -->
<!-- ``` -->

<!-- ```scala -->
<!-- println("hello") -->
<!-- def somefunction(col: String) -->

<!-- val mate = Int 5 -->
<!-- ``` -->
<!-- # <a name="matlab"></a>MATLAB -->
