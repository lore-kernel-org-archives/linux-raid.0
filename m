From: NeilBrown <neilb@suse.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Tue, 20 Dec 2016 09:45:01 +1100
Message-ID: <87oa07tu6q.fsf@notabene.neil.brown.name>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com> <87a8c20xpg.fsf@notabene.neil.brown.name> <CAMGffEkQ5puQEE0FVfLMV1of1OYOhLMhHdUTAy-YLYPkzBzjDg@mail.gmail.com> <87oa0gzuej.fsf@notabene.neil.brown.name> <CAMGffEm4BDhKJSiDt=2WmxrpRutg862at7JP221gMi6_SpPomQ@mail.gmail.com> <877f73zd5d.fsf@notabene.neil.brown.name> <CAMGffEnCesgUp4gBsPN2L9qg3WSxNXsCcYEPWH-BaeEEktaqcw@mail.gmail.com> <CAMGffE=KoVdoYRzkHdRMuCopjmUdcrP9-woFFr-4-VszGsSHRQ@mail.gmail.com> <CAMGffEnvn4YQ5ADFXrOm2vOeEwApo38V84wB7VF3D1eZihF-Zw@mail.gmail.com> <87fulpyj33.fsf@notabene.neil.brown.name> <CAMGffEkufeaDytaHxtLR02iiQifZDhcwkLdzMj3X8_yaitSoFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMGffEkufeaDytaHxtLR02iiQifZDhcwkLdzMj3X8_yaitSoFQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, Dec 19 2016, Jinpu Wang wrote:

> Hi Neil,
>
> After apply the patch below, it paniced during boot in
> generic_make_request-> bio_list_pop.
> Looks related to you do bio_list_init(&bio_list_on_stack); again.
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 14d7c0740dc0..3436b6fc3ef8 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -2036,10 +2036,31 @@ blk_qc_t generic_make_request(struct bio *bio)
>>                 struct request_queue *q = bdev_get_queue(bio->bi_bdev);
>>
>>                 if (likely(blk_queue_enter(q, false) == 0)) {
>> +                       struct bio_list hold;
>> +                       struct bio_list lower, same;
>> +
>> +                       /* Create a fresh bio_list for all subordinate requests */
>> +                       bio_list_merge(&hold, &bio_list_on_stack);

This is the problem.  'hold' hasn't been initialised.
We could either do:
  bio_list_init(&hold);
  bio_list_merge(&hold, &bio_list_on_stack);
or just
  hold = bio_list_on_stack;


You didn't find 'hold' to be necessary in your testing, but I think that
is more complex arrangements it could make an important difference.

Thanks,
NeilBrown


>> +                       bio_list_init(&bio_list_on_stack); ??? maybe init hold, and then merge bio_list_on_stack?
>>                         ret = q->make_request_fn(q, bio);
>>
>>                         blk_queue_exit(q);

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhYYu0ACgkQOeye3VZi
gbknCw/+O1Ev5RH/rkiZhlQ32P5mouvi5Usz8o5dvEPQhGZS/NtSxPZgTI54hWVi
iH5uGuCgfoqHzbyz8eNJk1vSGVw49ee5VmmFhyiVSZl3mKUgMv53mdEoqrw6UNYM
NkS2Hvhz9y/OTewnQ8pMD9Rpoo2eOUR3pYkKgylEfCm27Ws4Q2hBJtWQURVbL/s3
ks0a0a+iIeSFH6yhxtVtbk9ZTxT5zNF8VcKvjO3C1t16w43R7Z5OcQ84gYylQgek
nZW15Kw5+yHfDw1Z4H6YIfq6Jvmf2cn7hlcPznZvGmaqjWrf6N2Cuy3bx34zdJI6
2+thMgqr3EePM18AGFwM9TfWsdgtH83H2pi8V61d/QJFX5nJHc1HRL/sFycjscme
8w3lyIIwh9qQXubkRCLBBxARR+wK5DZzmUhm/nCyTjETzi3a1jGt6uSdQdhGGxjH
SpmeeiP+GKfvXTNeuQXqulSekGIbpYcg5QBHfviUXW6RuOwv+duIgMYgrZTIhg3o
W06HyyP22M+hTa/4DyAcHtVHIBExkupR2UuYNwdStt2vulGlf0BF82JgDaukC9fU
kN8igZ1rwWZ2P2Tb83oE3bggPxCvaNSo30y1hYEKalw8+zH9mRYJNXsnEoY+RIk+
dYJz7qVx8li5hPtgFXNR0jMG9cdFQJkJoLhbdNJi32oBc6jzaiE=
=0p9Y
-----END PGP SIGNATURE-----
--=-=-=--
