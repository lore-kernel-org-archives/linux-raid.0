From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm - level change from raid 1 to raid 5
Date: Sat, 1 Oct 2011 08:02:50 +1000
Message-ID: <20111001080250.65dc83bd@notabene.brown>
References: <BLU0-SMTP4116DC38F2741F78CA7020C9F70@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JsE=ft.A8Np5yZKjFIhhFkG"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP4116DC38F2741F78CA7020C9F70@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Dominique <dcouot@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/JsE=ft.A8Np5yZKjFIhhFkG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Sep 2011 20:31:37 +0200 Dominique <dcouot@hotmail.com> wrote:

> Hi,
>=20
> Using Ubuntu 11.10 server , I am testing RAID level changes through=20
> MDADM. The objective is to migrate RAID 1 (1+ HDD) environment to RAID 5=
=20
> (3+ HDD) without data loss.
> In order to make as simple as possible, I started in a VM environment=20
> (Virtual Box).

Very sensible!!


>=20
> Initial Setup:
> U11.10 + 2 HDD (20GB) in Raid 1 -> no problem
> The setup is made with 3 RAID 1 partition on each disk (swap (2GB), boot=
=20
> (500MB), and root (17,5GB)). I understand that this will allow to=20
> eventually grow to a RAID 5 configuration (in Ubuntu) and maintain boot=20
> on a RAID construct (swap and boot would remain on RAID 1, while root=20
> would migrate to RAID 5).
>=20
> Increment number of disks:
> add 3 HDD to the setup -> no problem
> increase the RAID 1 from 2 HDD to 5 HDD -> no problem, all disks added=20
> and synchronized

This is the bit you don't want.  Skip that step and it should work.


>=20
> root@ubuntu:~# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]=20
> [raid4] [raid10]
> md2 : active raid1 sda3[0] sde3[4] sdb3[1] sdc3[2] sdd3[3]
>        18528184 blocks super 1.2 [5/5] [UUUUU]
>=20
> md1 : active raid1 sda2[0] sde2[4] sdb2[1] sdd2[3] sdc2[2]
>        488436 blocks super 1.2 [5/5] [UUUUU]
>=20
> md0 : active raid1 sdb1[1] sde1[4] sda1[0] sdc1[2] sdd1[3]
>        1950708 blocks super 1.2 [5/5] [UUUUU]
>=20
>=20
> Change Level:
> That's where the problem occurs:
> I initially tried 3 different approaches for md2 (the root partition)
>=20
>      1. Normal boot
>=20
>      mdadm /dev/md2 --grow --level=3D5
>=20
>      Not working: 'Could not set level to raid 5'. I suppose this is=20
> because the partition is in use. Makes sense.

Nope.  This is because md won't change a 5-device RAID1 to RAID5.  It will
only change a 2-device RAID1 to RAID5.  This is trivial to do because a
2-device RAID1 and a 2-device RAID5 have data in exactly the same places.
Then you can change your 2-device RAID5 to a 5-device RAID5 - which takes a
while but this can all be done while the partition is in use.

i.e. if you start with a RAID1 with 2 active devices and 3 spares and issue
the command
    mdadm /dev/md2 --grow --level=3D5 --raid-disks=3D5

it will convert to RAID5 and then start reshaping out to include all 5 disk=
s.


NeilBrown

--Sig_/JsE=ft.A8Np5yZKjFIhhFkG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOhjyPG5fc6gV+Wb0RApt9AJ9OyE/cKcuItJ/fvCUI+sY/3fDEAACghSbM
oV6JdfAxAoKB++Twy1wOBws=
=1/4J
-----END PGP SIGNATURE-----

--Sig_/JsE=ft.A8Np5yZKjFIhhFkG--
