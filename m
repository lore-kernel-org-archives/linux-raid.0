From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH v2] md: fix a build warning
Date: Mon, 15 Jun 2015 15:58:46 +1000
Message-ID: <20150615155846.7b85f2cd@home.neil.brown.name>
References: <1433986870-7014-1-git-send-email-firogm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1433986870-7014-1-git-send-email-firogm@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Firo Yang <firogm@gmail.com>
Cc: linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 11 Jun 2015 09:41:10 +0800
=46iro Yang <firogm@gmail.com> wrote:

> Warning like this:
>=20
> drivers/md/md.c: In function =E2=80=98update_array_info=E2=80=99:
> drivers/md/md.c:6394:26: warning: logical not is only applied
> to the left hand side of comparison [-Wlogical-not-parentheses]
>       !mddev->persistent  !=3D info->not_persistent||
>=20
> Fix it as Neil Brown said:
> mddev->persistent !=3D !info->not_persistent ||
>=20
> Signed-off-by: Firo Yang <firogm@gmail.com>
> ---
>  drivers/md/md.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index dd85be9..a3528b9 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6391,7 +6391,7 @@ static int update_array_info(struct mddev *mdde=
v, mdu_array_info_t *info)
>  	    mddev->ctime         !=3D info->ctime         ||
>  	    mddev->level         !=3D info->level         ||
>  /*	    mddev->layout        !=3D info->layout        || */
> -	    !mddev->persistent	 !=3D info->not_persistent||
> +	    mddev->persistent	 !=3D !info->not_persistent ||
>  	    mddev->chunk_sectors !=3D info->chunk_size >> 9 ||
>  	    /* ignore bottom 8 bits of state, and allow SB_BITMAP_PRESENT t=
o change */
>  	    ((state^info->state) & 0xfffffe00)


applied, thanks.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
