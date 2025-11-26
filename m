Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD031303CAF
	for <linux-raid@vger.kernel.org>; Wed, 26 Nov 2025 09:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764148493; cv=none; b=cG/HTzLl4rYtCcxVKkxA37WJ6hgAkET+I+OHfp9Q8HFE1TkuPGtLUEfHRrGt44/s1v01zjKwWb9iuYtJ18jOoOIGyyNXEoaXi6wYCcAY6eIGfiLDyVM9li/YBB0c55kk9LO9+Z4yC0OLWlkaOYQYExVxMCsiLMDOFrxdfpgjPbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764148493; c=relaxed/simple;
	bh=C7u5TaIFYxCrpu4dYTWLHkvOWIUo764ll9nIVkmUeUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MyPlY4I4GyZQ1PCIbXquBNa6c4QXPe6pNQRLrRBURR1UjAVKX4wBjEVkqNE3jm0n5+/w3J6IzKRdnqaQh9b6SzTJ2vZ1D0miyZ533clNnLzN4T1qfsONPqYfev5oXs/BgNyp8CIEl+7UydVdegiKk/VPH5N7SWYVWhZ4qqTObnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uy3BemnR; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uy3BemnR"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7c66822dd6dso465725b3a.0
        for <linux-raid@vger.kernel.org>; Wed, 26 Nov 2025 01:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764148491; x=1764753291; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FsAxxdgt6IXuSxrdWBozCg8XdMM7lBgDlsl70F68Y1Y=;
        b=Uy3BemnRhp93t3By2uJPWoAgD4iwm0ztHeTg4uNKLR3KLhfWjKaxtuEssCd6b9jHxl
         uXBlDm+ZEQtwbfCbhQvjfMa0MDuCJIXuJtLE3CYojhDjeX4p+TI+1Uav2gJT03IulEo7
         0lzeFgZFnKaq7Rf4+paJpbtf5S2NdewY5c6CIOnGWvluHH7E6rXjdFlXhK5peRtQWusR
         ylsf9OV3RlQZP5QOogfiPyaRy9nv8QS6vtggDEQIEtzNPDQMb8lCfaEAHlCvjFxV5UVy
         3AgRdbDazMiOxW/6G8mp420ryyFaWm0bxhmMeu3XGNREY/VXZkTZEJYHeCt+aQTDA/6Q
         g+nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764148491; x=1764753291;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FsAxxdgt6IXuSxrdWBozCg8XdMM7lBgDlsl70F68Y1Y=;
        b=hGe5WYv/lMuVpL3yqKUgeiyF3KwnW0G8/HcjvLMUN6QJ8qR8QWfNq+fP/ZOZMbTvVW
         Xm7MKQqueBuTAsC/KWUqlmIneBvqtxE0QqbIJJkYRzBc8WRoMqDJdx6e2quOeCy2X8no
         1YKzpd7HwH4/mCIkwY0TrKHDC8Jg+gTdzx8S8Tnc/+3awtTIOhXN2e8ssNFRKpggnrf4
         4EXAgEZtK7xDZwW7mr40JHIptHifhjKo/ZKTRABeXD3aanb3lG8gTzLfKOpVJj7dkVmr
         jYKrMRszpg/DwYWewiLRO+Z5Z6gu6r9B1iyMl1KnsvX3xIY6JjDHXswbAiUCNom0SewO
         hPkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFTJjmpHA+yhK0mzKmbNP+C4pLvcmK50Ocrb6ck8JWUOw6Oa8dLmK+xOlXnKVR/pUyPzRwu1WVVQ8f@vger.kernel.org
X-Gm-Message-State: AOJu0YxMw0Ko2sH69KnIoQHqthoLOvauwTQ7bcN76NafYUajB+w9qUYE
	F4jL8dXuABkHpYOJiD+ghqnIXxZi1agKSFnIbBw3xH6oExkM4LC4+U8h
