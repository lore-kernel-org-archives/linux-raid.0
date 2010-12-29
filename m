From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Is It Hopeless?
Date: Wed, 29 Dec 2010 10:34:00 +0500
Message-ID: <20101229103400.286f50c7@natsu>
References: <201012261019.56481.CACook@quantum-sci.com>
	<201012270510.51520.CACook@quantum-sci.com>
	<4D18C0C5.4010606@hardwarefreak.com>
	<201012272016.08050.CACook@quantum-sci.com>
	<4D1AA52A.6010107@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tIETvDl7WkB14g2ezyhpTfc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D1AA52A.6010107@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/tIETvDl7WkB14g2ezyhpTfc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Dec 2010 21:04:10 -0600
Stan Hoeppner <stan@hardwarefreak.com> wrote:

> Carl Cook put forth on 12/27/2010 10:16 PM:
>=20
> > Please try not to worry about me...  I am switching to BTRFS and a back=
up
> > server for my frickin' movies, and will be fine.
>=20
> BTRFS?  You must be pulling our chains.  It's an experimental filesystem
> for Pete's sake.  A month ago it still didn't have a check/repair tool.
>  Does it yet?

AFAIK it does have a check tool, but not a repair tool yet :)

To be fair, it can be argued that if you have a backup [server], this doesn=
't
matter too much.

But personally I find btrfs to be good not for primary storage yet, but for
precisely the mentioned backup storage: its snapshot feature allows to do
(fast) incremental backups, while at the same time have the full state saved
at each backup step instantly accessible with no special software required
(snapshots of older state just sit there looking like plain directories in =
the
filesystem).

--=20
With respect,
Roman

--Sig_/tIETvDl7WkB14g2ezyhpTfc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0ayEgACgkQTLKSvz+PZwhfLACePCODHS80uoxwfgK7yJOZjEjT
iIkAmQGpRS1BkbriGV6j/V4coKZBjLh1
=v4PI
-----END PGP SIGNATURE-----

--Sig_/tIETvDl7WkB14g2ezyhpTfc--
