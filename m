From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: help with bad performing raid6
Date: Mon, 27 Jul 2009 21:01:50 +0100
Message-ID: <20090727200150.GA3764@cthulhu.home.robinhill.me.uk>
References: <cccedfc60907271219n1f3431c4w50033d4f5bc43edc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cccedfc60907271219n1f3431c4w50033d4f5bc43edc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Jul 27, 2009 at 02:19:42PM -0500, Jon Nelson wrote:

> I have a raid6 which is exposed via LVM (and parts of which are, in
> turn, exposed via NFS) and I'm having some really bad performance
> issues, primarily with large files. I'm not sure where the blame lies.
> When performance is bad "load" on the server is insanely high even
> though it's not doing anything except for the raid6 (it's otherwise
> quiescent) and NFS (to typically just one client).
>=20
Have you checked dmesg for disk errors?  I've had similar slowdowns when
there's a bad block on the drive - it's sitting waiting for the retries
to timeout (or the bus to reset) and the read to fail.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkpuB60ACgkQShxCyD40xBI09wCePxqGaJjGamoyLG5PB9OrowDp
JUgAnRDqhPpdQWunF7HXGULRMHv9vRnk
=YXsw
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
