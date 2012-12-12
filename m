From: "Andris Berzins" <pkix@inbox.lv>
Subject: Re: failed raid re-create changed dev size
Date: Wed, 12 Dec 2012 18:10:59 +0200
Message-ID: <1355328659.50c8ac93db8a3@mail.inbox.lv>
References: <1355236515.50c744a3720c1@mail.inbox.lv>
 <20121211144949.GB28593@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121211144949.GB28593@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> Is it possible that no data was damaged? It is LUKS partition, i
>> mapped it and run "fsck -n" on underlying ext3 partition,
>> but fsck returned immediately with status "clean".
>> 
> By default fsck will just check whether the filesystem is marked as
> dirty/clean and just skip running if it's clean. You'll need to use "-f"
> to force it to run.

It seems that something got damaged. I have several traces as shown below in dmesg.

Tried to run "fsck -f -n" but it looks that it will take several month on this 15TB fs with billion files.
Any ideas?

[151680.304424] INFO: task mv:11190 blocked for more than 120 seconds.
[151680.304426] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[151680.304429] mv              D ffffffff81806200     0 11190   8887 0x00000000
[151680.304434]  ffff8800b6f79558 0000000000000086 ffff8800b6f79518 ffff8800b5f3f580
[151680.304439]  ffff8800b6f79fd8 ffff8800b6f79fd8 ffff8800b6f79fd8 00000000000137c0
[151680.304444]  ffff8800ba319700 ffff8800b6fd4500 ffff8800b6f79528 ffff8800bfc94080
[151680.304450] Call Trace:
[151680.304454]  [<ffffffff811a8db0>] ? __wait_on_buffer+0x30/0x30
[151680.304459]  [<ffffffff816590ff>] schedule+0x3f/0x60
[151680.304463]  [<ffffffff816591af>] io_schedule+0x8f/0xd0
[151680.304466]  [<ffffffff811a8dbe>] sleep_on_buffer+0xe/0x20
[151680.304471]  [<ffffffff816599cf>] __wait_on_bit+0x5f/0x90
[151680.304475]  [<ffffffff812f0fa8>] ? generic_make_request+0x68/0x70
[151680.304479]  [<ffffffff811a8db0>] ? __wait_on_buffer+0x30/0x30
[151680.304484]  [<ffffffff81659a7c>] out_of_line_wait_on_bit+0x7c/0x90
[151680.304488]  [<ffffffff8108acc0>] ? autoremove_wake_function+0x40/0x40
[151680.304492]  [<ffffffff811a8dae>] __wait_on_buffer+0x2e/0x30
[151680.304496]  [<ffffffff811a9e58>] bh_submit_read+0x68/0x80
[151680.304500]  [<ffffffff811f19fe>] read_block_bitmap+0xde/0x150
[151680.304505]  [<ffffffff8125686b>] ? do_get_write_access+0x34b/0x4d0
[151680.304509]  [<ffffffff811f31ef>] ext3_new_blocks+0x29f/0x710
[151680.304514]  [<ffffffff811f5fc7>] ext3_alloc_blocks+0x57/0xf0
[151680.304519]  [<ffffffff811f6636>] ext3_alloc_branch+0x56/0x2d0
[151680.304522]  [<ffffffff811a9ad3>] ? __getblk+0x33/0x70
[151680.304527]  [<ffffffff811f63cb>] ? ext3_get_branch+0x8b/0x150
[151680.304531]  [<ffffffff811f970f>] ext3_get_blocks_handle+0x2ef/0x640
[151680.304535]  [<ffffffff811f9b24>] ext3_get_block+0xc4/0x120
[151680.304539]  [<ffffffff8165b00e>] ? _raw_spin_lock+0xe/0x20
[151680.304544]  [<ffffffff811ab7ae>] __block_write_begin+0x1ce/0x520
[151680.304548]  [<ffffffff811f9a60>] ? ext3_get_blocks_handle+0x640/0x640
[151680.304553]  [<ffffffff81117f98>] ? grab_cache_page_write_begin+0x78/0xe0
[151680.304557]  [<ffffffff811f8e73>] ext3_write_begin+0xc3/0x280
[151680.304562]  [<ffffffff8111757a>] generic_perform_write+0xca/0x210
[151680.304566]  [<ffffffff816591cb>] ? io_schedule+0xab/0xd0
[151680.304571]  [<ffffffff8111771d>] generic_file_buffered_write+0x5d/0x90
[151680.304576]  [<ffffffff81119139>] __generic_file_aio_write+0x229/0x440
[151680.304580]  [<ffffffff811193c2>] generic_file_aio_write+0x72/0xe0
[151680.304585]  [<ffffffff8117792a>] do_sync_write+0xda/0x120
[151680.304590]  [<ffffffff812d7f88>] ? apparmor_file_permission+0x18/0x20
[151680.304594]  [<ffffffff8129d6ec>] ? security_file_permission+0x2c/0xb0
[151680.304598]  [<ffffffff81177ed1>] ? rw_verify_area+0x61/0xf0
[151680.304602]  [<ffffffff81178233>] vfs_write+0xb3/0x180
[151680.304606]  [<ffffffff8117855a>] sys_write+0x4a/0x90
[151680.304610]  [<ffffffff81663602>] system_call_fastpath+0x16/0x1b



> 
> Cheers,
> Robin
> --
> ___
> ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
> / / )      | Little Jim says ....                            |
> // !!       |      "He fallen in de water !!"                 |

