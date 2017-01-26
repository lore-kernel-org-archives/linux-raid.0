From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md linear: fix a race between linear_add() and linear_congested()
Date: Thu, 26 Jan 2017 11:04:56 +1100
Message-ID: <8737g6vg7r.fsf@notabene.neil.brown.name>
References: <1485342943-9330-1-git-send-email-colyli@suse.de> <20170125180258.fil35zckwtebysqr@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170125180258.fil35zckwtebysqr@kernel.org>
Sender: stable-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, colyli@suse.de
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, stable@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 25 2017, Shaohua Li wrote:

> On Wed, Jan 25, 2017 at 07:15:43PM +0800, colyli@suse.de wrote:
>> Recently I receie a report that on Linux v3.0 based kerenl, hot add disk
>> to a md linear device causes kernel crash at linear_congested(). From the
>> crash image analysis, I find in linear_congested(), mddev->raid_disks
>> contains value N, but conf->disks[] only has N-1 pointers available. Then
>> a pointer deference to a NULL pointer crashes the kernel.
>>=20
>> There is a race between linear_add() and linear_congested(), RCU stuffs
>> used in these two functions cannot avoid the race. Since Linuv v4.0
>> RCU code is replaced by introducing mddev_suspend().  After checking the
>> upstream code, it seems linear_congested() is not called in
>> generic_make_request() code patch, so mddev_suspend() cannot provent it
>> from being called. The possible race still exists.
>>=20
>> Here I explain how the race still exists in current code.  For a machine
>> has many CPUs, on one CPU, linear_add() is called to add a hard disk to a
>> md linear device; at the same time on other CPU, linear_congested() is
>> called to detect whether this md linear device is congested before issui=
ng
>> an I/O request onto it.
>>=20
>> Now I use a possible code execution time sequence to demo how the possib=
le
>> race happens,=20
>>=20
>> seq    linear_add()                linear_congested()
>>  0                                 conf=3Dmddev->private
>>  1   oldconf=3Dmddev->private
>>  2   mddev->raid_disks++
>>  3                              for (i=3D0; i<mddev->raid_disks;i++)
>>  4                                bdev_get_queue(conf->disks[i].rdev->bd=
ev)
>>  5   mddev->private=3Dnewconf
>
> Good catch, this makes a lot of sense. However, this looks like an incomp=
lete
> fix. step 0 will get the old conf, after step 5, linear_add will free the=
 old
> conf. So it's possible linear_congested() will use the freed old conf. I =
think
> this is more likely to happen. The easist fix maybe put rcu_lock in
> linear_congested and free the old conf in a rcu callback.

We used to use kfree_rcu() but removed it in

