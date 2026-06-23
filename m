Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1669F30DECE
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 16:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782231103; cv=none; b=BnOtASPHb3Kw3DWIjdvpJwJVCNbBsw+W0evQBA3NiL6R0pji4Mpwepf707b4mDB0TznKRAkx5yZhOZJAPnR2LBcq+1IRG05lWyjRbpMHDTKP3eYBCJUWthsF9nova1QgsR6HDJxMUQh+6nFK+rdXa6W0aN5csqkI2s4vjZekQS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782231103; c=relaxed/simple;
	bh=ApYd6eMLX287wrJ6saYJiEWcq2pAqFgsSpMo+tAeWLE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QV6oOT595iU+kLse+DxFlqF8pH1XGJTfsmJdeDIv+F35Gc+fHbnDGdMQ25xINS9o+xAaPRe+ymT6psTcFk+i6IvObCKvt7KBUIRni5yJlXta5lmL1tZFIgdYeWJVnKv69Bh2mlo9aWMAGjnkmZZeAKxw6lukVL62unJ7dHPlo8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o/1Z/gsW; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o/1Z/gsW"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bec3ffb95dbso6080466b.0
        for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 09:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782231100; x=1782835900; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=qseEtwramBDXDeeIOB7L3DgR9DC3hS4bogH0wKDYVJM=;
        b=o/1Z/gsWmtWcFwQUfSwQqdb5LKDsjWI0doXDLQ9/zTVw3RTfIFLu6S8t5BS/tr702C
         2PZXb5S/BaI5du5PZwkFTgRP8i6OwHv9yNKWW5xTIAuxyLCO0la9Uz373p/PwSb26TVI
         LUZbDAWbvrAHp3zPn+TZj30S4Sg/AtpQX306qgEWrMwOTWAWZBMwhYjyd9lrJLLuA+no
         y+4vBQMt69mQccCtETG2ghoF8oPZqf7Z1jiPohssCza/9XBDqbgoN5AG0+654nCYxBY5
         90skk+Armh/hvQ68IqXVSWB8pLFwp94GLQhyXbr1PVEmvb/YASnLavDC0jZqHxiA1nbO
         IZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782231100; x=1782835900;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qseEtwramBDXDeeIOB7L3DgR9DC3hS4bogH0wKDYVJM=;
        b=nYRLj05FHORNodmMKzA74eJVbI7+KlmDBW9pYRitRGvZzwsb4FgFEuxEkgkXAyy4/C
         VOpwYU7+OYLWiyb1rgGgQ9G75CWdkEBiK43dJYTChQirJQNitUtZ7yCTjLbXBYufhXu8
         LyCroKR8WjqHUrBkef/N1Xg8jLuq+1i9yhlSby6ZDTSRA1sJOksU0WsTmLeQlE8HDbPg
         y3Z5Mq+UwJX2GCuj1JeFzRiXUowdPqrs48Pt+YWxs2qIWm7IKqa9TOe0kraKMjxNvt6S
         alF064gy9NuN4Gr7wAnFgvVr9CyVFP4rw4mllAEHTQj9OhfUCQKQDHdMby7TpO1ASDx9
         GpHw==
X-Gm-Message-State: AOJu0Yx/C4y2mcMttoHgyEiEzqPyAsj2I6zLZV3b1YpT9PM7sI5wyV5O
	xc3HHNuoOFdRqlbiTsWLHKlqqyVfUh8HLQBfma/aFaqAAYb8qteXiGorReDCnA==
X-Gm-Gg: AfdE7cmpDMFJDoAKQasALP2Jio2dUFjz3EYplP/m24CZ1KZjYILPW532KMz7aqdfzWl
	4ihxz22rZDJ58E+OYkLLHtQyg5h6mO8sUmib6kdocIgDTv8qlEcE+67rkfhGznVTp4+FScku+V6
	gWGPbQtWc+ye7am7uIMPRfgn6oupayHjbN1hYBgYv82mgwraDRvXlx1rDKAEQSYroSUjAnJ6eJ5
	oz+qXsF4P4obagagYjAKsv23b+fA24OOmIxgSRuviCaNTXACwZp5EfkHZjb+0SoKHzeGAKVCCfe
	LzzyWv3PVm1jcMPlk2c1IVYYPZT/51145ym5/wcwgd9oBJjtp5Zj0Fv6m1Ao/NYuxJF/yS92KYZ
	vn5tYEkNNYI0X29/p9HWxv+zD4odD7P/Xk+TakW4JjauXQHCyypW5qq4bXo2ZnVznKiQyxpz99e
	YTCvYvxU1PWU4g76+R7yoCVPYhTXyJZLdH344bInU2VJeE3WkJc0mWwGoIxYAQVNnY
