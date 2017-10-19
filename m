From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 1/5 v2] md: always hold reconfig_mutex when calling mddev_suspend()
Date: Thu, 19 Oct 2017 17:29:22 +1100
Message-ID: <8760bbhcql.fsf@notabene.neil.brown.name>
References: <150820826980.1646.6380214598725492144.stgit@noble> <150820840340.1646.12365558035859364361.stgit@noble> <20171018061107.42kpztc3nbnhbavi@kernel.org> <87efq0j4d2.fsf@notabene.neil.brown.name> <87lgk8gcmb.fsf@notabene.neil.brown.name> <20171019034420.sdxvirpv454vgx4h@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171019034420.sdxvirpv454vgx4h@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 18 2017, Shaohua Li wrote:

> On Thu, Oct 19, 2017 at 12:17:16PM +1100, Neil Brown wrote:
>>=20
>> Most often mddev_suspend() is called with
>> reconfig_mutex held.  Make this a requirement in
>> preparation a subsequent patch.  Also require
>> reconfig_mutex to be held for mddev_resume(),
>> partly for symmetry and partly to guarantee
>> no races with incr/decr of mddev->suspend.
>>=20
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
>> We wait in mddev->sb_wait and ensure this is woken
>> when any of the conditions change.  This requires
>> waking mddev->sb_wait in mddev_unlock().  This is only
>> like to trigger extra wake_ups of threads that needn't
>> be woken when metadata is being written, and that
>> doesn't happen often enough that the cost would be
>> noticeable.
>>=20
>> Signed-off-by: NeilBrown <neilb@suse.com>
>
> --snip--
>
> Applied the other patches in the series including the 'remove quiesce(2)'=
 one.

Thanks.

>
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
>> +	if (locked) {
>> +		mddev_suspend(mddev);
>> +		log->r5c_journal_mode =3D R5C_JOURNAL_MODE_WRITE_THROUGH;
>> +		mddev_resume(mddev);
>> +		mddev_unlock(mddev);
>> +	}
>
> For this one, my point is:
>
> 	wait_event(mddev->sb_wait, conf->log =3D=3D NULL ||
> 		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
> 	if (conf->log =3D=3D NULL)
> 		return;
>
> 	mddev_suspend(mddev);
> 	log->r5c_journal_mode =3D R5C_JOURNAL_MODE_WRITE_THROUGH;
> 	mddev_resume(mddev);
>
> does it work?

The
	lockdep_assert_held(&mddev->reconfig_mutex);
in mddev_suspend() will complain.

If you put an mddev_lock() call in there to stop the complaint, and if
the work item doesn't start before the reconfig_mutex is taken prior to
stopping the array, then r5l_exit_log() can deadlock at
	flush_work(&log->disable_writeback_work);

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnoRkQACgkQOeye3VZi
gbl4/BAAhsy5eh4RnBdkGKZQHkNK4e3y8YqXicJbFGRbNv9vKlqWndop+J4x32k0
XVGm1GkILLKCDkEUTbHiIffjrzuaMoi3nowobvwyMr6b5kHWMkKdx7TaqxlpTgXr
dLPGmQrKukMDp4wiEm2HPyb3U10XNwdH2BpFdEIetOxZfyIndD1xv6Y6YiKuKO6a
W0ltCr6wYjgWzF24MRFSibFpElLGQni+ySr4xDx07ZWR6xzEsxNaPT2mMSQI+ZA7
5elGju4syGRPWEl+yhWiMDrPxh4x4ArhFOmEVgz0UCQeZnY8nGUECA9Ov7QAC12D
038BZbj0UY4NmRScRE/KOQ6Gh7zPnKpDSOl+ZMCryJYBX2rcJJJG3wtb17RIxQ6k
fb/00Gz7VFnRRUHiqpEBoRYrk7a6+WdyiRG0yKhU+Ne1UOKocS5bu0nnEC4TqHbX
nUWzgR+DdHIHLGML0kPQYDtZPTsdFrx5X9TcxW8qGOGEk7irxpRtXaLEFGrcm/tz
v2oRXmQMbmMR1WrkRNitznDPyQhYrohfNfbODyGiqFQRnhFwCVWirKztqta5P71J
/VXkiSXu86+SI40VKggEkefVG7XHszADQg4pegXb7A9loMf9bQ7NogWt7PcqiTZj
AI3BgJvF6sRIyzOhRaJplQgXmmL1DYVKTIEwC3AGSLp0hDFr498=
=gKe7
-----END PGP SIGNATURE-----
--=-=-=--
