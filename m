Received: from va-2-39.ptr.blmpb.com (va-2-39.ptr.blmpb.com [209.127.231.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6D73CE083
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 08:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782204278; cv=none; b=hcpZE5fpA+ZCWMGUhrmOTLQ7P+6KNMz8JHLqt4DUNq8i4+cUVOqzyLQGxpEBHVcTjKynLQ42TFR7aTK3GF+FxutoJoIjbpxYtIzUYLWyh/1b/qx6YwG+y7E5TES04XjzZO1MwfHwI/0VcPkHZ6xgVocUev/1PWNdXGjJVABxhVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782204278; c=relaxed/simple;
	bh=6a3JyV+buGly1uktPAWCmnYFHWziVzbl4UjeB3wDa98=;
	h=Cc:References:To:Message-Id:In-Reply-To:From:Subject:Date:
	 Mime-Version:Content-Type; b=B67P3kdpq1mYd4iZ5n7QH/9fZ+texMErVENWMIVw1iJ/3IACWLvhd9+tbJxIvv1u7cEj9rC76kBahBgBzvnRR6tVhMN/MPPuX4MD/zli3oiq1ffmkN6k4w0HFViTrXpqpslZHADaDUXfX4YYzORCfFN16vaKmMfaxgefEjUj++k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=adMTg3Nh; arc=none smtp.client-ip=209.127.231.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="adMTg3Nh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782204265;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=+2e0KB3c4IEtDmjd5t9RQHu22IMEunkp4T+g9t8dV7I=;
 b=adMTg3NhJ2DIIS73ODseMjK2O4fCUx3iznQRdYqsKmcKl/D6cn8PcFAbyYX+AFnx2h0ecc
 vBWkpo/YQtwhbFkuZk4n07RJ+EfJElp1wM+ppADqBNTO6UAxbgpAI/OiiasU5TxIfpWcpj
 UoD/w3THK30A/pBk3jShqhHXoFTdC+QRHn+d+26JwWxwDCPxbV7MthBohmDRqyZ4WPMqS3
 LyTMlC+BidgfUK1tN0sbhH7FmpV8UFcMkU5jnjcAYSE9yS7RJoVsW5//SsorbjE8sBMXub
 bOkmk67yLj3D5ASE8J0O7Nrw3mgO5uAavNGR5LS+gzsKrCb7r3NV3c40tubZ9w==
Cc: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>
References: <20260623081942.2488045-1-chencheng@fnnas.com> <20260623082915.1B8A71F000E9@smtp.kernel.org>
User-Agent: Mozilla Thunderbird
To: <sashiko-reviews@lists.linux.dev>
Message-Id: <ab103643-dadc-423a-890d-bed781384e17@fnnas.com>
In-Reply-To: <20260623082915.1B8A71F000E9@smtp.kernel.org>
X-Lms-Return-Path: <lba+26a3a4768+f25ffc+vger.kernel.org+chencheng@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: Re: [PATCH] md: use READ_ONCE() for lockless reads of sb_flags
Date: Tue, 23 Jun 2026 16:44:21 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.8.62] ([183.34.170.156]) by smtp.feishu.cn with ESMTPS; Tue, 23 Jun 2026 16:44:23 +0800
Content-Type: text/plain; charset=UTF-8
X-Original-From: Chen Cheng <chencheng@fnnas.com>

=E5=9C=A8 2026/6/23 16:29, sashiko-bot@kernel.org =E5=86=99=E9=81=93:
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] Incomplete fix: The patch claims to resolve KCSAN data races o=
n `sb_flags` in md, raid1, raid5, and raid10, but completely omits the nece=
ssary `READ_ONCE()` updates to the `raid1`, `raid5`, and `raid10` subsystem=
s.
> --
>=20
> commit adcaa558925c24a70a377065ea735febac939f0b
> Author: Chen Cheng <chencheng@fnnas.com>
>=20
> md: use READ_ONCE() for lockless reads of sb_flags
>=20
> This commit adds READ_ONCE() wrappers around lockless reads of mddev->sb_=
flags
> to prevent KCSAN data race warnings. The commit message states it address=
es
> issues across md, raid1, raid5, and raid10.
>=20
>>      sb_flags is checked without a lock in md, raid1, raid5, and raid10.
>>      KCSAN reports these reads as data races.
>>     =20
>>      The write side uses atomic bit ops.
>>      The read side still has plain loads in a few places.
>>     =20
>>      Use READ_ONCE() for the lockless reads of sb_flags.
>=20
> [Severity: Medium]
> Does this patch completely address the data races mentioned in the commit
> message?
>=20

There isn't data races in strong consistency model arch..
raidXd() would be call periodically, so , steal value is ok..
But I see kcsan report, and I think use read_once to read would be better.

> The commit message indicates that sb_flags is checked without a lock in m=
d,
> raid1, raid5, and raid10, and includes KCSAN traces for raid1d, raid5d, a=
nd
> raid10d. However, the provided diff only includes changes to drivers/md/m=
d.c.
>=20
> Are there additional READ_ONCE() updates missing for the raid1, raid5, an=
d
> raid10 subsystems? For example:
> - drivers/md/raid1.c:raid1d()
> - drivers/md/raid5.c:raid5d(), ops_run_io(), and reshape_request()
> - drivers/md/raid10.c:raid10d() and reshape_request()
>=20

raidXd() all call md_check_recovery().

>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 096bb64e87bd5..f83cca895f85f 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
> [ ... ]
>> @@ -10425,7 +10425,7 @@ void md_check_recovery(struct mddev *mddev)
>>   			spin_unlock(&mddev->lock);
>>   		}
>>  =20
>> -		if (mddev->sb_flags)
>> +		if (READ_ONCE(mddev->sb_flags))
>>   			md_update_sb(mddev, 0);
>>  =20
>>   		/*
>=20
> [Severity: Medium]
> Are there other plain reads of sb_flags remaining in this file?
>=20
> Looking at drivers/md/md.c:__md_stop_writes(), there appears to be anothe=
r
> plain lockless read of mddev->sb_flags. Should that also be wrapped with
> READ_ONCE() to fully eliminate the KCSAN warnings?
>=20

Only add protect for lockless path. __md_stop_writes() already protected=20
by mddev_lock.
