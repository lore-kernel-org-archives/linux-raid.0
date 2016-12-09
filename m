From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/3] md: MD_RECOVERY_NEEDED is set for mddev->recovery
Date: Fri, 09 Dec 2016 15:31:58 +1100
Message-ID: <87r35h205d.fsf@notabene.neil.brown.name>
References: <cover.1481240632.git.shli@fb.com> <8c8e0b996b721fb9747fb7b7d312d59dbba3b4c4.1481240632.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8c8e0b996b721fb9747fb7b7d312d59dbba3b4c4.1481240632.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 09 2016, Shaohua Li wrote:

> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/md.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 84dc891..5e66648 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6856,7 +6856,7 @@ static int md_ioctl(struct block_device *bdev, fmod=
e_t mode,
>  		/* need to ensure recovery thread has run */
>  		wait_event_interruptible_timeout(mddev->sb_wait,
>  						 !test_bit(MD_RECOVERY_NEEDED,
> -							   &mddev->flags),
> +							   &mddev->recovery),
>  						 msecs_to_jiffies(5000));
>  	if (cmd =3D=3D STOP_ARRAY || cmd =3D=3D STOP_ARRAY_RO) {
>  		/* Need to flush page cache, and ensure no-one else opens
> --=20
> 2.9.3

That was careless!

It would be good to add

Fixes: 90f5f7ad4f38 ("md: Wait for md_check_recovery before attempting devi=
ce removal.")

to this.

Reviewed-by: NeilBrown <neilb@suse.com>

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhKM74ACgkQOeye3VZi
gbkqHQ//ezs9a60y+wPBQMtGP0XXTkJ6p1H9I2SAb6VFloN5HV+27x1zNkZncGZA
jv14J1+BYCVn9IJYFPahlI122x+HqV0bOceHpqc48gbcIfGoPlpnLcMn3dk9ET3w
XeFqU8vqwESwTwcVrVnu11ZVqHHayVpvRUYj3pDSA8+Ih39ojyvXGEMPD1Ojwdui
0ui84Tm2xscd0AL70Yvket0TdmbKo+8pVx+6n0tB4NXSgoKqUZ/xI+gdwlcAHJ/M
7UhGw9cfZoGsvQsEzLAPbRjf31pdkL/aQpFlBkhzg9BcV1ey+0mNeMlbfk1+9gEn
IXzo6Y3RTjPUgcLJHQfbrmhlZqWOT0xIakjzop2acxWCQqJlRw2yb/GvXZWHBcH1
T4+3BS9VhAN059vTcX1Vcdo7O5fVKUEvZX0YbEZKx8+MC+NjZ72zJ6odRJzEFLg2
7V+dUFrY4NjXlSpFfmEiWBZUfLXrL2s666aHYLOjZ0i/BW9jgaV6P3PqZJgEdshS
sfvgSKDBNlBYSh2RqB1mfmxrRCktn41ihD8+S5JRnDbWl3Xpcu5ITN0e0CaKqShC
o9E5H08l08Db/3FjaAPhPivkCuxoR9kCPIa2hh3NuhGf5WzYIxk86p137jpcu7Rg
iLXcJRKIRdFzzjjFEwTn1pvePiLXXY7GLJtr+sAOGZtOitD+McI=
=+vot
-----END PGP SIGNATURE-----
--=-=-=--
