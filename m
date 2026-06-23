Received: from va-2-28.ptr.blmpb.com (va-2-28.ptr.blmpb.com [209.127.231.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8C52D7DEF
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 10:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782208990; cv=none; b=ZSj6vmkmtMgmDepR6H0SkRbrKs2epWMeN+ry0PnXmKwUmES64zaxz+cXh8Q8zPBGDfacYAtwU+udOx0RkqI43DLo9NNrxxS6tJ7HDpbCgh2neYQ+fv8JByhC9mqyfzo+63/FgpryxfdxbOzr6koDHEycC+nzFFVXpniULYXm5X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782208990; c=relaxed/simple;
	bh=PKj0uf5rG2swSBE04Mi21OhY6wGX8aHMq2N4IxB8ctQ=;
	h=In-Reply-To:Mime-Version:Subject:Cc:References:To:Date:Message-Id:
	 Content-Type:From; b=tYqIKR+cIScr9eqvJaI3jZreGW1m3091LwnKYxLWuW99N13aM8gmJPPm5CQpiG8xUTQA3Tz0xzyD0DninXjJmN+kUhRcWw3FG3nDx4NVahR+MCIaY9U3QWNNNixdMGT936vfvQLvsb8MLCngLq19i0LFnqs+Ecakt5w8tQoHt9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=09RlAIGA; arc=none smtp.client-ip=209.127.231.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="09RlAIGA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782208981;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Pg65HcSR4bp4ci0dPxW+vobr3hyPZZim+6nkamq2r00=;
 b=09RlAIGAk+UfaBUmhCo1r4U+KJDyNItHfHA9Z5iwlu4JxC/j6PW0wvSEGkEeQSs9Y/SCBl
 PK3LPAKqolZ3EKfHiBG7FlFbIgO4+dIjfZfe5KKscbz1txt0SP5DyNpq0hDim3RgW70AdS
 6L978VRSKe8ZIt1F3x6GA7kRBgA6cnTcXj9/ttLfHhqM2gG00GPm+R/d+zwu5Duw+sMtMO
 4E7CHOTchhvEUoMhGF9+c0K/XuPXrcj38r6O/H9s61TYEIYL/KEyYq4KewwkasFG413mjr
 UN+791bw1Y4D9bRAlqwArSvDzoMUT0chZw5I53yjQPmgNJoBz+B0hxAJieS/zg==
In-Reply-To: <20260622122902.F25CD1F00A3A@smtp.kernel.org>
X-Original-From: Chen Cheng <chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH v5 3/3] md/raid10: free r10bio before ending master_bio in raid_end_bio_io()
X-Lms-Return-Path: <lba+26a3a59d3+1e1b0c+vger.kernel.org+chencheng@fnnas.com>
User-Agent: Mozilla Thunderbird
Cc: <yukuai@fygo.io>, <linux-raid@vger.kernel.org>
Received: from [192.168.8.62] ([183.34.169.141]) by smtp.feishu.cn with ESMTPS; Tue, 23 Jun 2026 18:02:58 +0800
References: <20260622121312.1775322-1-chencheng@fnnas.com> <20260622121312.1775322-4-chencheng@fnnas.com> <20260622122902.F25CD1F00A3A@smtp.kernel.org>
To: <sashiko-reviews@lists.linux.dev>
Date: Tue, 23 Jun 2026 18:02:57 +0800
Message-Id: <8a81ba6e-3501-4b34-98fc-3479295937ff@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
From: "Chen Cheng" <chencheng@fnnas.com>

=E5=9C=A8 2026/6/22 20:29, sashiko-bot@kernel.org =E5=86=99=E9=81=93:
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>=20
> Pre-existing issues:
> - [High] Incomplete fix: identical Use-After-Free and mempool corruption =
in `raid_end_discard_bio`.
> - [High] Memory leak of `r10_bio` on `REQ_NOWAIT` write requests during c=
luster resync or reshape.
> --
>=20
> commit 088539a2820315440079f31df4aa792c8a6bc547
> Author: Chen Cheng <chencheng@fnnas.com>
>=20
> md/raid10: free r10bio before ending master_bio in raid_end_bio_io()
>=20
> This commit reorders the teardown sequence in raid_end_bio_io() to free
> r10_bio before calling bio_endio(). This prevents a race condition where
> a concurrent array reshape can alter the geometry and destroy the mempool
> after the master bio completes but before the r10_bio is freed.
>=20
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index d740744a97461..a4642c903b202 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -332,12 +332,12 @@ static void raid_end_bio_io(struct r10bio *r10_bio=
)
>>   {
>>   	struct bio *bio =3D r10_bio->master_bio;
>>   	struct r10conf *conf =3D r10_bio->mddev->private;
>> +	bool returned =3D test_and_set_bit(R10BIO_Returned, &r10_bio->state);
>> +	blk_status_t status =3D test_bit(R10BIO_Uptodate, &r10_bio->state)
>> +				? BLK_STS_OK : BLK_STS_IOERR;
>>  =20
>> -	if (!test_and_set_bit(R10BIO_Returned, &r10_bio->state)) {
>> -		if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
>> -			bio->bi_status =3D BLK_STS_IOERR;
>> -		bio_endio(bio);
>> -	}
>> +	put_all_bios(conf, r10_bio);
>> +	mempool_free(r10_bio, conf->r10bio_pool);
>>  =20
>>   	/*
>>   	 * Wake up any possible resync thread that waits for the device
>> @@ -345,7 +345,10 @@ static void raid_end_bio_io(struct r10bio *r10_bio)
>>   	 */
>>   	allow_barrier(conf);
>>  =20
>> -	free_r10bio(r10_bio);
>> +	if (!returned) {
>> +		bio->bi_status =3D status;
>> +		bio_endio(bio);
>> +	}
>>   }
>>  =20
>=20
> [Severity: High]
> This is a pre-existing issue, but the exact same race condition appears t=
o
> exist in the discard completion path.
>=20
> In drivers/md/raid10.c:raid_end_discard_bio():
>=20
> 	} else {
> 		md_write_end(r10bio->mddev);
> 		bio_endio(r10bio->master_bio);
> 		free_r10bio(r10bio);
> 		break;
> 	}
>=20
> Since bio_endio(r10bio->master_bio) drops active_io to zero, couldn't thi=
s
> also wake up mddev_suspend() and allow a concurrent reshape to modify
> conf->geo and destroy conf->r10bio_pool before free_r10bio() is called?
>=20

