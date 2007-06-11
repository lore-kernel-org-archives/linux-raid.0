From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: below 10MB/s write on raid5
Date: Mon, 11 Jun 2007 14:46:55 +0200
Message-ID: <200706111446.55813.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I recently upgraded my file server, yet I'm still unsatisfied with the write 
speed.
Machine now is a Athlon64 3400+ (Socket 754) equipped with 1GB of RAM.
The four RAID disks are attached to the board's onbaord sATA controller 
(Sil3114 attached via PCI)
Kernel is 2.6.21.1, custom on Slackware 11.0.
RAID is on four Samsung SpinPoint disks, has LVM, 3 volumes atop of each XFS.

The machine does some other work, too, but still I would have suspected to get 
into the 20-30MB/s area. Too much asked for?

Dex

-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
