From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v4 2/2] md/r5cache: gracefully handle journal device
 errors for writeback mode
Date: Wed, 10 May 2017 21:45:05 +0000
Message-ID: <72F7A8AB-A6BD-4C52-B8AF-11C5E71CFEF4@fb.com>
References: <20170509003925.3480693-1-songliubraving@fb.com>
 <20170509003925.3480693-2-songliubraving@fb.com>
 <20170510170043.4v4ijoxmfty6hndf@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170510170043.4v4ijoxmfty6hndf@kernel.org>
Content-Language: en-US
Content-ID: <FE503093F40DCD44A15203E399F775AC@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, "neilb@suse.com" <neilb@suse.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
List-Id: linux-raid.ids


> On May 10, 2017, at 10:01 AM, Shaohua Li <shli@kernel.org> wrote:
>=20
> On Mon, May 08, 2017 at 05:39:25PM -0700, Song Liu wrote:
>> For the raid456 with writeback cache, when journal device failed during
>> normal operation, it is still possible to persist all data, as all
>> pending data is still in stripe cache. However, it is necessary to handl=
e
>> journal failure gracefully.
>>=20
>> During journal failures, this patch makes the follow changes to land dat=
a
>> in cache to raid disks gracefully:
>>=20
>> 1. In handle_stripe(), allow stripes with data in journal (s.injournal >=
 0)
>>   to make progress;
>> 2. In delay_towrite(), only process data in the cache (skip dev->towrite=
);
>> 3. In __get_priority_stripe(), set try_loprio to true, so no stripe stuc=
k
>>   in loprio_list
>=20
> Applied the first patch. For this patch, I don't have a clear picture abo=
ut
> what you are trying to do. Please describe the steps we are doing to do a=
fter
> journal failure.

I will add more description to the next version.=20

>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> drivers/md/raid5-cache.c | 13 ++++++++++---
>> drivers/md/raid5-log.h   |  3 ++-
>> drivers/md/raid5.c       | 29 +++++++++++++++++++++++------
>> 3 files changed, 35 insertions(+), 10 deletions(-)
>>=20
>> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
>> index dc1dba6..e6032f6 100644
>> --- a/drivers/md/raid5-cache.c
>> +++ b/drivers/md/raid5-cache.c
>> @@ -24,6 +24,7 @@
>> #include "md.h"
>> #include "raid5.h"
>> #include "bitmap.h"
>> +#include "raid5-log.h"
>>=20
>> /*
>>  * metadata/data stored in disk with 4k size unit (a block) regardless
>> @@ -679,6 +680,7 @@ static void r5c_disable_writeback_async(struct work_=
struct *work)
>> 		return;
>> 	pr_info("md/raid:%s: Disabling writeback cache for degraded array.\n",
>> 		mdname(mddev));
>> +	md_update_sb(mddev, 1);
>=20
> Why this? And md_update_sb must be called within mddev->reconfig_mutex lo=
cked.

This is to avoid skipping in handle_stripe():

        if (s.handle_bad_blocks ||
            test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags)) {
                set_bit(STRIPE_HANDLE, &sh->state);
                goto finish;
        }

I haven't got a better idea than calling md_update_sb() somewhere. It is al=
so tricky
to lock mddev->reconfigured_mutex here, due to potential deadlocking with=20
mddev->open_mutex.=20

Do you have suggestions on this?


>> 	mddev_suspend(mddev);
>> 	log->r5c_journal_mode =3D R5C_JOURNAL_MODE_WRITE_THROUGH;
>> 	mddev_resume(mddev);
>> @@ -1557,6 +1559,8 @@ void r5l_wake_reclaim(struct r5l_log *log, sector_=
t space)
>> void r5l_quiesce(struct r5l_log *log, int state)
>> {
>> 	struct mddev *mddev;
>> +	struct r5conf *conf;
>> +
>> 	if (!log || state =3D=3D 2)
>> 		return;
>> 	if (state =3D=3D 0)
>> @@ -1564,10 +1568,12 @@ void r5l_quiesce(struct r5l_log *log, int state)
>> 	else if (state =3D=3D 1) {
>> 		/* make sure r5l_write_super_and_discard_space exits */
>> 		mddev =3D log->rdev->mddev;
>> +		conf =3D mddev->private;
>> 		wake_up(&mddev->sb_wait);
>> 		kthread_park(log->reclaim_thread->tsk);
>> 		r5l_wake_reclaim(log, MaxSector);
>> -		r5l_do_reclaim(log);
>> +		if (!r5l_log_disk_error(conf))
>> +			r5l_do_reclaim(log);
>=20
> I think r5c_disable_writeback_async() will call into this, so we flush al=
l
> stripe cache out to raid disks, why skip the reclaim?
>=20

r5l_do_reclaim() reclaims log space with 2 steps:
1. clear all io_unit lists (flushing_ios, etc.) by waking up mddev->thread.=
=20
2. update log_tail in the journal device, and issue discard to journal devi=
ce.=20

When we are handling log failures in r5c_disable_writeback_async(), we are=
=20
flushing the cache, so it is not necessary to wake up mddev->thread. Also,=
=20
with log device error, it is not necessary update log_tail or issue discard=
.=20

Therefore, r5l_do_reclaim is not necessary in log disk errors.=20

Thanks,
Song