yes . raid_end_discard_bio have same issue .

>=20
> [Severity: High]
> This is a pre-existing issue, but does raid10_write_request() leak the r1=
0_bio
> on REQ_NOWAIT requests?
>=20
> In drivers/md/raid10.c:__make_request():
>=20
> 	r10_bio =3D mempool_alloc(conf->r10bio_pool, GFP_NOIO);
> ...
> 	if (bio_data_dir(bio) =3D=3D READ)
> 		raid10_read_request(mddev, bio, r10_bio);
> 	else
> 		raid10_write_request(mddev, bio, r10_bio);
>=20
> Then in raid10_write_request() during clustered resync:
>=20
> 	if ((mddev_is_clustered(mddev) &&
> 	     mddev->cluster_ops->area_resyncing(mddev, WRITE,
> 						bio->bi_iter.bi_sector,
> 						bio_end_sector(bio)))) {
> 		DEFINE_WAIT(w);
> 		/* Bail out if REQ_NOWAIT is set for the bio */
> 		if (bio->bi_opf & REQ_NOWAIT) {
> 			bio_wouldblock_error(bio);
> 			return;
> 		}
>=20
> And later during reshape:
>=20
> 		if (bio->bi_opf & REQ_NOWAIT) {
> 			allow_barrier(conf);
> 			bio_wouldblock_error(bio);
> 			return;
> 		}
>=20
> Since these paths return immediately, they leave the r10_bio allocated. C=
ould
> repeated REQ_NOWAIT rejections eventually exhaust conf->r10bio_pool, caus=
ing
> subsequent allocations in __make_request() to hang indefinitely?
>=20

seems fixed recently .
