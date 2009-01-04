From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Fwd: Raid 5 --grow to fewer, larger drives
Date: Sun, 4 Jan 2009 00:25:37 +0000
Message-ID: <20090104002537.GA494@cthulhu.home.robinhill.me.uk>
References: <de6d3ea90901031521va35b7b5uf3050995561592c0@mail.gmail.com> <de6d3ea90901031527x4af0dfcfm28f2d8890698a931@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <de6d3ea90901031527x4af0dfcfm28f2d8890698a931@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat Jan 03, 2009 at 05:27:49PM -0600, Jeff Rippy wrote:

> I too am looking at this.  My current setup is 4x 500GB drives and I
> want to move to 3x  >=3D1TB drives.
> My usable space should increase from 1.5TB to >=3D 2TB with this move if =
possible.
>=20
> I'm fairly new to linux-raid in general but I know you can replace
> drives with bigger ones.  You just can't use their space until all
> drives in the array are of that size.  So I'm thinking of replacing 3
> of the 500's with the 1 TBs.  Then fail and remove the 4th drive
> (assuming enough free space) and somehow forcing a reshape on the
> remaining 3 drives.  Not sure if that is possible but I can't imagine
> why it wouldn't be.  After the resync, finally grow to the new size
> and be done.
>=20
> Can someone tell me if this is even possible?  I saw the one reply in
> Nov. to Alex's email but I don't have another machine to swap the
> disks too.
>=20
This is currently not possible (though it is on the roadmap for future
work).  For now, the only solution is to set up the new disks as a
separate array and copy the data.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklgAgAACgkQShxCyD40xBJRKgCghKTs87prbuAEOEhsKnAg6cyh
UtwAoL/tXY1V3hEA3zlWFzDW+EqRRvKh
=JTJF
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
