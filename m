From: Raz <raziebe@gmail.com>
Subject: Re: [PATCH 1/2] md: Push down reconstruction log message to
	personality code.
Date: Fri, 29 May 2009 23:49:40 +0300
Message-ID: <5d96567b0905291349j211073e3qa9112e1a6c5337c7@mail.gmail.com>
References: <1243603122-11116-1-git-send-email-maan@systemlinux.org>
	<1243603122-11116-2-git-send-email-maan@systemlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1243603122-11116-2-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Meil/Andre Hello
I am happy to see this patch. I have lots of "md" mess with the raid0
reshape because of some md "assumptions".
1. in md_do_sync , max_sectors is determined to be dev_sectors.
Currently I had to patch to be
   array_sectors in the case of level=3D0.
2.  in procedure super_90_sync the minor version is determined  by the
reshape position ?
     So now, when i reshape I see that the minor version simply changes=
 .

thank you
raz


On Fri, May 29, 2009 at 4:18 PM, Andre Noll <maan@systemlinux.org> wrot=
e:
> Currently, the md layer checks in analyze_sbs() if the raid level
> supports reconstruction (mddev->level >=3D 1) and if reconstruction i=
s
> in progress (mddev->recovery_cp !=3D MaxSector).
>
> Move that printk into the personality code of those raid levels that
> care (levels 1, 4, 5, 6, 10).
>
> Signed-off-by: Andre Noll <maan@systemlinux.org>
> ---
> =A0drivers/md/md.c =A0 =A0 | =A0 =A09 ---------
> =A0drivers/md/raid1.c =A0| =A0 =A04 ++++
> =A0drivers/md/raid10.c | =A0 =A04 ++++
> =A0drivers/md/raid5.c =A0| =A0 =A04 ++++
> =A04 files changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index a54ec91..1d71cc2 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2597,15 +2597,6 @@ static void analyze_sbs(mddev_t * mddev)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0clear_bit(In_sync, &rd=
ev->flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
> -
> -
> -
> - =A0 =A0 =A0 if (mddev->recovery_cp !=3D MaxSector &&
> - =A0 =A0 =A0 =A0 =A0 mddev->level >=3D 1)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR "md: %s: raid array is =
not clean"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0" -- starting background=
 reconstruction\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mdname(mddev));
> -
> =A0}
>
> =A0static void md_safemode_timeout(unsigned long data);
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 4692a8a..d29842f 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2052,6 +2052,10 @@ static int run(mddev_t *mddev)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_free_conf;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 if (mddev->recovery_cp !=3D MaxSector)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_NOTICE "raid1: %s is not cl=
ean"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0" -- starting background=
 reconstruction\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mdname(mddev));
> =A0 =A0 =A0 =A0printk(KERN_INFO
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"raid1: raid set %s active with %d out=
 of %d mirrors\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mdname(mddev), mddev->raid_disks - mdd=
ev->degraded,
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index d75cb96..c317543 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2186,6 +2186,10 @@ static int run(mddev_t *mddev)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_free_conf;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 if (mddev->recovery_cp !=3D MaxSector)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_NOTICE "raid10: %s is not c=
lean"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0" -- starting background=
 reconstruction\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mdname(mddev));
> =A0 =A0 =A0 =A0printk(KERN_INFO
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"raid10: raid set %s active with %d ou=
t of %d devices\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mdname(mddev), mddev->raid_disks - mdd=
ev->degraded,
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 9ec505b..cdd5b49 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4454,6 +4454,10 @@ static int run(mddev_t *mddev)
> =A0 =A0 =A0 =A0int working_disks =3D 0;
> =A0 =A0 =A0 =A0mdk_rdev_t *rdev;
>
> + =A0 =A0 =A0 if (mddev->recovery_cp !=3D MaxSector)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_NOTICE "raid5: %s is not cl=
ean"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0" -- starting background=
 reconstruction\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mdname(mddev));
> =A0 =A0 =A0 =A0if (mddev->reshape_position !=3D MaxSector) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Check that we can continue the resh=
ape.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * Currently only disks can change, it=
 must
> --
> 1.5.4.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
