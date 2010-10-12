From: Job Honig <joho@xs4all.nl>
Subject: Linux raid resyncing for unknown reasons
Date: Tue, 12 Oct 2010 12:23:23 +0200
Message-ID: <201010121223.23464.joho@xs4all.nl>
Reply-To: joho@xs4all.nl
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

I have been using software raid for several years, to good effect.  Recently,
my RAID-5 file server started to have frequent resyncs after being switched
on, for reasons unknown to me.  No disk was failing, just resyncs (taking 6
or 7 hours).   I suspected that one of the four disks was slow in spinning up.
(Would that be a reason to resync?)

Since my server was almost full anyway, I decided to build a new one using
3 disks of 2 TB each, configured as RAID5.  I installed SuSE 11.3.  Initial-
ly, I made the mistake of configuring the disks as RAID0, so, in a running
system, I reconfigured the partitions to RAID5 and formatted md0 as ext3.
All went well, but took a few hours to complete.

After formatting had completed, I discovered that one of the disks was not
active and was being resynced.  Don't understand why that would be, and if
it means that my system is having a problem.

Below you find some of the information I have obtained.  Hope that someone
is willing and able to help me.  The server is intended to hold my photo
archive, so it is of crucial importance (hence RAID and several backups).

Thanks for any help with this problem!!

Job Honig
The Netherlands

gouda2:~ # cat /proc/mdstat

Personalities : [raid0] [raid6] [raid5] [raid4] 
md0 : active raid5 sdc3[3] sdb2[1] sda2[0]
      3865461760 blocks super 1.0 level 5, 512k chunk, algorithm 0 [3/2] [UU_]
      [>....................]  recovery =  1.0% (20146816/1932730880) 
finish=30822.8min speed=1033K/sec
      bitmap: 458/461 pages [1832KB], 2048KB chunk
unused devices: <none>

----------------------------------------------
Linux 2.6.34.7-0.3-desktop x86_64
----------------------------------------------

From /var/log/warn:

Oct 12 10:05:33 gouda2 kernel: [  503.470718] raid6: int64x1   1269 MB/s
Oct 12 10:05:33 gouda2 kernel: [  503.487163] raid6: int64x2   1839 MB/s
Oct 12 10:05:33 gouda2 kernel: [  503.504145] raid6: int64x4   1875 MB/s
Oct 12 10:05:33 gouda2 kernel: [  503.521024] raid6: int64x8   1523 MB/s
Oct 12 10:05:33 gouda2 kernel: [  503.538145] raid6: sse2x1    3242 MB/s
Oct 12 10:05:33 gouda2 kernel: [  503.555027] raid6: sse2x2    3738 MB/s
Oct 12 10:05:33 gouda2 kernel: [  503.572009] raid6: sse2x4    7152 MB/s
Oct 12 10:05:33 gouda2 kernel: [  503.572011] raid6: using algorithm sse2x4 
(7152 MB/s)
Oct 12 10:05:33 gouda2 kernel: [  503.714387] 1: w=1 pa=0 pr=3 m=1 a=0 r=3 
op1=0 op2=0
Oct 12 10:05:33 gouda2 kernel: [  503.714391] 0: w=2 pa=0 pr=3 m=1 a=0 r=3 
op1=0 op2=0
Oct 12 10:05:33 gouda2 kernel: [  503.714394] raid5: raid level 5 set md0 
active with 2 out of 3 devices, algorithm 0
Oct 12 10:05:33 gouda2 kernel: [  503.714397] RAID5 conf printout:
Oct 12 10:05:33 gouda2 kernel: [  503.714399]  --- rd:3 wd:2
Oct 12 10:05:33 gouda2 kernel: [  503.714401]  disk 0, o:1, dev:sda2
Oct 12 10:05:33 gouda2 kernel: [  503.714404]  disk 1, o:1, dev:sdb2
Oct 12 10:05:34 gouda2 kernel: [  504.628130] RAID5 conf printout:
Oct 12 10:05:34 gouda2 kernel: [  504.628136]  --- rd:3 wd:2
Oct 12 10:05:34 gouda2 kernel: [  504.628139]  disk 0, o:1, dev:sda2
Oct 12 10:05:34 gouda2 kernel: [  504.628142]  disk 1, o:1, dev:sdb2
Oct 12 10:05:34 gouda2 kernel: [  504.628145]  disk 2, o:1, dev:sdc3

