From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Can't create partitions on raid, --auto=mdp not possible
Date: Sat, 26 Apr 2008 13:46:03 +0200
Message-ID: <200804261346.03511.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

While I'm at migrating data to a new array I thought I get rid of LVM and 
partition the array directly - spares me one extra layer that I don't need.

Now, I can cfdisk md1 just fine and sfdisk -d shows me the partitions 
md1p[1-4], but as soon as I want to mkfs, I get:

-------------
# LC_ALL=en_EN mkfs.ext3 -O dir_index -E stride=16 -m 0 /dev/md1p1
mke2fs 1.40-WIP (14-Nov-2006)
Could not stat /dev/md1p1 --- No such file or directory

The device apparently does not exist; did you specify it correctly?
-------------

And lo and behold: in /dev no trace of md1p1 or md1/p1 or whatever. Only md1.


When assembling I get:

# mdadm -A -s
mdadm: that --auto option not compatable with device named /dev/md1

Here's my mdadm.conf:
DEVICE partitions
ARRAY /dev/md1 level=raid5 num-devices=5 auto=mdp 
 UUID=f2352335:f8654106:19a59613:120d8f39

This is debian 4.0r3 with kernel 2.6.22 from etch-backports and mdadm 2.5.6.

What do I have here? Version conflict? 

Dex


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.vorratsdatenspeicherung.de
