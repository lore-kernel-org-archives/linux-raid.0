From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: non-fresh from initrd, all fine when assembling manually
Date: Fri, 2 May 2008 14:46:32 +0200
Message-ID: <200805021446.32835.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My issues from the last few days all summed up in one, maybe someone knows 
what to do about it, I CC to the debian list as well:


Software raid5 on debian etch with 2.6.22 kernel from backports.

Hardware: Asus K8N-E Deluxe, nForce3/250Gb chipset. 
Has: 
2 sATA ports from the nF3 (sata_nv)
4 sATA ports from an onboard Silicon Image 3114 (sata_sil)
4 sATA ports from an PCI controller, Silicon Image 3114, too.

I used to run this setup:
4x Samsung Spinpoint 250GB on the onboard 3114, started by initrd. All fine.

Now I upgraded to 5x500GB. Built the array degraded on the 4 PCI controller 
ports, transferred all the data, then moved the 4x500 to the onboard 3114.

Now I added the fifth disk and --add'ed it to the array and it synced.

I thought all was fine. Wrong.

Upon reboot, the 5th disk that now sat on the PCI controller alone was kicked 
from the array for being non fresh. I suspected a shutdown problem, found one 
with 2.6.22 and the shutdown utility, fixed that and resynced.
Next reboot: same story.
So I synced, booted a live CD (knoppix) and checked out mdadm -E in regard of 
the event count. All ok. So no shutdown problem.
I even moved the fifth disk from the PCI controller to the NV controller on 
the board.

Two resyncs later I decided to reconf mdadm to *not* start from the initrd and 
not auto-assemble at boot time.
I then assembled the array manually and tadaa, all fine, array works and is 
synced.

Now: what's going on here? both onboard 3114 and pci 3114 controllers are 
handled by the same kernel module, so either initrd sees all or none.
Why would it not wanna see the 5th disk from initrd, but when I manually 
assemble, it's fine?

Dex


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.vorratsdatenspeicherung.de
