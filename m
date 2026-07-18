Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D342134F26F
	for <linux-raid@vger.kernel.org>; Sat, 18 Jul 2026 12:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784377838; cv=none; b=sGOMvyo+E7DLonJGX/L+zNyhJKQXhl2j0CWreGEBomUjTA6zHmUA0B3zl0tlPYgjmgLObXchdtSkLxlZRhWq4ZaGFHdzUS+INwEFqSRuXNAvL2wQdp6eCMYE7eSwcq0AjVW182TN+bu/Rhxs9XATwIq8bjkHRT2ONqpp460niiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784377838; c=relaxed/simple;
	bh=wr8AhaFp4thLv5UK8R3sJAZE++qp85VAdU+PcEtdHak=;
	h=Cc:Date:Message-Id:Subject:From:In-Reply-To:To:Mime-Version:
	 Content-Type:References; b=X3cmUf+PYk7qeRhRoMHmGjm6hWcRrP634wSjfWS9EgrC4icuf1mWjcu5BFWSi+V9Ku/Lh0vB2qsWl16Tjuw0jzTKMSN6ni0IYlSBfGWJnJfMxbaZav7xx3vbIhfnUni3pvv43w0VkKyI6GlVT4xZOEh67/91o2FK3Hg2jorCrLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=uwZQM2jK; arc=none smtp.client-ip=209.127.231.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="uwZQM2jK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1784377826;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Ot8sjg1ac+CXODH+Xjh5nk57Sic1fGwSegEVysUQMtg=;
 b=uwZQM2jKP0uWnZnvV7fcHNIrXJ4sZM7kE0Bzv2IcOEXk/OwHvof1soM5rmds92HyZM8GsJ
 xnm2rtHH4ntnxBQnWB4K/TJtzTL9zQq83IFSb+INGp5YmMsJskJf1VOs7yU6fCwlJfg1pD
 n6aJFX1l6PRukZwu+xupSpdK7XTtHbDbiubfgyFOcv7PI1noLEBT2RJy+V3T5Mofrg7o7C
 BE9NrtDWAMHQTZBc2awRjxP+DSR3JviGh+X1JtomG3L3P3qmqZDZKI6w5FjZDxRHSfeweW
 y2p1ibiB09pmNsCjqHrGLQ20TVqxBZlYqQERY4oW9zrIaB2197RbL/89Ake1IQ==
Cc: <linux-kernel@vger.kernel.org>
Date: Sat, 18 Jul 2026 20:30:22 +0800
Message-Id: <382167e4-94fc-476c-b610-831f31c80df9@fnnas.com>
X-Original-From: Chen Cheng <chencheng@fnnas.com>
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/3] md/raid10: free r10bio before ending master_bio in raid_end_bio_io() and raid_end_discard_bio()
X-Lms-Return-Path: <lba+26a5b71e0+a5f527+vger.kernel.org+chencheng@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
In-Reply-To: <2a399970-710a-49fb-ab72-e1076b05cfbc@fygo.io>
To: <yukuai@fygo.io>, <linux-raid@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <20260711100352.425177-1-chencheng@fnnas.com> <20260711100352.425177-4-chencheng@fnnas.com> <2a399970-710a-49fb-ab72-e1076b05cfbc@fygo.io>
Received: from [192.168.8.80] ([183.34.161.69]) by smtp.feishu.cn with ESMTPS; Sat, 18 Jul 2026 20:30:23 +0800

=E5=9C=A8 2026/7/12 01:43, yu kuai =E5=86=99=E9=81=93:
>> -	if (!test_and_set_bit(R10BIO_Returned, &r10_bio->state)) {
>> -		if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
>> -			bio->bi_status =3D BLK_STS_IOERR;
>> +	returned =3D test_and_set_bit(R10BIO_Returned, &state);
>> +	if (!returned && !test_bit(R10BIO_Uptodate, &state))
>> +		bio->bi_status =3D BLK_STS_IOERR;
>> +
>> +	free_r10bio(r10_bio);
>> +
>> +	if (!returned)
>>    		bio_endio(bio);
>> -	}
> Apparently this change is not enough, the R10BIO_Returned case still retu=
rn
> the master_bio before freeing r10_bio.
>=20



hi Kuai,

thanks for review.

After read the relate part, two scenarios goto raid_end_bio_io:
	a. bio_submit_split_bioset() failed cause early return, and
	b. normal raid-10 completion -> finially call raid_end_bio_io()

for (a), protected by md_handle_request()'s active_io ref life-scope.
	so, even close master io earily , active_io still alive.

for (b), after fix,  free r10bio first. then, close master bio, which
	md_end_clone_io() put active_io refcnt.

both is ok , I think.

thanks.
cheng


> I think you should get an active_io reference while allocating r10_bio to
> guarantee that no r10_bio is active while array is suspended.
>=20
>>   =20
>>    	/*
>>    	 * Wake up any possible resync thread that waits for the device
>>    	 * to go idle.
>>    	 */
>>    	allow_barrier(conf);
>> -
>> -	free_r10bio(r10_bio);
>>    }
>>   =20
>>    /*
>>     * Update disk head position estimator based on IRQ completion info.
>>     */
>> @@ -1579,13 +1582,15 @@ static void raid_end_discard_bio(struct r10bio *=
r10bio)
>>    		if (!test_bit(R10BIO_Discard, &r10bio->state)) {
>>    			first_r10bio =3D (struct r10bio *)r10bio->master_bio;
