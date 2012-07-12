From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: commit backport request
Date: Thu, 12 Jul 2012 04:52:11 +0100
Message-ID: <1342065131.25597.352.camel@deadeye.wl.decadent.org.uk>
References: <20120709140230.3cf926ec@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-bUdAcbH1TwLQPYBsnNsg"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120709140230.3cf926ec@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: stable@vger.kernel.org, Jose Manuel dos Santos Calhariz <jose.calhariz@netvisao.pt>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-bUdAcbH1TwLQPYBsnNsg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-07-09 at 14:02 +1000, NeilBrown wrote:
> Hi Mr Stable,
>=20
>  please apply patch
>=20
> commit fab363b5ff502d1b39ddcfec04271f5858d9f26e
> Author: Shaohua Li <shli@kernel.org>
> Date:   Tue Jul 3 15:57:19 2012 +1000
>=20
>     raid5: delayed stripe fix
>=20
>=20
> to 3.4.y and 3.2.y.
>=20
> It fixes a deadlock in RAID5 which can cause all IO to hang.
> It has been demonstrated to fix a real-life problem (the race is not
> theoretical).

Queued up for 3.2.y, thanks.

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u

--=-bUdAcbH1TwLQPYBsnNsg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/5J6+e/yOyVhhEJAQo8qA//VR5eevaFG+LPN+POX06YvKh3m6e667un
h6WhjiM+D0Tq4ZiZEV3ttgfPhSDzz4OjpJ+MQ9doy2awC2uOFDCXjyvjmKoPDcqP
j+QvOvQiJ2kw+Cqm6YC0BisxS/Wcs79Dj/GtEc0RPRi7/CNs09I6U6KKm2mk10hr
suz7Lf4R6wkqy95FOcf/HPgQlWDfcxgjYgRbC6bYsrgVwQFLGoHO0pWfwkFxUmJX
lqkTx1jJ84eSlIGuVWE23EycognFDWP/jLVjiZ9l0ROlKoU7fF4sra0spGK3FQ0V
r3arRPA8W1lonxp+pLDF5gqmQrQmtFGvC73orJZ7fgfDSr8XXNmKF7PSMoGnWoG/
p6pt0bUemA3uWCBbOwk+lHgpkn64od3JzM+mztgR5DssTUHkiPx7lLMkDVcmh6iF
xTNwjZln73pNbD0sxV0s/N1VVN/5FpmqLlCbEfvAFNCZVKVXg040thwpO82eUlGh
m8J14VKj/jduS4IY+obuadrfvScy2fRNwLQS1Tkjw93D+c+pe5FRa/Vv1niBqDeG
T2+bl8iP92v+9fdU5cA9yoSHFTzgqKq1cGXP8M42fEbj1c/C5karlT4FSuwH5p0+
FG0ix29FoQ64hOSTXO4Okau1bZt0sfoibo8htEUtpRQyhzTi4RnIZnOK1YsI9RLl
DRB32Eog2Ks=
=vW0N
-----END PGP SIGNATURE-----

--=-bUdAcbH1TwLQPYBsnNsg--
