From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RFC: detection of silent corruption via ATA long sector reads
Date: Fri, 02 Jan 2009 22:01:16 -0500
Message-ID: <yq1ljtt5c03.fsf@sermon.lab.mkp.net>
References: <fa.8mwKV7y4hm+Q6mvIKtp9QGoJYUU@ifi.uio.no>
	<fa.4QcsYZC0gJJwJ0eUOht3hDYaVWs@ifi.uio.no>
	<49580061.9060506@yahoo.com>
	<87f94c370901021226j40176872h9e5723c6da4afcbe@mail.gmail.com>
	<yq13ag174af.fsf@sermon.lab.mkp.net>
	<87f94c370901021441t5ba1b758qa34b474755835257@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <87f94c370901021441t5ba1b758qa34b474755835257@mail.gmail.com> (Greg Freemyer's message of "Fri\, 2 Jan 2009 17\:41\:50 -0500")
Sender: linux-ide-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Sitsofe Wheeler <sitsofe@yahoo.com>, Mark Lord <liml@rtr.ca>, Redeeman <redeeman@metanurb.dk>, piergiorgio.sartor@nexgo.de, neilb@suse.de, linux-raid@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Greg" == Greg Freemyer <greg.freemyer@gmail.com> writes:

Greg> I haven't seen any MD patches at all.  Will the MD support verify
Greg> the CRC on read and trigger a RAID re-read other mirror on
Greg> failure?

No.  With the data integrity model it is the owner of the integrity
metadata that needs to re-drive the I/O in case of failure.  So that
means the application, filesystem or the block layer depending on who
added it.

The reason for this is twofold:

 1) The owner of the I/O in question has much better knowledge about the
    context.  On a write it can re-run verification checks on its
    buffers before deciding whether to try again, notify the user, etc.

 2) Limiting the number of times we calculate the CRC/checksum.  If
    every layer in the I/O stack did a check things would get painfully
    slow.  So it's better to bubble everything to the top and do it
    once.

That's why it's important to me to ensure that the appropriate signaling
is in place so that upper layers can influence what's going on below.
I.e. telling MD/DM to retry redundant copies.

That said, adding a belt-and-suspenders option to MD/DM to verify all
I/O would be trivial.  But I don't think it's worth it.


Greg> The LHC (Large Hadron Collider) people put out a white paper on
Greg> silent corruption a year or two ago.  They were very concerned
Greg> that it could negatively impact there results.

I've been talking to them on and off.


>> Both.  You could emulate some of the DIX features in software (like
>> scatterlist interleaving) and then plug in the long commands on the
>> back end.  But as Mark said the checksum formats differ between drive
>> vendors/models.

Greg> The linux kernel obviously supports a large amount of vendor
Greg> specific code.

However, the actual ECC stored by disk drives is proprietary.  The drive
vendors have spent years and years refining their algorithms.  I think
it's highly unlikely that they'd be willing to tell us what's in there
and how it's calculated.

I really think you should all just go bug your drive vendors about this
feature.  The ATA add-on (called External Path Protection) was pretty
much fully baked when it was shelved.  It is compatible with the SCSI
ditto so interoperability is a no-brainer.  But the drive vendors fought
it vehemently.

Interestingly enough, SSD vendors seem much more interested in adding
competitive features.


Greg> Maybe the INTEGRITY crc could be calculated on the fly by libata
Greg> for at least a few hard drive vendors that have known CRC
Greg> algorithms used with the current long sector reads.

It's usually an ECC and not a CRC, btw.  And it's relatively big.  It's
not unusual to be able to correct on the order of 50 bytes out of 512.


Greg> ie. When INTEGRITY is enabled and supported hard drives are being
Greg> read from, libata requests the long sector with proprietary CRC
Greg> and verifies the vendor specific CRC.  If it looks good, then the
Greg> vendor specific CRC is replaced by the SCSI Spec CRC and the
Greg> sector / bios are passed up the line just like a supported SCSI
Greg> device would do.

Not necessary.

The integrity infrastructure is completely agnostic to the data
contained in the protection buffer.  It's all done by callbacks
registered with the block device.  And consequently filesystems and
applications operate at the "protect this buffer"/"verify this buffer"
level.  They don't have to know or care about T10, CRCs, ATA or
anything.

The actual format is negotiated in case of MD/DM that spans devices with
potentially different capabilities/checksum formats.  With SCSI we have
the luxury that the CRC is mandatory so we can always fall back to that.


Greg> In-flight is my concern as well.  All of the silent corruption
Greg> I've seen and taken the time to troubleshoot was caused by
Greg> in-flight errors.  I've seen it be cables, power supply,
Greg> controller, ram, and CPU cache at a minimum.

Yup.


Greg> That makes sense as well, but given the most filesystems won't
Greg> have inherent INTEGRITY support, then the block layer should also
Greg> be able to make retry-other-mirror requests of MD / DM.

Well, this is somewhat orthogonal.  A drive is not going to return good
sense information if the CRC didn't match the data.  So the I/O is going
to fail and DM/MD can retry at will.  In that case it doesn't really
matter what caused the failure and DM/MD will retry regardless.

You could argue that the data could still be corrupted on the way back
from the drive.  But I haven't seen that happen much.  In any case, the
verification further up the stack is going to catch the mismatch.

Most of the errors I see on READ are due to DMAs that for whatever
reason didn't actually happen.

That's actually a fun thing to do: Poison all pages in the target
scatterlist before issuing a READ.  I've had to do that several times to
prove that transfers went missing in action.


Greg> Also is there any effort to add diagnostic messages at the various
Greg> tiers.

Greg> You describe this as end-to-end protection, but when it fails, it
Greg> would be extremely useful to check dmesg or something and be able
Greg> to see that a sector came in from the controller fine, but was
Greg> corrupted later, so CPU / memory is suspected vs. sector came in
Greg> bad from the controller, so suspect a problem in the controller /
Greg> cable / power supply area.

Right now we distinguish between errors caught by the HBA and errors
caught by the target device.

A big problem we're trying to tackle is the case where a write is
acknowledged by the RAID controller and stored in non-volatile memory
there.  Once the RAID controller commits the write to an actual disk the
write fails and for some reason the RAID controller doesn't succeed in
writing the block elsewhere.  In that case the original I/O has been
completed at the OS level.  There's really no means for the array head
to come back and say "Oh, btw. that I/O that I acked a while ago didn't
actually make it".  And even if it did we would have forgotten all about
the context of that I/O so it wouldn't be of much help.

So out of band error reporting like that (that also involves SAN
switches) is a topic for discussion within the SNIA Data Integrity TWG.

-- 
Martin K. Petersen	Oracle Linux Engineering
