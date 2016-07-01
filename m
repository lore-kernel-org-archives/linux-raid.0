From: wangyijing <wangyijing@huawei.com>
Subject: Re: [RESEND PATCH 1/3] bcache: Remove redundant parameter for
 cache_alloc()
Date: Fri, 1 Jul 2016 10:09:44 +0800
Message-ID: <5775D0E8.4060201@huawei.com>
References: <1466561446-30443-1-git-send-email-wangyijing@huawei.com>
 <bb659bb1-b2ff-6b47-c47e-1b89fe9395b5@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <bb659bb1-b2ff-6b47-c47e-1b89fe9395b5@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
To: Coly Li <i@coly.li>, axboe@fb.com, Kent Overstreet <kent.overstreet@gmail.com>
Cc: Eric Wheeler <git@linux.ewheeler.net>, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



=D4=DA 2016/6/29 18:20, Coly Li =D0=B4=B5=C0:
> =D4=DA 16/6/22 =C9=CF=CE=E710:10, Yijing Wang =D0=B4=B5=C0:
>> Cache_sb is not used in cache_alloc, and we have copied
>> sb info to cache->sb already, remove it.
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>>  drivers/md/bcache/super.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index f5dbb4e..aecaace 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -1803,7 +1803,7 @@ void bch_cache_release(struct kobject *kobj)
>>  	module_put(THIS_MODULE);
>>  }
>> =20
>> -static int cache_alloc(struct cache_sb *sb, struct cache *ca)
>> +static int cache_alloc(struct cache *ca)
>>  {
>>  	size_t free;
>>  	struct bucket *b;
>> @@ -1858,7 +1858,7 @@ static int register_cache(struct cache_sb *sb,=
 struct page *sb_page,
>>  	if (blk_queue_discard(bdev_get_queue(ca->bdev)))
>>  		ca->discard =3D CACHE_DISCARD(&ca->sb);
>> =20
>> -	ret =3D cache_alloc(sb, ca);
>> +	ret =3D cache_alloc(ca);
>=20
> I am not sure whether struct cache_b *sb will be used in future, I
> suggest to let it be for now.
>=20

We have copied sb to ca->sb, so if we need sb info in future, we could =
get info from ca->sb.

Thanks!
Yijing.

>=20
>=20
>>  	if (ret !=3D 0)
>>  		goto err;
>> =20
>>
>=20
>=20
