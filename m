From: Mike Tran <mhtran@us.ibm.com>
Subject: RE: raid and sleeping bad sectors
Date: 30 Jun 2004 16:40:55 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1088631655.5376.311.camel@star2.austin.ibm.com>
References: <200406300219.i5U2JW327038@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200406300219.i5U2JW327038@watkins-home.com>
To: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Guy,

I'm glad you did not oppose plan a) :)

Before ruling out some kind of bad block relocation, I still think there
are some scenarios which may be worth to consider.

In your environment, for example, assume you shipped a system configured
with 2-way 400GB mirror.  Over time, both disks have had bad blocks and
the firmware can longer relocate bad blocks.  The database application
writes 100MB table.  Which one of the following 2 service calls you
would like receive?

1. "The database is corrupt. The 400GB raid1 volume is not operational."
-or-
2. "The email sent by MD monitor utility said "The raid1 array is
running in degraded mode and 50% of the reserved sectors have been
used.  Please take appropriate actions."  What should I do?"

Even the original author of Software RAID how-to made mistakes :) and
suggested that MD should have built-in bad block relocation, please
read  http://linas.org/linux/peeves.html

Having bad block relocation can also be a big plus during reconstruction
of a degraded MD array (i.e. thanks to the fact that bad sectors on one
of the remaining disks had been remapped, the reconstruction completes
successfully!)

As for implementation of bad block relocation, you're right.  Persistent
metadata (mapping table) is required.  I see the risk you mentioned is
about the same as having other MD metadata (superblock) and
reconstruction of degraded arrays.  Also, the disk contains the reserved
sectors could be a "small spare."

Just curious... How do you know the I/O failure is/isn't a bad block? 
From my knowledge, the only error is -EIO.


Regards,
Mike T.

On Tue, 2004-06-29 at 21:19, Guy wrote:
> I don't think plan b needs to be handled as stated.  If a cable is loose,
> the amount of data that needs to be written somewhere else could be vast.
> At least as big as 1 disk!  Maybe just re-try the write.  If the failure is
> not a bad block, then let it die!  Unless you want to allow the user to
> define the amount of spare space.  Create an array, but leave x% of the
> space unused for temp data relocation.  So, what do you do when the x% is
> full?  To me it seems too risky to attempt to track the re-located data.
> After all you must be able to re-boot without loosing this data.  Otherwise,
> don't even attempt it.  The "normal" systems administrator (operator) is
> going to try a re-boot as the first step in correcting a problem!!!  I am
> not referring to the systems administrator that installed the system!  I am
> referring to the people that "operate" the system.  In some cases they may
> be the same person, luck you.  In my environment we tend to deliver systems
> to customers, they "operate" the systems.
> 
> If the hard drive can't re-locate the bad block, then, accept that you have
> had a failure.  But, maybe still attempt reads, the drive may come back to
> life some day.  But then you must track which blocks are good and which are
> not.  The not good blocks (stale) must be re-built, the good blocks (synced)
> can still be read.  This info also must be retained after a re-boot.  Again,
> too risky to me!
> 
> That brings me back to:
> If the hard drive can't re-locate the bad block, then, accept that you have
> had a failure.
> 
> Guy
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mike Tran
> Sent: Tuesday, June 29, 2004 7:45 PM
> To: linux-raid
> Subject: Re: raid and sleeping bad sectors
> 
> On Tue, 2004-06-29 at 15:56, Dieter Stueken wrote:
> > Mike Tran wrote:
> > > (Please note that I don't mean to advertise EVMS here :) just want to
> > > mention that the functionality is available)
> > > 
> > > EVMS, (http://evms.sourceforge.net) provides a solution to this "bad
> > > sectors" issue by having Bad Block Relocation (BBR) layer on the I/O
> > > stack.
> > 
> > Before proposing any solutions, i think it is very important to
> > distinguish carefully between different kinds of errors:
> > 
> > a) read errors: some alert bell should ring (syslog/mail..)
> >     but the system should not careless disable any disk to avoid
> >     making the problem even worse.
> > 
> > b) write errors: if some blocks are written partly, but can not
> >     be written to all disks, it may help, to write the data
> >     (may be temporary) somewhere else.
> > 
> > when we got a read error, due to an unreadable sector, we may
> > first try to rewrite it. In most cases, bad sector replacement
> > of the HD-firmware takes action and the problem is solved so far.
> > 
> 
> For raid1 mirroring, I think the code for "rewrite" does not look too
> bad.  For raid5/raid5, it's going be harder.  I'm not saying that it's
> not doable :)
> 
> In fact, there is a cnt_corrected_read field in the MD ver 1
> superblock.  So, I hope this feature is coming soon.
> 
> 
> > Only after this failed, we should turn over to plan b)
> > 
> > case b) may also help, if some disk gets temporary unavailable
> > (i.E. cabling problem). After manual intervention, that brings
> > the disk back on line again, the redirected data may even be
> > copied back.
> > 
> 
> Plan b) needs that "somewhere else."  This can also be achieved with the
> MD ver 1 superblock.  Where we can reserve some sectors by correcly
> setting the usable data_offset and data_size.
> 
> Now, we need user-space tool to create MD arrays with ver 1 superblock. 
> In addition, of course, we will also need to enhance MD kernel code.
> 
> 
> Cheers,
> Mike T.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

