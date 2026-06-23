Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B6F369D6E
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 10:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782209174; cv=none; b=EexR2fBYALACJguQGn/AbAaiqzGdr8WbYZBA04+kQGfuMr+cfxRqAKN1tIZnDwJqTzoeVbMxHCSpZXT7KBeyVCncENETa/f0QjzhaCH1dv0v9Z3Ju0Zg7YCGy5Qmcbg343xYTUwhUamH4K97tIch1dmwK1eD6y09Zyhlw2XXQW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782209174; c=relaxed/simple;
	bh=IeCcvLfEXXfbac5s+Vn9SHrII3bh9+V9Maa+KrWFHm8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=u25HMMVJOY9BARuwUOB/q/WWGwI6oB8n6mmGWdbwZHePCFtnuCTEmySgoarGN4YNcalxi2lyz8a5PaqsrlkVBPrYYjNJeuN+8ziwRs2q7nl52IgqvlhKMya97St/zpr4+mxyvHE6YXgAfwBGA3nwHE7VmX+8MTCNZG4Yia7qrE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rm7d5FoA; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rm7d5FoA"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4629051c946so579468f8f.1
        for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 03:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782209171; x=1782813971; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=8BFdELiiAWXtyV9jq5igUjkjNq2N/STvSc6HvxYwA4E=;
        b=rm7d5FoA9C3R1RWeMMzypWWZNkakjyo0VgyWu5NLWQaKXOTT41yJ4AfrLRZzjNXS2F
         y66wkI5P2j8w/ejBHZNhOu6xwz+j5t8eLpczoh/sGVH8c9IPVedfMvDQkr1g8ZfpZ5tP
         cXu92hAA/NNSAGxERaVGPQfyPuvNjyRObYwlsMEeOBM/RqaD/J+XRFKHnO7pc4MaILRF
         jZEkBpYlGnZYHH6tW4Rym4K+ciRH9DbI+iznFq82jSuldnSmoFQcUC9Y5wmGHXQtx29R
         Zs41yKW8HuwRF0gDu7muUb/r9Dmtv3HjUdefkfKxjQUzWvXYNhn85x7a7caTOgIWiATP
         d2NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782209171; x=1782813971;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8BFdELiiAWXtyV9jq5igUjkjNq2N/STvSc6HvxYwA4E=;
        b=goj72YN7wA+Q/fccPNMJwTWDCNESvH547zmHOCBvqsvYeADyk5Wm0gMLSspQZzo3nW
         DyiacHt0ZETLgluWgUzOqtDbA7wBK8giuSyq63JksGnu+p03hJj/fRiZGS4p3lRdNcOw
         AofgTK+dqjMAmRY0VGTVT3WEYcuyH/xpeREyOOn9RbJzy3in1SYfOnJireDl6fbK572F
         lAYvU6KyntrEJ4X1YfBs4Ha2zin85j9fy8upJUhaKRFUR2R2ZsB1z0XamSjvkj5iJcEu
         ILcvi+DlPfrGWpAHZi21AzGg18gScP7Z1QWoDKvyQ4DUhIOQrVpx6Vzq2N9s92/11Zxo
         5Mgw==
X-Gm-Message-State: AOJu0YyvFwr2jbksJd6Qo/dl8qMjgsO0bmnTZhWKteHDNS1LNKJ7/Hve
	Ed0N+k9GjJ+LSZnxJzYTdFFX7hSNdWONpPxL7LlF/6PdrsAIfp5zxXQw
X-Gm-Gg: AfdE7cn9DF6ZcRJkhUNWlCZboJqx3eCTfXMKQLiXUnbMqZZDxum1SbusjfL3AxWdb46
	CQ6Q5hA1iWHCwOiODmiiEJIc1EQ/D0RInBN0M/8PSIk0Yj4u5tQhxTH30w5v92fZTtQQ1N525ob
	ElKy/ihpcJHTUKvseO91zN0MNMhtu5iuOEggCIfuFaUTTVlaG+jnOOFEwTdaB3t2fA+0mzG9qaj
	ahLmpTHoHw366r9euY81h21fBrKFGheamru2Sm1Ni8PpYWLz3O7lHeeESX6nybJbWF/5Hb8FTO1
	QLAb6yPm1aJHc7NaAADGyLHyRLGw5aR2WXGNxdzd28RLpsklb250k7F67O1eW3qZnnVJ2UiXK0a
	zGbQfX8dr8qQ3aWYjMTpysPo9UO+P2sTlgXrsclwETwroHa5jjfw2rSUMSybIH6QDm/iBG2vFTO
	M6AlVCSpLfGD2UpPMdYb8/Fq/537NgspkcNVdkTpY8j1A4hXXdvthJrdBX
