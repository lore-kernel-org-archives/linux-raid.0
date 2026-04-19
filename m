Received: from va-2-28.ptr.blmpb.com (va-2-28.ptr.blmpb.com [209.127.231.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9FA2AF1D
	for <linux-raid@vger.kernel.org>; Sun, 19 Apr 2026 03:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776570806; cv=none; b=pJpJy6qK3xa4H+lum/KmyWmiYtnamlby8wmygCUbRq9eB/xgwkHUNZebvnxtcuDXM1iuBNqSqlvmnODRcFYvnzMkwZr9+Ph9y9uo8hokIRZchotzYc11jrXpCpDqCovgfZWRIQx71mu/3XceTI4DS/H0hPw1KJJ2ToixUo2jsK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776570806; c=relaxed/simple;
	bh=qOik8oXH4kSE5AL5Nx+70hNVQ3RLQX8dWQKn5xdj+ZE=;
	h=Mime-Version:To:From:Date:Message-Id:Content-Type:References:
	 In-Reply-To:Cc:Subject; b=ENZm+B+fVs7Y6lZWB/LLWmIfVfJWA4bI52ejKcOzUdWqeJbdPwINpKcDbCi3+Kn7r4SZ+MifqzbKkUPP71BFieLpReBBz67qKe3nslpbPLxXsvZugwdTxEKSc6bFUmfEFndKMWxyj2y0zl5vVTPQx61A71hFS57BMgr/sQdwESE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=xgGCpW+f; arc=none smtp.client-ip=209.127.231.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="xgGCpW+f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1776570674;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=EDUwu8dU1ZOzwahB+Zrg7d/KEdQppMfMp6EBNsM4MkQ=;
 b=xgGCpW+fHnHrcbJ/2Dg3zV0WumXiN4mlmjueiWmSQJxyyBVfQoqBs7zEHfjgvBEiJLuYjl
 tJOs4ikcleSoPwVFoOjZN7p8XctHFfKzTajTMwDNIjBzIXWQ4192a5yQEBD+8uexixMX92
 eeUjV2YkeyaY+mTKLDCpjezm5YKcMwDy300WJ2iQNHnxirtmOviobsIQFcTOLQtlIrrcW/
 VJUazReUYc/gqyGiTFQD37dbCAS+vZOuey5kLSBCnU7seDaFNOTzHEEcEDWb3ocu53E0Wz
 phGmH19W/LyYBVyKUWdpVdFwPqBmo2SAsmDgvhARXASWS2XojC7/4WINM39qJA==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
X-Lms-Return-Path: <lba+269e45131+8af266+vger.kernel.org+yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
To: "Benjamin Marzinski" <bmarzins@redhat.com>, "Song Liu" <song@kernel.org>, 
	"Li Nan" <linan122@huawei.com>, "Xiao Ni" <xni@redhat.com>, 
	<yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Date: Sun, 19 Apr 2026 11:51:10 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.feishu.cn with ESMTPS; Sun, 19 Apr 2026 11:51:12 +0800
Message-Id: <8764280f-f478-44b5-8bb7-013b9d8e0aaa@fnnas.com>
Content-Type: text/plain; charset=UTF-8
References: <20260408043548.1695157-1-bmarzins@redhat.com>
In-Reply-To: <20260408043548.1695157-1-bmarzins@redhat.com>
Cc: <linux-raid@vger.kernel.org>, <dm-devel@lists.linux.dev>, 
	"Nigel Croxon" <ncroxon@redhat.com>
Subject: Re: [PATCH v2] md/raid5: Fix UAF on IO across the reshape position

=E5=9C=A8 2026/4/8 12:35, Benjamin Marzinski =E5=86=99=E9=81=93:

> If make_stripe_request() returns STRIPE_WAIT_RESHAPE,
> raid5_make_request() will free the cloned bio. But raid5_make_request()
> can call make_stripe_request() multiple times, writing to the various
> stripes. If that bio got added to the toread or towrite lists of a
> stripe disk in an earlier call to make_stripe_request(), then it's not
> safe to just free the bio if a later part of it is found to cross the
> reshape position. Doing so can lead to a UAF error, when bio_endio()
> is called on the bio for the earlier stripes.
>
> Instead, raid5_make_request() needs to wait until all parts of the bio
> have called bio_endio(). To do this, bios that cross the reshape
> position while the reshape can't make progress are flagged as needing to
> wait for all parts to complete. When raid5_make_request() has a bio that
> failed make_stripe_request() with STRIPE_WAIT_RESHAPE, it sets
> bi->bi_private to a completion struct and waits for completion after
> ending the bio.  When the bio_endio() is called for the last time on a
> clone bio with bi->bi_private set, it wakes up the waiter. This
> guarantees that raid5_make_request() doesn't return until the cloned bio
> needing a retry for io across the reshape boundary is safely cleaned up.
>
> There is a simple reproducer available at [1]. Compile the kernel with
> KASAN for more useful reporting when the error is triggered (this is not
> necessary to see the bug).
>
> [1]https://gist.github.com/bmarzins/e48598824305cf2171289e47d7241fa5
>
> Signed-off-by: Benjamin Marzinski<bmarzins@redhat.com>
> ---
>
> Changes from v1:
> - Removed mddev->pending_retry_bios, mddev->retry_bios_wait, and
>    md_io_clone->must_retry. Instead, use a completion struct
>    pointed to by bi->bi_private, as suggested by Xiao Ni and Yu Kuai.
>
>   drivers/md/md.c    | 31 ++++++++-----------------------
>   drivers/md/md.h    |  1 -
>   drivers/md/raid5.c |  7 ++++++-
>   3 files changed, 14 insertions(+), 25 deletions(-)
Applied

--=20
Thansk,
Kuai
