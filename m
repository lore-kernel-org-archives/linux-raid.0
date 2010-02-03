From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: problem changing raid level with Ubuntu 10.04 / 2.6.32 / mdadm
 3.1.1
Date: Wed, 3 Feb 2010 20:12:32 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1002032009410.31777@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1002031944020.31777@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1002031944020.31777@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 3 Feb 2010, Mikael Abrahamsson wrote:

> Am I missing something?

Seems I was, it works properly without bitmap. I first removed the bitmap, 
i first grew it to 4 drives while still being raid5, then I added a 6th 
drive and did this:

root@swmike-test:~/mdadm-3.1.1# ./mdadm --grow /dev/md0 --level=6 --raid-disks=6
mdadm level of /dev/md0 changed to raid6
mdadm: Need to backup 768K of critical section..

[  499.564157] raid5: device sdb2 operational as raid disk 0
[  499.564160] raid5: device sdg operational as raid disk 3
[  499.564162] raid5: device sde operational as raid disk 2
[  499.564165] raid5: device sdc operational as raid disk 1
[  499.564583] raid5: allocated 5265kB for md0
[  499.592869] 0: w=1 pa=0 pr=5 m=2 a=18 r=5 op1=0 op2=0
[  499.592873] 3: w=2 pa=0 pr=5 m=2 a=18 r=5 op1=0 op2=0
[  499.592875] 2: w=3 pa=0 pr=5 m=2 a=18 r=5 op1=0 op2=0
[  499.592878] 1: w=4 pa=0 pr=5 m=2 a=18 r=5 op1=0 op2=0
[  499.592881] raid5: raid level 6 set md0 active with 4 out of 5 devices, algorithm 18
[  499.592883] RAID5 conf printout:
[  499.592885]  --- rd:5 wd:4
[  499.592887]  disk 0, o:1, dev:sdb2
[  499.592890]  disk 1, o:1, dev:sdc
[  499.592891]  disk 2, o:1, dev:sde
[  499.592893]  disk 3, o:1, dev:sdg
[  500.274685] RAID5 conf printout:
[  500.274689]  --- rd:6 wd:5
[  500.274691]  disk 0, o:1, dev:sdb2
[  500.274694]  disk 1, o:1, dev:sdc
[  500.274696]  disk 2, o:1, dev:sde
[  500.274697]  disk 3, o:1, dev:sdg
[  500.274699]  disk 4, o:1, dev:sdh
[  500.274705] RAID5 conf printout:
[  500.274706]  --- rd:6 wd:5
[  500.274708]  disk 0, o:1, dev:sdb2
[  500.274710]  disk 1, o:1, dev:sdc
[  500.274711]  disk 2, o:1, dev:sde
[  500.274713]  disk 3, o:1, dev:sdg
[  500.274715]  disk 4, o:1, dev:sdh
[  500.274716]  disk 5, o:1, dev:sdf
[  500.274764] md: reshape of RAID array md0
[  500.274768] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  500.274770] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
[  500.274777] md: using 128k window, over a total of 2104448 blocks.

That seems to have worked just fine...

Any reason this doesn't work with a bitmap, and if it doesn't, then 
perhaps this should be documented somewhere or at least mdadm should throw 
an error message?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
