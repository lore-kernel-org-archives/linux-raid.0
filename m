From: NeilBrown <neilb@suse.de>
Subject: Re: Mirroring seek optimization
Date: Sun, 24 Aug 2014 12:45:36 +1000
Message-ID: <20140824124536.5f132895@notabene.brown>
References: <4CE5B469-1F8B-4F66-8993-8A752CE08420@k9heritage.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/9PSH979eCSnUxpnZL2QcFgU"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CE5B469-1F8B-4F66-8993-8A752CE08420@k9heritage.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Long <boblong@k9heritage.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/9PSH979eCSnUxpnZL2QcFgU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 23 Aug 2014 17:51:09 -0700 Robert Long <boblong@k9heritage.com> wro=
te:

> Hi,
>=20
> I don=E2=80=99t know who to talk to, so I thought I would start here. A w=
hile back I developed a further optimization for speeding up read access in=
 mirrored disk arrays. Testing reveals that it achieves about a 7% advantag=
e over the current implementation. I had considered patenting it, but I fou=
nd that there is an existing US patent (7,330,930) that is broad enough to =
cover the existing Linux mirror implementation as well as my improvement.
>=20
> Any ideas regarding who to contact regarding further discussion of applyi=
ng the improvement would be appreciated.
>=20
> Bob Long

Post your patch, test results, documentation, anything to this list.
That would be the best way forward.

NeilBrown

--Sig_/9PSH979eCSnUxpnZL2QcFgU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/lR1jnsnt1WYoG5AQJfKA//SMG3BB4BMT1pSaOHHQTmV/2dFPn1Su9o
mpcAQ4uor09stbk68NclvnvTNgU20G7S5zdZhOOXwspv2jdK+WwbjwAwfSa3PuFu
vmpWhKos+DhvlIwE/RexkHv+DWodtVxoNA2yjYySSiwh7pcSYW6ruSXD0CsGJY9Z
IWnusbuQP4Ac5VV9BPtB04onCC5K8bI1M9C+7xzO7IaArGzgrJJgagxDHM+uZuPC
Z7pOx/w9pLNgiJyMjLUgeWmFcdllMK6zfxr+C6L6GT3x02YjIgNgzhSyo8BQTE5x
yGQpL7P6cjw+ySB19J7MDRHjRFFoq8h1M+1b6WvRUUoNri9jwSnwW9yBjP35QkxP
UKjk9IylS8+PgXsDCiAQyIfySfWzg5rQPcAZoQXpW1H99qB3RBgkvUCAMeUYqvP6
6awYZP5EqyENwrEynSDwf6ZbpFjkZW/So3lLh2m403KUZxG/xKCvmIQG9DySnA6L
VhHyfDZOw1Kg+nx+x9t5tZQp7xjULPLhkD9K256oxlwDGwHvNr+zhc0BtaH5bpkI
8REeH8/eVssdhZ9Qp0xjTSKVZiCv9HqDbWocPd4mj25TjTsqnjS3d7MsExkenTcf
WRtSU6ZkfZd48LEM3UQ6UcWUezDFa4TdXp8sqopDSl07UTJ/QWUjYOje2NZTtxWn
ivRyL1bH9e4=
=Zfl+
-----END PGP SIGNATURE-----

--Sig_/9PSH979eCSnUxpnZL2QcFgU--
