From: "David Lethe" <david@santools.com>
Subject: Re: Has anyone compared SWRAID for (JBOD@HW-RAID) vs. (Regular Sata PCI-e cards)?
Date: Sat, 10 May 2008 13:24:00 -0500
Message-ID: <140e01c8b2cb$27175a32$3401a8c0@exchange.rackspace.com>
Reply-To: <David@santools.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

there are still other factors to consider.  HW raid can usually be configured to monitor and repair bad blocks and data consistency in background with no cpu impact (but allow for bus overhead, depending on architecture.  When things go bad and RAID is in stress, then there is a world of difference between the methodologies. People rarely consider that ... Until they have corruption.  HW RAID (with  battery backup) will rarely corrupt on power failure or os crash, but is not immune.  SW RAID, however, exposes you much more.  Read the threads relating to bugs and data losses on md rebuilds after failures. The md code just can't address certain failure scenarios that HW RAID protects against .. But it still does a good job.  HW RAID is not immune by any means, some controllers have higher ri
 sk of loss then others.  Yes the OP asked for performance diffs, but performance under stress is fair game, as is data integrity.

Think about it ... 100 percent of disks fail, eventually, so data integrity and recovery must be considered.

Neither SW or HW RAID is best or covers all failure scenarios, but please don't make a deployment decision based on performance when everything is working fine.  Testing RAID is one of the things I do, so I speak from authority here. Too many people have blind faith that any kind of parity-protected RAID protects against hardware faults.  This is not the real-world behavior.  



-----Original Message-----

From:  "Jeff Garzik" <jeff@garzik.org>
Subj:  Re: Has anyone compared SWRAID for (JBOD@HW-RAID) vs. (Regular Sata PCI-e cards)?
Date:  Sat May 10, 2008 12:14 pm
Size:  1K
To:  "Justin Piszcz" <jpiszcz@lucidpixels.com>
cc:  "David Lethe" <david@santools.com>; "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>

Justin Piszcz wrote: 
> .. What I meant was is JBOD using a single card with 16 ports faster than 
> using JBOD with multiple PCI-e SATA cards? 
 
JBOD on a HW RAID card is really wasting it's primary purpose,  
offloading RAID processing from the CPU, and consolidating large  
transactions. 
 
Using HW RAID-1 means that, for example, _one_ copy of a 4k write to a  
RAID-1 device goes the card, which performs data replication to each  
device.  In SW RAID's case, $N copies cross the PCI bus, one copy for  
each device in the RAID-1 mirror. 
 
In HW RAID-5, one 4k write can go to the card, which then performs the  
parity calculation and data replication.  In SW RAID-5, the parity  
calculation occurs on the host CPU, and $N copies go across the PCI bus. 
 
Running HW RAID in JBOD mode eliminates all the efficiencies of HW RAID  
just listed.  You might as well run normal SATA at that point, because  
you gain additional flexibility and faster performance. 
 
But unless you are maxing out PCI bus bandwidth -- highly unlikely for  
PCI Express unless you have 16 SSDs or so -- you likely won't even  
notice SW RAID's additional PCI bus use. 
 
 
And of course, there are plenty of other factors to consider.  I wrote a  
bit on this topic at http://linux.yyz.us/why-software-raid.html 
 
	Jeff 
 
 
 


