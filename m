From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Setting up md-raid5: observations, errors, questions
Date: Sun, 2 Mar 2008 13:48:36 +0000
Message-ID: <20080302134836.GB20333@cthulhu.home.robinhill.me.uk>
References: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun Mar 02, 2008 at 01:23:32PM +0100, Christian Pernegger wrote:

> Tried creating a filesystem:
>=20
> mke2fs -E stride=3D256 -j -L tb-storage -m1 -T largfile4 /dev/md0
>=20
> That was glacially slow, "writing inode tables" went up about 3-4/sec
> (22357 total). Since I had forgotten the crypto layer anyway I
> CTRL-Ced that attempt and added it:
>=20
> [exact command unavailable, see below. Used 2048 (512byte sectors) for
> LUKS payload alignment, which should land on it chunk boundaries]
>=20
> OK. Back to the fs again, same command, different device. Still
> glacially slow (and still running), only now the whole box is at a
> standstill, too. cat /proc/cpuinfo takes about 3 minutes (!) to
> complete, I'm still waiting for top to launch (15min and counting).
> I'll leave mke2fs running for now ...
>=20
Have you tried rebooting?  I have (sporadically) the same issue - I/O
just slows to a crawl and it's impossible to get anything done.  After
rebooting I receive an email notification of a SMART error (so it looks
like there's some ridiculous timeout period somewhere) and everything
works fine again.  Anyway, I've now disabled the background SMART
offline testing (they always seemed to coincide with the problem) and
haven't had a problem since - it's only been a month though so rather
early to be certain.

Cheers,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHyrA0ShxCyD40xBIRAjKvAKDM+Qw43coOxebDIhs2Fe40g16UpACfa8c3
lO8arlqFd3jRM1EqQ/LPxog=
=p4ku
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
