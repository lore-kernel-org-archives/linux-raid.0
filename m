From: "Singer, Benedict" <bzsing@dolby.com>
Subject: Array rebuilding over and over
Date: Fri, 17 Aug 2012 17:53:51 +0000
Message-ID: <0622703D64D8944D9624A1C5833B7A06A99D@DLB-XCHPW02.dolby.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello all,

Got a strange issue here. The setup is as follows: 4 RAID5 arrays, 3 drives (partitions - 3 drives total) each. We run some monitoring software to deal with keeping them all happy, ie removing faulty drives from all arrays if it goes bad in one of them, partitioning and adding new drives to all of them, tracking rebuild progress, etc. The situation we're in now is that it's somehow possible to get an array in a state where the rebuild consistently fails; then the monitoring software detects the degraded array + available physical disk, and starts a new rebuild, which then fails again (and again, and again...).

The really baffling part is that no information is present in any logs about why the rebuild fails, making this very hard to diagnose. The array appears to start rebuilding, fail, and finish all within a second, suggesting it's not actually trying to rebuild, but something else is stopping it. The smartctl short selftest reports no errors on any disks. This seems to happen most of the time with md4, and the only way to get out of it is to reboot the system and try the rebuild again, which suggests a kernel issue rather than a hardware issue. I have seen it once on a different array, but in that case the rebuild worked the second time, whereas in the md4 case it appears to be impossible to get out of this state without rebooting. While it's in this state I can remove and add the disk back t
 o md4 and idle the other rebuild to get it to happen on command, so if there are any debugging suggestions it's easy to reproduce on command at this point.

I've checked the kernel config to see if there's any other block/md logging to turn on, but was unsuccessful; watching the console and dmesg don't show any other useful information either.

Here's the relevant info:

uname:
Linux showstore-1 3.2.23 #1 SMP Mon Aug 13 21:19:58 UTC 2012 i686 GNU/Linux

mdadm:
mdadm - v3.1.4 - 31st August 2010

/proc/mdstat - this is in the middle of a rebuild cycle (2/4 finished, 1/4 in progress, and the last one (md4) will fail and start the whole process again):
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
md4 : active raid5 sda4[3] sdc4[2] sdb4[1]
      2096640 blocks level 5, 256k chunk, algorithm 2 [3/2] [_UU]
      resync=DELAYED
      
md126 : active raid5 sda3[4] sdc3[5] sdb3[3]
      1936479232 blocks super 1.2 level 5, 256k chunk, algorithm 2 [3/2] [_UU]
      [=========>...........]  recovery = 49.1% (476073216/968239616) finish=92.8min speed=88333K/sec
      
md127 : active raid5 sda2[4] sdc2[5] sdb2[3]
      8386048 blocks super 1.2 level 5, 256k chunk, algorithm 2 [3/3] [UUU]
      
md1 : active raid5 sda1[0] sdc1[2] sdb1[1]
      6290944 blocks level 5, 256k chunk, algorithm 2 [3/3] [UUU]
      
unused devices: <none>

Log entries from syslog and messages from the last time the failure occurred:

syslog (covering the full rebuild cycle on all 4 arrays):
Aug 17 05:13:20 showstore-1 mdadm[5991]: RebuildStarted event detected on md device /dev/md1
Aug 17 05:13:24 showstore-1 kernel: EXT2-fs (md1): warning: maximal mount count reached, running e2fsck is recommended
Aug 17 05:13:26 showstore-1 kernel: scsi_verify_blk_ioctl: 58 callbacks suppressed
Aug 17 05:13:26 showstore-1 kernel: grub-probe: sending ioctl 1261 to a partition!
Aug 17 05:14:00 showstore-1 kernel: last message repeated 9 times
Aug 17 05:14:00 showstore-1 mdadm[5991]: RebuildStarted event detected on md device /dev/md/status
Aug 17 05:14:00 showstore-1 mdadm[5991]: RebuildFinished event detected on md device /dev/md1
Aug 17 05:14:01 showstore-1 mdadm[5991]: SpareActive event detected on md device /dev/md1, component device /dev/sda1
Aug 17 05:14:29 showstore-1 kernel: EXT2-fs (md1): warning: maximal mount count reached, running e2fsck is recommended
Aug 17 05:14:29 showstore-1 kernel: scsi_verify_blk_ioctl: 612 callbacks suppressed
Aug 17 05:14:29 showstore-1 kernel: grub-probe: sending ioctl 1261 to a partition!
Aug 17 05:14:49 showstore-1 kernel: last message repeated 9 times
Aug 17 05:14:49 showstore-1 mdadm[5991]: RebuildStarted event detected on md device /dev/md/content
Aug 17 05:14:49 showstore-1 mdadm[5991]: RebuildFinished event detected on md device /dev/md/status
Aug 17 05:14:49 showstore-1 mdadm[5991]: SpareActive event detected on md device /dev/md/status
Aug 17 05:48:10 showstore-1 mdadm[5991]: Rebuild20 event detected on md device /dev/md/content
Aug 17 06:38:10 showstore-1 mdadm[5991]: Rebuild48 event detected on md device /dev/md/content
Aug 17 07:11:31 showstore-1 mdadm[5991]: Rebuild66 event detected on md device /dev/md/content
Aug 17 07:44:51 showstore-1 mdadm[5991]: Rebuild82 event detected on md device /dev/md/content
Aug 17 08:29:41 showstore-1 kernel: md/raid:md4: Disk failure on sda4, disabling device.
Aug 17 08:29:41 showstore-1 kernel: md/raid:md4: Operation continuing on 2 devices.
Aug 17 08:29:41 showstore-1 mdadm[5991]: FailSpare event detected on md device /dev/md4, component device /dev/sda4
Aug 17 08:29:41 showstore-1 mdadm[5991]: RebuildFinished event detected on md device /dev/md/content
Aug 17 08:29:41 showstore-1 mdadm[5991]: SpareActive event detected on md device /dev/md/content

