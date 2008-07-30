From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: traceback on mdadm --stop
Date: Wed, 30 Jul 2008 13:09:08 -0500
Message-ID: <cccedfc60807301109x1dadbff4u11ce3c186656069@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Steps to reproduce:

1. create 2-device raid5
2. add 3rd device
3. --grow --raid-devices=3
4. wait a bit
5. --stop

Environment:

opensuse 11.0, x86-64, kernel 2.6.25.11-0.1-default, AMD x86-64 3600+ dual core.

Jul 30 13:02:20 turnip kernel: md: bind<sdb3>
Jul 30 13:02:20 turnip kernel: md: bind<sdc3>
Jul 30 13:02:20 turnip kernel: raid5: device sdc3 operational as raid disk 1
Jul 30 13:02:20 turnip kernel: raid5: device sdb3 operational as raid disk 0
Jul 30 13:02:20 turnip kernel: raid5: allocated 2174kB for md99
Jul 30 13:02:20 turnip kernel: raid5: raid level 5 set md99 active
with 2 out of 2 devices, algorithm 2
Jul 30 13:02:20 turnip kernel: RAID5 conf printout:
Jul 30 13:02:20 turnip kernel:  --- rd:2 wd:2
Jul 30 13:02:20 turnip kernel:  disk 0, o:1, dev:sdb3
Jul 30 13:02:20 turnip kernel:  disk 1, o:1, dev:sdc3
Jul 30 13:02:39 turnip kernel: md: bind<sdd3>
Jul 30 13:03:02 turnip kernel: RAID5 conf printout:
Jul 30 13:03:02 turnip kernel:  --- rd:3 wd:3
Jul 30 13:03:02 turnip kernel:  disk 0, o:1, dev:sdb3
Jul 30 13:03:02 turnip kernel:  disk 1, o:1, dev:sdc3
Jul 30 13:03:02 turnip kernel:  disk 2, o:1, dev:sdd3
Jul 30 13:03:02 turnip kernel: md: reshape of RAID array md99
Jul 30 13:03:02 turnip kernel: md: minimum _guaranteed_  speed: 30000
KB/sec/disk.
Jul 30 13:03:02 turnip kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for reshape.
Jul 30 13:03:02 turnip kernel: md: using 128k window, over a total of
3903744 blocks.
Jul 30 13:06:17 turnip kernel: md: md_do_sync() got signal ... exiting
Jul 30 13:06:17 turnip kernel: slab error in kmem_cache_destroy():
cache `raid5-md99-alt': Can't free all objects
Jul 30 13:06:17 turnip kernel: Pid: 28433, comm: mdadm Tainted: G
 AN 2.6.25.11-0.1-default #1
Jul 30 13:06:17 turnip kernel:
Jul 30 13:06:17 turnip kernel: Call Trace:
Jul 30 13:06:17 turnip kernel:  [<ffffffff8020d696>] dump_trace+0xc4/0x576
Jul 30 13:06:17 turnip kernel:  [<ffffffff8020db88>] show_trace+0x40/0x57
Jul 30 13:06:17 turnip kernel:  [<ffffffff8044f8d5>] _etext+0x72/0x7b
Jul 30 13:06:17 turnip kernel:  [<ffffffff8029ca7e>]
kmem_cache_destroy+0x9c/0xf5
Jul 30 13:06:17 turnip kernel:  [<ffffffff88113299>]
:raid456:shrink_stripes+0x29/0x39
Jul 30 13:06:17 turnip kernel:  [<ffffffff881132d5>] :raid456:stop+0x2c/0x86
Jul 30 13:06:17 turnip kernel:  [<ffffffff803baf92>] do_md_stop+0x11a/0x36a
Jul 30 13:06:17 turnip kernel:  [<ffffffff803bd3c7>] md_ioctl+0xdf9/0x17ff
Jul 30 13:06:17 turnip kernel:  [<ffffffff80316c97>]
blkdev_driver_ioctl+0x63/0x78
Jul 30 13:06:17 turnip kernel:  [<ffffffff803173df>] blkdev_ioctl+0x733/0x758
Jul 30 13:06:17 turnip kernel:  [<ffffffff802c5bd4>] block_ioctl+0x1b/0x1f
Jul 30 13:06:17 turnip kernel:  [<ffffffff802ac89a>] vfs_ioctl+0x2a/0x78
Jul 30 13:06:17 turnip kernel:  [<ffffffff802acb2f>] do_vfs_ioctl+0x247/0x261
Jul 30 13:06:17 turnip kernel:  [<ffffffff802acb9e>] sys_ioctl+0x55/0x77
Jul 30 13:06:17 turnip kernel:  [<ffffffff8020bffa>]
system_call_after_swapgs+0x8a/0x8f
Jul 30 13:06:17 turnip kernel: DWARF2 unwinder stuck at
system_call_after_swapgs+0x8a/0x8f
Jul 30 13:06:17 turnip kernel:
Jul 30 13:06:17 turnip kernel: Leftover inexact backtrace:
Jul 30 13:06:17 turnip kernel:
Jul 30 13:06:17 turnip kernel:
Jul 30 13:06:18 turnip kernel: md: md99 stopped.
Jul 30 13:06:18 turnip kernel: md: unbind<sdd3>
Jul 30 13:06:18 turnip kernel: md: export_rdev(sdd3)
Jul 30 13:06:18 turnip kernel: md: unbind<sdc3>
Jul 30 13:06:18 turnip kernel: md: export_rdev(sdc3)
Jul 30 13:06:18 turnip kernel: md: unbind<sdb3>
Jul 30 13:06:18 turnip kernel: md: export_rdev(sdb3)


-- 
Jon
