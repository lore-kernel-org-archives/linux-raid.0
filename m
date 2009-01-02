From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RFC: detection of silent corruption via ATA long sector reads
Date: Fri, 02 Jan 2009 17:04:56 -0500
Message-ID: <yq13ag174af.fsf@sermon.lab.mkp.net>
References: <fa.8mwKV7y4hm+Q6mvIKtp9QGoJYUU@ifi.uio.no>
	<fa.4QcsYZC0gJJwJ0eUOht3hDYaVWs@ifi.uio.no>
	<49580061.9060506@yahoo.com>
	<87f94c370901021226j40176872h9e5723c6da4afcbe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370901021226j40176872h9e5723c6da4afcbe@mail.gmail.com> (Greg Freemyer's message of "Fri\, 2 Jan 2009 15\:26\:38 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Mark Lord <liml@rtr.ca>, Redeeman <redeeman@metanurb.dk>, piergiorgio.sartor@nexgo.de, neilb@suse.de, linux-raid@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Greg" == Greg Freemyer <greg.freemyer@gmail.com> writes:

Greg> I also see Device Mapper support was discussed in Oct.  (My 2.6.27
Greg> kernel does not have those patches).

See below.


Greg> Is there a more comprehensive write-up / resource that describes
Greg> the current status of the overall INTEGRITY support is, 

http://oss.oracle.com/projects/data-integrity/documentation/

The status is:

 - The infrastructure in the kernel is in place as of .27.  Hoping to
   get MD/DM support in .29 but I'm running late wrt. the merge window.

 - We recently announced an early adopter program for Oracle DB
   customers.  The ASM component of the database now supports the
   integrity hooks so we can true end-to-end integrity protection of DB
   I/O.

 - btrfs support is work in progress.

 - Other people have expressed interest in adding support to ext4 and
   XFS.


Greg> especially as it relates to ATA devices?

ATA support was put on hold in the T13 committee because the drive
vendors don't feel like adding a big, intrusive feature to their
firmware.  I'm still hoping we can eventually get support added to
nearline class drives but it'll be a while.  Market demand needs to be
there first.  I.e. the array vendors that use SATA drives will need to
start asking for it.

We're just, just, just starting to push out FC support.  Then comes SAS.
And then hopefully ATA.


Greg> ie.  Do actual ATA hardware devices that support "T13/ATA External
Greg> Path Protection" exist yet?  Does it require HDD and controller
Greg> support?  Or just HDD?

Both.  You could emulate some of the DIX features in software (like
scatterlist interleaving) and then plug in the long commands on the back
end.  But as Mark said the checksum formats differ between drive
vendors/models.

On SCSI you could conceivably use the block integrity stuff to store an
LVM/MD checksum when used with devices that expose the application tag.

However, it's only a 16-bit field (16 bits - 1 to be exact) so it's not
exactly a lot of space.  And only dumb drives are going to make it
available.  Some RAID controllers are going to keep those 16-bits for
their own internal use.

The main purpose of the block integrity stuff is to protect in-flight
I/O.  Persistence is an optional feature and a side-effect.

So I think it would be much more worthwhile to implement checksumming in
MD/DM without relying on special hardware.  I did some experiments in
that department a few years ago when we were investigating how to go
about fixing some of the data integrity problems in Linux.

I wrote something akin to DIF in software by doing 64 512-byte blocks +
512 bytes of checksums.  The disadvantage there is having to do
read-modify-write for small writes.  I tried several other approaches
sacrificing both space and locality but performance was still anemic.

The reason DIF is implemented the way it is (with 520 byte sectors: 512
bytes followed by 8 bytes of checksum) is to prevent the cost of seeking
to write the protection information elsewhere.  With solid state devices
that seek penalty doesn't exist so this may become less of an issue
going forward.

The beauty of checksumming in btrfs is that the checksum is stored in
the filesystem metadata which is read/written anyway.  So the only
overhead is in calculating the actual checksum.  That's something
virtual block devices have a much harder time providing because they
don't have metadata describing individual blocks.

That doesn't mean it can't be done but it's a lot more work.  I'm
personally much more interested in adding support for adding a
retry-other-mirror interface to MD/DM and leave the checksumming to the
filesystems.

-- 
Martin K. Petersen	Oracle Linux Engineering

