From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Stuck reshape
Date: Fri, 22 Nov 2013 13:17:52 -0600
Message-ID: <528FADE0.4090608@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a reshape that got stuck on what appears to be step 1 of the process.

What can be done? Will a shutdown be recoverable, or should I be
prepared to restore from backup?

I can read from the array w/o error.

I initiated the re-shape with the following command (devices 4->5, level
5->6, chunk 512->256):
mdadm --grow /dev/md1 --level=6 --raid-devices=6 --chunk=256

The output was:
mdadm: level of /dev/md1 changed to raid6
mdadm: Need to backup 3072K of critical section..

The status is:

md1 : active raid6 sdo1[6] sdn1[5] sdd1[2] sdb1[4] sdc1[0] sda1[1]
      2929890816 blocks super 1.2 level 6, 512k chunk, algorithm 18
[6/5] [UUUU_U]
      [>....................]  reshape =  0.0% (512/976630272)
finish=56199369.9min speed=0K/sec
      bitmap: 0/1 pages [0KB], 1048576KB chunk

This process is chewing up a lot of CPU:
 2858 root      20   0    7936   3692    280 R  91.5  0.0  35:23.72 mdadm
 2856 root      20   0       0      0      0 R  24.4  0.0  14:05.14
md1_raid6
 2857 root      20   0       0      0      0 R  12.2  0.0   4:28.68
md1_reshape

(that's 91.5% for mdadm, 24.4% for md1_raid6, and 12.2% for md1_reshape)

All drives are on-line and functioning normally. I did forget to remove
the internal bitmap and I also forgot to use an external backup file.

mdadm - v3.2.6 - 25th October 2012
kernel: 3.11.8-200.fc19.x86_64

Syslog is:

[  601.373480] md: bind<sdn1>
[  601.773482] md: bind<sdo1>
[  601.824051] RAID conf printout:
[  601.824058]  --- level:5 rd:4 wd:4
[  601.824062]  disk 0, o:1, dev:sdc1
[  601.824065]  disk 1, o:1, dev:sda1
[  601.824068]  disk 2, o:1, dev:sdd1
[  601.824071]  disk 3, o:1, dev:sdb1
[  601.824073] RAID conf printout:
[  601.824075]  --- level:5 rd:4 wd:4
[  601.824078]  disk 0, o:1, dev:sdc1
[  601.824080]  disk 1, o:1, dev:sda1
[  601.824083]  disk 2, o:1, dev:sdd1
[  601.824085]  disk 3, o:1, dev:sdb1
[  647.692320] md/raid:md1: device sdd1 operational as raid disk 2
[  647.698547] md/raid:md1: device sdb1 operational as raid disk 3
[  647.704787] md/raid:md1: device sdc1 operational as raid disk 0
[  647.710941] md/raid:md1: device sda1 operational as raid disk 1
[  647.718258] md/raid:md1: allocated 5394kB
[  647.752152] md/raid:md1: raid level 6 active with 4 out of 5 devices,
algorithm 18
[  647.760088] RAID conf printout:
[  647.760092]  --- level:6 rd:5 wd:4
[  647.760096]  disk 0, o:1, dev:sdc1
[  647.760100]  disk 1, o:1, dev:sda1
[  647.760103]  disk 2, o:1, dev:sdd1
[  647.760105]  disk 3, o:1, dev:sdb1
[  648.622041] RAID conf printout:
[  648.622049]  --- level:6 rd:6 wd:5
[  648.622053]  disk 0, o:1, dev:sdc1
[  648.622057]  disk 1, o:1, dev:sda1
[  648.622059]  disk 2, o:1, dev:sdd1
[  648.622062]  disk 3, o:1, dev:sdb1
[  648.622065]  disk 4, o:1, dev:sdo1
[  648.622072] RAID conf printout:
[  648.622074]  --- level:6 rd:6 wd:5
[  648.622077]  disk 0, o:1, dev:sdc1
[  648.622079]  disk 1, o:1, dev:sda1
[  648.622082]  disk 2, o:1, dev:sdd1
[  648.622084]  disk 3, o:1, dev:sdb1
[  648.622087]  disk 4, o:1, dev:sdo1
[  648.622089]  disk 5, o:1, dev:sdn1
[  648.622475] md: reshape of RAID array md1
[  648.626832] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  648.633041] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for reshape.
[  648.643053] md: using 128k window, over a total of 976630272k.

--Larkin
