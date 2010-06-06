From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID Configuration For New Home Server
Date: Sun, 6 Jun 2010 15:47:30 -0500
Message-ID: <79.AC.26996.8690C0C4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTinh1WtkzAgS8cOC1idj-7tcS4OMv9s3qRGwdhrf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinh1WtkzAgS8cOC1idj-7tcS4OMv9s3qRGwdhrf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Knecht' <markknecht@gmail.com>
Cc: 'Mdadm' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > =A0 =A0 =A0 =A0Oh, I almost forgot. =A0It may be of notable mention=
 an array with
> a
> > 1.0 superblock can be read as if it were an ordinary partition. =A0=
This
> means
> > one can build a 1.0 superblock array containing a file system (ext2=
 may
> be
> > the best choice in this case), but boot from the partition just as =
if it
> > were not an array. =A0Once the system is booted, the array can be
> assembled
> > and then /boot can be mounted. =A0This is because:
> >
> > 1. =A0The 1.0 superblock is at the *END* of the array.
> >
> > 2. =A0The file system when created only uses up the front part of t=
he
> > partition, leaving the superblock intact.
> >
> > 3. =A0GRUB does not require the file system to be mounted in order =
to read
> the
> > kernel and the initrd. =A0(Actually, it could be made to work even =
if it
> did
> > mount the partition, but since it does not, it makes it much easier=
=2E)
> >
> > =A0 =A0 =A0 =A0Indeed, this is the only way of which I know to boot=
 to an array
> > using GRUB legacy.
> >
> >
>=20
> Actually that is of interest. If there's a way to use a single RAID
> boot partition by itself once in awhile then there's value there if
> something has gone wrong and you're just trying to get the machine up
> and running.

	Well, of course a basic RAID1 array can be assembled with only one
member present, but yes, a RAID1 member partition with a 1.0 superblock=
 can
be safely read (but not written!) as if it were an ordinary partition. =
 If
one has an unassembled RAID1 array comprised of 3 partitions, say /dev/=
sda1,
/dev/sdb1, and /dev/sdc1, one can simply mount /dev/sdb1 like any other
formatted partition.  Neither the OS nor the file system will be aware =
the
mount point is anything but a partially filled partition.  Of course, o=
ne
does not ordinarily wish to write to the partition which is so mounted
(mounting as read-only is a good idea), since doing so will de-sync the
array, and chances are the data would be lost when the array is
re-assembled, anyway.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
