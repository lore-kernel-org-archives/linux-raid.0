From: NeilBrown <neilb@suse.de>
Subject: Re: Need pointers to shrinking an array
Date: Mon, 19 Sep 2011 09:17:07 +1000
Message-ID: <20110919091707.76dfa073@notabene.brown>
References: <1316357406.15583.7.camel@michal-laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wZgpiUMdUha3o.ZfnCVeY0s"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1316357406.15583.7.camel@michal-laptop>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgg==?= Sawicz <michal@sawicz.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/wZgpiUMdUha3o.ZfnCVeY0s
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 18 Sep 2011 16:50:00 +0200 Micha=C5=82 Sawicz <michal@sawicz.net> w=
rote:

> Hi again,
>=20
> Given an array with --examine like so:
> > /dev/sdf1:
> >           Magic : a92b4efc
> >         Version : 1.1
> >     Feature Map : 0x0
> >      Array UUID : 9ce41f94:7489a7f2:6897e4b5:269c8b3b
> >            Name : media:2  (local to host media)
> >   Creation Time : Sun Jan 24 22:32:58 2010
> >      Raid Level : raid6
> >    Raid Devices : 10
> >=20
> > Avail Dev Size : 1953519738 (931.51 GiB 1000.20 GB)
> >      Array Size : 15628156928 (7452.09 GiB 8001.62 GB)
> >   Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
> >     Data Offset : 264 sectors
> >    Super Offset : 0 sectors
> >           State : clean
> >     Device UUID : 97945e4f:9f439aec:951cb289:47862ad7
> >=20
> >     Update Time : Sun Sep 18 16:31:52 2011
> >        Checksum : 4da159ea - correct
> >          Events : 4381317
> >=20
> >          Layout : left-symmetric
> >      Chunk Size : 256K
> >=20
> >    Device Role : Active device 7
> >    Array State : AAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> On it, a resized filesystem:
> > Filesystem           1K-blocks      Used Available Use% Mounted on
> > /dev/md2             1982282708 1970782580  11500128 100% /mnt/store.tmp
>=20
> I now need to shrink the array to as few drives as possible. I know
> `mdadm --grow --array-size=3Dx` will let me check if the resulting FS is
> still fine. Is x in Kibibytes, same as for --size? What's the best way
> of determining x?=20

Yes, x is in Kibibytes, though 'M' and 'G' suffixes are allowed for Mebibyt=
es
and Gibibytes.

If you try the reshape without setting --array-size first, it will tell you
exactly what --array-size command you need to run.

>=20
> Then, a `mdadm --grow --raid-devices=3Dy` will let me reduce the number of
> drives used. Is there a way to tell _which_ drives are to be active and
> which - spares in the resulting array?

It will use the first y devices.  i.e. those with a "Device Role : Active
device N' number of 0..y-1.


>=20
> Is there anything else I should know?

backups are good.
loose cables are bad.
Testing on loop-back devices can help increase your confidence.

But you probably know that already.

The really important thing is to perform proper tests after the --array-size
change to ensure that your data is still all visible.  And 'fsck' and a
'mount' should do that.  But you seem to know that already too.

NeilBrown

--Sig_/wZgpiUMdUha3o.ZfnCVeY0s
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOdnvzG5fc6gV+Wb0RAqgbAKCbRiApsYspuNZLl99Vd3CUTAdqmwCeOlR9
Nb+56I4tYp2mt67RrX1PLzk=
=OqxN
-----END PGP SIGNATURE-----

--Sig_/wZgpiUMdUha3o.ZfnCVeY0s--
