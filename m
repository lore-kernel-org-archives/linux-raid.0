From: Tregaron Bayly <tbayly@bluehost.com>
Subject: Re: RAID1 lockup over multipath devices?
Date: Mon, 11 Feb 2013 14:54:24 -0700
Message-ID: <1360619664.2186.41.camel@linux-lxtg.site>
References: <1360611067.2186.26.camel@linux-lxtg.site>
Reply-To: tbayly@bluehost.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1360611067.2186.26.camel@linux-lxtg.site>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So, this looks suspicious to me:

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

Thread [flush-9:16] is in wait_barrier(), which executes this:

  wait_event_lock_irq(conf->wait_barrier,
                      !conf->barrier ||
                      (conf->nr_pending &&
                      current->bio_list &&
                      !bio_list_empty(current->bio_list)),
                      conf->resync_lock,
                      );

> [md16-raid1]
> [<ffffffffa009ffb9>] handle_read_error+0x119/0x790 [raid1]
> [<ffffffffa00a0862>] raid1d+0x232/0x1060 [raid1]
> [<ffffffff813675a7>] md_thread+0x117/0x150
> [<ffffffff8106414e>] kthread+0xce/0xe0
> [<ffffffff81488a6c>] ret_from_fork+0x7c/0xb0
> [<ffffffffffffffff>] 0xffffffffffffffff

and thread [md16-raid1] is in handle_read_error(), which calls
freeze_array(), which executes this:

  wait_event_lock_irq(conf->wait_barrier,
                      conf->nr_pending == conf->nr_queued+1,
                      conf->resync_lock,
                      flush_pending_writes(conf));

...different conditions, but the same wait queue and lock.  Both threads
are TASK_UNINTERRUPTIBLE, which would be consistent with both of them
being in the wait_event_lock_irq().  This seems more and more like a
deadlock to me, but kernel concurrency is beyond my skill.  Do these
symptoms and stack look like a race/deadlock to anyone else?

Tregaron Bayly

