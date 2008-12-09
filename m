From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Data integrity and RAID
Date: Tue, 9 Dec 2008 14:41:32 +0000
Message-ID: <20081209144132.GA24906@cthulhu.home.robinhill.me.uk>
References: <20841008.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20841008.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Dec 09, 2008 at 06:02:57AM -0800, peter.stevens wrote:

>=20
> I'm looking for a software solution to help replace my existing raid hard=
ware
> setup. The hardware mimics RAID-1 (in that it has 3 mirrors), except for =
the
> fact that on read all 3 mirrors are compared and possibly error corrected
> before data is returned. I don't neccessarily need a RAID-1 solution, it
> just seems closer to what I already have and also that it also can recover
> from 2 simulateous disk failures.=20
>=20
> So far I've played with a software RAID-1 array of USB flash drives. My
> issue is that software RAID-1 does not check for or recover from data
> corruption unless a read or write to disk actually fails. Integrity is a
> major concern for me, I need to know that all data going to and from disk=
 is
> correct at all times.
>=20
> All advice and comments are welcomed.
>=20
I'm not aware of anything, no.  Software RAID-1 will do some of what
you're after but doesn't verify reads against all drives (this doesn't
guarantee integrity anyway, only reduce the chance of an error).  You
can run regular checks of the drives to detect (and repair) any
data mismatches though.

Mind you, to do this properly, you'd need to disable write caching on
all drives; do a read of all drives after every write (to verify that
the write was successful); and compare all drives on every read (to
verify that the read was successful).  You probably also want checksums
on the drives to help detect which drive(s) are incorrect on read
mismatches as well (I believe there's now a standard for doing this, but
I don't think it's supported end-to-end yet). Doing all this will really
limit performance though - generally you'll be better off building error
recovery into the file format instead.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkk+g5wACgkQShxCyD40xBLwQwCfR6oWOX/CoROMqglq1P1CKplt
1wIAoKANqEQpJh2PlGMUj+WKXu/ZvkcW
=uDrq
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
