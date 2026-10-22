Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792654634;
	b=Yr521/aj+YtWGIiHZCHMd8ONxKiPSZqY2wPbS8Z1oiEL04uNVGr625D+rtqJRcdXBL1N
	 /7eA3Zwt5Orli80fk3bHdcyG04FAIcC/+xllAYFmrdlTL/bI4lZzjNKH10zB/Uc/6Nswj
	 mLmo61pLwiZFPinseoFIaG0+1ZzlmPhIeBQgyGpSL6StyZzHEmTRkbN2wHUcRQzFFkKc4
	 BoLQGxtX0jRHBjw+91+GKGz2qLArsD5XE1M69VK4IXdNMEv4Oas7O1oG/y6mriDYkiPgW
	 kRmNkGUxBA9MEm3lJlfhmnYtvuHxC+fpEXWvyHcjN25NxXHa09n/WS4jjKTQJzCkJrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792654634;
	h=DMARC-Filter:DKIM-Signature:To:Cc:Mime-Version:X-Lms-Return-Path:
	 Date:References:X-Original-From:From:Subject:User-Agent:
	 Content-Transfer-Encoding:Message-Id:Received:In-Reply-To:
	 Content-Type;
	bh=w5JhBMDEbj3cx1oXbt0JanKqGYutt/sE8OJ/dFm3amE=;
	b=huJjUlT2tJ64/+/+BLAAyow6FUtjZX8A3Ljyuyr2l+2plPZYMxzEcpPFWJIKQQBW+uAH
	 JccF0wQB56hfEC3kLGUEu+KbC24EISmKOTdK3PGy/52r6SBjJv+y2mFNP1DGX+O1i19qx
	 WcknGDm6dlYu3UHky/3PzO8merUXVH2gJvIIzakMfJnWeO+/k43FyF8IZFMK/V2EjaQ27
	 8EUIeLmHyfd+z9lbaKLia+yRCLSWPlpBsUEwIZC33ZMu1I1LosEC8Fil4CBbRi7UB3s3b
	 ZIBtkM4+ju2ODWcVRldlqGR5txlJBWnt/EHaBoZ2ttu5zAQuKGParGJD1kmIprRbXzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=fnnas.com;
	spf=pass smtp.mailfrom=fnnas.com;
	dkim=pass header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.a=rsa-sha256 header.s=s1 header.b=1prZsu3E;
	arc=none smtp.remote-ip=209.127.231.58
Received: from va-2-58.ptr.blmpb.com (va-2-58.ptr.blmpb.com [209.127.231.58])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A42C606A31A
	for <linux-raid@vger.kernel.org>; Thu, 22 Oct 2026 07:37:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A42C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.a=rsa-sha256 header.s=s1 header.b=1prZsu3E
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1792654625;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=w5JhBMDEbj3cx1oXbt0JanKqGYutt/sE8OJ/dFm3amE=;
 b=1prZsu3E8rL2v8O5jb1Q9CAaQiqQJz+BrHGbyXmMg00SKSE1YhqkLi8UqhxsUWaqbtU9ql
 yGt44B4h7rnSK36E8ZIPpdEL2nxNsI4Xei89w11P7BDvplqDoVZFGolxuiOl4li42DNNgu
 88lExzD9+IKpKnWfqucLepQrTvFpxY+WasoliXiAyH163ZqCz6ZGI9uwxBxJeNIdzzUQ17
 mXd2/mNxjhvI0wLCnyMQTRHwM5vY8wazd9l35kOLEriY6GH/c33JtmrnUwyGReB3fm6hQy
 Jo+MFzeaNBxl9QC8tUCVoUsF4mPR+UST3N+8MvHOsUm7AxT7JyUV4Zf/pUOAKA==
To: "Doug V Johnson" <me@dougvj.me>, <linux-raid@vger.kernel.org>
Cc: <song@kernel.org>, <yukuai@fygo.io>, <magiclinan@didiglobal.com>, 
	<xiao@kernel.org>, <linux-kernel@vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26ad9bd1f+1963fd+vger.kernel.org+chencheng@fnnas.com>
