From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Keeping debian from auto-assembling
Date: Wed, 30 Apr 2008 13:54:35 +0200
Message-ID: <200804301354.35407.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'd like to assembla manually to investigate why the bloody 5th disk flies 
from the array at EVERY boot time (third so far, wonder how much stress the 
disks take) but I can't seen to disable it.

All 5 disks are 0xFD, but I passed raid=noautodetect to the end of the kernel 
line, I set "assemble at startup" in /etc/defaults/mdadm to "false", I 
cleared the mdadm.conf - still it assembles the array. No idea why.

Hints? I'm currently pretty much down with my nerves on this issue.

Dex


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.vorratsdatenspeicherung.de
