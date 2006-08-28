From: Neil Brown <neilb@suse.de>
Subject: Re: invalid superblock - *again*
Date: Mon, 28 Aug 2006 13:38:16 +1000
Message-ID: <17650.25896.938033.522653@cse.unsw.edu.au>
References: <200608210104.17274.Dexter.Filmore@gmx.de>
	<200608220302.23412.Dexter.Filmore@gmx.de>
	<17642.23419.119010.518798@cse.unsw.edu.au>
	<200608221326.42776.Dexter.Filmore@gmx.de>
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
> Am Dienstag, 22. August 2006 03:18 schrieb Neil Brown:
> > >
> > > Most notable: [   38.536733] md: kicking non-fresh sdd1 from array!
> > > What does this mean?
> >
> > It means that the 'event' count on sdd1 is old compared to that on
> > the other partitions.  The most likely explanation is that when the
> > array was last running, sdd1 was not part of it.
> 
> Event count - so: a certain command or set of instructions was sent to all 
> disks, but one didn't get it, hence the raid module can't ensure that the 
> data on that disk is consistent with the rest of the array?
> 

Not exactly.  Events are thing like starting and stopping the array,
adding or removing drives, drive failure and clean <-> dirty
transitions.  If the event counts are not consistent, then when the
array was last stopped, one drive (at least) was missing from the
array. 

> > > What's happening here? What can I do? Do I have to readd sdd and resync?
> > > Or is there an easier way out? What causes these issues?
> >
> > Yes, you need to add sdd1 back to the array and it will resync.
> 
> Ok, if that's what it takes.
> 
> > I would need some precise recent history of the array to know why this
> > happened.  That might not be easy to come by.
> 
> Depends on what exactly you mean. Disk age? smart data? Hardware types? Logs? 
> OS?
> 

Complete kernel logs since a time when it was known to be good might
be enough - so I could track all the 'event's and see where it went
out of sync.

> I don't have more than a few vague guesses about what might have happened. 
> First of all it might be possible that the file systems on the array were not 
> unmounted properly during shutdown because a remote NFS mount was hogging 
> them. If that be the case, LVM couldn't have shut down properly, then the md 
> device wouldn't have stopped and the machine just powered down.
> That would explain it.

Maybe but even shutting down with the array still active shouldn't
cause the event counts to go out of sync.  It should just trigger a
resync.

NeilBrown
