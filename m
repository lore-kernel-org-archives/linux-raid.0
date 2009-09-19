From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Random bit flips - better data integrity needed [Was: Re:
	mismatch_count != 0 on multiple hosts]
Date: Sat, 19 Sep 2009 12:10:34 -0400
Message-ID: <87f94c370909190910s6992a671re507ddcf91ea623e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@tu-ilmenau.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Sep 19, 2009 at 11:10 AM, Mario 'BitKoenig' Holbe
<Mario.Holbe@tu-ilmenau.de> wrote:
> Bryan Mesich <bryan.mesich@ndsu.edu> wrote:
>> On Wed, Sep 16, 2009 at 09:20:35PM +0200, Mario 'BitKoenig' Holbe wr=
ote:
>>> They should not appear on RAID5.
>> I would agree. =A0The only reason I mentioned RAID5 was to remove th=
e
>> possibility that the HD were spontaneously flipping bits. =A0Our SAN
>
> This should not happen on recent disks (and even not that recent ones=
)
> either. Disks do error correction and don't deliver faulty data, they
> deliver read errors instead. Maybe there are some disks where you can
> disable ECC (I'm not aware of such), but I doubt you would get even o=
ne
> reasonable bit out of them then :)
>
> And *if* spontaneously flipping bits *would* happen on single disks,
> they would also happen on your RAID5. No RAID level except RAID2 (whi=
ch
> does ECC on its own) tolerates this kind of error, they all rely on
> disks delivering either correct data or error messages.
>

There is a whole series of places a bit flip can occur after the data
is read from the platter and the ECC verified that don't generate
error messages.

Could be in the IDE electronics themselves on the drive.  In the IDE
or SATA cable.  (I think sata has a checksum on the transmission.  IDE
cables don't.)  In the controller.  In ram. In the cache.  In the CPU,
etc., etc. etc.

If you want reliable data you have to build in end-to-end
verification.  As long as you attack the issues piece by little piece,
you are going to have weaknesses where a bit flip can sneak in.  That
is one reason we see  MD5s distributed with lots of downloadable ISOs,
etc.  In theory the whole distribution process is reliable, but by
verifying it at the very end you gain a significant amount of
confidence.

With regards to data storage, one major step in this direction is the
"integrity" patch that went into the kernel last winter (2.6.28?).
There is apparently now a scsi standard that allows a checksum / crc
to be passed along with the data.  The protocol for calculating the
value is published, so at the top of the linux block stack, with this
feature enabled a chucksum / crc is calculated as soon as a filesystem
puts a block of data into the block queues.  The checksum / crc
travels with the data all the way to the scsi subsystem.  The
subsystem in turn verifies the value and errors out on a data write if
the data and checksum / crc are in disagreement.  On read, the
subsystem also provides the checksum / crc in addition to the data.
This data traverses the linux block stack all the way to the
filesystem and is verified immediately prior to being handed off to
the filesystem.

This is all pretty new obviously.  To the best of my knowledge
filesystems have not yet been enhanced to track this value, thus
covering even more of the end-to-end transaction.

I don't know how specifically, but it also seems to me the mdraid
stack could add to currently poor data integrity process even in the
absence of a supporting scsi subsystem.  Maybe by pulling out the
integrity checksum / crc info and putting it on yet another disk, or
mixing it in with the parity calculation.

Specifically you could steal the second parity stripe from a raid 6
setup and replace it with this end-to-end data integrity checksum /
crc.  The checksum / crc is much smaller than the original data so the
one integrity disk should support a reasonable number of data disks.
Obviously this would not be one of the formal raid levels, but that
doesn't mean its not useful.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
