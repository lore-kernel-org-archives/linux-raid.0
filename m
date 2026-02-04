Received: from sg-1-11.ptr.blmpb.com (sg-1-11.ptr.blmpb.com [118.26.132.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E49428463
	for <linux-raid@vger.kernel.org>; Wed,  4 Feb 2026 16:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770222591; cv=none; b=PtLvA6rVbsJJ4a/J18Z7LGhpgC8DiyWcMMYywm+K7oQxc/HVhZ2DiBEGwbadqOXKsHuUCS6sHEAI8ngaFkhuHsv+ZWg5eSfkZl2qgtSSt4aXFbZzch3MxO+spK79xllxitehLVkECts9klMj7MyjUkc3delTsbueEu6ylgeCi2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770222591; c=relaxed/simple;
	bh=9mZTiWlXZwzqbV/chJHhgWiNBODXMABOQwAo9riOMSY=;
	h=In-Reply-To:Subject:Date:Mime-Version:Message-Id:Content-Type:
	 References:To:Cc:From; b=qP4XjHc6XaPK2WZsK08aqdAHkYYroUztG0Q1AuYFdaSmgjvpLO+kE0pxSM15EFFP3E0nGv1XqOWuUW+BbuWEHYuSRCKNygwJ/x7eBvm9wIIYXr7bkUHdEeLR6Jt893O4SxDoci7adlFl5meGkgG3f/Zw8kLQ+siYfk7CIdyip1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=gmkBWm1R; arc=none smtp.client-ip=118.26.132.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="gmkBWm1R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770222579;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=WDlNUU0p39/R81SmmW8jp9MbYN56w2+PJb5c8z2A6Jo=;
 b=gmkBWm1R09N7OxnVR5U0V9J5Hh6NLHwF6u0xVxhI71B0hGIehHUiO5k2wemiCroyvRqAf6
 iOh8pKWaAZChowY0FI1TWnU7b8I4c3+pK0eUzuZa1h2iZRs7iffj6HoHqbQbpvbgw6bqG5
 ofT1j6YVs1h1Tae8KOtPE+SYXKzk/3zvhxqQPcFdQbw+Hne5QaqGJ2yyGKfbbQses1sfQg
 7jai1xueKsPn8Ayj/ZhB4lvzRnoYHbcrHwErhhuOg7syRfj0biPfMaFySjbQKdv7pJX8sb
 5PPjRwL5MQrmJavz6gAUkDneh43x99VsOPpKbltkAipEoed3VK/fdU3mZUg4xQ==
Reply-To: yukuai@fnnas.com
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Thu, 05 Feb 2026 00:29:37 +0800
In-Reply-To: <20260128075708.2259525-2-linan666@huaweicloud.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Language: en-US
Subject: Re: [PATCH v2 01/14] md/raid1,raid10: clean up of RESYNC_SECTORS
Date: Thu, 5 Feb 2026 00:29:35 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Message-Id: <c1a2aca7-73e5-46eb-8439-c8d65d5c3ab8@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
References: <20260128075708.2259525-1-linan666@huaweicloud.com> <20260128075708.2259525-2-linan666@huaweicloud.com>
To: <linan666@huaweicloud.com>, <song@kernel.org>
Cc: <xni@redhat.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>
From: "Yu Kuai" <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+2698373f1+00207b+vger.kernel.org+yukuai@fnnas.com>

=E5=9C=A8 2026/1/28 15:56, linan666@huaweicloud.com =E5=86=99=E9=81=93:

> From: Li Nan<linan122@huawei.com>
>
> Move redundant RESYNC_SECTORS definition from raid1 and raid10
> implementations to raid1-10.c.
>
> Simplify max_sync assignment in raid10_sync_request().
>
> No functional changes.
>
> Signed-off-by: Li Nan<linan122@huawei.com>
> ---
>   drivers/md/raid1-10.c | 1 +
>   drivers/md/raid1.c    | 1 -
>   drivers/md/raid10.c   | 4 +---
>   3 files changed, 2 insertions(+), 4 deletions(-)
Reviewed-by: Yu Kuai <yukuai@fnnas.com>

--=20
Thansk,
Kuai
