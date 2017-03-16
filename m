From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 02/15] md/raid5: simplfy delaying of writes while metadata is updated.
Date: Thu, 16 Mar 2017 13:45:16 +1100
Message-ID: <8760jadjnn.fsf@notabene.neil.brown.name>
References: <148954692173.18641.1294690639716682540.stgit@noble> <148954711228.18641.2048575896322496918.stgit@noble> <20170315230356.3zizpl44atdikrt7@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170315230356.3zizpl44atdikrt7@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 15 2017, Shaohua Li wrote:

> On Wed, Mar 15, 2017 at 02:05:12PM +1100, Neil Brown wrote:
>> If a device fails during a write, we must ensure the failure is
>> recorded in the metadata before the completion of the write is
>> acknowleged.
>>=20
>> Commit c3cce6cda162 ("md/raid5: ensure device failure recorded before
>> write request returns.")  added code for this, but it was
>> unnecessarily complicated.  We already had similar functionality for
>> handling updates to the bad-block-list, thanks to Commit de393cdea66c
>> ("md: make it easier to wait for bad blocks to be acknowledged.")
>>=20
>> So revert most of the former commit, and instead avoid collecting
>> completed writes if MD_CHANGE_PENDING is set.  raid5d() will then flush
>> the metadata and retry the stripe_head.
>> As this change can leave a stripe_head ready for handling immediately
>> after handle_active_stripes() returns, we change raid5_do_work() to
>> pause when MD_CHANGE_PENDING is set, so that it doesn't spin.
>>=20
>> We check MD_CHANGE_PENDING *after* analyse_stripe() as it could be set
>> asynchronously.  After analyse_stripe(), we have collected stable data
>> about the state of devices, which will be used to make decisions.
>>=20
>> Signed-off-by: NeilBrown <neilb@suse.com>
>> ---
>>  drivers/md/raid5.c |   31 ++++++++-----------------------
>>  drivers/md/raid5.h |    3 ---
>>  2 files changed, 8 insertions(+), 26 deletions(-)
>>=20
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index cc2d039b4aae..f990f74901d2 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -4690,7 +4690,8 @@ static void handle_stripe(struct stripe_head *sh)
>>  	if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
>>  		goto finish;
>>=20=20
>> -	if (s.handle_bad_blocks) {
>> +	if (s.handle_bad_blocks ||
>> +	    test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags)) {
>>  		set_bit(STRIPE_HANDLE, &sh->state);
>>  		goto finish;
>>  	}
>> @@ -5020,15 +5021,8 @@ static void handle_stripe(struct stripe_head *sh)
>>  			md_wakeup_thread(conf->mddev->thread);
>>  	}
>>=20=20
>> -	if (!bio_list_empty(&s.return_bi)) {
>> -		if (test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags)) {
>> -			spin_lock_irq(&conf->device_lock);
>> -			bio_list_merge(&conf->return_bi, &s.return_bi);
>> -			spin_unlock_irq(&conf->device_lock);
>> -			md_wakeup_thread(conf->mddev->thread);
>> -		} else
>> -			return_io(&s.return_bi);
>> -	}
>> +	if (!bio_list_empty(&s.return_bi))
>> +		return_io(&s.return_bi);
>>=20=20
>>  	clear_bit_unlock(STRIPE_ACTIVE, &sh->state);
>>  }
>> @@ -6225,6 +6219,7 @@ static void raid5_do_work(struct work_struct *work)
>>  	struct r5worker *worker =3D container_of(work, struct r5worker, work);
>>  	struct r5worker_group *group =3D worker->group;
>>  	struct r5conf *conf =3D group->conf;
>> +	struct mddev *mddev =3D conf->mddev;
>>  	int group_id =3D group - conf->worker_groups;
>>  	int handled;
>>  	struct blk_plug plug;
>> @@ -6245,6 +6240,9 @@ static void raid5_do_work(struct work_struct *work)
>>  		if (!batch_size && !released)
>>  			break;
>>  		handled +=3D batch_size;
>> +		wait_event_lock_irq(mddev->sb_wait,
>> +				    !test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags),
> MD_SB_CHANGE_PENDING?


