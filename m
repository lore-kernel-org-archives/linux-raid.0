From: NeilBrown <neilb@suse.de>
Subject: Re: Data Offset
Date: Sat, 2 Jun 2012 09:52:37 +1000
Message-ID: <20120602095237.3822e2c2@notabene.brown>
References: <CAFhY2CjOECFy4bWDL6zs9rtSkVGPR9Wv=1UX9vKgmdjwMsmBYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yV2ZDhPD2uGWflw/pZ1ljVe"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFhY2CjOECFy4bWDL6zs9rtSkVGPR9Wv=1UX9vKgmdjwMsmBYg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: freeone3000 <freeone3000@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/yV2ZDhPD2uGWflw/pZ1ljVe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 1 Jun 2012 18:22:33 -0500 freeone3000 <freeone3000@gmail.com> wrote:

> Hello. I have an issue concerning a broken RAID of unsure pedigree.
> Examining the drives tells me the block sizes are not the same, as
> listed in the email.
>=20
> > I certainly won't be easy.  Though if someone did find themselves in th=
at
> > situation it might motivate me to enhance mdadm in some way to make it =
easily
> > fixable.
>=20
> I seem to be your motivation for making this situation fixable.
> Somehow I managed to get drives with an invalid block size. All worked
> fine until a drive dropped out of the RAID5. When attempting to
> replace, I can re-create the RAID, but it cannot be of the same size
> because the 1024-sector drives are "too small" when changed to
> 2048-sector, exactly as described. Are there any recovery options I
> could try, including simply editing the header?

You seem to be leaving out some important information.
The "mdadm --examine" of all the drives is good - thanks - but what exactly
if your problem, and what were you trying to do?

You appear to have a 5-device RAID5 of which one device (sde3) fell out of
the array on or shortly after 23rd May, 3 drives are working fine, and one -
sdf (not sdf3??) - is a confused spare....

What exactly did you do to sdf?

NeilBrown


>=20
>=20
> mdadm --examine of all drives in the RAID:
>=20
> /dev/sdb3:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
> =C2=A0 =C2=A0 Feature Map : 0x0
> =C2=A0 =C2=A0 =C2=A0Array UUID : 9759ad94:75e30b6b:8a726b4d:177a6eda
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : leyline:1 =C2=A0(local to=
 host leyline)
> =C2=A0 Creation Time : Mon Sep 12 13:19:00 2011
> =C2=A0 =C2=A0 =C2=A0Raid Level : raid5
> =C2=A0 =C2=A0Raid Devices : 5
>=20
> =C2=A0Avail Dev Size : 3906525098 (1862.78 GiB 2000.14 GB)
> =C2=A0 =C2=A0 =C2=A0Array Size : 15626096640 (7451.10 GiB 8000.56 GB)
> =C2=A0 Used Dev Size : 3906524160 (1862.78 GiB 2000.14 GB)
> =C2=A0 =C2=A0 Data Offset : 2048 sectors
> =C2=A0 =C2=A0Super Offset : 8 sectors
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
> =C2=A0 =C2=A0 Device UUID : 872097fa:3ae66ab4:ed21256a:10a030c9
>=20
> =C2=A0 =C2=A0 Update Time : Fri Jun =C2=A01 03:11:54 2012
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : 6d627f7a - correct
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 2127454
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Layout : left-symmetric
> =C2=A0 =C2=A0 =C2=A0Chunk Size : 512K
>=20
> =C2=A0 =C2=A0Device Role : Active device 1
> =C2=A0 =C2=A0Array State : AAAA. ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
> =C2=A0 =C2=A0 Feature Map : 0x0
> =C2=A0 =C2=A0 =C2=A0Array UUID : 9759ad94:75e30b6b:8a726b4d:177a6eda
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : leyline:1 =C2=A0(local to=
 host leyline)
