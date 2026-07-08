Received: from va-2-18.ptr.blmpb.com (va-2-18.ptr.blmpb.com [209.127.231.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F9D38C414
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 08:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783499587; cv=none; b=fNZ+MuG+akhu1NfekcRuRgjzt+gmarWC4EVKMkKVW4ux4TjBqrJ0YoDv854cySP+/oPOFxhz4zcg98d3aqwOaMBgSz/6QcruPZ08mL93MEYReMO+UlxPIonSAupmh3GtInncQPuC7aCVHpx2gxm3g3FABUT0dUUz57yLr32OFA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783499587; c=relaxed/simple;
	bh=DAIYywAR0W/NeFuMl6ZKhnDTCa6O2gpOiqJwwJ+8nUM=;
	h=References:Cc:Message-Id:Mime-Version:In-Reply-To:To:From:Subject:
	 Content-Type:Date; b=FhPhYUYR/7YPd/MNfQwqYuBWFZKac19kSOO88sBgrJXO2Ceq0etDmZvrIIWmY+vgg893W9eGzi//F58okL3fac5S6NIrhvKgzuFD11KPJF+zzs9iNCDDL0M7xUennIOIjxlOcKEmXNuyphKm3PoIqBFN9PV/C5IxctS+RQ0OZ8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=m+Qdj5rS; arc=none smtp.client-ip=209.127.231.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="m+Qdj5rS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783499572;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=DAIYywAR0W/NeFuMl6ZKhnDTCa6O2gpOiqJwwJ+8nUM=;
 b=m+Qdj5rSgjeJfdP2a72rpGSdZP5fkLtH99SCbPXPSmgg7HzDzcGzzrUBGxyRaI93KFtRUs
 k1F5d5h4zwiSCW7fZz3NUiiVzdHcNOqheMZH3kF2MgboBkVfqvWpCS6EXxEEaAfICpknVH
 lFBG7DIZqMK1cQYpUM2u7Tpt2MJWE4IGpJqvLvbICacP6vtsQNZRkr11IbcwExAct2015h
 fKDYH9MV9w4BxGUrI2FnWkKpxpch2QW37oYcNtSiaugP98bNu1s+unMptZKpK6aePjgYCc
 pu+ORF+Q7gluRAEeWVp8fllnwcw0fshDLbMjWVRJN4+p9nR/9KKHMyqfPq5H6g==
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Wed, 08 Jul 2026 08:32:50 +0000
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a4e0b33+bff0e9+vger.kernel.org+yukuai@fygo.io>
References: <20260630075640.1081634-1-abd.masalkhi@gmail.com> <0a7dc7e2-30af-44de-8c29-b6e27a62fa55@fygo.io> <m2se5x6wff.fsf@gmail.com> <4f0b2516-65bd-41fa-abc3-3cd76951ec46@fygo.io> <m2mrw36qap.fsf@gmail.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"sashiko-bot" <sashiko-bot@kernel.org>
Message-Id: <f30acc2d-9153-4a9c-b6e5-79083bd9fedb@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <m2mrw36qap.fsf@gmail.com>
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, 
	"yu kuai" <yukuai@fygo.io>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md: avoid modifying spares while the array is not suspended
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
Date: Wed, 8 Jul 2026 16:32:47 +0800
X-Original-From: yu kuai <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/7/7 18:35, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
> Hi Kuai,
>
> On Tue, Jul 07, 2026 at 09:12 +0800, yu kuai wrote:
>> Hi,
>>
>> =E5=9C=A8 2026/7/6 3:58, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>>>> The problem looks real, however, I think this will cause a change that=
 user will be awared,
>>>> if there are really spares that can be removed from conf, but array is=
 not suspended here,
>>>> user will still expect rdev will be removed from conf automatically.
>>>>
>>>> In md_start_sync, if suspend is false, can we check again after mddev_=
lock? If suspend is
>>>> supposed to be true, we can release the lock and retry with suspend =
=3D true.
>>>>
>>> Yes, I see, and your approach is much better. But what do you think
>>> about taking the lock first and then checking only once?
>> I don't get what you mean. If we take the lock and then check that array=
 should
>> suspend, we still have to release the lock before we suspend the array.
>>
> Sorry, I was not clear. I meant, do we need to check twice, once before
> taking the lock and once after? It seems that the check before taking the
> lock is redundant. since the result would need to be checked again after
> taking the lock anyway.
>
> Could we drop the check before taking the lock and only check whether
> suspension is needed once while holding it? If suspension is needed, we
> would release the lock, suspend the array, and then reacquire the lock.

Thanks for the explanation, I understand now. Howerver, I still prefer to c=
heck
first before holding the lock. Because the checking is much lower overhead =
than
acquire reconfig_mutex, and the race window that rdev become spare is small=
, so
it's unlikely we'll acquire reconfig_mtuex twice.

>
>> --=20
>> Thanks,
>> Kuai

--=20
Thanks,
Kuai