X-Received: by 2002:a05:6000:250a:b0:463:3184:6310 with SMTP id ffacd0b85a97d-46a80f5c67amr4920142f8f.28.1782209171167;
        Tue, 23 Jun 2026 03:06:11 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([141.2.113.173])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46666788226sm33996976f8f.23.2026.06.23.03.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 03:06:10 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: John Garry <john.g.garry@oracle.com>, song@kernel.org, yukuai@fygo.io,
 magiclinan@didiglobal.com, xiao@kernel.org, axboe@kernel.dk,
 martin.petersen@oracle.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] md/raid1: handle atomic writes that require splitting
In-Reply-To: <6130d0cb-4cf8-4042-843e-98a9d8aa00c5@oracle.com>
References: <20260623072456.333437-1-abd.masalkhi@gmail.com>
 <20260623072456.333437-3-abd.masalkhi@gmail.com>
 <ba67f3ef-45cb-41c0-b4ea-fa0a22508cdc@oracle.com>
 <m2se6d1vls.fsf@gmail.com>
 <6130d0cb-4cf8-4042-843e-98a9d8aa00c5@oracle.com>
Date: Tue, 23 Jun 2026 12:06:09 +0200
Message-ID: <m2mrwl1sha.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Jun 23, 2026 at 10:20 +0100, John Garry wrote:
> On 23/06/2026 09:58, Abd-Alrhman Masalkhi wrote:
>> On Tue, Jun 23, 2026 at 09:11 +0100, John Garry wrote:
>>> On 23/06/2026 08:24, Abd-Alrhman Masalkhi wrote:
>>>> If a request already requires splitting when entering
>>>> raid1_write_request(), the current code allows it to proceed until it
>>>> eventually reaches the split path.
>>>
>>> The block layer should catch invalid atomic writes in
>>> submit_bio_noacct() -> blk_validate_atomic_write_op_size() before we
>>> even get as far as the md atomic write handling. Having the check in
>>> bio_submit_split_bioset() is really just a fail-safe for the block layer
>>> not catching invalid atomic writes or the atomic writes queue limits not
>>> being properly calculated.
>> The request size itself satisfies the currently advertised atomic write
>> limits, so blk_validate_atomic_write_op_size() allows it. The problem
>> is that RAID1 may further restrict atomic writes to a single barrier
>> unit via align_to_barrier_unit_end(). Therefore a request that crosses
>> a barrier-unit boundary can still reach raid1_write_request() with
>> max_sectors < bio_sectors(bio).
>> 
>> If the barrier-unit restriction should instead be advertised through the
>> atomic write queue limits, 
>
> It should. Any restrictions should be advertised up front. For the user 
> to issue an atomic write which is valid according to limits, then it 
> should succeed.
>

I'll take a look at how best to expose that through the queue limits and
rework this part accordingly. If there is already an existing mechanism 
you had in mind, I'd appreciate any pointers.

>> then I agree the block layer could reject
>> such requests earlier and the RAID1 entry check would become
>> unnecessary.
>> 
>> However, there are also cases where max_sectors is reduced later within
>> raid1_write_request(), for example when bad blocks are present on some
>> mirrors (or due to other RAID1-specific constraints such as write-behind
>> limits). Those reductions depend on RAID1 runtime state and mirror
>> health, so they are not readily visible to the block layer during atomic
>> write validation. In those cases RAID1 still needs to detect that the
>> atomic write can no longer be serviced as requested and fail it
>> appropriately.
>
> Sure, and we do this. As I remember, we should return -EIO in this case.
>

Right, and that's the main motivation for this patch. The original
atomic write support already returned -EIO for one bad-block path, but
there are other cases where max_sectors can be reduced (e.g. the
first_bad <= sector path and write-behind limits)

After a4c55c902670, those cases can end up completing with EINVAL or
NOTSUPP instead. This patch is intended to restore consistent -EIO.

>> 
>>>
>>>> Along the way, the bio may instead
>>>> fail due to other conditions and return a different status, even though
>>>> the request was invalid as an atomic write from the beginning.
>>>>
>

-- 
Best Regards,
Abd-Alrhman
