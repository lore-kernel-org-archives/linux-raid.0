From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: RAID 5 - One drive dropped while replacing another
Date: Wed, 2 Feb 2011 19:28:35 +0500
Message-ID: <20110202192835.5d35f2d1@natsu>
References: <AANLkTinXTYds442gPrs9a9vKtWTo4OcDHDEzvO0njvyv@mail.gmail.com>
	<AANLkTikSjLhoUM5f2ibqCUmo8XF-tsrhxZ7oieg08dtD@mail.gmail.com>
	<20110202043605.593f0c5c@natsu>
	<AANLkTimJC_e8=BmGj7Th_LLc=wnoNj8tRovAgTR=mmQ7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ujSCqE8p/hSUoPVae74K4Zj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimJC_e8=BmGj7Th_LLc=wnoNj8tRovAgTR=mmQ7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: Bryan Wintermute <bryanwintermute@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ujSCqE8p/hSUoPVae74K4Zj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Feb 2011 21:21:20 +0700
hansbkk@gmail.com wrote:

> On Wed, Feb 2, 2011 at 6:36 AM, Roman Mamedov <rm@romanrm.ru> wrote:
> >
> >> I have a RAID5 setup with 15 drives.
> >
> > Looks like you got the problem you were so desperately asking for, with
> > this crazy setup. :(
>=20
> Please give some more details as to what's so crazy about this.
>=20
> I would think RAID6 would have made more sense, possibly with an
> additional spare if these are large drives (over a few hundred GB?)

Exactly, RAID6 would make an order of magnitude more sense.
A 15-drive RAID5 array is just one step (one drive failure) from becoming a
14-drive RAID0 array (reliability-wise).
Would you also ask "what's wrong with having a 14-drive RAID0"?
See the link below for some array failure probability calculations:
http://louwrentius.com/blog/2010/08/raid-5-vs-raid-6-or-do-you-care-about-y=
our-data/

--=20
With respect,
Roman

--Sig_/ujSCqE8p/hSUoPVae74K4Zj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1JahMACgkQTLKSvz+PZwhonQCfb/xbrZ268z7JUoPL3m91ST0j
4ksAmwQObcXl/Z5qT/vOGv+zQAEQksfN
=v4c7
-----END PGP SIGNATURE-----

--Sig_/ujSCqE8p/hSUoPVae74K4Zj--
