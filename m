From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/8] Grow: Grow_continue_command() remove dead code
Date: Wed, 09 Mar 2016 09:42:04 +1100
Message-ID: <87fuw0lhhf.fsf@notabene.neil.brown.name>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com> <1457458252-20203-4-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457458252-20203-4-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org
Cc: gqjiang@suse.com, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 09 2016, Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> All cases where fd2 is used are completed with a close(fd2) ; fd2 =3D -1;
> so there is no need to check for fd2 > -1 before exiting.

In that case, you can remove all the assignments so -1 to fd2 - if you
like.

Thanks,
NeilBrown

>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  Grow.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/Grow.c b/Grow.c
> index c4f417e..0fa776d 100755
> --- a/Grow.c
> +++ b/Grow.c
> @@ -4924,8 +4924,6 @@ int Grow_continue_command(char *devname, int fd,
>  	ret_val =3D Grow_continue(fd, st, content, backup_file, 1, 0);
>=20=20
>  Grow_continue_command_exit:
> -	if (fd2 > -1)
> -		close(fd2);
>  	if (cfd > -1)
>  		close(cfd);
>  	st->ss->free_super(st);
> --=20
> 2.5.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW31U8AAoJEDnsnt1WYoG53xQP/icgkrWZcxBzmucjXN0lDfAk
EzLEQs7EmHbzryAiz3rYNXUApPBLq+QnQYDaGIqklTG+mnHpZDRIP+AyWFtvqW+V
lL+gRqNb6eM1P7qWhws/S0tNZhBox/KhGrfYb8uDiMqw755VWgw08wewlmCnmcb4
3IInZR5P8nFItnfKlLsgB/qpTPmFYbSZ0dIeqsZqjWy5jn8ClyHfBjbsTHUYaKSZ
7wgSCYylSP+i5Z3s5komPQkwVJTSSciYIc7n9C3CQWWz4eyQIWNhROav2Atd9NOY
OFWcKXlN9eNV3xjznqpnWXtHFgLl3u1h97GNgKXjFLOyN0H15CL3weh+pbvp8C7n
fULPb1RWcLZkcQxkMraSdC/VJlcEw4BjEbWqZyxTsxqAKtcB5TUdWNvBK1KAFKtV
ufpYROjwVmLTbBCnVgocG/g0ATXePQpE/UsnnV+PdX/7JqRfZHGSwGVJohCBVTF/
i6a+Xd713syWuVkqTq1rtTRh89Ty/9b3OscTTyEUz8pJp/iSBLe+7AIbir6/04ye
wV9B6jyPc9lkUF0XEHPZykGcQiQDfgBap0l6kHw2E+v3TzsCSZslfxLMIr6Ne0cE
jXBqFaabzIp+3G37y6MooQZZUFlbKNm0vmmPyOCgXhHlr7Dz8y0vUftc5sAc8ijO
ybVk7R7aYqWZBM/MxBFb
=vvci
-----END PGP SIGNATURE-----
--=-=-=--
