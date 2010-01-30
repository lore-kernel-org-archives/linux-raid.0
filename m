From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: raid10 How do I tell what side of the mirror a disk is on?
Date: Sat, 30 Jan 2010 11:01:09 +0000
Message-ID: <20100130110109.GA14000@cthulhu.home.robinhill.me.uk>
References: <1264777247.29409.64.camel@thor>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1264777247.29409.64.camel@thor>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Jan 29, 2010 at 10:00:47AM -0500, Rick Bragg wrote:

> Another puzzle is with raid10, there are 2 used in a stripe, then that
> stripe is mirrored with the other 2.  My question is how can I tell
> "what 2 disks can fail?"  In other words, how can I tell for example if
> sda and b are stiped? and that c and d are a mirror of a and b?  How can
> I see what is happening with that?  Is there a way to tell? =20
>=20
Reading the RAID10 documentation (man md, or check Wikipedia), with
four disks the adjacent disks should always contain the same data.  So
for sda, sdb, sdc, sdd (in that order in the array), you can lose one of
sda/sdb and one of sdc/sdd.  This holds for any layout (near, far or
offset) with the default 2 copies.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAktkEXQACgkQShxCyD40xBKbYQCfSBmQmowHPXKo7u/EjEHFSWVI
AqUAn0wLdM1WBMkMKZQ4KH1HvseY6fVZ
=+Im/
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
