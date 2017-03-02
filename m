From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V2 2/5] md: move bitmap_destroy before __md_stop
Date: Fri, 03 Mar 2017 09:15:50 +1100
Message-ID: <87pohznx49.fsf@notabene.neil.brown.name>
References: <1488357760-7893-1-git-send-email-gqjiang@suse.com> <1488357760-7893-3-git-send-email-gqjiang@suse.com> <20170302182825.fcinhanfai3qgzot@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170302182825.fcinhanfai3qgzot@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 02 2017, Shaohua Li wrote:

> On Wed, Mar 01, 2017 at 04:42:37PM +0800, Guoqing Jiang wrote:
>> Since we have switched to sync way to handle METADATA_UPDATED
>> msg for md-cluster, then process_metadata_update is depended
>> on mddev->thread->wqueue.
>>=20
>> With the new change, clustered raid could possible hang if
>> array received a METADATA_UPDATED msg after array unregistered
>> mddev->thread, so we need to stop clustered raid earlier
>> than before.
>>=20
>> And this change should be safe for non-clustered raid since
>> all writes are stopped before the destroy. Also in md_run,
>> we activate the personality (pers->run()) before activating
>> the bitmap (bitmap_create()). So it is pleasingly symmetric
>> to stop the bitmap (bitmap_destroy()) before stopping the
>> personality (__md_stop() calls pers->free()).
>>=20
>> Reviewed-by: NeilBrown <neilb@suse.com>
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>> ---
>>  drivers/md/md.c | 30 +++++++++++++++++-------------
>>  1 file changed, 17 insertions(+), 13 deletions(-)
>>=20
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 44206bc6e3aa..e1d9116044ae 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -5574,8 +5574,8 @@ void md_stop(struct mddev *mddev)
>>  	/* stop the array and free an attached data structures.
>>  	 * This is called from dm-raid
>>  	 */
>> -	__md_stop(mddev);
>>  	bitmap_destroy(mddev);
>> +	__md_stop(mddev);
>>  	if (mddev->bio_set)
>>  		bioset_free(mddev->bio_set);
>>  }
>
> Applied other 4 patches. But this one I still have concerns.
>
> For raid1, if a bio is behind IO, we return the bio to upper layer but do=
n't
> wait behind IO completion. So even there are no writes running, there mig=
ht be
> behind IO running. mddev_detach will do the wait which checks bitmap. If =
we
> bitmap_destroy before __md_stop, mddev_detach doesn't do the wait.
>
> Probably we should move mddev_detach out of __md_stop and always do:
> mddev_detach()
> bitmap_destroy()
> __md_stop()
>
> This looks safer to me.

Thanks for catching that.  I agree - mddev_detach should come before
bitmap_destroy.
I might be best to change __md_stop() to start

static void __md_stop(struct mddev *mddev)
{
	struct md_personality *pers =3D mddev->pers;
	mddev_detach(mddev);
+	bitmap_destroy(mddev);
	/* Ensure ->event_work is done */
	flush_workqueue(md_misc_wq);


That would make the remainder of the patch (below) unnecessary.
I think it is wrong anyway.
We were correct to move the "bitmap_destroy() call up to the
"if (mddev->pers)" case, but we were not correct to move the
closing of bitmap_info.file.
If a file is added to an array but that array is not started
(so ->pers is not set), then stopping the array will not close the file
with the change below, and that isn't good.

So if we move bitmap_destroy() into  __md_stop() and remove it from
do_md_stop and md_stop(), that might be exactly what we need.

Thanks,
NeilBrown

>
> Thanks,
> Shaohua
>> @@ -5688,6 +5688,22 @@ static int do_md_stop(struct mddev *mddev, int mo=
de,
>>  			set_disk_ro(disk, 0);
>>=20=20
>>  		__md_stop_writes(mddev);
>> +
>> +		/*
>> +		 * Destroy bitmap after all writes are stopped
>> +		 */
>> +		if (mode =3D=3D 0) {
>> +			bitmap_destroy(mddev);
>> +			if (mddev->bitmap_info.file) {
>> +				struct file *f =3D mddev->bitmap_info.file;
>> +				spin_lock(&mddev->lock);
>> +				mddev->bitmap_info.file =3D NULL;
>> +				spin_unlock(&mddev->lock);
>> +				fput(f);
>> +			}
>> +			mddev->bitmap_info.offset =3D 0;
>> +		}
>> +
>>  		__md_stop(mddev);
>>  		mddev->queue->backing_dev_info->congested_fn =3D NULL;
>>=20=20
>> @@ -5712,19 +5728,7 @@ static int do_md_stop(struct mddev *mddev, int mo=
de,
>>  	 */
>>  	if (mode =3D=3D 0) {
>>  		pr_info("md: %s stopped.\n", mdname(mddev));
>> -
>> -		bitmap_destroy(mddev);
>> -		if (mddev->bitmap_info.file) {
>> -			struct file *f =3D mddev->bitmap_info.file;
>> -			spin_lock(&mddev->lock);
>> -			mddev->bitmap_info.file =3D NULL;
>> -			spin_unlock(&mddev->lock);
>> -			fput(f);
>> -		}
>> -		mddev->bitmap_info.offset =3D 0;
>> -
>>  		export_array(mddev);
>> -
>>  		md_clean(mddev);
>>  		if (mddev->hold_active =3D=3D UNTIL_STOP)
>>  			mddev->hold_active =3D 0;
>> --=20
>> 2.6.2
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAli4mZYACgkQOeye3VZi
gbnAzg//Rbvgq8XvDfqdfuVhSV59kNhT6VWW8wpdau6VIp8VcXDiyM8qvpfYbICh
77x2Hj0kwoxg+mJXhfcOijwnYwBf7E5Mh6CokUr/hs2VVT7z6JGt1XuGhK6nQmXO
vAWg4ZznrvgXwD1nBalx0JkR4EJG556CkKYJw7TglqLSwilPoUX4sAOhcAiYZqAj
hYXsk1CC5wsF9q5pAY5FKgw5QGMinn7EucLrcXVn6Zo2YtjhQGGd/lwjX8LDiepQ
NvrXWRYS6t/Nz7oOK6AFgLWq7fNhlA5G20fi+vVgEtB61uMEUhOlV9560eDKzm2G
427G1C3NddjOUPmGAigaGOguivcMwpmYDGwF9cxENDy4aZu4hFuFtvSL3LSIc4Cv
Ve7GO9jO2QpvO4tph6HVyAVyJzTW9VG3j2KTjAb7+5tSb6Tj0fl+djrFuZ3GNzcv
WRQgaNGQBrKHABsWdz2G8ZF7e1ScldCV++2u6rRWa8lErvlaK76/UsWjg2ElQTf6
eMYIAnz6HLqOL1qSAiGyq/uJ6/OyWClC3Zpi/Y2lvM5W9dUlc2cgJ3ZIn9jgE5Xa
WzGZV40zYCVUmDUkCwcwHyE/XIanKkjc4F+Mm/W8O9u2WNYyICEsVwT6uv2jB2yH
AI+iXwYH8yV/iZVdb8fv0xu/kRhi/3Uw1KGWzde+hy50ky/YEAE=
=UEGQ
-----END PGP SIGNATURE-----
--=-=-=--
