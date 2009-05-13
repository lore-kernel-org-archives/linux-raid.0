From: Neil Brown <neilb@suse.de>
Subject: Re: Requesting replace mode for changing a disk
Date: Wed, 13 May 2009 21:02:05 +1000
Message-ID: <18954.43181.558444.360139@notabene.brown>
References: <20090513012112681.IEFQ19662@cdptpa-omta02.mail.rr.com>
	<87zldhvg0v.fsf@frosties.localdomain>
	<18954.20061.109627.591832@notabene.brown>
	<874ovpihcj.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Goswin von Brederlow on Wednesday May 13
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: lrhorer@satx.rr.com, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday May 13, goswin-v-b@web.de wrote:
> Neil Brown <neilb@suse.de> writes:
> 
> > On Wednesday May 13, goswin-v-b@web.de wrote:
> >> > OK, basically the same question.  How does one disassemble the RAID1 array
> >> > without wiping the data on the new drive?
> >> 
> >> I think he ment this:
> >> 
> >> mdadm --stop /dev/md0
> >> mdadm --build /dev/md9 --chunk=64k --level=1 --raid-devices=2 /dev/suspect /dev/new
> >> mdadm --assemble /dev/md0 /dev/md9 /dev/other ...
> >
> > or better still:
> >
> >   mdadm --grow /dev/md0 --bitmap internal
> >   mdadm /dev/md0 --fail /dev/suspect --remove /dev/suspect
> >   mdadm --build /dev/md9 --level 1 --raid-devices 2 /dev/suspect missing
> >   mdadm /dev/md0 --add /dev/md9
> >   mdadm /dev/md9 --add /dev/new
> >
> > no down time at all.  The bitmap ensures that /dev/md9 will be
> > recovered almost immediately once it is added back in to the array.
> 
> I keep forgetting bitmaps. :)
> 
> > The one problem with this approach is that if there is a read error on
> > /dev/suspect while data is being copied to /dev/new, you lose.
> >
> > Hence the requested functionality which I do hope to implement for
> > raid456 and raid10 (it adds no value to raid1).
> > Maybe by the end of this year... it is on the roadmap.
> >
> > NeilBrown
> 
> What about raid0? You can't use your bitmap trick there.

I seriously had not considered raid0 for this functionality at all.
I guess I assume that people who use raid0 directly on normal drives
don't really value their data, so if a device starts failing, they
will just give up the data as lost (i.e. use the raid0 as a cache for
something).

Maybe I need to come up with a way to atomically swap a device in any
array....  maybe.

I actually would really like to provide this hot-replace functionality
without explicitly implementing it for each level.

The first part of that is to implement support for maintaining a
bad-block-list.  This is a per-device list that identifies sectors
that should fail when read.

Then if you resync a raid1 and you get a read failure, you don't have
to reject the whole drive, you just record the bad block (on both
drives) and move on.

Then we can use "swap the drive for a raid1" to mostly implement
hot-replace.
Once the recovery finishes, mdadm can check out the bad block list,
and trigger a resync in the top-level array for just those sectors.
That will cause the bad block to be over-written by good data from the
top-level.   This removes the bad block from the list.
Once the list is empty (for the new drive), we swap out the raid1 and
put the new drive back in and all is happy.

To be able use this as a real solution, I think we want that
atomic-swap function.  Using the bitmap trick is OK, but not ideal
(and as you say, doesn't work on raid0).

My other unresolved issue about this approach is correct handling of
the metadata.  If we crash in the middle of a hot-recovery I want to
be sure that the new drive isn't mistakenly assumed to be fully
recovered.  When the metadata is at the end, that should "just work".
But when it is at the start it becomes more awkward.  This is probably
solvable, but I haven't solved it yet.

NeilBrown

