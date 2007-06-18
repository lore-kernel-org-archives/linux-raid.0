From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: resync to last 27h - usually 3. what's this?
Date: Mon, 18 Jun 2007 16:59:32 +0200
Message-ID: <200706181659.32119.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bootet today, got this in dmesg:

[   44.884915] md: bind<sdd1>
[   44.885150] md: bind<sda1>
[   44.885352] md: bind<sdb1>
[   44.885552] md: bind<sdc1>
[   44.885601] md: kicking non-fresh sdd1 from array!
[   44.885637] md: unbind<sdd1>
[   44.885671] md: export_rdev(sdd1)
[   44.900824] raid5: device sdc1 operational as raid disk 1
[   44.900860] raid5: device sdb1 operational as raid disk 3
[   44.900895] raid5: device sda1 operational as raid disk 2
[   44.901207] raid5: allocated 4203kB for md0
[   44.901241] raid5: raid level 5 set md0 active with 3 out of 4 devices, 
algorithm 2
[   44.901284] RAID5 conf printout:
[   44.901317]  --- rd:4 wd:3
[   44.901349]  disk 1, o:1, dev:sdc1
[   44.901381]  disk 2, o:1, dev:sda1
[   44.901414]  disk 3, o:1, dev:sdb1

Checked the disk, seemed fine (not the first time linux kicked a disk for no 
apparent reason), readded it with mdadm which triggered a resync.
Now having a look at it I get:

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdd[4] sdc1[1] sdb1[3] sda1[2]
      732563712 blocks level 5, 32k chunk, algorithm 2 [4/3] [_UUU]
      [=>...................]  recovery =  8.1% (19867520/244187904) 
finish=1661.6min speed=2248K/sec

1661 minutes is *way* too long. it's a 4x250GiB sATA array and usually takes 3 
hours to resync or check, for that matter.

So, what's this? 


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
