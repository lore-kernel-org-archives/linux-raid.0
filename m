From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/3] Replace --no-error by --keep-going
Date: Mon, 22 Oct 2012 09:11:48 +1100
Message-ID: <20121022091148.4c678fad@notabene.brown>
References: <1350749054-5519-1-git-send-email-g.esp@free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/msF6Y16N3dpU1eU.0GqBlVT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1350749054-5519-1-git-send-email-g.esp@free.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Gilles Espinasse <g.esp@free.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/msF6Y16N3dpU1eU.0GqBlVT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 20 Oct 2012 18:04:14 +0200 Gilles Espinasse <g.esp@free.fr> wrote:

> Signed-off-by: Gilles Espinasse <g.esp@free.fr>
>=20
> Suggest to replace by the option name that 'make' use.
> no error is only a developper hope.
> ---
>  test |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/test b/test
> index 8339d06..c5b1982 100755
> --- a/test
> +++ b/test
> @@ -252,7 +252,7 @@ do_help() {
>    echo "    --disable-multipath         Disable any tests involving mult=
ipath"
>    echo "    --logdir=3D<directory>        Directory to save logfiles in"
>    echo "    --save-logs                 Save all logs in <logdir>"
> -  echo "    --no-error                  Don't stop on error, ie. run all=
 tests"
> +  echo "    --keep-going                Don't stop on error, ie. run all=
 tests"
>    echo "    setup                       Setup test environment and exit"
>    echo "    cleanup                     Cleanup test environment"
>    echo "    <prefix>                    Run tests with <prefix>"
> @@ -289,7 +289,7 @@ parse_args() {
>  	fi
>        fi
>        ;;
> -    --no-error)
> +    --keep-going)
>        exitonerror=3D0
>        ;;
>      --disable-multipath)

Applied, thanks ... though I kept "--no-error" as an alternative (it still
works, but isn't listed in the help).

NeilBrown

--Sig_/msF6Y16N3dpU1eU.0GqBlVT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUIRzJDnsnt1WYoG5AQJ2PQ/+P6VPtHDNZ1B5k7jFRw0WdwHnvol3DM/y
LzDM/2IG076qJYQgGwD/bVRnqhcVH3PVTrS4o5lPmQT/Szk9G+fCpK3+qUtRpLeg
UWeZXx06/dbPVP+QHZFGgxzCMuxk2PVhtqgPxqQ4XTH8jtOUg2AeQtLRlBiw/xlT
qon9yO0Juv/7F54XjviyqZ1yT4U/00KMGunEvBj+VTeQaWCTYkvT/VpiBJoZxGLg
+3ZvsJQxn9OKTrJF7qIsVq/BWRDaCS1ojXR+nXvsGsKzQxLjckr4YYdXVSpJ0pdo
8KQUrAW+cgpm4jrKqik1poJVvQ3vKEFdjIADkIsarzkFGk5VcCQ5juyhsdITGOxj
5vUoAon2aNLZryb3KiMGH8GvGP0u5irO9N2dY/BC3hBtxKdK8ux9R7Irck6rRF/R
5BFO+/wFDO0qbjW514rCQQnQjV2PgWamQI/L8w2dTkeCvMXBe/V86zjsQ/b+YjPi
rBSnSuz5UdjDd5AmWBMdAIN+BsC+RY6uESpuG5FyimWwVJMtAg7Zm5V76tgV7TLC
NBrfiB9UluN/9AJ/WGVX+oeYb6nwp6FMg6lfywVZoxZrwEWjXvN/MQbFU1xx0jpu
Ll5HyhtW3tI8P4iPQuMZItW53zt671Ns0n2zaJJoy9QIkEgCzNlXLHIQC1UcKL4e
WjVCdb9dVWI=
=AtvN
-----END PGP SIGNATURE-----

--Sig_/msF6Y16N3dpU1eU.0GqBlVT--
