From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Which raid card to buy for Sarge
Date: Thu, 01 Apr 2004 00:54:35 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <406BAE9B.6000306@pobox.com>
References: <200404010529.i315TbW21661@dns1.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200404010529.i315TbW21661@dns1.watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:
> With software RAID (md) you must invoke some commands to do the hot swap.
> It's not auto-magic.  Some of the hardware RAID systems I know of don't need
> any user input to re-sync.  Just swap the bad disk for a good one.
> 
> It would be nice if md could detect a disk being replaced and do everything
> needed without user input.

Yes, agreed.  This sort of communication would be the [simple] interface 
alluded to in other messages.



> BUT!!  md has a big difference on that point.
> md does not mirror disks!
> Read the above line again!
> 
> md mirrors partitions.  I think it is a major difference.  You must

No, that's not the major difference.  You are very close, though:

The difference is that md manipulates anonymous block devices.  The 
block devices can be whole disks, partitioned disks, un-partition-able 
media (nbd or ramdisk), whatever.  As long as it's a block device, md 
can handle it.

So, functioning at the Linux block device level as it does, md is much 
more abstract and generic than hardware RAID, or "controller-focused 
software RAID" (i.e. Adaptec host raid, DDF, Promise pdcraid, hptraid, 
Silicon Image Medley RAID, ...)

	Jeff



