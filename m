From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SSD data reliable vs. unreliable [Was: Re: Data Recovery from
	SSDs - Impact of trim?]
Date: Mon, 26 Jan 2009 17:47:45 +0000
Message-ID: <1232992065.3248.38.camel@localhost.localdomain>
References: <87f94c370901221553p4d3a749fl4717deabba5419ec@mail.gmail.com>
	 <497A2B3C.3060603@redhat.com>
	 <1232749447.3250.146.camel@localhost.localdomain>
	 <87f94c370901231526jb41ea66ta1d6a23d7631d63c@mail.gmail.com>
	 <497A542C.1040900@redhat.com>
	 <7fce22690901260659u30ffd634m3fb7f75102141ee9@mail.gmail.com>
	 <497DE35C.6090308@redhat.com>
	 <87f94c370901260934vef69a2cgada9ae3dfdb440ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370901260934vef69a2cgada9ae3dfdb440ef@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@norcrossgroup.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, Dongjun Shin <djshin90@gmail.com>, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 2009-01-26 at 12:34 -0500, Greg Freemyer wrote:
> Adding mdraid list:
> 
> Top post as a recap for mdraid list (redundantly at end of email if
> anyone wants to respond to any of this).:
> 
> == Start RECAP
> With proposed spec changes for both T10 and T13 a new "unmap" or
> "trim" command is proposed respectively.  The linux kernel is
> implementing this as a sector discard and will be called by various
> file systems as they delete data files.  Ext4 will be one of the first
> to support this. (At least via out of kernel patches.)
> 
> SCSI - see http://www.t10.org/cgi-bin/ac.pl?t=d&f=08-356r5.pdf
> ATA - see T13/e08137r2 draft
> 
> Per the proposed spec changes, the underlying SSD device can
> optionally modify the unmapped data.  SCSI T10 at least restricts the
> way the modification happens, but data modification of unmapped data
> is still definitely allowed for both classes of SSD.
> 
> Thus if a filesystem "discards" a sector, the contents of the sector
> can change and thus parity values are no longer meaningful for the
> stripe.

This isn't correct.  The implementation is via bio and request discard
flags.  linux raid as a bio->bio mapping entity can choose to drop or
implement the discard flag (by default it will be dropped unless the
raid layer is modified).

> ie. If the unmap-ed blocks don't exactly correlate with the Raid-5 / 6
> stripping, then the integrity of a stripe containing both mapped and
> unmapped data is lost.
> 
> Thus it seems that either the filesystem will have to understand the
> raid 5 / 6 stripping / chunking setup and ensure it never issues a
> discard command unless an entire stripe is being discarded.  Or that
> the raid implementation must must snoop the discard commands and take
> appropriate actions.

No.  It only works if the discard is supported all the way through the
stack to the controller and device ... any point in the stack can drop
the discard.  It's also theoretically possible that any layer could
accumulate them as well (i.e. up to stripe size for raid).

James