messages (also covering the full rebuild cycle):
Aug 17 05:13:20 showstore-1 kernel: md: bind<sda1>
Aug 17 05:13:20 showstore-1 kernel: md: recovery of RAID array md1
Aug 17 05:13:20 showstore-1 kernel: md: minimum _guaranteed_  speed: 20000 KB/sec/disk.
Aug 17 05:13:20 showstore-1 kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Aug 17 05:13:20 showstore-1 kernel: md: using 128k window, over a total of 3145472k.
Aug 17 05:13:21 showstore-1 kernel: md: bind<sda2>
Aug 17 05:13:21 showstore-1 kernel: md: delaying recovery of md127 until md1 has finished (they share one or more physical units)
Aug 17 05:13:21 showstore-1 kernel: md: bind<sda3>
Aug 17 05:13:22 showstore-1 kernel: md: delaying recovery of md126 until md127 has finished (they share one or more physical units)
Aug 17 05:13:22 showstore-1 kernel: md: delaying recovery of md127 until md1 has finished (they share one or more physical units)
Aug 17 05:13:22 showstore-1 kernel: md: bind<sda4>
Aug 17 05:13:22 showstore-1 kernel: md: delaying recovery of md4 until md126 has finished (they share one or more physical units)
Aug 17 05:13:22 showstore-1 kernel: md: delaying recovery of md127 until md1 has finished (they share one or more physical units)
Aug 17 05:13:22 showstore-1 kernel: md: delaying recovery of md126 until md127 has finished (they share one or more physical units)
Aug 17 05:13:26 showstore-1 kernel: grub-probe[21583]: segfault at 18 ip 08049057 sp bfa87b60 error 4 in grub-probe[8048000+1f000]
Aug 17 05:13:59 showstore-1 kernel: md: md1: recovery done.
Aug 17 05:14:00 showstore-1 kernel: md: delaying recovery of md126 until md127 has finished (they share one or more physical units)
Aug 17 05:14:00 showstore-1 kernel: md: recovery of RAID array md127
Aug 17 05:14:00 showstore-1 kernel: md: minimum _guaranteed_  speed: 20000 KB/sec/disk.
Aug 17 05:14:00 showstore-1 kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Aug 17 05:14:00 showstore-1 kernel: md: using 128k window, over a total of 4193024k.
Aug 17 05:14:00 showstore-1 kernel: md: delaying recovery of md4 until md126 has finished (they share one or more physical units)
Aug 17 05:14:49 showstore-1 kernel: md: md127: recovery done.
Aug 17 05:14:49 showstore-1 kernel: md: delaying recovery of md4 until md126 has finished (they share one or more physical units)
Aug 17 05:14:49 showstore-1 kernel: md: recovery of RAID array md126
Aug 17 05:14:49 showstore-1 kernel: md: minimum _guaranteed_  speed: 20000 KB/sec/disk.
Aug 17 05:14:49 showstore-1 kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Aug 17 05:14:49 showstore-1 kernel: md: using 128k window, over a total of 968239616k.
Aug 17 05:40:27 showstore-1 rsyslogd: -- MARK --
Aug 17 06:00:27 showstore-1 rsyslogd: -- MARK --
Aug 17 06:20:28 showstore-1 rsyslogd: -- MARK --
Aug 17 06:40:28 showstore-1 rsyslogd: -- MARK --
Aug 17 07:00:28 showstore-1 rsyslogd: -- MARK --
Aug 17 07:20:28 showstore-1 rsyslogd: -- MARK --
Aug 17 07:40:28 showstore-1 rsyslogd: -- MARK --
Aug 17 08:00:28 showstore-1 rsyslogd: -- MARK --
Aug 17 08:20:28 showstore-1 rsyslogd: -- MARK --
Aug 17 08:29:41 showstore-1 kernel: md: md126: recovery done.
Aug 17 08:29:41 showstore-1 kernel: md: recovery of RAID array md4
Aug 17 08:29:41 showstore-1 kernel: md: minimum _guaranteed_  speed: 20000 KB/sec/disk.
Aug 17 08:29:41 showstore-1 kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Aug 17 08:29:41 showstore-1 kernel: md: using 128k window, over a total of 1048320k.
Aug 17 08:29:41 showstore-1 kernel: md: md4: recovery done.

Any suggestions gratefully received!

Benedict