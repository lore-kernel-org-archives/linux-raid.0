From: walter harms <wharms@bfs.de>
Subject: Re: [PATCH] md: fix a build warning
Date: Wed, 10 Jun 2015 19:32:41 +0200
Message-ID: <557874B9.9010500@bfs.de>
References: <1433949658-8455-1-git-send-email-firogm@gmail.com>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1433949658-8455-1-git-send-email-firogm@gmail.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Firo Yang <firogm@gmail.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids



Am 10.06.2015 17:20, schrieb Firo Yang:
> Warning like this:
>=20
> drivers/md/md.c: In function =E2=80=98update_array_info=E2=80=99:
> drivers/md/md.c:6394:26: warning: logical not is only applied
> to the left hand side of comparison [-Wlogical-not-parentheses]
>       !mddev->persistent  !=3D info->not_persistent||
>=20
> I fix it by enclosing !mddev->persistent with parentheses
>=20
> By the way, I also fixed a line over 80 characters warning outputed
> by ./scripts/checkpatch.pl
>=20
> Signed-off-by: Firo Yang <firogm@gmail.com>
> ---
>  drivers/md/md.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index dd85be9..b420d82 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6391,9 +6391,10 @@ static int update_array_info(struct mddev *mdd=
ev, mdu_array_info_t *info)
>  	    mddev->ctime         !=3D info->ctime         ||
>  	    mddev->level         !=3D info->level         ||
>  /*	    mddev->layout        !=3D info->layout        || */
> -	    !mddev->persistent	 !=3D info->not_persistent||
> +	    (!mddev->persistent) !=3D info->not_persistent ||


this looks odd,
would it be possible the check for =3D=3D instead (and drop the !) ?
and it someone care for readability: It would be helpful to
make some more ifs here.

re,
 wh

>  	    mddev->chunk_sectors !=3D info->chunk_size >> 9 ||
> -	    /* ignore bottom 8 bits of state, and allow SB_BITMAP_PRESENT t=
o change */
> +	    /* ignore bottom 8 bits of state, and allow SB_BITMAP_PRESENT
> +		to change */
>  	    ((state^info->state) & 0xfffffe00)
>  		)
>  		return -EINVAL;
--
To unsubscribe from this list: send the line "unsubscribe kernel-janito=
rs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
