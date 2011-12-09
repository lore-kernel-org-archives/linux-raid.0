From: NeilBrown <neilb@suse.de>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Fri, 9 Dec 2011 14:20:06 +1100
Message-ID: <20111209142006.7ad399f9@notabene.brown>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu>
	<20111208075709.587ac227@notabene.brown>
	<654BF752-029F-444F-A4AB-68C3CEA7F8D5@ucsc.edu>
	<20111208091651.2a56dd5b@notabene.brown>
	<2866C99D-B573-4EF3-8FD0-0A40B0C20118@ucsc.edu>
	<20111209065140.107aa286@notabene.brown>
	<46200D05-2D7F-44F8-9323-DCFF720776D2@ucsc.edu>
	<20111209075931.29b26b5e@notabene.brown>
	<D1EB6C45-E127-4EC6-BFDD-BDFCC4607981@ucsc.edu>
	<20111209095033.06136f92@notabene.brown>
	<E88BF285-4224-45F8-952A-0248E7025BDD@ucsc.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/J0pF+eSEZBp8wdEkcctiU=7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E88BF285-4224-45F8-952A-0248E7025BDD@ucsc.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Eli Morris <ermorris@ucsc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/J0pF+eSEZBp8wdEkcctiU=7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Dec 2011 15:03:54 -0800 Eli Morris <ermorris@ucsc.edu> wrote:

>=20
> Hi Neil,
>=20
> Thanks. I have:
>=20
> mdadm - v3.1.3 - 6th August 2010, which is the default up to date version=
 on Centos 6.0
>=20
> One question: is the command:
>=20
> >  mdadm --create /dev/md5 -l5 --layout=3Dleft-symmetric --chunk=3D512 \
> >  --raid-disks=3D16  --assume-clean /dev/sd[a-p]
>=20
> Or=20
>=20
>  mdadm --create /dev/md5 -l5 --layout=3Dleft-symmetric --chunk=3D512 \
>  --raid-disks=3D16  --assume-clean /dev/sd[a-p]1
>=20
>=20
>=20
> Note that partition number on the drives: /dev/sd[1-p]1 instead of /dev/s=
d[a-p]

Yes, you are correct, you need the '1' at the end.
Sorry, and thanks for being careful.

NeilBrown


--Sig_/J0pF+eSEZBp8wdEkcctiU=7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuF+Zjnsnt1WYoG5AQLezxAAkkNfO6NL0RRb3kKHDa3WvB4ff4AIUI99
KBrV9/Te7f74nOEovnibYJJj8BCI4ijSXYsmWcPjTnp75Wm0CpeTYO1xjZd81gX2
dQgqVO92e7hZ4SF8RP15fAFb7qVW4irPyOIF9k34aSL66JtSO8ql2eNwVeWEalLE
3KiIX0VoHHxN0umWNmsBDvY7WABn8jhZThsc43od2radN/nxjfzjJ/4mIuQE/Pbm
jk+DQLISkxS1q1NmfBmo1pl+wh6flFQcPBn9Dr7rt7bY8T1p9gKzYu3+he9KuQ0s
Ez0TLJPRj8koTRO++/0bqmVhkf6SaxRRW33gV48Yr03yVsLLt/AvrrmwI0XVp4JA
gMIRQU+ragyA/ZhHXc3Y1VZ4V0mc29o3MXp7ziHcMxgarqJC3aI/I2cxmOW9fpVq
skVADUW1t7WW7XQV5LgdIy3rjg+2p2DBhmYyZSN/ZoIoJ3yh5zqb+30eU5+wQD6F
MLsNNgi3JR0/XVC3Nhl+QxFAS7FT5iWrSMTUg4rKsU4XjHiOC5JiX5A5862ESL/7
0vWQr5ueW7YEQqalAbmRAhp0AaUaYqdQ0ebUy7Hp/3CMflM+Kfy7yOoL8HB5YSzp
VIvaMaY/N9/h6BtokgugPRnrt4NfmKhrgrzinSigMAisD1sfXRIZj13FWa7zrfih
qOR+yZIs+qE=
=yUlN
-----END PGP SIGNATURE-----

--Sig_/J0pF+eSEZBp8wdEkcctiU=7--
