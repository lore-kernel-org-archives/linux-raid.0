Received: from mail110.out.titan.email (mail110.out.titan.email [44.217.104.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040C01FF1AF
	for <linux-raid@vger.kernel.org>; Fri, 21 Feb 2025 10:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.217.104.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740134306; cv=none; b=rBDWYnYLQ9k8b6b61tSxc2tnUi8cYDfl0Tc3jdcHZ/g3HKFJpS0NBoT8L3zAN/DuqOsnl7KqOjVWEfvJz+RrWMDmS8FkOa6GmGgYJf4bnwP43EIO4wM51U5Us2jnQwMv+OPuLYhZ5AQp4xZrXB/cDMjt3suUEUjsovk9APd4ZEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740134306; c=relaxed/simple;
	bh=ea+Ek2RQttgOP+iUjwOS2oImmaIG+/q8Ozo8FGBXYvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c2OLqV3t2jRNey3j3x3QwWVpQ5BqWztQzlyVpGlR1StAxlHB/MG30m49Hvikk3zGnZuXP+OQBD8JCZep4bdI8LWF0wf9SE0+iuoagK32b2RL349tUFaLLaUbzryr7uh/03r4Wsd7DdByKgMjvOEhx1HMxKVp7QTWy4XElP0Kluo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=bMi5BshJ; arc=none smtp.client-ip=44.217.104.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="bMi5BshJ"
Received: from smtp-out.flockmail.com (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id 19C901401B7;
	Fri, 21 Feb 2025 09:59:00 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=k1ZI6/H36h6jxhHmmVjWJpJw1xAsCSw9MFuq5X7Hl3g=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=subject:references:to:message-id:mime-version:from:cc:in-reply-to:date:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1740131940; v=1;
	b=bMi5BshJoilKdG0aIy/FOLxFRPSQvptgRdYxhCBonZ9QGDNpvVktjv5lI0UaMp6liDxnfv7a
	HX4vUncQ3cIFqweB9Dqovk8CjMDiUZCY0zG23VV3fA+0ASfN1ty/vdnIQTSFBVWlZhQKnkgWqXz
	GL6cwyKunaTxWkr7UVdGhF4o=
Received: from studio.local (unknown [141.11.218.23])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id E015E140230;
	Fri, 21 Feb 2025 09:58:51 +0000 (UTC)
Date: Fri, 21 Feb 2025 17:58:49 +0800
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
To: Zheng Qixing <zhengqixing@huaweicloud.com>
Cc: axboe@kernel.dk, song@kernel.org, colyli@kernel.org, 
	yukuai3@huawei.com, dan.j.williams@intel.com, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, ira.weiny@intel.com, dlemoal@kernel.org, yanjun.zhu@linux.dev, 
	kch@nvidia.com, hare@suse.de, zhengqixing@huawei.com, john.g.garry@oracle.com, 
	geliang@kernel.org, xni@redhat.com, colyli@suse.de, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, 
	yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 01/12] badblocks: Fix error shitf ops
Message-ID: <utqnfxii5zrqafturex5tyu4ufociw2uojdtiqrs6mezjkcf53@mtxl3g74c44u>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
 <20250221081109.734170-2-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250221081109.734170-2-zhengqixing@huaweicloud.com>
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1740131939955435648.32605.715982361791409116@prod-use1-smtp-out1003.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=XIrKSRhE c=1 sm=1 tr=0 ts=67b84e63
	a=USBFZE4A2Ag4MGBBroF6Xg==:117 a=USBFZE4A2Ag4MGBBroF6Xg==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8
	a=bTkXzGrAoGneLz_nSNMA:9 a=QEXdDO2ut3YA:10
X-Virus-Scanned: ClamAV using ClamSMTP

On Fri, Feb 21, 2025 at 04:10:58PM +0800, Zheng Qixing wrote:
> From: Li Nan <linan122@huawei.com>
>

Looks good to me.

Acked-by: Coly Li <colyli@kernel.org>

Thanks.
 
> 'bb->shift' is used directly in badblocks. It is wrong, fix it.
> 
> Fixes: 3ea3354cb9f0 ("badblocks: improve badblocks_check() for multiple ranges handling")
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>  block/badblocks.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/block/badblocks.c b/block/badblocks.c
> index db4ec8b9b2a8..bcee057efc47 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -880,8 +880,8 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>  		/* round the start down, and the end up */
>  		sector_t next = s + sectors;
>  
> -		rounddown(s, bb->shift);
> -		roundup(next, bb->shift);
> +		rounddown(s, 1 << bb->shift);
> +		roundup(next, 1 << bb->shift);
>  		sectors = next - s;
>  	}
>  
> @@ -1157,8 +1157,8 @@ static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
>  		 * isn't than to think a block is not bad when it is.
>  		 */
>  		target = s + sectors;
> -		roundup(s, bb->shift);
> -		rounddown(target, bb->shift);
> +		roundup(s, 1 << bb->shift);
> +		rounddown(target, 1 << bb->shift);
>  		sectors = target - s;
>  	}
>  
> @@ -1288,8 +1288,8 @@ static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
>  
>  		/* round the start down, and the end up */
>  		target = s + sectors;
> -		rounddown(s, bb->shift);
> -		roundup(target, bb->shift);
> +		rounddown(s, 1 << bb->shift);
> +		roundup(target, 1 << bb->shift);
>  		sectors = target - s;
>  	}
>  
> -- 
> 2.39.2
> 

-- 
Coly Li
