From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: adding a missing drive(s), which drives get written to?
Date: Tue, 10 Dec 2013 08:59:20 +0000
Message-ID: <20131210085920.GB441@cthulhu.home.robinhill.me.uk>
References: <BLU0-SMTP144CE5F6040BC17EDAE8A9E98D30@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1UWUbFP1cBYEclgG"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BLU0-SMTP144CE5F6040BC17EDAE8A9E98D30@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Wilson Jonathan <piercing_male@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Dec 09, 2013 at 02:09:11PM +0000, Wilson Jonathan wrote:

> After recovering from a failed raid6, now running with 2 missing drives
> and soon to be finally backed up (is still backing up), I have 2 related
> questions...
>=20
> The first is, can I add in both drives at the same time, or do I need to
> add them in singly, just checking for clarity?
>=20
You can add both together. Older versions of mdadm would kick off the
rebuild before the addition of both disks had been completed though, so
you might want to freeze the array first:

 echo freeze > /sys/block/md0/md/sync_action                               =
    =20
 mdadm /dev/md0 --add /dev/foo /dev/bar                                    =
    =20
 echo idle > /sys/block/md0/md/sync_action                                 =
    =20

> The second question is far more important... during the re-creation of
> data on the newly added missing disk/partition(s) does mdadm just read
> the data from the original array and write to the new disk(s) or does it
> potentially write new/update existing data (excluding bitmap/superblock)
> to the existing disks.
>=20
The rebuild process will only write data to the new disks. The only
cases where data will be written to the old disks during a rebuild is if
a read error is triggered and the data has to be reconstructed (not
applicable in your case as you have no redundancy to rebuild the data
=66rom in the case of a read error), or if new data is written to the
array.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--1UWUbFP1cBYEclgG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlKm1+cACgkQShxCyD40xBLb/ACfamfUSoW0Inn8FafAxYBOVnO2
49kAoNpM/BGbTtDOTb16fZ3qwzfoiD92
=gVvV
-----END PGP SIGNATURE-----

--1UWUbFP1cBYEclgG--
