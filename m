From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 0/2] raid5: 65% sequential-write performance improvement,
	stripe-queue take2
Date: Tue, 03 Jul 2007 16:20:16 -0700
Message-ID: <20070703231838.17500.34505.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: raziebe@gmail.com, akpm@linux-foundation.org, davidsen@tmr.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The first take of the stripe-queue implementation[1] had a performance
limiting bug in __wait_for_inactive_queue.  Fixing that issue
drastically changed the performance characteristics.  The following data
from tiobench shows the relative performance difference of the
stripe-queue patchset.

Unit information
================
File size = megabytes
Blk Size  = bytes
Num Thr   = number of threads
Avg Rate  = relative throughput
CPU%      = relative percentage of CPU used during the test
CPU Eff   = Rate divided by CPU% - relative throughput per cpu load

Configuration
=============
Platform: 1200Mhz iop348 with 4-disk sata_vsc array
mdadm --create /dev/md0 /dev/sd[abcd] -n 4 -l 5
mkfs.ext2 /dev/md0
mount /dev/md0 /mnt/raid
tiobench --size 2048 --numruns 5 --block 4096 --block 131072 --dir /mnt/raid

Sequential Reads
                File    Blk     Num     Avg     Maximum CPU
Identifier      Size    Size    Thr     Rate    (CPU%)  Eff
--------------- ------  -----   ---     ------  ------  -----
2.6.22-rc7-iop1 2048    4096    1       0%      4%      -3%
2.6.22-rc7-iop1 2048    4096    2       -38%    -33%    -8%
2.6.22-rc7-iop1 2048    4096    4       -35%    -30%    -8%
2.6.22-rc7-iop1 2048    4096    8       -14%    -11%    -3%
2.6.22-rc7-iop1 2048    13107   1       2%      1%      2%
2.6.22-rc7-iop1 2048    13107   2       -11%    -10%    -2%
2.6.22-rc7-iop1 2048    13107   4       -7%     -6%     -1%
2.6.22-rc7-iop1 2048    13107   8       -9%     -6%     -4%

Random  Reads
                File    Blk     Num     Avg     Maximum CPU
Identifier      Size    Size    Thr     Rate    (CPU%)  Eff
--------------- ------  -----   ---     ------  ------  -----
2.6.22-rc7-iop1 2048    4096    1       -9%     15%     -21%
2.6.22-rc7-iop1 2048    4096    2       -1%     -30%    42%
2.6.22-rc7-iop1 2048    4096    4       -14%    -22%    10%
2.6.22-rc7-iop1 2048    4096    8       -21%    -28%    9%
2.6.22-rc7-iop1 2048    13107   1       -8%     -4%     -4%
2.6.22-rc7-iop1 2048    13107   2       -13%    -13%    0%
2.6.22-rc7-iop1 2048    13107   4       -15%    -15%    0%
2.6.22-rc7-iop1 2048    13107   8       -13%    -13%    0%

Sequential Writes
                File    Blk     Num     Avg     Maximum CPU
Identifier      Size    Size    Thr     Rate    (CPU%)  Eff
--------------- ------  -----   ---     ------  ------  -----
2.6.22-rc7-iop1 2048    4096    1       25%     11%     12%
2.6.22-rc7-iop1 2048    4096    2       41%     42%     -1%
2.6.22-rc7-iop1 2048    4096    4       40%     18%     19%
2.6.22-rc7-iop1 2048    4096    8       15%     -5%     21%
2.6.22-rc7-iop1 2048    13107   1       65%     57%     4%
2.6.22-rc7-iop1 2048    13107   2       46%     36%     8%
2.6.22-rc7-iop1 2048    13107   4       24%     -7%     34%
2.6.22-rc7-iop1 2048    13107   8       28%     -15%    51%

Random  Writes
                File    Blk     Num     Avg     Maximum CPU
Identifier      Size    Size    Thr     Rate    (CPU%)  Eff
--------------- ------  -----   ---     ------  ------  -----
2.6.22-rc7-iop1 2048    4096    1       2%      -8%     11%
2.6.22-rc7-iop1 2048    4096    2       -1%     -19%    21%
2.6.22-rc7-iop1 2048    4096    4       2%      2%      0%
2.6.22-rc7-iop1 2048    4096    8       -1%     -28%    37%
2.6.22-rc7-iop1 2048    13107   1       2%      -3%     5%
2.6.22-rc7-iop1 2048    13107   2       3%      -4%     7%
2.6.22-rc7-iop1 2048    13107   4       4%      -3%     8%
2.6.22-rc7-iop1 2048    13107   8       5%      -9%     15%

The write performance numbers are better than I expected and would seem
to address the concerns raised in the thread "Odd (slow) RAID
performance"[2].  The read performance drop was not expected.  However,
the numbers suggest some additional changes to be made to the queuing
model.  Where read performance is dropping there appears to be an equal
drop in CPU utilization, which seems to suggest that pure read requests
be handled immediately without a trip to the the stripe-queue workqueue.

Although it is not shown in the above data, another positive aspect is that
increasing the cache size past a certain point causes the write performance
gains to erode.  In other words negative returns in contrast to diminishing
returns.  The stripe-queue can only carry out optimizations while the cache is
busy.  When the cache is large requests can be handled without waiting, and
performance approaches the original 1:1 (queue-to-stripe-head) model.  CPU
speed dictates the maximum effective cache size.  Once the CPU can no longer
keep the stripe-queue saturated performance falls off from the peak.  This is
a positive change because it shows that the new queuing model can produce higher
performance with less resources, but it does require more care when changing
'stripe_cache_size.'  The above numbers were taken with the default cache size
of 256.

Changes since take1:
* separate write and overwrite in the io_weight fields, i.e. an overwrite
  no longer implies a write
* rename queue_weight -> io_weight
* fix r5_io_weight_size
* implement support for sysfs changes to stripe_cache_size
* delete and re-add stripe queues from their management lists rather than
  moving them.  This guarantees that when the sq->count is non-zero the
  queue is not on a list (identical to stripe_head handling)
* __wait_for_inactive_queue was incorrectly using conf->inactive_blocked
  which is exclusively for the stripe_cache.  Added
  conf->inactive_queue_blocked and set the routine to wait until the
  number of active queues drops below 7/8's of the total before unblocking
  processing.  7/8's arises from the following: get_active_stripe waits
  for 3/4's of the stripe cache i.e. 1/4 inactive.  conf->max_nr_stripes /
  4 == conf->max_nr_stripes * STRIPE_QUEUE_SIZE / 8 iff STRIPE_QUEUE_SIZE
  == 2
* change raid5_congested to report whether the *queue* is congested, not
  the cache.

As before these patches are on top of the md-accel series:

	git://lost.foo-projects.org/~dwillia2/git/iop md-accel+experimental

For those wanting to test these changes in isolation from other major kernel
changes look for the upcoming 2.6.22-iop1 kernel release on SourceForge[3].

--
Dan

[1] http://marc.info/?l=linux-raid&m=118297138908827&w=2
[2] http://marc.info/?l=linux-raid&m=116489600902178&w=2
[3] https://sourceforge.net/projects/xscaleiop/
