From: "George Spelvin" <linux@horizon.com>
Subject: 2.6.26-rc8 deadlock: RAID code?
Date: Fri, 04 Jul 2008 08:55:51 -0400
Message-ID: <20080704125551.24267.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

I've seen this twice before, but had to get remote logging working to
capture the initial error; once the root file system locks up there's
an unending stream of these messages and even syslog can't actually
log anything.

(In fact, it locked up and stopped working after capturing this here.
I'd have to get a null modem cable and serial console to capture more.)

I can do it again, but it takes a few days.

Hardware: single-core Athlon 64, ECC memory (scrubbing enabled),
6x SATA drives on 3x SiI3132 controllers.  Root file system (where I
believe the problem is) is ext3 over RAID-10 over all drives.  Another,
larger file system (that I can't see why the sensors daemon would touch)
is ext3 over RAID5 over the same drives.

Kernel is 2.6.26-rc8 + EDAC patches + linuxpps support.  This problem
was not observed in 2.6.25 kernels (with the same patches).

Any ideas?  For now, I'm going to turn on frame pointers and
CONFIG_PROVE_LOCKING to get more information.

01:19:13: INFO: task sensors:3111 blocked for more than 120 seconds.
01:19:13: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
01:19:13: sensors       D ffff81007e2fc4e0     0  3111   3110
01:19:13:  ffff81005c6d73e8 0000000000000086 ffff81005c6d73a8 ffff81005c6d73a8
01:19:13:  ffff81007e2fc1a0 ffff81007fae41a0 ffff81005c6d73d8 0000000000000002
01:19:13:  0000000000011220 ffffffff80659130 ffff81007e2fc1a0 ffffffffffffffff
01:19:13: Call Trace:
01:19:13:  [<ffffffff804e0e62>] __mutex_lock_slowpath+0x60/0x8a
01:19:13:  [<ffffffff8022358c>] ? __wake_up_common+0x40/0x6f
01:19:13:  [<ffffffff804e0d0f>] mutex_lock+0xd/0xf
01:19:13:  [<ffffffff802ae237>] sysfs_notify+0x23/0x90
01:19:13:  [<ffffffff804211c1>] md_write_start+0xb7/0x138
01:19:13:  [<ffffffff8041b96a>] make_request+0x61/0x545
01:19:13:  [<ffffffff802105e1>] ? read_tsc+0x9/0x1c
01:19:13:  [<ffffffff8023c569>] ? ktime_get_ts+0x49/0x4e
01:19:13:  [<ffffffff8023c57f>] ? ktime_get+0x11/0x42
01:19:13:  [<ffffffff802fc75f>] generic_make_request+0x238/0x273
01:19:13:  [<ffffffff802fc866>] submit_bio+0xcc/0xd5
01:19:13:  [<ffffffff8028e525>] submit_bh+0xe8/0x10c
01:19:13:  [<ffffffff802909ba>] __block_write_full_page+0x1a6/0x281
01:19:13:  [<ffffffff802927dd>] ? blkdev_get_block+0x0/0x5d
01:19:13:  [<ffffffff80290b5e>] block_write_full_page+0xc9/0xce
01:19:13:  [<ffffffff80293b35>] blkdev_writepage+0x13/0x15
01:19:13:  [<ffffffff80256f57>] shrink_page_list+0x350/0x594
01:19:13:  [<ffffffff8025653f>] ? isolate_lru_pages+0x14f/0x1ef
01:19:13:  [<ffffffff8025653f>] ? isolate_lru_pages+0x14f/0x1ef
01:19:13:  [<ffffffff802572fa>] shrink_inactive_list+0x15f/0x3aa
01:19:13:  [<ffffffff80257612>] shrink_zone+0xcd/0xf0
01:19:13:  [<ffffffff802580ea>] try_to_free_pages+0x1c1/0x2e9
01:19:13:  [<ffffffff802565df>] ? isolate_pages_global+0x0/0x34
01:19:13:  [<ffffffff8025383d>] __alloc_pages_internal+0x260/0x3fd
01:19:13:  [<ffffffff802539f0>] __alloc_pages+0xb/0xd
01:19:13:  [<ffffffff8026c51c>] __slab_alloc+0x11f/0x44b
01:19:13:  [<ffffffff802812b2>] ? alloc_inode+0x2b/0x17c
01:19:13:  [<ffffffff8026cc70>] kmem_cache_alloc+0x49/0x72
01:19:13:  [<ffffffff802812b2>] alloc_inode+0x2b/0x17c
01:19:13:  [<ffffffff80281450>] iget_locked+0x4d/0x132
01:19:13:  [<ffffffff802ad5fb>] sysfs_get_inode+0x1a/0x1c3
01:19:13:  [<ffffffff802ae4e6>] sysfs_lookup+0x4f/0xb2
01:19:13:  [<ffffffff8027671c>] do_lookup+0xc4/0x1a8
01:19:13:  [<ffffffff8027812a>] __link_path_walk+0x821/0xca0
01:19:13:  [<ffffffff80278608>] path_walk+0x5f/0xbf
01:19:13:  [<ffffffff80278967>] do_path_lookup+0x1a4/0x1c6
01:19:13:  [<ffffffff802778cb>] ? getname+0x142/0x180
01:19:13:  [<ffffffff802794d3>] __user_walk_fd+0x41/0x63
01:19:13:  [<ffffffff802726e7>] vfs_stat_fd+0x27/0x5d
01:19:13:  [<ffffffff802728c7>] sys_newstat+0x22/0x3c
01:19:13:  [<ffffffff8020b1db>] system_call_after_swapgs+0x7b/0x80
01:19:13: 
01:19:26: INFO: task kjournald:689 blocked for more than 120 seconds.
01:19:26: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
01:19:26: kjournald     D ffff81007fa5c4e0     0   689      2
01:19:26:  ffff81007e5a5b70 0000000000000046 ffff81007e5a5b30 ffff81007e5a5b30
01:19:26:  ffff81007fa5c1a0 ffff81007fb3c1a0 ffff81007e5a5b60 0000000000000002
01:19:26:  0000000000000001 ffffffff80659130 ffff81007fa5c1a0 ffffffffffffffff
01:19:26: Call Trace:
01:19:26:  [<ffffffff804e0e62>] __mutex_lock_slowpath+0x60/0x8a
01:19:26:  [<ffffffff8022358c>] ? __wake_up_common+0x40/0x6f
01:19:26:  [<ffffffff804e0d0f>] mutex_lock+0xd/0xf
01:19:26:  [<ffffffff802ae237>] sysfs_notify+0x23/0x90
01:19:26:  [<ffffffff804211c1>] md_write_start+0xb7/0x138
01:19:26:  [<ffffffff8023e0d7>] ? getnstimeofday+0x3a/0x93
01:19:26:  [<ffffffff8023c569>] ? ktime_get_ts+0x49/0x4e
01:19:26:  [<ffffffff80414ab9>] make_request+0x121/0x481
01:19:26:  [<ffffffff802fc75f>] generic_make_request+0x238/0x273
01:19:26:  [<ffffffff80223dda>] ? check_preempt_wakeup+0x6b/0xa2
01:19:26:  [<ffffffff802fc866>] submit_bio+0xcc/0xd5
01:19:26:  [<ffffffff8028e525>] submit_bh+0xe8/0x10c
01:19:26:  [<ffffffff802c07e8>] journal_commit_transaction+0x36f/0xb8b
01:19:26:  [<ffffffff804e08b9>] ? thread_return+0x3f/0x75
01:19:26:  [<ffffffff80239df4>] ? autoremove_wake_function+0x0/0x38
01:19:26:  [<ffffffff802c353f>] kjournald+0xcd/0x1d3
01:19:26:  [<ffffffff80239df4>] ? autoremove_wake_function+0x0/0x38
01:19:26:  [<ffffffff802c3472>] ? kjournald+0x0/0x1d3
01:19:26:  [<ffffffff802399cc>] kthread+0x49/0x76
01:19:26:  [<ffffffff8020bb28>] child_rip+0xa/0x12
01:19:26:  [<ffffffff80239983>] ? kthread+0x0/0x76
01:19:26:  [<ffffffff8020bb1e>] ? child_rip+0x0/0x12
01:19:26: 
01:19:41: INFO: task sensord:2172 blocked for more than 120 seconds.
01:19:41: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
01:19:41: sensord       D ffff81006de30340     0  2172      1
01:19:41:  ffff81006dec1be8 0000000000000086 ffff81006dec1c28 ffff81006dec1ba8
01:19:41:  ffff81006de30000 ffff81007fb395e0 0000000000000000 000280d000000000
01:19:41:  0000000200000010 ffffffff80659130 ffff81006de30000 ffffffffffffffff
01:19:41: Call Trace:
01:19:41:  [<ffffffff804e0e62>] __mutex_lock_slowpath+0x60/0x8a
01:19:41:  [<ffffffff804e0d0f>] mutex_lock+0xd/0xf
01:19:41:  [<ffffffff802af192>] sysfs_follow_link+0x50/0x16f
01:19:41:  [<ffffffff80277d27>] __link_path_walk+0x41e/0xca0
01:19:41:  [<ffffffff80278608>] path_walk+0x5f/0xbf
01:19:41:  [<ffffffff80278967>] do_path_lookup+0x1a4/0x1c6
01:19:41:  [<ffffffff80278c6d>] __path_lookup_intent_open+0x5c/0x9f
01:19:41:  [<ffffffff80278cbc>] path_lookup_open+0xc/0xe
01:19:41:  [<ffffffff802798ed>] do_filp_open+0xaa/0x832
01:19:41:  [<ffffffff8023bef7>] ? hrtimer_cancel+0x14/0x21
01:19:41:  [<ffffffff8023c444>] ? hrtimer_nanosleep+0x6b/0xdd
01:19:41:  [<ffffffff8026df5f>] ? get_unused_fd_flags+0x7a/0x102
01:19:41:  [<ffffffff8026e03c>] do_sys_open+0x55/0xff
01:19:41:  [<ffffffff8026e10f>] sys_open+0x1b/0x1d
01:19:41:  [<ffffffff8020b1db>] system_call_after_swapgs+0x7b/0x80
01:19:41: 
