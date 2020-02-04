From: Michal Soltys <soltys@drutsystem.com>
Subject: md/mdadm and restore from hibernate issue
Date: Tue, 4 Feb 2020 18:12:09 +0100
Message-ID: <4f15ea34-195c-8bb9-42bb-042265589ea0@drutsystem.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US-large
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I had resume-from-hibernation issue yesterday, with logs stating that mdadm couldn't have been freezed:

[   19.124753] PM: Image signature found, resuming
[   19.124757] PM: resume from hibernation
[   19.185972] Freezing user space processes ... 
[   39.188867] Freezing of tasks failed after 20.002 seconds (1 tasks refusing to freeze, wq_busy=0):
[   39.198921] mdadm           D    0   592    368 0x00004006
[   39.198939] Call Trace:
[   39.201685]  ? __schedule+0x2bb/0x660
[   39.205784]  schedule+0x2f/0xa0
[   39.209310]  schedule_timeout+0x20d/0x310
[   39.213793]  ? __schedule+0x2c3/0x660
[   39.217906]  io_schedule_timeout+0x19/0x40
[   39.222488]  wait_for_completion_io+0x11f/0x190
[   39.227567]  ? wake_up_q+0x80/0x80
[   39.231384]  submit_bio_wait+0x5b/0x80
[   39.235598]  sync_page_io+0x127/0x160 [md_mod]
[   39.240581]  r5l_recovery_replay_one_stripe.isra.30+0xd5/0x210 [raid456]
[   39.247690]  r5c_recovery_replay_stripes+0x60/0xa0 [raid456]
[   39.254029]  r5l_start+0xb44/0xee0 [raid456]
[   39.258806]  md_start.part.41+0x2e/0x50 [md_mod]
[   39.263980]  do_md_run+0x56/0xc0 [md_mod]
[   39.268463]  md_ioctl+0xe7d/0x17c0 [md_mod]
[   39.273143]  blkdev_ioctl+0x4d0/0xa10
[   39.277241]  block_ioctl+0x39/0x40
[   39.281098]  do_vfs_ioctl+0xa4/0x630
[   39.285102]  ksys_ioctl+0x60/0x90
[   39.288812]  __x64_sys_ioctl+0x16/0x20
[   39.293005]  do_syscall_64+0x53/0x130
[   39.297104]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   39.302758] RIP: 0033:0x7fcc23774427
[   39.306761] Code: Bad RIP value.
[   39.310322] RSP: 002b:00007ffe776fac48 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   39.318778] RAX: ffffffffffffffda RBX: 00007ffe776fd624 RCX: 00007fcc23774427
[   39.326856] RDX: 0000000000000000 RSI: 00000000400c0930 RDI: 0000000000000004
[   39.334930] RBP: 000056408fb857f0 R08: 000000000000004f R09: 000056408fb87610
[   39.342922] R10: 0000000000000003 R11: 0000000000000246 R12: 00007ffe776fbb00
[   39.350892] R13: 0000000000000004 R14: 000056408fb86bb0 R15: 0000000000000000
[   39.350895] OOM killer enabled.
[   39.350895] Restarting tasks ... done.
[   39.420402] PM: resume from hibernation failed (-16)

This is the fragment from the initramfs stage, with 3 of the 4 arrays assembled (the 4th uses external bitmap, so it's handled far later and outside initramfs) - before an attempt to resume from hibernation was attempted. This was on debian's kernel (5.2.0-0.bpo.3-amd64, so based on 5.2.17 from what I can see).

Out of those 3 arrays:

- md127 is raid1 serving as a journal (nominally write-back, but it was changed to write-through before hibernation) for md126; this one was assembled and activated (capacity change ...)

- md126 is raid5 consisting of 4 disks, that uses md127 as its journal device; it was assmebled but wasn't activated (no capacity change message, and it looks like it was in recovery ?)

- md125 is raid5 with internal bitmap, it assembled and activated fine (nevermind possible race condition between udev scripts and debian's script in local-block, judging from '[    8.898089] md: array md125 already has disks!')

The md126 array activated 2+ minutes later:

Feb 03 20:54:44 xs22 systemd-udevd[756]: md126: Worker [823] processing SEQNUM=4194 is taking a long time
....
Feb 03 20:55:59 xs22 kernel: md/raid:md126: recovering 0 data-only stripes and 358258 data-parity stripes
Feb 03 20:55:59 xs22 kernel: md126: detected capacity change from 0 to 11999596511232
+dmesg timestamps:
[  219.195721] md/raid:md126: recovering 0 data-only stripes and 358258 data-parity stripes
[  219.235388] md126: detected capacity change from 0 to 11999596511232

So it looks like one of incremental-assembly mdadms was stuck waiting for the array's activation. Still, I had to "push" it with mdadm -As to assembly correctly from the console (unless there was race here and my mdadm invocation had no effect - but I'm 99% it was manual mdadm that nudged the array into life).

Overall I'm scratching my head what happened. Hibernation went (allegedly) fine, journal was in w-t mode.
Is raid5+journal a viable configuration to be used with hibernation - or is it asking for problems ?

Any ideas / hints appreciated.
