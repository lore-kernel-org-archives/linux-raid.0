From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: freshly grown array shrinks after first reboot - major data loss
Date: Thu, 1 Sep 2011 18:03:36 +0100
Message-ID: <20110901170336.GB22274@cthulhu.home.robinhill.me.uk>
References: <4E5FA4B5.6010407@macroscoop.nl>
 <4E5FAEF3.60501@macroscoop.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rJwd6BRFiFCcLxzm"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E5FAEF3.60501@macroscoop.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Sep 01, 2011 at 06:12:35PM +0200, Pim Zandbergen wrote:

> On 09/01/2011 05:28 PM, Pim Zandbergen wrote:
> >
> >
> > What should I do to find the cause?
>=20
> Additional information:
>=20
> Both the original 2TB drives as well as the new 3TB drives were GPT
> formatted with partition type FD00
>=20
> This is information about the currently shrunk array:
>=20
>=20
> # mdadm --detail  /dev/md0
> /dev/md0:
>          Version : 0.90
>    Creation Time : Wed Feb  8 23:22:15 2006
>       Raid Level : raid5
>=20
Looks like there's a bug somewhere. The documentation says that 0.90
metadata doesn't support >2TB components for RAID levels 1 and above.
If this is still correct, mdadm should have prevented you growing the
array in the first place.

I'd suggest recreating the array with 1.x metadata instead and checking
whether that runs into the same issue.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--rJwd6BRFiFCcLxzm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5fuucACgkQShxCyD40xBJ86gCeN4O1u+LxQgCJSso/sS9h7Q+1
nfwAnRQm3M+FmbmvHetlNbwy82pWP0Bt
=Lg4n
-----END PGP SIGNATURE-----

--rJwd6BRFiFCcLxzm--
