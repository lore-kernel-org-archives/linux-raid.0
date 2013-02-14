From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Possible to rescue SW Raid5 with 2 missing Disks
Date: Thu, 14 Feb 2013 21:11:22 +0000
Message-ID: <20130214211121.GA11925@cthulhu.home.robinhill.me.uk>
References: <20130214210029.203940@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130214210029.203940@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dragon <Sunghost@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Feb 14, 2013 at 10:00:29 +0100, Dragon wrote:

> Hello,
>=20
> the 40TB are in an filecluster and this machine is part of this. the
> system consists of 6x3tb in sw raid5. there are four partions on each
> machine. one with 100mb for the efi bios, one for the os in raid1, one
> for the swap in raid5 and one for the files in raid5. the machine was
> opened and the disk layed beside, i moved two disks slightly and in
> this moment both spinded for a second down and the raid was gone.
> there was no filetransfer but the raid couldnt rebuild because of
> missing two disks.
>=20
The standard option to try is a forced assembly - "mdadm -Af /dev/mdX"

If that fails, then please retry with "-vv" as well and post both the
output from the command and the dmesg output.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEdUvkACgkQShxCyD40xBJuswCfcAZ4uqs1s1RFZ/RDhF+e9uz0
FIAAoNWQ2mmieJYMyW2wqlVs3SFYafzo
=1GWw
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
