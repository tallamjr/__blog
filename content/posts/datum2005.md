---
draft: true
title: "[DATUM-2005] "
author: "Tarek Allam Jr"
date: 2020-05-20
categories: [news]
tags: [datum, data-engineering, open-source]
---

Monthly roundup of news in Open Source, Data Science and Data Engineering circles. _May 2020
edition_.

<!--more-->

- [KIP-500](#kip500) -- The end of Zookeeper dependecy for Kafka
- [GTC20](#gtc20) -- NVIDIA's Global Technology Conference 2020

# <a name="kip500b"></a>KIP-500 -- Coming to life

<center>
{{< tweet 1261786929101565952 >}}
</center>

### What is KIP-500?

KIP refers to the Kafka-Improvement-Proposal, much like PEP (Python Enhancement Proposals)
developers can influence the development of Kafka by proposing ideas. KIP-500 is motivated by:
>Currently, Kafka uses ZooKeeper to store its metadata about partitions and brokers, and to elect a
>broker to be the Kafka Controller.  We would like to remove this dependency on ZooKeeper.  This
>will enable us to manage metadata in a more scalable and robust way, enabling support for more
>partitions.  It will also simplify the deployment and configuration of Kafka.

This is neatly visualised by the image below:

{{< figure src="https://cwiki.apache.org/confluence/download/attachments/123898922/a.png?version=1&modificationDate=1564694752000&api=v2" class="alignright">}}

Zookeeper has served Kafka well for many years, but the drive to develop a self-contained <a
href="#" class="tooltip tooltip-left" title="the minimum number of members of an assembly or society that must be
present at any of its meetings to make the proceedings of that meeting valid.">quorum</a> controller
has been on the cards for some time. Before we go into details of the latests news, let's first
breakdown what this means and explain a few concepts for the uninitiated.

### What is Raft?

RAFT is a consensus protocol that helps maintain state among a set of workers. Zookeeper has their
own implementation of a consensus protocol called Zookeeper Atomic Broadcast Protocol (ZAB).

There has recently been an interesting paper to evaluate the best consensus protocol

# <a name="gtc20"></a>NVIDIA's Global Technology Conference 2020

<!-- <center> -->
<!-- <embed -->
<!-- <video type=video/webm src=https://developer.download.nvidia.com/video/gputechconf/gtc/2020/secure/s21764/video-480p.mp4?7fGvEsX3-_hTdIWKs7XaDIESMHphS7T4IjbmeQNQ-KxvGn_P_eYSnb5y5Oc13KIDYiCV479Ez83lE1gXWgKv8_c1KnKjk4PEWf4x8j7GCVbYgtC9dsdcVBwee_P7RdaOzVayQ5JekmMVWrN9l-m6-wRjd0Z4vQ width="600" height="350" autoplay="0" autostart="0"></video> -->

<!-- </center> -->

{{< youtube tpeGZ7nm0J0 >}}

### Apache Spark 3.0 on the Horizon

<!-- {{< figure src="/blog/img/posts/2016-11-12-Matlab-R-Julia-Notebooks/newprojectlist.png" class="alignright">}} -->

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



