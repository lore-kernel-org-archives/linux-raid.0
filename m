From: Robin Hill <robin.hill47@ntlworld.com>
Subject: Re: RAID1 question
Date: Thu, 29 Sep 2011 20:26:11 +0100
Message-ID: <20110929192611.GA23316@cthulhu.home.robinhill.me.uk>
References: <20110929183457.GA19871@electro-mechanical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110929183457.GA19871@electro-mechanical.com>
Sender: linux-raid-owner@vger.kernel.org
To: William Thompson <wt@electro-mechanical.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Sep 29, 2011 at 02:34:57PM -0400, William Thompson wrote:

> Please keep me in the CC.  I am not on the list.
>=20
> If I have a RAID1 of 2 disks and I decide to move them to another computer
> and recreate the raid, does it really need to do the initial recovery?
>=20
You don't need to recreate the raid at all, just reassemble it. You may
want to update the homehost though, otherwise it will (IIRC) auto
assemble to md_126 (or so) instead of md0.

> For that matter, when creating a RAID1 on 2 disks, is it really needed to=
 do
> the initial recovery?
>=20
> I understand why it's needed for RAID4/5/6 though.
>
Probably not, no. Anything written would go to both mirrors, and reads
of any un-mirrored areas are indeterminate anyway. You would lose the
ability to check the array for mismatches though, and the recovery
process would bring everything into sync whenever it's run anyway. More
of a question would be why not do the initial recovery? It doesn't delay
access to the array, and at least the I/O load is happening at a
controlled point (rather than at recovery time, when you have no
control). Anyway, if you do want to avoid the initial recovery, just use
--assume-clean.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk6ExlIACgkQShxCyD40xBIwXgCfSXIXF901jDogHWm5poRGBQR+
PcUAniWH6HAtxH4oDCCZ1iCfEvg0+cE0
=ILwK
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