> =C2=A0 Creation Time : Mon Sep 12 13:19:00 2011
> =C2=A0 =C2=A0 =C2=A0Raid Level : raid5
> =C2=A0 =C2=A0Raid Devices : 5
>=20
> =C2=A0Avail Dev Size : 3906525098 (1862.78 GiB 2000.14 GB)
> =C2=A0 =C2=A0 =C2=A0Array Size : 15626096640 (7451.10 GiB 8000.56 GB)
> =C2=A0 Used Dev Size : 3906524160 (1862.78 GiB 2000.14 GB)
> =C2=A0 =C2=A0 Data Offset : 2048 sectors
> =C2=A0 =C2=A0Super Offset : 8 sectors
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
> =C2=A0 =C2=A0 Device UUID : 2ea285a1:a2342c24:ffec56a2:ba6fcf07
>=20
> =C2=A0 =C2=A0 Update Time : Fri Jun =C2=A01 03:11:54 2012
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : fae2ea42 - correct
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 2127454
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Layout : left-symmetric
> =C2=A0 =C2=A0 =C2=A0Chunk Size : 512K
>=20
> =C2=A0 =C2=A0Device Role : Active device 0
> =C2=A0 =C2=A0Array State : AAAA. ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sdc3:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
> =C2=A0 =C2=A0 Feature Map : 0x0
> =C2=A0 =C2=A0 =C2=A0Array UUID : 9759ad94:75e30b6b:8a726b4d:177a6eda
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : leyline:1 =C2=A0(local to=
 host leyline)
> =C2=A0 Creation Time : Mon Sep 12 13:19:00 2011
> =C2=A0 =C2=A0 =C2=A0Raid Level : raid5
> =C2=A0 =C2=A0Raid Devices : 5
>=20
> =C2=A0Avail Dev Size : 3906525098 (1862.78 GiB 2000.14 GB)
> =C2=A0 =C2=A0 =C2=A0Array Size : 15626096640 (7451.10 GiB 8000.56 GB)
> =C2=A0 Used Dev Size : 3906524160 (1862.78 GiB 2000.14 GB)
> =C2=A0 =C2=A0 Data Offset : 2048 sectors
> =C2=A0 =C2=A0Super Offset : 8 sectors
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
> =C2=A0 =C2=A0 Device UUID : 2ea285a1:a2342c24:ffec56a2:ba6fcf07
>=20
> =C2=A0 =C2=A0 Update Time : Fri Jun =C2=A01 03:11:54 2012
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : fae2ea42 - correct
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 2127454
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Layout : left-symmetric
> =C2=A0 =C2=A0 =C2=A0Chunk Size : 512K
>=20
> =C2=A0 =C2=A0Device Role : Active device 0
> =C2=A0 =C2=A0Array State : AAAA. ('A' =3D=3D active, '.' =3D=3D missing)
>=20
>=20
> /dev/sdd3:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
> =C2=A0 =C2=A0 Feature Map : 0x0
> =C2=A0 =C2=A0 =C2=A0Array UUID : 9759ad94:75e30b6b:8a726b4d:177a6eda
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : leyline:1 =C2=A0(local to=
 host leyline)
> =C2=A0 Creation Time : Mon Sep 12 13:19:00 2011
> =C2=A0 =C2=A0 =C2=A0Raid Level : raid5
> =C2=A0 =C2=A0Raid Devices : 5
>=20
> =C2=A0Avail Dev Size : 3906524160 (1862.78 GiB 2000.14 GB)
> =C2=A0 =C2=A0 =C2=A0Array Size : 15626096640 (7451.10 GiB 8000.56 GB)
> =C2=A0 =C2=A0 Data Offset : 1024 sectors
> =C2=A0 =C2=A0Super Offset : 8 sectors
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
> =C2=A0 =C2=A0 Device UUID : 8d656a1d:bbb1da37:edaf4011:1af2bbb9
>=20
> =C2=A0 =C2=A0 Update Time : Fri Jun =C2=A01 03:11:54 2012
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : ab4c6863 - correct
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 2127454
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Layout : left-symmetric
> =C2=A0 =C2=A0 =C2=A0Chunk Size : 512K
>=20
> =C2=A0 =C2=A0Device Role : Active device 3
> =C2=A0 =C2=A0Array State : AAAA. ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sde3:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
> =C2=A0 =C2=A0 Feature Map : 0x0
> =C2=A0 =C2=A0 =C2=A0Array UUID : 9759ad94:75e30b6b:8a726b4d:177a6eda
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : leyline:1 =C2=A0(local to=
 host leyline)
