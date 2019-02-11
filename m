From: Wolfgang Walter <linux@stwm.de>
Subject: linux 4.19.19: md0_raid:1317 blocked for more than 120 seconds.
Date: Mon, 11 Feb 2019 16:12:56 +0100
Message-ID: <2131016.q2kFhguZXe@stwm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

With 4.19.19 we see sometimes the following issue (practically only wit=
h blk_mq, though):

Feb  4 20:04:46 tettnang kernel: [252300.060165] INFO: task md0_raid1:3=
17 blocked for more than 120 seconds.
Feb  4 20:04:46 tettnang kernel: [252300.060188]       Not tainted 4.19=
.19-debian64.all+1.1 #1
Feb  4 20:04:46 tettnang kernel: [252300.060197] "echo 0 > /proc/sys/ke=
rnel/hung_task_timeout_secs" disables this message.
Feb  4 20:04:46 tettnang kernel: [252300.060207] md0_raid1       D    0=
   317      2 0x80000000
Feb  4 20:04:46 tettnang kernel: [252300.060211] Call Trace:
Feb  4 20:04:46 tettnang kernel: [252300.060222]  ? __schedule+0x2a2/0x=
8c0
Feb  4 20:04:46 tettnang kernel: [252300.060226]  ? _raw_spin_unlock_ir=
qrestore+0x20/0x40
Feb  4 20:04:46 tettnang kernel: [252300.060229]  schedule+0x32/0x90
Feb  4 20:04:46 tettnang kernel: [252300.060241]  md_super_wait+0x69/0x=
a0 [md_mod]
Feb  4 20:04:46 tettnang kernel: [252300.060247]  ? finish_wait+0x80/0x=
80
Feb  4 20:04:46 tettnang kernel: [252300.060255]  md_bitmap_wait_writes=
+0x8e/0xa0 [md_mod]
Feb  4 20:04:46 tettnang kernel: [252300.060263]  ? md_bitmap_get_count=
er+0x42/0xd0 [md_mod]
Feb  4 20:04:46 tettnang kernel: [252300.060271]  md_bitmap_daemon_work=
+0x1e8/0x380 [md_mod]
Feb  4 20:04:46 tettnang kernel: [252300.060278]  ? md_rdev_init+0xb0/0=
xb0 [md_mod]
Feb  4 20:04:46 tettnang kernel: [252300.060285]  md_check_recovery+0x2=
6/0x540 [md_mod]
Feb  4 20:04:46 tettnang kernel: [252300.060290]  raid1d+0x5c/0xf00 [ra=
id1]
Feb  4 20:04:46 tettnang kernel: [252300.060294]  ? preempt_count_add+0=
x79/0xb0
Feb  4 20:04:46 tettnang kernel: [252300.060298]  ? lock_timer_base+0x6=
7/0x80
Feb  4 20:04:46 tettnang kernel: [252300.060302]  ? _raw_spin_unlock_ir=
qrestore+0x20/0x40
Feb  4 20:04:46 tettnang kernel: [252300.060304]  ? try_to_del_timer_sy=
nc+0x4d/0x80
Feb  4 20:04:46 tettnang kernel: [252300.060306]  ? del_timer_sync+0x35=
/0x40
Feb  4 20:04:46 tettnang kernel: [252300.060309]  ? schedule_timeout+0x=
17a/0x3b0
Feb  4 20:04:46 tettnang kernel: [252300.060312]  ? preempt_count_add+0=
x79/0xb0
Feb  4 20:04:46 tettnang kernel: [252300.060315]  ? _raw_spin_lock_irqs=
ave+0x25/0x50
Feb  4 20:04:46 tettnang kernel: [252300.060321]  ? md_rdev_init+0xb0/0=
xb0 [md_mod]
Feb  4 20:04:46 tettnang kernel: [252300.060327]  ? md_thread+0xf9/0x16=
0 [md_mod]
Feb  4 20:04:46 tettnang kernel: [252300.060330]  ? r1bio_pool_alloc+0x=
20/0x20 [raid1]
Feb  4 20:04:46 tettnang kernel: [252300.060336]  md_thread+0xf9/0x160 =
[md_mod]
Feb  4 20:04:46 tettnang kernel: [252300.060340]  ? finish_wait+0x80/0x=
80
Feb  4 20:04:46 tettnang kernel: [252300.060344]  kthread+0x112/0x130
Feb  4 20:04:46 tettnang kernel: [252300.060346]  ? kthread_create_work=
er_on_cpu+0x70/0x70
Feb  4 20:04:46 tettnang kernel: [252300.060350]  ret_from_fork+0x35/0x=
40

I saw that there was a similar problem with raid10 and an upstream patc=
h

e820d55cb99dd93ac2dc949cf486bb187e5cd70d
md: fix raid10 hang issue caused by barrier
by  Guoqing Jiang

I wonder if there is a similar fix needed for raid1?

Regards,
--=20
Wolfgang Walter
Studentenwerk M=FCnchen
Anstalt des =F6ffentlichen Rechts
