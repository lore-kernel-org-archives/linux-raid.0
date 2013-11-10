From: NeilBrown <neilb@suse.de>
Subject: Re: Running check and e2fsck simultaneously
Date: Mon, 11 Nov 2013 09:51:24 +1100
Message-ID: <20131111095124.560dc6c0@notabene.brown>
References: <B385A1A4-3EB2-48CA-8EA5-FE8A0F5C2BA0@gmail.com>
	<527FCBAF.4070208@hardwarefreak.com>
	<58CD4AD8-0A1E-42E8-984D-F4727EE2B8F0@gmail.com>
	<527FDBC1.4000009@hardwarefreak.com>
	<20131111073428.583b83b2@notabene.brown>
	<52800A73.9020401@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zGvgnexs5qVh=Os=0Ngi4Su"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52800A73.9020401@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/zGvgnexs5qVh=Os=0Ngi4Su
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Nov 2013 16:36:35 -0600 Stan Hoeppner <stan@hardwarefreak.com>
wrote:

> On 11/10/2013 2:34 PM, NeilBrown wrote:
> > On Sun, 10 Nov 2013 13:17:21 -0600 Stan Hoeppner <stan@hardwarefreak.co=
m>
> > wrote:
> >=20
> >> Also, I see little/no value in running a scheduled mdadm check on a
> >> RAID1 array.  Any problems with RAID1 will be due to one of the disks
> >> beginning to fail in some mode, usually requiring sector relocation.
> >=20
> > I think scrubbing has value on any RAID with redundancy.
>=20
> That's a bit... redundant, Neil. :)

RAID0.  Sadly a name that is used, even though it is an oxymoron.

>=20
> > The firmware can only relocate a sector if it reads it when it is margi=
nal
> > but not yet completely lost.  If a sector is not read for a long time a=
nd
> > during that time the media degraded beyond recovery the firmware cannot=
 do
> > anything.  But RAID1 can - it can get it from the other device.
>=20
> But is a scrub required for this?  Isn't this exactly what occurs during
> normal operation with md/RAID1?  I.e. a read fails with disk error, so
> we grab the sector from the mirror?  So what advantage is there to
> scrubbing md/RAID1?
>=20

If scrubbing finds and repairs a (rarely accessed) bad sector on one drive
before the other drive dies completely, that is a win.

NeilBrown

--Sig_/zGvgnexs5qVh=Os=0Ngi4Su
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoAN7Dnsnt1WYoG5AQJ9nRAAnQkJICQmaQCgojeoWxU47KW7g/RYdmO4
Ar52BRo6Exb6a1nJmkBNy99fG8Aw7CiYBsAnmuCwdKjRg3YZX0FnKeQmiJwvOXES
BSnqU9yGAy4gHjzzYat0fjUhiXk2zlN6viroE8j8yAh9lEDqiCbdGKHk0TXBS4GX
6Mi2RDWZMJT7PY9X+1gWdz9PNTYe7yYtc1MYzkzhV2AsLYvEMe4XObcEQjxoUUjE
dq/hb19JNzol0+Ttt2rF6NKzrYtH/AsrsCMb8f5HJfk7JIkV4McHZMibajSFuirE
U1Cl8F2k0EicoWCxO8NeBpsW/8kN7drhb+quFKi/xZ9r/d7cIX6uDZWYl1dBg+zn
p8GggsDZ5sLlfmg1wOTbubWxNRn4jP6Ntt5CBXWI04f5w1+xfgMnXSFQHMcALIQR
OupN+eFvl5c/Fi5orzlpXbwR6wSKfW4ogR+od7f+Lha4HfRGLYVOuheGiSP5z7zo
L+Fz4ozzHEv/8mYP8Ns74P2vz8LPc7jEaIw+mtBRJJe82P9nbfttpw9DtMHx/Ane
JP6f50SuDuSjhnEQAZ8Zl4/yYwOmHBiPXsQKQTVHt8T/SuEz6rYgQZFQufTsBT+w
xqEwKF05AHdrxN80dp1JIBTM7ZwR7Dy4jurJ4ZXn17pZ/JZwDliwvn3UODSm9OoS
MEpC6HqrAGI=
=Bq2J
-----END PGP SIGNATURE-----

--Sig_/zGvgnexs5qVh=Os=0Ngi4Su--
