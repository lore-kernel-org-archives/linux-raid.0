From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm -E won't examine loop back device, works ok on source
 disk
Date: Mon, 23 Apr 2012 07:58:16 +1000
Message-ID: <20120423075816.6d21afe8@notabene.brown>
References: <CANb3qHeDF10CoRiteo_wwUSvGtpjcNWPh95xdatkFoY+GyAZJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JX5Wa7MOVWd90tGPORIfwsE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANb3qHeDF10CoRiteo_wwUSvGtpjcNWPh95xdatkFoY+GyAZJQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Veedar Hokstadt <veedar@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/JX5Wa7MOVWd90tGPORIfwsE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Apr 2012 17:00:04 -0400 Veedar Hokstadt <veedar@gmail.com> wrote:

> Consider a SATA drive /dev/sdb which is a member of an imsm RAID0 array...
>=20
> % sum /dev/sdb
> 25645 156290904
>=20
> The drive was imaged to a file without error and mounted as a loopback de=
vice...
>=20
> % sum /dev/loop2
> 25645 156290904
>=20
> The checksums match as expected. But I can not examine the loopback I get=
....
>=20
> % mdadm  -E -v /dev/loop2
> mdadm: No md superblock detected on /dev/loop2.
>=20
> But I can examine the physical source drive /dev/sdb...
>=20
> % mdadm  -E -v /dev/sdb
> /dev/sdb:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.0.00
>     Orig Family : e92a11d9
>          Family : e92a11d9
>      Generation : 00001608
>            UUID : 25137636:2ff64e75:10ae5444:4e8f609b
>        Checksum : e1237b20 correct
>     MPB Sectors : 1
>           Disks : 2
>    RAID Devices : 1
>=20
>   Disk01 Serial : 8068C3QVT
>           State : active
>              Id : 00010000
>     Usable Size : 312577294 (149.05 GiB 160.04 GB)
>=20
> [Volume0]:
>            UUID : 72acd5fa:35c5a901:995af79b:83a29de1
>      RAID Level : 0
>         Members : 2
>       This Slot : 1
>      Array Size : 625154048 (298.10 GiB 320.08 GB)
>    Per Dev Size : 312577283 (149.05 GiB 160.04 GB)
>   Sector Offset : 0
>     Num Stripes : 1221004
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : normal
>     Dirty State : clean
>=20
>   Disk00 Serial : 809BC541T
>           State : active failed
>              Id : 00000000
>     Usable Size : 312577294 (149.05 GiB 160.04 GB)
>=20
> I'm trying to recover data from a failed RAID0.
> I can successfully reassemble the RAID0 from the image files using
> other proprietary recovery software.
> But I would like to get it working with mdadm if at all possible.
> Any ideas?
>

Try setting  IMSM_NO_PLATFORM in the environment:

  IMSM_NO_PLATFORM=3D1 mdadm -E -v /dev/loop2

or

  export IMSM_NO_PLATFORM=3D1
  mdadm -E -v /dev/loop2

I think this is fixed in more recent mdadm.  You still need IMSM_NO_PLATFORM
to create or assemble an array, but not just to look at it.

NeilBrown



--Sig_/JX5Wa7MOVWd90tGPORIfwsE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5R++Dnsnt1WYoG5AQK9rhAAofy1KnCN/UdVykGnZoUQG1l4FOT9A4mO
AnjqxRmYj+xzvYFd6rPJqyGEEMFWUnYcmWBmGM1ElxpAuKqa+gzVwnUqrjjunR6u
FUJH5G1Vm7+5kDwg5qg5wQBwgNtRk8/Y7JenklZmGl7aLQFQB7535n8MlCGgcqnn
+IZ2Czf19pffqR02aX3lSZCcSHjEneb0Jk9M0gMgj361DrHvya58VH/c3S/3Z1Hw
hTvK8M50yWtDAPbvu3f+8IEjcDIyLXZ+LMnCyPaDqff1r9HKfkSbX5CKtmRkdc+Z
dt554522H1xdG1/q03zTs6smb9/B2IBVhOxRSdtXG5Tt/Gaz+N6dPvT6FNcb+cO0
nPKYEsZlMxl93fDmyiClTR5K2byg5fWKovxKu9KHcpqMB3aQzcDZDtiVIZNzWnLz
se1wblNq4nBLNvJv0BNblXmv1Uowyv56Op6afsM3Q7p9duBLdNDE8e6ciGVh69d5
oTOnI/X0LO9mofCX+xafr9r1QqtBcJvq3o5V4Jb3FuT5CAK2i48GfAJuYEdCti9u
kXIGm+7aN6CayiWUorACmNejDBB1FyV6wIbzQ5/rhmHdMG+PRV2yZCrQAZw/9u6M
8Js6t/CpXqfqhRRVhbYNccMoxHSdFHFFUKqOfqkNyIK1kUDvb2wfwHpLZdjZn58F
UIt7uLzJi34=
=DZDp
-----END PGP SIGNATURE-----

--Sig_/JX5Wa7MOVWd90tGPORIfwsE--
