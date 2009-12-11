From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID 5 build time optimization question and experiments.
Date: Fri, 11 Dec 2009 15:29:38 +0000
Message-ID: <20091211152938.GA5857@cthulhu.home.robinhill.me.uk>
References: <ad15b8920912110655k62c8b6ber8b366731cf1e85f3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ad15b8920912110655k62c8b6ber8b366731cf1e85f3@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Dec 11, 2009 at 02:55:31PM +0000, Cat'Killer wrote:

> I found a way using Doug Gilbert's great sg3utils to zero all these
> disks in a very efficient manner, using sgp_dd, at near drive
> bandwidth, and proceeded to zero all the disks fully in about 4 hours!
>=20
> Once done, I then created a RAID 5 on 10 disks, waited for the rebuild
> to complete, stopped the array using mdadm, and dumped each of the
> RAID's components superblocks to files.
>=20
<-snip->
> The create worked fine and I waited for the rebuild to be complete
> before stopping the array and dumping the SBs.
>=20
> I then proceeded to write these same superblocks to 10 new similar
> disks in a different system.
>
You could just do the create with --assume-clean, which should take very
little time at all.  If the drives were zeroed initially then this will
give you valid parity data.

Cheers,
    Robin

--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAksiZWEACgkQShxCyD40xBJygQCfVmvQxuJX0oD21LnJLjO3VKze
xC4AnibaRJPNz/1nuUmYl08V7LrhjWPi
=KzQ4
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
