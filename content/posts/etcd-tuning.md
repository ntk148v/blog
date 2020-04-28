+++
title = "Etcd deployment"
date = 2020-04-28T11:24:04+07:00
lastmod = 2020-04-28T11:24:04+07:00
tags = ["tech", "etcd"]
categories = []
imgs = []
cover = ""  # image show on top
readingTime = true  # show reading time after article date
toc = true
comments = true
justify = false  # text-align: justify;
single = false  # display as a single page, hide navigation on bottom, like as about page.
license = ""  # CC License
draft = true
+++

## Context

Etcd Version v3.4

## Requirements

### Number of nodes

* \>= 3 nodes. A etcd cluster needs a majority of nodes, a quorum to agree on updates to the cluster state. For a cluster with **n-members**, quorum is **(n/2)+1**.

### CPUs

* Etcd doesn't require a lot of CPU capacity.
* Typical clusters need **2-4 cores** to run smoothly.

### Memory

* Etcd performance depends on having enough memory (cache key-value data, tracking watchers...).
* Typical **8GB** is enough.

### Disk

* An etcd cluster is very sensitive to disk latencies. Since etcd must persist proposals to its log, disk activity from other processes may cause long `fync` latencies. The upshot is etcd may miss heartbeats, causing request timeouts and temporary leader loss. An etcd server can sometimes stably run alongside these processes when given a high disk priority.
* Check whether a disk is fast enough for etcd using [fio](https://github.com/axboe/fio). If the 99th percentile of fdatasync is **<10ms**, your storage is ok.

```
fio --rw=write --ioengine=sync --fdatasync=1 --directory=test-data --size=22m --bs=2300 --name=mytest
```
* **SSD** is recommened.

### Network

* Etcd cluster
