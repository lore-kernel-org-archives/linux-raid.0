From: Neil Brown <neilb@suse.de>
Subject: Re: invalid superblock - *again*
Date: Tue, 22 Aug 2006 11:18:51 +1000
Message-ID: <17642.23419.119010.518798@cse.unsw.edu.au>
References: <200608210104.17274.Dexter.Filmore@gmx.de>
	<17641.3010.978057.92568@cse.unsw.edu.au>
	<200608211304.12010.Dexter.Filmore@gmx.de>
	<200608220302.23412.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dexter Filmore on Tuesday August 22
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday August 22, Dexter.Filmore@gmx.de wrote:
> Am Montag, 21. August 2006 13:04 schrieb Dexter Filmore:
> I seriously don't know what's going on here.
> I upgraded packages and rebooted the machine to find that now disk 4 of 4 is 
> not assembled.
> 
> Here's dmesg and mdadm -E 
> 
> ***************** dmesg ******************
> [   38.439644] md: md0 stopped.
> [   38.536089] md: bind<sdb1>
> [   38.536301] md: bind<sdc1>
> [   38.536501] md: bind<sdd1>
> [   38.536702] md: bind<sda1>
> [   38.536733] md: kicking non-fresh sdd1 from array!
> [   38.536751] md: unbind<sdd1>
> [   38.536765] md: export_rdev(sdd1)
> [   38.536794] raid5: device sda1 operational as raid disk 0
> [   38.536812] raid5: device sdc1 operational as raid disk 2
> [   38.536831] raid5: device sdb1 operational as raid disk 1
> [   38.537453] raid5: allocated 4195kB for md0
> [   38.537471] raid5: raid level 5 set md0 active with 3 out of 4 devices, 
> algor
> ithm 2
> [   38.537499] RAID5 conf printout:
> [   38.537513]  --- rd:4 wd:3 fd:1
> [   38.537528]  disk 0, o:1, dev:sda1
> [   38.537543]  disk 1, o:1, dev:sdb1
> [   38.537558]  disk 2, o:1, dev:sdc1
> *********************************************
> 
> Most notable: [   38.536733] md: kicking non-fresh sdd1 from array!
> What does this mean?

It means that the 'event' count on sdd1 is old compared to that on
the other partitions.  The most likely explanation is that when the
array was last running, sdd1 was not part of it.

> 
> What's happening here? What can I do? Do I have to readd sdd and resync? Or is 
> there an easier way out? What causes these issues?
> 

Yes, you need to add sdd1 back to the array and it will resync.

I would need some precise recent history of the array to know why this
happened.  That might not be easy to come by.

NeilBrown