X-Received: by 2002:a17:907:6d1e:b0:c0e:883e:e4e6 with SMTP id a640c23a62f3a-c0e883ee9e1mr588253166b.25.1782231100269;
        Tue, 23 Jun 2026 09:11:40 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:603:9c63:bc1f:6f2d:e43:dd64])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46666788226sm36432536f8f.23.2026.06.23.09.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 09:11:39 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: John Garry <john.g.garry@oracle.com>, song@kernel.org, yukuai@fygo.io,
 magiclinan@didiglobal.com, xiao@kernel.org, axboe@kernel.dk,
 martin.petersen@oracle.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] md/raid1: handle atomic writes that require splitting
In-Reply-To: <007416b5-d099-406d-b1d1-ff0db2edc48a@oracle.com>
References: <20260623072456.333437-1-abd.masalkhi@gmail.com>
 <20260623072456.333437-3-abd.masalkhi@gmail.com>
 <ba67f3ef-45cb-41c0-b4ea-fa0a22508cdc@oracle.com>
 <m2se6d1vls.fsf@gmail.com>
 <6130d0cb-4cf8-4042-843e-98a9d8aa00c5@oracle.com>
 <m2mrwl1sha.fsf@gmail.com>
 <007416b5-d099-406d-b1d1-ff0db2edc48a@oracle.com>
Date: Tue, 23 Jun 2026 18:11:33 +0200
Message-ID: <m2jyrp1bka.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Jun 23, 2026 at 12:38 +0100, John Garry wrote:
> On 23/06/2026 11:06, Abd-Alrhman Masalkhi wrote:
>> On Tue, Jun 23, 2026 at 10:20 +0100, John Garry wrote:
>>> On 23/06/2026 09:58, Abd-Alrhman Masalkhi wrote:
>>>> On Tue, Jun 23, 2026 at 09:11 +0100, John Garry wrote:
>>>>> On 23/06/2026 08:24, Abd-Alrhman Masalkhi wrote:
>>>>>> If a request already requires splitting when entering
>>>>>> raid1_write_request(), the current code allows it to proceed until it
>>>>>> eventually reaches the split path.
>>>>>
>>>>> The block layer should catch invalid atomic writes in
>>>>> submit_bio_noacct() -> blk_validate_atomic_write_op_size() before we
>>>>> even get as far as the md atomic write handling. Having the check in
>>>>> bio_submit_split_bioset() is really just a fail-safe for the block layer
>>>>> not catching invalid atomic writes or the atomic writes queue limits not
>>>>> being properly calculated.
>>>> The request size itself satisfies the currently advertised atomic write
>>>> limits, so blk_validate_atomic_write_op_size() allows it. The problem
>>>> is that RAID1 may further restrict atomic writes to a single barrier
>>>> unit via align_to_barrier_unit_end(). Therefore a request that crosses
>>>> a barrier-unit boundary can still reach raid1_write_request() with
>>>> max_sectors < bio_sectors(bio).
>>>>
>>>> If the barrier-unit restriction should instead be advertised through the
>>>> atomic write queue limits,
>>>
>>> It should. Any restrictions should be advertised up front. For the user
>>> to issue an atomic write which is valid according to limits, then it
>>> should succeed.
>>>
>> 
>> I'll take a look at how best to expose that through the queue limits and
>> rework this part accordingly. If there is already an existing mechanism
>> you had in mind, I'd appreciate any pointers.
>
> Any write must fit within BARRIER_UNIT_SECTOR_SIZE, right?
>
> Since an atomic write must be naturally aligned, then I would expect 
> that the atomic write max unit is limited by BARRIER_UNIT_SECTOR_SIZE.
>

Yes, that makes sense. I was thinking in terms of a boundary
restriction, but with natural alignment it should be sufficient to cap
the advertised atomic write max unit. I'll rework this accordingly and
drop the entry check.
Thanks for pointing out the natural alignment aspect.

>> 
>>>> then I agree the block layer could reject
>>>> such requests earlier and the RAID1 entry check would become
>>>> unnecessary.
>>>>
>>>> However, there are also cases where max_sectors is reduced later within
>>>> raid1_write_request(), for example when bad blocks are present on some
>>>> mirrors (or due to other RAID1-specific constraints such as write-behind
>>>> limits). Those reductions depend on RAID1 runtime state and mirror
>>>> health, so they are not readily visible to the block layer during atomic
>>>> write validation. In those cases RAID1 still needs to detect that the
>>>> atomic write can no longer be serviced as requested and fail it
>>>> appropriately.
>>>
>>> Sure, and we do this. As I remember, we should return -EIO in this case.
>>>
>> 
>> Right, and that's the main motivation for this patch. The original
>> atomic write support already returned -EIO for one bad-block path, but
>> there are other cases where max_sectors can be reduced (e.g. the
>> first_bad <= sector path and write-behind limits)
>> 
>> After a4c55c902670, those cases can end up completing with EINVAL or
>> NOTSUPP instead. This patch is intended to restore consistent -EIO.
>> 
>
> ok, but I could not check this as I did not recognize the baseline code.
>
>>>>
>>>>>
>>>>>> Along the way, the bio may instead
>>>>>> fail due to other conditions and return a different status, even though
>>>>>> the request was invalid as an atomic write from the beginning.
>>>>>>
>>>
>> 
>

-- 
Best Regards,
Abd-Alrhman
