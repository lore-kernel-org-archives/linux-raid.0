From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Anything left to try?
Date: Thu, 2 May 2013 15:58:29 +0100
Message-ID: <20130502145829.GB18405@cthulhu.home.robinhill.me.uk>
References: <CAPSPcXjFQ9zDP9ZK8X3uZXHNKot5hS=0iwj04E_FrNa2Z8n++A@mail.gmail.com>
 <C480F6221151144EA453A5C89300815601403A74@MBOX1.ds.sbdhi.com>
 <CAPSPcXhS2O8ASH8Gsz8KE=oJp6y1K6VTi7Jf-=39uzNzG3SnJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPSPcXhS2O8ASH8Gsz8KE=oJp6y1K6VTi7Jf-=39uzNzG3SnJQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu May 02, 2013 at 09:26:55AM -0500, Barrett Lewis wrote:

> That is a really good idea.  At minimum I will ddrescue the failed drives.
> But even if I do that, is there a way to reassemble the array (even with
> new drives) now that those components are marked failed?
>=20
Yes, "mdadm -Af /dev/mdX" should reassemble the array, making use of the
best set of drives available to get the array running - i.e. all the
working drives plus the most-recently failed drive(s). It'll still be in
a degraded state, but hopefully you can then get the other disk added
(though you'll still have to keep your fingers crossed that there's no
read error of any kind during the several days required to rebuild a 4T
drive).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlGCfxMACgkQShxCyD40xBJTuwCfT7Jq0HkDoNFD7bU3EnyXclXR
dVkAoNZ87htNFQ05dlFrGTpq9yZCZvS3
=v4ce
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
