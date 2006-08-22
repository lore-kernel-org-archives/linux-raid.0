From: Steve Cousins <steve.cousins@maine.edu>
Subject: Correct way to create multiple RAID volumes with hot-spare?
Date: Tue, 22 Aug 2006 15:05:29 -0400
Message-ID: <44EB5579.4020200@maine.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I have a set of 11 500 GB drives. Currently each has two 250 GB 
partitions (/dev/sd?1 and /dev/sd?2).  I have two RAID6 arrays set up, 
each with 10 drives and then I wanted the 11th drive to be a hot-spare. 
  When I originally created the array I used mdadm and only specified 
the use of 10 drives since the 11th one wasn't even a thought at the 
time (I didn't think I could get an 11th drive in the case).  Now I can 
manually add in the 11th drive partitions into each of the arrays and 
they show up as a spares but on reboot they aren't part of the set 
anymore.  I have added them into /etc/mdadm.conf and the partition type 
is set to be  Software RAID (fd).

Maybe I shouldn't be splitting the drives up into partitions.  I did 
this due to issues with volumes greater than 2TB.  Maybe this isn't an 
issue anymore and I should just rebuild the array from scratch with 
single partitions.  Or should there even be partitions? Should I just 
use /dev/sd[abcdefghijk] ?

On a side note, maybe for another thread, the arrays work great until a 
reboot (using 'shutdown' or 'reboot' and they seem to be shutting down 
the md system correctly).  Sometimes one or even two (yikes!) partitions 
in each array go offline and I have to mdadm /dev/md0 -a /dev/sdx1 it 
back in.  Do others experience this regularly with RAID6?  Is RAID6 not 
ready for prime time?

As for system information, it is (was) a Dual Opteron with CentOS 4.3 
(now I'm putting FC5 on it as I write) with a 3Ware 8506-12 SATA RAID 
card that I am using in JBOD mode so I could do software RAID6.

Thanks for your help.

Steve
-- 
______________________________________________________________________
  Steve Cousins, Ocean Modeling Group    Email: cousins@umit.maine.edu
  Marine Sciences, 452 Aubert Hall       http://rocky.umeoce.maine.edu
  Univ. of Maine, Orono, ME 04469        Phone: (207) 581-4302


