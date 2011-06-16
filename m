From: Shivani Bhope <sbhope@redhat.com>
Subject: md0_raid5 process consuming 100% CPU on disk failure
Date: Thu, 16 Jun 2011 15:01:17 -0400 (EDT)
Message-ID: <1349223387.724279.1308250877780.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
References: <542975669.724147.1308250559342.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <542975669.724147.1308250559342.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all, 

I have been trying to test md raid 5 array faults. I set up a three-disk 
RAID 5, and started some I/O. Then I entered the command: 

mdadm /dev/md0 --fail /dev/sdc 

As soon as the disk is failed, the md0_raid5 process is seen to be taking 
100% CPU. This happens about 2 out of 3 times the test was run. 

The details: 

1. Output for mdadm -D /dev/md0 before the test: 
/dev/md0: 
Version : 1.2 
Creation Time : Tue Jun 14 20:05:07 2011 
Raid Level : raid5 
Array Size : 143129600 (136.50 GiB 146.56 GB) 
Used Dev Size : 71564800 (68.25 GiB 73.28 GB) 
Raid Devices : 3 
Total Devices : 3 
Persistence : Superblock is persistent 

Intent Bitmap : Internal 

Update Time : Wed Jun 15 13:42:59 2011 
State : active 
Active Devices : 3 
Working Devices : 3 
Failed Devices : 0 
Spare Devices : 0 

Layout : left-symmetric 
Chunk Size : 512K 

Name : 0 
UUID : 5a1f5b73:7ce46e00:2b16a389:cadd7ae8 
Events : 4716 

Number Major Minor RaidDevice State 
0 8 16 0 active sync /dev/sdb 
1 8 32 1 active sync /dev/sdc 
3 8 48 2 active sync /dev/sdd 


2. Output for mdadm -D after the test: 

/dev/md0: 
Version : 1.2 
Creation Time : Wed Jun 15 17:44:11 2011 
Raid Level : raid5 
Array Size : 143129600 (136.50 GiB 146.56 GB) 
Used Dev Size : 71564800 (68.25 GiB 73.28 GB) 
Raid Devices : 3 
Total Devices : 3 
Persistence : Superblock is persistent 

Intent Bitmap : Internal 

Update Time : Wed Jun 15 18:18:41 2011 
State : active, degraded 
Active Devices : 2 
Working Devices : 2 
Failed Devices : 1 
Spare Devices : 0 

Layout : left-symmetric 
Chunk Size : 512K 

Name : 0 
UUID : 8663119c:892e5b7d:a4f2be22:5bb2fdd4 
Events : 1049 

Number Major Minor RaidDevice State 
0 8 16 0 active sync /dev/sdb 
1 8 32 1 faulty spare 
rebuilding /dev/sdc 
3 8 48 2 active sync /dev/sdd 


Note the device is not marked as removed and spare but as
spare rebuilding. 

The system has to be manually power-cycled to recover. 

This system is running RHEL 6.1, kernel version 
2.6.32-131.0.15.el6.x86_64 & mdadm-3.2.1-1.el6.x86_64
The same test was also run on Fedora-15, kernel version 
2.6.38.8-32.fc15.x86_64 & mdadm-3.1.5-2.fc15.x86_64

The output for sysrq-t showing md0_raid5 after the hang is: 

Jun 15 18:20:39 kernel: md0_raid5 R running task 0 1896 2 0x00000080 
Jun 15 18:20:39 kernel: ffff880175e3fbd0 ffffffff814db337 ffff880175e3fb70 ffffffff8104af29 
Jun 15 18:20:39 kernel: 000000000000100c 0000000300000001 ffffe8ffffc00270 ffff88002801e988 
Jun 15 18:20:39 kernel: ffff8801747bdab8 ffff880175e3ffd8 000000000000f598 ffff8801747bdac0 
Jun 15 18:20:39 kernel: Call Trace: 
Jun 15 18:20:39 kernel: [<ffffffff814db337>] ? thread_return+0x4e/0x777 
Jun 15 18:20:39 kernel: [<ffffffff8104af29>] ? __wake_up_common+0x59/0x90 
Jun 15 18:20:39 kernel: [<ffffffff81103c56>] ? __perf_event_task_sched_out+0x36/0x50 
Jun 15 18:20:39 kernel: [<ffffffff8105faba>] __cond_resched+0x2a/0x40 
Jun 15 18:20:39 kernel: [<ffffffff814dbbb0>] _cond_resched+0x30/0x40 
Jun 15 18:20:39 kernel: [<ffffffffa0362cee>] ops_run_io+0x2e/0x350 [raid456] 
Jun 15 18:20:39 kernel: [<ffffffffa03659d1>] handle_stripe+0x501/0x2310 [raid456] 
Jun 15 18:20:39 kernel: [<ffffffff8104f843>] ? __wake_up+0x53/0x70 
Jun 15 18:20:39 kernel: [<ffffffffa0367c7f>] raid5d+0x49f/0x690 [raid456] 
Jun 15 18:20:39 kernel: [<ffffffff813de266>] md_thread+0x116/0x150 
Jun 15 18:20:39 kernel: [<ffffffff8108e160>] ? autoremove_wake_function+0x0/0x40 
Jun 15 18:20:39 kernel: [<ffffffff813de150>] ? md_thread+0x0/0x150 
Jun 15 18:20:39 kernel: [<ffffffff8108ddf6>] kthread+0x96/0xa0 
Jun 15 18:20:39 kernel: [<ffffffff8100c1ca>] child_rip+0xa/0x20 
Jun 15 18:20:39 kernel: [<ffffffff8108dd60>] ? kthread+0x0/0xa0 
Jun 15 18:20:39 kernel: [<ffffffff8100c1c0>] ? child_rip+0x0/0x20 

I tried to increase the stripe_cache_size to 512 and then to 16384.
The problem is still seen. 

What could be the reason for the problem? 

Any pointers will be greatly appreciated. 

Thanks, 
Shivani 

