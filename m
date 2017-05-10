From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v4 2/2] md/r5cache: gracefully handle journal device
 errors for writeback mode
Date: Wed, 10 May 2017 23:58:38 +0000
Message-ID: <833FC4FB-3EF0-4757-85DE-F75D061DDF13@fb.com>
References: <20170509003925.3480693-1-songliubraving@fb.com>
 <20170509003925.3480693-2-songliubraving@fb.com>
 <20170510170043.4v4ijoxmfty6hndf@kernel.org>
 <72F7A8AB-A6BD-4C52-B8AF-11C5E71CFEF4@fb.com>
 <20170510225103.gc34fpaqmesvadgi@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170510225103.gc34fpaqmesvadgi@kernel.org>
Content-Language: en-US
Content-ID: <45DF8F7A1C47444D9ECB1D7804FBFB78@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, "neilb@suse.com" <neilb@suse.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
List-Id: linux-raid.ids


> On May 10, 2017, at 3:51 PM, Shaohua Li <shli@kernel.org> wrote:
>=20
> On Wed, May 10, 2017 at 09:45:05PM +0000, Song Liu wrote:
>>=20
>>> On May 10, 2017, at 10:01 AM, Shaohua Li <shli@kernel.org> wrote:
>>>=20
>>> On Mon, May 08, 2017 at 05:39:25PM -0700, Song Liu wrote:
>>>> For the raid456 with writeback cache, when journal device failed durin=
g
>>>> normal operation, it is still possible to persist all data, as all
>>>> pending data is still in stripe cache. However, it is necessary to han=
dle
>>>> journal failure gracefully.
>>>>=20
>>>> During journal failures, this patch makes the follow changes to land d=
ata
>>>> in cache to raid disks gracefully:
>>>>=20
>>>> 1. In handle_stripe(), allow stripes with data in journal (s.injournal=
 > 0)
>>>>  to make progress;
>>>> 2. In delay_towrite(), only process data in the cache (skip dev->towri=
te);
>>>> 3. In __get_priority_stripe(), set try_loprio to true, so no stripe st=
uck
>>>>  in loprio_list
>>>=20
>>> Applied the first patch. For this patch, I don't have a clear picture a=
bout
>>> what you are trying to do. Please describe the steps we are doing to do=
 after
