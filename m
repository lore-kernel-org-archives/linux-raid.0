From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: raid10 layout for 2xSSDs
Date: Mon, 16 Nov 2009 16:31:03 +0000
Message-ID: <20091116163102.GB28577@cthulhu.home.robinhill.me.uk>
References: <1258381745.31633.35.camel@localhost>
 <878we61oev.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <878we61oev.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Nov 16, 2009 at 04:26:32PM +0100, Goswin von Brederlow wrote:

> What I'm aiming at is that offset might better fit into erase blocks,
> cause less internal fragmentation on the disk and give better wear
> leveling. Might improve speed and lifetime. But that is just a
> thought. Maybe test and do ask Intel (or other vendors) about it.
>=20
I very much doubt this will make any difference.  With SSDs you have to
throw out any preconceptions of internal layout you may have.  You have
absolutely no idea (or control of) where two consecutive blocks will
actually get written.  Fragmentation and seek time are thus irrelevant
(or uncontrollable anyway).

I don't see how any RAID-10 layout would perform better than another
with SSDs, unless there's internal optimisations/constraints which
affect sequential reading from multiple devices.  I'm not aware of any
though - RAID-10 n2 may be the same layout as RAID-1 but it's an
entirely separate piece of code.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAksBfkYACgkQShxCyD40xBKHUgCdE7ii6ln9YPiKvh7JC5ZVfUGB
qLQAoMZeFGZWVpiq5j6KKT3sBX1Zu4lX
=Y5OO
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
