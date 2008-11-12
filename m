From: Doug Ledford <dledford@redhat.com>
Subject: Re: Fedora 9 install using md RAID
Date: Wed, 12 Nov 2008 10:56:24 -0500
Message-ID: <1226505384.4765.70.camel@firewall.xsintricity.com>
References: <491A5165.5080004@sauce.co.nz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RUn+ttRNR5Dp62msTKfT"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <491A5165.5080004@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-RUn+ttRNR5Dp62msTKfT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-12 at 16:45 +1300, Richard Scobie wrote:
> Slightly off topic, but I was wondering if anyone knew how I could do an=20
> install of Fedora 9 WITHOUT it using dm RAID.
>=20
> I have done a number of md RAID installs of Fedora 9, but this=20
> particular machine has a Silicon Image controller that the Redhat=20
> installer obviously recognises and automatically proceeds to install=20
> using dmraid and I would prefer to use md.

At the boot prompt, pass the nodmraid option.  There are a number of
options available, you can get the entire list by installing anaconda,
then running anaconda --help on a working system.  Any options the
kernel doesn't know just get passed on to anaconda.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-RUn+ttRNR5Dp62msTKfT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkka/KgACgkQTzP9PM7pjw+1ZACdH+Sa+02++WzTkwpo3vqbsL7z
cukAn2/wGrZF7Z8ZWNRMMQ9UQZYjQag9
=2Bh0
-----END PGP SIGNATURE-----

--=-RUn+ttRNR5Dp62msTKfT--

