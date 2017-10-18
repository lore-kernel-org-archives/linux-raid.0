From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 1/5] md: always hold reconfig_mutex when calling mddev_suspend()
Date: Wed, 18 Oct 2017 18:35:05 +1100
Message-ID: <87efq0j4d2.fsf@notabene.neil.brown.name>
References: <150820826980.1646.6380214598725492144.stgit@noble> <150820840340.1646.12365558035859364361.stgit@noble> <20171018061107.42kpztc3nbnhbavi@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171018061107.42kpztc3nbnhbavi@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 17 2017, Shaohua Li wrote:

> On Tue, Oct 17, 2017 at 01:46:43PM +1100, Neil Brown wrote:
>> Most often mddev_suspend() is called with
>> reconfig_mutex held.  Make this a requirement in
>> preparation a subsequent patch.
>
> can we do further, eg, make mddev_resumed() called with the mutex held. T=
hat's
> symmetrical. It appears only dm-raid.c doesn't hold the mutext for mddev_=
resume
> in a quick scan.
>=20=20
>> Taking the mutex in r5c_disable_writeback_async() is
>> a little tricky as this is called from a work queue
>> via log->disable_writeback_work, and flush_work()
>> is called on that while holding ->reconfig_mutex.
>> If the work item hasn't run before flush_work()
>> is called, the work function will not be able to
>> get the mutex.
>>=20
>> So we use mddev_trylock() inside the wait_event() call, and have that
>> abort when conf->log is set to NULL, which happens before
>> flush_work() is called.
>>=20
>> Signed-off-by: NeilBrown <neilb@suse.com>
>> ---
>>  drivers/md/dm-raid.c     |    5 ++++-
>>  drivers/md/md.c          |    1 +
>>  drivers/md/raid5-cache.c |   18 +++++++++++++-----
>>  3 files changed, 18 insertions(+), 6 deletions(-)
>>=20
>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>> index 2245d06d2045..cc2fed784a5f 100644
>> --- a/drivers/md/dm-raid.c
>> +++ b/drivers/md/dm-raid.c
>> @@ -3629,8 +3629,11 @@ static void raid_postsuspend(struct dm_target *ti)
>>  {
>>  	struct raid_set *rs =3D ti->private;
>>=20=20
>> -	if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags))
>> +	if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
>> +		mddev_lock_nointr(&rs->md);
>>  		mddev_suspend(&rs->md);
>> +		mddev_unlock(&rs->md);
>> +	}
>>=20=20
>>  	rs->md.ro =3D 1;
>>  }
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 0ff1bbf6c90e..04538b60f8f3 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -344,6 +344,7 @@ static blk_qc_t md_make_request(struct request_queue=
 *q, struct bio *bio)
>>  void mddev_suspend(struct mddev *mddev)
>>  {
>>  	WARN_ON_ONCE(mddev->thread && current =3D=3D mddev->thread->tsk);
>> +	lockdep_assert_held(&mddev->reconfig_mutex);
>>  	if (mddev->suspended++)
>>  		return;
>>  	synchronize_rcu();
>> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
>> index 0b7406ac8ce1..6a631dd21f0b 100644
>> --- a/drivers/md/raid5-cache.c
>> +++ b/drivers/md/raid5-cache.c
>> @@ -693,6 +693,8 @@ static void r5c_disable_writeback_async(struct work_=
struct *work)
>>  	struct r5l_log *log =3D container_of(work, struct r5l_log,
>>  					   disable_writeback_work);
>>  	struct mddev *mddev =3D log->rdev->mddev;
>> +	struct r5conf *conf =3D mddev->private;
>> +	int locked =3D 0;
>>=20=20
>>  	if (log->r5c_journal_mode =3D=3D R5C_JOURNAL_MODE_WRITE_THROUGH)
>>  		return;
>> @@ -701,11 +703,15 @@ static void r5c_disable_writeback_async(struct wor=
k_struct *work)
>>=20=20
>>  	/* wait superblock change before suspend */
>>  	wait_event(mddev->sb_wait,
>> -		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
>> -
>> -	mddev_suspend(mddev);
>> -	log->r5c_journal_mode =3D R5C_JOURNAL_MODE_WRITE_THROUGH;
>> -	mddev_resume(mddev);
>> +		   conf->log =3D=3D NULL ||
>> +		   (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) &&
>> +		    (locked =3D mddev_trylock(mddev))));
>
> Probably we just bail out if conf->log =3D=3D NULL.

