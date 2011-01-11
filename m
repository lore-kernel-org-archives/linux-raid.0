From: =?UTF-8?B?UsOpbWkgUsOpcm9sbGU=?= <rrerolle@lacie.com>
Subject: Re: [PATCH] md: fix sync_completed reporting for very large drives
 (>2TB)
Date: Tue, 11 Jan 2011 11:37:54 +0100
Message-ID: <4D2C3302.2090708@lacie.com>
References: <1294155883-31421-1-git-send-email-remi.rerolle@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1294155883-31421-1-git-send-email-remi.rerolle@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?UsOpbWkgUsOpcm9sbGU=?= <remi.rerolle@gmail.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Le 04/01/2011 16:44, R=C3=A9mi R=C3=A9rolle a =C3=A9crit :
> From: R=C3=A9mi R=C3=A9rolle<rrerolle@lacie.com>
>
> The values exported in the sync_completed file are unsigned long, whi=
ch
> overflows with very large drives, resulting in wrong values reported.
>
> Since sync_completed uses sectors as unit, we'll start getting wrong
> values with components larger than 2TB.
>
> This patch simply replaces the use of unsigned long by unsigned long =
long.
>

Hi Neil,

What is the status for this patch ?

Thanks in advance!

> Signed-off-by: R=C3=A9mi R=C3=A9rolle<rrerolle@lacie.com>
> ---
>   drivers/md/md.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 175c424..ea46b3b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3912,7 +3912,7 @@ static struct md_sysfs_entry md_sync_speed =3D =
__ATTR_RO(sync_speed);
>   static ssize_t
>   sync_completed_show(mddev_t *mddev, char *page)
>   {
> -	unsigned long max_sectors, resync;
> +	unsigned long long max_sectors, resync;
>
>   	if (!test_bit(MD_RECOVERY_RUNNING,&mddev->recovery))
>   		return sprintf(page, "none\n");
> @@ -3923,7 +3923,7 @@ sync_completed_show(mddev_t *mddev, char *page)
>   		max_sectors =3D mddev->dev_sectors;
>
>   	resync =3D mddev->curr_resync_completed;
> -	return sprintf(page, "%lu / %lu\n", resync, max_sectors);
> +	return sprintf(page, "%llu / %llu\n", resync, max_sectors);
>   }
>
>   static struct md_sysfs_entry md_sync_completed =3D __ATTR_RO(sync_c=
ompleted);

--=20
R=C3=A9mi
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
