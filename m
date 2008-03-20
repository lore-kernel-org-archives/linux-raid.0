From: Robin Hill <robin@robinhill.me.uk>
Subject: Re:  Redundancy check using "echo check > sync_action": error
	reporting?
Date: Thu, 20 Mar 2008 13:47:47 +0000
Message-ID: <20080320134747.GA28114@cthulhu.home.robinhill.me.uk>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47E26775.3000500@tuxes.nl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Mar 20, 2008 at 02:32:37PM +0100, Bas van Schaik wrote:

> Anyone able to answer the last and most important question: does it
> produce a message during resync in case of corruption? That would be grea=
t!
>=20
There's no explicit message produced by the md module, no.  You need to
check the /sys/block/md{X}/md/mismatch_cnt entry to find out how many
mismatches there are.  Similarly, following a repair this will indicate
how many mismatches it thinks have been fixed (by updating the parity
block to match the data blocks).

I've no idea whether the checkarray script you're using is checking this
counter - there seems little point in having a special script if it
isn't though.

Cheers,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFH4msDShxCyD40xBIRAizJAJ4uJWG2XYkzFI6NYnTyMoQWqnd+rwCfTceL
CLHTSvoWLLy2BZGaLaj1Du8=
=XZJH
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
