From: Mark Knecht <markknecht@gmail.com>
Subject: mdadm: sending ioctl 800c0910 to a partition!
Date: Tue, 17 Apr 2012 20:48:06 -0700
Message-ID: <CAK2H+efFUYqX98KBSdJAu-wH5c+Aec2+1K40uQVostDgyh8PYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Wondering if I should be concerned about these new messages?

Everything seems to be working fine. Found a bug report at RedHat
suggesting it's not an mdadm problem but thought maybe I should report
it anyway.

Thanks,
Mark

k2 ~ # uname -a
Linux k2 3.2.12-gentoo #1 SMP PREEMPT Thu Apr 12 16:26:36 PDT 2012
x86_64 Intel(R) Core(TM) i7 CPU 920 @ 2.67GHz GenuineIntel GNU/Linux
k2 ~ #

[    9.354769] scsi_verify_blk_ioctl: 368 callbacks suppressed
[    9.354773] mdadm: sending ioctl 1261 to a partition!
[    9.354776] mdadm: sending ioctl 1261 to a partition!
[    9.354918] mdadm: sending ioctl 800c0910 to a partition!
[    9.354921] mdadm: sending ioctl 800c0910 to a partition!
[    9.354939] mdadm: sending ioctl 800c0910 to a partition!
[    9.354942] mdadm: sending ioctl 800c0910 to a partition!
[    9.354988] mdadm: sending ioctl 800c0910 to a partition!
[    9.354991] mdadm: sending ioctl 800c0910 to a partition!
[    9.355004] mdadm: sending ioctl 800c0910 to a partition!
[    9.355007] mdadm: sending ioctl 800c0910 to a partition!
[    9.913580] EXT3-fs (md3): using internal journal
[   10.067489] kjournald starting.  Commit interval 5 seconds
[   10.092612] EXT3-fs (md127): using internal journal
[   10.092619] EXT3-fs (md127): mounted filesystem with writeback data mode
[   11.724865] Adding 4200992k swap on /dev/sda2.  Priority:-1
extents:1 across:4200992k
[   11.731532] Adding 4200992k swap on /dev/sdb2.  Priority:-2
extents:1 across:4200992k
[   11.743473] Adding 4200992k swap on /dev/sdc2.  Priority:-3
extents:1 across:4200992k


mark@k2 ~ $ cat /proc/mdstat
Personalities : [raid0] [raid1]
md127 : active raid1 sdc6[1] sdb6[0]
      327740905 blocks super 1.2 [2/2] [UU]

md126 : active raid1 sdb5[0] sdc5[1]
      31463203 blocks super 1.1 [2/2] [UU]

md3 : active raid1 sdc3[1] sdb3[0]
      41953664 blocks [2/2] [UU]

unused devices: <none>
mark@k2 ~ $
