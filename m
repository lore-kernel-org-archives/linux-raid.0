From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: softraid: controller? 5->6? grow?
Date: Tue, 4 Apr 2006 19:48:31 +0200
Message-ID: <200604041948.31141.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm currently planning my first raid array.
I intend to go for softraid (budget's the limiting factor), not sure about 5 
or 6 yet.

Plan so far: build a raid5 from 3 disks, later add a disk and reconf to raid6.
Question: is that possible at all? Can a raid5 be reconfed to a raid6 with 
raidreconf?
Next Question: how stable is it? Will I likely get away without making backups 
or is there like a 10% chance of failure?
Other precautions advised?

Next: Let's say I stick to raid5 for the moment and a disk dies. I heard that 
some people had another disk killed during resync because of the extra 
stress, hence losing the entire raid. 
This was attributed to the circumstance that all disks were from the same 
production series. True? Should I rather go for disks from different months? 
Or even brands? Are there vendors who ship sets fitting that purpose?

Another thing: I need a recommendation for a sATA controller.
Requirements: cheap, PCI, 4 ports sATA II. I had a look at a Sil3114 
controller, then noticed it was sATA-1. I don't even aim for the performance, 
but simply for the connectors. sATA-1 connectors are said to be troublesome 
for being fragile. If that can be neglected, let me know.

System is an nF2/AthlonXP2000+, PCI32bit, right now Slackware, 2.6.14.
Might become debian.

Thanks in advance,

Dex

-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C+++(++++) UL+>++++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS++(+) PE(-) Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D G++ e* h>++ r%>* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