Date: Thu, 22 Oct 2026 15:36:59 +0800
References: <20261016042537.277516-1-me@dougvj.me> <010101a142f57e37-cd14b78d-54cd-447b-9888-87f166a937ab-000000@us-west-2.amazonses.com>
X-Original-From: Chen Cheng <chencheng@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: Re: [PATCH v4 1/3] md/raid5: freeze and interrupt reshape when handling failed reshape
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: 7bit
Message-Id: <323c8d9f-319e-4f9e-a258-63a33a0e6200@fnnas.com>
Received: from [192.168.8.25] ([183.34.163.217]) by smtp.feishu.cn with ESMTPS; Thu, 22 Oct 2026 15:37:02 +0800
In-Reply-To: <010101a142f57e37-cd14b78d-54cd-447b-9888-87f166a937ab-000000@us-west-2.amazonses.com>
Content-Type: text/plain; charset=UTF-8

On 2026/10/16 12:25, Doug V Johnson wrote:
> Set the reshape freeze flag to prevent automatic reshape resumption
> and interrupt the current reshape with md_sync_error() so that a
> reshape always stops no matter how the failed reshape is triggered.
> 
> Previously, if there were no faulty or out of sync devices but there
> was an unrecoverable read, the reshape continued and was not cancelled
> after handle_failed_reshape(). This caused some data corruption as
> block writes were cancelled but the reshape nonetheless continued.
> 
> Prior to Chen's fix, the kernel would deadlock with a failed stripe
> read.  That case also caused some data corruption, so Chen's patch
> did not introduce corruption in this case.
> 
> An example test case showing how this happened before this fix is
> demonstrated by the following:
> 
> Simplified example (schematic logical sector numbers):
> 
>    1. Before reshape, destination D contains data for logical 20-27.
>       The new geometry will use D for logical 100-107.
> 
>    2. Inject bad-block metadata on enough members that the old source
>       stripe cannot be reconstructed. Logical sector 100 now returns
>       a read error; sectors 101-107 are still readable.
> 
>    3. Reshape tries to read the source block for logical 100-107.
>       The bad-block records prevent a successful read/reconstruction.
>       Failure cleanup cancels the destination write:
> 
>         Source: logical 100-107 --X--> destination D
>                                       still contains data for 20-27
> 
>    4. Without interruption, reshape continues and completes.
>       The new mapping now sends reads of logical 100-107 to D.
> 
>    5. Reading logical 100-107 succeeds, but returns data for 20-27.
>       Previously readable sectors 101-107 now return wrong data.
> 
> Code that injects bad blocks to demonstrate this problem before and
> after Chen's fix as well as after this patch can be found here:
> 
> Link: https://github.com/dougvj/md-raid-reshape-badblock-corruption-test
> 
> Fixes: 788e4139463f ("md/raid5: fix reshape deadlock while failed devices more than max degraded")
> Link: https://patch.msgid.link/20260624075824.2601110-1-chencheng@fnnas.com
> Assisted-by: LLM
> Signed-off-by: Doug V Johnson <me@dougvj.me>
> ---
>   drivers/md/raid5.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b91545ce090d..86ea65559576 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3773,6 +3773,10 @@ static void handle_failed_reshape(struct r5conf *conf, struct stripe_head *sh,
>   	bool was_expanding = test_and_clear_bit(STRIPE_EXPANDING, &sh->state);
>   	bool was_ready = test_and_clear_bit(STRIPE_EXPAND_READY, &sh->state);
>   
> +	/* Freeze reshaping to prevent data loss */
> +	set_bit(MD_RECOVERY_FROZEN, &conf->mddev->recovery);
> +	md_sync_error(conf->mddev);
> +
>   	if (was_expanding || was_ready) {
>   		atomic_dec(&conf->reshape_stripes);
>   		wake_up(&conf->wait_for_reshape);

Reviewed-by: Chen Cheng <chencheng@fnnas.com>
