From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: raid1 on HDD + RAM ?
Date: Tue, 30 Sep 2008 19:21:29 +0100
Message-ID: <20080930182129.GA28669@cthulhu.home.robinhill.me.uk>
References: <20080930174926.5fdad7f1@szpak>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080930174926.5fdad7f1@szpak>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Sep 30, 2008 at 05:49:26PM +0200, Janek Kozicki wrote:

> Hi,
>=20
> It's possible to have a ramdisk device. Would it make any sense in
> doing raid1 using a common HDD and a ramdisk?
>=20
> They would automatically sync on boot-up of the computer.
>=20
> I'm asking because an ultra-fast READ and normal WRITE would be
> useful for me...
>=20
I don't see why it wouldn't be possible.  I would think you'd get the
same performance leaving the RAM for caching though - that way anything
you _are_ actually reading/writing will be cached and the RAM is still
available for applications if needed.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjibikACgkQShxCyD40xBLPVwCfSa1LpmSb4BroFMknZOxy47Y0
c/EAnRH+hmL3lwv/7e43jiX8DDjW4/U8
=19Ay
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
