Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD46E23392E
	for <linux-raid@vger.kernel.org>; Sat, 11 Jul 2026 08:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783759096; cv=none; b=YfqxtteGrIb+RDqedABH12csCUJNa6X1gu8qa+9iOkSMRE0kkQ7gtudhPctsh1O47X9lPf7os2Gbdya07cm3V/p9GW2yPdC9p4hMDO9BC/ZGcQR5OHRIOWkmTJd6FKcgE+5EbtjG+3krtuZ57hQeFXbTEs3/HiEqHOfp3rHnbRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783759096; c=relaxed/simple;
	bh=cvQYSkqMHKyy8R45o8U5om95cvpG9KXlicKa/yWOAyQ=;
	h=Cc:Date:In-Reply-To:Content-Type:To:Mime-Version:From:Subject:
	 Message-Id:References; b=qsRDHhA5uUhOxiIQJotAtb4OogsMgI4iHVvwT1wyH5Ue29GDJjD+pWYwLXebMtcsDFUu0dF7HhqelgUQJz4IO1E+Ru6OAbgtSQOLDvIIFQgH3vo5Rb8kMJRP7iJZ2Rh+egy0gjY2nOWNofP+FDo6xyOUyJYZpnmn+E3OPsIMDso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=r136t0b6; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="r136t0b6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783759087;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=mSL7HdSK+sK5MRPeatY2CnmR7sXOpT+LVAuO68navrI=;
 b=r136t0b6XDjnPOYnxoovG5z2XMkSy+hd/0vdVqHcrdtXE4X1bPrbkjIHIZJ7LDpgKvo9J1
 GO5W9jZQ40HnObkegAECNnrLXpw+UNe9Kloo8Pxos6snDiYFSN2a+fEMtB4TD26jdhguEE
 fuCUlkCZCDW/jOIHyGcbk/aO0o2akpNmwn+XHepLK3D18G5lP7htaQr6jDfFVmuiQM4AB2
 uAmncyZwgcMKGu1jMZjfs3eu0Iu28NK00xGGRHAcAUFA+WbMoyrgRPJ7hcJUhew5byuxW4
 NFQDvfePMLaiPYFwqGB0ZXSQzk3SEbmFIa434z66biW9kKBr2Zw4jlUYi89fYw==
Cc: <linux-kernel@vger.kernel.org>
Date: Sat, 11 Jul 2026 16:38:04 +0800
X-Lms-Return-Path: <lba+26a5200ed+777e1e+vger.kernel.org+chencheng@fnnas.com>
In-Reply-To: <fb8b048b-3912-44e8-9f56-a25989cd80ee@fygo.io>
Received: from [192.168.8.91] ([183.34.162.102]) by smtp.feishu.cn with ESMTPS; Sat, 11 Jul 2026 16:38:05 +0800
X-Original-From: Chen Cheng <chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: <yukuai@fygo.io>, <linux-raid@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: Re: [PATCH v6 3/3] md/raid10: free r10bio before ending master_bio in raid_end_bio_io() and raid_end_discard_bio()
Message-Id: <e3d981c9-19b4-4e7c-b9e6-c6831710e7cb@fnnas.com>
References: <20260623123840.2521340-1-chencheng@fnnas.com> <20260623123840.2521340-4-chencheng@fnnas.com> <fb8b048b-3912-44e8-9f56-a25989cd80ee@fygo.io>

=E5=9C=A8 2026/7/5 15:48, yu kuai =E5=86=99=E9=81=93:
> Hi,
>=20
> =E5=9C=A8 2026/6/23 20:38, Chen Cheng =E5=86=99=E9=81=93:
>> From: Chen Cheng <chencheng@fnnas.com>
>>
>> origin flow:
>>
>>         bio_endio(master_bio);   /* may drop active_io to zero */
>>         allow_barrier(conf);
>>         free_r10bio(r10_bio);    /* reads conf->geo, returns to pool */
>>
>> one scenario is:
>>
>>     CPU A (softirq, raid_end_bio_io)         CPU B (action_store) --> re=
shape
>>     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D         =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>     bio_endio(master_bio)
>>       md_end_clone_io
>>         percpu_ref_put -> 0
>>                                              wait_event wakeup, and,
>>                                              	mddev_suspend return
>>                                              raid10_start_reshape:
>>                                                setup_geo(&conf->geo, new=
)
>>                                                ...
>>                                                mempool_destroy(old_pool)
>>                                                conf->r10bio_pool =3D new=
_pool
>>     allow_barrier(conf)
>>     free_r10bio(r10_bio)
>>       put_all_bios:
>>         for (i=3D0; i<conf->geo.raid_disks; i++)
>>             =3D=3D> old obj, new geo, OOB
>>       mempool_free(r10_bio, conf->r10bio_pool)
>>             =3D=3D> old-geometry obj freed into new pool
>>
>> so .. fix by reorder the flow:
>>
>> 	free_r10bio(r10_bio)
>> 	allow_barrier(conf)
>> 	bio_endio(master_io)
>>
>> raid_end_discard_bio() is exactly the same.
>>
>> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
>> ---
>>    drivers/md/raid10.c | 17 ++++++++++-------
>>    1 file changed, 10 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index d740744a9746..e44a9b6e95c7 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -330,24 +330,25 @@ static void reschedule_retry(struct r10bio *r10_bi=
o)
>>     */
>>    static void raid_end_bio_io(struct r10bio *r10_bio)
>>    {
>>    	struct bio *bio =3D r10_bio->master_bio;
>>    	struct r10conf *conf =3D r10_bio->mddev->private;
>> +	unsigned long state =3D r10_bio->state;
>>   =20
>> -	if (!test_and_set_bit(R10BIO_Returned, &r10_bio->state)) {
>> -		if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
>> -			bio->bi_status =3D BLK_STS_IOERR;
>> -		bio_endio(bio);
>> -	}
>> +	free_r10bio(r10_bio);
>>   =20
>>    	/*
>>    	 * Wake up any possible resync thread that waits for the device
>>    	 * to go idle.
>>    	 */
>>    	allow_barrier(conf);
>>   =20
>> -	free_r10bio(r10_bio);
>> +	if (!test_and_set_bit(R10BIO_Returned, &state)) {
>> +		if (!test_bit(R10BIO_Uptodate, &state))
>> +			bio->bi_status =3D BLK_STS_IOERR;
>> +		bio_endio(bio);
>> +	}
>=20
> Why is this moved to the end? I feel it's not necessary.
>=20

yes, point is let endio after free r10bio.

free_r10bio(r10_bio) -> allow_barrier(conf) -> bio_endio(master_io) or

free_r10bio(r10_bio) -> bio_endio(master_io) -> allow_barrier(conf)

both order is correct to fix the bug.

>>    }
>>   =20
>>    /*
>>     * Update disk head position estimator based on IRQ completion info.
>>     */
>> @@ -1580,13 +1581,15 @@ static void raid_end_discard_bio(struct r10bio *=
r10bio)
>>    		if (!test_bit(R10BIO_Discard, &r10bio->state)) {
>>    			first_r10bio =3D (struct r10bio *)r10bio->master_bio;
>>    			free_r10bio(r10bio);
>>    			r10bio =3D first_r10bio;
>>    		} else {
>> +			struct bio *master_bio =3D r10bio->master_bio;
>> +
>>    			md_write_end(r10bio->mddev);
>> -			bio_endio(r10bio->master_bio);
>>    			free_r10bio(r10bio);
>> +			bio_endio(master_bio);
>>    			break;
>>    		}
>>    	}
>>    }
>>   =20
>
