Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206F634753F;
	Tue, 21 Apr 2026 07:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776755889; cv=none; b=JrrcMp3ElSOKwPX5xQWUE5Yi+1lBf7xZKrKRu0MUWgufrY5giVWXy54oVjMsDWVmWqkysGe0ebNp7NyCsoYcRfQh+yj769WodR1dtXsshhUU7L5EvHE8YpuYVwK+WTp8t5kGoqGVGNcMVr26gm/XCs8bDokKeVbNWqUKCg2SA/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776755889; c=relaxed/simple;
	bh=Tj0vp2FMas1mPy5BHq7Y1bjRgp8LVDCMuwDEWXSsHi4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PCTST1fyJqTIDCN4iDiTWVXnbdy6hSoz4X1y2QTaQDxqVTS0dKoQXF+a4nXcWZmjDt5mSM+TYJ1v4GDk2tnOPBJ77YfjmlAFdA13YTYOBehNUaBc9MYBmxkIbS1eWOLJK5n7R4P7clrC6bCEqmDHaKCnog3OrNdknIDLgp3MZtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=HZq7WobK; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="HZq7WobK"
Received: from [10.17.40.225] (unknown [10.17.40.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.synology.com (Postfix) with ESMTPSA id 4g0D4S3H6fzJ4pBk4;
	Tue, 21 Apr 2026 15:09:28 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1776755368; bh=Tj0vp2FMas1mPy5BHq7Y1bjRgp8LVDCMuwDEWXSsHi4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HZq7WobKsuvOMWlS1FwYFnfUf5XNHeDuzz/1CqwOhYChNLvq/gcAy9H7XwnS7qj9C
	 HVaPtdTYWNpceWfwnsluRKjkW9Y/qQ9BfLO0CNIb41ca3shiVlHpAQBCyL+rYlRbXR
	 oopW0LwQSJErlPWRbIFm5i5BjEZlI7buc/Ijr4EY=
Message-ID: <d298e159-1e47-4c97-80cd-41c4c1c74a04@synology.com>
Date: Tue, 21 Apr 2026 15:09:22 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid5: fix race between reshape and chunk-aligned read
To: yukuai@fnnas.com, song@kernel.org
Cc: linan122@huawei.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260409051722.2865321-1-dannyshih@synology.com>
 <68b61dc3-f7fa-49ba-9f26-f07b7fa4768d@fnnas.com>
Content-Language: en-US
From: FengWei Shih <dannyshih@synology.com>
In-Reply-To: <68b61dc3-f7fa-49ba-9f26-f07b7fa4768d@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no

Hi Kuai,

Yu Kuai 於 2026/4/19 下午 01:14 寫道:
> Hi,
>
> 在 2026/4/9 13:17, FengWei Shih 写道:
>> raid5_make_request() checks mddev->reshape_position to decide whether
>> to allow chunk-aligned reads. However in raid5_start_reshape(), the
>> layout configuration (raid_disks, algorithm, etc.) is updated before
>> mddev->reshape_position is set:
>>
>>     reshape (raid5_start_reshape)        read (raid5_make_request)
>>     ==============================       ===========================
>>     write_seqcount_begin
>>     update raid_disks, algorithm...
>>     set conf->reshape_progress
>>     write_seqcount_end
>>                                           check mddev->reshape_position
>>                                             * still MaxSector, allow
>>                                           raid5_read_one_chunk()
>>                                             * use new layout
>>     raid5_quiesce()
>>     set mddev->reshape_position
> While we're here, I think it's pretty ugly to disable raid5_read_one_chunk
> when reshape is not fully done. So a better solution should be:
>
> - data behind reshape: read with new layout
> - data ahead of reshape: read with old layout, reshape will also need to wait
> for this IO to be done, before reshape can make progress.
> - data intersecting the active reshape window: wait for reshape to make progress.

Thanks for the feedback. I agree that using reshape_progress to distinguish
the three cases (ahead/behind/inside reshape) would be more refined.

But disabling chunk-aligned reads during reshape was already the 
existing design.
In the original code, the check is at the caller level:

     if (rw == READ && mddev->degraded == 0 &&
         mddev->reshape_position == MaxSector) {
         bi = chunk_aligned_read(mddev, bi);
     }

My patch is focused on fixing the race condition in the existing 
lockless check of whether
reshape is in progress. So just to confirm: are you suggesting we add a 
mechanism to
allow chunk-aligned reads during reshape (based on reshape progress), rather
than simply disabling them?

>> Since reshape_position is not yet updated, raid5_make_request()
>> considers no reshape is in progress and proceeds with the
>> chunk-aligned path, but the layout has already changed, causing
>> raid5_compute_sector() to return an incorrect physical address.
>>
>> Fix this by reading conf->reshape_progress under gen_lock in
>> raid5_read_one_chunk() and falling back to the stripe path if a
>> reshape is in progress.
>>
>> Signed-off-by: FengWei Shih <dannyshih@synology.com>
>> ---
>>    drivers/md/raid5.c | 8 ++++++++
>>    1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index a8e8d431071b..bded2b86f0ef 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -5421,6 +5421,11 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
>>    	sector_t sector, end_sector;
>>    	int dd_idx;
>>    	bool did_inc;
>> +	int seq;
>> +
>> +	seq = read_seqcount_begin(&conf->gen_lock);
>> +	if (unlikely(conf->reshape_progress != MaxSector))
>> +		return 0;
>>    
>>    	if (!in_chunk_boundary(mddev, raid_bio)) {
>>    		pr_debug("%s: non aligned\n", __func__);
>> @@ -5431,6 +5436,9 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
>>    				      &dd_idx, NULL);
>>    	end_sector = sector + bio_sectors(raid_bio);
>>    
>> +	if (read_seqcount_retry(&conf->gen_lock, seq))
>> +		return 0;
>> +
>>    	if (r5c_big_stripe_cached(conf, sector))
>>    		return 0;
>>    
Thanks,
FengWei Shih

Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
