Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6B72F60CC
	for <linux-raid@vger.kernel.org>; Tue,  7 Apr 2026 13:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775569223; cv=none; b=OoFneih+/ajlaPPTHXY8MrbQ/f3+AeWhhRxvSkhhhN1Zo2/OMnrTYNX3h4UhfmuXPj87RT9um1B3f5Bp6N1FUaloFvmXPjB4F2e15+y9SK75btC0S0KhdjlFrLqIvjIws4sX0uw2ncGYQBMbqnKcjZMB0YJyORIdDvwxIEBx4Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775569223; c=relaxed/simple;
	bh=h+ePfXHfcakNzWR5crCa4estyFPye0IdQWd33adIaCA=;
	h=To:From:Message-Id:In-Reply-To:Mime-Version:References:Cc:Subject:
	 Content-Type:Date; b=ucMv+cZg2hILS7/2yL9FO4xPdFUL78IBHqSNqBrcTA4f7GxA+U6bIjs4FaPqVSdYC0fznuSv6cSYskeTPpY+kXQuKA6VHw2j3DfhvUgVegkapGWgcx+8AIJ4420B75dIKXNkcgJAbTUHTmOaSbmU8oFqG5vb8zjk68SiLXlexTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=FuXuMQcZ; arc=none smtp.client-ip=209.127.231.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="FuXuMQcZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1775569201;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=jgUfPRtwVx3FDZm/OYDhN205bm4Nd8x121g53GOsjso=;
 b=FuXuMQcZdUprh1OjKBUMJe6tXB/LuF8IwUhatlvUsALhgpEXcahIFAQvJn2K20RYA++3U2
 jicJv/pFFbNRRIWs7evjxki6R4PKK1YFC8L3KF8Ry6IZqPmOAQixabDE9cRIiYZdhQ/3+x
 +zaV0lLFMCK8aDs2wqBuXyAFlbtDAaFvC+VEtNBK0FIWorazuQ5RteLbrJef6ZYoTvZWdu
 OG5zMe79FpHcScpz/T+Ll3qq1dD3R8YdyAZxLITKY8VE0rBxr3QVfLv5hEMFJdISO03xji
 m40LZF4i8OKWku/QOrIxt/6qn5jgcQW5Q+zgp0H4jn08XWmmW91AzrvLKaYisA==
To: "Chia-Ming Chang" <chiamingc@synology.com>, <song@kernel.org>
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <ede626d0-6e0a-43bf-8aa6-eba6f6dcd1fd@fnnas.com>
In-Reply-To: <20260402061406.455755-1-chiamingc@synology.com>
Received: from [192.168.1.104] ([39.182.0.129]) by smtp.feishu.cn with ESMTPS; Tue, 07 Apr 2026 21:39:58 +0800
Reply-To: yukuai@fnnas.com
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260402061406.455755-1-chiamingc@synology.com>
Content-Transfer-Encoding: quoted-printable
X-Original-From: Yu Kuai <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Cc: <linan122@huawei.com>, <shli@kernel.org>, <neil@brown.name>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<stable@vger.kernel.org>, "FengWei Shih" <dannyshih@synology.com>, 
	<yukuai@fnnas.com>
Subject: Re: [PATCH] md/raid5: fix soft lockup in retry_aligned_read()
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
X-Lms-Return-Path: <lba+269d5092f+5f3bea+vger.kernel.org+yukuai@fnnas.com>
Date: Tue, 7 Apr 2026 21:39:55 +0800

=E5=9C=A8 2026/4/2 14:14, Chia-Ming Chang =E5=86=99=E9=81=93:

> When retry_aligned_read() encounters an overlapped stripe, it releases
> the stripe via raid5_release_stripe() which puts it on the lockless
> released_stripes llist. In the next raid5d loop iteration,
> release_stripe_list() drains the stripe onto handle_list (since
> STRIPE_HANDLE is set by the original IO), but retry_aligned_read()
> runs before handle_active_stripes() and removes the stripe from
> handle_list via find_get_stripe() -> list_del_init(). This prevents
> handle_stripe() from ever processing the stripe to resolve the
> overlap, causing an infinite loop and soft lockup.
>
> Fix this by using __release_stripe() with temp_inactive_list instead
> of raid5_release_stripe() in the failure path, so the stripe does not
> go through the released_stripes llist. This allows raid5d to break out
> of its loop, and the overlap will be resolved when the stripe is
> eventually processed by handle_stripe().
>
> Fixes: 773ca82fa1ee ("raid5: make release_stripe lockless")
> Cc:stable@vger.kernel.org
> Signed-off-by: FengWei Shih<dannyshih@synology.com>
> Signed-off-by: Chia-Ming Chang<chiamingc@synology.com>
> ---
>   drivers/md/raid5.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
Applied to md-7.1

--=20
Thansk,
Kuai
