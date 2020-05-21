---
draft: false
title: "Using PySpark to call compiled Scala from Python"
author: "Tarek Allam Jr"
date: 2020-05-20
category: tutorials
tags: [reproducibility, programming]
---

Calling compiled Scala code inside the JVM from Python using PySpark

<!--more-->

There is no doubt that Java and Scala are the de-facto languages for Data Engineering, whilst Python
is certainly the front runner for language of choice with Data Scientists. Spark; a framework for
distributed data analytics is written in Scala but allows for usage in Python, R and Java.
Interoperability between Java and Scala is a no briner since Scala compiles down to Java byte code,
but call Scala from Python is a little more involved, but the process is very simple.

The code used in this post builds upon the code used in a previous post and has the standard maven
directory layout. We will be calling `simple.SimpleApp.hello()` function to print `"Hello, World!"`.


The simple Scala we will use is the following:

```bash
$ cat -n src/main/scala/simple/SimpleApp.scala

 1	package simple;
 2
 3	object SimpleApp {
 4	  def hello(): Unit = {
 5	    println("Hello, Wolrd")
 6	  }
 7	}

```

This will then be compiled and packaged using `sbt` to created a `.jar` file that can be included in
the running JVM instance when launching Spark. Thus, after running:

```bash
$ sbt clean compile package

[info] Loading settings for project simpleapp-build from plugins.sbt ...
[info] Loading project definition from /Users/tallamjr/www/blog/code/posts/2020-05-20-Scala-Python-JVM/simpleApp/project
[info] Loading settings for project simpleapp from build.sbt ...
[info] Set current project to SimpleApp (in build file:/Users/tallamjr/www/blog/code/posts/2020-05-20-Scala-Python-JVM/simpleApp/)
[info] Executing in batch mode. For better performance use sbt's shell
[success] Total time: 0 s, completed 21-May-2020 13:18:19
[info] Compiling 1 Scala source to /Users/tallamjr/www/blog/code/posts/2020-05-20-Scala-Python-JVM/simpleApp/target/scala-2.12/classes ...
[success] Total time: 7 s, completed 21-May-2020 13:18:25
[success] Total time: 0 s, completed 21-May-2020 13:18:26

```

We obtain `target/scala-2.12/simpleapp_2.12-1.0.jar` which is supplied to Spark like so:

```bash
$ spark-submit --driver-class-path target/scala-2.12/simpleapp_2.12-1.0.jar simpleSpark/main.py

```

`simpleSpark/main.py` is the where the `pyspark` code lives that will be calling the Scala function,
let's have a look into that file:

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .master("local[*]") \
    .appName("simpleSpark") \
    .getOrCreate()

sc = spark.sparkContext
sc.setLogLevel("ERROR")


def logLevel(sc):
    # REF: https://stackoverflow.com/questions/25193488/how-to-turn-off-info-logging-in-spark
    log4jLogger = sc._jvm.org.apache.log4j
    log4jLogger.Logger.getLogger("org").setLevel(log4jLogger.Level.ERROR)
    log = log4jLogger.LogManager.getLogger(__name__)
    log.warn("Custom WARN message")


logLevel(spark)


print(spark.range(5000).where("id > 500").selectExpr("sum(id)").collect())

sc._jvm.simple.SimpleApp.hello()

```

There is a bit of boilerplate to get the session started and some customisation with logging going
on but the key lines of code are:

```python
...
 8  sc = spark.sparkContext
...
25  sc._jvm.simple.SimpleApp.hello()
```

The resulting output after running `spark-submit` is:

```bash
$ spark-submit --driver-class-path target/scala-2.12/simpleapp_2.12-1.0.jar simpleSpark/main.py

20/05/21 13:26:02 WARN Utils: Your hostname, Tareks-MacBook-Pro.local resolves to a loopback address: 127.0.0.1; using 192.168.0.178 instead (on interface en0)
20/05/21 13:26:02 WARN Utils: Set SPARK_LOCAL_IP if you need to bind to another address
20/05/21 13:26:02 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
[Row(sum(id)=12372250)]
Hello, Wolrd!
```

# References

This post was inspired by Alexis Seigneurin's much more detailed post [Spark - Calling Scala code from PySpark](https://aseigneurin.github.io/2016/09/01/spark-calling-scala-code-from-pyspark.html) which I highly recommend reading.

