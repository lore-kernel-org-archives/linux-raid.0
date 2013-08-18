From: wangkaird <wangkaird@gmail.com>
Subject: raid5: a problem of repeat recovery
Date: Sun, 18 Aug 2013 21:28:21 +0800
Message-ID: <1376832501.8512.5.camel@bogon>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I'm currently fighting a raid problem with a wired log as follows:
(md19 is a 3-devices raid5)

......
Aug 13 09:40:06 node-0 kernel: md19: detected capacity change from
2147483648 to 0
Aug 13 09:40:06 node-0 kernel: md: md19 stopped.
Aug 13 09:40:06 node-0 kernel: md: unbind<dm-117>
Aug 13 09:40:06 node-0 kernel: md: export_rdev(dm-117)
Aug 13 09:40:06 node-0 kernel: md: unbind<dm-420>
Aug 13 09:40:06 node-0 kernel: md: bind<dm-420>
Aug 13 09:40:06 node-0 kernel: raid5: device dm-420 operational as raid
disk 1
Aug 13 09:40:06 node-0 kernel: raid5: device dm-304 operational as raid
disk 0
Aug 13 09:40:06 node-0 kernel: raid5: allocated 3230kB for md19
Aug 13 09:40:06 node-0 kernel: 1: w=1 pa=0 pr=3 m=1 a=0 r=3 op1=0 op2=0
Aug 13 09:40:06 node-0 kernel: 0: w=2 pa=0 pr=3 m=1 a=0 r=3 op1=0 op2=0
Aug 13 09:40:06 node-0 kernel: raid5: raid level 4 set md19 active with
2 out of 3 devices, algorithm 0
Aug 13 09:40:06 node-0 kernel: md19: bitmap initialized from disk: read
1/1 pages, set 0 bits
Aug 13 09:40:06 node-0 kernel: created bitmap (1 pages) for device md19
Aug 13 09:40:06 node-0 kernel: md19: detected capacity change from 0 to
2147483648
Aug 13 09:40:06 node-0 kernel: md19: detected capacity change from 0 to
2147483648
Aug 13 09:40:06 node-0 kernel: md19: unknown partition table
Aug 13 09:40:06 node-0 kernel: md: bind<dm-117>
Aug 13 09:40:06 node-0 kernel: RAID5 conf printout:
Aug 13 09:40:06 node-0 kernel: --- rd:3 wd:2
Aug 13 09:40:06 node-0 kernel: disk 0, o:1, dev:dm-304
Aug 13 09:40:06 node-0 kernel: disk 1, o:1, dev:dm-420
Aug 13 09:40:06 node-0 kernel: disk 2, o:1, dev:dm-117
Aug 13 09:40:06 node-0 kernel: md: recovery of RAID array md19
Aug 13 09:40:06 node-0 kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Aug 13 09:40:06 node-0 kernel: md: using maximum available idle IO
bandwidth (but not more than 400000 KB/sec) for recovery.
Aug 13 09:40:06 node-0 kernel: md: using 128k window, over a total of
1048576 blocks.
Aug 13 09:40:06 node-0 kernel: md: md19: recovery done.
Aug 13 09:40:06 node-0 kernel: RAID5 conf printout:
Aug 13 09:40:06 node-0 kernel: --- rd:3 wd:3
Aug 13 09:40:06 node-0 kernel: disk 0, o:1, dev:dm-304
Aug 13 09:40:06 node-0 kernel: disk 1, o:1, dev:dm-420
Aug 13 09:40:06 node-0 kernel: disk 2, o:1, dev:dm-117

An hour later, something wrong with dm-304. 

