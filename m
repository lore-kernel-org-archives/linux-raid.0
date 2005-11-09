From: Neil Brown <neilb@suse.de>
Subject: Re: Replacement disk is slightly smaller
Date: Wed, 9 Nov 2005 18:27:48 +1100
Message-ID: <17265.42228.180657.810453@cse.unsw.edu.au>
References: <20051109024211.GS7163@strugglers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andy Smith on Wednesday November 9
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@lug.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday November 9, andy@lug.org.uk wrote:
> 
> But what's the easiest way to do this?  I can't start creating
> partitions at the end can I?  Or maybe I can, in something other
> than fdisk.

You can create partitions in any way you like.  cfdisk is quite good
at making this ... not trivial, but not hard.
Create a tiny "1s" partition at the Beginning of the device.  This will be
sdb1.  Create another tiny partition - sdb2
Change the Units to 'sectors'.  Create another partition - sdb3 of the
desired size at the End. - put an 's' at the end of the number to
indicate sectors
   218837432s

Then delete sdb2 and create a new sdb2 using all the space.

Then add sdb3 to the raid5, and make a new raid0 array with
sd[abcd]2.  This will use all of the space of all those partitions
even though they aren't the same size.

> 
> Oh, and, will I need to do anything special (like shrink sd[acd]2)
> when trying to rebuild the stripe (md1) with the smaller patition
> from sdb?

No.  raid0 (like linear) does not need all the devices to be the same
size - it makes use of all available space.

> 
> Cheers,
> Andy
> 
> [1] Did it like that because I wanted /boot on a RAID 1, but I keep it
>     read only most of the time and didn't see the point in having it
>     a 4-way RAID 1.  But then, there isn't much to do with two
>     70-odd MB disk partitions so I made them hot spares.

You could have included them in the raid0, but having a least one
hot-spare for boot is a good idea.

NeilBrown
