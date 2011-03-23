From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Convert RAID5 to RAID6 in a live system
Date: Wed, 23 Mar 2011 13:14:24 +0500
Message-ID: <20110323131424.70a0e08a@natsu>
References: <201103230843.59080.stefan.roese@gmail.com>
	<alpine.DEB.2.00.1103230905480.4842@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FpMuekyPoxjU8c6_4XGY+jm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1103230905480.4842@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Stefan Roese <stefan.roese@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/FpMuekyPoxjU8c6_4XGY+jm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Mar 2011 09:07:56 +0100 (CET)
Mikael Abrahamsson <swmike@swm.pp.se> wrote:

> On Wed, 23 Mar 2011, Stefan Roese wrote:
>=20
> > I'm currently in the process of converting a 3 disk RAID5 array into a 4
> > disk RAID5 array. I'm using mdadm 3.1.4 and Linux kernel 2.6.35-28-gene=
ric
> > (Ubuntu). My questions now is this conversion save in a live (running)
> > system? Or is this now allowed/supported?
>=20
> I guess you wanted to say "4 disk RAID6 array"?
>=20
> In that case, yes, I have done it on 2.6.32 and mdadm version (something=
=20
> older) and it went just fine.
>=20
> Neil wrote about it here <http://neil.brown.name/blog/20090817000931>.

Additionally, I suggest that you also check "man mdadm" and note the
"--layout=3Dpreserve" option, if you use it, the RAID5 to RAID6 conversion =
while
adding one disk will happen instantly, without restriping (but only with a
resync of the new drive).

--=20
With respect,
Roman

--Sig_/FpMuekyPoxjU8c6_4XGY+jm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2Jq+AACgkQTLKSvz+PZwhpWACeKU/2tlENCjOhZvFNJq+7Z4wl
ZRsAn1VaSqP6D2Ys4+RqQMqdtUmE0Yg+
=8Gqx
-----END PGP SIGNATURE-----

--Sig_/FpMuekyPoxjU8c6_4XGY+jm--
