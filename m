Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEA724113D
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 06:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782282766; cv=none; b=IBHsr1GPu692VguEf4gGBfOEuJe+cfuccAD7dsadQsEgFkZS+7mGQGFDU+/d0Pv9t847Kj1C7iOPC/aQATneJgMIzB0ZeQIiTxXp99bTCp9PmsDnneIuqxXRuQ7xaCjMSEXibiq9O09EJU0JjL+wGwQlcxwnL0hYZenaM50CvXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782282766; c=relaxed/simple;
	bh=QNCFY19qmD7v8/OACFuQ9+AMmsX1HzrtDbFmy8IMb7w=;
	h=Cc:Subject:Mime-Version:References:Date:Message-Id:In-Reply-To:To:
	 From:Content-Type; b=JxxIw1nh9im1LWPHx97X/p33YyQAdwLR78bZpauAZsSOQSaxQ8qfecpjf4Nh8nfqDEeaeA2hjQT9jMZZ+iw9m5A/0gbWnAXVf97xu+AU+pu5kW5u5cR4Y0tOPF7w0zlrQZXr6kSpnLHoRpNUELcv2tuH6vjIdO8fJGb8m7JyBgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=AlzVWoAZ; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="AlzVWoAZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782282759;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Z38jOtd0UchS/P9yGsksjC9qEN9lSSS3lQ6W1XCzxjU=;
 b=AlzVWoAZFvyedmL6ZOpeLgVS1MUPCpxr5x1q7KH72d/zstjpIbc002CLPLN5qpCLLp5RTo
 JpYOWO+2NQHY4oSVcxnLGrUpkPKcUFFSHhlinHzwWHQmwf0mmOx2NrZ7bAfo1a7wbG7MZ6
 qro0V0cUazoBabmiTOIfdS9Z12qu9CvJs+Z/WDittcHGauN5Cq04SwvTuqpM1aCVK+RXoP
 4N+mGlCRmr8/+39+mtGz0F5HKSQwZeEaPac7F7IYq6rpjYyu8ZXyoDClOm6dvSZRBhkouY
 hxDzb/qBdqsnUuBJjuOCz4Wl1/UDpg4MhKbtkh/sZ7v8N6L6kkW3pEb+bNRYsA==
Cc: <yukuai@fygo.io>, <linux-raid@vger.kernel.org>
Subject: Re: [PATCH v6 2/3] md/raid10: resize r10bio_pool for reshape
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
References: <20260623123840.2521340-1-chencheng@fnnas.com> <20260623123840.2521340-3-chencheng@fnnas.com> <20260623130100.477FE1F000E9@smtp.kernel.org>
Date: Wed, 24 Jun 2026 14:32:34 +0800
X-Lms-Return-Path: <lba+26a3b7a05+1b5d60+vger.kernel.org+chencheng@fnnas.com>
Message-Id: <05b24fee-b9d9-45b5-9453-abd3d0b6b3d8@fnnas.com>
In-Reply-To: <20260623130100.477FE1F000E9@smtp.kernel.org>
X-Original-From: Chen Cheng <chencheng@fnnas.com>
To: <sashiko-reviews@lists.linux.dev>
From: "Chen Cheng" <chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.8.62] ([183.34.167.222]) by smtp.feishu.cn with ESMTPS; Wed, 24 Jun 2026 14:32:35 +0800

=E5=9C=A8 2026/6/23 21:00, sashiko-bot@kernel.org =E5=86=99=E9=81=93:
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] The newly allocated `new_pool` is leaked on the `reshape_backw=
ards` error path.
> --
>=20
> commit 2142096170ffdd8a1caabfde6f2461f6e7d64f61
> Author: Chen Cheng <chencheng@fnnas.com>
>=20
> md/raid10: resize r10bio_pool for reshape
>     =20
> When reshape grows raid_disks, the pool must also switch to new geometry
> object size, and allocate a new geometry size pool and replace the old.
>=20
> But not for shrinking reshape, because regular I/O can still use the
> prev geo for sectors that have not crossed reshape_progress yet.
>=20
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index cee5a253a281d..d740744a97461 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
> [ ... ]
>> @@ -4411,6 +4422,11 @@ static int raid10_start_reshape(struct mddev *mdd=
ev)
>>   		return -EINVAL;
>>  =20
>>   	conf->offset_diff =3D min_offset_diff;
>> +	if (mddev->delta_disks > 0) {
>> +		new_pool =3D create_r10bio_pool(new.raid_disks);
>> +		if (!new_pool)
>> +			return -ENOMEM;
>> +	}
>>   	spin_lock_irq(&conf->device_lock);
>>   	if (conf->mirrors_new) {
>>   		memcpy(conf->mirrors_new, conf->mirrors,
>=20
> [Severity: Medium]
> Will this newly allocated new_pool be leaked if the reshape_backwards
> error path is triggered?
>=20
> If an array is configured for a reshape that expands the number of disks
> (delta_disks > 0), the new_pool is allocated here. However, if the
> component device sizes are also reduced such that the array is set to
> reshape backwards, it can hit a pre-existing error check a few lines
> down:

It's impossible use backward reshape while delta disk > 0 or change=20
component size.

>=20
> 	if (mddev->reshape_backwards) {
> 		sector_t size =3D raid10_size(mddev, 0, 0);
> 		if (size < mddev->array_sectors) {
> 			spin_unlock_irq(&conf->device_lock);
> 			pr_warn("md/raid10:%s: array size must be reduce before number of disk=
s\n",
> 				mdname(mddev));
> 			return -EINVAL;
> 		}
>=20
> This direct return skips the standard cleanup path at the abort label,
> causing the mempool_t structure and its preallocated elements to leak.
> Should we add a mempool_destroy(new_pool) here, or change the return to
> a goto abort?
>
