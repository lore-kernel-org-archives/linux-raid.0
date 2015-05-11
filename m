From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: Possible RAID6 regression with ASYNC_TX_DMA enabled in 4.1
Date: Mon, 11 May 2015 11:13:35 +0200
Message-ID: <20150511091335.GA10961@lukather>
References: <20150507125702.GI11057@lukather>
 <12EF8D94C6F8734FB2FF37B9FBEDD1735FC9B959@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735FC9B959@EXCHANGE.collogia.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: Neil Brown <neilb@suse.de>, Shaohua Li <shli@fusionio.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Lior Amsalem <alior@marvell.com>, Thomas Petazzoni <thomas@free-electrons.com>, Gregory Clement <gregory.clement@free-electrons.com>, Boris Brezillon <boris@free-electrons.com>
List-Id: linux-raid.ids


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Markus,

On Thu, May 07, 2015 at 02:39:07PM +0000, Markus Stockhausen wrote:
> Hi Maxime,
>=20
> > Von: linux-raid-owner@vger.kernel.org [linux-raid-owner@vger.kernel.org=
]&quot; im Auftrag von &quot;Maxime Ripard [maxime.ripard@free-electrons.co=
m]
> > Gesendet: Donnerstag, 7. Mai 2015 14:57
> > An: Neil Brown; Shaohua Li
> > Cc: linux-raid@vger.kernel.org; linux-kernel@vger.kernel.org; Lior Amsa=
lem; Thomas Petazzoni; Gregory Clement; Boris Brezillon
> > Betreff: Possible RAID6 regression with ASYNC_TX_DMA enabled in 4.1
> >=20
> > Hi,
> >=20
> > I'm currently trying to add support for the PQ operations on the
> > marvell XOR engine, in dmaengine, obviously to be able to use async_tx
> > to offload these operations.
> >=20
> > I'm testing these patches with a RAID6 array with 4 disks.
> >=20
> > However, since the commit 59fc630b8b5f ("RAID5: batch adjacent full
> > stripe write", every write to that array fails with the following
> > stacktrace.
> >=20
> > http://code.bulix.org/eh8iew-88342?raw
>=20
> I don't know if it might be related. I added support for RAID6 Read-Modif=
y-Write
> in software XOR with some patches. The following commit mangles some line=
s in=20
> async_pq.c:
>=20
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?
> id=3D584acdd49cd2472ca0f5a06adbe979db82d0b4af
>=20
> I introduced a new flag ASYNC_TX_PQ_XOR_DST that notifies the async layer
> that we want to do a XOR syndrome operation instead of a full calculation.
> This will enforce the software path because I guessed that hardware does =
not
> support that case. Without hardware to check I might have missed some=20
> checks in the async layer.
>=20
> In the upper layer ops_run_reconstruct6 will set the flag if we determined
> that rmw is faster than rcw.
>=20
> Can you check if rmw_level=3D0 fixes the issue. See:
>=20
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?
> id=3Dd06f191f8ecaef4d524e765fdb455f96392fbd42

I just gave this a try, and it doesn't fix anything.

One thing I forgot to mention is that our hardware doesn't support the
PQ multiplications and product sums, so one of the patches we have is
to add a new ASYNC_TX flag to be able to identify and bail out of such
transfers.

The patch is here:
https://github.com/MISL-EBU-System-SW/mainline-public/commit/9964fe4a79da10=
162f83bd527b3fe44da60d7e0f

There might be some interaction between your patch and this one, even
though the async_tx code itself looks to be untouched by your patches.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVUHK/AAoJEBx+YmzsjxAgwPIP/jzHlKeiKVM48cOppT+6xF94
UXp9L98ccmLCxLT4dHAuB1+X4J5aX8a1pFkh4Zi5VFycGK13Sfrlf//u9ivPT2Px
H0qXBKkTStJTftrDMzfyYbS0JPhx+e2YwQIoI6kGpLHn+qmP6TMsbHh7hhrGrq07
XJMlnoaZGqZGk2rQNl2wF6O2IiyT3qKSnkarbXpPOrpj4iMKlTyRrO53tce0s6TR
yf3EUM7SeLNM00ByLH0wFK0VxU35HJuDW+SgalS2OnqsSMAmKsO4l+lk8EmjLrpo
feg8Pyy20cn0zeWwETg5e64SFaqFZf+VLxj6070yYvLb7hD//DyMo1e/j+poDyyx
ESK81DMmAEYl7LE7J3KMLFSJK00aTcKjX3td2rt8sw3F++6MWXx80IR+FL8us8oa
sTLIQTcJALr4WFxdmIpE+YzuGHkAMGManpdjG25GJfY7H5ERCUZw/XDz/r4C9YX6
tV1MnweVUaEONcrB8RW4ADROMNKMvvrGnO/GSl8hM0MTTaPENZMWO+ePHkbTwE7U
TDJgUr2firFAYQFeIAWqJDAMECY2HhfZTiu4dwUj0TaUbrBC0jfbMrQ6h+tXeCYg
uz2uL6fo7QvQeMne0uny404sn08mnSSv+DrS+Vmg65X7UWKXI8TODgZrlyinSNl3
xH26X14mhq/zZc4KeO0T
=0m98
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
