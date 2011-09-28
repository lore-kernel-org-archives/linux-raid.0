From: NeilBrown <neilb@suse.de>
Subject: Re: Creating an md with 3TB drives.
Date: Wed, 28 Sep 2011 18:23:02 +1000
Message-ID: <20110928182302.39cfd4b0@notabene.brown>
References: <4E82D53F.3050409@yazzy.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SfKaUKaow+NC1Nw9hal911+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E82D53F.3050409@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/SfKaUKaow+NC1Nw9hal911+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Sep 2011 10:05:19 +0200 "Marcin M. Jessa" <lists@yazzy.org> wrot=
e:

> Hi guys.
>=20
>=20
> I have two 3TB drives and I want to set them up as RAID0.
> The problem is I can't use all of the space on them.
> I only get 4TB of the 6 in total.
>=20
> What I tried was:
> # parted /dev/sde
> GNU Parted 2.3
> Using /dev/sde
> Welcome to GNU Parted! Type 'help' to view a list of commands.
> (parted)  mklabel gpt
> Warning: The existing disk label on /dev/sde will be destroyed and all=20
> data on this disk will be lost. Do you want
> to continue?
> Yes/No? yes
> (parted) mkpart primary 0 -0
> Warning: The resulting partition is not properly aligned for best=20
> performance.
> Ignore/Cancel? ignore
> (parted) print
> Model: ATA Hitachi HDS72303 (scsi)
> Disk /dev/sde: 3001GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
>=20
> Number  Start   End     Size    File system  Name     Flags
>   1      17.4kB  3001GB  3001GB               primary

I wouldn't bother with a partition table - just use the whole device.
But partition tables should work if you want that.

>=20
> (parted) quit
>=20
> Then I used fdisk to change the partition type to Linux raid auto

You can do that if you like but it will have no effect.  The "raid auto"
partition type only means anything on MBR partitions.  You don't need to, so
don't bother.

>=20
> Finally I ran
> mdadm --create /dev/md2 --level=3D0 --raid-devices=3D2 /dev/sdd1 /dev/sde1
>=20
> but mdadm -QD /dev/md2 shows 2TBs are gone.
> Array Size : 4294964224 (4096.00 GiB 4398.04 GB)
>=20
> What to do in this case? How can I a 6TB raid array ?
>=20
Hmm... maybe you have an old version of mdadm.
Or maybe mdadm is broken.
Please report:
 mdadm -E /dev/sdd1 /dev/sde1
 blockdev --getsz /dev/md2
 cat /proc/mdstat

NeilBrown


>=20


--Sig_/SfKaUKaow+NC1Nw9hal911+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOgtlmG5fc6gV+Wb0RAt2hAKDRvlcbByS0lc+XrB+1PKgllvLySACeKQGK
17ct3K66CFNKbuphWZq7wsw=
=IEo4
-----END PGP SIGNATURE-----

--Sig_/SfKaUKaow+NC1Nw9hal911+--
