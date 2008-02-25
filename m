From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: board/controller recommendations?
Date: Mon, 25 Feb 2008 14:24:56 +0100
Message-ID: <200802251424.57325.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Currently my array consists of four Samsung Spinpoint sATA drives, I'm about 
to enlarge to 6 drive.
As of now they sit on an Sil3114 controller via PCI, hence there's a 
bottleneck, can't squeeze more than 15-30 megs write speed (rather 15 today 
as the xfs partitions on it are brim full and started fragmenting).

Now, I'd like to go for a AMD board with 6 sATA channels connected via PCIe - 
can someone recomend a board here? Preferrably AMD 690 based so I won't need 
a video card or similar.

Dex

-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.vorratsdatenspeicherung.de
