From: Simon Valiquette <v.simon@ieee.org>
Subject: growing a RAID-5 array live
Date: Fri, 28 Jan 2005 18:15:02 -0500
Message-ID: <41FAC776.6010202@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hello,

   I would like to add code to be able to grow a RAID-5 array while 
keeping the filesystem in read/write mode.  Also, I want the data to be 
able to survive over a power failure and a disk failure.  Actually, as far 
as I know, there is no tools for doing that with Linux.  The closest tools 
I know for that is raidreconf, but I want more than what it can give me 
and I certainly want something safer.  And doing it while the FS is mounted.

   I am willing to do the work, but I still don't have a deep enought 
understanding of the software raid internal implementation.  Do there is 
any documentation about that?  I did'nt find much except what is in the 
./Documentation directory, so I might have to write it myself.


   My intent would be to play at the bio and biovec level, so that the 
filesystem can be kept online while we do the restriping.  The basic trick 
is to be able to use 2 superblocks for the same array at the same time. 
When we access data that have not yet been converted to the new format, we 
use the old superblock because the data are still there (obviously).  When 
we use data that have already been converted, we use the new superblock 
(because we now have them on the new location).  And between is the fun if 
we want to minimise the risk of data lost in case of power failure or crash.

   It would makes me save a lot of time if people comments on which parts 
of the kernel software RAID code I should put my modifications.  Note that 
I will require the stripe size not to change, as it would otherwise be 
very innefficient, and a real nightmare to maintain (use raidreconf instead).


   Eventually, I hope this code could also be used to convert between 
differents kinds of RAID (ie. conversion from RAID-5 to RAID-6, or RAID-0 
to RAID-5).  As long the stripe size does'nt change, that should be 
possible since I already need the RAID array to support two different 
superblocks.


   So, I need documentation about the internal implementation of the 
software RAID array and the interactions between the different parts in 
the kernel, or at least a mentor to guide me.  I already have an 
algorithm, I just need help to know how and where to makes the changes to 
have a working prototype.

   Thank you,

Simon Valiquette
http://gulus.USherbrooke.ca



