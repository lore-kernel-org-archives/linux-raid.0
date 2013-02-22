From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: Re: BUG  - raid 1 deadlock on handle_read_error / wait_barrier
Date: Thu, 21 Feb 2013 22:44:43 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1302212158470.29035@jlaw-desktop.mno.stratus.com>
References: <1361487504.4863.54.camel@linux-lxtg.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1361487504.4863.54.camel@linux-lxtg.site>
Sender: linux-raid-owner@vger.kernel.org
To: Tregaron Bayly <tbayly@bluehost.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Thu, 21 Feb 2013, Tregaron Bayly wrote:

> Symptom:
> A RAID 1 array ends up with two threads (flush and raid1) stuck in D
> state forever.  The array is inaccessible and the host must be restarted
> to restore access to the array.
> 
> I have some scripted workloads that reproduce this within a maximum of a
> couple hours on kernels from 3.6.11 - 3.8-rc7.  I cannot reproduce on
> 3.4.32.  3.5.7 ends up with three threads stuck in D state, but the
> stacks are different from this bug (as it's EOL maybe of interest in
> bisecting the problem?).
> 
> Details:
> 
> [flush-9:16]
> [<ffffffffa009f1a4>] wait_barrier+0x124/0x180 [raid1]
> [<ffffffffa00a2a15>] make_request+0x85/0xd50 [raid1]
> [<ffffffff813653c3>] md_make_request+0xd3/0x200
> [<ffffffff811f494a>] generic_make_request+0xca/0x100
> [<ffffffff811f49f9>] submit_bio+0x79/0x160
> [<ffffffff811808f8>] submit_bh+0x128/0x200
> [<ffffffff81182fe0>] __block_write_full_page+0x1d0/0x330
> [<ffffffff8118320e>] block_write_full_page_endio+0xce/0x100
> [<ffffffff81183255>] block_write_full_page+0x15/0x20
> [<ffffffff81187908>] blkdev_writepage+0x18/0x20
> [<ffffffff810f73b7>] __writepage+0x17/0x40
> [<ffffffff810f8543>] write_cache_pages+0x1d3/0x4c0
> [<ffffffff810f8881>] generic_writepages+0x51/0x80
> [<ffffffff810f88d0>] do_writepages+0x20/0x40
> [<ffffffff811782bb>] __writeback_single_inode+0x3b/0x160
> [<ffffffff8117a8a9>] writeback_sb_inodes+0x1e9/0x430
> [<ffffffff8117ab8e>] __writeback_inodes_wb+0x9e/0xd0
> [<ffffffff8117ae9b>] wb_writeback+0x24b/0x2e0
> [<ffffffff8117b171>] wb_do_writeback+0x241/0x250
> [<ffffffff8117b222>] bdi_writeback_thread+0xa2/0x250
> [<ffffffff8106414e>] kthread+0xce/0xe0
> [<ffffffff81488a6c>] ret_from_fork+0x7c/0xb0
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> [md16-raid1]
> [<ffffffffa009ffb9>] handle_read_error+0x119/0x790 [raid1]
> [<ffffffffa00a0862>] raid1d+0x232/0x1060 [raid1]
> [<ffffffff813675a7>] md_thread+0x117/0x150
> [<ffffffff8106414e>] kthread+0xce/0xe0
> [<ffffffff81488a6c>] ret_from_fork+0x7c/0xb0
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Both processes end up in wait_event_lock_irq() waiting for favorable
> conditions in the struct r1conf to proceed.  These conditions obviously
> seem to never arrive.  I placed printk statements in freeze_array() and
> wait_barrier() directly before calling their respective
> wait_event_lock_irq() and this is an example output:
> 
> Feb 20 17:47:35 sanclient kernel: [4946b55d-bb0a-7fce-54c8-ac90615dabc1] Attempting to freeze array: barrier (1), nr_waiting (1), nr_pending (5), nr_queued (3)
> Feb 20 17:47:35 sanclient kernel: [4946b55d-bb0a-7fce-54c8-ac90615dabc1] Awaiting barrier: barrier (1), nr_waiting (2), nr_pending (5), nr_queued (3)
> Feb 20 17:47:38 sanclient kernel: [4946b55d-bb0a-7fce-54c8-ac90615dabc1] Awaiting barrier: barrier (1), nr_waiting (3), nr_pending (5), nr_queued (3)
> 
> The flush seems to come after the attempt to handle the read error.  I
> believe the incrementing nr_waiting comes from the multiple read
> processes I have going as they get stuck behind this deadlock.
> 
> majienpeng may have been referring to this condition on the linux-raid
> list a few days ago (http://www.spinics.net/lists/raid/msg42150.html)
> when he stated "Above code is what's you said.  But it met read-error,
> raid1d will blocked for ever.  The reason is freeze_array"
> 
> Environment:
> A RAID 1 array built on top of two multipath maps
> Devices underlying the maps are iscsi disks exported from a linux SAN
> Multipath is configured to queue i/o if no path for 5 retries (polling
> interval 5) before failing and causing the mirror to degrade.
> 
> Reproducible on kernels 3.6.11 and up (x86_64)
>   
> To reproduce, I create 10 raid 1 arrays on a client built on mpio over
> iscsi.  For each of the arrays, I start the following to create some
> writes:
> 
> $NODE=array_5; while :; do let TIME=($RANDOM % 10); let size=$RANDOM*6;
> sleep $TIME; dd if=/dev/zero of=/dev/md/$NODE bs=1024 count=$size; done
> 
> I then start 10 processes each doing this to create some reads:
> 
> while :; do let SAN=($RANDOM % 10); dd if=/dev/md/array_$SAN
> of=/dev/null bs=1024 count=50000; done
> 
> In a screen I start a script running in a loop that
> monitors /proc/mdstat for failed arrays and does a fail/remove/re-add on
> the failed disk.  (This is mainly so that I get more than one crack at
> reproducing the bug since the timing never happens just right on one
> try.)
> 
> Now on one of the iscsi servers I start a loop that sleeps a random
> amount of time between 1-5 minutes then stops the export, sleeps again
> and then restores the export.
> 
> The net effect of all this is that the disks on the initiator will queue
> i/o for a while when the export is off and eventually fail.  In most
> cases this happens gracefully and i/o will go to the remaining disk.  In
> the failure case we get the behavior described here.  The test is setup
> to restore the arrays and try again until the bug is hit.
> 
> We do see this situation in production with relative frequency so it's
> not something that happens only in theory under artificial conditions.
> 
> Any help or insight here is much appreciated.
> 
> Tregaron Bayly
> Systems Administrator
> Bluehost, Inc.

Hi Tregaron,

I've been seeing a similar looking hang over the past few days.  In my 
testing, I'm running 3.7.0-rcX with direct IO via fio out to an MD RAID1 
array during surprise disk removals.  (We script fail/remove/add when the 
controller is hotplugged.)  This week I have seen three instances of the 
hang, usually after ~5 hours of testing, but once I added debugging 
printk's it went away :(  

For reference, my traces look like:

INFO: task md127_raid1:500 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
md127_raid1     D ffff88107fd13d40     0   500      2 0x00000000
 ffff880850643bc8 0000000000000046 ffff88085056c9b0 ffff880850643fd8
 ffff880850643fd8 ffff880850643fd8 ffff880854683120 ffff88085056c9b0
 ffff880850643bf8 ffff8810528d88e8 ffff880850643fd8 ffff8810543c6b10
Call Trace:
 [<ffffffff8165f4a9>] schedule+0x29/0x70
 [<ffffffffa0161e8a>] handle_read_error+0xea/0x7b0 [raid1]
 [<ffffffff81092653>] ? __wake_up+0x53/0x70
 [<ffffffff814dcd3b>] ? mddev_unlock+0x8b/0xf0
 [<ffffffff81085eb0>] ? wake_up_bit+0x40/0x40
 [<ffffffffa0162b39>] raid1d+0x219/0x1020 [raid1]
 [<ffffffff8107114a>] ? del_timer_sync+0x5a/0x70
 [<ffffffff8165d74a>] ? schedule_timeout+0x17a/0x310
 [<ffffffff8108607b>] ? prepare_to_wait+0x5b/0x90
 [<ffffffff814dbced>] md_thread+0x10d/0x140
 [<ffffffff81085eb0>] ? wake_up_bit+0x40/0x40
 [<ffffffff814dbbe0>] ? md_rdev_init+0x140/0x140
 [<ffffffff810854d0>] kthread+0xc0/0xd0
 [<ffffffff81010000>] ? ftrace_define_fields_xen_mmu_flush_tlb+0x10/0x80
 [<ffffffff81085410>] ? flush_kthread_worker+0x80/0x80
 [<ffffffff8166906c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81085410>] ? flush_kthread_worker+0x80/0x80

(handle_read_error+0xea puts me at the wait_event_lock_irq_cmd in 
freeze_array.)

INFO: task jbd2/md127-8:547 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
jbd2/md127-8    D ffff88107fdd3d40     0   547      2 0x00000000
 ffff88085060f9c8 0000000000000046 ffff88084d768000 ffff88085060ffd8
 ffff88085060ffd8 ffff88085060ffd8 ffff8808546b0000 ffff88084d768000
 ffffffff8113c1a5 ffff8810543c6aa8 ffff8810543c6b10 ffff88085060ffd8
Call Trace:
 [<ffffffff8113c1a5>] ? mempool_alloc_slab+0x15/0x20
 [<ffffffff8165f4a9>] schedule+0x29/0x70
 [<ffffffffa01610f9>] wait_barrier+0xc9/0x170 [raid1]
 [<ffffffff81085eb0>] ? wake_up_bit+0x40/0x40
 [<ffffffffa0163bdb>] make_request+0x7b/0xce0 [raid1]
 [<ffffffff8113c1a5>] ? mempool_alloc_slab+0x15/0x20
 [<ffffffff814db837>] md_make_request+0x107/0x260
 [<ffffffff8113c1a5>] ? mempool_alloc_slab+0x15/0x20
 [<ffffffff812e6672>] generic_make_request+0xc2/0x110
 [<ffffffff812e6a09>] submit_bio+0x79/0x160
 [<ffffffff811dbd35>] ? bio_alloc_bioset+0x65/0x120
 [<ffffffff811d6954>] submit_bh+0x114/0x1e0
 [<ffffffff812794af>] jbd2_journal_commit_transaction+0x75f/0x1c40
 [<ffffffff8127f441>] kjournald2+0xd1/0x2a0
 [<ffffffff81085eb0>] ? wake_up_bit+0x40/0x40
 [<ffffffff8127f370>] ? jbd2_journal_release_jbd_inode+0x140/0x140
 [<ffffffff810854d0>] kthread+0xc0/0xd0
 [<ffffffff81010000>] ? ftrace_define_fields_xen_mmu_flush_tlb+0x10/0x80
 [<ffffffff81085410>] ? flush_kthread_worker+0x80/0x80
 [<ffffffff8166906c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81085410>] ? flush_kthread_worker+0x80/0x80

INFO: task flush-9:127:580 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-9:127     D ffff88107fc13d40     0   580      2 0x00000000
 ffff880851b1b5c8 0000000000000046 ffff880850568000 ffff880851b1bfd8
 ffff880851b1bfd8 ffff880851b1bfd8 ffff880854666240 ffff880850568000
 00000000000000bb ffff8810543c6aa8 ffff8810543c6b10 ffff880851b1bfd8
Call Trace:
 [<ffffffff8165f4a9>] schedule+0x29/0x70
 [<ffffffffa01610f9>] wait_barrier+0xc9/0x170 [raid1]
 [<ffffffff81085eb0>] ? wake_up_bit+0x40/0x40
 [<ffffffffa0163bdb>] make_request+0x7b/0xce0 [raid1]
 [<ffffffff811dbc1a>] ? bvec_alloc_bs+0x6a/0x120
 [<ffffffff814db837>] md_make_request+0x107/0x260
 [<ffffffff811db4f4>] ? __bio_add_page.part.13+0xf4/0x220
 [<ffffffff812e6672>] generic_make_request+0xc2/0x110
 [<ffffffff812e6a09>] submit_bio+0x79/0x160
 [<ffffffff812343b9>] ext4_io_submit+0x29/0x60
 [<ffffffff8122f73f>] mpage_da_submit_io+0x31f/0x5c0
 [<ffffffff812325a5>] ? write_cache_pages_da+0x175/0x4f0
 [<ffffffff81276907>] ? jbd2__journal_start+0x87/0x110
 [<ffffffff8123204a>] mpage_da_map_and_submit+0x11a/0x420
 [<ffffffff81232c77>] ? ext4_da_writepages+0x357/0x660
 [<ffffffff812769a3>] ? jbd2_journal_start+0x13/0x20
 [<ffffffff81232cc8>] ext4_da_writepages+0x3a8/0x660
 [<ffffffff811458de>] do_writepages+0x1e/0x40
 [<ffffffff811cdbeb>] __writeback_single_inode+0x3b/0x190
 [<ffffffff811ceb1e>] writeback_sb_inodes+0x1ee/0x4e0
 [<ffffffff811ceeaf>] __writeback_inodes_wb+0x9f/0xd0
 [<ffffffff811d061b>] wb_writeback+0x2fb/0x320
 [<ffffffff811d0acf>] wb_do_writeback+0x22f/0x240
 [<ffffffff811d0b73>] bdi_writeback_thread+0x93/0x280
 [<ffffffff811d0ae0>] ? wb_do_writeback+0x240/0x240
 [<ffffffff810854d0>] kthread+0xc0/0xd0
 [<ffffffff81010000>] ? ftrace_define_fields_xen_mmu_flush_tlb+0x10/0x80
 [<ffffffff81085410>] ? flush_kthread_worker+0x80/0x80
 [<ffffffff8166906c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81085410>] ? flush_kthread_worker+0x80/0x80

And a few stats before the machine completely wedged:

[root@dhcp-linux-2103-650 Breaker]# cat /proc/mdstat

Personalities : [raid1] 
md124 : active raid1 sdq3[4]
      4192192 blocks super 1.2 [2/1] [_U]
      bitmap: 0/1 pages [0KB], 65536KB chunk

md125 : active raid1 sdq2[0]
      16762752 blocks super 1.2 [2/1] [U_]
      bitmap: 0/1 pages [0KB], 65536KB chunk

md126 : active raid1 sdq1[1]
      16779136 blocks super 1.0 [2/1] [_U]
      bitmap: 0/1 pages [0KB], 65536KB chunk

md127 : active raid1 sdq5[0] sds5[1](F)
      255080256 blocks super 1.2 [2/1] [U_]
      bitmap: 1/2 pages [4KB], 65536KB chunk

unused devices: <none>

[root@dhcp-linux-2103-650 Breaker]# mdadm --detail /dev/md127
/dev/md127:
        Version : 1.2
  Creation Time : Thu Jan 17 16:56:09 2013
     Raid Level : raid1
     Array Size : 255080256 (243.26 GiB 261.20 GB)
  Used Dev Size : 255080256 (243.26 GiB 261.20 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Tue Feb 12 21:35:02 2013
          State : active, degraded 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0

           Name : dhcp-Linux-2103-627:root
           UUID : b5e4bddd:e76802b0:3b6badd6:e85ebc27
         Events : 128267

    Number   Major   Minor   RaidDevice State
       0      65        5        0      active sync   /dev/sdq5
       1      65       37        1      faulty

I'll try kicking off the test again tonight (sans debug printk's) and see 
if I can get a kdump out of the hang.

Regards,

-- Joe
