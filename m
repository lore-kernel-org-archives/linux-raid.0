From: Shaohua Li <shli@fb.com>
Subject: Re: [RFC] raid5: add a log device to fix raid5/6 write hole issue
Date: Wed, 8 Apr 2015 17:43:11 -0700
Message-ID: <20150409004238.GA186860@devbig257.prn2.facebook.com>
References: <20150330222459.GA575371@devbig257.prn2.facebook.com>
 <20150402085312.5ea3d518@notabene.brown>
 <20150401234055.GA3375744@devbig257.prn2.facebook.com>
 <20150402111941.104d0633@notabene.brown>
 <20150402040749.GA4025688@devbig257.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150402040749.GA4025688@devbig257.prn2.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: dan.j.williams@intel.com, linux-raid@vger.kernel.org, songliubraving@fb.com, Kernel-team@fb.com
List-Id: linux-raid.ids

Hi,
This is what I'm working on now, and hopefully had the basic code
running next week. The new design will do cache and fix the write hole
issue too. Before I post the code out, I'd like to check if the design
has obvious issues.

Thanks,
Shaohua

Main goal is to aggregate write IO to hopefully make full stripe IO and fix the
write hole issue. This might speed up read too, but it's not optimized for
read, eg, we don't proactivly cache data for read. The aggregation makes a lot
of sense for workloads which sequentially write to several files. Such
workloads are popular in today's datacenter.

Here cache = cache disk, generally SSD. raid = raid array or raid disks
(excluding cache disk)
-------------------------
cache layout will like this:

|super|chunk descriptor|chunk data|

We divide cache to equal sized chunks. each chunk will have a descriptor.
Its size will be raid_chunk_size * raid_disks. That is the cache chunk can
store a whole raid chunk data and parity.

Write IO will store to cache chunks first and then flush to raid chunks. We use
fixed size chunk:
-manage cache space easily. We don't need a complex tree-like index

-flush data from cache to raid easily. data and parity are in the same chunk

-reclaim space is easy. when there is no free chunk in cache, we must try to
free some chunks, eg, reclaim. We do reclaim in chunk unit. reclaim a chunk
just means flush the chunk from cache to raid. If we use complex data
structure, we will need garbage collection and so on.

-The downside is we waste space. Eg, a single 4k data will use a whole chunk in
cache. But we can reclaim chunks with low utilization quickly to mitgate this
issue partially.

--------------------
chunk descriptor looks like this:
chunk_desc {
	u64 seq;
	u64 raid_chunk_index;
	u32 state;
	u8 bitmaps[];
}

seq: seq can be used to implement LRU-like algorithm for chunk reclaim. Every
time data is written to the chunk, we update the chunk's seq. When we flush a
chunk from cache to raid, we freeze the chunk (eg, the chunk can't accept new
IO). If there is new IO, we write the new IO to another chunk. The new chunk
will have a bigger seq than original chunk. crash and reboot can use the seq to
detinguish which chunk is newer.

raid_chunk_index: where the chunk should be flushed to raid

state: chunk state. Currently I defined 3 states
-FREE, the chunk is free
-RUNNING, the chunk maps to raid chunk and accepts new IO
-PARITY_INCORE, the chunk has both data and parity stored in cache

bitmaps: each page of data and parity has one bit. 1 means present. Store data
bits first.

-----IO READ PATH------
IO READ will check each chunk desc. If data is present in cache, dispatch to
cache. otherwise to raid.

-----IO WRITE PATH------
1. find or create a chunk in cache
2. write to cache
3. write descriptor

We write descriptor immediately in asynchronous way to reduce data loss, the
chunk will be RUNNING state.

-For normal write, IO return after 2. This will cut latency too. If there is a
crash, the chunk state might be FREE or bitmap isn't set. In either case, this
is the first write to the chunk, IO READ will read raid and get old data. We
meet the symantics. If data isn't in cache, we will read old data in cache, we
meet the symantics too.

-For FUA write, 2 will be a FUA write. When 2 finishes, run 3 with FUA. IO
return after 3. Crash after IO return deosn't impact symantics. We will read
old or new data if crash happens before IO return, which is the similar like
the normal write case.

-For FLUSH, wait all previous descriptor write finish and then flush cache disk
cache. In this way, we guarantee all previous write hit cache.

-----chunk reclaim--------
1. select a chunk
2. freeze the chunk
3. copy chunk data from cache to raid, so stripe state machine runs, eg,
calculate parity and so on
4. Hook to raid5 run_io. We write parity to cache
5. flush cache disk cache
6. mark descriptor PARITY_INCORE, and WRITE_FUA to cache
7. raid5 run_io continue run. data and parity write to raid disks
8. flush all raid disk cache
9. mark descriptor FREE, WRITE_FUA to cache

We will batch several chunks for reclaim for better performance. FUA write can
be replaced with FLUSH too.

If there is a crash before 6, descriptor state will be RUNNING. Recovery just
need discard the parity bitmap. If there is a crash before 9, descriptor state
will be PARITY_INCORE, recovery must copy both data and parity to raid.
