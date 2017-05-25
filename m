From: NeilBrown <neilb@suse.com>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on md_attr_store / raid5_make_request
Date: Thu, 25 May 2017 11:30:12 +1000
Message-ID: <877f15iuzf.fsf@notabene.neil.brown.name>
References: <87lgppz221.fsf@esperi.org.uk> <87a865jf9a.fsf@notabene.neil.brown.name> <87fufwy3lr.fsf@esperi.org.uk> <87poezhwsa.fsf@notabene.neil.brown.name> <20170524225735.555dpfe24mi6yxrb@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170524225735.555dpfe24mi6yxrb@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Nix <nix@esperi.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, May 24 2017, Shaohua Li wrote:

> On Wed, May 24, 2017 at 11:24:21AM +1000, Neil Brown wrote:
>>=20
>>=20
>>=20
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 10367ffe92e3..a7b9c0576479 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -324,8 +324,12 @@ static blk_qc_t md_make_request(struct request_queu=
e *q, struct bio *bio)
>>  void mddev_suspend(struct mddev *mddev)
>>  {
>>  	WARN_ON_ONCE(mddev->thread && current =3D=3D mddev->thread->tsk);
>> +
>>  	if (mddev->suspended++)
>>  		return;
>> +#ifdef CONFIG_LOCKDEP
>> +	WARN_ON_ONCE(debug_locks && lockdep_is_held(&mddev->reconfig_mutex));
>> +#endif
>>  	synchronize_rcu();
>>  	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) =3D=3D 0);
>>  	mddev->pers->quiesce(mddev, 1);
>> @@ -3594,9 +3598,12 @@ level_store(struct mddev *mddev, const char *buf,=
 size_t len)
>>  	if (slen =3D=3D 0 || slen >=3D sizeof(clevel))
>>  		return -EINVAL;
>>=20=20
>> +	mddev_suspend(mddev);
>>  	rv =3D mddev_lock(mddev);
>> -	if (rv)
>> +	if (rv) {
>> +		mddev_resume(mddev);
>>  		return rv;
>> +	}
>>=20=20
>>  	if (mddev->pers =3D=3D NULL) {
>>  		strncpy(mddev->clevel, buf, slen);
>> @@ -3687,7 +3694,6 @@ level_store(struct mddev *mddev, const char *buf, =
size_t len)
>>  	}
>>=20=20
>>  	/* Looks like we have a winner */
>> -	mddev_suspend(mddev);
>>  	mddev_detach(mddev);
>>=20=20
>>  	spin_lock(&mddev->lock);
>> @@ -3771,13 +3777,13 @@ level_store(struct mddev *mddev, const char *buf=
, size_t len)
>>  	blk_set_stacking_limits(&mddev->queue->limits);
>>  	pers->run(mddev);
>>  	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>> -	mddev_resume(mddev);
>>  	if (!mddev->thread)
>>  		md_update_sb(mddev, 1);
>>  	sysfs_notify(&mddev->kobj, NULL, "level");
>>  	md_new_event(mddev);
>>  	rv =3D len;
>>  out_unlock:
>> +	mddev_resume(mddev);
>>  	mddev_unlock(mddev);
>>  	return rv;
>>  }
>> @@ -4490,6 +4496,7 @@ action_store(struct mddev *mddev, const char *page=
, size_t len)
>>  		int err;
>>  		if (mddev->pers->start_reshape =3D=3D NULL)
>>  			return -EINVAL;
>> +		mddev_suspend(mddev);
>>  		err =3D mddev_lock(mddev);
>>  		if (!err) {
>>  			if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>> @@ -4500,6 +4507,7 @@ action_store(struct mddev *mddev, const char *page=
, size_t len)
>>  			}
>>  			mddev_unlock(mddev);
>>  		}
>> +		mddev_resume(mddev);
>>  		if (err)
>>  			return err;
>>  		sysfs_notify(&mddev->kobj, NULL, "degraded");
>
> The analysis makes a lot of sense, thanks! The patch looks not solving the
> problem though, because check_recovery will not write super if suspended =
isn't
> 0.

Why does that matter?  In what case do you need the superblock to be
written, but it doesn't happen.

check_recovery won't write the superblock while the mddev is locked
either, and it is locked for most of level_store().
When level_store() finished, it unlocks the device and that will trigger
md_check_recovery() to be run, and the metadata will be written then.
I don't think there is a particular need to update it before then.

Thanks,
NeilBrown


>
> I'm thinking of alternative wayt to fix this issue. A request which stall=
s in
> md_write_start reallys isn't an active IO. We could add another counter in
> md_write_start to record stalled request there. Then in mddev_suspend, wa=
it
> event will wait for atomic_read(&mddev->active_io) =3D=3D the_new_counter.
>
> Thanks,
> Shaohua

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkmM6QACgkQOeye3VZi
gbmPXQ//VHAXFMNcXHnO5uKec5tZsY3+36bkYMS7zedFR7xS4Gf9B6v8LDMhK+bW
/M0Xl9jsGOMl7+AxQ912l+ovMFdAsBzAJwBE8VXuDuWUrA0qXml37jYPMGqC2gK2
VnqZzuDvqnlHvhvJEnfP6x0xlJjVOKeZhmab1HWlkgVqQx+zvED+s15zH+28VR7S
okjATYQwTJFjgl8rX6MlntEYt9jysjW9fnvJIMbtIfczU/gkMsiB2hsk2s9LfvRd
EO3pVk4jGlL/hmhDA6dsBm0aLN+fFuUBY+07kM7v2ETD85sak8vioLIT1miB4VSz
mU7Mb2gdyzWq5Ky8On+G0iqKinQTmPVTB9ANSwzqEj50DLje3d4Bb5uEhFus1ZAC
1XPltzodCrKR7e0ZcN8O674iPDiHH79kpT8q2tkkYFp4jbZc/fEm+PRxTr6d4Vqb
7UQFKRfxZLY3rj1ROwcosLI1v+7/x+8pB4VSU3xzkzgTD1E8okC3GYFo8x3VYIi0
CXWrwwGLT9AbgHXt98d0VC2Ys246rhBsQ6qdvICxGHeqHhpphDrHU4LORINUTthU
Ci+11q+J+P6x8GXFh+2kVYVp8+s4V4ACVF0lzDbxwIgOxRQcUVohCt/HkCbMOmdA
PN+5MSmV6bsB5AgrZyTlb0DMVaiKbbV4drkyUe8J84sWPgc0OVw=
=8o1o
-----END PGP SIGNATURE-----
--=-=-=--
