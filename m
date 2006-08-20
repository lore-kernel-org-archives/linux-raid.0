From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: invalid superblock - why?
Date: Mon, 21 Aug 2006 01:04:17 +0200
Message-ID: <200608210104.17274.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

raid5, 4 sata disks, slackware with 2.6.14.6.
Yesterday the machine hung, so I used MagicKey to sync, remount read only and 
reboot.
After that the third disk was not assembled into the array.
dmesg came up with:

[   34.652268] md: md0 stopped. 
[   34.742673] md: bind<sdb1> 
[   34.742900] md: invalid superblock checksum on sdc1 
[   34.742920] md: sdc1 has invalid sb, not importing! 
[   34.742941] md: md_import_device returned -22 
[   34.743257] md: bind<sdd1> 
[   34.743464] md: bind<sda1> 
[   34.743506] raid5: device sda1 operational as raid disk 0 
[   34.743524] raid5: device sdd1 operational as raid disk 3 
[   34.743542] raid5: device sdb1 operational as raid disk 1 
[   34.744128] raid5: allocated 4195kB for md0 
[   34.744146] raid5: raid level 5 set md0 active with 3 out of 4 devices, alg 
orithm 2 
[   34.744173] RAID5 conf printout: 
[   34.744187]  --- rd:4 wd:3 fd:1 
[   34.744202]  disk 0, o:1, dev:sda1 
[   34.744216]  disk 1, o:1, dev:sdb1 
[   34.744231]  disk 3, o:1, dev:sdd1

So after throwing a minor fit (my first degraded array) I started 
investigating options. Whe I was sure the disk was alright I re-added it and 
resyncing started. 
It's currently still at it.

Question: what happened to that superblock? just because it didn't shut down 
properly? Disk seems to be ok.

-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