That is exactly what this code does.  If ->log is NULL or ever becomes
NULL, we bail out.

>                                                  The whole trylock point =
is for
> the exit case, we can handle it separately. The bonus is
> r5c_disable_writeback_async will not magically do nothing if the mutex is
> already held by others.

I don't understand... the try_lock is so we can wait for the lock, or
for other things.  The "wait_event()" waits until it can get the lock,
or it doesn't need to. r5c_disable_writeback_async
will not "do nothing if the mutex is already held by others"

Though I just noticed ->sb_wait doesn't get woken when the mddev is
unlocked.=20
I could just add a wake_up in mddev_unlock but that probably isn't
a good idea.  I'll have a proper look...

So drop this patch for now, thanks.

NeilBrown



>
> Thanks,
> Shaohua
>
>> +	if (locked) {
>> +		mddev_suspend(mddev);
>> +		log->r5c_journal_mode =3D R5C_JOURNAL_MODE_WRITE_THROUGH;
>> +		mddev_resume(mddev);
>> +		mddev_unlock(mddev);
>> +	}
>>  }
>>=20=20
>>  static void r5l_submit_current_io(struct r5l_log *log)
>> @@ -3165,6 +3171,8 @@ void r5l_exit_log(struct r5conf *conf)
>>  	conf->log =3D NULL;
>>  	synchronize_rcu();
>>=20=20
>> +	/* Ensure disable_writeback_work wakes up and exits */
>> +	wake_up(&conf->mddev->sb_wait);
>>  	flush_work(&log->disable_writeback_work);
>>  	md_unregister_thread(&log->reclaim_thread);
>>  	mempool_destroy(log->meta_pool);
>>=20
>>=20

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnnBCsACgkQOeye3VZi
gbnNyQ//f7vWljgpBs4n3ZYyeSK+3LmD/a/74vhxPpbe1j0fCrpilxZlmbk0Taw1
gNWBXwqthLwJ0Sy2B6XBOwMd+4SWK4FpwsepEa2uYWEaW7wcLveKuQvz4PIeu8lm
WemZnIkJT1UuAbD1Pi6v/bgfQ8tLkJZ7PfecgVr1MpyxDnqFcIn+gbN7Lg0wuGu1
FOXi7rqDhJhAhc5CFkXkszUMSebAMpb4/kCBHa9LpLSfGPwMJoFKT5LquwS9cqQc
dPJ3y/QVlXE29aDqPHW5cOggduIUZsePgxQO2brgRB4CK1HJ11fS39ida16ODojD
+u4nEKL3Pu6fnduukWOvt8p8A4y7TWJvl6vg4KBvRiXRP6YsaJE8qqB3cwq7+Nkl
CJqgbvNW0RmgFLe7YZ5bcsT/x5wjJadoL+LCy+sUt2qTBF3OJqVrlzSvR5xMnLSi
txNG2LkZWZm/HYKVpAf3777VRB1Hme2FAyhWp6DpNSFm/md8dPkB0W29lScWUl13
7Ad93mbvZQxJex0SwmX+dr+51r1RQ6ZHQZE+pYIkFV4zVKhoM/crZbo9jewT/kN5
7hMTxPPgrq0OQWvZ4CO4CaXUzdbH1pz5UfsHlmvv2QY3x//cYtKu4qrOFbEWxBwQ
fSUP3RtD7W+qDJ/qvXG8+WnoTN4tvBagPBd2Q06ofqLwjHjEPAQ=
=h7ds
-----END PGP SIGNATURE-----
--=-=-=--
