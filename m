From: John Rowe <rowe@excc.ex.ac.uk>
Subject: Re: New features?
Date: Tue, 31 Oct 2006 12:09:17 +0000
Message-ID: <1162296558.32109.124.camel@kenny>
References: <1162293818.32109.113.camel@kenny>
	 <17735.14472.835153.186432@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17735.14472.835153.186432@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for this Neil, good to know that most of what I would like is
already available. I think your reply highlights what I almost put in
there as my first priority: documentation, specifically a HOWTO.

> I believe that 2.6.18 has SATA hot-swap, so this should be available
> know ... providing you can find out what commands to use.

Exactly!

> > 2 Adding new disks to arrays. Allows incremental upgrades and to take
> > advantage of the hard disk equivalent of Moore's law.
> 
> Works for raid5 and linear.  Raid6 one day.

Am I misinterpreting the mdadm 2.5 man pages when it says:

        Grow (or shrink) an array, or otherwise reshape it in some way.
        Currently supported growth options including changing the active
        size of component devices in RAID level 1/4/5/6 and changing the
        number of active devices in RAID1.

> > 3. RAID level conversion (1 to 5, 5 to 6, with single-disk to RAID 1 a
> > lower priority).
> 
> A single disk is large than a RAID1 built from it, so this is
> non-trivial.  What exactly do you want to do there.

Single to disk is less important, but adding a third disk to a RAID1
pair to make a RAID5 would be nice as would be adding one or more disks
to a RAID5 to make a RAID6.

John


