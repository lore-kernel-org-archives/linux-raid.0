From: NeilBrown <neilb@suse.de>
Subject: Re: error injection
Date: Thu, 29 Sep 2011 11:08:36 +1000
Message-ID: <20110929110836.1dc9944d@notabene.brown>
References: <CAJD3hpWbkSGeiWDgYHP3ewnw7akoEY-ydoRJKLxwcp8+up5zKw@mail.gmail.com>
	<20110929091128.1488f267@notabene.brown>
	<CAJD3hpUNkLDRGQxNuo6m7=OQjBu3uc5xV7Fzy-XLvrUFHQJbiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/k9Ir0z0.zzHr_=..ltLWAN/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJD3hpUNkLDRGQxNuo6m7=OQjBu3uc5xV7Fzy-XLvrUFHQJbiw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jojy Varghese <jojy.varghese@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/k9Ir0z0.zzHr_=..ltLWAN/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Sep 2011 17:59:49 -0700 Jojy Varghese <jojy.varghese@gmail.com>
wrote:

> Thanks Neil. I tried setting my sda7 partition to generate write
> errors every 40 bytes(writing 1 byte at a time). I did :

md doesn't see byte writes.  It sees sectors or more - usually whole pages =
or
groups of pages.

>=20
> 1. Create a array with:
> mdadm -C /dev/md/me0 -l faulty -n1 /dev/sda7

-C will write a superblock to /dev/sda7 which you don't really want.  It
doesn't hurt, but I always used -B (--build) to avoid any metadata.

>=20
> After this step I can see /dev/md127 and when i do a mdadm -D /dev/md127,=
 i get:
>=20
> /dev/md127:
>         Version : 1.2
>   Creation Time : Wed Sep 28 17:35:50 2011
>      Raid Level : faulty
>      Array Size : 969410424 (924.50 GiB 992.68 GB)
>    Raid Devices : 1
>   Total Devices : 1
>     Persistence : Superblock is persistent
>=20
>     Update Time : Wed Sep 28 17:35:50 2011
>           State : clean
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>            Name : eng-dev16.lab.local:me0  (local to host eng-dev16.lab.l=
ocal)
>            UUID : 96f4be10:312f9574:f40107aa:d9f278ba
>          Events : 0
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8        7        0      active sync   /dev/sda7
>=20
>=20
> 2. Set write fault level with:
>=20
> mdadm -G /dev/md/me0 --layout=3Dwp40
>=20
>=20
>=20
>   After this when i write > 40 bytes into /dev/md127, i dont get any
> I/O errors. I am sure i am doing something wrong here.

When you write to /dev/md127 it will just go into the page cache and
eventually be flushed to the device in one write.
Use O_DIRECT or O_SYNC and it will be flushed out more quickly, but always
write at least 512  bytes at a time.

NeilBrown



>=20
>=20
> Any help is much appreciated.
>=20
> Thanks
> Jojy

--Sig_/k9Ir0z0.zzHr_=..ltLWAN/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOg8UUG5fc6gV+Wb0RAkEOAKCKye5hm5WYHh5r7FwJn0VzWEOD4gCfW0dh
/QpgbivMh9oa6SQP4IMabhc=
=3R1R
-----END PGP SIGNATURE-----

--Sig_/k9Ir0z0.zzHr_=..ltLWAN/--
