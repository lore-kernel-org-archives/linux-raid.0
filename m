From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: 14 disks for RAID 5 question
Date: Fri, 14 Nov 2003 11:04:46 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16308.7198.108317.6816@notabene.cse.unsw.edu.au>
References: <200311132001.hADK1GE32158@dns1.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from bugzilla@watkins-home.com on Thursday November 13
To: bugzilla@watkins-home.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 13, bugzilla@watkins-home.com wrote:
> I am setting up an array with 14 disks.
> Should I create one 14 disk RAID 5 array?
> Or two 7 disk RAID 5 arrays, and then RAID 0 them together?
> I know I would have less overall space with 2 RAID 5 arrays.  This is not
> an issue.
> 
> I guess the real question is: does RAID five have a sweet spot related to
> the number of disks?
> 
> Is there chunk size sweet spot?  Does it very with number of disks?
> 
> System: P3-500 (2 processors)
> 	512 Meg ram
> 	3 SCSI cards for disks.
> 		1 internal LVD (80 meg/second)
> 			2 disks (for OS) mirrored
> 			1 disk for spare
> 		1 external LVD (80 meg per second)
> 			7 disks
> 		1 external ultra-wide (40 meg per second)
> 			7 disks

Sweet spots are very system dependant.
Given the different performance characteristics of the two busses I
would make a raid5 out of each set of 7 disks and then combine the two
sets with raid0 or linear.

> 
> I could not find any performance info related to this subject.
> Also, could not find much about chunk size.
> 
> I did a simple dd test of these disks using a block size
> of 16, 32, 64, 128, 256, 512 and 1024K.  16 and 32K were best for overall
> speed and CPU usage.  It got worse as the block size increased.  I work with
> HP-UX systems alot.  On HP systems, as block size increases CPU load decreases.
> But HP-UX has raw (character) devices.  My dd test was with RedHat
> 8.0.

A dd test on the disk with a given blocksize is very different than a
dd test on a filesystem on a raid array on the disks.  
When doing tests it is *always* best to make the configuration and
load as close as possible to what you really plan to do as there are
many variable that can distort the outcome.

I find a chunksize of around 64k - 128k works pretty well.  Bigger
chunk sizes don't seem to give significant improvements.

NeilBrown
