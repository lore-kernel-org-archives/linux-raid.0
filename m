From: Tregaron Bayly <tbayly@bluehost.com>
Subject: BUG  - raid 1 deadlock on handle_read_error / wait_barrier
Date: Thu, 21 Feb 2013 15:58:24 -0700
Message-ID: <1361487504.4863.54.camel@linux-lxtg.site>
Reply-To: tbayly@bluehost.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Symptom:
A RAID 1 array ends up with two threads (flush and raid1) stuck in D
state forever.  The array is inaccessible and the host must be restarted
to restore access to the array.

I have some scripted workloads that reproduce this within a maximum of a
couple hours on kernels from 3.6.11 - 3.8-rc7.  I cannot reproduce on
3.4.32.  3.5.7 ends up with three threads stuck in D state, but the
stacks are different from this bug (as it's EOL maybe of interest in
bisecting the problem?).

Details:

[flush-9:16]
[<ffffffffa009f1a4>] wait_barrier+0x124/0x180 [raid1]
[<ffffffffa00a2a15>] make_request+0x85/0xd50 [raid1]
[<ffffffff813653c3>] md_make_request+0xd3/0x200
[<ffffffff811f494a>] generic_make_request+0xca/0x100
[<ffffffff811f49f9>] submit_bio+0x79/0x160
[<ffffffff811808f8>] submit_bh+0x128/0x200
[<ffffffff81182fe0>] __block_write_full_page+0x1d0/0x330
[<ffffffff8118320e>] block_write_full_page_endio+0xce/0x100
[<ffffffff81183255>] block_write_full_page+0x15/0x20
[<ffffffff81187908>] blkdev_writepage+0x18/0x20
[<ffffffff810f73b7>] __writepage+0x17/0x40
[<ffffffff810f8543>] write_cache_pages+0x1d3/0x4c0
[<ffffffff810f8881>] generic_writepages+0x51/0x80
[<ffffffff810f88d0>] do_writepages+0x20/0x40
[<ffffffff811782bb>] __writeback_single_inode+0x3b/0x160
[<ffffffff8117a8a9>] writeback_sb_inodes+0x1e9/0x430
[<ffffffff8117ab8e>] __writeback_inodes_wb+0x9e/0xd0
[<ffffffff8117ae9b>] wb_writeback+0x24b/0x2e0
[<ffffffff8117b171>] wb_do_writeback+0x241/0x250
[<ffffffff8117b222>] bdi_writeback_thread+0xa2/0x250
[<ffffffff8106414e>] kthread+0xce/0xe0
[<ffffffff81488a6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

[md16-raid1]
[<ffffffffa009ffb9>] handle_read_error+0x119/0x790 [raid1]
[<ffffffffa00a0862>] raid1d+0x232/0x1060 [raid1]
[<ffffffff813675a7>] md_thread+0x117/0x150
[<ffffffff8106414e>] kthread+0xce/0xe0
[<ffffffff81488a6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

Both processes end up in wait_event_lock_irq() waiting for favorable
conditions in the struct r1conf to proceed.  These conditions obviously
seem to never arrive.  I placed printk statements in freeze_array() and
wait_barrier() directly before calling their respective
wait_event_lock_irq() and this is an example output:

Feb 20 17:47:35 sanclient kernel: [4946b55d-bb0a-7fce-54c8-ac90615dabc1] Attempting to freeze array: barrier (1), nr_waiting (1), nr_pending (5), nr_queued (3)
Feb 20 17:47:35 sanclient kernel: [4946b55d-bb0a-7fce-54c8-ac90615dabc1] Awaiting barrier: barrier (1), nr_waiting (2), nr_pending (5), nr_queued (3)
Feb 20 17:47:38 sanclient kernel: [4946b55d-bb0a-7fce-54c8-ac90615dabc1] Awaiting barrier: barrier (1), nr_waiting (3), nr_pending (5), nr_queued (3)

The flush seems to come after the attempt to handle the read error.  I
believe the incrementing nr_waiting comes from the multiple read
processes I have going as they get stuck behind this deadlock.

majienpeng may have been referring to this condition on the linux-raid
list a few days ago (http://www.spinics.net/lists/raid/msg42150.html)
when he stated "Above code is what's you said.  But it met read-error,
raid1d will blocked for ever.  The reason is freeze_array"

Environment:
A RAID 1 array built on top of two multipath maps
Devices underlying the maps are iscsi disks exported from a linux SAN
Multipath is configured to queue i/o if no path for 5 retries (polling
interval 5) before failing and causing the mirror to degrade.

Reproducible on kernels 3.6.11 and up (x86_64)
  
To reproduce, I create 10 raid 1 arrays on a client built on mpio over
iscsi.  For each of the arrays, I start the following to create some
writes:

$NODE=array_5; while :; do let TIME=($RANDOM % 10); let size=$RANDOM*6;
sleep $TIME; dd if=/dev/zero of=/dev/md/$NODE bs=1024 count=$size; done

I then start 10 processes each doing this to create some reads:

while :; do let SAN=($RANDOM % 10); dd if=/dev/md/array_$SAN
of=/dev/null bs=1024 count=50000; done

In a screen I start a script running in a loop that
monitors /proc/mdstat for failed arrays and does a fail/remove/re-add on
the failed disk.  (This is mainly so that I get more than one crack at
reproducing the bug since the timing never happens just right on one
try.)

Now on one of the iscsi servers I start a loop that sleeps a random
amount of time between 1-5 minutes then stops the export, sleeps again
and then restores the export.

The net effect of all this is that the disks on the initiator will queue
i/o for a while when the export is off and eventually fail.  In most
cases this happens gracefully and i/o will go to the remaining disk.  In
the failure case we get the behavior described here.  The test is setup
to restore the arrays and try again until the bug is hit.

We do see this situation in production with relative frequency so it's
not something that happens only in theory under artificial conditions.

Any help or insight here is much appreciated.

Tregaron Bayly
Systems Administrator
Bluehost, Inc.


