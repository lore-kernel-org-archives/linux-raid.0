From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Grow: fix resize of array component size to > 32bits
Date: Wed, 29 Oct 2014 09:19:57 +1100
Message-ID: <20141029091957.1c4cdeae@notabene.brown>
References: <1414198502-10167-1-git-send-email-jmaggard10@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/krsENHcG5.0u8rLh/0Vl4XN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1414198502-10167-1-git-send-email-jmaggard10@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/krsENHcG5.0u8rLh/0Vl4XN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Oct 2014 17:55:02 -0700 Justin Maggard <jmaggard10@gmail.com>
wrote:

> If the request --size to --grow an array to is larger
> than 32bits, then mdadm may make the wrong choice and
> use ioctl instead of setting component_size via sysfs
> and the change is ignored.

Can you explain exactly why the  current code is not sufficient?  When does
it fail?
If you include the explanation in a re-submission of the patch, and I am
convinced, then I will gladly apply your patch.

Thanks,
NeilBrown

>=20
> Instead of using casts to check for a 32-bit overflow,
> just check for set bits outside of INT32_MAX.
> ---
>  Grow.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index a9c8589..a614102 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1818,7 +1818,7 @@ int Grow_reshape(char *devname, int fd,
>  		if (s->size =3D=3D MAX_SIZE)
>  			s->size =3D 0;
>  		array.size =3D s->size;
> -		if (array.size !=3D (signed)s->size) {
> +		if (s->size & ~INT32_MAX) {
>  			/* got truncated to 32bit, write to
>  			 * component_size instead
>  			 */


--Sig_/krsENHcG5.0u8rLh/0Vl4XN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFAWjTnsnt1WYoG5AQJ+WhAAuNSv985wMFYA9YxskhSmh5QjU6Y4abgj
xaQyJVFiZ+sZ8iXKh+eY76OvSYfWnpQTAYJZrYfPGg/CXeEC/fKqdmt9zvJs1dMc
y4/PiR6DfXQXt86VTLahxrYOgbMTIV8EOZ+n+sdgUBQ2PIjrrZZdGYux0lKnUsm0
aN6g3R5ygdxPErbrVIYNCtaxnZPt+kJZwKCFCvrrQa8IdDAcheW6LVIXcf2iP+g/
rnZVSKbMwizmx6omz5WbQmKTCIrvhIZ9YWwBnRXH64cESmkt4agKY9bvAhDVoQic
oH9HHZK3ZIClXoYRuQU+j1Ih5eMgznAcxT04KXwBnEgZ47gGurHq6G2zPFn3XTIF
kvuwrSvk7Zjp3ysI2B12glgYYw0GcTjIPFPMv4JKyebMK93X1Xmz/sP49uyYpGD9
uFIy9+64rBQtDixH6kWXddg4vvbb5i6MRx06faHnL70fPNqaLzLTagME2dcXM1vB
l/+c0Z/9a1qPLKcu56xAJR7Ow8k5/OO0QJrA61IC2yLVmV28FAAdsvN+Dz4hO5V+
3coZpHtrHwQF2ZlVBEo/WgvvCsxMg8xK12opOUoV4bw/z0k5dSYMy0cw+aQO/cYg
jC/7EtlON1A6lwGXjQGH8Vjjqt90SsN9MSz5sCuuysM3PUFVP/6IwasyJbNnkdBM
uCRIGGg7RFo=
=/tVX
-----END PGP SIGNATURE-----

--Sig_/krsENHcG5.0u8rLh/0Vl4XN--
