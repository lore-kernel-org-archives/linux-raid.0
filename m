From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/4] md: Add prompt message about wantreplacement disk
 in /proc/mdstat
Date: Mon, 4 Mar 2013 13:05:31 +1100
Message-ID: <20130304130531.047b4879@notabene.brown>
References: <201302281550256355711@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/UShXq+aZ9Kd3TMn_W/cFcDb"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201302281550256355711@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/UShXq+aZ9Kd3TMn_W/cFcDb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 Feb 2013 15:50:28 +0800 majianpeng <majianpeng@gmail.com> wrote:

> From file "/proc/mdstat",we only get the disk which replacing.But we
> can't get the disk which want repalce.So add the info.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/md.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3db3d1b..4935dbe 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7017,6 +7017,8 @@ static int md_seq_show(struct seq_file *seq, void *=
v)
>  				seq_printf(seq, "(S)"); /* spare */
>  			if (test_bit(Replacement, &rdev->flags))
>  				seq_printf(seq, "(R)");
> +			if (test_bit(WantReplacement, &rdev->flags))
> +				seq_printf(seq, "(WR)");
>  			sectors +=3D rdev->sectors;
>  		}
> =20

If you really need it you can get it from /sys.

not applied.

NeilBrown

--Sig_/UShXq+aZ9Kd3TMn_W/cFcDb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUTQBaznsnt1WYoG5AQJl2xAAhExkFHaey28monMlrkqaBFr6lnFdiYjb
wCDhPFF0FP/Ku2M1LAA1hmUMgsTryaExLF9zgpjPn4nSX4ojAuHNAt5ba6dwh6no
+Bl5Shb+rcxT6CNCUyeh+NTP1SY4LAU1COXHF0nQ5Yuijv+rvAKk9h+scVlUKjrW
wGCpafvxRC/FQ6zWk6G1y4PMgf5gYXnfqeTLA834fP8bPEgzj2lzUfX05zG4ZUOx
tPw4ixSTIYk2rHXjVgtrYsdt9mL6JQIgzRqwWZAiOiKXbax/YxMB1/WogMvVeDEu
UcebnhW0wbgProbn7HOFe2tnByI4E3kH7r+XMqgAdc0S3dplzKAJ5JYxDjlIV0Td
UMYwAoV2YVzj8L18pLAnk7q8hTZyoCsF942iHTd0Em4MBqjkMmkFb24z/lcTO3bY
dwSsphFVU5KgPbevCVqT8gWzykDDkFaXHVgpMhLquM+BOeoBTetfTD+yIEDrcXln
0nlHHZWm3ut0crZaq4Hp0rxjNHd90+jqN7QY5pexaunNKDQOqWAaAQxCxom8M1zG
cmzDfzjqCzHrzzYFtAsoxRPTJuGJpPtKxnXHAE8EmQRsEiYxVr1r70JfIA4bYeKp
tyS055sH8YiJiLbSpufAPn7UVnL5hSjg/AKkpGjqGi3PzoScx1+zuWTqXsn+hvYf
/3IzP4k/rpw=
=/3iI
-----END PGP SIGNATURE-----

--Sig_/UShXq+aZ9Kd3TMn_W/cFcDb--
