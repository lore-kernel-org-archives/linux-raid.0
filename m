From: "Greg Freemyer" <greg.freemyer@gmail.com>
Subject: Re: RFC: detection of silent corruption via ATA long sector reads
Date: Fri, 2 Jan 2009 17:41:50 -0500
Message-ID: <87f94c370901021441t5ba1b758qa34b474755835257@mail.gmail.com>
References: <fa.8mwKV7y4hm+Q6mvIKtp9QGoJYUU@ifi.uio.no>
	 <fa.4QcsYZC0gJJwJ0eUOht3hDYaVWs@ifi.uio.no>
	 <49580061.9060506@yahoo.com>
	 <87f94c370901021226j40176872h9e5723c6da4afcbe@mail.gmail.com>
	 <yq13ag174af.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <yq13ag174af.fsf@sermon.lab.mkp.net>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Mark Lord <liml@rtr.ca>, Redeeman <redeeman@metanurb.dk>, piergiorgio.sartor@nexgo.de, neilb@suse.de, linux-raid@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Thanks Martin, comments interspersed

On Fri, Jan 2, 2009 at 5:04 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Greg" == Greg Freemyer <greg.freemyer@gmail.com> writes:
>
<snip>

> The status is:
>
>  - The infrastructure in the kernel is in place as of .27.  Hoping to
>   get MD/DM support in .29 but I'm running late wrt. the merge window.

I haven't seen any MD patches at all.  Will the MD support verify the
CRC on read and trigger a RAID re-read other mirror on failure?

>  - We recently announced an early adopter program for Oracle DB
>   customers.  The ASM component of the database now supports the
>   integrity hooks so we can true end-to-end integrity protection of DB
>   I/O.

Very cool.

>  - btrfs support is work in progress.
>
>  - Other people have expressed interest in adding support to ext4 and
>   XFS.

Nice, but it seems the block layer will capture that vast majority of issues.

> Greg> especially as it relates to ATA devices?
>
> ATA support was put on hold in the T13 committee because the drive
> vendors don't feel like adding a big, intrusive feature to their
> firmware.  I'm still hoping we can eventually get support added to
> nearline class drives but it'll be a while.  Market demand needs to be
> there first.  I.e. the array vendors that use SATA drives will need to
> start asking for it.
>
> We're just, just, just starting to push out FC support.  Then comes SAS.
> And then hopefully ATA.

The LHC (Large Hadron Collider) people put out a white paper on silent
corruption a year or two ago.   They were very concerned that it could
negatively impact there results.  I don't remember the details, or how
they worked around it.

If they are not already part of your integrity team, you might want to
reach out to them.  And I think they bought / are buying huge amounts
of hardware.

>
> Greg> ie.  Do actual ATA hardware devices that support "T13/ATA External
> Greg> Path Protection" exist yet?  Does it require HDD and controller
> Greg> support?  Or just HDD?
>
> Both.  You could emulate some of the DIX features in software (like
> scatterlist interleaving) and then plug in the long commands on the back
> end.  But as Mark said the checksum formats differ between drive
> vendors/models.

The linux kernel obviously supports a large amount of vendor specific code.

Maybe the INTEGRITY crc could be calculated on the fly by libata for
at least a few hard drive vendors that have known CRC algorithms used
with the current long sector reads.

ie. When INTEGRITY is enabled and supported hard drives are being read
from, libata requests the long sector with proprietary  CRC and
verifies the vendor specific CRC.  If it looks good, then the vendor
specific CRC is replaced by the SCSI Spec CRC and the sector / bios
are passed up the line just like a supported SCSI device would do.

If those drives started selling well, maybe the drive manufactures
could be persuaded to implement the full end-to-end protocol.

> On SCSI you could conceivably use the block integrity stuff to store an
> LVM/MD checksum when used with devices that expose the application tag.
>
> However, it's only a 16-bit field (16 bits - 1 to be exact) so it's not
> exactly a lot of space.  And only dumb drives are going to make it
> available.  Some RAID controllers are going to keep those 16-bits for
> their own internal use.
>
> The main purpose of the block integrity stuff is to protect in-flight
> I/O.  Persistence is an optional feature and a side-effect.

In-flight is my concern as well.  All of the silent corruption I've
seen and taken the time to troubleshoot was caused by in-flight
errors.  I've seen it be cables, power supply, controller, ram, and
CPU cache at a minimum.

> So I think it would be much more worthwhile to implement checksumming in
> MD/DM without relying on special hardware.  I did some experiments in
> that department a few years ago when we were investigating how to go
> about fixing some of the data integrity problems in Linux.
>
> I wrote something akin to DIF in software by doing 64 512-byte blocks +
> 512 bytes of checksums.  The disadvantage there is having to do
> read-modify-write for small writes.  I tried several other approaches
> sacrificing both space and locality but performance was still anemic.
>
> The reason DIF is implemented the way it is (with 520 byte sectors: 512
> bytes followed by 8 bytes of checksum) is to prevent the cost of seeking
> to write the protection information elsewhere.  With solid state devices
> that seek penalty doesn't exist so this may become less of an issue
> going forward.
>
> The beauty of checksumming in btrfs is that the checksum is stored in
> the filesystem metadata which is read/written anyway.  So the only
> overhead is in calculating the actual checksum.  That's something
> virtual block devices have a much harder time providing because they
> don't have metadata describing individual blocks.
>
> That doesn't mean it can't be done but it's a lot more work.  I'm
> personally much more interested in adding support for adding a
> retry-other-mirror interface to MD/DM and leave the checksumming to the
> filesystems.

That makes sense as well, but given the most filesystems won't have
inherent INTEGRITY support, then the block layer should also be able
to make retry-other-mirror requests of MD / DM.

> --
> Martin K. Petersen      Oracle Linux Engineering
>

Also is there any effort to add diagnostic messages at the various tiers.

You describe this as end-to-end protection, but when it fails, it
would be extremely useful to check dmesg or something and be able to
see that a sector came in from the controller fine, but was corrupted
later, so CPU / memory is suspected vs. sector came in bad from the
controller, so suspect a problem in the controller / cable / power
supply area.

Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
