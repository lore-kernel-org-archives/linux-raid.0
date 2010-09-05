From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Date: Sun, 5 Sep 2010 21:01:39 +0200
Message-ID: <20100905190139.GA3163@merkur.ravnborg.org>
References: <1283711539-7123-1-git-send-email-segooon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1283711539-7123-1-git-send-email-segooon@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Neil Brown <neilb@suse.de>, Jens Axboe <jaxboe@fusionio.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Sep 05, 2010 at 10:32:18PM +0400, Kulikov Vasiliy wrote:
> From: Vasiliy Kulikov <segooon@gmail.com>
>=20
> rcu_dereference() is macro, so it might use its argument twice.
> Argument must not has side effects.
>=20
> It was found by compiler warning:
> drivers/md/raid1.c: In function =E2=80=98read_balance=E2=80=99:
> drivers/md/raid1.c:445: warning: operation on =E2=80=98new_disk=E2=80=
=99 may be undefined
>=20
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  drivers/md/raid1.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index ad83a4d..12194df 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -442,7 +442,7 @@ static int read_balance(conf_t *conf, r1bio_t *r1=
_bio)
>  		     r1_bio->bios[new_disk] =3D=3D IO_BLOCKED ||
>  		     !rdev || !test_bit(In_sync, &rdev->flags)
>  			     || test_bit(WriteMostly, &rdev->flags);
> -		     rdev =3D rcu_dereference(conf->mirrors[++new_disk].rdev)) {
> +		     rdev =3D rcu_dereference(conf->mirrors[new_disk].rdev)) {
> =20
>  			if (rdev && test_bit(In_sync, &rdev->flags) &&
>  				r1_bio->bios[new_disk] !=3D IO_BLOCKED)
> @@ -452,6 +452,7 @@ static int read_balance(conf_t *conf, r1bio_t *r1=
_bio)
>  				new_disk =3D wonly_disk;
>  				break;
>  			}
> +			new_disk++;
>  		}
>  		goto rb_out;

This change looks wrong.
In the original implementation new_disk is incremented and
then we do the array lookup.
With your implementation it looks like we increment it after
the array lookup.

	Sam
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
