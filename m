From: NeilBrown <neilb@suse.de>
Subject: Re: Problem rebuild raid 1 replacement disk
Date: Mon, 20 Feb 2012 21:51:47 +1100
Message-ID: <20120220215147.7684efda@notabene.brown>
References: <807765805CA0DF48898D4C016E982BFC065A67CE25@MWLSVEXM002.au.baesystems.com>
	<20120220162915.43b4f451@notabene.brown>
	<807765805CA0DF48898D4C016E982BFC065A6D9BF5@MWLSVEXM002.au.baesystems.com>
	<20120220201159.6cd1633d@notabene.brown>
	<807765805CA0DF48898D4C016E982BFC065A6D9BF6@MWLSVEXM002.au.baesystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/H2nnEeZrKU7ImuhquBGMyG2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <807765805CA0DF48898D4C016E982BFC065A6D9BF6@MWLSVEXM002.au.baesystems.com>
Sender: linux-raid-owner@vger.kernel.org
To: "RANSOM, Tony" <tony.ransom@baesystems.com>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/H2nnEeZrKU7ImuhquBGMyG2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Feb 2012 19:45:24 +1030 "RANSOM, Tony"
<tony.ransom@baesystems.com> wrote:

> Neil,
>=20
> >Yes.
> >Somehow both sdb and sdb3 have a superblock for the same array.  Must ha=
ve
> >been a typo somewhere I suspect.
> >You should remove the one you don't want:
>=20
> >  mdadm --zero-superblock /dev/sdb
>=20
> >then it should all work nicely again.
>=20
>=20
> Unfortunately, the above command gave the following error :
>=20
> root@server2:~# mdadm --zero-superblock /dev/sdb
> mdadm: Couldn't open /dev/sdb for write - not zeroing
>=20
> Do you know how to work around?

Presumably this is because sdb3 is active in the array.  This keeps sdb bus=
y.
If this is the current situation then adding --force to the command should
make it work.

Otherwise you might need to remove sdb from the array first.

NeilBrown

--Sig_/H2nnEeZrKU7ImuhquBGMyG2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0Ilwznsnt1WYoG5AQKo6g/+NoZs7TjBBXvmm7m6ZOWfZgdHdoXHZuxb
6ZCPLgDQI5GMv6SeWv4xYErYXedTGIDMeDQ1idsOE+nbqToKvW/fqUiitFni/1uz
rvJzGLvw41GKK3eRRjoMhMX8VfYB/m96uznkJAC6gSpOXa1Ugx/my+856JetNRe9
UNPC7TogEPpn37wUWlYs/eKjPG68AhvtOeLzrHKnZUjrRLIQsQaHq0kXMOFFO2Lj
jCipsh6T5+z5nwDFGyvilBK9xG4sFzdtUEJO/EkQUyb4odhrNpQ48YymNRDl5Scz
fY3IsTuDaki5O0fFjBXV6tX1lcc5c7IhQ724ukzgq5Zk0bdFjfW4bvYdTT/UMISe
SBoS7F2k55hoshFNYct6l8EjNzk10+9cjDicUpDfblA7Wo97PVBe2EfEEbKwPmYj
K9MB8plRlRGntOfsLISs5EM/Ahlo4DcECRsllorIoO6Hg2QUqv5lUSsHX+ZOo7VO
Cjm4ugpfg4zp079OdCB+sik6Smeqo7v5ipKANE2wjUf9seqi06ImcBz3A4ycqpbj
sQyYVjnVWGnVnrWTVfKThCGooiQNSod48T7W+L6YWCWOBFo6dPwIVNBNn6SjDB5d
JClZcDA3wlSujPOJlmA5FMLRg/TEslq7vJ5ihmJq6gHFqb6357h3lAHdUbsqafW9
rr5Ul9PiOj0=
=C3bi
-----END PGP SIGNATURE-----

--Sig_/H2nnEeZrKU7ImuhquBGMyG2--
