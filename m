From: Robin Hill <robin@robinhill.me.uk>
Subject: Re:  Redundancy check using "echo check > sync_action": error
	reporting?
Date: Thu, 20 Mar 2008 16:04:05 +0000
Message-ID: <20080320160405.GC28114@cthulhu.home.robinhill.me.uk>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl> <20080320144549.GB28114@cthulhu.home.robinhill.me.uk> <47E27FB8.1070009@tuxes.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uXxzq0nDebZQVNAZ"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47E27FB8.1070009@tuxes.nl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--uXxzq0nDebZQVNAZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Mar 20, 2008 at 04:16:08PM +0100, Bas van Schaik wrote:

> Maybe I understand something wrong then. In an ideal situation, the
> following should hold:
>  - for RAID5: all data should count up to the parity bit
>  - for RAID1: all bits should be identical
>=20
> If the redundancy check encounters a anomaly, something should be fixed.
> If something should be fixed, clearly something went wrong somewhere in
> the past. Or can you give an example where the statements mentioned
> above don't hold and nothing is wrong?
>=20
My understanding is that, for RAID1 at least (and possibly for any other
mirrored setup), the data is not written to both disks simultaneously,
therefore there's a chance for the data to be modified (in memory)
between writes (or for the check to read the disks between writes).
This is usually only a temporary situation (i.e. the block is due to be
rewritten anyway) but does show up occasionally in checks, particularly
with swap partitions.

> Bottom line: I just want to know if an md check (using "echo check >
> sync_action") encountered any inconsistencies. If so, in my setup that
> would probably mean there is something wrong (bits flipping somewhere
> between md, the bus, the NIC, the network, the NIC of a storage server,
> etc.)
>=20
> I just don't want to be surprised by any major filesystem corruptions
> anymore!
>=20
For this, a simple check for a non-zero value in the
/sys/block/md{X}/md/mismatch_cnt entry will indicate an issue.  Note
that the repair stage only rewrites the parity - there's no way to know
whether the actual error was in the data or parity though, so there may
still be corruption after running a repair.

Cheers,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--uXxzq0nDebZQVNAZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFH4orzShxCyD40xBIRAj+jAKCZs+dP9LHPQzwsyaepkrsYYYBzTACfUQkR
gTxhKMN3cCaDtHUJR8vnnwE=
=yWKe
-----END PGP SIGNATURE-----

--uXxzq0nDebZQVNAZ--
