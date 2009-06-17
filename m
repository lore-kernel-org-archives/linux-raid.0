From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: [PATCH] md linear: Protecting mddev with rcu locks to avoid races
	in
Date: Wed, 17 Jun 2009 12:05:59 +0530
Message-ID: <37d33d830906162335j2dda043dn7e5c19d3b40de103@mail.gmail.com>
References: <37d33d830906060824u1bf71f1ej22efc3e8bbcaf2b9@mail.gmail.com>
	 <18997.32786.206008.486995@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18997.32786.206008.486995@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

On Mon, Jun 15, 2009 at 4:26 AM, Neil Brown<neilb@suse.de> wrote:
>
> Hi,
> =A0Thanks for this patch, and sorry for the delay in reviewing it.
>
> I have a few issues:
>
> On Saturday June 6, sandeepksinha@gmail.com wrote:
>> Signed-off-by: Sandeep K Sinha <sandeepksinha@gmail.com>
>>
>> =A0 =A0 Protecting mddev with barriers to avoid races.
>
> 1/ You need a lot more of an explanatory comment than this.
> =A0At least give some hint as to what the races are.
> =A0Give than the rcu primitives are used, it now makes sense to use
> =A0e.g. call_rcu to free the old 'conf'. =A0That might reasonably be =
in a
> =A0separate patch, but the comment on this patch should at least at t=
hat
> =A0possibility.
>>

Sure. I shall do it for the final patch. I will also take care of this
henceforth.

>> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
>> index 9ad6ec4..a56095c 100644
>> --- a/drivers/md/linear.c
>> +++ b/drivers/md/linear.c
>> @@ -28,9 +28,11 @@
>> =A0static inline dev_info_t *which_dev(mddev_t *mddev, sector_t sect=
or)
>> =A0{
>> =A0 =A0 =A0 int lo, mid, hi;
>> - =A0 =A0 linear_conf_t *conf =3D mddev_to_conf(mddev);
>> + =A0 =A0 linear_conf_t *conf;
>>
>> + =A0 =A0 rcu_read_lock();
>> =A0 =A0 =A0 lo =3D 0;
>> + =A0 =A0 conf =3D rcu_dereference(mddev->private);
>> =A0 =A0 =A0 hi =3D mddev->raid_disks - 1;
>>
>
> 2/ mddev->raid_disks should really be dereferenced before 'conf'.
> =A0Doing it the way you have done it, the 'raid_disks' value could be
> =A0larger than the value supported by the 'conf' so things could
> =A0go wrong.
>
Agreed. I hope you are referring to the case where a disk is in the
process of being added to an array. Is that right ?
Kindly confirm.
>
>> =A0 =A0 =A0 /*
>> @@ -45,7 +47,7 @@ static inline dev_info_t *which_dev(mddev_t *mddev=
,
>> sector_t sector)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lo =3D mid + 1;
>> =A0 =A0 =A0 }
>> -
>> + =A0 =A0 rcu_read_unlock();
>> =A0 =A0 =A0 return conf->disks + lo;
>> =A0}
>
> 3/ We are accessing conf->disks well after the rcu_lock has been rele=
ased.
> =A0 That is not exactly a problem with the code as it stands. =A0But =
if
> =A0 we do go ahead and free the old 'conf' with call_rcu, then this
> =A0 becomes racy.
> =A0 We should hold the rcu_read_lock for the entire time that we are
> =A0 accessing the contents of 'conf'.
>
True.

> =A0 That means we don't take rcu_read_lock in which_dev, but rather
> =A0 take it in the two functions that call which_dev.
>

I have made that change.
>>
>> @@ -86,36 +88,49 @@ static int linear_mergeable_bvec(struct request_=
queue *q,
>> =A0static void linear_unplug(struct request_queue *q)
>> =A0{
>> =A0 =A0 =A0 mddev_t *mddev =3D q->queuedata;
>> - =A0 =A0 linear_conf_t *conf =3D mddev_to_conf(mddev);
>> + =A0 =A0 linear_conf_t *conf;
>> =A0 =A0 =A0 int i;
>>
>> + =A0 =A0 rcu_read_lock();
>> + =A0 =A0 conf =3D rcu_dereference(mddev->private);
>> +
>> =A0 =A0 =A0 for (i=3D0; i < mddev->raid_disks; i++) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct request_queue *r_queue =3D bdev_g=
et_queue(conf->disks[i].rdev->bdev);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk_unplug(r_queue);
>> =A0 =A0 =A0 }
>> + =A0 =A0 rcu_read_unlock();
>> =A0}
>>
>> =A0static int linear_congested(void *data, int bits)
>> =A0{
>> =A0 =A0 =A0 mddev_t *mddev =3D data;
>> - =A0 =A0 linear_conf_t *conf =3D mddev_to_conf(mddev);
>> + =A0 =A0 linear_conf_t *conf;
>> =A0 =A0 =A0 int i, ret =3D 0;
>>
>> + =A0 =A0 rcu_read_lock();
>> + =A0 =A0 conf =3D rcu_dereference(mddev->private);
>> +
>> =A0 =A0 =A0 for (i =3D 0; i < mddev->raid_disks && !ret ; i++) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct request_queue *q =3D bdev_get_que=
ue(conf->disks[i].rdev->bdev);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret |=3D bdi_congested(&q->backing_dev_i=
nfo, bits);
>> =A0 =A0 =A0 }
>> +
>> + =A0 =A0 rcu_read_unlock();
>> =A0 =A0 =A0 return ret;
>> =A0}
>>
>> =A0static sector_t linear_size(mddev_t *mddev, sector_t sectors, int=
 raid_disks)
>> =A0{
>> - =A0 =A0 linear_conf_t *conf =3D mddev_to_conf(mddev);
>> -
>> + =A0 =A0 linear_conf_t *conf;
>> + =A0 =A0 sector_t array_sectors;
>> + =A0 =A0 rcu_read_lock();
>> + =A0 =A0 conf =3D rcu_dereference(mddev->private);
>> =A0 =A0 =A0 WARN_ONCE(sectors || raid_disks,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "%s does not support generic reshape=
\n", __func__);
>> -
>> - =A0 =A0 return conf->array_sectors;
>> + =A0 =A0 array_sectors =3D conf->array_sectors;
>> + =A0 =A0 rcu_read_unlock();
>> +
>> + =A0 =A0 return array_sectors;
>> =A0}
>>
>> =A0static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
>> @@ -215,15 +230,14 @@ static int linear_add(mddev_t *mddev, mdk_rdev=
_t *rdev)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>>
>> =A0 =A0 =A0 rdev->raid_disk =3D rdev->saved_raid_disk;
>> -
>> - =A0 =A0 newconf =3D linear_conf(mddev,mddev->raid_disks+1);
>> + =A0 =A0 newconf =3D linear_conf(mddev,mddev->raid_disks + 1);
>>
>> =A0 =A0 =A0 if (!newconf)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>>
>> =A0 =A0 =A0 newconf->prev =3D mddev_to_conf(mddev);
>> - =A0 =A0 mddev->private =3D newconf;
>> =A0 =A0 =A0 mddev->raid_disks++;
>> + =A0 =A0 rcu_assign_pointer(mddev->private,newconf);
>> =A0 =A0 =A0 md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
>> =A0 =A0 =A0 set_capacity(mddev->gendisk, mddev->array_sectors);
>> =A0 =A0 =A0 return 0;
>> @@ -231,14 +245,17 @@ static int linear_add(mddev_t *mddev, mdk_rdev=
_t *rdev)
>>
>> =A0static int linear_stop (mddev_t *mddev)
>> =A0{
>> - =A0 =A0 linear_conf_t *conf =3D mddev_to_conf(mddev);
>> -
>> + =A0 =A0 linear_conf_t *conf;
>> +
>> + =A0 =A0 rcu_read_lock();
>> + =A0 =A0 conf =3D rcu_dereference(mddev->private);
>> =A0 =A0 =A0 blk_sync_queue(mddev->queue); /* the unplug fn reference=
s 'conf'*/
>> =A0 =A0 =A0 do {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 linear_conf_t *t =3D conf->prev;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(conf);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 conf =3D t;
>> =A0 =A0 =A0 } while (conf);
>> + =A0 =A0 rcu_read_unlock();
>>
>
> 4/ We don't need the rcu protection here as we hold ->reconfig_mutex
> =A0 both in linear_add and linear_stop, so they cannot race.
> =A0 Adding a comment to this effect might be a good idea though.
>

=46ine. Shall do this as well.

The new patch will follow soon.

> Thanks,
>
> NeilBrown
>
>
>> =A0 =A0 =A0 return 0;
>> =A0}
>> --
>> Regards,
>> Sandeep.
>>
>>
>>
>>
>>
>>
>> =93To learn is to change. Education is a process that changes the le=
arner.=94
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
