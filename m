From: admin <admin@turboio.com>
Subject: md hang on updating bitmap
Date: Sat, 25 Jan 2014 03:57:16 -0700
Message-ID: <20463c26597b0a4c939dcb582cc44210@mail.turboio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been failure testing initiator-side mirroring, and occasionally if 
I hit things just right during a failure scenario, I can get md arrays 
stuck indefinitely. This seems to wedge the scsi controller(target on 
initiator) from cleanly disconnecting, even though it is trying 
furiously and failing IO. I'm on the latest kernel 3.10, and using the 
srp_backport driver with the fast_io_fail and dev_loss_tmo updates. I'm 
told by the srp devs that the target seems to be failing io and aborting 
as it should, but about 2 times out of 10 I can get the md threads stuck 
in D state forever. I'm just throwing this out there in case anyone has 
suggestions or knows what to try.

[69923.701603] md3_raid1       D ffffffff818089a0  5248  8760      2 
0x00000080
[69923.709434]  ffff88020d511b58 0000000000000046 ffff880213f59020
0000000000013d80
[69923.717381]  ffff88020d511fd8 ffff88020d510010 0000000000013d80
0000000000013d80
[69923.725338]  ffff88020d511fd8 0000000000013d80 ffff880213f59020
ffff8802148458b0
[69923.733352] Call Trace:
[69923.741291]  [<ffffffff81761834>] schedule+0x24/0x70
[69923.749303]  [<ffffffff815e6745>] md_super_wait+0x55/0x90
[69923.757294]  [<ffffffff81092eb0>] ? wake_up_bit+0x40/0x40
[69923.765226]  [<ffffffff815f3b92>] write_page+0x1b2/0x370
[69923.773100]  [<ffffffff815f38c9>] bitmap_update_sb+0x119/0x120
[69923.780994]  [<ffffffff815eca85>] md_update_sb+0x245/0x650
[69923.788890]  [<ffffffff815f1d8a>] md_check_recovery+0x24a/0x4c0
[69923.796793]  [<ffffffffa02f06a2>] raid1d+0x32/0xf10 [raid1]
[69923.804729]  [<ffffffff8107c226>] ? try_to_del_timer_sync+0x56/0x70
[69923.812717]  [<ffffffff8107c29a>] ? del_timer_sync+0x5a/0x70
[69923.820565]  [<ffffffff8175f785>] ? schedule_timeout+0x135/0x210
[69923.828327]  [<ffffffff81044293>] ? default_spin_lock_flags+0x13/0x20
[69923.836134]  [<ffffffff81044293>] ? default_spin_lock_flags+0x13/0x20
[69923.843788]  [<ffffffff815ea12f>] md_thread+0x11f/0x170
[69923.851288]  [<ffffffff81092eb0>] ? wake_up_bit+0x40/0x40
[69923.858767]  [<ffffffff815ea010>] ? md_rdev_init+0x110/0x110
[69923.866238]  [<ffffffff81092806>] kthread+0xc6/0xd0
[69923.873689]  [<ffffffff81092740>] ? 
kthread_freezable_should_stop+0x60/0x60
[69923.881236]  [<ffffffff8176b7fc>] ret_from_fork+0x7c/0xb0
[69923.888759]  [<ffffffff81092740>] ? 
kthread_freezable_should_stop+0x60/0x60
