From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md linear: Protecting mddev with rcu locks to avoid races in
Date: Wed, 17 Jun 2009 19:59:43 +1000
Message-ID: <19000.48783.236367.948169@notabene.brown>
References: <37d33d830906060824u1bf71f1ej22efc3e8bbcaf2b9@mail.gmail.com>
	<18997.32786.206008.486995@notabene.brown>
	<37d33d830906162335j2dda043dn7e5c19d3b40de103@mail.gmail.com>
	<37d33d830906162346m725af61bg5356e2081f05ce74@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from SandeepKsinha on Wednesday June 17
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday June 17, sandeepksinha@gmail.com wrote:
> Here goes the updated patch.

The patch is corrupt.  It looks like there are about 15 lines missing
that the end (at least).

Also, you are still doing the locking inside which_dev.
I said
> =1B,A =1B(B That means we don't take rcu_read_lock in which_dev, but =
rather
> =1B,A =1B(B take it in the two functions that call which_dev.
>

and you said
> I have made that change.

Thanks,
NeilBrown




>=20
>=20
> commit 74da1595eb711b77969275070cda7516bac36f5e
> Signed-off-by: Sandeep K Sinha <sandeepksinha@gmail.com>
> Date:   Sat Jun 6 20:49:37 2009 +0530
> Due to the lack of memory ordering guarantees, we may have races arou=
nd
> mddev->conf. This patch addresses the same using rcu protection to av=
oid
> such race conditions.
>=20
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index 9ad6ec4..a56095c 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -28,9 +28,11 @@
>  static inline dev_info_t *which_dev(mddev_t *mddev, sector_t sector)
>  {
>  	int lo, mid, hi;
> -	linear_conf_t *conf =3D mddev_to_conf(mddev);
> +	linear_conf_t *conf;=09
>  =09
> +	rcu_read_lock();
>  	lo =3D 0;
> +	conf =3D rcu_dereference(mddev->private);
>  	hi =3D mddev->raid_disks - 1;
>=20
>  	/*
> @@ -45,7 +47,7 @@ static inline dev_info_t *which_dev(mddev_t *mddev,
> sector_t sector)
>  		else
>  			lo =3D mid + 1;
>  	}
> -
> +	rcu_read_unlock();
>  	return conf->disks + lo;
>  }
>=20
> @@ -86,36 +88,49 @@ static int linear_mergeable_bvec(struct request_q=
ueue *q,
>  static void linear_unplug(struct request_queue *q)
>  {
>  	mddev_t *mddev =3D q->queuedata;
> -	linear_conf_t *conf =3D mddev_to_conf(mddev);
> +	linear_conf_t *conf;
>  	int i;
>=20
> +	rcu_read_lock();
> +	conf =3D rcu_dereference(mddev->private);
> +=09
>  	for (i=3D0; i < mddev->raid_disks; i++) {
>  		struct request_queue *r_queue =3D bdev_get_queue(conf->disks[i].rd=
ev->bdev);
>  		blk_unplug(r_queue);
>  	}
> +	rcu_read_unlock();
>  }
>=20
>  static int linear_congested(void *data, int bits)
>  {
>  	mddev_t *mddev =3D data;
> -	linear_conf_t *conf =3D mddev_to_conf(mddev);
> +	linear_conf_t *conf;
>  	int i, ret =3D 0;
>=20
> +	rcu_read_lock();
> +	conf =3D rcu_dereference(mddev->private);
> +=09
>  	for (i =3D 0; i < mddev->raid_disks && !ret ; i++) {
>  		struct request_queue *q =3D bdev_get_queue(conf->disks[i].rdev->bd=
ev);
>  		ret |=3D bdi_congested(&q->backing_dev_info, bits);
>  	}
> +
> +	rcu_read_unlock();
>  	return ret;
>  }
>=20
>=20
> On Wed, Jun 17, 2009 at 12:05 PM, SandeepKsinha<sandeepksinha@gmail.c=
om> wrote:
> > Neil,
> >
> > On Mon, Jun 15, 2009 at 4:26 AM, Neil Brown<neilb@suse.de> wrote:
> >>
> >> Hi,
> >> =1B,A =1B(BThanks for this patch, and sorry for the delay in revie=
wing it.
> >>
> >> I have a few issues:
> >>
> >> On Saturday June 6, sandeepksinha@gmail.com wrote:
> >>> Signed-off-by: Sandeep K Sinha <sandeepksinha@gmail.com>
> >>>
> >>> =1B,A =1B(B =1B,A =1B(B Protecting mddev with barriers to avoid r=
aces.
> >>
> >> 1/ You need a lot more of an explanatory comment than this.
> >> =1B,A =1B(BAt least give some hint as to what the races are.
> >> =1B,A =1B(BGive than the rcu primitives are used, it now makes sen=
se to use
> >> =1B,A =1B(Be.g. call_rcu to free the old 'conf'. =1B,A =1B(BThat m=
ight reasonably be in a
> >> =1B,A =1B(Bseparate patch, but the comment on this patch should at=
 least at that
> >> =1B,A =1B(Bpossibility.
> >>>
> >
> > Sure. I shall do it for the final patch. I will also take care of t=
his
> > henceforth.
> >
> >>> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> >>> index 9ad6ec4..a56095c 100644
> >>> --- a/drivers/md/linear.c
> >>> +++ b/drivers/md/linear.c
> >>> @@ -28,9 +28,11 @@
> >>> =1B,A =1B(Bstatic inline dev_info_t *which_dev(mddev_t *mddev, se=
ctor_t sector)
> >>> =1B,A =1B(B{
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B int lo, mid, hi;
> >>> - =1B,A =1B(B =1B,A =1B(B linear_conf_t *conf =3D mddev_to_conf(m=
ddev);
> >>> + =1B,A =1B(B =1B,A =1B(B linear_conf_t *conf;
> >>>
> >>> + =1B,A =1B(B =1B,A =1B(B rcu_read_lock();
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B lo =3D 0;
> >>> + =1B,A =1B(B =1B,A =1B(B conf =3D rcu_dereference(mddev->private=
);
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B hi =3D mddev->raid_disks - 1;
> >>>
> >>
> >> 2/ mddev->raid_disks should really be dereferenced before 'conf'.
> >> =1B,A =1B(BDoing it the way you have done it, the 'raid_disks' val=
ue could be
> >> =1B,A =1B(Blarger than the value supported by the 'conf' so things=
 could
> >> =1B,A =1B(Bgo wrong.
> >>
> > Agreed. I hope you are referring to the case where a disk is in the
> > process of being added to an array. Is that right ?
> > Kindly confirm.
> >>
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B /*
> >>> @@ -45,7 +47,7 @@ static inline dev_info_t *which_dev(mddev_t *md=
dev,
> >>> sector_t sector)
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A=
 =1B(B =1B,A =1B(B else
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A=
 =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B lo =3D=
 mid + 1;
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B }
> >>> -
> >>> + =1B,A =1B(B =1B,A =1B(B rcu_read_unlock();
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B return conf->disks + lo;
> >>> =1B,A =1B(B}
> >>
> >> 3/ We are accessing conf->disks well after the rcu_lock has been r=
eleased.
> >> =1B,A =1B(B That is not exactly a problem with the code as it stan=
ds. =1B,A =1B(BBut if
> >> =1B,A =1B(B we do go ahead and free the old 'conf' with call_rcu, =
then this
> >> =1B,A =1B(B becomes racy.
> >> =1B,A =1B(B We should hold the rcu_read_lock for the entire time t=
hat we are
> >> =1B,A =1B(B accessing the contents of 'conf'.
> >>
> > True.
> >
> >> =1B,A =1B(B That means we don't take rcu_read_lock in which_dev, b=
ut rather
> >> =1B,A =1B(B take it in the two functions that call which_dev.
> >>
> >
> > I have made that change.
> >>>
> >>> @@ -86,36 +88,49 @@ static int linear_mergeable_bvec(struct reque=
st_queue *q,
> >>> =1B,A =1B(Bstatic void linear_unplug(struct request_queue *q)
> >>> =1B,A =1B(B{
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B mddev_t *mddev =3D q->queueda=
ta;
> >>> - =1B,A =1B(B =1B,A =1B(B linear_conf_t *conf =3D mddev_to_conf(m=
ddev);
> >>> + =1B,A =1B(B =1B,A =1B(B linear_conf_t *conf;
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B int i;
> >>>
> >>> + =1B,A =1B(B =1B,A =1B(B rcu_read_lock();
> >>> + =1B,A =1B(B =1B,A =1B(B conf =3D rcu_dereference(mddev->private=
);
> >>> +
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B for (i=3D0; i < mddev->raid_d=
isks; i++) {
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A=
 =1B(B =1B,A =1B(B struct request_queue *r_queue =3D bdev_get_queue(con=
f->disks[i].rdev->bdev);
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A=
 =1B(B =1B,A =1B(B blk_unplug(r_queue);
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B }
> >>> + =1B,A =1B(B =1B,A =1B(B rcu_read_unlock();
> >>> =1B,A =1B(B}
> >>>
> >>> =1B,A =1B(Bstatic int linear_congested(void *data, int bits)
> >>> =1B,A =1B(B{
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B mddev_t *mddev =3D data;
> >>> - =1B,A =1B(B =1B,A =1B(B linear_conf_t *conf =3D mddev_to_conf(m=
ddev);
> >>> + =1B,A =1B(B =1B,A =1B(B linear_conf_t *conf;
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B int i, ret =3D 0;
> >>>
> >>> + =1B,A =1B(B =1B,A =1B(B rcu_read_lock();
> >>> + =1B,A =1B(B =1B,A =1B(B conf =3D rcu_dereference(mddev->private=
);
> >>> +
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B for (i =3D 0; i < mddev->raid=
_disks && !ret ; i++) {
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A=
 =1B(B =1B,A =1B(B struct request_queue *q =3D bdev_get_queue(conf->dis=
ks[i].rdev->bdev);
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A=
 =1B(B =1B,A =1B(B ret |=3D bdi_congested(&q->backing_dev_info, bits);
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B }
> >>> +
> >>> + =1B,A =1B(B =1B,A =1B(B rcu_read_unlock();
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B return ret;
> >>> =1B,A =1B(B}
> >>>
> >>> =1B,A =1B(Bstatic sector_t linear_size(mddev_t *mddev, sector_t s=
ectors, int raid_disks)
> >>> =1B,A =1B(B{
> >>> - =1B,A =1B(B =1B,A =1B(B linear_conf_t *conf =3D mddev_to_conf(m=
ddev);
> >>> -
> >>> + =1B,A =1B(B =1B,A =1B(B linear_conf_t *conf;
> >>> + =1B,A =1B(B =1B,A =1B(B sector_t array_sectors;
> >>> + =1B,A =1B(B =1B,A =1B(B rcu_read_lock();
> >>> + =1B,A =1B(B =1B,A =1B(B conf =3D rcu_dereference(mddev->private=
);
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B WARN_ONCE(sectors || raid_dis=
ks,
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A=
 =1B(B =1B,A =1B(B =1B,A =1B(B "%s does not support generic reshape\n",=
 __func__);
> >>> -
> >>> - =1B,A =1B(B =1B,A =1B(B return conf->array_sectors;
> >>> + =1B,A =1B(B =1B,A =1B(B array_sectors =3D conf->array_sectors;
> >>> + =1B,A =1B(B =1B,A =1B(B rcu_read_unlock();
> >>> +
> >>> + =1B,A =1B(B =1B,A =1B(B return array_sectors;
> >>> =1B,A =1B(B}
> >>>
> >>> =1B,A =1B(Bstatic linear_conf_t *linear_conf(mddev_t *mddev, int =
raid_disks)
> >>> @@ -215,15 +230,14 @@ static int linear_add(mddev_t *mddev, mdk_r=
dev_t *rdev)
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A=
 =1B(B =1B,A =1B(B return -EINVAL;
> >>>
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B rdev->raid_disk =3D rdev->sav=
ed_raid_disk;
> >>> -
> >>> - =1B,A =1B(B =1B,A =1B(B newconf =3D linear_conf(mddev,mddev->ra=
id_disks+1);
> >>> + =1B,A =1B(B =1B,A =1B(B newconf =3D linear_conf(mddev,mddev->ra=
id_disks + 1);
> >>>
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B if (!newconf)
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A=
 =1B(B =1B,A =1B(B return -ENOMEM;
> >>>
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B newconf->prev =3D mddev_to_co=
nf(mddev);
> >>> - =1B,A =1B(B =1B,A =1B(B mddev->private =3D newconf;
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B mddev->raid_disks++;
> >>> + =1B,A =1B(B =1B,A =1B(B rcu_assign_pointer(mddev->private,newco=
nf);
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B md_set_array_sectors(mddev, l=
inear_size(mddev, 0, 0));
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B set_capacity(mddev->gendisk, =
mddev->array_sectors);
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B return 0;
> >>> @@ -231,14 +245,17 @@ static int linear_add(mddev_t *mddev, mdk_r=
dev_t *rdev)
> >>>
> >>> =1B,A =1B(Bstatic int linear_stop (mddev_t *mddev)
> >>> =1B,A =1B(B{
> >>> - =1B,A =1B(B =1B,A =1B(B linear_conf_t *conf =3D mddev_to_conf(m=
ddev);
> >>> -
> >>> + =1B,A =1B(B =1B,A =1B(B linear_conf_t *conf;
> >>> +
> >>> + =1B,A =1B(B =1B,A =1B(B rcu_read_lock();
> >>> + =1B,A =1B(B =1B,A =1B(B conf =3D rcu_dereference(mddev->private=
);
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B blk_sync_queue(mddev->queue);=
 /* the unplug fn references 'conf'*/
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B do {
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A=
 =1B(B =1B,A =1B(B linear_conf_t *t =3D conf->prev;
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A=
 =1B(B =1B,A =1B(B kfree(conf);
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B =1B,A=
 =1B(B =1B,A =1B(B conf =3D t;
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B } while (conf);
> >>> + =1B,A =1B(B =1B,A =1B(B rcu_read_unlock();
> >>>
> >>
> >> 4/ We don't need the rcu protection here as we hold ->reconfig_mut=
ex
> >> =1B,A =1B(B both in linear_add and linear_stop, so they cannot rac=
e.
> >> =1B,A =1B(B Adding a comment to this effect might be a good idea t=
hough.
> >>
> >
> > Fine. Shall do this as well.
> >
> > The new patch will follow soon.
> >
> >> Thanks,
> >>
> >> NeilBrown
> >>
> >>
> >>> =1B,A =1B(B =1B,A =1B(B =1B,A =1B(B return 0;
> >>> =1B,A =1B(B}
> >>> --
> >>> Regards,
> >>> Sandeep.
> >>>
> >>>
> >>>
> >>>
> >>>
> >>>
> >>> =93To learn is to change. Education is a process that changes the=
 learner.=94
> >>
> >
> >
> >
> > --
> > Regards,
> > Sandeep.
> >
> >
> >
> >
> >
> >
> > =93To learn is to change. Education is a process that changes the l=
earner.=94
> >
>=20
>=20
>=20
> --=20
> Regards,
> Sandeep.
>=20
>=20
>=20
>=20
>=20
>  =09
> =93To learn is to change. Education is a process that changes the lea=
rner.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
