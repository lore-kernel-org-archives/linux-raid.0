From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
Subject: mdadm kernel log messages explained
Date: Sun, 16 Sep 2012 10:57:11 +0200
Message-ID: <50559467.9030400@statystyka.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Welcome.

(This email is a copy of serverfault question 
http://serverfault.com/questions/427692/mdadm-kernel-log-messages-explained, 
which I guess didn't get to the right audience)
I try to recover from linux software raid failure. I am in a process of 
recreating the superblocks based on a syslog from the system when it was 
healthy. The log speaks about 2 md devices, each based on 5 500GB 
partitions. The RAID-5 /dev/md5 is composed from /dev/sd[b-f]6 and 
RAID-6 /dev/md6 is composed from /dev/sd[b-f]5. The relevant part dmesg 
log is at bottom of this mail.

Questions:
#    What do the numbers on the line [ 5.979771] 4: w=1 pa=0 pr=5 m=1 
a=2 r=5 op1=0 op2=0 mean, including the first 4:?
#    What do the numbers on the line [ 6.039266] --- rd:5 wd:5] mean?
  #   What do the numbers on the line [ 6.046856] disk 0, o:1, dev:sdb6 
mean?
  #   Does the line [ 6.096768] created bitmap (15 pages) for device md5 
tell anything about the place, where the bitmap is located and what is 
its size?

|[    5.964928] raid5: allocated 5265kB for md5
[    5.979771] 4: w=1 pa=0 pr=5 m=1 a=2 r=5 op1=0 op2=0
[    5.987064] 1: w=2 pa=0 pr=5 m=1 a=2 r=5 op1=0 op2=0
[    5.994256] 3: w=3 pa=0 pr=5 m=1 a=2 r=5 op1=0 op2=0
[    6.001441] 2: w=4 pa=0 pr=5 m=1 a=2 r=5 op1=0 op2=0
[    6.008665] 0: w=5 pa=0 pr=5 m=1 a=2 r=5 op1=0 op2=0
[    6.015883] raid5: raid level 5 set md5 active with 5 out of 5 devices, algorithm 2
[    6.031441] RAID5 conf printout:
[    6.039266]  --- rd:5 wd:5
[    6.046856]  disk 0, o:1, dev:sdb6
[    6.054308]  disk 1, o:1, dev:sdf6
[    6.061524]  disk 2, o:1, dev:sdc6
[    6.068667]  disk 3, o:1, dev:sde6
[    6.075774]  disk 4, o:1, dev:sdd6
[    6.089504] md5: bitmap initialized from disk: read 1/1 pages, set 0 bits
[    6.096768] created bitmap (15 pages) for device md5
[    6.141010] md5: detected capacity change from 0 to 1978409418752
[    6.153794]  md5: unknown partition table

[    5.594614] raid5: device sde5 operational as raid disk 3
[    5.599701] raid5: device sdd5 operational as raid disk 4
[    5.604750] raid5: device sdf5 operational as raid disk 1
[    5.609879] raid5: device sdc5 operational as raid disk 2
[    5.615032] raid5: device sdb5 operational as raid disk 0
[    5.621672] raid5: allocated 5265kB for md6
[    5.627243] 3: w=1 pa=0 pr=5 m=2 a=2 r=5 op1=0 op2=0
[    5.632846] 4: w=2 pa=0 pr=5 m=2 a=2 r=5 op1=0 op2=0
[    5.638502] 1: w=3 pa=0 pr=5 m=2 a=2 r=5 op1=0 op2=0
[    5.644155] 2: w=4 pa=0 pr=5 m=2 a=2 r=5 op1=0 op2=0
[    5.649844] 0: w=5 pa=0 pr=5 m=2 a=2 r=5 op1=0 op2=0
[    5.655566] raid5: raid level 6 set md6 active with 5 out of 5 devices, algorithm 2
[    5.667653] RAID5 conf printout:
[    5.673791]  --- rd:5 wd:5
[    5.679837]  disk 0, o:1, dev:sdb5
[    5.685721]  disk 1, o:1, dev:sdf5
[    5.691570]  disk 2, o:1, dev:sdc5
[    5.697348]  disk 3, o:1, dev:sde5
[    5.703122]  disk 4, o:1, dev:sdd5
[    5.710762] md6: bitmap initialized from disk: read 1/1 pages, set 0 bits
[    5.716915] created bitmap (15 pages) for device md6|

-- 
Adam Ryczkowski
Skype:sisteczko
