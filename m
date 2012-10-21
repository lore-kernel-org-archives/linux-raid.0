From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/3] Allow escape by ctrl-c broken by --no-error change
Date: Mon, 22 Oct 2012 09:12:14 +1100
Message-ID: <20121022091214.3550e892@notabene.brown>
References: <1350749031-5482-1-git-send-email-g.esp@free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Xcraajnvov6vBDFRP9.0UL/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1350749031-5482-1-git-send-email-g.esp@free.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Gilles Espinasse <g.esp@free.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Xcraajnvov6vBDFRP9.0UL/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 20 Oct 2012 18:03:51 +0200 Gilles Espinasse <g.esp@free.fr> wrote:

> Signed-off-by: Gilles Espinasse <g.esp@free.fr>
> ---
>  test |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
>=20
> diff --git a/test b/test
> index 2bb482c..8339d06 100755
> --- a/test
> +++ b/test
> @@ -68,8 +68,13 @@ cleanup() {
>  	done
>  }
> =20
> +ctrl-c() {
> +	exitonerror=3D1
> +}
> +
>  do_setup() {
> -  trap cleanup 0 1 2 3 15
> +  trap cleanup 0 1 3 15
> +  trap ctrl-c 2
> =20
>    devlist=3D
>    for d in 0 1 2 3 4 5 6 7 8 9 10 11 12

Applied,
thanks.
NeilBrown

--Sig_/Xcraajnvov6vBDFRP9.0UL/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUIRzPjnsnt1WYoG5AQIk5g/9G0fr/1z2e6C/f8DbctAYLD6Ib1CH94TX
Sl1qBRfV6hiO3feTgWoNkH9+Vb7C64s9+vuKrDFD/uDP6raaH5tU+Mk5AFEYmYLf
v4a9QamaCCjvPth1DE3tILJ5n/87RZ0MZND3+OTU8EE4zlQmDkfW/n864tNqjLY+
aiYYqzXBXbCfuLBH5UZRqMocqvTSHBXYmef5qozHKPa0Zv031fqTiZjdwzaUMeKe
CQKXWLn9rHH7KehWQOycZGvxditFSqO5sbw30J1XWLC1lnvanZCFlpaX3IzPP8b3
SAAXlkZ9G1wimoE3tjuvC1FsnBZFK0fCUKGlcwM6K7UAjvokJqIOJ0LpPXCqG79f
QYWEOwtYy+g962EqoIQ5ht52S8vayihpRv2dnPkbWYk7YOwGjEq5Y6odBtsZtnRt
GieLgN3SEmz15pJj/SEwPnTFUXCQvfwEWZtaoYRMqhSI4UuoljryY3Q1K1nDGkL+
iDJqnNgjFSn+E0T6Azf6kj7F+M2JLicESQLkF0zzp24uGNpWk9gcvTLDSaacX9c+
oKnfgmFODbOYe91MdG0A5bMgWuPlMRyNmhuJWKRtzGkfcxjpKv4sC00UqhOdBqfO
zXlVH3U0rzqrnauMxjvM3UBtcb7HfNjT8MVUhhSIZ/5MTl7Tu8x3jInnm15qSxqT
6dBFCtS3NMA=
=8yUR
-----END PGP SIGNATURE-----

--Sig_/Xcraajnvov6vBDFRP9.0UL/--