Aug 13 10:57:29 node-0 kernel: raid5: Disk failure on dm-304, disabling
device.
Aug 13 10:57:29 node-0 kernel: raid5: Operation continuing on 2 devices.
Aug 13 10:57:29 node-0 kernel: md: recovery of RAID array md19
Aug 13 10:57:29 node-0 kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Aug 13 10:57:29 node-0 kernel: md: using maximum available idle IO
bandwidth (but not more than 400000 KB/sec) for recovery.
Aug 13 10:57:29 node-0 kernel: md: using 128k window, over a total of
1048576 blocks.
Aug 13 10:57:29 node-0 kernel: md: resuming recovery of md19 from
checkpoint.
Aug 13 10:57:29 node-0 kernel: md: md19: recovery done.
Aug 13 10:57:29 node-0 kernel: RAID5 conf printout:
Aug 13 10:57:29 node-0 kernel: --- rd:3 wd:2
Aug 13 10:57:29 node-0 kernel: disk 0, o:0, dev:dm-304
Aug 13 10:57:29 node-0 kernel: disk 1, o:1, dev:dm-420
Aug 13 10:57:29 node-0 kernel: disk 2, o:1, dev:dm-117

And the wired thing begins. 
The log as follows, was printed thousands of time.

Aug 13 10:57:29 node-0 kernel: md: recovery of RAID array md19
Aug 13 10:57:29 node-0 kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Aug 13 10:57:29 node-0 kernel: md: using maximum available idle IO
bandwidth (but not more than 400000 KB/sec) for recovery.
Aug 13 10:57:29 node-0 kernel: md: using 128k window, over a total of
1048576 blocks.
Aug 13 10:57:29 node-0 kernel: md: resuming recovery of md19 from
checkpoint.
Aug 13 10:57:29 node-0 kernel: md: md19: recovery done.
Aug 13 10:57:29 node-0 kernel: RAID5 conf printout:
Aug 13 10:57:29 node-0 kernel: --- rd:3 wd:2
Aug 13 10:57:29 node-0 kernel: disk 0, o:0, dev:dm-304
Aug 13 10:57:29 node-0 kernel: disk 1, o:1, dev:dm-420
Aug 13 10:57:29 node-0 kernel: disk 2, o:1, dev:dm-117

finally, it finished.

Aug 13 10:57:30 node-0 kernel: md: recovery of RAID array md19
Aug 13 10:57:30 node-0 kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Aug 13 10:57:30 node-0 kernel: md: using maximum available idle IO
bandwidth (but not more than 400000 KB/sec) for recovery.
Aug 13 10:57:30 node-0 kernel: md: using 128k window, over a total of
1048576 blocks.
Aug 13 10:57:30 node-0 kernel: md: resuming recovery of md19 from
checkpoint.
Aug 13 10:57:30 node-0 kernel: md: md19: recovery done.
Aug 13 10:57:30 node-0 kernel: end_request: I/O error, dev dm-297,
sector 2048
Aug 13 10:57:30 node-0 kernel: end_request: I/O error, dev dm-297,
sector 1152
Aug 13 10:57:30 node-0 kernel: end_request: I/O error, dev dm-297,
sector 512
Aug 13 10:57:30 node-0 kernel: end_request: I/O error, dev dm-297,
sector 0
Aug 13 10:57:30 node-0 kernel: RAID5 conf printout:
Aug 13 10:57:30 node-0 kernel: --- rd:3 wd:2
Aug 13 10:57:30 node-0 kernel: disk 0, o:0, dev:dm-304
Aug 13 10:57:30 node-0 kernel: disk 1, o:1, dev:dm-420
Aug 13 10:57:30 node-0 kernel: disk 2, o:1, dev:dm-117
Aug 13 10:57:30 node-0 kernel: RAID5 conf printout:
Aug 13 10:57:30 node-0 kernel: --- rd:3 wd:2
Aug 13 10:57:30 node-0 kernel: disk 0, o:0, dev:dm-304
Aug 13 10:57:30 node-0 kernel: disk 1, o:1, dev:dm-420
Aug 13 10:57:30 node-0 kernel: disk 2, o:1, dev:dm-117
Aug 13 10:57:30 node-0 kernel: RAID5 conf printout:
Aug 13 10:57:30 node-0 kernel: --- rd:3 wd:2
Aug 13 10:57:30 node-0 kernel: disk 1, o:1, dev:dm-420
Aug 13 10:57:30 node-0 kernel: disk 2, o:1, dev:dm-117

and then, dm-304, dm-420, dm-117 were unbound and exported.
my system is centos 6.0 and the version of mdadm is 3.2.2 .
This problem confuses me for a long time. Who can tell me what happened?


