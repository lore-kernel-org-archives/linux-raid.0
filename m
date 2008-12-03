From: "David Lethe" <david@santools.com>
Subject: RE: raid5 failed logical and physically; how to reconstruct?
Date: Wed, 3 Dec 2008 15:26:14 -0600
Message-ID: <A20315AE59B5C34585629E258D76A97C02E38658@34093-C3-EVS3.exchange.rackspace.com>
References: <06FA127F-E560-4D16-BF86-560F9ED82006@non-creative.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <06FA127F-E560-4D16-BF86-560F9ED82006@non-creative.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Schriever <paul@non-creative.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Paul Schriever
> Sent: Wednesday, December 03, 2008 2:52 PM
> To: linux-raid
> Subject: raid5 failed logical and physically; how to reconstruct?
> 
> Hi all,
> 
> having used mdadm and linux for slightly over a year now to great
> pleasure I came to face a problem. My raid5 got degraded due to hard
> disc failure. After this some form of logical damage also occurred.
> 
> Everytime I wish to mount md0 I get an error from the system telling
> it's unable to mount, something wrong with the superblock.
> 
> I tried to rebuild the array, without formatting the discs, and using
> a windows based tool I can still see that data is available, but
> garbled.
> 
> Is there any way of recovering the array, and to recover my data? I am
> not a big linux guru and any tutorial / steps to take would be very
> much appreciated!
> 
> yours
> 
> Paul
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Well, there are ways to recover it, but it comes down to how much damage
you started out with;  what damage (if any), the windows-based tool
might have done; whether or not you have unreadable blocks on surviving
disks.   If you just force a rebuild onto the new disk drive, then you
will absolutely make it worse.

If data loss could be in the thousands of dollars range, then I wouldn't
use a cookbook recovery.  Somebody who knows what they are doing and who
is directly involved will get more of your data back, and can look at
the raw blocks to see what is going on.  They may also look at the disk
that "failed" and perhaps get data from that disk.

I would immediately make raw copies of each physical device before going
further.  Hopefully you can pick up a cheap 1TB SATA disk and dd
everything onto it.  Not only can you play with a copy of the data, but
since you just lost a disk drive, then odds are high that another disk
in the RAID set will die.   Just one more drive failure and you have
100% data loss.
  
David


