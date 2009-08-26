From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Raid 5 - not clean and then a failure.
Date: Wed, 26 Aug 2009 15:33:16 +0100
Message-ID: <20090826143315.GA9995@cthulhu.home.robinhill.me.uk>
References: <15771.7292.qm@web51312.mail.re2.yahoo.com> <87hbvu9626.fsf@frosties.localdomain> <7d86ddb90908260714j4ddc6b56w580b511bdcf12491@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7d86ddb90908260714j4ddc6b56w580b511bdcf12491@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Aug 26, 2009 at 10:14:31AM -0400, Ryan Wagoner wrote:

> Wouldn't weekly RAID consistency checks reveal a bad block before you
> had a failure that required the need to do a full resync? It only
> takes 3 hours to resync my 3 x 1TB drives and having a bitmap would
> reduce the performance. I've never had to have a resync in the year
> I've had the array up. I just wonder if the performance drawback is
> worth having the bitmap to save a possible resync once every couple
> years. Or are the RAID consistency checks not reliable enough to
> prevent more errors during a resync?
>=20
If your system is that stable, then bitmaps will be a waste of time for
you.  A lot of people have hardware/software issues which cause drives
to be kicked out of arrays occasionally, or arrays to fail to shut down
cleanly.  A bitmap will save time when adding the drive back into the
array in these cases.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqVR6sACgkQShxCyD40xBI+IACdHR3MbuV02/TFAR6dupM9SmP5
BakAnjssqcLEWOqjGbDVZzGnPK+Ydxth
=qLRA
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