> =C2=A0 Creation Time : Mon Sep 12 13:19:00 2011
> =C2=A0 =C2=A0 =C2=A0Raid Level : raid5
> =C2=A0 =C2=A0Raid Devices : 5
>=20
> =C2=A0Avail Dev Size : 3906524160 (1862.78 GiB 2000.14 GB)
> =C2=A0 =C2=A0 =C2=A0Array Size : 15626096640 (7451.10 GiB 8000.56 GB)
> =C2=A0 =C2=A0 Data Offset : 1024 sectors
> =C2=A0 =C2=A0Super Offset : 8 sectors
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
> =C2=A0 =C2=A0 Device UUID : 37bb83bd:313c9381:cabff9d0:60bd205c
>=20
> =C2=A0 =C2=A0 Update Time : Wed May 23 03:30:50 2012
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : f72e6959 - correct
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 2004256
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Layout : left-symmetric
> =C2=A0 =C2=A0 =C2=A0Chunk Size : 512K
>=20
> =C2=A0 =C2=A0Device Role : spare
> =C2=A0 =C2=A0Array State : AAAA. ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sdf:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.2
> =C2=A0 =C2=A0 Feature Map : 0x0
> =C2=A0 =C2=A0 =C2=A0Array UUID : 9759ad94:75e30b6b:8a726b4d:177a6eda
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : leyline:1 =C2=A0(local to=
 host leyline)
> =C2=A0 Creation Time : Mon Sep 12 13:19:00 2011
> =C2=A0 =C2=A0 =C2=A0Raid Level : raid5
> =C2=A0 =C2=A0Raid Devices : 5
>=20
> =C2=A0Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
> =C2=A0 =C2=A0 =C2=A0Array Size : 15626096640 (7451.10 GiB 8000.56 GB)
> =C2=A0 Used Dev Size : 3906524160 (1862.78 GiB 2000.14 GB)
> =C2=A0 =C2=A0 Data Offset : 2048 sectors
> =C2=A0 =C2=A0Super Offset : 8 sectors
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
> =C2=A0 =C2=A0 Device UUID : e16d4103:cd11cc3b:bb6ee12e:5ad0a6e9
>=20
> =C2=A0 =C2=A0 Update Time : Fri Jun =C2=A01 03:11:54 2012
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : e287a82a - correct
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 0
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Layout : left-symmetric
> =C2=A0 =C2=A0 =C2=A0Chunk Size : 512K
>=20
> =C2=A0 =C2=A0Device Role : spare
> =C2=A0 =C2=A0Array State : AAAA. ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> --
> James Moore
>=20
> --
> James Moore
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/yV2ZDhPD2uGWflw/pZ1ljVe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8lVxTnsnt1WYoG5AQKwpw//cJFvTDE0EZIWeWYsoS4QBAkoD75I20Qf
yXf1SIo2IW+814WTLeERkENTO4byxMg6O6OeEKD4AAkuPuOGphP/as6xB21nTeNs
QkLiCQb19FgaLu7fU4f2GlOa82tjSVvUVHhWvZiOS4e/OJAVBhpPwg3CJes+5cbv
TJcwlj0ym2L6KWblgLGvZ4h+QusffFydC71gfH09sqCBax2U8DO3rOpWzVjq+Wlu
9+M+7xznbcw8tplaSZA5ygmK6J4b/b1uqGpyK6aafVhOlAZv/HtUUX/b8FAEfIuS
guBPh1zLNAgljh0QV8JsqFwAV3KfPnZlORJYW8w8ZHh2j4ZJ0AuGRe71yAM1B+k6
nRahqXVn3gWE0CbZ7vyEbJsGctPOKEM26k4qOLiLodIv4ALHNvrY29Fc8mDWH3jZ
KlHnOVMjZPrRZeSH0Lzr9EqKeV0B7pJYMuzISv7nfIJ3A52yL8uu6gbX05m5SmR9
xDoaduH8Oyvdd6mYUkm69moe5tfxnkCBcOAvSn7lBIJdOgSoaJrfShaDGZeqLk1+
TiWz9qkcwdzS7TO9ViVEQRab88OPVFjZSDc5aLwsBU5St7Ez+REmDQ5MMGSnQRXu
qE6xWzW1yaBVhbI2oF+6wtn+523sdbKdZZb/oVP0jddp2AYlkMPLRZAd3adBpko3
vnt1heHa1Sk=
=qtwF
-----END PGP SIGNATURE-----

--Sig_/yV2ZDhPD2uGWflw/pZ1ljVe--
