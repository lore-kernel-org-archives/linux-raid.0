Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB61259C
	for <linux-raid@vger.kernel.org>; Thu, 13 Mar 2025 11:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741865918; cv=none; b=pmrddo3NoQJL2obR/UdwI88E9CewCdPk6M9Gg4Wom5vvT2709dINz2U2KPyo+/FDw+eSzR2TpiFyCNnn5esyTaibCTmgIeyvBnBlb1E/qIL1WsZPUXPnVvwzm/kbcl7TlwJzFeU3ZWqejT8g/tn689ezYhQ3FwX3rVudRHtW0W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741865918; c=relaxed/simple;
	bh=r3aISP53bWVR16zFQ7VRlzL2doYRxLSCbMTp+quzHEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I8WT7aryIumNKZdaq5vSWqiPgY098qAc6IatfCN1CD0BCCtIem9AgKNjABy4x/2D9Qijo4BuBcXyD11jR/mHyMkPXhrJDLVuKOAWBS4ixi/Th+72w+HgFGhYVwvvRZ7FnehSoixeOLlBwq1XwbwZLolFxAVzqnhzHRBXRyUlpjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FTEVeN7+; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FTEVeN7+"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-85afd2b911aso33024239f.2
        for <linux-raid@vger.kernel.org>; Thu, 13 Mar 2025 04:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741865914; x=1742470714; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zVxlvA4MpV5/noCAEc4jb+eWtXb81nOScvkuMjcsbbQ=;
        b=FTEVeN7+j3xkqmFpOdKjrI1/J3Q05TQtMb9kwioq+QgwUYOQecLO26gwKVbGgIzaSB
         GywURyI0/6bH9h1fbUY3MObfzOHs40CuWzGDH2Gj0CnTJLIhP7iIHDEaaVFftMxN+Th8
         1y1GLb7AXafJq4d6PKdYQLWwLngnM5xgQGJ+jWQ8MqCYWoaGzKVis9XMMnRFq95L4CDj
         8LVjQAtGQ2A0OvFwuJi2AZkh1FJ26t8fXp5wNGzV6q6uFrIweFo6qs9uXSYFPwS/UXAT
         QAfyobue3diLN+sLRGndb3M3rsNXw5AjQLQ0ZWyhVWQZi1SaYUtpIpVwHppMoOnVQIm0
         5+6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741865914; x=1742470714;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zVxlvA4MpV5/noCAEc4jb+eWtXb81nOScvkuMjcsbbQ=;
        b=F1a3x08/Sz6NQoffqFysd9qcUQoAE+GwXHJvWf1ZUJ6arL3G7GGHa5H4Jm7xZ+nbPC
         awuIcRmtXX0p85xjgOYETcm1Aj1z/j4Q8CBWThVu50SD9nyZpyOWvKnBjSS1XVnUEgio
         EtppXLD0BDWZDHT6NA++gVWBHxktFLSiwB+fVhttfFyVzbbtHtoimhcJ9Clstkzy8/KF
         qF1GwN+YJsOZCFN2255YFX4eenyqrn4vWXwvqRHRlybnoGbgH4HveIPLjrLeGJ4SKd/F
         ccwnp3UKxHVDx84Ry+BLMENIarax1Q7uCyDBK8nyOGd1JUk8w4yBSoDWGWnpJpvlL0j4
         iiRg==
X-Forwarded-Encrypted: i=1; AJvYcCXZUOWUFCJVxfGaDlyKb3StrionmvdShO7K+QfNcSt+5RSGd7IKrr6r3kPZFOWg4BVmnvUoSLNldFGm@vger.kernel.org
X-Gm-Message-State: AOJu0YxiIiGDhyARI6e8GIakfCxPKkyNymm1WhCSbO1MOW/Nz7CzMCxf
	9nsSq2CIePtUV71oOaCWG8Oxg6bqq7SgpUc4CeAM4ed/SgWHjjLBACQ548N+jw4=
