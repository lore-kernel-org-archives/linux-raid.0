From: Neil Brown <neilb@suse.de>
Subject: Re: SSD data reliable vs. unreliable [Was: Re: Data Recovery from
	SSDs - Impact of trim?]
Date: Tue, 27 Jan 2009 16:16:18 +1100
Message-ID: <18814.39074.194781.490676@notabene.brown>
References: <87f94c370901221553p4d3a749fl4717deabba5419ec@mail.gmail.com>
	<497A2B3C.3060603@redhat.com>
	<1232749447.3250.146.camel@localhost.localdomain>
	<87f94c370901231526jb41ea66ta1d6a23d7631d63c@mail.gmail.com>
	<497A542C.1040900@redhat.com>
	<7fce22690901260659u30ffd634m3fb7f75102141ee9@mail.gmail.com>
	<497DE35C.6090308@redhat.com>
	<87f94c370901260934vef69a2cgada9ae3dfdb440ef@mail.gmail.com>
	<1232992065.3248.38.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: message from James Bottomley on Monday January 26
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg Freemyer <greg.freemyer@norcrossgroup.com>, Ric Wheeler <rwheeler@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, Dongjun Shin <djshin90@gmail.com>, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

On Monday January 26, James.Bottomley@HansenPartnership.com wrote:
> On Mon, 2009-01-26 at 12:34 -0500, Greg Freemyer wrote:
> > Adding mdraid list:
> > 
> > Top post as a recap for mdraid list (redundantly at end of email if
> > anyone wants to respond to any of this).:
> > 
> > == Start RECAP
> > With proposed spec changes for both T10 and T13 a new "unmap" or
> > "trim" command is proposed respectively.  The linux kernel is
> > implementing this as a sector discard and will be called by various
> > file systems as they delete data files.  Ext4 will be one of the first
> > to support this. (At least via out of kernel patches.)
> > 
> > SCSI - see http://www.t10.org/cgi-bin/ac.pl?t=d&f=08-356r5.pdf
> > ATA - see T13/e08137r2 draft
> > 
> > Per the proposed spec changes, the underlying SSD device can
> > optionally modify the unmapped data.  SCSI T10 at least restricts the
> > way the modification happens, but data modification of unmapped data
> > is still definitely allowed for both classes of SSD.
> > 
> > Thus if a filesystem "discards" a sector, the contents of the sector
> > can change and thus parity values are no longer meaningful for the
> > stripe.
> 
> This isn't correct.  The implementation is via bio and request discard
> flags.  linux raid as a bio->bio mapping entity can choose to drop or
> implement the discard flag (by default it will be dropped unless the
> raid layer is modified).

That's good.  I would be worried if they could slip through without
md/raid noticing.

> 
> > ie. If the unmap-ed blocks don't exactly correlate with the Raid-5 / 6
> > stripping, then the integrity of a stripe containing both mapped and
> > unmapped data is lost.
> > 
> > Thus it seems that either the filesystem will have to understand the
> > raid 5 / 6 stripping / chunking setup and ensure it never issues a
> > discard command unless an entire stripe is being discarded.  Or that
> > the raid implementation must must snoop the discard commands and take
> > appropriate actions.
> 
> No.  It only works if the discard is supported all the way through the
> stack to the controller and device ... any point in the stack can drop
> the discard.  It's also theoretically possible that any layer could
> accumulate them as well (i.e. up to stripe size for raid).

Accumulating them in the raid level would probably be awkward.

It was my understanding that filesystems would (try to) send the
largest possible 'discard' covering any surrounding blocks that had
already been discarded.  Then e.g. raid5 could just round down any
discard request to an aligned number of complete stripes and just
discard those.  i.e. have all the accumulation done in the filesystem.

To be able to safely discard stripes, raid5 would need to remember
which stripes were discarded so that it could be sure to write out the
whole stripe when updating any block on it, thus ensuring that parity
will be correct again and will remain correct.

Probably the only practical data structure for this would be a bitmap
similar to the current write-intent bitmap.

Is it really worth supporting this in raid5?   Are the sorts of
devices that will benefit from 'discard' requests likely to be used
inside an md/raid5 array I wonder....

raid1 and raid10 are much easier to handle, so supporting 'discard'
there certainly makes sense.

NeilBrown
