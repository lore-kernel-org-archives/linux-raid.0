From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v1 23/54] bcache: handle bio_clone() & bvec updating for
 multipage bvecs
Date: Sat, 31 Dec 2016 18:29:32 +0800
Message-ID: <CACVXFVNdJjo18PzdkacA_rpBpDydcemOh9ui2NfzZ2Qd22BX_A@mail.gmail.com>
References: <1482854250-13481-1-git-send-email-tom.leiming@gmail.com>
 <1482854250-13481-24-git-send-email-tom.leiming@gmail.com> <4d015585-c830-17ff-de4a-60f2d5f06a0d@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <4d015585-c830-17ff-de4a-60f2d5f06a0d@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Mike Christie <mchristi@redhat.com>, Guoqing Jiang <gqjiang@suse.com>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Coly,

On Fri, Dec 30, 2016 at 7:01 PM, Coly Li <i@coly.li> wrote:
> On 2016/12/27 =E4=B8=8B=E5=8D=8811:56, Ming Lei wrote:
>> The incoming bio may be too big to be cloned into
>> one singlepage bvecs bio, so split the bio and
>> check the splitted bio one by one.
>>
>> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>> ---
>>  drivers/md/bcache/debug.c | 24 ++++++++++++++++++++++--
>>  1 file changed, 22 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
>> index 48d03e8b3385..18b2d2d138e3 100644
>> --- a/drivers/md/bcache/debug.c
>> +++ b/drivers/md/bcache/debug.c
>> @@ -103,7 +103,7 @@ void bch_btree_verify(struct btree *b)
>>       up(&b->io_mutex);
>>  }
>>
>> -void bch_data_verify(struct cached_dev *dc, struct bio *bio)
>> +static void __bch_data_verify(struct cached_dev *dc, struct bio *bio)
>>  {
>>       char name[BDEVNAME_SIZE];
>>       struct bio *check;
>> @@ -116,7 +116,7 @@ void bch_data_verify(struct cached_dev *dc, struct b=
io *bio)
>>        * in the new cloned bio because each single page need
>>        * to assign to each bvec of the new bio.
>>        */
>> -     check =3D bio_clone(bio, GFP_NOIO);
>> +     check =3D bio_clone_sp(bio, GFP_NOIO);
>>       if (!check)
>>               return;
>>       check->bi_opf =3D REQ_OP_READ;
>> @@ -151,6 +151,26 @@ void bch_data_verify(struct cached_dev *dc, struct =
bio *bio)
>>       bio_put(check);
>>  }
>>
>> +void bch_data_verify(struct cached_dev *dc, struct bio *bio)
>> +{
>> +     struct request_queue *q =3D bdev_get_queue(bio->bi_bdev);
>> +     struct bio *clone =3D bio_clone_fast(bio, GFP_NOIO, q->bio_split);
>> +     unsigned sectors;
>> +
>> +     while (!bio_can_convert_to_sp(clone, &sectors)) {
>> +             struct bio *split =3D bio_split(clone, sectors,
>> +                                           GFP_NOIO, q->bio_split);
>> +
>> +             __bch_data_verify(dc, split);
>> +             bio_put(split);
>> +     }
>> +
>> +     if (bio_sectors(clone))
>> +             __bch_data_verify(dc, clone);
>> +
>> +     bio_put(clone);
>> +}
>> +
>
> Hi Lei,
>
> The above patch is good IMHO. Just wondering why not use the classical
> style ? something like,

I don't know there is the classical style, :-)

>
>
> do {
>         if (!bio_can_convert_to_sp(clone, &sectors))
>                 split =3D bio_split(clone, sectors,
>                                   GFP_NOIO, q->bio_split);
>         else
>                 split =3D clone;
>
>         __bch_data_verity(gc, split);
>         bio_put(split);
> } while (split !=3D clone);
>
>
> I guess maybe the above style generates less binary code.

Maybe, will take this style in V2.

Thanks for the review!

--=20
Ming Lei
