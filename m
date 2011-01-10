From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Considering a complete rework of RAID on my home compute server
Date: Sun, 9 Jan 2011 18:10:31 -0600
Message-ID: <68.C0.13137.77E4A2D4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTikxViM45MfjZvMCDAobeVVwBqMZHrm_Ws-bsAQt@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikxViM45MfjZvMCDAobeVVwBqMZHrm_Ws-bsAQt@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Knecht' <markknecht@gmail.com>
Cc: 'Linux-RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> On Wed, Jan 5, 2011 at 4:03 PM, Leslie Rhorer <lrhorer@satx.rr.com> w=
rote:
> >> 1) The Linux/MySQL stuff is a 3 drive RAID1. (sda/sdb/sdc)
> >
> > =A0 =A0 =A0 =A0Well, RAID1 certainly offers the most robust solutio=
n, especially
> > with more than 1 mirror.
> >
> <SNIP>
> >
> >> 3) There is a second RAID1 (sda/sdb/sdc) used for backups of the
> >> RAID0. The RAID0 is backed up to RAID1 nightly. If the RAID0 fails
> >> then I lose 1 day's work.
> >
> > =A0 =A0 =A0 =A0Well, first of all, unless you meant to say sda1/sdb=
1/sdc1, etc,
> > then this can't be different from the #1 RAID array above. =A0Assum=
ing you
> are
> > actually using partitions, then I don't really see the value of two
> separate
> > arrays. =A0Why not just one RAID1 array?
> >
>=20
> Sorry I wasn't very clear.
>=20
> In #1 the RAID1 is my main Linux system on sda3/sdb3/sdc3.
> In #3 the RAID1 is purely for backups on /swa6/sdb6/sdc6 and is used
> only for the backup of the RAID0 data. It is not normally mounted
> except when doing backups. I wanted the extra protection that if
> something went wrong with the basic Linux box the backup partition
> would not normally be mounted and the data hopefully a bit safer.
>=20
>=20
> > =A0 =A0 =A0 =A0Also, I personally would reverse the backup strategy=
=2E =A0I would
> put
> > the Windows VM on the (single) main RAID array and back up the data=
 to a
> > single 1T hard drive.
> >
>=20
> I do this today backing up the existing RAID1 partitions to an
> external eSATA 1TB drive.

	What I meant was, you currently have a 2 disk RAID0.  Why not buy a
larger disk and move the 2 drives currently tied up in the RAID0 to a 5=
 disk
RAID6 array with no partitions?  The function currently provided by the=
 2nd
RAID1 can be taken over by the single drive, and the function of the RA=
ID0
can be taken over by a directory on the main array.  This makes better
functional use of the space and may provide performance benefits, not t=
o
mention being much simpler.  I'm a fan of having a separate, small disk=
 for
booting.  My servers both have a pair of small drives each partitioned =
into
three sections.  Each of the partition pairs are in turn assembled into=
 a
RAID array for a total of 3 mounts:

md1 - a tiny /boot
md2 - a small /
md3 - swap. =20

> >> =A0 =A0OK - the problems I have with this arrangement are:
> >>
> >> 1) I used the older v0.9 metadata.
> >
> > =A0 =A0 =A0 =A0This may be necessary if you are booting from the ar=
ray. =A0The
> > limitations of the 0.90 superblock may never impact you. =A0That's =
a small
> > system with only a few drives.
> >
> >> 2) The RAIDs are assembled by the kernel automatically. I do not u=
se
> >> an initrd. (Because I don't know how/newer have)
> >
> > =A0 =A0 =A0 =A0How is that a problem? =A0An initrd, or lack thereof=
, won't prevent
> > you from disabling the automatic assembly of one or more arrays, un=
less
> once
> > again you boot from the array in question. =A0Most modern distros d=
efault
> to
> > using an initrd. =A0What distro are you using?
> >
>=20
> The machines are Gentoo and an initrd/initramfs is up to the builder.
> The new RAID6/superblock-1.2  boot uses one. The RAID1/superblock-0.9
> does not.

	OK, well, either way, any array can have auto-assembly disabled.  If
you go with a single RAID6 plus a simple drive, it won't be required,
though.

> >> 3) I think with 5 disks I could get better performance =A0than I
> >> currently get , with similar or better safety using maybe RAID5 or
> >> RAID6.
> >
> > =A0 =A0 =A0 =A0No, RAID1 is as safe as it gets. =A0RAID0 allows for=
 better
> > performance, but if you make the RAID0 into your backup solution, t=
he
> > performance won't matter much.
> >
>=20
> If I'm wrong about RAID6 please correct me as this understanding is
> why I chose it.
>=20
> 1) A 5-drive RAID6 can survive losing 2 disks and still return good d=
ata.

	Yes.

> 2) A 5-drive RAID6 reads data as nearly fast as a 3-drive RAID0.

	Or faster.  Right now your 3 drive arrays are RAID1, though, aren't
they?  RAID6 should read *MUCH* faster than RAID1

> If those two aren't true then my choice of RAID6 doesn't improve my
> system as I hoped.
>=20
> 3) My current 3-drive RAID1 can lose 2 disks and still return good
> data making #1 equivalent to #3

	Well, only in terms of survivability and only for the configuration
you mention.  An N drive RAID1 array can lose N-1 drives.  Any RAID6 ar=
ray
can lose 2 drives.

> 4) #2 would be faster than my current 2-drive RAID0 and wouldn't have
> the risk of a single drive loss.

	Yes.
=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
