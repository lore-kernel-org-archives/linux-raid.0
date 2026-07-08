Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB640401A14
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 08:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783501147; cv=none; b=fg69Ez0BPuc8jRL4+K6XcAXgBqax3iLDcDrUYBnjK4nae1frmkuEpDSCr9//o7ZFgkYsPoOgvTeVYsvFwKoOslbMc1Mz9V3Dc5F3y4ruQKFjfNroDfex4uMXLlgZE8nkejKn/wnh6tL2bxi1hYXtPeg0qZfCLKkTFAx3k/Wtiq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783501147; c=relaxed/simple;
	bh=0jEicuR8vQSQKyoixKtyUOW/T1sz//S8YUpGR+ZOTic=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ho0n5sdfVTzSj5dWDPhh2CBzOWHm9/HhgcfUdsRCZ6qPUaR05nqbIxl+EOaqyZRRN03Rtzeb7chOhsPH1/WoPt61YBgvToTM8PoahZ3qsYxatHBCSyiYO8rvjbv+1QaOFQmbnkJD47zuhOy9t70/TJfBAbBYmq9cMAEe4twTfU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XgQD9pdw; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XgQD9pdw"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-476a130c138so479225f8f.0
        for <linux-raid@vger.kernel.org>; Wed, 08 Jul 2026 01:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783501144; x=1784105944; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0jEicuR8vQSQKyoixKtyUOW/T1sz//S8YUpGR+ZOTic=;
        b=XgQD9pdwX1OFyoTrRf4iRb39W8FQS6jvDD+/YQ9pREDH03kouC+XV7hGtGfNmWrYxq
         5N3tBz8mLKZFWxDxQGYYBdCAwwt9QmcpoMlx7wzdc3R04Cuh29H4dVh0UwPk2vYeMEfd
         JThMrgdNN/viKBv/5x6Ey5PIxFV5nCTsDx83CqdUUK+bAX8RppLOFVuwtUfRGSsFGP2D
         XmaQfzI827W6jthxA/42SaCa+Ay87+rmnYD54dc3j+oisfzBDeqt9BOAurcJfSUANqYh
         xQcoJeCjHCNwgLrE9tf3Xz/aOZzu8Cbxkt1FfiERahhQ/ol7wjN07+Uh3IXbqB/IU+qS
         en8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783501144; x=1784105944;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0jEicuR8vQSQKyoixKtyUOW/T1sz//S8YUpGR+ZOTic=;
        b=CJ8TK8uL2QxldgNAdvrseCfaIhx9/+DDHUVeoOZ2jqoluhWAlnxZyy6bsiLHYQKb/w
         Bt/Ybn/mWewYbUyTEMFfX/C31BnZ+znSFJ/+djdsq71uu7DRq8hEPLl8UQrC1pLWpG5t
         4VLiwwDGIDOE+tc6Giht2Tlbjo9WeSBmrP0Q9vU1iugLWeSDgmfCRvc8OtoMjRvggDTo
         KDUECv2bL6QZH2ekVZIwkjGgnTv6/KkgONDYiPuZCw1Mvk1IKBEHK0sXNwNWP93Ft+Ez
         5J0aWtu/r4NVpIAQo1pnJ0csHSfvIa8Ak/+tvOKD6NV4quoAQJFBsf8s4UtzQB2SxoaP
         gCwQ==
X-Gm-Message-State: AOJu0YwIW90fH41bRiIb2EbkCOlXGqav4ECSwsfkENHhSI+7N7CfWU9X
	MlNEpy05hRmV8VPJAalQGWbhAYc2MLJae8AtRgZGRdfXhjHH5t0depKw
