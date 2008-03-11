From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Online resize
Date: Tue, 11 Mar 2008 11:12:19 +0000
Message-ID: <20080311111219.GA2086@cthulhu.home.robinhill.me.uk>
References: <200803111119.56015.wayne@flashmedia.co.za>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200803111119.56015.wayne@flashmedia.co.za>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Mar 11, 2008 at 11:19:55AM +0200, Wayne Gemmell wrote:

> Hi all
>=20
> I'd like to do an online resize for my RAID5 drives now that I've upgrade=
d=20
> them to 500GB drives. Now I'm a bit stuck. I assume the steps would be th=
e=20
> following.
>=20
> 1) Resize partitions
> 2) Drop EXT3 journal
> 3) run e2resize
> 4) Recreate journal.
>=20
> Are there any raid specific things I have to do to get this to work. Am I=
 on=20
> the right track?
>=20
Sort of.  The steps you'll need are:

 1) Resize partitions (usually a drop & recreate step - this doesn't
    affect the data though).
 2) Force the OS to be aware of the new partition sizes - either a
    reboot or using partprobe.
 3) Grow the array (mdadm --grow) - check the manual page for details.
 4) Resize the filesystem (resize2fs).

There shouldn't be any need to drop & recreate the journal (I've never
done anyway - I guess it may be needed if you want to resize it).

HTH,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFH1mkTShxCyD40xBIRAgK4AKCCzVOAl0qg+/homMVDdsufB2wdSACgoskg
DDJ7dMN/KzhU0CIrnlF6LOA=
=KQeo
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
