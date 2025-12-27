Received: from sg-1-12.ptr.blmpb.com (sg-1-12.ptr.blmpb.com [118.26.132.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBCF1DA55
	for <linux-raid@vger.kernel.org>; Sat, 27 Dec 2025 01:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766800385; cv=none; b=ir/iceK+K9SLdKFdTQZ+zP2ox5DnqTa9YRr562+R1zsIJmEhJTrWihuEkuvwWEOazBmQZHKa7Gd+xkpKmOXCB3b4uwmN9E0Xog6qnn/SUOy5jNgNB9tmafNg3MuI1JDH9BSRhSmoh85a5m0+COlJcoJKQc38M2oCGvwBZfz/qBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766800385; c=relaxed/simple;
	bh=5WuF/b8/vHV3yDVGmSetcigLBNMhzf76EEkQ2MYj7yI=;
	h=Mime-Version:From:Subject:Message-Id:References:In-Reply-To:Cc:To:
	 Date:Content-Type; b=ec4c15tZ0HVgV4UaXNcTpau00VY4LqJ8/UkCpRO6YtWerWmBsi/t222ehXQerBvlJ5ALgtzsrpyxnLTWz8BYMgSiQeZcOyFbQMFkpx2u3lDO52gj8gfzKhE3+0lyV2/MrsyRBMrAs9zngM32B1AZilWi4vlPqSjpkt8cDeI4zjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=2OBiXrdP; arc=none smtp.client-ip=118.26.132.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="2OBiXrdP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1766800370;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=uMpo4BqcG/ND54xy+9Ne5jhL3io39cMs/B1nmK2C7uo=;
 b=2OBiXrdPLNjFAVnZ++6PNZrY5K0qe8ZdLRAlvqXMlDzMqBHt/hzfiNc3hyiqsGHF7cGFB9
 Apgtibf+Q+7wEX4d9N6U5f0SnXilm8tm1XQoXm44sI4PkotfrdZ5uKctZkdLiT4cLHs+Dq
 xiboIhjPkf47IJ6lqnmsrI6IexzWeKPY5nkZJwVLWD9Kikdy+j0lMdcJ+se8ELS3nCkV8y
 dp+hZOsXNFGQ4yq76gJiuMt9HAa8CfkU9iIIlyMFfihQSDaTyONvHHHdfvo4qBVxr0DCjp
 rPb2ctaxR/IxQIf5JZqMgnCH7DSqTeAzSPlKgaQeQmXnWFnxTRmsrFWm4j7IZA==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
From: "Yu Kuai" <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+2694f3bf0+1c2787+vger.kernel.org+yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.136]) by smtp.feishu.cn with ESMTPS; Sat, 27 Dec 2025 09:52:47 +0800
Subject: Re: [PATCH v2] md/raid5: fix possible null-pointer dereferences in raid5_store_group_thread_cnt()
Message-Id: <5315a702-935e-4a57-a176-cf11823349b4@fnnas.com>
References: <20251225130326.67780-1-islituo@gmail.com>
In-Reply-To: <20251225130326.67780-1-islituo@gmail.com>
Content-Language: en-US
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fnnas.com>
To: "Tuo Li" <islituo@gmail.com>, <song@kernel.org>
Date: Sat, 27 Dec 2025 09:52:45 +0800
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fnnas.com

=E5=9C=A8 2025/12/25 21:03, Tuo Li =E5=86=99=E9=81=93:

> The variable mddev->private is first assigned to conf and then checked:
>
>     conf =3D mddev->private;
>      if (!conf) ...
>
> If conf is NULL, then mddev->private is also NULL. In this case,
> null-pointer dereferences can occur when calling raid5_quiesce():
>
>    raid5_quiesce(mddev, true);
>    raid5_quiesce(mddev, false);
>
> since mddev->private is assigned to conf again in raid5_quiesce(), and co=
nf
> is dereferenced in several places, for example:
>
>    conf->quiesce =3D 0;
>    wake_up(&conf->wait_for_quiescent);
>
> To fix this issue, the function should unlock mddev and return before
> invoking raid5_quiesce() when conf is NULL, following the existing patter=
n
> in raid5_change_consistency_policy().
>
> Fixes: fa1944bbe622 ("md/raid5: Wait sync io to finish before changing gr=
oup cnt")
> Signed-off-by: Tuo Li<islituo@gmail.com>
> ---
> v2:
> * Move the NULL check and early return ahead of the first call to
>    raid5_quiesce().
>    Thanks to Yu Kuai for helpful advice.
> ---
>   drivers/md/raid5.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)

Applied to md-6.19

--=20
Thansk,
Kuai
