From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Grow: Do not use grow-continue unit file if reshape is
 starting
Date: Mon, 7 Jul 2014 11:06:13 +1000
Message-ID: <20140707110613.3b558b33@notabene.brown>
References: <84A53BEA6EAC69439B7E311E9B17A76F19CC0430@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QzEvMV.BsDdJkCRTO7UPySm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84A53BEA6EAC69439B7E311E9B17A76F19CC0430@IRSMSX105.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--Sig_/QzEvMV.BsDdJkCRTO7UPySm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 4 Jul 2014 08:59:00 +0000 "Baldysiak, Pawel"
<pawel.baldysiak@intel.com> wrote:

> Mdadm should use mdadm-grow-continue unit file only if
> reshape is going to be continued. Otherwise, array specific
> reshape with IMSM metadata will fail to start, due to
> missing information about ongoing migration -
> grow-continue will try to start again the reshape process.

I don't think I agree.  I think mdadm should always use mdadm-grow-continue
unit file if it is available.

Please explain in more detail what problem you are seeing.

NeilBrown

>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  Grow.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index a2f4f14..0cd9442 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -3272,7 +3272,7 @@ started:
>  		return 1;
>  	}
> =20
> -	if (!forked && !check_env("MDADM_NO_SYSTEMCTL"))
> +	if (restart && !forked && !check_env("MDADM_NO_SYSTEMCTL"))
>  		if (continue_via_systemd(container ?: sra->sys_name)) {
>  			free(fdlist);
>  			free(offsets);


--Sig_/QzEvMV.BsDdJkCRTO7UPySm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU7nyhTnsnt1WYoG5AQJYrw//Sd0EojUqgPhqYwyi8jhPJcRRnst7psSw
veFD9fx8uP5rqNghCnH3ysRqEaZlhDX0ZZrV97BzC5OVoqIvJYxyU4ncBljQL50T
wwhXz4Tuz9Bz3Y/7CvXY76v645cNpDgMFqfF4AScmWTZXA3j6qiLgjYKeOhzlx2s
N761Lxv7wBPlzCS1VWyXPY9VBXoh+QvtIiCfM1dHKgmAyYJ6igoBUK7ykaTwxWsC
i9LZN/3sd/wm+45SfPAvMm/C8Ml74RIDz7q3hn+rw6ZsxMwWcAAa4FoKHAB5lYHI
apzjsYOLGuxOymv8XN/oGZNHafeM6x5vg9isgyfE18vd2zTk4fYLiSzw0vNH0RZD
Z4YBp2frvRc/v/sTvAEHxpDRFOz7WBW8M0v619CXHxAuLd03y/ETaitMSzVWLsi3
F82ePaLZKc3u5nWlMbFntumAeF6DHHdJ287lW9rnsy7btKYbeC02YFJDYuO8yjFY
XvEBAJQOB+n2t5Y5ttyMfBaI4pLPVtGV7qZF0v2Ax7bQwF1F1fEWO0BRSDHpKsNe
5ucAwSxEFdpSgDgQG8tywuHNeXSxeiDD/CFvQz9gFPd/2ndNOti2dgbUcskT+1Ha
L0lsVTl+p2ZFkQMTyrdBRsTSwDxH7breq9GTDx1FaYXydPt65JT+1Cso4sVAHdlI
TY2Rf/OR/9M=
=0q/l
-----END PGP SIGNATURE-----

--Sig_/QzEvMV.BsDdJkCRTO7UPySm--
