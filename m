From: Tupshin Harper <tupshin@tupshin.com>
Subject: degraded raid5 at bootup
Date: Fri, 13 Aug 2004 12:49:18 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <411D1B3E.9050306@tupshin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 5 disk raid5 using autodetect partitions. If I have a clean 
array when I shut down, I always have a degraded array with one disk 
removed when I boot back up. Below I include the relevant dmesg output. 
hdi1 is always the problem. If I do a "mdadm -a /dev/md0 /dev/hdi1", 
then the array rebuilds without a problem, and runs clean until I reboot 
again. Any suggestions?

Kernel is 2.6.8-rc2-mm2, but I've tried it with a few other recent 
kernels (mm and not) and all have the same problem. Distro is Debian Sid.

-Tupshin

md: considering hdl1 ...
md:  adding hdl1 ...
md:  adding hdj1 ...
md: hdi1 has different UUID to hdl1
md:  adding hdh1 ...
md:  adding hde1 ...
md: created md0
md: bind<hde1>
md: bind<hdh1>
md: bind<hdj1>
md: bind<hdl1>
md: running: <hdl1><hdj1><hdh1><hde1>
raid5: device hdl1 operational as raid disk 4
raid5: device hdj1 operational as raid disk 3
raid5: device hdh1 operational as raid disk 1
raid5: device hde1 operational as raid disk 0
raid5: allocated 5242kB for md0
raid5: raid level 5 set md0 active with 4 out of 5 devices, algorithm 2
RAID5 conf printout:
 --- rd:5 wd:4 fd:1
 disk 0, o:1, dev:hde1
 disk 1, o:1, dev:hdh1
 disk 3, o:1, dev:hdj1
 disk 4, o:1, dev:hdl1
md: considering hdi1 ...
md:  adding hdi1 ...
md: md0 already running, cannot run hdi1
md: export_rdev(hdi1)
md: ... autorun DONE.