X-Gm-Gg: ASbGncusEXy5gd4hi5JKuBkAfsZ+aTPXHpZDBilxFkEgYS1k3O0Es136kQy67o+kAy5
	abZcfnPXEvqhogp5U7fb+pFUFGxRpQW0pwNrUgBqLsMnzrMHLMPrjPlUUkwN6sDkUlCIIZw5JSP
	4oeK102lLjBwyxK4DSXJeG1n2O3KIwHSlbOWm2LkDU1/TEwB11YWTUIrN/S75nh6zGXkw48OCcP
	32P0v3YbojNtq3FGjLrvRW8VbN8RrLmKeoSgwgZ1uCJl5pp+gsYpigeXRvdF+OKfR+PQfoXZPuB
	A5L+FVP0fP1KJFfGFZXye4+8UHnc1+JnIHoMLd5+R/Q8l+/KSKcS91Rx2W5nh9BLNs47rMWsGHZ
	M6/N5hulq52RGsZPEsrL8dW1VkiUPMP88eERP0v8RIJ1WesEPa8+6t/S06l0SyrZhfXXT9FdmKY
	qIw1y0GgBgef8n0lZIvcaHXe1dc+ui/w==
X-Google-Smtp-Source: AGHT+IGT8gd70TCQi63rsPWx+UIJ4mcNla5iKtS6p8pWOc51DUh5MCPHup9N3N3lGRYqyvIBZTUYDg==
X-Received: by 2002:a05:6a20:a114:b0:342:fa5:8b20 with SMTP id adf61e73a8af0-3614f5aec2cmr19183971637.30.1764148490926;
        Wed, 26 Nov 2025 01:14:50 -0800 (PST)
Received: from [10.189.138.37] ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3ecf7d849sm20690335b3a.14.2025.11.26.01.14.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 01:14:50 -0800 (PST)
Message-ID: <2da95607-9b21-4d21-8926-9463021a6f33@gmail.com>
Date: Wed, 26 Nov 2025 17:14:44 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [f2fs-dev] [PATCH V3 6/6] xfs: ignore discard return value
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 Yongpeng Yang <yangyongpeng.storage@gmail.com>,
 Chaitanya Kulkarni <ckulkarnilinux@gmail.com>,
 "axboe@kernel.dk" <axboe@kernel.dk>, "agk@redhat.com" <agk@redhat.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "mpatocka@redhat.com" <mpatocka@redhat.com>,
 "song@kernel.org" <song@kernel.org>, "yukuai@fnnas.com" <yukuai@fnnas.com>,
 "hch@lst.de" <hch@lst.de>, "sagi@grimberg.me" <sagi@grimberg.me>,
 "jaegeuk@kernel.org" <jaegeuk@kernel.org>, "chao@kernel.org"
 <chao@kernel.org>, "cem@kernel.org" <cem@kernel.org>
Cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Yongpeng Yang <yangyongpeng@xiaomi.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-f2fs-devel@lists.sourceforge.net"
 <linux-f2fs-devel@lists.sourceforge.net>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
 <20251124234806.75216-7-ckulkarnilinux@gmail.com>
 <b18c489f-d6ee-4986-94be-a9aade7d3a47@gmail.com>
 <218f0cd0-61bf-4afa-afb0-a559cd085d4a@nvidia.com>
