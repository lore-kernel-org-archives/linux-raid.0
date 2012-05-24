From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Increase minimum chunk size in testsuite to 64kB
Date: Thu, 24 May 2012 15:38:14 +1000
Message-ID: <20120524153814.05cf7d70@notabene.brown>
References: <20120524151047.7a011be9@kryten>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/X/C7VBYQzMnUo/JikQzm3+i"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120524151047.7a011be9@kryten>
Sender: linux-raid-owner@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/X/C7VBYQzMnUo/JikQzm3+i
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 May 2012 15:10:47 +1000 Anton Blanchard <anton@samba.org> wrote:

>=20
> When running the mdadm testsuite on ppc64 with a 64kB page size I
> see a couple of failures because the chunk size is smaller than a
> page.
>=20
> Bump the chunksize to 64kB to fix these failures.
>=20
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
>=20
> diff --git a/tests/02r5grow b/tests/02r5grow
> index f9fd571..b91ffcd 100644
> --- a/tests/02r5grow
> +++ b/tests/02r5grow
> @@ -2,7 +2,7 @@
> =20
>  # create a small raid5 array, make it larger.  Then make it smaller
> =20
> -mdadm -CR $md0 -e0.90 --level raid5 --chunk=3D32 --raid-disks 3 --size $=
[size/2] $dev1 $dev2 $dev3=20
> +mdadm -CR $md0 -e0.90 --level raid5 --chunk=3D64 --raid-disks 3 --size $=
[size/2] $dev1 $dev2 $dev3=20
>  check wait
>  check state UUU
>  testdev $md0 2 $[size/2] 32
> diff --git a/tests/02r6grow b/tests/02r6grow
> index 3f53904..38c7781 100644
> --- a/tests/02r6grow
> +++ b/tests/02r6grow
> @@ -2,7 +2,7 @@
> =20
>  # create a small raid6 array, make it larger.  Then make it smaller
> =20
> -mdadm -CR $md0 -e 0.90 --level raid6 --chunk=3D32 --raid-disks 4 --size =
$[size/2] $dev1 $dev2 $dev3 $dev4=20
> +mdadm -CR $md0 -e 0.90 --level raid6 --chunk=3D64 --raid-disks 4 --size =
$[size/2] $dev1 $dev2 $dev3 $dev4=20
>  check wait
>  check state UUUU
>  testdev $md0 2 $[size/2] 32
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Applied, thanks.

And thanks for testing :-)

NeilBrown

--Sig_/X/C7VBYQzMnUo/JikQzm3+i
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT73JRjnsnt1WYoG5AQLvwQ/+Pd5VwAMLg0I7bLp+Gcygry9YjDs+YAed
3qIlE1sOvdWFSHhBxGIB6SV7hmsUgeysjEZmxh57holZjRdzpfr9iePdCnB/rM/G
/NZAOFb5Xxf+qGbpBOtM03n9bAoEQ4/a0bjZrBR1+uWQeh2sgcT5JY3fWZzgSnNM
8CkwWDQELjiaeOgaO2bLUm1nPZNFN8p0Ik5/dIzQ5QjE/nZ9wOY4tWiv7KQXIOIc
YvbDVpRAx0d20hCyeFUR/5r1HS1XO5UmSPWPJlbhl0sO8ZHvObJVhEsMKZc0+9jH
SaQovzqYGhem+eLWXFsjhP1Lc3tYKnus6S3y2D4bPDkiOkYld5L5PY+xT/8T9SOX
C/2NVhdSk5llO3sQ5KPt9Qi/XVQac5sy+RhQWHSuYo4+sPmi04p5gp9wO1Gpzw2o
wmQT6/14j5vOrtUrpfF+p+N1scdc4VauekhSYFieUfXtnm6/Vm141vOiegJTzCHR
CVsl6YePJbY6VRQxnu58di2IfneB/U0ZQBIEUS6aDtiwGwqpRfdSzBssperjIkWn
eddGkJn0Ylw4v788t3Xlc6T3Tojn40fr8lykRjdF5xxo0nsBFICyeIiMWdCYTaen
l71+OQhI21DsT8ngf5R3nG6Oct9+t/1PCa6w+ZFa4ZgUM7Rmq6zzb0YSwIIIqREH
CIsnFmwfJ00=
=9reb
-----END PGP SIGNATURE-----

--Sig_/X/C7VBYQzMnUo/JikQzm3+i--
