From: Alexander Murashkin <AlexanderMurashkin@msn.com>
Subject: stripe_cache_size and journal (cache) in write-back mode
Date: Tue, 23 Jun 2020 16:01:58 -0500
Message-ID: <CH2PR22MB1768B9C137438BD5F512A73BD5940@CH2PR22MB1768.namprd22.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear MD,

After reading md documentation describing stripe_cache_size and journal 
(cache) in write-back mode, I found some inconsistencies

- sometimes the documentation states that the cache is for RAID 4/5/6, 
sometimes just for RAID 5
- it is nothing explicitly said about the cache block device size and 
how one is related to the memory cache size
- it is stated that the memory cache <includes> the same data stored on 
cache disk - that is somewhat ambiguous
- stripe_cache_size is the number of pages per device, but it is also 
called the number of entries

Here are some statements about the journal. Could somebody confirm that 
they are true (or not)?

- the journal and all its features can be used with md RAID 4/5/6
- references to RAID 5 only are wrong (in regards to the journal)
- cache block device size in bytes shall be the same as memory cache 
size in bytes
- any extra block device or memory space (larger than the minimum of 
cache block device and memory cache sizes) is not used
- the cache block device and the memory cache contain the same data
- the cache entry is exactly one page (so the number of pages and the 
number of entries are the same)

Below are few extracts from the related documentation, for your convenience.

md(4)
====

     md/stripe_cache_size
         This is only available on RAID5 and RAID6. It records the size 
(in pages per device) of the stripe cache which
         is used for synchronising all write operations to the array and 
all read operations if the array is degraded.
         memory_consumed = system_page_size * nr_disks * stripe_cache_size

https://www.kernel.org/doc/Documentation/md/raid5-cache.txt
=======================================

RAID5 cache
------------------

Raid 4/5/6 could include an extra disk for data cache...

write-back mode:
------------------------

Write-back cache will aggregate the data and flush the data to RAID 
disks only after the data becomes a full stripe write...
In write-back mode, MD also caches data in memory. The memory cache 
includes the same data stored on cache disk, ...
A user can configure the size by: echo "2048" > 
/sys/block/md0/md/stripe_cache_size

The implementation:
-----------------------------

In write-back mode, MD writes IO data to the log and reports IO 
completion. The data is also fully cached in memory at that
time, which means read must query memory cache. If some conditions are 
met, MD will flush the data to RAID disks
... MD will write both data and parity into RAID disks, then MD can 
release the memory cache. The flush conditions could be
stripe becomes a full stripe write, free cache disk space is low or free 
in-kernel memory cache space is low.

https://www.kernel.org/doc/html/latest/admin-guide/md.html
======================================

stripe_cache_size (currently raid5 only)
     number of entries in the stripe cache...
