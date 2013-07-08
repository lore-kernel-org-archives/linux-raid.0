From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 05/27] DDF: Implement store_super_ddf
Date: Mon, 8 Jul 2013 15:48:10 +1000
Message-ID: <20130708154810.561ba2a2@notabene.brown>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
	<1372883287-8859-6-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GIZE8M+9tk9VjpJfIC1taKK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-6-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/GIZE8M+9tk9VjpJfIC1taKK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Jul 2013 22:27:45 +0200 mwilck@arcor.de wrote:

> This patch implements the previously unsupported case where
> store_super_ddf is called with a non-empty superblock.
>=20
> For DDF, writing meta data to just one disk makes no sense.
> We would run the risk of writing inconsistent meta data
> to the devices. So just call __write_init_super_ddf and
> write to all devices, including the one passed by the caller.
>=20
> This patch assumes that the device to store the superblock on
> has already been added to the DDF structure. Otherwise, an
> error message will be emitted.
>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>

I'm not sure I really like this.  If mdadm is calling ->store_super, then it
wants to write to just one device.  It will quite possibly call
->store_super on all devices, and with your change that will write to all
devices multiple times.
So maybe a different interface is needed?

What is the big-picture effect of this patch?  What mdadm function now works
that didn't work before?

Thanks,
NeilBrown



> ---
>  super-ddf.c |   41 +++++++++++++++++++++++++++++++++++------
>  1 files changed, 35 insertions(+), 6 deletions(-)
>=20
> diff --git a/super-ddf.c b/super-ddf.c
> index b806949..b3c846d 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -3471,15 +3471,44 @@ static int store_super_ddf(struct supertype *st, =
int fd)
>  	if (!ddf)
>  		return 1;
> =20
> -	/* ->dlist and ->conflist will be set for updates, currently not
> -	 * supported
> -	 */
> -	if (ddf->dlist || ddf->conflist)
> -		return 1;
> -
>  	if (!get_dev_size(fd, NULL, &dsize))
>  		return 1;
> =20
> +	if (ddf->dlist || ddf->conflist) {
> +		struct stat sta;
> +		struct dl *dl;
> +		int ofd, ret;
> +
> +		if (fstat(fd, &sta) =3D=3D -1 || !S_ISBLK(sta.st_mode)) {
> +			pr_err("%s: file descriptor for invalid device\n",
> +			       __func__);
> +			return 1;
> +		}
> +		for (dl =3D ddf->dlist; dl; dl =3D dl->next)
> +			if (dl->major =3D=3D (int)major(sta.st_rdev) &&
> +			    dl->minor =3D=3D (int)minor(sta.st_rdev))
> +				break;
> +		if (!dl) {
> +			pr_err("%s: couldn't find disk %d/%d\n", __func__,
> +			       (int)major(sta.st_rdev),
> +			       (int)minor(sta.st_rdev));
> +			return 1;
> +		}
> +		/*
> +		   For DDF, writing to just one disk makes no sense.
> +		   We would run the risk of writing inconsistent meta data
> +		   to the devices. So just call __write_init_super_ddf and
> +		   write to all devices, including this one.
> +		   Use the fd passed to this function, just in case dl->fd
> +		   is invalid.
> +		 */
> +		ofd =3D dl->fd;
> +		dl->fd =3D fd;
> +		ret =3D  __write_init_super_ddf(st);
> +		dl->fd =3D ofd;
> +		return ret;
> +	}
> +
>  	if (posix_memalign(&buf, 512, 512) !=3D 0)
>  		return 1;
>  	memset(buf, 0, 512);


--Sig_/GIZE8M+9tk9VjpJfIC1taKK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUdpSmjnsnt1WYoG5AQKlihAAsc11J8UWYF2qYQjcKuZGe5zNgWegoB0H
yJ0eXjIcIZ2dcSNTgQFaJVQ6I1X2w/HdDSQg3LDzIMEFiTnRdmmNiWHiyQZTRpC5
MD6wAEVmDLoiYAcpvj5TsEDa3edFieo2SRML3oCyCJNxttW0w2P9OtREKX+Vslma
h90cMBhMbwWcPfh40FdLmrV68SIedMET10NzQtSfca+Gl9NHD+zLaJ0F7cim54lL
2H/bXvTFXebcSth5HPvRny2zgM2mYyZPNrX+ThLbIFrhHlvRHGM/HXxOG/NuUKBX
ywsZcQDCND4zugmyJuhHilGXm34ZjUNfrJms3hS9tWr+0L1ZkBgNMyiFk7EUTHUU
HkzNQlGyZJ1YsxLmbYEgfTAsjizTQZSXBANMojLZTG1nAROFzxRk3QWTpaPmyZye
OPHtsDBXlXIginTucK1Sik4XQEarqNxUIE+mXSHCmPv5/6T3t4sHTIH/5XjYaq5Y
eu6BkI5LEyKxOzA5FFcLxPlWohXYiBmO/XC08YZhiv7jL6yupHLFNMw7X2yoj1Eh
jr2anSWNIQNIb+JkP1juaUIdSxWADgkvAemZ6S3m0Gl87M/qSWgrcaDa6pC6WQFd
duXxXlN8VrjmsDeasHpncgLC5i2JSXwa8bGca/lJXGuVImhrqjGRgIWpBcl5qwZU
bYPoDgDLbfY=
=pajm
-----END PGP SIGNATURE-----

--Sig_/GIZE8M+9tk9VjpJfIC1taKK--
