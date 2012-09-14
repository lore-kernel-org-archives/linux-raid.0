From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 issue after disk failure: both disks of the array are
 still active
Date: Fri, 14 Sep 2012 18:13:15 +1000
Message-ID: <20120914181315.79d6d746@notabene.brown>
References: <5051AF17.8010501@linuxsystems.it>
	<20120913103432.GA11764@cthulhu.home.robinhill.me.uk>
	<B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com>
	<alpine.DEB.2.00.1209140912350.13902@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/UVnMef381PjCdNP9gIrjAyJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1209140912350.13902@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Chris Murphy <lists@colorremedies.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/UVnMef381PjCdNP9gIrjAyJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 14 Sep 2012 09:16:20 +0200 (CEST) Mikael Abrahamsson
<swmike@swm.pp.se> wrote:

> On Thu, 13 Sep 2012, Chris Murphy wrote:
>=20
> > "check" records errors, no action is taken by the md driver to correct=
=20
> > it, although the disk firmware itself may try reallocation. So far, tha=
t=20
> > appears to not be the case.
> >
> > "repair" causes the md driver to write correct data (from copy or=20
> > reconstructed from parity), which should force the disk firmware to=20
> > reallocate the affected LBAs from bad physical sectors to good ones.
> >
> > It seems in this case "repair" is indicated.
>=20
> I was under the impression that "check" would check if all data blocks an=
d=20
> parity are correct, and record if there is a parity mismatch. This would=
=20
> then be corrected by using "repair" at a later time.
>=20
> I was also under the impression that if there was a read error on a drive=
=20
> during "check", that read error would be corrected using parity because=20
> it's obviously a hard error, not a logical error.

Both of your impressions are correct.

NeilBrown

>=20
> Could you (or someone else) please confirm that my impression is wrong an=
d=20
> if there indeed is a hard read error using "check", this will not be=20
> corrected? I would be interested in knowing why this decision was taken t=
o=20
> have this behaviour, as I feel that if there is a hard read error, this=20
> should always be corrected using parity.
>=20


--Sig_/UVnMef381PjCdNP9gIrjAyJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFLnGznsnt1WYoG5AQJ3nw/9GDGWwL5e0N4npABVf5Gub+YxcU6NfipS
Ltyq57PNXd02rAj4inmz8Q37433KKTzyz2hKiMebwqrEgksqaQPskv908b1YG50m
g0I57WMxGLSq2tmAwhn9D4p0rLrSeWN83aD0OhWg5RUbOFfpyceqDt1vO42w6iqb
3FNvcWZKIN6QelG9XHE9O7wgD6VEw6/wtMORrF2Upt1chI5k0QxI/2xWE0E7FcJO
hA53/aYnP3p2auz8QjF1es/lE15+8bylFWnv1wSwnwnXGgw7GGNNG1ZGHSpC4Zqh
+QnawXq8L80kWhBNRUfJ3DV/PSwCP0IKgB9pVonXXjvJLIf0opU4bdflwc0VZiLv
eGYcr971kzO0JNxmSLPt+U2qEF6rIQ+m7h9I/ylCCq8JqxVJM8NaQJROiFL/EBHj
kcZ3me/0Ggp+gNnKfSivxbl7sP93nBHxligPTElnwDqtWooRCty573BZljrMHTYC
6Kb63HqEmj7Ra3DOON361yaGcZ4HKeAczt+EBrgC9vsXudtc1Lxeaz4Pn6waB/up
WYmnxePjxcL8Kil+SjNPvK9rkx4+IaG1sMVoztY1RcNKcOw59GG8yIYfBEwGQEiq
zztO+cdbPXXr+06UPtDcQedusmGWx3VZKduJwT/N7BDXXMbCyu8zB49DjTvB/cXs
ATTaWSMN8O4=
=4RAs
-----END PGP SIGNATURE-----

--Sig_/UVnMef381PjCdNP9gIrjAyJ--
