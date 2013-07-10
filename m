From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Query regarding disk failure
Date: Wed, 10 Jul 2013 14:11:19 +0100
Message-ID: <20130710131119.GA26658@cthulhu.home.robinhill.me.uk>
References: <51DD4EF0.6020509@perpetual-data.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51DD4EF0.6020509@perpetual-data.com>
Sender: linux-raid-owner@vger.kernel.org
To: Priya Kamala <priya.kamala@perpetual-data.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Jul 10, 2013 at 01:09:20PM +0100, Priya Kamala wrote:

> Hi,
>=20
> If a single disk develops bad sector(s) that affects only a single=20
> stripe within a given RAID-5 configuration and these bad sectors are=20
> discovered when running a "check/resync" (echo check >=20
> /sys/block/mdX/md/sync_action), does this result in the entire disk=20
> being removed from the RAID? In other words, is access to the other good=
=20
> stripes on the drive disabled as well? If so, why is it done this way?=20
> In case the kernel version makes a difference to the behaviour, I'm=20
> working with 2.6.21.1.
>=20
If the check/repair process finds a read error, it will trigger a
rewrite of the affected block (rebuilding the data from the other
drives). If the write fails then the disk will be removed from the RAID.
This shouldn't happen, as the disk should either succeed in the write,
or should remap the bad block with one of its spares.

If you're getting repeated problems with this, it's likely that you are
using consumer-level drives without TLER/ERC and have failed to adjust
the kernel timeouts to compensate for this. In this case the rewrite
will be triggered while the disk is still attempting the read process
and will therefore be ignored, causing the write to fail and the disk to
be removed.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iEYEARECAAYFAlHdXXYACgkQShxCyD40xBKGeACdGQWCxjD9oiklPK8LyIKosU5A
A10AoJ7fPALovigsC0h2NWpi5JA82nVm
=erSh
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
