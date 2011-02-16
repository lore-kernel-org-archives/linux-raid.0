From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: md road-map: 2011
Date: Wed, 16 Feb 2011 14:00:24 +0000
Message-ID: <20110216140024.GA18707@cthulhu.home.robinhill.me.uk>
References: <20110216212751.51a294aa@notabene.brown>
 <4D5BB4EA.8030907@texsoft.it>
 <AANLkTikiP+PTJzpQomr++4d0chRww3gOq0R-J2-vaQ1-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikiP+PTJzpQomr++4d0chRww3gOq0R-J2-vaQ1-@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Giovanni Tessore <giotex@texsoft.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Feb 16, 2011 at 10:40:40AM -0300, Roberto Spadim wrote:

> i agree with giovanni, another question since we will make a lot of
> change on mirrors based arrays (raid1, raid10) with the badblock list,
> could we:
>=20
> option1) remove raid1 code, change raid10 to work without raid0
> 'service', change raid10 to work with more than 1mirror (like raid1
> do)?
> option2) port raid10 layout to raid1?
>=20
You can already do option1 (if I'm understanding you correctly).  A
RAID10 array can use as many mirrors as you like (--layout n2 is the
default, meaning a near layout with 2 replicas, using n4 would give 4
replicas), and as long as the number of replicas is equal to the number
of devices, there should be no striping involved in the process.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk1b2HcACgkQShxCyD40xBJaWgCgrxXPoFzdEUOGCWFWp3hvya6K
+rQAoJQC/2V3mlBliMb5NXqp+8bJY2aw
=96y9
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