Commit: 3be260cc18f8 ("md/linear: remove rcu protections in favour of suspe=
nd/resume")

when we changed to suspend/resume the device.  That stops all IO, but
doesn't stop the ->congested call.

So we probably should re-introduce kfree_rcu() to free oldconf.
It might also be good to store a copy of raid_disks in
linear_conf, like we do with r5conf, the ensure we never us inconsistent
=2D>raid_disks and ->disks[]

Thanks,
NeilBrown


>
> Thanks,
> Shaohua
>=20=20
>> In linear_add() mddev->raid_disks is increased in time seq 2, and on
>> another CPU in linear_congested() the for-loop iterates conf->disks[i] by
>> the increased mddev->raid_disks in time seq 3,4. But conf with one more
>> element (which is a pointer to struct dev_info type) to conf->disks[] is
>> not updated yet, accessing its structure member in time seq 4 will cause=
 a
>> NULL pointer deference fault.
>>=20
>> The fix is to update mddev->private with new value before increasing
>> mddev->raid_disks, and to make sure on other CPUs their are seen to be
>> updated in same order as linear_add() does (otherwise the race may still
>> happen), a smp_mb() is necessary.
>>=20
>> A question is, by this fix, if mddev->private is update to new value in
>> linear_add(), but in linear_congested() the for-loop still tests old val=
ue
>> of mddev->raid_disks, then the iteration will miss the last element of
>> conf->disks[]. My answer is don't worry it, it's OK. the reasons are,
>>  - When updating mddev->private, the md linear device is suspend, no I/O
>>    may happen, it is safe to missing congestion status of the last
>>    new-added hard disk.=20
>>  - In the worst case linear_congested() returns 0 and I/O sent to this md
>>    linear device, but the new added hard disk is congested, then the I/O
>>    request will be blocked for a while if it just happenly hits the new
>>    added hard disk. linear_congested() is in code path of wb_congested(),
>>    which is quite hot in write back code path. Comparing to add locking
>>    code in linear_congested(), the cost of the worst case is acceptable.
>>=20
>> The bug is reported on Linux v3.0 based kernel, it can and should be
>> applied to all kernels since Linux v3.0. I see linear_add() is merged in=
to
>> mainline since Linux v2.6.18, maybe stable kernel maintainers after this
>> version may consider to pick this fix as well.
>>=20
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Cc: Shaohua Li <shli@fb.com>
>> Cc: Neil Brown <neilb@suse.com>
>> Cc: stable@vger.kernel.org
>> ---
>>  drivers/md/linear.c | 14 +++++++++++++-
>>  1 file changed, 13 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
>> index 5975c99..48ccfad 100644
>> --- a/drivers/md/linear.c
>> +++ b/drivers/md/linear.c
>> @@ -196,10 +196,22 @@ static int linear_add(struct mddev *mddev, struct =
md_rdev *rdev)
>>  	if (!newconf)
>>  		return -ENOMEM;
>>=20=20
>> +	/* In linear_congested(), mddev->raid_disks and mddev->private
>> +	 * are accessed without protection by mddev_suspend(). If on
>> +	 * another CPU,  in linear_congested() mddev->private is still seen
>> +	 * to contains old value but mddev->raid_disks is seen to have the
>> +	 * increased value, the last iteration to conf->disks[i].rdev will
>> +	 * trigger a NULL pointer deference. To avoid this race, here
>> +	 * mddev->private must be updated before increasing
>> +	 * mddev->raid_disks, and a smp_mb() is required between them. Then
>> +	 * in linear_congested(), we are sure the updated mddev->private is
>> +	 * seen when iterating conf->disks[i].
>> +	 */
>>  	mddev_suspend(mddev);
>>  	oldconf =3D mddev->private;
>> -	mddev->raid_disks++;
>>  	mddev->private =3D newconf;
>> +	smp_mb();
>> +	mddev->raid_disks++;
>>  	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
>>  	set_capacity(mddev->gendisk, mddev->array_sectors);
>>  	mddev_resume(mddev);
>> --=20
>> 2.6.6
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAliJPSgACgkQOeye3VZi
gbnV9A//RES+KxGNQ4w5U92/Y3yyzNDq+oKJ94Pokj0U043IsBq+80vKCFMkaFAD
PVIVZfEnzOGDBNVtPuy7MOzSlJNyylhGAnjORYIZyQ6LsHAdQi4Cyatq6FYE06KG
ilHx9dd/5jk0ShQ/P9vb4uy3KTei4dm847YxVu6fVwk9aENo1nhH9WyuVb4mWq75
hqWRn9GTjAYFSHHnoh/jmb9OkxCPEhJH9H96xFzUMsxmH6AO85p67pvlk37e1T/V
qfDaRJqCE4uifch/66vX9fwqcSsZFZokV8rV8S6dRUJmuNKL+AMVP+cpDJje2Yx9
Jcuw354n/lVSXWVJA6iDzvVOnUnPb7q28JsptUoA31NDlAZGZhn+4QKfNWdRAIWO
xcmtqmS/7LK928iCHXgrWE/Kuay5E5foJf08iN5fyAslJxB+ho35PDeLMPTq/fu4
tNuanovyb78evmUmYdyOiBFSG1JbMdLWHjIb/WY2rGQVMDnfpAOdMApulb2zmxEr
9fPQLubkjyUD3F6C613Okxg/5nUAvAMS8PKAbvHEX6Z6abHsBHMjoiuLkX3kQ8fJ
bUB0EZ3dxYkpq1S3oY6R540Ug57ZoXU1vr7mDMBfTNbUhQvbIZHiInv4LjqjcUMu
5UNdzST8596nngCTiw9wMbj8CUfr0PwLeIxUw97thmLaGiEaNTg=
=92as
-----END PGP SIGNATURE-----
--=-=-=--
