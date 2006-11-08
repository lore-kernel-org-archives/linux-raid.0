From: "James Lee" <james.lee@cantab.net>
Subject: Re: RAID5 array showing as degraded after motherboard replacement
Date: Wed, 8 Nov 2006 01:16:39 +0000
Message-ID: <ef2613f30611071716u1c5b8fcy373d1d632acddd17@mail.gmail.com>
References: <ef2613f30611050858m562386a0m7966667f803f35fc@mail.gmail.com>
	 <Pine.LNX.4.64.0611051247550.13706@twinlark.arctic.org>
	 <ef2613f30611051607t24fdcec0qe6f37227e4118b73@mail.gmail.com>
	 <Pine.LNX.4.64.0611060028120.20361@twinlark.arctic.org>
	 <ef2613f30611061618n185978daqc8e4a07368b6baec@mail.gmail.com>
	 <ef2613f30611071715q2a6776eaya219349d667b43b1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ef2613f30611071715q2a6776eaya219349d667b43b1@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/11/06, James Lee <james.lee@cantab.net> wrote:
> On 07/11/06, James Lee <james.lee@cantab.net> wrote:
> > On 06/11/06, dean gaudet <dean@arctic.org> wrote:
> > >
> > >
> > > On Mon, 6 Nov 2006, James Lee wrote:
> > >
> > > > Thanks for the reply Dean.  I looked through dmesg output from the
> > > > boot up, to check whether this was just an ordering issue during the
> > > > system start up (since both evms and mdadm attempt to activate the
> > > > array, which could cause things to go wrong...).
> > > >
> > > > Looking through the dmesg output though, it looks like the 'missing'
> > > > disk is being detected before the array is assembled, but that the
> > > > disk is throwing up errors.  I've attached the full output of dmesg;
> > > > grepping it for "hde" gives the following:
> > > >
> > > > [17179574.084000]     ide2: BM-DMA at 0xd400-0xd407, BIOS settings:
> > > > hde:DMA, hdf:DMA
> > > > [17179574.380000] hde: NetCell SyncRAID(TM) SR5000 JBOD, ATA DISK drive
> > > > [17179575.312000] hde: max request size: 512KiB
> > > > [17179575.312000] hde: 625134827 sectors (320069 MB), CHS=38912/255/63, (U)DMA
> > > > [17179575.312000] hde: set_geometry_intr: status=0x51 { DriveReady
> > > > SeekComplete Error }
> > > > [17179575.312000] hde: set_geometry_intr: error=0x04 { DriveStatusError }
> > > > [17179575.312000] hde: cache flushes supported
> > >
> > > is it possible that the "NetCell SyncRAID" implementation is stealing some
> > > of the sectors (even though it's marked JBOD)?  anyhow it could be the
> > > disk is bad, but i'd still be tempted to see if the problem stays with the
> > > controller if you swap the disk with another in the array.
> > >
> > > -dean
> > >
> >
> > Looks like you might be right.  I removed one of the other drives from
> > the onboard controller, and moved the 'faulty' drive from the NetCell
> > controller to the onboard one.  Booted up up the machine, and the
> > drive is still not added to the array correctly (so the array now
> > fails to assemble, as there's only 3 out of 5 drives).  I've run the
> > Seagate diagnostics tools over the drive and they report successful
> > when it's connected to the onboard controller and unsuccessful when
> > it's connected to the NetCell controller (this may be a test tool
> > issue though).
> >
> > I guess this indicates that either:
> > 1) The NetCell controller is faulty and just not reading/writing data properly.
> > 2) The NetCell controller's RAID implementation has somehow not been
> > transparent to the OS and has overwritten/modified md's superblocks.
> > 3) EVMS somehow messed the config up on that drive when trying to
> > reassemble the array after the first time the controller came up.
> >
> > I'll test for 1) by attaching another drive (not one of the ones in
> > the array!) to the NetCell contoller and seeing if it passed
> > diagnostics tests.  3) seems pretty unlikely.
> >
> > I bought the NetCell card mainly for its Linux compatibility - do they
> > have known issues with mdadm?
> >
> > Thanks,
> > James
> >
>
> Well I'm still a little unsure what might have happened here.  I've
> reconnected the 'bad' drive to the NetCell controller, and run
> badblocks over that device.  It isn't reporting any bad blocks at all,
> which I guess pretty much indicates that neither the hard drive nor
> the controller are faulty right?
>
> However I'm still seeing the error messages in my dmesg (the ones I
> posted earlier), and they suggest that there is some kind of hardware
> fault (based on a quick Google of the error codes).  So I'm a little
> confused.
>
> If the hard-drive and controller are not faulty, then how can I go
> about figuring out whether the drive got messed up by the controller
> going and overwriting some data due to it's internal RAIDing (which
> would seem unlikely - I'd assume this would have been reported and
> fixed as it would not just be a Linux problem)?  I guess the other
> possibility is that in the process of the motherboard dying, some data
> on the drive corrupted - does this seem at all plausible?
>
> Basically I'm just not sure how to move forward in a way that I can
> feel confident that this won't happen again (possibly in a more
> serious way that means losing all the data on the array).  Would
> dumping the sectors at the start of the drive help at all to figure
> out what's going on?
>

[Sorry for the double mail - forgot to CC the list]
