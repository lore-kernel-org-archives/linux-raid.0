From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: [PATCH] md: raid0: Simplify raid0_run().
Date: Thu, 14 May 2009 17:13:18 +0530
Message-ID: <37d33d830905140443y3e81ed8gf1dbb00843eb2864@mail.gmail.com>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
	 <1242297833-13908-7-git-send-email-maan@systemlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242297833-13908-7-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: neilb@suse.de, raziebe@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Andre,

On Thu, May 14, 2009 at 4:13 PM, Andre Noll <maan@systemlinux.org> wrot=
e:
> Get rid of the local variable "conf" and of an unnecessary cast.
>
> Signed-off-by: Andre Noll <maan@systemlinux.org>
> ---
> =A0drivers/md/raid0.c | =A0 20 +++++++-------------
> =A01 files changed, 7 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 5ff6290..36b747a 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -261,7 +261,6 @@ static sector_t raid0_size(mddev_t *mddev, sector=
_t sectors, int raid_disks)
>
> =A0static int raid0_run(mddev_t *mddev)
> =A0{
> - =A0 =A0 =A0 raid0_conf_t *conf;
> =A0 =A0 =A0 =A0int ret;
>
> =A0 =A0 =A0 =A0if (mddev->chunk_size =3D=3D 0) {
> @@ -276,14 +275,15 @@ static int raid0_run(mddev_t *mddev)
> =A0 =A0 =A0 =A0blk_queue_segment_boundary(mddev->queue, (mddev->chunk=
_size>>1) - 1);
> =A0 =A0 =A0 =A0mddev->queue->queue_lock =3D &mddev->queue->__queue_lo=
ck;
>
> - =A0 =A0 =A0 conf =3D kmalloc(sizeof (raid0_conf_t), GFP_KERNEL);
> - =A0 =A0 =A0 if (!conf)
> + =A0 =A0 =A0 mddev->private =3D kmalloc(sizeof(raid0_conf_t), GFP_KE=
RNEL);
> + =A0 =A0 =A0 if (!mddev->private)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
> - =A0 =A0 =A0 mddev->private =3D (void *)conf;
> -
> =A0 =A0 =A0 =A0ret =3D create_strip_zones(mddev);
> - =A0 =A0 =A0 if (ret < 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free_conf;
> + =A0 =A0 =A0 if (ret < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(mddev->private);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mddev->private =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 }
>


I believe the use of goto statements keep the code more structured,
especially for code cleanup in case of failures.
Its better that you revert back to the goto's so that later if a new
piece of code is added and there would be cases of failure to handle,
you will have a common cleanup routine.

I think Neil can comment better on this one.


> =A0 =A0 =A0 =A0/* calculate array device size */
> =A0 =A0 =A0 =A0md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
> @@ -305,14 +305,8 @@ static int raid0_run(mddev_t *mddev)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mddev->queue->backing_=
dev_info.ra_pages =3D 2* stripe;
> =A0 =A0 =A0 =A0}
>
> -
> =A0 =A0 =A0 =A0blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bve=
c);
> =A0 =A0 =A0 =A0return 0;
> -
> -out_free_conf:
> - =A0 =A0 =A0 kfree(conf);
> - =A0 =A0 =A0 mddev->private =3D NULL;
> - =A0 =A0 =A0 return ret;
> =A0}
>
> =A0static int raid0_stop (mddev_t *mddev)
> --
> 1.5.4.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