>>> journal failure.
>>=20
>> I will add more description to the next version.=20
>>=20
>>>=20
>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>> ---
>>>> drivers/md/raid5-cache.c | 13 ++++++++++---
>>>> drivers/md/raid5-log.h   |  3 ++-
>>>> drivers/md/raid5.c       | 29 +++++++++++++++++++++++------
>>>> 3 files changed, 35 insertions(+), 10 deletions(-)
>>>>=20
>>>> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
>>>> index dc1dba6..e6032f6 100644
>>>> --- a/drivers/md/raid5-cache.c
>>>> +++ b/drivers/md/raid5-cache.c
>>>> @@ -24,6 +24,7 @@
>>>> #include "md.h"
>>>> #include "raid5.h"
>>>> #include "bitmap.h"
>>>> +#include "raid5-log.h"
>>>>=20
>>>> /*
>>>> * metadata/data stored in disk with 4k size unit (a block) regardless
>>>> @@ -679,6 +680,7 @@ static void r5c_disable_writeback_async(struct wor=
k_struct *work)
>>>> 		return;
>>>> 	pr_info("md/raid:%s: Disabling writeback cache for degraded array.\n"=
,
>>>> 		mdname(mddev));
>>>> +	md_update_sb(mddev, 1);
>>>=20
>>> Why this? And md_update_sb must be called within mddev->reconfig_mutex =
locked.
>>=20
>> This is to avoid skipping in handle_stripe():
>>=20
>>        if (s.handle_bad_blocks ||
>>            test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags)) {
>>                set_bit(STRIPE_HANDLE, &sh->state);
>>                goto finish;
>>        }
>>=20
>> I haven't got a better idea than calling md_update_sb() somewhere. It is=
 also tricky
>> to lock mddev->reconfigured_mutex here, due to potential deadlocking wit=
h=20
>> mddev->open_mutex.=20
>>=20
>> Do you have suggestions on this?
>=20
> This sounds not necessary then. The mddev->thread will call md_update_sb =
and
> clear the MD_SB_CHANGE_PENDING bit. After that, the stripes will be handl=
ed.
> This is running in a workqueue, I'm wondering what kind of deadlock issue=
 there
> is.

mddev->thread calls md_check_recovery() in raid5d(), and md_check_recovery(=
)=20
calls md_update_sb(). However, we need to call md_update_sb() before=20
mddev_suspend() here. Otherwise, mddev_suspend() will increase mddev->suspe=
nded
and then md_check_recovery() will exit before calling md_update_sb().=20

The deadlock of reconfig_mutex and open_mutex is as the following:

[  211.753343] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  211.753823] [ INFO: possible circular locking dependency detected ]
[  211.754310] 4.11.0+ #88 Not tainted
[  211.754582] -------------------------------------------------------
[  211.755079] mdadm/1582 is trying to acquire lock:
[  211.755444]  ((&log->disable_writeback_work)){+.+...}, at: [<ffffffff810=
7d842>] flush_work+0x12/0x290
[  211.756160]
[  211.756160] but task is already holding lock:
[  211.756609]  (&mddev->reconfig_mutex){+.+.+.}, at: [<ffffffffa0052654>] =
rdev_attr_store+0x64/0xd0 [md_mod]
[  211.757354]
[  211.757354] which lock already depends on the new lock.
[  211.757354]
[  211.757984]
[  211.757984] the existing dependency chain (in reverse order) is:
[  211.758560]
[  211.758560] -> #1 (&mddev->reconfig_mutex){+.+.+.}:
[  211.759062]        lock_acquire+0xc2/0x230
[  211.759391]        __mutex_lock+0x7b/0x9d0
[  211.759716]        mutex_lock_interruptible_nested+0x1b/0x20
[  211.760158]        r5c_disable_writeback_async+0x6b/0xa0 [raid456]
[  211.760634]        process_one_work+0x1d6/0x650
[  211.760986]        worker_thread+0x4d/0x380
[  211.761311]        kthread+0x117/0x150
[  211.761602]        ret_from_fork+0x2e/0x40
[  211.761924]
[  211.761924] -> #0 ((&log->disable_writeback_work)){+.+...}:
[  211.762470]        __lock_acquire+0x1458/0x1770
[  211.762825]        lock_acquire+0xc2/0x230
[  211.763149]        flush_work+0x4a/0x290
[  211.763457]        r5l_exit_log+0x31/0x80 [raid456]
[  211.763840]        raid5_remove_disk+0x8a/0x240 [raid456]
[  211.764265]        remove_and_add_spares+0x175/0x390 [md_mod]
[  211.764714]        state_store+0xa3/0x4f0 [md_mod]
[  211.765090]        rdev_attr_store+0x89/0xd0 [md_mod]
[  211.765486]        sysfs_kf_write+0x4f/0x70
[  211.765815]        kernfs_fop_write+0x147/0x1d0
[  211.766170]        __vfs_write+0x28/0x120
[  211.766485]        vfs_write+0xd3/0x1d0
[  211.766789]        SyS_write+0x52/0xa0
[  211.767083]        do_syscall_64+0x6a/0x210
[  211.767408]        return_from_SYSCALL_64+0x0/0x7a
[  211.767782]
[  211.767782] other info that might help us debug this:
[  211.767782]
[  211.768399]  Possible unsafe locking scenario:
[  211.768399]
[  211.768861]        CPU0                    CPU1
[  211.769214]        ----                    ----
[  211.769567]   lock(&mddev->reconfig_mutex);
[  211.769897]                                lock((&log->disable_writeback=
_work));
[  211.770471]                                lock(&mddev->reconfig_mutex);
[  211.770993]   lock((&log->disable_writeback_work));

>=20
>>=20
>>>> 	mddev_suspend(mddev);
>>>> 	log->r5c_journal_mode =3D R5C_JOURNAL_MODE_WRITE_THROUGH;
>>>> 	mddev_resume(mddev);
>>>> @@ -1557,6 +1559,8 @@ void r5l_wake_reclaim(struct r5l_log *log, secto=
r_t space)
>>>> void r5l_quiesce(struct r5l_log *log, int state)
>>>> {
>>>> 	struct mddev *mddev;
>>>> +	struct r5conf *conf;
>>>> +
>>>> 	if (!log || state =3D=3D 2)
>>>> 		return;
>>>> 	if (state =3D=3D 0)
>>>> @@ -1564,10 +1568,12 @@ void r5l_quiesce(struct r5l_log *log, int stat=
e)
>>>> 	else if (state =3D=3D 1) {
>>>> 		/* make sure r5l_write_super_and_discard_space exits */
>>>> 		mddev =3D log->rdev->mddev;
>>>> +		conf =3D mddev->private;
>>>> 		wake_up(&mddev->sb_wait);
>>>> 		kthread_park(log->reclaim_thread->tsk);
>>>> 		r5l_wake_reclaim(log, MaxSector);
>>>> -		r5l_do_reclaim(log);
>>>> +		if (!r5l_log_disk_error(conf))
>>>> +			r5l_do_reclaim(log);
>>>=20
>>> I think r5c_disable_writeback_async() will call into this, so we flush =
all
>>> stripe cache out to raid disks, why skip the reclaim?
>>>=20
>>=20
>> r5l_do_reclaim() reclaims log space with 2 steps:
>> 1. clear all io_unit lists (flushing_ios, etc.) by waking up mddev->thre=
ad.=20
>> 2. update log_tail in the journal device, and issue discard to journal d=
evice.=20
>>=20
>> When we are handling log failures in r5c_disable_writeback_async(), we a=
re=20
>> flushing the cache, so it is not necessary to wake up mddev->thread. Als=
o,=20
>> with log device error, it is not necessary update log_tail or issue disc=
ard.=20
>>=20
>> Therefore, r5l_do_reclaim is not necessary in log disk errors.=20
>=20
> Ok, there is no side effect, right? let's call it anyway.

Let me double check potential side effect. If it is safe, I will remove it.=
=20

Thanks,
Song=
