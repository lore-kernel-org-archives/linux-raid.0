From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: md lock issue, I suppose
Date: Mon, 21 Jun 2010 23:25:21 +0200
Message-ID: <20100621212521.GA31833@lazy.lzy>
References: <20100621204208.GA29830@lazy.lzy>
 <4C1FD4CF.20109@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C1FD4CF.20109@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: st0ff@npl.de
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

thanks for the answer.

Actually, the locking just prevent to re-read the
partition table, not to write it.
After "detaching" the disk, the partition table
can be re-read and it shows all the partitions.
So, the locking is only half protection, in that
respect, I guess (the next restart...).

About the solution, thanks, I was implementing
something similar.

Unfortunately, there are use cases, at least one,
where the partitions must, or should, be created
on a spare space of some drive, already belonging
to an array, thus the need to create a partition
on a disk belonging to a running array.

=46or example: 5 disks: 40 40 160 160 160 (all
could be GiB or whatever).
The 160 have a 40 partition, so there is a sigle
RAID-6 composed by the 2 40 and 3 partitions,
from the 160, of 40.
The rest of the 160, namely 120, is free space.

Now, a new HDD is added, of 120...

At this point the 160 should have added a partition
of 80, leaving another 40 free.
Unfortunately, they belong to the first RAID, so the
partitioning and successive RAID creation does not
seem to be posssible. On a live system.

Any other suggestions or ideas?

Thanks,

bye,

pg

On Mon, Jun 21, 2010 at 11:08:31PM +0200, Stefan /*St0fF*/ H=FCbner wro=
te:
> I don't think it's too aggressive locking.  If the disk wasn't locked=
,
> you could also shrink or expand the raid partition.  That wouldn't be=
 a
> good idea (f.e. with 0.90 metadata shrinking or expanding would be
> really bad!).  This could happen with one write to the partition tabl=
e,
> so writing to it should be locked.
>=20
> The workaround is first grade programming: divide and conquer!  Make =
two
> for-loops.  One collecting the information, the second to apply all
> changes (first change the pt, then loop thru adding the partitions to
> the different arrays).
>=20
> Yes, as easy as that.
>=20
> Am 21.06.2010 22:42, schrieb Piergiorgio Sartor:
> > Hi all,
> >=20
> > still playing with my wild bunch of RAID-6.
> >=20
> > I'm more or less finished with a script adding
> > an HDD to the different arrays.
> >=20
> > The script, originally, was going thru the different
> > arrays, collecting the partition size, creating the
> > partition (on the new disk), adding the partition
> > to the corresponding RAID volume.
> >=20
> > Something like:
> >=20
> > for v in raid_devices
> >   find start end part
> >   parted /dev/sdX mkpart part start end
> >   mdadm --add $v /dev/sdXpart
> > end
> >=20
> > This works only for the first partition.
> >=20
> > The issue seems to be that, after the "--add", the
> > device is locked and the partition table *cannot*
> > be updated (the kernel cannot).
> > The consequence is that the successive "parted",
> > while succeeding, report a failure (not a problem),
> > and the /dev/sdXpart does not appear. This means
> > it will not be added to the next device.
> >=20
> > In other words, the script starts with /dev/sdX.
> > It creates /dev/sdX1.
> > It adds /dev/sdX1 to the RAID.
> > It creates /dev/sdX2...
> > /dev/sdX2 does not appear, the add fails...
> > ...
> >=20
> > Is this intended behaviour? Or a bit aggressive locking?
> >=20
> > Any possible solution not involving stopping the RAIDs?
> >=20
> > Thanks a lot, if you need more info, please let me know.
> >=20
> > bye,
> >=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20

piergiorgio
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
