From: chris <linux_mail@rozpooh.com>
Subject: RAID, Serial ATA, ReiserFS, EVMS
Date: Thu, 11 Mar 2004 00:15:03 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200403110015.03805.linux_mail@rozpooh.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I presently have a modest RAID 1 setup on a Highpoint 370 RAID controller 
built into my motherboard.  I very much need additional storage space and I 
am looking at serial ATA RAID solutions that will work with the 2.6.x kernel 
(it is my understanding that my existing highpoint raid controller is not yet 
supported in the newer kernel).

As I do not yet wish to upgrade my motherboard, I have been looking into add 
in serial ATA RAID controllers.  At this point, it seems that the 3Ware 
8506-4LP or the Adaptec 2410SA would be my primary choice (I don't see much 
point in spending money on low end RAID controller cards that still mostly 
rely on software in their drivers for RAID calculations).  However, I mostly 
intend to use RAID 1 and I am more interested in read performance than write.  
Rather than spend $350 on a hardware RAID controller, perhaps it would be in 
my best interests to implement software RAID.  In that case, I would simply 
invest in an add in non-RAID serial ATA controller card.

I am mainly interested in purchasing products from companies who are more 
cooperative in Linux driver support especially those companies offering 
source code that can be compiled with any kernel (rather than precompiled 
drivers for Red Hat or SUSE).

I seek advice in choosing serial ATA controller cards with the best supported 
chipsets (especially with 2.6.x) and from companies who are most helpful in 
the driver writing process.

I am also interested in comments regarding relatively low end hardware vs. 
software RAID.  Is there much advantage in hardware RAID unless you are using 
the highend gear?

My data archive is a large number of smaller (20 MB or less) files and I am 
thinking about using ReiserFS when I upgrade.  I am a little scared of Reiser 
4 (even though it appears to kick ass!) and have Reiser 3 in mind.  Does 
anyone trust Reiser with their precious RAIDs?

Also, I have been reading about EVMS and I am curious if most would agree that 
this is the direction that volume management in linux is headed.  I have the 
impression that this is much more than I need with my simple RAID 
implementation, but, I am curious what everyone thinks about EVMS in 
enterprise settings.  I assume that this a more mature product, but, not 
necessarily better than other solutions.  Thoughts?

-chris
