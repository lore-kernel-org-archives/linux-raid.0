Received: from mail-108-mta42.mxroute.com (mail-108-mta42.mxroute.com [136.175.108.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32B5242D86
	for <linux-raid@vger.kernel.org>; Thu, 19 Jun 2025 05:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750312777; cv=none; b=YZFCYJzbM9fofEqgedFHBofXML7X+Oh8DfZOMykpggn3msGBwOB84dqQAq2mYclZJvi+KiozfGgy1ifL48ybkG2BxkTdXEbP7V6AdTpkQVdHVUhRCOX8qo9bY2Ci9C/eDgyZRvEHK2DWwxA/WwilDsy7a8X+Q2ylW87aGPMm4r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750312777; c=relaxed/simple;
	bh=NQNSKcZW6MxBDM+e/d9L05krenmBAKgMLzHc3lGuKJQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Xkkymc1DL9KZbn+TeJ1cYrtNY2CZbzyRkHDSw0ueqzs4ZBjkQVbpNLCwVxLS2B2RdHUJjf4O2RZYGWhIg5tQM25P/kDqxePdhk4kpzXgE3Acj1uvKswLhftR+l7I6YQ3dnt0vdLvzvq5M1kaL4fvRqzK40ZrCva0VLc8t9j0LGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=jnGdfq2F; arc=none smtp.client-ip=136.175.108.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="jnGdfq2F"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta42.mxroute.com (ZoneMTA) with ESMTPSA id 19786c0ae6a0008631.005
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Thu, 19 Jun 2025 05:54:23 +0000
X-Zone-Loop: b48f60a39a087c4861f5bcf9b3bf50eb79c79fcd6f4b
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:Content-Description
	:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=aS9Sm2GJ/ViMvEc6aPGcyL6zCgwQ70oiKgc5V8IkMNU=; b=jnGdfq2FEdxi
	Fmwhf0hBunF9BRigu2b3BNiyRQ7tsF/YSPpCANEdq/tDVW9Wb9AvjDEjem98R15dCGqUh1SVMCzia
	GfXq071gtiKAn/COWjBEyRkhvPudkhQRznK+cNF3TrU7Mvah6NAwCitlS75QTH9EzYYBtSkZf3zqq
	KwZce5yvFJ+9o6JS0CZcUez66973+zmjAIOSQxv1fq7yY7zG9CDqty27Zsf3+UL+OSo7ndMzyb25i
	cDfldMu5rF9NfNvTWMu1Hvg8081WTEHTjAHKpp+8ZZljiOFLcB4UrFtHnHgaR9EEtz7Aqdtdh+6CR
	oB9WsoPv1cbejnaaDE3K/w==;
From: Su Yue <l@damenly.org>
To: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Song Liu <song@kernel.org>,  Yu Kuai <yukuai3@huawei.com>,
  linux-raid@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md/raid1: change r1conf->r1bio_pool to a pointer type
In-Reply-To: <ec472853-fe4f-4b3b-887c-c1e8f562dbd5@gmail.com> (Wang Jinchao's
	message of "Thu, 19 Jun 2025 10:01:34 +0800")
References: <20250618114120.130584-1-wangjinchao600@gmail.com>
	<ldpoy2fo.fsf@damenly.org>
	<ec472853-fe4f-4b3b-887c-c1e8f562dbd5@gmail.com>
User-Agent: mu4e 1.12.7; emacs 30.1
Date: Thu, 19 Jun 2025 13:54:12 +0800
Message-ID: <frfwxomz.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Authenticated-Id: l@damenly.org

On Thu 19 Jun 2025 at 10:01, Wang Jinchao=20
<wangjinchao600@gmail.com> wrote:

> On 6/19/25 08:56, Su Yue wrote:
>> On Wed 18 Jun 2025 at 19:41, Wang Jinchao=20
>> <wangjinchao600@gmail.com> wrote:
>>
>>> In raid1_reshape(), newpool is a stack variable.
>>> mempool_init() initializes newpool->wait with the stack=20
>>> address.
>>> After assigning newpool to conf->r1bio_pool, the wait queue
>>> need to be reinitialized, which is not ideal.
>>>
>>> Change raid1_conf->r1bio_pool to a pointer type and
>>> replace mempool_init() with mempool_create() to
>>> avoid referencing a stack-based wait queue.
>>>
>>> Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
>>> ---
>>> =C2=A0drivers/md/raid1.c | 31 +++++++++++++------------------
>>> =C2=A0drivers/md/raid1.h |=C2=A0 2 +-
>>> =C2=A02 files changed, 14 insertions(+), 19 deletions(-)
>>>
>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>> index fd4ce2a4136f..4d4833915b5f 100644
>>> --- a/drivers/md/raid1.c
>>> +++ b/drivers/md/raid1.c
>>> @@ -255,7 +255,7 @@ static void free_r1bio(struct r1bio=20
>>> *r1_bio)
>>> =C2=A0=C2=A0=C2=A0=C2=A0 struct r1conf *conf =3D r1_bio->mddev->private;
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0 put_all_bios(conf, r1_bio);
>>> -=C2=A0=C2=A0=C2=A0 mempool_free(r1_bio, &conf->r1bio_pool);
>>> +=C2=A0=C2=A0=C2=A0 mempool_free(r1_bio, conf->r1bio_pool);
>>> =C2=A0}
>>>
>>> =C2=A0static void put_buf(struct r1bio *r1_bio)
>>> @@ -1305,7 +1305,7 @@ alloc_r1bio(struct mddev *mddev, struct=20
>>> bio *bio)
>>> =C2=A0=C2=A0=C2=A0=C2=A0 struct r1conf *conf =3D mddev->private;
>>> =C2=A0=C2=A0=C2=A0=C2=A0 struct r1bio *r1_bio;
>>>
>>> -=C2=A0=C2=A0=C2=A0 r1_bio =3D mempool_alloc(&conf->r1bio_pool, GFP_NOI=
O);
>>> +=C2=A0=C2=A0=C2=A0 r1_bio =3D mempool_alloc(conf->r1bio_pool, GFP_NOIO=
);
>>> =C2=A0=C2=A0=C2=A0=C2=A0 /* Ensure no bio records IO_BLOCKED */
>>> =C2=A0=C2=A0=C2=A0=C2=A0 memset(r1_bio->bios, 0, conf->raid_disks *=20
>>> =C2=A0sizeof(r1_bio-  >bios[0]));
>>> =C2=A0=C2=A0=C2=A0=C2=A0 init_r1bio(r1_bio, mddev, bio);
>>> @@ -3124,9 +3124,9 @@ static struct r1conf *setup_conf(struct=20
>>> mddev *mddev)
>>> =C2=A0=C2=A0=C2=A0=C2=A0 if (!conf->poolinfo)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto abort;
>>> =C2=A0=C2=A0=C2=A0=C2=A0 conf->poolinfo->raid_disks =3D mddev->raid_dis=
ks * 2;
>>> -=C2=A0=C2=A0=C2=A0 err =3D mempool_init(&conf->r1bio_pool, NR_RAID_BIO=
S,=20
>>> r1bio_pool_alloc,
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 rbio_pool_free, conf->poolinfo);
>>> -=C2=A0=C2=A0=C2=A0 if (err)
>>> +=C2=A0=C2=A0=C2=A0 conf->r1bio_pool =3D mempool_create(NR_RAID_BIOS,=20
>>> r1bio_pool_alloc,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rbio_pool_free, c=
onf->poolinfo);
>>> +=C2=A0=C2=A0=C2=A0 if (!conf->r1bio_pool)
>>>
>> err should be set to -ENOMEM.
>>
> At the beginning of the function, err is initialized to -ENOMEM.
>
Alright...

--
Su
>> -- Su
>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto abort;
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0 err =3D bioset_init(&conf->bio_split, BIO_POOL=
_SIZE, 0, 0);
>>> @@ -3197,7 +3197,7 @@ static struct r1conf *setup_conf(struct=20
>>> mddev *mddev)
>>>
>>> =C2=A0 abort:
>>> =C2=A0=C2=A0=C2=A0=C2=A0 if (conf) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mempool_exit(&conf->r1bio_p=
ool);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mempool_destroy(conf->r1bio=
_pool);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(conf->mirrors);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 safe_put_page(conf->tm=
ppage);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(conf->poolinfo);
>>> @@ -3310,7 +3310,7 @@ static void raid1_free(struct mddev=20
>>> *mddev, void *priv)
>>> =C2=A0{
>>> =C2=A0=C2=A0=C2=A0=C2=A0 struct r1conf *conf =3D priv;
>>>
>>> -=C2=A0=C2=A0=C2=A0 mempool_exit(&conf->r1bio_pool);
>>> +=C2=A0=C2=A0=C2=A0 mempool_destroy(conf->r1bio_pool);
>>> =C2=A0=C2=A0=C2=A0=C2=A0 kfree(conf->mirrors);
>>> =C2=A0=C2=A0=C2=A0=C2=A0 safe_put_page(conf->tmppage);
>>> =C2=A0=C2=A0=C2=A0=C2=A0 kfree(conf->poolinfo);
>>> @@ -3366,17 +3366,13 @@ static int raid1_reshape(struct mddev=20
>>> *mddev)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * At the same time, we "pack" the device=
s so that all=20
>>> the =C2=A0missing
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * devices have the higher raid_disk numb=
ers.
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> -=C2=A0=C2=A0=C2=A0 mempool_t newpool, oldpool;
>>> +=C2=A0=C2=A0=C2=A0 mempool_t *newpool, *oldpool;
>>> =C2=A0=C2=A0=C2=A0=C2=A0 struct pool_info *newpoolinfo;
>>> =C2=A0=C2=A0=C2=A0=C2=A0 struct raid1_info *newmirrors;
>>> =C2=A0=C2=A0=C2=A0=C2=A0 struct r1conf *conf =3D mddev->private;
>>> =C2=A0=C2=A0=C2=A0=C2=A0 int cnt, raid_disks;
>>> =C2=A0=C2=A0=C2=A0=C2=A0 unsigned long flags;
>>> =C2=A0=C2=A0=C2=A0=C2=A0 int d, d2;
>>> -=C2=A0=C2=A0=C2=A0 int ret;
>>> -
>>> -=C2=A0=C2=A0=C2=A0 memset(&newpool, 0, sizeof(newpool));
>>> -=C2=A0=C2=A0=C2=A0 memset(&oldpool, 0, sizeof(oldpool));
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0 /* Cannot change chunk_size, layout, or level =
*/
>>> =C2=A0=C2=A0=C2=A0=C2=A0 if (mddev->chunk_sectors !=3D mddev->new_chunk=
_sectors ||
>>> @@ -3408,18 +3404,18 @@ static int raid1_reshape(struct mddev=20
>>> *mddev)
>>> =C2=A0=C2=A0=C2=A0=C2=A0 newpoolinfo->mddev =3D mddev;
>>> =C2=A0=C2=A0=C2=A0=C2=A0 newpoolinfo->raid_disks =3D raid_disks * 2;
>>>
>>> -=C2=A0=C2=A0=C2=A0 ret =3D mempool_init(&newpool, NR_RAID_BIOS,=20
>>> r1bio_pool_alloc,
>>> +=C2=A0=C2=A0=C2=A0 newpool =3D mempool_create(NR_RAID_BIOS, r1bio_pool=
_alloc,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 rbio_pool_free, newpoolinfo);
>>> -=C2=A0=C2=A0=C2=A0 if (ret) {
>>> +=C2=A0=C2=A0=C2=A0 if (!newpool) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(newpoolinfo);
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>>> =C2=A0=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0=C2=A0=C2=A0=C2=A0 newmirrors =3D kzalloc(array3_size(sizeof(stru=
ct=20
>>> raid1_info),
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 raid_disks, 2),
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 GFP_KERNEL);
>>> =C2=A0=C2=A0=C2=A0=C2=A0 if (!newmirrors) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(newpoolinfo);
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mempool_exit(&newpool);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mempool_destroy(newpool);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM;
>>> =C2=A0=C2=A0=C2=A0=C2=A0 }
>>>
>>> @@ -3428,7 +3424,6 @@ static int raid1_reshape(struct mddev=20
>>> *mddev)
>>> =C2=A0=C2=A0=C2=A0=C2=A0 /* ok, everything is stopped */
>>> =C2=A0=C2=A0=C2=A0=C2=A0 oldpool =3D conf->r1bio_pool;
>>> =C2=A0=C2=A0=C2=A0=C2=A0 conf->r1bio_pool =3D newpool;
>>> -=C2=A0=C2=A0=C2=A0 init_waitqueue_head(&conf->r1bio_pool.wait);
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0 for (d =3D d2 =3D 0; d < conf->raid_disks; d++=
) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct md_rdev *rdev =
=3D conf->mirrors[d].rdev;
>>> @@ -3460,7 +3455,7 @@ static int raid1_reshape(struct mddev=20
>>> *mddev)
>>> =C2=A0=C2=A0=C2=A0=C2=A0 set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>>> =C2=A0=C2=A0=C2=A0=C2=A0 md_wakeup_thread(mddev->thread);
>>>
>>> -=C2=A0=C2=A0=C2=A0 mempool_exit(&oldpool);
>>> +=C2=A0=C2=A0=C2=A0 mempool_destroy(oldpool);
>>> =C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>> =C2=A0}
>>>
>>> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
>>> index 33f318fcc268..652c347b1a70 100644
>>> --- a/drivers/md/raid1.h
>>> +++ b/drivers/md/raid1.h
>>> @@ -118,7 +118,7 @@ struct r1conf {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * mempools - it changes when the array g=
rows or shrinks
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> =C2=A0=C2=A0=C2=A0=C2=A0 struct pool_info=C2=A0=C2=A0=C2=A0 *poolinfo;
>>> -=C2=A0=C2=A0=C2=A0 mempool_t=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 r1bio_pool;
>>> +=C2=A0=C2=A0=C2=A0 mempool_t=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 *r1bio_pool;
>>> =C2=A0=C2=A0=C2=A0=C2=A0 mempool_t=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 r1buf_pool;
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0 struct bio_set=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 bio_split;