----------------------------------------------

From /var/log/messages:

Oct 12 10:05:32 gouda2 kernel: [  502.538212] md: md0 stopped.
Oct 12 10:05:32 gouda2 kernel: [  502.538218] md: unbind<sda2>
Oct 12 10:05:32 gouda2 kernel: [  502.541019] md: export_rdev(sda2)
Oct 12 10:05:32 gouda2 kernel: [  502.541029] md: unbind<sdc3>
Oct 12 10:05:32 gouda2 kernel: [  502.544020] md: export_rdev(sdc3)
Oct 12 10:05:32 gouda2 kernel: [  502.544026] md: unbind<sdb2>
Oct 12 10:05:32 gouda2 kernel: [  502.548012] md: export_rdev(sdb2)
Oct 12 10:05:32 gouda2 kernel: [  502.551320] md0: detected capacity change 
from 5937349263360 to 0
Oct 12 10:05:33 gouda2 kernel: [  503.416975] async_tx: api initialized 
(async)
Oct 12 10:05:33 gouda2 kernel: [  503.422689] xor: automatically using best 
checksumming function: generic_sse
Oct 12 10:05:33 gouda2 kernel: [  503.427004]    generic_sse:  5832.000 MB/sec
Oct 12 10:05:33 gouda2 kernel: [  503.427007] xor: using function: generic_sse 
(5832.000 MB/sec)
Oct 12 10:05:33 gouda2 kernel: [  503.470718] raid6: int64x1   1269 MB/s
Oct 12 10:05:33 gouda2 kernel: [  503.487163] raid6: int64x2   1839 MB/s
Oct 12 10:05:33 gouda2 kernel: [  503.504145] raid6: int64x4   1875 MB/s
Oct 12 10:05:33 gouda2 kernel: [  503.521024] raid6: int64x8   1523 MB/s
Oct 12 10:05:33 gouda2 kernel: [  503.538145] raid6: sse2x1    3242 MB/s
Oct 12 10:05:33 gouda2 kernel: [  503.555027] raid6: sse2x2    3738 MB/s
Oct 12 10:05:33 gouda2 kernel: [  503.572009] raid6: sse2x4    7152 MB/s
Oct 12 10:05:33 gouda2 kernel: [  503.572011] raid6: using algorithm sse2x4 
(7152 MB/s)
Oct 12 10:05:33 gouda2 kernel: [  503.583991] md: raid6 personality registered 
for level 6
Oct 12 10:05:33 gouda2 kernel: [  503.583993] md: raid5 personality registered 
for level 5
Oct 12 10:05:33 gouda2 kernel: [  503.583994] md: raid4 personality registered 
for level 4
Oct 12 10:05:33 gouda2 kernel: [  503.701376] md: bind<sda2>
Oct 12 10:05:33 gouda2 kernel: [  503.701527] md: bind<sdb2>
Oct 12 10:05:33 gouda2 kernel: [  503.712204] md: bind<sdc3>
Oct 12 10:05:33 gouda2 kernel: [  503.713988] raid5: device sdb2 operational 
as raid disk 1
Oct 12 10:05:33 gouda2 kernel: [  503.713991] raid5: device sda2 operational 
as raid disk 0
Oct 12 10:05:33 gouda2 kernel: [  503.714350] raid5: allocated 3230kB for md0
Oct 12 10:05:33 gouda2 kernel: [  503.714387] 1: w=1 pa=0 pr=3 m=1 a=0 r=3 
op1=0 op2=0
Oct 12 10:05:33 gouda2 kernel: [  503.714391] 0: w=2 pa=0 pr=3 m=1 a=0 r=3 
op1=0 op2=0
Oct 12 10:05:33 gouda2 kernel: [  503.714394] raid5: raid level 5 set md0 
active with 2 out of 3 devices, algorithm 0
Oct 12 10:05:33 gouda2 kernel: [  503.714397] RAID5 conf printout:
Oct 12 10:05:33 gouda2 kernel: [  503.714399]  --- rd:3 wd:2
Oct 12 10:05:33 gouda2 kernel: [  503.714401]  disk 0, o:1, dev:sda2
Oct 12 10:05:33 gouda2 kernel: [  503.714404]  disk 1, o:1, dev:sdb2
Oct 12 10:05:33 gouda2 kernel: [  503.830570] md0: bitmap initialized from 
disk: read 29/29 pages, set 943717 bits
Oct 12 10:05:33 gouda2 kernel: [  503.830574] created bitmap (461 pages) for 
device md0
Oct 12 10:05:33 gouda2 kernel: [  503.853207] md0: detected capacity change 
from 0 to 3958232842240
Oct 12 10:05:33 gouda2 kernel: [  503.854739]  md0: unknown partition table
Oct 12 10:05:34 gouda2 kernel: [  504.628130] RAID5 conf printout:
Oct 12 10:05:34 gouda2 kernel: [  504.628136]  --- rd:3 wd:2
Oct 12 10:05:34 gouda2 kernel: [  504.628139]  disk 0, o:1, dev:sda2
Oct 12 10:05:34 gouda2 kernel: [  504.628142]  disk 1, o:1, dev:sdb2
Oct 12 10:05:34 gouda2 kernel: [  504.628145]  disk 2, o:1, dev:sdc3
Oct 12 10:05:34 gouda2 kernel: [  504.628671] md: recovery of RAID array md0
Oct 12 10:05:34 gouda2 kernel: [  504.628674] md: minimum _guaranteed_  speed: 
1000 KB/sec/disk.
Oct 12 10:05:34 gouda2 kernel: [  504.628677] md: using maximum available idle 
IO bandwidth (but not more than 200000 KB/sec) for recovery.
Oct 12 10:05:34 gouda2 kernel: [  504.628681] md: using 128k window, over a 
total of 1932730880 blocks.
Oct 12 10:17:24 gouda2 rsyslogd: -- MARK --
Oct 12 10:27:36 gouda2 smartd[2504]: Device: /dev/sda [SAT], SMART Usage 
Attribute: 181 Program_Fail_Cnt_Total changed from 252 to 100
Oct 12 10:27:37 gouda2 smartd[2504]: Device: /dev/sdb [SAT], SMART Prefailure 
Attribute: 1 Raw_Read_Error_Rate changed from 252 to 100
Oct 12 10:27:37 gouda2 smartd[2504]: Device: /dev/sdb [SAT], SMART Usage 
Attribute: 181 Program_Fail_Cnt_Total changed from 252 to 100
Oct 12 10:27:37 gouda2 smartd[2504]: Device: /dev/sdb [SAT], SMART Usage 
Attribute: 195 Hardware_ECC_Recovered changed from 252 to 100
Oct 12 10:27:38 gouda2 smartd[2504]: Device: /dev/sdc [SAT], SMART Usage 
Attribute: 181 Program_Fail_Cnt_Total changed from 252 to 100
Oct 12 10:57:24 gouda2 rsyslogd: -- MARK --
Oct 12 10:57:42 gouda2 kernel: [ 3632.830635] EXT3-fs (md0): using internal 
journal
Oct 12 10:57:42 gouda2 kernel: [ 3632.830641] EXT3-fs (md0): mounted 
filesystem with ordered data mode
