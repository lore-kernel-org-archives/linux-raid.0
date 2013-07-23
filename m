From: NeilBrown <neilb@suse.de>
Subject: Re: shown disk sizes
Date: Wed, 24 Jul 2013 06:57:23 +1000
Message-ID: <20130724065723.3a0d52b3@notabene.brown>
References: <1374071867.25339.14.camel@heisenberg.scientia.net>
	<20130718094327.7d46949e@notabene.brown>
	<1374596770.8463.23.camel@heisenberg.scientia.net>
	<alpine.DEB.2.00.1307231911380.8891@uplift.swm.pp.se>
	<1374600126.8463.24.camel@heisenberg.scientia.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3P0ndPqo9zpBITmdp=sfQ6o"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374600126.8463.24.camel@heisenberg.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/3P0ndPqo9zpBITmdp=sfQ6o
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Jul 2013 19:22:06 +0200 Christoph Anton Mitterer
<calestyo@scientia.net> wrote:

> On Tue, 2013-07-23 at 19:12 +0200, Mikael Abrahamsson wrote:=20
> > 2^18=3D262144
> > Nothing odd about it.
> Sure... it's not e or pi ;-)
>=20
> "odd" in the sense of "why such a big offset?" respectively "what does
> it try to align to?"
>

It isn't (all) alignment.  It is mostly spare space.

New feature in 3.3 is that when you reshape (e.g.) a RAID5 to a RAID6 it can
do so without using a "backup file" - which is are a pain to work with and
slow things down a lot.
What it does instead is move the "data_offset" towards the start of the
device.  That way it is never writing onto live data, and so no backup is
needed.

For this to work, we need a buffer at the start of the device.  128M is
plenty big enough and just a tiny fraction of a 1TB drive.  (If you only ha=
ve
a small drive it will still pick a tiny fraction).

So we are reserving a bit of space for future flexibility.

NeilBrown

--Sig_/3P0ndPqo9zpBITmdp=sfQ6o
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUe7uNDnsnt1WYoG5AQIykg/+OWz0OthMSll9mNY9w2qrLqiYh0hNgBGx
PDyVdd5yZiCIHaFn2mnEpqfXzZgReiKUb5S2/2TaiyjAJZeUaptdln+e/qVgystx
qFhAjnA94Rxo+wGLIYPZ6z+tXC+zAKYeMjvPIDQSQ+Hu5Q9X3MLUjgowlIbV69YI
uEefX/bDUw1X5yEaQ6+oKLYP0OzxPBnccSnRwlCC9RNCwWb0QvYKR5WvC+DZH7Dj
mF8yCZsghGvO/78xQYbI70wk2Nn1mAivtJEEtYOtgnQJVvRxt1UiZDPTvPYZU0kP
1VxjCDqMqJpFVDvqsDYGTTMV9XhNFWfHRqQWd2qRYe2qTgNbo55SkF1tvTECqhFG
4Urkik9FsRE/Z7H1erhikHRizJYYP9VpB0owIsqozK5ufvR8gcQR6oKlORgwGVgA
ibExjI7czqt8/AEUMD5n+VaKet7g6fA2nQ4b3zQk3+8K8EV5Rqn7Duzlt6rvvSSr
LWWr9CnCGZ0PNrwSNx8aW4UXQoWki2MRhVI2LxUrfTO35odxjP8M5onSRJWb5Q2I
EZkToWXF9aG0kxoH6KpVMDNynYoz709bSXNiYN7zJmhGlmNCRt6EPxb7HULxunSI
BgVma2Pnz/moJqAKqiD3XboL2DsfgYEW4Y7H3j2xthTIaQ00JLJ4E58Mb0TdBB5U
ldgb53fBgJw=
=f+AP
-----END PGP SIGNATURE-----

--Sig_/3P0ndPqo9zpBITmdp=sfQ6o--
