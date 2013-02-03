From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID5 with 2 drive failure at the same time
Date: Sun, 3 Feb 2013 21:59:35 +0000
Message-ID: <20130203215934.GB18805@cthulhu.home.robinhill.me.uk>
References: <20130131221007.GA1447@cthulhu.home.robinhill.me.uk>
 <88758108-9333-4224-9006-8E44E717AB29@colorremedies.com>
 <20130201133455.GA24375@cthulhu.home.robinhill.me.uk>
 <9F0E4AF3-4358-425F-8078-C068D5BB9487@colorremedies.com>
 <20130201195734.GA16573@cthulhu.home.robinhill.me.uk>
 <510C5E3F.8090807@evilazrael.de>
 <510C6AB6.8040900@turmel.org>
 <510D36D7.5050704@evilazrael.de>
 <510DBBB9.5030300@turmel.org>
 <510E88B3.8050505@evilazrael.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <510E88B3.8050505@evilazrael.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Nelles <evilazrael@evilazrael.de>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun Feb 03, 2013 at 04:56:35 +0100, Christoph Nelles wrote:

> Hi folks,
>=20
> the dd_rescue to the new HDD took 14hours. It looks like ddrescue is not
> reading and writing in parallel. In the end 8kb couldn't be read after
> 10 retries.
>=20
Note that there's a difference between dd_rescue and ddrescue. GNU
ddrescue seems to be the better option nowadays,

> I just force-assembled the RAID with the new drive, but it failed almost
> immediately with an WRITE FPDMA QUEUED error on one of the other drives
> (sdj, formerly sdi). I tried immediately again, an this time one disk
> was rejected but the RAID started on 8 devices, but xfs_repair failed
> when one of the disks failed with an READ FPDMA QUEUED error :( and md
> expelled the disk from the RAID.
>=20
> It looks more like a controller problem as all the messages comming from
> the drives on the PCIe Marvell have all the line
> ataXX: illegal qc_active transition (00000002->00000003)
> I found only one similar report about that problem:
> http://marc.info/?l=3Dlinux-ide&m=3D131475722021117
>=20
> Any recommendations for a decent and affordable SATA Controller with at
> least 4 ports and faster than PCIe x1? Looks like there are only
> Marvells and more expensive Enterprise RAID controllers.
>=20

I can recommend the Intel RS2WC080 (or any other LSI SAS2008 based
controller). Quite frankly, any SAS controller is almost certainly
going to be better than the SATA equivalent (and for not a huge amount
more), while still supporting standard SATA drives.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEO3cYACgkQShxCyD40xBJrVQCg4irFPJoKXi0bT9jhBXc6t5h4
B6sAmwWmvb+GD+24OSzT+3Hy1pMJLZMc
=IBUY
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
