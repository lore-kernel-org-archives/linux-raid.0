From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Issue removing failed drive and re adding on raid 6
Date: Sun, 5 Jul 2015 15:27:09 +0500
Message-ID: <20150705152709.43d2f9c6@natsu>
References: <emfb4b5aee-68ba-4089-a763-4e835afefc45@littlez>
	<5597922A.90402@youngman.org.uk>
	<alpine.DEB.2.02.1507041009040.11810@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kXqfB=ixe_QmA/FsHS/i.gX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1507041009040.11810@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kXqfB=ixe_QmA/FsHS/i.gX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 4 Jul 2015 10:10:46 +0200 (CEST)
Mikael Abrahamsson <swmike@swm.pp.se> wrote:

> > Are these 3TB Seagate Barracudas? (Same as mine). You DO NOT want to be
> > running raid 5 or 6 on these things !!!! They're desktop drives not
> > meant for raid.
>=20
> Not only that, but they're known to have en extremely high failure rate:
>=20
> https://www.backblaze.com/blog/3tb-hard-drive-failure/
>=20
> "As of March 31, 2015, 1,423 of the 4,829 deployed Seagate 3TB drives had=
=20
> failed, that=E2=80=99s 29.5% of the drives."

And the cause is... http://habrahabr.ru/post/251941/
(Use Google Translate if you have to, or just look at the pictures)

An unfortunate hardware design flaw, leading to dust from the outside
eventually getting into the drive's platter area, and then starting to chip
away ferromagnetic particles from the actual platters.

--=20
With respect,
Roman

--Sig_/kXqfB=ixe_QmA/FsHS/i.gX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlWZBn0ACgkQTLKSvz+PZwgiOwCfc4f95mPBUHXYmF+9qsStpi9c
CwsAn3JxbDfVakAO8Q4HQDQxxp8WbYht
=fVAv
-----END PGP SIGNATURE-----

--Sig_/kXqfB=ixe_QmA/FsHS/i.gX--
