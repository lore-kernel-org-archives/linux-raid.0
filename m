Received: from va-2-39.ptr.blmpb.com (va-2-39.ptr.blmpb.com [209.127.231.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F3F1A9FB7
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 01:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782093178; cv=none; b=R9TxIPM/+KhjJGEq87tOL918z8Gy42rAziJxUbod2/QrCOwyFXMfLBsIK37BpzdEQVpB4NG9Dkjzbr4InNyywMhgqgBpkYR9QR/D+Dq0exXDvZTmguXYogatuuuN/+b0mlmARQDXQQXVuzkMKvyui3hFz0N0Gsh5bZri4Plddgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782093178; c=relaxed/simple;
	bh=Y7isyy8QElkykiisnn5YMjiYG9+P7eyJh5DqmIqCFoE=;
	h=Mime-Version:From:To:Message-Id:Content-Type:Cc:Date:In-Reply-To:
	 References:Subject; b=Cqiyjf4h46y+5bR8S7u9C94IRraORJeo54xSxybcpo4SUsNC6OshLAaHulWe9u4WBS0JASXtpEfkqdgIAX0ldokRp+HnBtccBtym8SqtVJ/iiAP8sqvxJ3PD9QbU9QpLE1Ie6bwtlTQTUQ4QzqEVwl3VVK50B2F+iSnHFNgIIjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=WSgnIW6b; arc=none smtp.client-ip=209.127.231.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="WSgnIW6b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782093165;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=UHynic1vZJw8XAQBCHKv1lR1741VUUyfaTgYXV88HKE=;
 b=WSgnIW6biaUXVeEkyHAVPanTg+NLIOnuBXmcRynenUa63esEArPIdGNzndizaD21kbic0V
 AJqQN4BfPqqtBdGIpJXuBrjDQXYy2KMZJtgS464QTwTHrAqsJkM15GK8oEd/ElLn+r5ea9
 /cnBfTJc0C9tsS9AedDnZPqdhm4JNVNY/o3+JKR4ZomtFeDzZ6vyeSrmFYX1FmeixWSDkk
 llpDGpRyyh15zDblA40Z5uheb1t1VH1Lc6mxt7RuEsNLNJx2dvdS9A2MfERp3D0qqGv09P
 lSSsRHCdhpu5Ptjec80w2Jel0xxo63Ydz8hAiS/VFMMX4jMcsKzmpqwRoGPYjQ==
X-Lms-Return-Path: <lba+26a38956b+2de940+vger.kernel.org+chencheng@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: "Chen Cheng" <chencheng@fnnas.com>
To: <yukuai@fygo.io>, <linux-raid@vger.kernel.org>
Message-Id: <72d4202b-d0da-4424-9c53-ddc1fd15fa67@fnnas.com>
Received: from [192.168.8.62] ([183.34.162.92]) by smtp.feishu.cn with ESMTPS; Mon, 22 Jun 2026 09:52:41 +0800
X-Original-From: Chen Cheng <chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Cc: <chenchneg33@gmail.com>, <linux-kernel@vger.kernel.org>
Date: Mon, 22 Jun 2026 09:52:40 +0800
In-Reply-To: <d7011132-d213-4dea-9c1d-c8fd9d6e93e0@fygo.io>
User-Agent: Mozilla Thunderbird
References: <20260617142839.882378-1-chencheng@fnnas.com> <d7011132-d213-4dea-9c1d-c8fd9d6e93e0@fygo.io>
Subject: Re: [PATCH v2] md/raid5: protect bitmap batch counters aka seq_flush/seq_write consistency

=E5=9C=A8 2026/6/21 05:13, yu kuai =E5=86=99=E9=81=93:
> Hi,
>=20
> =E5=9C=A8 2026/6/17 22:28, Chen Cheng =E5=86=99=E9=81=93:
>> From: Chen Cheng <chencheng@fnnas.com>
>>
>> kcsan detect race :
>> - raid5d() closes the current bitmap batch by updating
>> 	conf->seq_flush under conf->device_lock.
>> - __add_stripe_bio() read conf->seq_flush without that
>> 	lock when assigning sh->bm_seq.
>>
>> so, protect seq_flush/seq_write consistency for multiple CPUs by
>> READ_ONCE()/WRITE_ONCE() under the path without held device_lock.
>>
>> re-explain the stripe batch sequence number update flow:
>> 1. sh->bm_seq declare which batch number the stripe belongs to
>>      when perform bitmap-related write.
>> 	=3D=3D> bm_seq =3D seq_flush+1
>>
>> 2. stripe be handled,
>> 	* if sh->bm_seq - conf->seq_write > 0, means the
>> 	  batch stripes **newer than** the last written
>> 	  batch, it cannot proceed yet, queued on bitmap_list.
>> 	* otherwise , has already proceed.
>>
>> 3. raid5d() `++seq_flush` to closes the current batch, means
>> 	* no more stripes join that old batch
>> 	* just-closed batch ready to write-out to disk
>>
>> 4. raid5d() calls bitmap hooks unplug() or writeout, then,
>>      `++seq_write` to the same as bm_seq.
>>
>> - seq_flush - for producer, to close batches.
>> - seq_write - for consumer, the checkpoint number.
>>
>> the report:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> BUG: KCSAN: data-race in __add_stripe_bio / raid5d
>>
>> write to 0xffff88ba5625d470 of 4 bytes by task 82401 on cpu 0:
>>    raid5d+0x1d9/0xba0
>>    [.....]
>>
>> read to 0xffff88ba5625d470 of 4 bytes by task 82421 on cpu 8:
>>    __add_stripe_bio+0x332/0x400
>>    raid5_make_request+0x6ac/0x2930
>>    md_handle_request+0x4a2/0xa40
>>    md_submit_bio+0x109/0x1a0
>>    __submit_bio+0x2ec/0x390
>>    [.....]
>>
>> v1 -> v2:
>> - remove WRITE_ONCE(conf->seq_write) in held device_lock path.
>> - remove READ_ONCE(conf->seq_flush) in held device_lock path.
>>
>> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
>> ---
>>    drivers/md/raid5.c | 9 +++++----
>>    1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index a320b71d7117..b2c5a1930841 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -3536,11 +3536,11 @@ static void __add_stripe_bio(struct stripe_head =
*sh, struct bio *bi,
>>    	pr_debug("added bi b#%llu to stripe s#%llu, disk %d, logical %llu\n"=
,
>>    		 (*bip)->bi_iter.bi_sector, sh->sector, dd_idx,
>>    		 sh->dev[dd_idx].sector);
>>   =20
>>    	if (conf->mddev->bitmap && firstwrite && !sh->batch_head) {
>> -		sh->bm_seq =3D conf->seq_flush+1;
>> +		sh->bm_seq =3D READ_ONCE(conf->seq_flush) + 1;
>>    		set_bit(STRIPE_BIT_DELAY, &sh->state);
>>    	}
>>    }
>>   =20
>>    /*
>> @@ -5827,11 +5827,11 @@ static void make_discard_request(struct mddev *m=
ddev, struct bio *bi)
>>    			md_write_inc(mddev, bi);
>>    			sh->overwrite_disks++;
>>    		}
>>    		spin_unlock_irq(&sh->stripe_lock);
>>    		if (conf->mddev->bitmap) {
>> -			sh->bm_seq =3D conf->seq_flush + 1;
>> +			sh->bm_seq =3D READ_ONCE(conf->seq_flush) + 1;
>>    			set_bit(STRIPE_BIT_DELAY, &sh->state);
>>    		}
>>   =20
>>    		set_bit(STRIPE_HANDLE, &sh->state);
>>    		clear_bit(STRIPE_DELAYED, &sh->state);
>> @@ -6877,16 +6877,17 @@ static void raid5d(struct md_thread *thread)
>>    			clear_bit(R5_DID_ALLOC, &conf->cache_state);
>>   =20
>>    		if (
>>    		    !list_empty(&conf->bitmap_list)) {
>>    			/* Now is a good time to flush some bitmap updates */
>> -			conf->seq_flush++;
>> +			int seq =3D conf->seq_flush + 1;
>=20
> checkpatch should warn this about missing blank line after declaration.

ok.

>=20
>> +			WRITE_ONCE(conf->seq_flush, seq);
>=20
> WRITE_ONCE(a, a + 1) is safe, you can see lots of examples.

Gotta re-use `conf->seq_flush` snapshot aka. `seq` below..

>=20
>>    			spin_unlock_irq(&conf->device_lock);
>>    			if (md_bitmap_enabled(mddev, true))
>>    				mddev->bitmap_ops->unplug(mddev, true);
>>    			spin_lock_irq(&conf->device_lock);
>> -			conf->seq_write =3D conf->seq_flush;
>> +			conf->seq_write =3D seq;
>>    			activate_bit_delay(conf, conf->temp_inactive_list);
>>    		}
>>    		raid5_activate_delayed(conf);
>>   =20
>>    		while ((bio =3D remove_bio_from_retry(conf, &offset))) {
>
