From: NeilBrown <neilb@suse.de>
Subject: Re: Managing mdam
Date: Wed, 11 Sep 2013 09:48:48 +1000
Message-ID: <20130911094848.00289146@notabene.brown>
References: <CAPoh-nY8wwu-2yYRbKycPX2gEUofQu6y29TOYhOm83C2au6ZQQ@mail.gmail.com>
	<20130910153347.5fafb58b@notabene.brown>
	<CAPoh-nYLbSL81V4zmLQ579+XMa2rsNFG-Drf6mVQQuCh6SYOKg@mail.gmail.com>
	<6693fa95e533a6027b7346f1b9b8af7e@alyseo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/o.CSbRqtstcaDJA_UswUB7V"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6693fa95e533a6027b7346f1b9b8af7e@alyseo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Billard <francois.billard@alyseo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/o.CSbRqtstcaDJA_UswUB7V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Sep 2013 10:03:23 +0200 Francois Billard
<francois.billard@alyseo.com> wrote:

> Hi,
>=20
> Is it possible to manage mdadm from an external point of view ? with a=20
> library with bindings in some language (Python) for example ?
> Thanks in advance
>=20
> Regards,
> Francois

Only by running mdadm in a separate process and passing appropriate argumen=
ts.

Is there something particular that you wanted to do?

NeilBrown

--Sig_/o.CSbRqtstcaDJA_UswUB7V
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUi+v4Dnsnt1WYoG5AQKyFQ/9ECDyR0A1f20NxLeR3Yywy61wXB0CETg1
D/BzqA698+NAUTuN8KBpEGuT41h+naqVSTdns16JSxOaZKgmVJyjNRxb2Jn86Fko
QWXGyhgqoy5hODdzknyL0dQuE7ml67zwLdcy6jZxuPSnL4LttsGKXDl8VDthRe4y
7qQGQJjnkr4u10kw4gksF08TNckJUifhsWiCJ1Bl96PZO8SdnkcvSC/HX4PScrKc
l5PCSC82glliwPgBrRCyZogAgn2X9bdauyl3BDBtJKOrnMMGG3uNkzx0Spqdnbw7
OHjMJF/g1vHq1GA1UHhj/jiHLgqpAFeM3jCtw7m/H3HnOjlkoXfOsVwlD5ILhQ98
6eefaTTzcwldHZcFWu9wSRqT9d/NyhMGxbpQGwU7P618QRH7DJqutQf/Gl0JCoxK
hMy5oK3O5JyMhb1ZcOq9+K05zIF1YRVs8I1pkwp1WpmFYk44rUtTWXxT7n4B9JuP
cMtbRjXiTyco2/NQDJL1EvQuJDbOMmDhidxcT8JsfuBclKa048By1uEDciob4ltE
e9DjuepFP3W0GlgdGhB/DdOq55q38TplLkw4/QjKH53ML89J54TtB2m/+TiwCrlj
tWnx0u6lr6GKvU6xPpiHnbxbB2mpY6Npw0oxTUnPt0hR08vJGFbtVgVl1XBceCrj
Sxd9Hwe4VvE=
=dULg
-----END PGP SIGNATURE-----

--Sig_/o.CSbRqtstcaDJA_UswUB7V--
