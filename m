From: Glenn Enright <glenn.enright@gmail.com>
Subject: io lockup on cp
Date: Mon, 10 Oct 2016 11:01:02 +1300
Message-ID: <CAN7jt210rMw8zwoN+kcoypW6y6R92kZ66h_K85Yms-LLG8gcxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

We are seeing cp processes getting stuck in state D. it mayt be
related to md. Or perhaps it is dm_mod.

What seems to happen generally is the cp command gets to D state, then
a dmeventd command sleeps in a polling state and can not be roused or
safely killed. And then eventually other io commands that depend on
dmeventd queue up enough that the server hangs.

Ive seen this on raid1,6 and 10. running xen 4.6 with a 4.4.19 kernel
from xen.crc.id.au. On Centos6 (mdadm 3.3)

I have lots of other 'stuff' from the system, if anyone wants more
ouptut from anything specific please let me know.

Thanks
--Glenn

# the cp command
[~]# cat /proc/30923/stack
[<ffffffff8133ff53>] call_rwsem_down_write_failed+0x13/0x20
[<ffffffffa030bc20>] snapshot_map+0x90/0x490 [dm_snapshot]
[<ffffffffa000427a>] __map_bio+0x4a/0x130 [dm_mod]
[<ffffffffa0004867>] __split_and_process_bio+0x327/0x3f0 [dm_mod]
[<ffffffffa00049a4>] dm_make_request+0x74/0xe0 [dm_mod]
[<ffffffff8130922f>] generic_make_request+0xff/0x1d0
[<ffffffff81309370>] submit_bio+0x70/0x140
[<ffffffff8120eed4>] mpage_bio_submit+0x34/0x50
[<ffffffff8120f2c3>] do_mpage_readpage+0x2b3/0x6d0
[<ffffffff8120f874>] mpage_readpages+0x114/0x160
[<ffffffff81209fdd>] blkdev_readpages+0x1d/0x20
[<ffffffff81168d60>] __do_page_cache_readahead+0x1a0/0x240
[<ffffffff81168f4d>] ondemand_readahead+0x14d/0x250
[<ffffffff811690c2>] page_cache_async_readahead+0x72/0x80
[<ffffffff8115c62e>] generic_file_read_iter+0x40e/0x5e0
[<ffffffff81209ac7>] blkdev_read_iter+0x37/0x40
[<ffffffff811d0f7c>] __vfs_read+0xcc/0xf0
[<ffffffff811d122e>] vfs_read+0x8e/0xe0
[<ffffffff811d1ae6>] SyS_read+0x56/0xc0
[<ffffffff816856ee>] entry_SYSCALL_64_fastpath+0x12/0x71
[<ffffffffffffffff>] 0xffffffffffffffff

# dmeventd
[~]# cat /proc/30757/stack
[<ffffffff811e3e19>] poll_schedule_timeout+0x49/0x70
[<ffffffff811e45fa>] do_select+0x5ba/0x750
[<ffffffff811e5052>] core_sys_select+0x1c2/0x2b0
[<ffffffff811e5657>] SyS_select+0x47/0x110
[<ffffffff816856ee>] entry_SYSCALL_64_fastpath+0x12/0x71
[<ffffffffffffffff>] 0xffffffffffffffff
