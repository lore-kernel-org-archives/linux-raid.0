From: Shaohua Li <shli@kernel.org>
Subject: [patch 0/9 v2] raid5: improve write performance for fast storage
Date: Tue, 19 Jun 2012 09:59:41 +0800
Message-ID: <20120619015941.891400722@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

Hi,

Like raid 1/10, raid5 uses one thread to handle stripe. In a fast storage, the
thread becomes a bottleneck. raid5 can offload calculation like checksum to
async threads. And if storge is fast, scheduling async work and running async
work will introduce heavy lock contention of workqueue, which makes such
optimization useless. And calculation isn't the only bottleneck. For example,
in my test raid5 thread must handle > 450k requests per second. Just doing
dispatch and completion will make raid5 thread incapable. The only chance to
scale is using several threads to handle stripe.

Simpliy using several threads doesn't work. conf->device_lock is a global lock
which is heavily contended. patch 2-8 in the set are trying to address this
problem. With them, when several threads are handling stripe, device_lock is
still contended but takes much less cpu time and not the heavist locking any
more. Even the 9th patch isn't accepted, the patch 2-8 look good to merge.

I did stress test (block size range 1k - 64k with a small total size, so
overlap/stripe sharing guaranteed) with the patches and looks fine except a
wake_up issue which I fixed in the first patch. That issue isn't related to the
series, but I need it in stress test.

With the locking issue solved (at least largely), switching stripe handling to
multiple threads is trival.

Threads are still created in advance (default thread number is disk number) and
can be reconfigured by user. Automatically creating and reaping threads is
great, but I'm worrying about numa binding.

In a 3-disk raid5 setup, 2 extra threads can provide 130% throughput
improvement (double stripe_cache_size) and the throughput is pretty close to
theory value. With >=4 disks, the improvement is even bigger, for example, can
improve 200% for 4-disk setup, but the throughput is far less than theory
value, which is caused by several factors like request queue lock contention,
cache issue, latency introduced by how a stripe is handled in different disks.
Those factors need further investigations.

V1->V2:
1. fixed several issues pointed out by Neil and Dan.
2. fixed a wake_up issue.

Thanks,
Shaohua
