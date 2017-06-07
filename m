From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] mdadm: Send version text to stdout rather than stderr
Date: Wed, 07 Jun 2017 11:44:03 +1000
Message-ID: <877f0od124.fsf@notabene.neil.brown.name>
References: <1496735987-10653-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1496735987-10653-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 06 2017, Zhilong Liu wrote:

> This helps with piping to a paper.

It might help you, but it is an API change and could cause problems for
others.

Some programs, such as "mount -V", send version info to stdout.
Others, like "gcc -v", send it to stderr.
There is no uniform standard, it is best to leave the behavior
unchanged.

If you need to capture the output use
   mdadm -V |& ...
or
   mdadm -V 2>&1

or similar.

NeilBrtown

>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  mdadm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mdadm.c b/mdadm.c
> index 70b16f2..0f736d7 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -139,7 +139,7 @@ int main(int argc, char *argv[])
>  			continue;
>=20=20
>  		case 'V':
> -			fputs(Version, stderr);
> +			fputs(Version, stdout);
>  			exit(0);
>=20=20
>  		case 'v': c.verbose++;
> --=20
> 2.6.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlk3WmUACgkQOeye3VZi
gbkToBAAlivun7eTYXHUMkXtMFE1+ZxhtVuE1ouww/w+CErzeav7nSuZy1gOZcWw
uFTVTSrMk36PlFYwy7Ylit7u3YKnNO8TMdxzcp20IUf8M7vUVL9rOW1Y9Mzj9rfC
xKogUN8Cn7LhVrsQVrd0FatqrKCBf+3EM0zSp8xtoGwhudmI7eVwSGEweqO7tZHs
EewMVRF5XGudx/ksDojyPkc9X2deSiy0zAoGngnk86q/rtug5vBIBTsXKzg3UkQP
GLZeKk726s+8fIjiib8yWXHsbXpoaxbpPsV5LczrilXBufWivd7ccj0DtPOEVE6w
k7eh8eNX5/mndHio03K60687EWON5Na098WFlQQYFQHUitjN6Aw3SRWUY8y36O1h
V3qlXP3STPUH4EwBOOnwH1XRUimAagyXpbEaJTmbXWCI844xzZP4TCJvpiaOSCIY
pDQGgThmkaZ0FaAGiOaibs4r7guMplYaL1SCi6rtmn7Qt9qjwUjwJmFBV/rPkcCj
x8vz+Akpw+AIE6uUSPNN8uiTBPVULV8B3yYAUM6Azchdl1YazeZZ/NXh6IZHGgus
5q9Y8Bb2jKmkQ7rAGJ4bHgBqGrva4WV+nxPmwfol9VeFMSFy523S+M5huDn17a83
CKPBZZHT3w5Jy1ek4iTZUL8jC5msrI7MXCS0JorMktG9BvFBLDY=
=xllz
-----END PGP SIGNATURE-----
--=-=-=--
