From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: no journaling and loops on softraid?
Date: Mon, 5 Mar 2007 23:55:15 +0100
Message-ID: <200703052355.15363.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

http://gentoo-wiki.com/HOWTO_Gentoo_Install_on_Software_RAID#Data_Scrubbing

"Warning: Be aware that the combination of RAID5 and loop-devices will most 
likely cause severe filesystem damage, especially when using ext3 and 
ReiserFS. Some users suggest that XFS is not affected by this, but this has 
not been entirely confirmed. See kernel bug 6242 for updates on this bug.

Note: There are also reports that Journaled Filesystems are problematic on all 
Software-RAID levels. No kernel bugs have been submitted regarding this bug 
as of yet. A number of the reports involve using cryptoloops which are known 
to cause corruption. See http://forums.gentoo.org/viewtopic-t-412467.html for 
more information. This thread should be taken with a grain of salt."

Can someone shed some light on this? I have XFS on my raid and *had* problems 
when unpacking large archives with many small files.

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
