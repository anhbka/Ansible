### Performance Tuning for Redis

### 1. Disabling THP

Speed of RAM and memory bandwidth seem less critical for global performance especially for small objects. For large objects (>10 KB), it may become noticeable though. Usually, it is not really cost-effective to buy expensive fast memory modules to optimize Redis. For example, in a world case scenario, it is true that Linux kernel has transparent huge pages enabled. Redis incurs a big latency penalty after the fork call is used in order to persist on disk. Huge pages are the cause of the following issue:fork is called, two processes with shared huge pages are created.

In a busy instance, a few event loop runs will cause commands to target a few thousand of pages, causing the copy-on write of almost the whole process memory.

This will result in big latency and big memory usage.

Make sure to disable transparent huge pages using the following command:

```
echo never > /sys/kernel/mm/transparent_hugepage/enabled
```

### 2. Avoiding OOM

Redis runs slower on a VM compared to running without virtualization using the same hardware. If you have the chance to run Redis on a physical machine this is preferred. However this does not mean that Redis is slow in virtualized environments, the delivered performances are still very good and most of the serious performance issues you may incur in virtualized environments are due to over-provisioning, non-local disks with high latency, or old hypervisor software that have slow fork syscall implementation.

Enabling `overcommit_memory`

To add more safekeeping of your Redis, it’s best practice to avoid out of memory space issues. Setting kernel parameters to avoid OOM is recommended. If the overcommit memory value is 0 then there is a chance that your Redis will get an OOM (Out of Memory) error. To avoid that, you can do the following:

```
echo 1 > /proc/sys/vm/overcommit_memory

```
### 3. Set it persistently

```
echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf
```

Worth noting that 32 and 64 bit Redis instances do not have the same memory footprint.

### Set swappiness at the most least weight

Redis relies heavily on most of your memory resources. If memory is highly consumed by active processes running in your database host where Redis is hosted, it shall start to use the swap space which uses disk as a resource to store temporary memory allocation. Although that means it shall still allow your tasks to finish or run without terminating the whole system, it degrades the performance of your Redis from slow to drastic and that is not what you would want especially for a busy and high traffic load environment. To avoid this, run the following:

```
echo 1 > /proc/sys/vm/swappiness
```

### 4. Set it persistently

```
echo 'vm.swappiness = 1' >> /etc/sysctl.conf
```

### Choosing right memory allocators

Depending on the platform, Redis can be compiled against different memory allocators (libc malloc, jemalloc, tcmalloc), which may have different behaviors in term of raw speed, internal and external fragmentation. If you did not compile Redis yourself, you can use the INFO command to check the mem_allocator field. Please note most benchmarks do not run long enough to generate significant external fragmentation (contrary to production Redis instances).

Memory allocators that are supported by Redis do have differences when it comes to memory fragmentation outcomes when allocating large blocks of memory or even with small blocks of memory. If you need performance, tuning your Redis requires you to do a test with your own real data and do a benchmark to choose the most suitable memory allocator for your own data.

### 4. Memory Usage

Redis will use all of your available memory in the server unless this is configured. This is the default nature of Redis, so setting it to take around 75-85% of your memory dedicated for Redis makes sense. Make sure that Redis is not running on a shared server but on a dedicated environment setup. To change this, edit your redis.conf just like below,

```
# Setting it to 16Gib
maxmemory 17179869184
```

Alternatively, you can also run the command below to set it dynamically and also apply changes in your redis.conf,

```
CONFIG SET maxmemory 
CONFIG REWRITE
```

### 5. Tuning Redis Config

There are notable parameters that you can set to tune up your Redis performance. These parameters helps boost performance for your Redis especially for handling large traffic and managing large data objects.

### 6. TCP-KeepAlive

Keepalive is a method to allow the same TCP connection for HTTP conversation instead of opening a new one with each new request.

In simple words, if the keepalive is off the Redis will open a new connection for every request which will slow down its performance. If the keepalive is on then Redis will use the same TCP connection for requests.

To enable TCP keepalive, edit your redis config file and enable or update this value as shown below:

Editing default config file `/etc/redis/redis.conf`

Update the value to 0

```
tcp-keepalive 0
```

Disable saving redis to disk in redis.conf

Redis will attempt to persist the data to disk. While redis forks for this process, it still slows everything down.

Comment out the lines that start with save

```
#save 900 1
#save 300 10
#save 60 10000
```

If you need to persist the data, run a slave and use that to persist data as it will cause less of a slowdown.

### 8. TCP-backlog

Newer versions of redis have their own backlog set to 511 and you will need this to be higher if you have many connections. To do this, edit your redis config file and add the following for example,

```
# TCP listen() backlog.
# In high requests-per-second environments you need an high backlog in order
# make sure to raise both the value of somaxconn and tcp_max_syn_backlog
tcp-backlog 65536
```

### 9. Set maxclients

The default is `10000` and if you have many connections you may need to go higher. Otherwise if you have low on resources but are running on an efficient sharding horizontally using Redis cluster, then lowering it down to make sure it doesn’t produce any bottlenecks. To do that, just edit or change the value in your redis config as follows,

```
# Once the limit is reached Redis will close all the new connections sending
# an error 'max number of clients reached'.
maxclients 10000
```

### 10. Redis Persistence

When using Redis for persistence storage, the best option for optimal and performant Redis is to enable both AOF and RDB. Using RDB or AOF alone possesses disadvantages of its own and might place you to a critical encounter. This is the general indication that you should use both persistence methods if you want a degree of data safety comparable to what PostgreSQL can provide you.

If you care a lot about your data, but still can live with a few minutes of data loss in case of disasters, you can simply use RDB alone. There are many users using AOF alone, but the Redis community discourages it since having an RDB snapshot from time to time is a great idea for doing database backups, for faster restarts, and in the event of bugs in the AOF engine.

It is also likely that in the future release of Redis, they will likely end up unifying AOF and RDB into a single persistence model and for the long term plan.