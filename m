From: Frank van Maarseveen <frankvm@frankvm.com>
Subject: raid synchronization too aggressive in 2.6.21?
Date: Sat, 16 Jun 2007 23:00:14 +0200
Message-ID: <20070616210014.GA12624@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2.6.21.1, the system got mostly unresponsive after a

	echo repair >/sys/block/md3/md/sync_action

In this case mozilla not refreshing anything for several minutes was
the main symptom. Raid1 md3 is mounted on /home. "ps" worked and showed
mozilla hanging in (IIRC) get_write_access(). So I tried alt-sysrq-t but
didn't see anything appearing in a "tail --follow=name /var/log/messages"
running from system start. tail /var/log/messages at that point did not
print anything for minutes too. I weeded out all the processes in state
'S' from the alt-sysrq-r output and found these, all in state D:

> kjournald     D F7A41DD0     0   540     11 (L-TLB)
>        f7a41e14 00000046 00000001 f7a41dd0 00000046 dffe1658 dffe1648 00000296 
>        dffe1648 f7a41de0 00000296 dffe1648 00000001 f5104b70 c2a1e7e0 dfe4a130 
>        dfe4a23c 00000000 ad9dc6c0 00000352 f7a41e80 f7a41e0c c03c527c c2a1e7e0 
> Call Trace:
>  [<c04e1162>] io_schedule+0x22/0x30
>  [<c018f3b0>] sync_buffer+0x30/0x40
>  [<c04e1357>] __wait_on_bit+0x57/0x60
>  [<c04e13dd>] out_of_line_wait_on_bit+0x7d/0x90
>  [<c018f44f>] __wait_on_buffer+0x2f/0x40
>  [<c01c2ac7>] journal_commit_transaction+0x9f7/0xdf0
>  [<c01c500d>] kjournald+0x1bd/0x210
>  [<c0136910>] kthread+0xa0/0xb0
>  [<c0104de7>] kernel_thread_helper+0x7/0x20
>  =======================

> kjournald     D F7441DD0     0  2172     11 (L-TLB)
>        f7441e14 00000046 00000001 f7441dd0 00000046 f77b2b18 f77b2b08 00000296 
>        f77b2b08 ed376740 00000353 00000000 00000000 f74e8070 c2a267e0 f74bf430 
>        f74bf53c 00000000 ed376740 00000353 f7441e80 f7441e0c c03c527c c2a267e0 
> Call Trace:
>  [<c04e1162>] io_schedule+0x22/0x30
>  [<c018f3b0>] sync_buffer+0x30/0x40
>  [<c04e1357>] __wait_on_bit+0x57/0x60
>  [<c04e13dd>] out_of_line_wait_on_bit+0x7d/0x90
>  [<c018f44f>] __wait_on_buffer+0x2f/0x40
>  [<c01c2ac7>] journal_commit_transaction+0x9f7/0xdf0
>  [<c01c500d>] kjournald+0x1bd/0x210
>  [<c0136910>] kthread+0xa0/0xb0
>  [<c0104de7>] kernel_thread_helper+0x7/0x20
>  =======================

> syslogd       D F74420F0     0  2935      1 (NOTLB)
>        f7169db4 00000046 dfc82414 f74420f0 f7169d74 c0141327 00000001 00000046 
>        c0136c75 d3c167c0 0000034e 00000000 00000000 dfe4a130 c2a1e7e0 f74420f0 
>        f74421fc 00000000 d3c167c0 0000034e f7169db4 c0136c75 00000002 dfc8233c 
> Call Trace:
>  [<c01c57a0>] log_wait_commit+0xd0/0x130
>  [<c01c0f4e>] journal_stop+0x17e/0x210
>  [<c01c1009>] journal_force_commit+0x29/0x30
>  [<c01bd2e4>] ext3_force_commit+0x24/0x30
>  [<c01b6f11>] ext3_write_inode+0x41/0x50
>  [<c018bce7>] write_inode+0x47/0x50
>  [<c018beaf>] __sync_single_inode+0x1bf/0x1e0
>  [<c018bf1f>] __writeback_single_inode+0x4f/0x1d0
>  [<c018c704>] sync_inode+0x24/0x40
>  [<c01b29aa>] ext3_sync_file+0x9a/0xf0
>  [<c018ece9>] do_fsync+0x69/0x90
>  [<c018ed3a>] __do_fsync+0x2a/0x50
>  [<c018ed6d>] sys_fsync+0xd/0x10
>  [<c0104198>] sysenter_past_esp+0x5d/0x81
>  =======================

> mozilla-bin   D F5C714B0     0  5812   5803 (NOTLB)
>        f626592c 00000046 c2a0286c f5c714b0 f62658ec c0141327 00000001 00000046 
>        c0136c75 abc4c100 00000352 00000000 00000000 f7436a70 c2a267e0 f5c714b0 
>        f5c715bc 00000000 abc4c100 00000352 f626592c c0136c75 00000002 c2a0285c 
> Call Trace:
>  [<c01c02cc>] do_get_write_access+0x3fc/0x560
>  [<c01c0453>] journal_get_write_access+0x23/0x40
>  [<c01bf46f>] __ext3_journal_get_write_access+0x1f/0x50
>  [<c01b71bc>] ext3_reserve_inode_write+0x5c/0x80
>  [<c01b7215>] ext3_mark_inode_dirty+0x35/0x60
>  [<c01b72b4>] ext3_dirty_inode+0x74/0x80
>  [<c018bc98>] __mark_inode_dirty+0x198/0x1a0
>  [<c01b163f>] ext3_new_blocks+0x8f/0x530
>  [<c01b3e8b>] ext3_alloc_blocks+0x4b/0xc0
>  [<c01b3f50>] ext3_alloc_branch+0x50/0x240
>  [<c01b4414>] ext3_get_blocks_handle+0x194/0x3a0
>  [<c01b46b4>] ext3_get_block+0x94/0x110
>  [<c019132c>] __block_prepare_write+0x25c/0x3f0
>  [<c0191cc8>] block_prepare_write+0x28/0x50
>  [<c01b4b6b>] ext3_prepare_write+0x8b/0x190
>  [<c0151d33>] generic_file_buffered_write+0x213/0x660
>  [<c0152483>] __generic_file_aio_write_nolock+0x303/0x630
>  [<c01528c0>] generic_file_aio_write+0x60/0xd0
>  [<c01b286d>] ext3_file_write+0x2d/0xd0
>  [<c016ffa0>] do_sync_write+0xc0/0x100
>  [<c0170078>] vfs_write+0x98/0x120
>  [<c01701b1>] sys_write+0x41/0x70
>  [<c0104198>] sysenter_past_esp+0x5d/0x81
>  =======================

This is reproduceable. After starting a "repair" for a 200G raid1 md device, mounted
but not used AFAIK several processes periodically locked up for minutes while the
array was being repaired.

-- 
Frank