Content-Language: en-US
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
In-Reply-To: <218f0cd0-61bf-4afa-afb0-a559cd085d4a@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/26/25 16:07, Chaitanya Kulkarni via Linux-f2fs-devel wrote:
> On 11/25/25 18:37, Yongpeng Yang wrote:
>>> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
>>> index 6917de832191..b6ffe4807a11 100644
>>> --- a/fs/xfs/xfs_discard.c
>>> +++ b/fs/xfs/xfs_discard.c
>>> @@ -108,7 +108,7 @@ xfs_discard_endio(
>>>     * list. We plug and chain the bios so that we only need a single
>>> completion
>>>     * call to clear all the busy extents once the discards are complete.
>>>     */
>>> -int
>>> +void
>>>    xfs_discard_extents(
>>>        struct xfs_mount    *mp,
>>>        struct xfs_busy_extents    *extents)
>>> @@ -116,7 +116,6 @@ xfs_discard_extents(
>>>        struct xfs_extent_busy    *busyp;
>>>        struct bio        *bio = NULL;
>>>        struct blk_plug        plug;
>>> -    int            error = 0;
>>>          blk_start_plug(&plug);
>>>        list_for_each_entry(busyp, &extents->extent_list, list) {
>>> @@ -126,18 +125,10 @@ xfs_discard_extents(
>>>              trace_xfs_discard_extent(xg, busyp->bno, busyp->length);
>>>    -        error = __blkdev_issue_discard(btp->bt_bdev,
>>> +        __blkdev_issue_discard(btp->bt_bdev,
>>>                    xfs_gbno_to_daddr(xg, busyp->bno),
>>>                    XFS_FSB_TO_BB(mp, busyp->length),
>>>                    GFP_KERNEL, &bio);
>>
>> If blk_alloc_discard_bio() fails to allocate a bio inside
>> __blkdev_issue_discard(), this may lead to an invalid loop in
>> list_for_each_entry{}. Instead of using __blkdev_issue_discard(), how
>> about allocate and submit the discard bios explicitly in
>> list_for_each_entry{}?
>>
>> Yongpeng,
> 
> 
> Calling __blkdev_issue_discard() keeps managing all the bio with the
> appropriate GFP mask, so the semantics stay the same. You are just
> moving memory allocation to the caller and potentially looking at
> implementing retry on bio allocation failure.
> 
> The retry for discard bio memory allocation is not desired I think,
> since it's only a hint to the controller.

Agreed. I'm not trying to retry bio allocation inside the
list_for_each_entry{} loop. Instead, since blk_alloc_discard_bio()
returning NULL cannot reliably indicate whether the failure is due to
bio allocation failure, it could also be caused by 'bio_sects == 0', I'd
like to allocate the bio explicitly.

> 
> This patch is simply cleaning up dead error-handling branches at the
> callers no behavioral changes intended.
> 
> What maybe useful is to stop iterating once we fail to allocate the
> bio [1].
> 
> -ck
> 
> [1] Potential addition on the top of this to exit early in discard loop
>       on bio allocation failure.
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index b6ffe4807a11..1519f708bb79 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -129,6 +129,13 @@ xfs_discard_extents(
>                                   xfs_gbno_to_daddr(xg, busyp->bno),
>                                   XFS_FSB_TO_BB(mp, busyp->length),
>                                   GFP_KERNEL, &bio);
> +               /*
> +                * We failed to allocate bio instead of continuing the loop
> +                * so it will lead to inconsistent discards to the disk
> +                * exit early and jump into xfs_discard_busy_clear().
> +                */
> +               if (!bio)
> +                       break;

I noticed that as long as XFS_FSB_TO_BB(mp, busyp->length) is greater
than 0 and there is no bio allocation failure, __blkdev_issue_discard()
will never return NULL. I'm not familiar with this part of the xfs, so
I'm not sure whether there are cases where 'XFS_FSB_TO_BB(mp,
busyp->length)' could be 0. If such cases do not exist, then
checking whether the bio is NULL should be sufficient.

Yongpeng,

>           }
>    
>           if (bio) {
> > If we keep looping after the first bio == NULL, the rest of the range is
> guaranteed to be inconsistent anyways, because every subsequent iteration
> will fall into one of three cases:
> 
> - The allocator keeps returning NULL, so none of the remaining LBAs receive
>     discard.
> - Rest of the allocator succeeds, but we’ve already skipped a chunk, leaving
>     a hole in the discard range.
> - We get intermittent successes, which produces alternating chunks of
>     discarded and undiscarded blocks.
> 
> In each of those scenarios, the disk ends up with a partially discarded
> range, so the correct fix is to break out of the loop immediately and
> proceed to xfs_discard_busy_clear() once the very first allocation fails.


