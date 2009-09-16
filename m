From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Re-map disk sectors in userspace when rewriting after read
 errors
Date: Wed, 16 Sep 2009 11:00:23 +0100
Message-ID: <20090916100022.GA15413@cthulhu.home.robinhill.me.uk>
References: <h8nbt5$n8p$1@ger.gmane.org>
 <70ed7c3e0909150340q4ae91cb1j7eaae473c6d94c9a@mail.gmail.com>
 <h8nrkn$n8p$5@ger.gmane.org>
 <70ed7c3e0909150403s4db60837gfd742d5f6960adf0@mail.gmail.com>
 <70ed7c3e0909151002y5f4690b1j26d33dc297af7795@mail.gmail.com>
 <1253037953.7774.131.camel@kiste>
 <70ed7c3e0909151114q7296314du77de369f5e4ea695@mail.gmail.com>
 <1253040282.7774.149.camel@kiste>
 <70ed7c3e0909160231l4e424ff3y4d4615ebb87c0e82@mail.gmail.com>
 <1253094266.6394.5.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1253094266.6394.5.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Sep 16, 2009 at 11:44:26AM +0200, Matthias Urlichs wrote:

> On Wed, 2009-09-16 at 12:31 +0300, Majed B. wrote:
> > I have a question which would probably sound stupid: If I have a bad
> > blocks output file from dd_rescue, can I reconstruct a bad sector's
> > data by reading the same sector from all disks (using dd if=3D/dev/sdx
> > of=3D./bbfix_#number bs=3D512 count=3D1 skip=3Dbb_number-1), then run an
> > normal XOR operation, write zeros to the bad block to force sector
> > remap, then dd the XOR output to the said sector?
>=20
> Well, of course. Assuming that the disk's sector remap works, which was
> my problem, and that we're talking about RAID5.
>=20
And also assuming that the array starts from the same sector of each
disk.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqwtzUACgkQShxCyD40xBKeQACgvQV5XwZNLOhp1jVaYJlaj8DX
y1sAnjNgYyOgp7pSUHJSQsoUo16nwKoT
=BPxQ
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
