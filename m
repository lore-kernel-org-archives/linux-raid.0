From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: consistency detect
Date: Mon, 11 Oct 2004 17:15:34 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1097529334.3103.22.camel@localhost.localdomain>
References: <1097465522.3111.24.camel@localhost.localdomain>
	 <416A4A29.9080906@wasp.net.au> <416A63B2.7020004@tls.msk.ru>
	 <416A6773.1080104@wasp.net.au>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <416A6773.1080104@wasp.net.au>
To: Brad Campbell <brad@wasp.net.au>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank all so much for reply.

On Mon, 2004-10-11 at 06:58, Brad Campbell wrote:
> Michael Tokarev wrote:
> 
> >> In short, it does not deal with it at all. RAID will deal with a disk 
> >> failure, it has no guarantees about consistency on power failures, 
> >> hard lockups or other catastrophic events.
> > 
> > 
> > This is incorrect.  In-kernel raid code keeps track of arrays and
> > underlying disk state during write operations.  On clean shutdown,
> > when everything has been written, raid superblocks on all disks
> > gets updated to indicate this.  In case of unclean shutdown, raid
> > code will reconstruct older copies of data using most recent ones
> > (ie, from a disk which has most recent "events" value in superblock).
> > The same is done for all other raid levels (4, 5, 6), but onot for
> > raid0 for obvious reasons (as there's no R in raid0 per se).
> 
> 
> When does the "events" value in the superblock actually get updated? I understood it only got 
> updated on an event, ie raid start, raid stop, disk add/remove/fail.
> 
yes, I guess if this information get updated frequently, it will have
impact on performance. but if not that frequently, it is useless for
this situation at all.


> I realise the system does an auto rebuild when started after an unclean shutdown, the question 
> really is how does it know which disk is the freshest in a raid-1? In a raid-4,5,6 it's pretty 
> obvious as there is really only one copy of the data, but then does the code actually ensure that 
> the data gets written before the updated parity? or does it just flush the lot to disk in what it 
> thinks is the most optimum fashion?
> 
> The In-kernel data becomes pretty moot when the kernel has just blasted a couple of large blocks out 
> to a couple of disks and the plug has been pulled. It's going to be pretty indeterminate as to which 
> disk has the most accurate image of what was actually sent to it. Thus my comment that there is 
> really no way of accurately dealing with a catastrophic failure, and RAID is not there to do that 
> anyway.
> 
with this indeterminate results, i do not know how raid code to detect
which one is the latest copy, or a half-half? and in previous email, u
suggest to have UPS and journal fs. but 1) u system will crash sometime
even with UPS, so a UPS can not 100% prevent this. 2) JFS can not 100%
solve this as well. especially when jfs only have metadata in log.


> I guess if you had a hardware RAID card that had a battery backed up RAM you have a much better 
> chance but then you really have a mini-ups :p)
> 
so here a NVRAM is the only way to solve this. :P also need a separate
cpu running separate code.

> Brad


ming


