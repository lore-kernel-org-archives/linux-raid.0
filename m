From: Andy Smith <andy@lug.org.uk>
Subject: Re: RAID1: What happens when one half of a mirror fails?
Date: Wed, 27 Jul 2005 10:07:10 +0000
Message-ID: <20050727100710.GL6594@strugglers.net>
References: <200506301024.13126.eric@pretorious.net> <42C44210.7010204@gw.unix-scripts.info> <200506301215.39271.eric@pretorious.net> <42C44DD6.5060901@weisshuhn.de> <1122438610.28969.201.camel@seki.nac.uci.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8f0Rp8CLSOFvlIcd"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1122438610.28969.201.camel@seki.nac.uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--8f0Rp8CLSOFvlIcd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 26, 2005 at 09:30:09PM -0700, Dan Stromberg wrote:
> If a little downtime is no big deal, and you could use a little extra
> disk space, then sure, don't mirror swap.
>=20
> If downtime is more important than the loss of a little disk space, then
> do mirror swap.
>=20
> Before you say that disk is always cheaper than downtime, recall that
> sometimes there'll be a layer of bureaucracy between you and the
> purchase of a new disk.

But in that case if you mirror swap then you can have the pleasure
of working through the bureaucracy while the server is still up. :)

--8f0Rp8CLSOFvlIcd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC51zOIJm2TL8VSQsRAvHxAKCSiTNh7GHPeG4RoDMbaEdxmNS6BACfSodT
Y15lXAF5Y+B2Oz9HFMK1uq0=
=uPcU
-----END PGP SIGNATURE-----

--8f0Rp8CLSOFvlIcd--
