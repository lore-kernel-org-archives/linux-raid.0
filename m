From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: raid1 issue after disk failure: both disks of the array are
 still active
Date: Fri, 14 Sep 2012 19:27:55 +0100
Message-ID: <20120914182755.GA2534@cthulhu.home.robinhill.me.uk>
References: <5051AF17.8010501@linuxsystems.it>
 <20120913103432.GA11764@cthulhu.home.robinhill.me.uk>
 <B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com>
 <alpine.DEB.2.00.1209140912350.13902@uplift.swm.pp.se>
 <5052E096.5040509@linuxsystems.it>
 <45F26B36-1890-4F8E-BDF9-0DB49FDEE922@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45F26B36-1890-4F8E-BDF9-0DB49FDEE922@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Sep 14, 2012 at 12:04:56 -0600, Chris Murphy wrote:

>=20
> On Sep 14, 2012, at 1:45 AM, Niccol=F2 Belli wrote:
>=20
> > I also would like to know if the raid1 will *surely* use data from
> > the other disk to write on the broken sector after a CHECK.
>=20
> Not according to documentation. In normal operation, and for a repair,
> what you describe is correct. But not for check.
>=20
Maybe you need to reread the documentation. The md manual page says:

    Requesting a scrub will cause md to read every block on every device
    in the array, and check that the data is consistent. For RAID1 and
    RAID10, this means checking that the copies are identical. For
    RAID4, RAID5, RAID6 this means checking that the parity block is (or
    blocks are) correct.

    If a read error is detected during this process, the normal
    read-error handling causes correct data to be found from other
    devices and to be written back to the faulty device. In many case
    this will effectively fix the bad block.

So a check will repair cases where the data cannot be read at all, but
will not repair cases where the data is returned but does not match the
data on the other mirror(s).

> > I read that when raid1 is in doubt there is a 50%-50% chance it uses
> > data from the good disk, wouldn't be better to fail the broken disk
> > and then re-add it to the array?
>=20
> I don't know what this means.
>=20
I assume he's referring to cases where the data is read successfully but
does not match the data on the mirror(s). In this case a repair will
cause one copy to overwrite the others, which may or may not be the
correct copy (md has no way of knowing for a mirrored pair).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlBTdysACgkQShxCyD40xBK/BACfdd4wMag3kaKVhjam4BxedMzA
0JkAnRQpoYTdk0+EAqIycb486V45UUQA
=ldow
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
