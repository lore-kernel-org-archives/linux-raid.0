From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: sb->resync_offset value after resync failure
Date: Thu, 19 Jan 2012 18:19:55 +0200
Message-ID: <CAGRgLy44uKSggEsrU4Fx7op7iVjoPPq-doMdYjxnSGDm6krf9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Greetings,
I am looking into a scenario, in which the md raid5/6 array is
resyncing (e.g., after a fresh creation) and there is a drive failure.
As written in Neil's blog entry "Closing the RAID5 write hole"
(http://neil.brown.name/blog/20110614101708): "if a device fails
during the resync, md doesn't take special action - it just allows the
array to be used without a resync even though there could be corrupt
data".

However, I noticed that at this point sb->resync_offset in the
superblock is not set to MaxSector. At this point if a drive is
added/re-added to the array, then drive recovery starts, i.e., md
assumes that data/parity on the surviving drives are correct, and uses
them to rebuild the new drive. This state of data/parity being correct
should be reflected as sb->resync_offset=3D=3DMaxSector, shouldn't it?

One issue that I ran into is the following: I reached a situation in
which during array assembly: sb->resync_offset=3D=3Dsb->size. At this
point, the following code in mdadm
assumes that array is clean:
info->array.state =3D
    (__le64_to_cpu(sb->resync_offset) >=3D __le64_to_cpu(sb->size))
 =A0=A0=A0 ? 1 : 0;
As a result, mdadm lets the array assembly flow through fine to the
kernel, but in the kernel the following code refuses to start the
array:
=A0=A0=A0 if (mddev->degraded > dirty_parity_disks &&
=A0=A0=A0 =A0=A0=A0 mddev->recovery_cp !=3D MaxSector) {

At this point, speciying --force to mdadm --assembly doesn't help,
because mdadm thinks that array is clean (clean=3D=3D1), and therefore
doesn't do the "force-array" update, which would knock off the
sb->resync_offset value. So there is no way to start the array, unless
specifying the start_dirty_degraded=3D1 kernel parameter.

So one question is: should mdadm compare sb->resync_offset to
MaxSector and not to sb->size? In the kernel code, resync_offset is
always compared to MaxSector.

Another question is: whether sb->resync_offset should be set to
MaxSector by the kernel as soon as it starts rebuilding a drive? I
think this would be consistent with what Neil wrote in the blog entry.

Here is the scenario to reproduce the issue I described:
# Create a raid6 array with 4 drives A,B,C,D. Array starts resyncing.
# Fail drive D. Array aborts the resync and then immediately restarts
it (it seems to checkpoint the mddev->recovery_cp, but I am not sure
that it restarts from that checkpoint)
# Re-add drive D to the array. It is added as a spare, array continues =
resyncing
# Fail drive C. Array aborts the resync, and then starts rebuilding
drive D. At this point sb->resync_offset is some valid value (usually
0, not MaxSectors and not sb->size).
# Stop the array. At this point sb->resync offset is sb->size in all
the superblocks.

Another question I have: when exactly md decides to update the
sb->resync_offset in the superblock? I am playing with similar
scenarios with raid5, and sometimes I end up with MaxSectors and
sometimes with valid values. From the code, it looks like only this
logic updates it:
	if (mddev->in_sync)
		sb->resync_offset =3D cpu_to_le64(mddev->recovery_cp);
	else
		sb->resync_offset =3D cpu_to_le64(0);
except for resizing and setting through sysfs. But I don't understand
how this value should be managed in general.

Thanks!
Alex.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
