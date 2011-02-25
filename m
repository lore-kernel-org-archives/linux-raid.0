From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: auto-read-only question
Date: Fri, 25 Feb 2011 16:26:32 +0000
Message-ID: <20110225162632.GD11345@cthulhu.home.robinhill.me.uk>
References: <4D67D3D4.9040306@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D67D3D4.9040306@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Feb 25, 2011 at 05:07:48PM +0100, Albert Pauw wrote:

>   Can anybody explain to me what "active (auto-read-only)" mean in=20
> /proc/mdstats?
>=20
When the array is assembled, it's set in "auto-read-only" mode. As soon
as anything tries to write to it, it gets set to normal write mode (or
you can trigger this manually by doing "mdadm -w" on the array). I'm not
sure why this is done - possibly it make it simpler for md to skip
running various internal processes on that array (as it knows that the
array isn't being dirtied).

I usually see this with swap arrays - most filesystems will immediately
open the array in read/write mode, so trigger the switch.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk1n2DYACgkQShxCyD40xBKeIwCcDx2irjuEHp8NI/Qf5v7GVX+b
lGIAoIegB8J/wgDEYByU2XmEy/dxnA3P
=4I25
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
