From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: md RAID1 passes I/O errors to the filesystem despite having
 alive mirrors?
Date: Fri, 15 Mar 2013 12:10:35 +0600
Message-ID: <20130315121035.68a7fae1@natsu>
References: <20130315041054.79eb5dcc@natsu>
	<FCBB3555-81D9-4C7E-87D5-9AFBE20ED529@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rfzCM.byS.pigsFzszxpXbI"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FCBB3555-81D9-4C7E-87D5-9AFBE20ED529@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/rfzCM.byS.pigsFzszxpXbI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Mar 2013 21:43:14 -0600
Chris Murphy <lists@colorremedies.com> wrote:

>=20
> On Mar 14, 2013, at 4:10 PM, Roman Mamedov <rm@romanrm.ru> wrote:
> >=20
> > - shouldn't the reads have been quietly satisfied my md3 from sdf1, ins=
tead of just passing the buck^W error
> >  due to unreadable sdg1 to the higher (filesystem) layer?
>=20
> What distro kernel and version?

Debian Testing, but I use vanilla 3.7.6 kernel, not distro's.

> Since you're not using btrfs raid1 there isn't a second copy maintained b=
y btrfs itself, so it can't fix this. It's reporting a checksum failure for=
 the single copy of data on the md raid1. It is getting the data elsewhere =
but it's btrfs saying that the checksum doesn't match.

So my guess (but that's already something like an accusation and not a foun=
ded
one at the moment :) that maybe mdadm failed to properly get data elsewhere,
and in case of errors it returned something like a zero-filled block, at wh=
ich
btrfs correctly complained?..

Point is, I thought no user of md3 (be it btrfs or not) should have noticed=
 any
errors "below" it, and in my case this turned out not to be the case.

--=20
With respect,
Roman

--Sig_/rfzCM.byS.pigsFzszxpXbI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFCu1sACgkQTLKSvz+PZwj38ACbB5GqjtopSnlelYRCHWqikYbT
JpsAnRIcCM/20qziot9fzQurUJBVNJXs
=VIk0
-----END PGP SIGNATURE-----

--Sig_/rfzCM.byS.pigsFzszxpXbI--
