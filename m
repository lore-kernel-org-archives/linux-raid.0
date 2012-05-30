From: NeilBrown <neilb@suse.de>
Subject: Re: raid10 devices all marked as spares?!
Date: Wed, 30 May 2012 11:14:05 +1000
Message-ID: <20120530111405.53f7e68c@notabene.brown>
References: <4FC3E4FB.4010003@schinagl.nl>
	<20120529080736.03c62ae1@notabene.brown>
	<4FC3FFE7.6020606@schinagl.nl>
	<20120529090938.5af8a7ed@notabene.brown>
	<4FC518FB.4000408@schinagl.nl>
	<4FC51A0A.6070700@schinagl.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6iafJzHcD3L6fAcS2nSbz5n"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FC51A0A.6070700@schinagl.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Schinagl <oliverlist@schinagl.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/6iafJzHcD3L6fAcS2nSbz5n
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 May 2012 20:48:42 +0200 Oliver Schinagl <oliverlist@schinagl.nl>
wrote:

> On 29-05-12 20:44, Oliver Schinagl wrote:
> > <snip>
> >>>> You can recover your data by re-creating the array.
> >>>>
> >>>>     mdadm -C /dev/md2 -l10 -n2 --layout o2 --assume-clean \
> >>>>     -e 1.2  /dev/sda6 /dev/sdb6
> >>>>
> >>>> Check that I have that right - don't just assume :-)
> >>> That looks very similar to what I used to create the array with, exce=
pt
> >>> the assume-clean part. I wonder however, would it not wiser to create
> >>> the array using /dev/sda6 missing thus creating a degraded array?
> >>> Atleast I'll still have the sdb6 which MAY contain the data also (sin=
ce
> >>> only sda6 'apparently' has wrong state?
> >> That would be a suitable approach - arguably safer.  If you feel more
> >> comfortable with it, then that is a strong reason to follow that cours=
e.
> >
> > I have tried that on sda6 but it cannot file a filesystem when trying=20
> > to mount md2. This of course is quite scary. I am now slightly=20
> > doubting if my chunksize is the same as before, 128k.
> >
> > I've used the following command.
> > mdadm -C /dev/md2 -c 128 -l 10 -p o2 --assume-clean -e 1.2 -n 2=20
> > --name=3Dopt /dev/sda6 missing
> >
> > Now I could try the same on sdb6 and hope that does work, but slightly=
=20
> > scared of loosing everything on that partition, it could be possible=20
> > of course that sdb6 is the partition that has everything in the=20
> > 'proper' order? I will try to losetup sdb6 with an offset and see if=20
> > that is mountable.
> Also, I forgot to mention, the thing that is really strange, is that the=
=20
> data offset is somewhere extremely strange.
>=20
> Data Offset : 262144 sectors

128MB.

>=20
> where sda4 and sdb5 (md0 and 1) both have 2048, which sounds common and=20
> sensible.

You'll need to use an older mdadm which uses the 2048 (1MB) offset.
The next mdadm (3.3) will have a --data-offset option to make this easier to
control.  For now you need 3.2.3 or earlier.
That should make your filesystem accessible.  If it doesn't try a different
chunk size. Maybe 64, maybe 512.

NeilBrown


--Sig_/6iafJzHcD3L6fAcS2nSbz5n
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8V0XTnsnt1WYoG5AQLyoA//ch6WE7StGaxjmibS8zeRJ5ugNsGJBMcV
g2ycbmg3MUmrZGWnLZ7HNLk/rpfYgoIkR9QGT6CnpEHb8eUBAkbnzkdYbjoUauTl
NmhoYIgQqZMKtNQb78jC/osUfQNqmqMWayHeK3GoQdzyrUM0JWKvXx+lErowO/HC
x2YeTQFSP3XgpxhLwImxki97lkKE48eimMwk/pNqL/NpNIqwFxt5obWw3JpHXzkm
+LO1ELBDwdvHRE1Eh0Kby7aEIbjlyuLvwMpaYXjgyF/1wq+fECKXruXZbrJ5i7qO
C2XJ9Bk5UaLDsmOg2bWt45gRMyd5gvF8/51ryxT6inSraqHaA60SxqyWPT+aHyHd
yjxEOKWlYKSLF1OtS21pJIyH/YKxPPYM/Zi1DKwfCEjs//QwFB6n4qfu4oOladtw
bTLlrMc9vLaurE1cjcp13Ed1xtLfHua+RrF3Tgf0bOdiRXs2xCEyKzrF8kH5C2+0
6oFDjhLT+eUVfBEI13ZX7NKkTwSSbFKBJUnJkec1EqfZvhVCbBwjqMPafOOFQ/Eu
W+YXrh7mMWAKuXTLL0PKpuGuSmlYCOz857brgsVNJtx1f15/zz8NBYNbnIrngRro
Wozs9pk9Zol6YXlq5D1O+ibfXLGH932pesr1GSkfipWpYvm2Uk69SjaWv15Gu8FY
CR0xJXAtosQ=
=21ES
-----END PGP SIGNATURE-----

--Sig_/6iafJzHcD3L6fAcS2nSbz5n--
