Received: from sg-1-30.ptr.blmpb.com (sg-1-30.ptr.blmpb.com [118.26.132.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C3621CA13
	for <linux-raid@vger.kernel.org>; Sat,  3 Jan 2026 10:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767436431; cv=none; b=qGoas9gtf7fnkq1dW8CqvrIOz0YaHMynzOfzRKPlW/pKIFFt+KhCtm84QbSDRBjoyV18o8AnD6HSVrttAw90CUmaTllvNT/iyqEYPVpRN4eFNokz75hl4BPEDOyBHYrzJCbRFZGO/iJt8SYNyGKTKWx+NjP2rs5wNBkfEL9t+xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767436431; c=relaxed/simple;
	bh=lglyKJ4e7a4dyjdrGDU4gZ97uh0doqbvuLNI3I9HGX8=;
	h=To:From:Subject:Date:References:Mime-Version:Cc:Message-Id:
	 In-Reply-To:Content-Type; b=Sle9mUKOltt4jtQycqei0Zl6cwOMVjzaYkucydBomdHicd642AYqf+EmS4cKVmlXpWVERzurdRpcrMEm6CyE7LckU5ZLZ6r04jViTFFcEvjqFfyGBPPg5jAWQyMbWm/qOIQl/5T3EoPykNVJFVvFWRyGjsJ/T4FwjpvITkxy0wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=X03WgkPy; arc=none smtp.client-ip=118.26.132.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="X03WgkPy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1767436421;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Ga5m1yiziqApdLuWa7wiP9tTYOWuko9bW88RA2gYjyA=;
 b=X03WgkPyhyv57ASWthakDloDeR+puOOAONL0ctMBM7nWy1eyrh8INvRJndikBkNL1MO5O+
 XssikJCMrtMR44pDKI4fvaJ72nqf6pYjtjVQ30lAWRUbaehaCfWCuxoLaTPLYPbZPmXVIw
 i8O7WV7RYkq61HNU+Cr+hjzo7IQjRDEve3MtLmPltSXvUhVY4NsE7y7ioYL3oyswFQEOr+
 qHHv206u52COYc7dHwu+VaaMF6Ulcy2UTYOY4KlT5zORCbLs8TV6+53GCpMNMHbX5h7Iun
 LQ7d7UHWXYvKdvPUAs+7TeZXAL3SGFTUYi+FGjt7X/iG7ihdeCy8XAvv7+0x7w==
Reply-To: yukuai@fnnas.com
Received: from [192.168.1.104] ([39.182.0.186]) by smtp.feishu.cn with ESMTPS; Sat, 03 Jan 2026 18:33:39 +0800
Content-Language: en-US
X-Original-From: Yu Kuai <yukuai@fnnas.com>
To: <linan666@huaweicloud.com>, <song@kernel.org>, <neil@brown.name>, 
	<namhyung@gmail.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH v3 07/13] md: update curr_resync_completed even when MD_RECOVERY_INTR is set
Date: Sat, 3 Jan 2026 18:33:35 +0800
X-Lms-Return-Path: <lba+26958f084+1c8f8d+vger.kernel.org+yukuai@fnnas.com>
References: <20251215030444.1318434-1-linan666@huaweicloud.com> <20251215030444.1318434-8-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<k@mgml.me>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>, 
	<yukuai@fnnas.com>
Message-Id: <ca3e635a-3fea-494e-9aa3-3c0ef5f58b13@fnnas.com>
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20251215030444.1318434-8-linan666@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8

=E5=9C=A8 2025/12/15 11:04, linan666@huaweicloud.com =E5=86=99=E9=81=93:

> From: Li Nan<linan122@huawei.com>
>
> An error sync IO may be done and sub 'recovery_active' while its
> error handling work is pending. This work sets 'recovery_disabled'
> and MD_RECOVERY_INTR, then later removes the bad disk without Faulty
> flag. If 'curr_resync_completed' is updated before the disk is removed,
> it could lead to reading from sync-failed regions.
>
> With the previous patch, error IO will set badblocks or mark rdev as
> Faulty, sync-failed regions are no longer readable. After waiting for
> 'recovery_active' to reach 0 (in the previous line), all sync IO has
> *completed*, regardless of whether MD_RECOVERY_INTR is set. Thus, the
> MD_RECOVERY_INTR check can be removed.
>
> Signed-off-by: Li Nan<linan122@huawei.com>
> ---
>   drivers/md/md.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Yu Kuai <yukuai@fnnas.com>

--=20
Thansk,
Kuai
