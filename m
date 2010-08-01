From: Michael Tokarev <mjt@tls.msk.ru>
Subject: sw raid array completely hungs during verify in 2.6.32
Date: Sun, 01 Aug 2010 14:57:56 +0400
Message-ID: <4C555334.5080202@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello.

It is the second time we come across this issue
after switching from 2.6.27 to 2.6.32 about 3
months ago.

At some point, an md-raid10 array hungs - that
is, all the processes that tries to access it,
either read or write, hungs forever.

Here's a typical set of messages found in kern.log:

 INFO: task oracle:7602 blocked for more than 120 seconds.
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 oracle        D ffff8801a8837148     0  7602      1 0x00000000
  ffffffff813bc480 0000000000000082 0000000000000000 0000000000000001
  ffff8801a8b7fdd8 000000000000e1c8 ffff88003b397fd8 ffff88003f47d840
  ffff88003f47dbe0 000000012416219a ffff88002820e1c8 ffff88003f47dbe0
 Call Trace:
  [<ffffffffa018e8ae>] ? wait_barrier+0xee/0x130 [raid10]
  [<ffffffff8104f570>] ? default_wake_function+0x0/0x10
  [<ffffffffa0191852>] ? make_request+0x82/0x5f0 [raid10]
  [<ffffffffa007cb2c>] ? md_make_request+0xbc/0x130 [md_mod]
  [<ffffffff810c4722>] ? mempool_alloc+0x62/0x140
  [<ffffffff8117d26f>] ? generic_make_request+0x30f/0x410
  [<ffffffff8112eee4>] ? bio_alloc_bioset+0x54/0xf0
  [<ffffffff8112e28b>] ? __bio_add_page+0x12b/0x240
  [<ffffffff8117d3cc>] ? submit_bio+0x5c/0xe0
  [<ffffffff811313da>] ? dio_bio_submit+0x5a/0x90
  [<ffffffff81131d63>] ? __blockdev_direct_IO+0x5a3/0xcd0
  [<ffffffffa01f66ed>] ? xfs_vm_direct_IO+0x11d/0x140 [xfs]
  [<ffffffffa01f6af0>] ? xfs_get_blocks_direct+0x0/0x20 [xfs]
  [<ffffffffa01f6470>] ? xfs_end_io_direct+0x0/0x70 [xfs]
  [<ffffffff810c3738>] ? generic_file_direct_write+0xc8/0x1b0
  [<ffffffffa01fef18>] ? xfs_write+0x458/0x950 [xfs]
  [<ffffffff8106317b>] ? try_to_del_timer_sync+0x9b/0xd0
  [<ffffffff810f9251>] ? cache_alloc_refill+0x221/0x5e0
  [<ffffffffa01fafe0>] ? xfs_file_aio_write+0x0/0x60 [xfs]
  [<ffffffff8113a6ac>] ? aio_rw_vect_retry+0x7c/0x210
  [<ffffffff8113be02>] ? aio_run_iocb+0x82/0x150
  [<ffffffff8113c747>] ? sys_io_submit+0x2b7/0x6b0
  [<ffffffff8100b542>] ? system_call_fastpath+0x16/0x1b

 INFO: task oracle:7654 blocked for more than 120 seconds.
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 oracle        D ffff8801a8837148     0  7654      1 0x00000000
  ffff8800614ac7c0 0000000000000086 0000000000000000 0000000000000206
  0000000000000000 000000000000e1c8 ffff88018c175fd8 ffff88005c9ba040
  ffff88005c9ba3e0 ffffffff810c4722 000000038c175810 ffff88005c9ba3e0
 Call Trace:
  [<ffffffff810c4722>] ? mempool_alloc+0x62/0x140
  [<ffffffffa018e8ae>] ? wait_barrier+0xee/0x130 [raid10]
  [<ffffffff8104f570>] ? default_wake_function+0x0/0x10
  [<ffffffff8112ddd1>] ? __bio_clone+0x21/0x70
  [<ffffffffa0191852>] ? make_request+0x82/0x5f0 [raid10]
  [<ffffffff8112d765>] ? bio_split+0x25/0x2a0
  [<ffffffffa0191ce1>] ? make_request+0x511/0x5f0 [raid10]
  [<ffffffffa007cb2c>] ? md_make_request+0xbc/0x130 [md_mod]
  [<ffffffff8117d26f>] ? generic_make_request+0x30f/0x410
  [<ffffffff8112da4a>] ? bvec_alloc_bs+0x6a/0x120
  [<ffffffff8117d3cc>] ? submit_bio+0x5c/0xe0
  [<ffffffff811313da>] ? dio_bio_submit+0x5a/0x90
  [<ffffffff81131480>] ? dio_send_cur_page+0x70/0xc0
  [<ffffffff8113151e>] ? submit_page_section+0x4e/0x140
  [<ffffffff8113215a>] ? __blockdev_direct_IO+0x99a/0xcd0
  [<ffffffffa01f666e>] ? xfs_vm_direct_IO+0x9e/0x140 [xfs]
  [<ffffffffa01f6af0>] ? xfs_get_blocks_direct+0x0/0x20 [xfs]
  [<ffffffffa01f6470>] ? xfs_end_io_direct+0x0/0x70 [xfs]
  [<ffffffff810c4357>] ? generic_file_aio_read+0x607/0x620
  [<ffffffffa023fae8>] ? rpc_run_task+0x38/0x80 [sunrpc]
  [<ffffffffa01ff83b>] ? xfs_read+0x11b/0x270 [xfs]
  [<ffffffff81103453>] ? do_sync_read+0xe3/0x130
  [<ffffffff8113c32c>] ? sys_io_getevents+0x39c/0x420
  [<ffffffff810706b0>] ? autoremove_wake_function+0x0/0x30
  [<ffffffff8113adc0>] ? timeout_func+0x0/0x10
  [<ffffffff81104138>] ? vfs_read+0xc8/0x180
  [<ffffffff81104291>] ? sys_pread64+0xa1/0xb0
  [<ffffffff8100c2db>] ? device_not_available+0x1b/0x20
  [<ffffffff8100b542>] ? system_call_fastpath+0x16/0x1b

 INFO: task md11_resync:11976 blocked for more than 120 seconds.
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 md11_resync   D ffff88017964d140     0 11976      2 0x00000000
  ffff8801af879880 0000000000000046 0000000000000000 0000000000000001
  ffff8801a8b7fdd8 000000000000e1c8 ffff8800577d1fd8 ffff88017964d140
  ffff88017964d4e0 000000012416219a ffff88002828e1c8 ffff88017964d4e0
 Call Trace:
  [<ffffffffa018e696>] ? raise_barrier+0xb6/0x1e0 [raid10]
  [<ffffffff8104f570>] ? default_wake_function+0x0/0x10
  [<ffffffff8103b263>] ? enqueue_task+0x53/0x60
  [<ffffffffa018f525>] ? sync_request+0x715/0xae0 [raid10]
  [<ffffffffa007dc76>] ? md_do_sync+0x606/0xc70 [md_mod]
  [<ffffffff8104ca4a>] ? finish_task_switch+0x3a/0xc0
  [<ffffffffa007ec47>] ? md_thread+0x67/0x140 [md_mod]
  [<ffffffffa007ebe0>] ? md_thread+0x0/0x140 [md_mod]
  [<ffffffff81070376>] ? kthread+0x96/0xb0
  [<ffffffff8100c52a>] ? child_rip+0xa/0x20
  [<ffffffff810702e0>] ? kthread+0x0/0xb0
  [<ffffffff8100c520>] ? child_rip+0x0/0x20

(All 3 processes shown are reported at the same time).
A few more processes are waiting in wait_barrier like the
first mentioned above does.  Note the 3 different places
it is waiting:

 o raise_barrier
 o wait_barrier
 o mempool_alloc called from wait_barrier

the whole thing look suspicious - smells like a deadlock
somewhere.

From this point on, the array is completely dead, with many
processes (like the above) blocked, with no way to umount the
filesystem in question.  Only forced reboot of the system
helps.

This is 2.6.32.15.  I see there were a few patches for md
after that, but it looks like they aren't relevant for this
issue.

Note that this is not a trivially-triggerable problem.  The
array survived several verify rounds (even during current
uptime) without problems.  But today the array had quite some
load during verify.

Thanks!

/mjt