X-Gm-Gg: AfdE7cml5E6WND9ZJw9JPFqbpNvrqCjJ0/7OC8Hu3abfd9lkTBpxQj+cg4tjoavvL92
	fYJg4PSyJlMVdV1+7WrFw4T2yxlBGrLM3w8g2u4W912FU0U0aV7FDX2Vrrf1LJp1wvldJ18xq0K
	JBeZBYUAxjYfH6gerokJI3HYpZ7SDAQRoG3doIA0/fRVKUTixogjS3zylJ66yPr59rhf6n7IPHD
	BG0/ZP/c3//pkwLDb++4OUL4E7ECQlr5c/vJ6rfgL4qMRR1hXxX4G97/cv0WBIdKoelJvpJ3Tiv
	hYd16iFC/0Fm6bvZjdjXwBrNNzvbnF646bFvwZlCND5MiYaff5uZgDAdtsnN+cjSNm39QOU5aOi
	gi9CfJzlkx9Ti05nc8cPRxnsmS8row0Y21v8LdR8fj4Dp7X2iaDb3AWdj/Zo0P1wOFHsbq+UjJO
	ib1yjWw0CVgUdWtyus/Z9CiRljnr7FGOCDAbt0s7TW2QzlRg==
X-Received: by 2002:a05:600d:8497:20b0:493:b55f:bca4 with SMTP id 5b1f17b1804b1-493e68cec61mr11152625e9.29.1783501143991;
        Wed, 08 Jul 2026 01:59:03 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([195.72.110.74])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa039ae4fsm42184910f8f.18.2026.07.08.01.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 01:59:03 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: yu kuai <yukuai@fygo.io>, yu kuai <yukuai@fygo.io>, song@kernel.org,
 magiclinan@didiglobal.com, xiao@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, sashiko-bot
 <sashiko-bot@kernel.org>
Subject: Re: [PATCH] md: avoid modifying spares while the array is not
 suspended
In-Reply-To: <f30acc2d-9153-4a9c-b6e5-79083bd9fedb@fygo.io>
References: <20260630075640.1081634-1-abd.masalkhi@gmail.com>
 <0a7dc7e2-30af-44de-8c29-b6e27a62fa55@fygo.io> <m2se5x6wff.fsf@gmail.com>
 <4f0b2516-65bd-41fa-abc3-3cd76951ec46@fygo.io> <m2mrw36qap.fsf@gmail.com>
 <f30acc2d-9153-4a9c-b6e5-79083bd9fedb@fygo.io>
Date: Wed, 08 Jul 2026 10:59:02 +0200
Message-ID: <m2jyr57t7t.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Kuai,

On Wed, Jul 08, 2026 at 16:32 +0800, yu kuai wrote:
> Hi,
>
> =E5=9C=A8 2026/7/7 18:35, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>> Hi Kuai,
>>
>> On Tue, Jul 07, 2026 at 09:12 +0800, yu kuai wrote:
>>> Hi,
>>>
>>> =E5=9C=A8 2026/7/6 3:58, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>>>>> The problem looks real, however, I think this will cause a change tha=
t user will be awared,
>>>>> if there are really spares that can be removed from conf, but array i=
s not suspended here,
>>>>> user will still expect rdev will be removed from conf automatically.
>>>>>
>>>>> In md_start_sync, if suspend is false, can we check again after mddev=
_lock? If suspend is
>>>>> supposed to be true, we can release the lock and retry with suspend =
=3D true.
>>>>>
>>>> Yes, I see, and your approach is much better. But what do you think
>>>> about taking the lock first and then checking only once?
>>> I don't get what you mean. If we take the lock and then check that arra=
y should
>>> suspend, we still have to release the lock before we suspend the array.
>>>
>> Sorry, I was not clear. I meant, do we need to check twice, once before
>> taking the lock and once after? It seems that the check before taking the
>> lock is redundant. since the result would need to be checked again after
>> taking the lock anyway.
>>
>> Could we drop the check before taking the lock and only check whether
>> suspension is needed once while holding it? If suspension is needed, we
>> would release the lock, suspend the array, and then reacquire the lock.
>
> Thanks for the explanation, I understand now. Howerver, I still prefer to=
 check
> first before holding the lock. Because the checking is much lower overhea=
d than
> acquire reconfig_mutex, and the race window that rdev become spare is sma=
ll, so
> it's unlikely we'll acquire reconfig_mtuex twice.
>

I see, thanks for the explanation. I'll send a v2 shortly.

>>
>>> --=20
>>> Thanks,
>>> Kuai
>
> --=20
> Thanks,
> Kuai

--=20
Best Regards,
Abd-Alrhman
