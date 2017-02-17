From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 01/14] md/raid5: use md_write_start to count stripes, not bios
Date: Fri, 17 Feb 2017 13:04:44 +1100
Message-ID: <87ino94loj.fsf@notabene.neil.brown.name>
References: <148721992248.7521.17160361058957519076.stgit@noble> <148721994120.7521.3518782809103694227.stgit@noble> <20170216172926.lojx2a7ceqifrklq@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170216172926.lojx2a7ceqifrklq@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 16 2017, Shaohua Li wrote:

> On Thu, Feb 16, 2017 at 03:39:01PM +1100, Neil Brown wrote:
>> We use md_write_start() to increase the count of pending writes, and
>> md_write_end() to decrement the count.  We currently count bios
>> submitted to md/raid5.  Change it count stripe_heads that a WRITE bio
>> has been attached to.
>>=20
>> So now, raid5_make_request() calls md_write_start() and then
>> md_write_end() to keep the count elevated during the setup of the
>> request.
>>=20
>> add_stripe_bio() calls md_write_start() for each stripe_head, and the
>> completion routines always call md_write_end(), instead of only
>> calling it when raid5_dec_bi_active_stripes() returns 0.
>> make_discard_request also calls md_write_start/end().
>>=20
>> The parallel between md_write_{start,end} and use of bi_phys_segments
>> can be seen in that:
>>  Whenever we set bi_phys_segments to 1, we now call md_write_start.
>>  Whenever we increment it on non-read requests with
>>    raid5_inc_bi_active_stripes(), we now call md_write_start().
>>  Whenever we decrement bi_phys_segments on non-read requsts with
>>     raid5_dec_bi_active_stripes(), we now call md_write_end().
>>=20
>> This reduces our dependence on keeping a per-bio count of active
>> stripes in bi_phys_segments.
>>=20
>> Signed-off-by: NeilBrown <neilb@suse.com>
>> ---
>>  drivers/md/raid5-cache.c |    2 +-
>>  drivers/md/raid5.c       |   27 +++++++++++++--------------
>>  2 files changed, 14 insertions(+), 15 deletions(-)
>>=20
>> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
>> index 302dea3296ba..4b211f914d17 100644
>> --- a/drivers/md/raid5-cache.c
>> +++ b/drivers/md/raid5-cache.c
>> @@ -265,8 +265,8 @@ r5c_return_dev_pending_writes(struct r5conf *conf, s=
truct r5dev *dev,
>>  	while (wbi && wbi->bi_iter.bi_sector <
>>  	       dev->sector + STRIPE_SECTORS) {
>>  		wbi2 =3D r5_next_bio(wbi, dev->sector);
>> +		md_write_end(conf->mddev);
>>  		if (!raid5_dec_bi_active_stripes(wbi)) {
>> -			md_write_end(conf->mddev);
>>  			bio_list_add(return_bi, wbi);
>>  		}
>>  		wbi =3D wbi2;
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 3c7e106c12a2..760b726943c9 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -3075,6 +3075,7 @@ static int add_stripe_bio(struct stripe_head *sh, =
struct bio *bi, int dd_idx,
>>  		bi->bi_next =3D *bip;
>>  	*bip =3D bi;
>>  	raid5_inc_bi_active_stripes(bi);
>> +	md_write_start(conf->mddev, bi);
>>=20=20
>>  	if (forwrite) {
>>  		/* check if page is covered */
>> @@ -3198,10 +3199,9 @@ handle_failed_stripe(struct r5conf *conf, struct =
stripe_head *sh,
>>  			struct bio *nextbi =3D r5_next_bio(bi, sh->dev[i].sector);
>>=20=20
>>  			bi->bi_error =3D -EIO;
>> -			if (!raid5_dec_bi_active_stripes(bi)) {
>> -				md_write_end(conf->mddev);
>> +			md_write_end(conf->mddev);
>> +			if (!raid5_dec_bi_active_stripes(bi))
>>  				bio_list_add(return_bi, bi);
>> -			}
>>  			bi =3D nextbi;
>>  		}
>>  		if (bitmap_end)
>> @@ -3222,10 +3222,9 @@ handle_failed_stripe(struct r5conf *conf, struct =
stripe_head *sh,
>>  			struct bio *bi2 =3D r5_next_bio(bi, sh->dev[i].sector);
>>=20=20
>>  			bi->bi_error =3D -EIO;
>> -			if (!raid5_dec_bi_active_stripes(bi)) {
>> -				md_write_end(conf->mddev);
>> +			md_write_end(conf->mddev);
>> +			if (!raid5_dec_bi_active_stripes(bi))
>>  				bio_list_add(return_bi, bi);
>> -			}
>>  			bi =3D bi2;
>>  		}
>>=20=20
>> @@ -3582,10 +3581,9 @@ static void handle_stripe_clean_event(struct r5co=
nf *conf,
>>  				while (wbi && wbi->bi_iter.bi_sector <
>>  					dev->sector + STRIPE_SECTORS) {
>>  					wbi2 =3D r5_next_bio(wbi, dev->sector);
>> -					if (!raid5_dec_bi_active_stripes(wbi)) {
>> -						md_write_end(conf->mddev);
>> +					md_write_end(conf->mddev);
>> +					if (!raid5_dec_bi_active_stripes(wbi))
>>  						bio_list_add(return_bi, wbi);
>> -					}
>>  					wbi =3D wbi2;
>>  				}
>>  				bitmap_endwrite(conf->mddev->bitmap, sh->sector,
>> @@ -5268,6 +5266,7 @@ static void make_discard_request(struct mddev *mdd=
ev, struct bio *bi)
>>=20=20
>>  	bi->bi_next =3D NULL;
>>  	bi->bi_phys_segments =3D 1; /* over-loaded to count active stripes */
>> +	md_write_start(mddev, bi);
>
> md_write_start calls wait_event, so it can't be called with lock hold. Ma=
ybe
> add a special __md_write_start which only increases the count, we already=
 wait
> in make_request.

I cannot see what lock is held here, but I can see a that a lock is held
below while md_write_start() is called.

An "md_write_incr()" or similar would certainly make sense.  I'll add
that in.

Thanks,
NeilBrown


>
>>  	stripe_sectors =3D conf->chunk_sectors *
>>  		(conf->raid_disks - conf->max_degraded);
>> @@ -5314,6 +5313,7 @@ static void make_discard_request(struct mddev *mdd=
ev, struct bio *bi)
>>  			sh->dev[d].towrite =3D bi;
>>  			set_bit(R5_OVERWRITE, &sh->dev[d].flags);
>>  			raid5_inc_bi_active_stripes(bi);
>> +			md_write_start(mddev, bi);
>
> Ditto.
>
> Thanks,
> Shaohua
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlimWj0ACgkQOeye3VZi
gbkk5xAAgSddoPwlp3V22tITrpyOkaAIhLkgsI8UHZBF3wQiB3oOR1Q3VNS7Yksb
fDy1c4U5rEkLRKOMYggQw6wgOC/MShu8hZEb64jqbIXwl1pcuciyb98HlR+iAok5
4z94UZc4iCGfGZ4HKlboZcy9FknztKrtnc0ThQoazEBt4BTsaT26Dv07QMRlavTw
Qx8H8yUkUHvv8ZEeMiv+uU3duAdNCAxSl/VJiUOeAIF5qQ55zpjTiQzhEkL4h8Mp
giuTywdw3CJPkdnS2YFRbjW8Z/TZ44QR0LjeWxEhjWWgB3vHiy0LR5/IHnC2HtD3
e63kdsizKoX+LLNGZCNeXuYrl2AM82kvfOaUSydy0fAlSlEKqDb8gh0cE+KKvEbm
DGccXk+A7W5LIlf/VyvhhsntM9i1iTLtxvJP1FhNBzw7tGdRGsNnCjFWvY8H1AST
JRuFK4CIIWDF9QMznrkfRFXfiOdrVMEAvl3U7CVro0gbw8maOQimhRMKDUod4uMn
ohnzXOUZW1VC/Kv5CLQ+yj2b4Mr0Aq5G6+2QyuUypGrbXBATZncPkf39RwC4fE6F
eF3hIOmqLg09qofOtxJhDFUKNq9VQrggCNCQ38vOXLVz0Uu75+y8H3IO50CmHJ2k
YIGU32dtb7fpt5mRAuI5MEWDM9ZDburl5rH7+iOahfrL9L6lOtY=
=Qm/l
-----END PGP SIGNATURE-----
--=-=-=--
