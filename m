From: Tregaron Bayly <tbayly@bluehost.com>
Subject: RAID1 lockup over multipath devices?
Date: Mon, 11 Feb 2013 12:31:07 -0700
Message-ID: <1360611067.2186.26.camel@linux-lxtg.site>
Reply-To: tbayly@bluehost.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We are running kernel 3.7.1 here with dozens of raid1 arrays each
composed of a pair of multipath devices (over iscsi).  Multipath is
configured with no_path_retry (queuing the i/o if the paths all fail)
for what amounts to two minutes.  When we have any path fail events long
enough to surface errors to raid most of the arrays degrade correctly
but we often end up with a handful mirrors that are degraded but have a
pair of kernel threads stuck in D state with the following stacks:

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

At this point the raid device is completely inaccessible and we are
forced to restart the host to restore access.

Does this sound like a configuration problem or some kind of deadlock
bug with barriers?

Thanks for your help,

Tregaron Bayly
Bluehost, Inc.

