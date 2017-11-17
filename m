From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2] md: introduce new personality funciton start()
Date: Fri, 17 Nov 2017 20:23:59 +0000
Message-ID: <E959CA9E-E05D-407C-A1A7-DD09A9C8E765@fb.com>
References: <20171116181244.3552262-1-songliubraving@fb.com>
 <20171117192122.ewxsumxakb2rkzt7@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171117192122.ewxsumxakb2rkzt7@kernel.org>
Content-Language: en-US
Content-ID: <C6F8930EEA97834DB2B6F825BDD09B68@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, NeilBrown <neilb@suse.com>, "artur.paszkiewicz@intel.com" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids


> On Nov 17, 2017, at 11:21 AM, Shaohua Li <shli@kernel.org> wrote:
>=20
> On Thu, Nov 16, 2017 at 10:12:44AM -0800, Song Liu wrote:
>> In do_md_run(), md threads should not wake up until the array is fully
>> initialized in md_run(). However, in raid5_run(), raid5-cache may wake
>> up mddev->thread to flush stripes that need to be written back. This
>> design doesn't break badly right now. But it could lead to bad bug in
>> the future.
>>=20
>> This patch tries to resolve this problem by splitting start up work
>> into two personality functions, run() and start(). Tasks that do not
>> require the md threads should go into run(), while task that require
>> the md threads go into start().
>>=20
>> r5l_load_log() is moved to raid5_start(), so it is not called until
>> the md threads are started in do_md_run().
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> drivers/md/md.c          | 13 ++++++++-----
>> drivers/md/md.h          |  5 +++++
>> drivers/md/raid5-cache.c | 22 +++++++++++++++++-----
>> drivers/md/raid5-log.h   |  1 +
>> drivers/md/raid5.c       | 10 ++++++++++
>> 5 files changed, 41 insertions(+), 10 deletions(-)
>>=20
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index e014d39..afeab7b 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -5561,11 +5561,6 @@ int md_run(struct mddev *mddev)
>> 	if (start_readonly && mddev->ro =3D=3D 0)
>> 		mddev->ro =3D 2; /* read-only, but switch on first write */
>>=20
>> -	/*
>> -	 * NOTE: some pers->run(), for example r5l_recovery_log(), wakes
>> -	 * up mddev->thread. It is important to initialize critical
>> -	 * resources for mddev->thread BEFORE calling pers->run().
>> -	 */
>> 	err =3D pers->run(mddev);
>> 	if (err)
>> 		pr_warn("md: pers->run() failed ...\n");
>> @@ -5680,6 +5675,14 @@ static int do_md_run(struct mddev *mddev)
>> 		md_allow_write(mddev);
>>=20
>> 	md_wakeup_thread(mddev->thread);
>> +	/* run start up tasks that require md_thread */
>> +	if (mddev->pers->start) {
>> +		err =3D mddev->pers->start(mddev);
>> +		if (err) {
>> +			bitmap_destroy(mddev);
>> +			goto out;
>> +		}
>> +	}
>=20
> Looks there is one thing left. dm-raid.c calls md_run but not do_md_run,
> dm-raid supports raid5-cache too. So we need export a wrap for ->start an=
d let
> dm-raid use it.

I can add this.=20


> This doesn't seem to prevent reshape happening. mddev->thread calls
> check_recovery which can create and wakeup sync_thread. Probably we shoul=
d
> preserve ->recovery and set it 0, do log load and then set it back, this =
way we
> should prevent the reshape for sure.

Maybe we need some systematic way to gate both threads (md_thread and=20
sync_thread). Maybe some extra flags like:

MD_THREAD_ENABLED
SYNC_THREAD_ENABLED

Thanks,
Song