Yes.  Thanks for catching.

NeilBrown

>
>> +				    conf->device_lock);
>>  	}
>>  	pr_debug("%d stripes handled\n", handled);
>>=20=20
>> @@ -6272,18 +6270,6 @@ static void raid5d(struct md_thread *thread)
>>=20=20
>>  	md_check_recovery(mddev);
>>=20=20
>> -	if (!bio_list_empty(&conf->return_bi) &&
>> -	    !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
>> -		struct bio_list tmp =3D BIO_EMPTY_LIST;
>> -		spin_lock_irq(&conf->device_lock);
>> -		if (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
>> -			bio_list_merge(&tmp, &conf->return_bi);
>> -			bio_list_init(&conf->return_bi);
>> -		}
>> -		spin_unlock_irq(&conf->device_lock);
>> -		return_io(&tmp);
>> -	}
>> -
>>  	blk_start_plug(&plug);
>>  	handled =3D 0;
>>  	spin_lock_irq(&conf->device_lock);
>> @@ -6935,7 +6921,6 @@ static struct r5conf *setup_conf(struct mddev *mdd=
ev)
>>  	INIT_LIST_HEAD(&conf->hold_list);
>>  	INIT_LIST_HEAD(&conf->delayed_list);
>>  	INIT_LIST_HEAD(&conf->bitmap_list);
>> -	bio_list_init(&conf->return_bi);
>>  	init_llist_head(&conf->released_stripes);
>>  	atomic_set(&conf->active_stripes, 0);
>>  	atomic_set(&conf->preread_active_stripes, 0);
>> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
>> index ba5b7a3790af..13800dc9dd88 100644
>> --- a/drivers/md/raid5.h
>> +++ b/drivers/md/raid5.h
>> @@ -638,9 +638,6 @@ struct r5conf {
>>  	int			skip_copy; /* Don't copy data from bio to stripe cache */
>>  	struct list_head	*last_hold; /* detect hold_list promotions */
>>=20=20
>> -	/* bios to have bi_end_io called after metadata is synced */
>> -	struct bio_list		return_bi;
>> -
>>  	atomic_t		reshape_stripes; /* stripes with pending writes for reshape =
*/
>>  	/* unfortunately we need two cache names as we temporarily have
>>  	 * two caches.
>>=20
>>=20

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljJ/D0ACgkQOeye3VZi
gbny+Q//bFvBtsxi7SVRa4Y0IxNnjSb9kgW0mexJSlBx8ta/40dZ2/dFqBr3VuYq
+z8N7tM669AKoyXwMVQFmGxzkC01I047DtwnHwb6cAd0hy0q9+UfyD8AIRvsERK+
H1PxGfrfN64yLkLjByNgfY4dOUlX96ab83GJmX+TkD8roqApmwoh9shHay6Do1n1
9fN8zMcRDQbqaX97xHQsuA2ho4mEju8O+hIEsuIGnob6QyJxGu8xumern/yuFD5R
i+irGgJZCaHKwQZveWx8PJaXKgljikLIvdxTSEmvp+VpFptFzZm4fG8B0MOyF3Jd
dZapvAa9C0eSYPwr+bD6fWIF+O89YQN7FigtzgVuuH3YXMhERUEg5LNjGBkw51RO
S1fRQdBiBE/7CR4T7KHHUN3nGUgiQrBbrSf/oKI3jRWEXjMaJpIlulUgZK2YYG6y
Yd/bVzZGo3+3hsjtglM94ard6M6sLyJIYy9y9DeKcFfAzJglnnsYnAkBdibTHH4l
AFDlnSds1OFVgGH7HRudlceI7ZzzbmDNf+PadxTuYw8oabij2ICiYHrqwN3W1OcR
1Zg2KLIdipq3WUxwALLeiECRbKyfZ4wY5JYk3pKGLBuSHSZEqcx44TtSHp+BAiYZ
1GGa2nrBU2UlDAl00QPJZBzCSCRqTBDpVfYTGtHq4N9NjA4ADx4=
=YwLG
-----END PGP SIGNATURE-----
--=-=-=--
