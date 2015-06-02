From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: self healing of MD raid
Date: Tue, 2 Jun 2015 18:53:39 +0100
Message-ID: <20150602175339.GA20741@cthulhu.home.robinhill.me.uk>
References: <20150602172236.GA23446@www5.open-std.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150602172236.GA23446@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Jun 02, 2015 at 07:22:36PM +0200, keld@keldix.com wrote:

> Hi list
>=20
> I wonder if MD RAID software is kind of self healing.
> That is, if a read operation gets an IO error, then the logical
> sector of the RAID can be recreated from the other sector(s)
> of the raid, and then written out on the block which gave a read error.
>=20
> His could work both for the mirrored RAID types, and for the
> parity orientet RAID types.
>=20
> Is that implemented in MD RAID?
>=20
> Similarily the self healing process could be part of the monitoring
> background processes.
>=20
> Best regaqrds
> keld

Yes, this is implemented as standard for all forms of RAID with
redundant data (parity/mirror). A read error will automatically trigger
a rewrite of the faulty block with data recovered from the other
members. This rewrite should also trigger a remapping within the drive
if the original block proves to be unwritable as well.

Running a regular check (echo check > /sys/block/mdX/md/sync_action)
will do a full read of all active members in an array and therefore
trigger rewrites for any unreadable blocks. This is often set up as part
of the standard distro cron jobs, but should be set up manually if not.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlVt7aIACgkQShxCyD40xBLoSACePYZux+d8E6AscuRIleRjFrIZ
dDsAnjKkjcHHBVxmSaepHWBJwYZYFuEC
=Vb7r
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
