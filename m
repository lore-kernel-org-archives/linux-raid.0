From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: raid5d hangs when stopping an array during reshape
Date: Wed, 30 Dec 2015 14:45:48 +0100
Message-ID: <5683E00C.1050005@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I'm seeing a hang when trying to stop a RAID5 array that is undergoing
reshape:

[   99.629924] md: reshape of RAID array md0
[   99.631150] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[   99.632737] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
[   99.635366] md: using 128k window, over a total of 1047552k.
[  103.819848] md: md0: reshape interrupted.
[  150.127132] INFO: task md0_raid5:3234 blocked for more than 30 seconds.
[  150.128717]       Not tainted 4.4.0-rc5+ #54
[  150.129939] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  150.132116] md0_raid5       D ffff88003b1d7ba0 14104  3234      2 0x00000000
[  150.134081]  ffff88003b1d7ba0 ffffffff81e104c0 ffff88003bad0000 ffff88003b1d8000
[  150.137205]  ffff88003d66380c 0000000000000001 ffff88003d663a50 ffff88003d663800
[  150.139994]  ffff88003b1d7bb8 ffffffff81876050 ffff88003d663800 ffff88003b1d7c28
[  150.142606] Call Trace:
[  150.143551]  [<ffffffff81876050>] schedule+0x30/0x80
[  150.144883]  [<ffffffffa005fc80>] raid5_quiesce+0x200/0x250 [raid456]
[  150.147964]  [<ffffffff810882a0>] ? prepare_to_wait_event+0xf0/0xf0
[  150.149661]  [<ffffffffa0003bca>] mddev_suspend.part.26+0x7a/0x90 [md_mod]
[  150.151376]  [<ffffffffa0003bf7>] mddev_suspend+0x17/0x20 [md_mod]
[  150.153268]  [<ffffffffa0064e29>] check_reshape+0xb9/0x6b0 [raid456]
[  150.154869]  [<ffffffff8107e63f>] ? set_next_entity+0x9f/0x6d0
[  150.156359]  [<ffffffff8107af68>] ? sched_clock_local+0x18/0x80
[  150.157848]  [<ffffffff81081400>] ? pick_next_entity+0xa0/0x150
[  150.159348]  [<ffffffff810830ae>] ? pick_next_task_fair+0x3fe/0x460
[  150.160887]  [<ffffffffa0065471>] raid5_check_reshape+0x51/0xa0 [raid456]
[  150.162482]  [<ffffffffa000ba59>] md_check_recovery+0x2f9/0x480 [md_mod]
[  150.164074]  [<ffffffffa00697b4>] raid5d+0x34/0x650 [raid456]
[  150.165751]  [<ffffffff81876050>] ? schedule+0x30/0x80
[  150.167508]  [<ffffffff818786ef>] ? schedule_timeout+0x1ef/0x270
[  150.169784]  [<ffffffff81875ac3>] ? __schedule+0x313/0x870
[  150.171194]  [<ffffffffa0002e61>] md_thread+0x111/0x130 [md_mod]
[  150.172671]  [<ffffffff810882a0>] ? prepare_to_wait_event+0xf0/0xf0
[  150.174206]  [<ffffffffa0002d50>] ? find_pers+0x70/0x70 [md_mod]
[  150.175697]  [<ffffffff8106c8d4>] kthread+0xc4/0xe0
[  150.178294]  [<ffffffff8106c810>] ? kthread_park+0x50/0x50
[  150.179745]  [<ffffffff818796df>] ret_from_fork+0x3f/0x70
[  150.181134]  [<ffffffff8106c810>] ? kthread_park+0x50/0x50

Two tasks end up blocked:
 3866 ?        D      0:00 [systemd-udevd]
 4051 ?        D      0:00 [md0_raid5]

This happens when udev change event is triggered by mdadm -S and it
causes some reads on the array. I think the hang occurs because
raid5_quiesce() is called from the raid5d thread and it blocks waiting
for active_stripes to become 0, which won't happen, since stripes are
released by raid5d. Commit 738a273 ("md/raid5: fix allocation of
'scribble' array.") added mddev_suspend() in resize_chunks(), causing
this problem. Skipping mddev_suspend()/mddev_resume() in resize_chunks()
when running in raid5d context seems to fix it, but I don't think that's
a correct fix...

Regards,
Artur

