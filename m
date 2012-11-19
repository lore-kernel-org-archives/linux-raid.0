From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Grow.c: fix uninitialized variables compilation-time
 error
Date: Mon, 19 Nov 2012 11:18:00 +1100
Message-ID: <20121119111800.08edee0c@notabene.brown>
References: <20121113122943.4041.51702.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/sUAVJgdfvYcG91cCDRMPKe2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121113122943.4041.51702.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

--Sig_/sUAVJgdfvYcG91cCDRMPKe2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Nov 2012 13:29:43 +0100 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> It fixes the following uninitialized variables compilation-time error:
> WARN  - Grow.c: In function =E2=80=98reshape_array=E2=80=99:
> WARN  - Grow.c:2413:21: error: =E2=80=98min_space_after=E2=80=99 may be u=
sed uninitialized in this function [-Werror=3Dmaybe-uninitialized]
> WARN  - Grow.c:2376:39: note: =E2=80=98min_space_after=E2=80=99 was decla=
red here
> WARN  - Grow.c:2414:22: error: =E2=80=98min_space_before=E2=80=99 may be =
used uninitialized in this function [-Werror=3Dmaybe-uninitialized]
> WARN  - Grow.c:2376:21: note: =E2=80=98min_space_before=E2=80=99 was decl=
ared here
> WARN  - cc1: all warnings being treated as errors
> WARN  - make: *** [Grow.o] Error 1
> It occurs during compilation of mdadm on Fedora 17.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  Grow.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 4de8029..a526a65 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -2373,7 +2373,7 @@ release:
>  static void get_space_after(int fd, struct supertype *st, struct mdinfo =
*info)
>  {
>  	struct mdinfo *sra, *sd;
> -	unsigned long long min_space_before, min_space_after;
> +	unsigned long long min_space_before =3D 0, min_space_after =3D 0;
>  	int first =3D 1;
> =20
>  	sra =3D sysfs_read(fd, 0, GET_DEVS);

Applied, thanks - though I added a comment to clarify that the initialisati=
on
is only to silence a compiler warning.

NeilBrown

--Sig_/sUAVJgdfvYcG91cCDRMPKe2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKl6uDnsnt1WYoG5AQILug//Wh5RN2eeYKwGBiiijqsgiYfHN/L8Sot1
YPaN8PtmfU10HE/OdZIqfhbbP+rkWd/28LiTBkyQtK0rErCL3XnXt8QiWpopuHuG
E6Sjis8nBiEZsyPpR9j5zHcOJl/KnIx30eXDVUN6Yml2TAK/WH6nuwbbhrsoHLun
60eH56q28IKHodgiVqbkgOh2c3eej0tBLTgae01YSkVvQ8BoM5rBjpNkfhH8P5CQ
cEq93bfe8YBKt2jdOoojMfeMtzOad1ZyarsPSJ/7BySI6X70y4tWVGDogLFLu/q0
G+2Zmu6zANZaIaZi629H7JmeQxP7dCjlOchOs/3uOMnqjFnYJ+h0HD1EDoTaSUAN
3oH6YgNJTpD80hsEKRRGDGK5JgWwO2zXU83uZaWysWOBhfKPP2nQlEEZXOiW7evK
cTXvX9YkKWzKYZyQmOtnmiT/8s2lzVjfRyptu4I4WFzMq9oKC0S5uaJ+DxDUeIUJ
CVVESiF5WzduCvMMQDx1abV9TsCHTKIPbwNtamPiRrkb2nssxQd8cFcE1naa9O4B
7c6PZ4sZ5dNlZYf1ff4EaA6cR/M4+pJAPXfwuaDc/M40i9gDEIqKerKBcK5NUaB6
aR5D1aptgGu8kIO4vJ/RJNkl19689uRTYAEVNE2IV8n7agBI25LZ5qHc4l38ervU
tFbTYJFvGLw=
=xeec
-----END PGP SIGNATURE-----

--Sig_/sUAVJgdfvYcG91cCDRMPKe2--
