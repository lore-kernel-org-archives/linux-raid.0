From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: RAID1: What happens when one half of a mirror fails?
Date: Tue, 26 Jul 2005 21:30:09 -0700
Message-ID: <1122438610.28969.201.camel@seki.nac.uci.edu>
References: <200506301024.13126.eric@pretorious.net>
	 <42C44210.7010204@gw.unix-scripts.info>
	 <200506301215.39271.eric@pretorious.net>  <42C44DD6.5060901@weisshuhn.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1IzMlq6vVuKT7mJb4pWY"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42C44DD6.5060901@weisshuhn.de>
Sender: linux-raid-owner@vger.kernel.org
To: Frank Wittig <fw@weisshuhn.de>
Cc: eric@pretorious.net, Laurent CARON <lcaron@gw.unix-scripts.info>, linux-raid@vger.kernel.org, strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids


--=-1IzMlq6vVuKT7mJb4pWY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2005-06-30 at 21:53 +0200, Frank Wittig wrote:
> Eric Pretorious wrote:
> > On Thursday 30 June 2005 12:03 pm, Laurent CARON wrote:
> >=20
> >>is the swap partition on raid?
> >=20
> >=20
> > No. swap both swap partitions are formatted as standard swap partitions=
 and mounted via /etc/fstab.
> >=20
>=20
> That's no good idea. If a disk fails which contains a swap partition to
> which data has been swapped the system will crash.
> Therefor it is important to use mirrored partitions for swap.

This is totally specific to the usage of the machine you're doing the
mirroring on: the relative importance of loss of disk space vs downtime.

If a little downtime is no big deal, and you could use a little extra
disk space, then sure, don't mirror swap.

If downtime is more important than the loss of a little disk space, then
do mirror swap.

Before you say that disk is always cheaper than downtime, recall that
sometimes there'll be a layer of bureaucracy between you and the
purchase of a new disk.


--=-1IzMlq6vVuKT7mJb4pWY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBC5w3Ro0feVm00f/8RAoX1AJ9Xp4Dr+6sNbn8yim597vqoz1S63gCdE47T
eXxAz0A49uTs+44TH41ipnI=
=3PiA
-----END PGP SIGNATURE-----

--=-1IzMlq6vVuKT7mJb4pWY--