X-Gm-Gg: ASbGncu2lOnt5uhRXaMxr9J+SbtvD7ixA6WNCp8yNWyuNM91kw0SHdpPA8PRASZ2Krd
	PdXW9pulWtcP/XpgXvY8xKt1BDi/tTEadaCTSJCe//MAgpiWafHOYNYdTXuujvGPOtUFplrl+mO
	Y8cA3edVHG9ZawnoLQUCG5waWjWGeZ0KrAV4JMaxEQ5t1K8it29B4yMlUy+w23fzaonMxRx56od
	lCGXnuUUQjHZKXUI4PDByXuG7XuYM7Cd5d3kwRMv8ZLAGIMPmj04/f7VaPdPIBPC6BfsKAa59sV
	JvL4ifIPwMKCFr2eWZG3KAshjkmdIS4Zo5QSB/VXEQ==
X-Google-Smtp-Source: AGHT+IGZJ815oX7dlS6FvbgLae8fwIDvI/rIsUScCugG3v1z8mNlbQZyfaKPr73CTQHfcgJj4DIQvA==
X-Received: by 2002:a05:6602:3811:b0:85b:3885:1595 with SMTP id ca18e2360f4ac-85b3885172dmr2367625339f.3.1741865913736;
        Thu, 13 Mar 2025 04:38:33 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85db8750862sm28053939f.9.2025.03.13.04.38.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Mar 2025 04:38:32 -0700 (PDT)
Message-ID: <856ec38f-de54-4079-9329-66adfa2790ee@kernel.dk>
Date: Thu, 13 Mar 2025 05:38:31 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.15-20250312
To: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
 song@kernel.org, yukuai3@huawei.com
Cc: xni@redhat.com, glass.su@suse.com, zhengqixing@huawei.com,
 linan122@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250313022445.2229190-1-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250313022445.2229190-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/12/25 8:24 PM, Yu Kuai wrote:
> Hi Jens,
> 
> Please consider pulling the following changes for md-6.15 on your
> for-6.15/block branch, this pull request contains:
> 
> - fix recovery can preempt resync (Li Nan)
> - fix md-bitmap IO limit (Su Yue)
> - fix raid10 discard with REQ_NOWAIT (Xiao Ni)
> - fix raid1 memory leak (Zheng Qixing)
> - fix mddev uaf (Yu Kuai)
> - fix raid1,raid10 IO flags (Yu Kuai)
> - some refactor and cleanup (Yu Kuai)
> 
> Thanks,
> Kuai
> 
> The following changes since commit a052bfa636bb763786b9dc13a301a59afb03787a:
> 
>   block: refactor rq_qos_wait() (2025-02-11 13:04:11 -0700)
> 
> are available in the Git repository at:
>   https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.15-20250312
> 
> for you to fetch changes up to 3db4404435397a345431b45f57876a3df133f3b4:
> 
>   md/raid10: wait barrier before returning discard request with REQ_NOWAIT (2025-03-06 22:34:20 +0800)
> 
> ----------------------------------------------------------------
> Li Nan (1):
>       md: ensure resync is prioritized over recovery
> 
> Su Yue (1):
>       md/md-bitmap: fix wrong bitmap_limit for clustermd when write sb
> 
> Xiao Ni (1):
>       md/raid10: wait barrier before returning discard request with REQ_NOWAIT
> 
> Yu Kuai (10):
>       md: merge common code into find_pers()
>       md: only include md-cluster.h if necessary
>       md: introduce struct md_submodule_head and APIs
>       md: switch personalities to use md_submodule_head
>       md/md-cluster: cleanup md_cluster_ops reference
>       md: don't export md_cluster_ops
>       md: switch md-cluster to use md_submodle_head
>       md: fix mddev uaf while iterating all_mddevs list
>       md/raid5: merge reshape_progress checking inside get_reshape_loc()
>       md/raid1,raid10: don't ignore IO flags

Pulled, thanks - fwiw, I did not get any merge conflicts, neither pulling
it into my for-6.15/block, nor merging it into my for-next. But if
the potential conflict is with 7e5102dd99f3, then that's already in my
6.15 branch.

-- 
Jens Axboe

