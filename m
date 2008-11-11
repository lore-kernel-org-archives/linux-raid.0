From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: How about reversed (or offset) disk components?
Date: Tue, 11 Nov 2008 19:02:00 +0000
Message-ID: <20081111190200.GA27786@cthulhu.home.robinhill.me.uk>
References: <43d009740811111040x5e610582n9f9bd4354682ca16@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43d009740811111040x5e610582n9f9bd4354682ca16@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Nov 12, 2008 at 01:40:52AM +0700, Igor Podlesny wrote:

> 	Hi!
>=20
> 	And I have one more idea: How about reversed (or offset) disk
> components? -- It's known that linear read speed is decreasing when
> reading from the beginning to end of HDD, thus leading to situation
> when reading from RAID is good at its beginning and rather poor at its
> ending. My suggestion (possibly) would make that speed almost constant
> in despite of reading position. Examples:
> =09
> 	RAID5:
>=20
> 	disk1: 0123456789
> 	disk2: 3456789012
> 	disk3: 6789012345
>=20
> 	i. .e, the disk1's chunks aren't offseted at all, and disks' 2 and 3 are.
> =09
> 	RAID0:
> =09
> 	disk1: 0123456789
> 	disk2: 9876543210
>=20
> 	Any drawbacks?
>=20
This is already implemented for RAID-10 (using 'far' copies).  I don't
see it making any sense for RAID-5 or RAID-0 though - you need to read
=66rom multiple disks anyway, so you're always going to be waiting for the
slowest one.  In fact, it's more likely to be a handicap as you'll
effectively be multiplying the slow read points.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--huq684BweRXVnRxX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkZ1qcACgkQShxCyD40xBKETgCeNkN51jetG1RIOSxf6BDhn/MJ
PO4An1vTBGHSxFlRGFjtAnuLsPHgVGuK
=GhlY
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
