Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81DC28469F
	for <linux-raid@vger.kernel.org>; Fri, 20 Mar 2026 04:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773979735; cv=none; b=qME5DRw2zE56U6YeT9YAz65KdKcU/bvkMOwpCiXMn3HsOcJayGOfWmn9am00ha/79/p9mptr9LPZkjIbvn3e3xgbR8jCjikkZPaS5n6SouPHc6muxDDtrxJKjxCQKDqBmoNCaUZVFGJJP0hKKcr24L0pBivgtnXwwaOCyL1sSHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773979735; c=relaxed/simple;
	bh=kShKZFUSNGm53J5DNjNq7vre2dCWy75opLWSOCTAQAI=;
	h=Cc:Message-Id:To:Mime-Version:In-Reply-To:References:From:Subject:
	 Date:Content-Type; b=Zr7RmDnxA8Wzott/ctGKWBj96bvWT7gYoXoGouHaFXIEixsx45d9TIJRptlAHFilqGStQ21sZ+sM8xTSHVg3RdS06JfSjgLHufzWSBCnws0nNBkCmUhAMEFKTjyFDND9Viadmnle5p26ZrYYdURtUrgLVqLz95xux/68KSZPzi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=bPScg7LE; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="bPScg7LE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1773979727;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=sBMtnOv4DRn8rDgmtSHryk/8Qxx1GHEuCpgpp2GSR0o=;
 b=bPScg7LExrd5eeaimik/7FZC/a8Amb1st3TZ7pN8DA5mCsaTWD+c6tWZQmD5JtGaGUK+6m
 HEBHRxHN8/h6XxbKSOuXCpsJaGxD+csNTdZYi4/8Gi4Z1HaZ1dhxTSJ+odIfBl5GnWwlmq
 a8xhU6ISeIBPnElOt5MSonKwtfuR1qGhzdlWnTcLgI9wW3NQkdxPerHDmuK6t0rt2aVK+i
 Ff94rbBkK/k5Q4yjaH17+AjrT+48s4mby9ql95/pnSJ2gF9YTQnSolYIULUdzvRbadp6ly
 nOqKr48VRqSWeHyG6FiIz2Dgc55BaCgmuM74XfXK3AX4e8tUsz27PlFyYqbZTg==
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, 
	<syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com>, 
	<akpm@linux-foundation.org>
Message-Id: <d15b9cf0-94cc-4fd1-a702-e3e34f967f6b@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.175]) by smtp.feishu.cn with ESMTPS; Fri, 20 Mar 2026 12:08:44 +0800
X-Lms-Return-Path: <lba+269bcc84d+3ec08a+vger.kernel.org+yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
To: "Gregory Price" <gourry@gourry.net>, <song@kernel.org>, 
	<linan122@huawei.com>, <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Language: en-US
User-Agent: Mozilla Thunderbird
In-Reply-To: <20260308234202.3118119-1-gourry@gourry.net>
References: <69adaba8.a00a0220.b130.0005.GAE@google.com> <20260308234202.3118119-1-gourry@gourry.net>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH] md/raid0: use kvzalloc/kvfree for strip_zone and devlist allocations
Date: Fri, 20 Mar 2026 12:08:41 +0800
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

=E5=9C=A8 2026/3/9 7:42, Gregory Price =E5=86=99=E9=81=93:

> syzbot reported a WARNING at mm/page_alloc.c:__alloc_frozen_pages_noprof(=
)
> triggered by create_strip_zones() in the RAID0 driver.
>
> When raid_disks is large, the allocation size exceeds MAX_PAGE_ORDER (4MB
> on x86), causing WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER).
>
> Convert the strip_zone and devlist allocations from kzalloc/kzalloc_objs =
to
> kvzalloc/kvzalloc_objs, which first attempts a contiguous allocation with
> __GFP_NOWARN and then falls back to vmalloc for large sizes. Convert the
> corresponding kfree calls to kvfree.
>
> Both arrays are pure metadata lookup tables (arrays of pointers and zone
> descriptors) accessed only via indexing, so they do not require physicall=
y
> contiguous memory.
>
> Reported-by:syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com
> Signed-off-by: Gregory Price<gourry@gourry.net>
> ---
>   drivers/md/raid0.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)

Reviewed-by: Yu Kuai <yukuai@fnnas.com>

--=20
Thansk,
Kuai
