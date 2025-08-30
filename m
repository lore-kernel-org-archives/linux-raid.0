Received: from sender4-op-o12.zoho.com (sender4-op-o12.zoho.com [136.143.188.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEC0273804;
	Sat, 30 Aug 2025 11:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756551899; cv=pass; b=ZnaYyb6O3T2UvBCqAFXBSkBT7gNXNwb+zIit1pBLjvLn+F0BCGDiKiUQ9qmwFr9zkQ4P30f1e6Fn4pxCFBGtSATCFWcznS8BRweb16CwaYeOajHSnzSVhhNCRUNwDPcIXGW2qOjXaCraf64zF5pSwvp61t6jWZCrPYzMmT2Ac4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756551899; c=relaxed/simple;
	bh=+65sX5nlFKAh9MHG4yXXm398wCqhoW92jc7OjOtoJss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cBwAH+q7dYT9fcMKhKwxgASI4rtUcbMCgRnH1lZIGl5zplJKiANGO3vCUahPvVyT+KfRP2HkJRVdJhUrOoQII9CuKzTpAqiyMirkFF9fxHVbCgXjJGHAsQ2pOaT1pPWIOQI4il/hHl5EWGudsINzVi3XfGvKgfAE8+dTXOQS8wY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=yukuai.org.cn; spf=pass smtp.mailfrom=yukuai.org.cn; dkim=pass (1024-bit key) header.d=yukuai.org.cn header.i=hailan@yukuai.org.cn header.b=c6emmv6Y; arc=pass smtp.client-ip=136.143.188.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=yukuai.org.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yukuai.org.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yukuai.org.cn header.i=hailan@yukuai.org.cn header.b="c6emmv6Y"
ARC-Seal: i=1; a=rsa-sha256; t=1756551864; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=YEJQLPEockC3FyLEiWCrL8CF7rtfxYof8nPCXha/AbJnWIEN2z3zYQOb4bIIQs9N6L2ReR/tl7APASy0chK4LNEZqF4DQYHzHnvQ9MYf9vGlzSmGEy/zm89DbkaxEae0wgdfhjEsFESPs5cpnFrQqSbInJ2ky8wO3QzHfdVZ+oM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1756551864; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=+4I0XrREZWrnl9fdIlgeC39pe31+x02BFXZRvd/fLiQ=; 
	b=UcyQ6qz4wUHcEAPLtwV/Xfg1Y7zi2t8pdCGBN6qQRSKQTYQgLeDe2pqPRjEfsy4waP0m+sIWELmdfH+/Zkm8MTo2SwDeOQiA4EnArZkzBhS8L8zO1xPh1bdi93IAh5h9zwOOTMQ8r4xOqX8qsrZ1fvXRs/BCeWbYHdeDayCPpsA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=yukuai.org.cn;
	spf=pass  smtp.mailfrom=hailan@yukuai.org.cn;
	dmarc=pass header.from=<hailan@yukuai.org.cn>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1756551864;
	s=zmail; d=yukuai.org.cn; i=hailan@yukuai.org.cn;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=+4I0XrREZWrnl9fdIlgeC39pe31+x02BFXZRvd/fLiQ=;
	b=c6emmv6YRLH8yex4AxLbCBuQfrXHiTCEDrdOHmjUi2Or15uM8UnIHKuRuhhbeyH3
	XN0BP0aZkxRdMwzZ/93PpF59RXX6qol1gkG4dHZxel5rgKCNYyk5DOD4CHNc0hms8v0
	1WxB1PsafIi2/MPn42OlE7NC/QPHlT1PrCYPpB3Y=
Received: by mx.zohomail.com with SMTPS id 175655186159215.312786958320203;
	Sat, 30 Aug 2025 04:04:21 -0700 (PDT)
Message-ID: <969460f8-9ed2-4535-8336-4a7c359f5708@yukuai.org.cn>
Date: Sat, 30 Aug 2025 19:04:16 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: prevent incoreect update of resync/recovery offset
To: Paul Menzel <pmenzel@molgen.mpg.de>, Li Nan <linan666@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250830090242.4067003-1-linan666@huaweicloud.com>
 <2eadd8d3-7705-4000-982e-cafd222977c1@molgen.mpg.de>
From: Yu Kuai <hailan@yukuai.org.cn>
In-Reply-To: <2eadd8d3-7705-4000-982e-cafd222977c1@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Hi,

在 2025/8/30 17:41, Paul Menzel 写道:
> Dear Nan,
>
>
> Thank you for your patch. I have some formal comments. In the 
> summary/title: incor*r*ect.
>
> Am 30.08.25 um 11:02 schrieb linan666@huaweicloud.com:
>> From: Li Nan <linan122@huawei.com>
>>
>> In md_do_sync(), when md_sync_action returns ACTION_FROZEN, subsequent
>> call to md_sync_position() will return MaxSector. This causes
>> 'curr_resync' (and later 'recovery_offset') to be set to MaxSector too,
>> which incorrectly signals that recovery/resync has completed even though
>> disk data has not actually been updated.
>>
>> To fix this issue, skip updating any offset values when the sync acion
>
> ac*t*ion
>
>> is either FROZEN or IDLE.
>
> Maybe state that the same holds true for IDLE?
>
> Should these two cases be handled differently in `md_sync_position()`. 
> Does it semantically make sense, that the default of MaxSector is 
> returned?
>
Max sectors will return, however, following procedures will update
resync_offset to MaxSector, while recovery can be interuppted by the
concurrent frozen, can this will cause data lost.

>> Fixes: 7d9f107a4e94 ("md: use new helpers in md_do_sync()")
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> ---
>>   drivers/md/md.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index e78f80d39271..6828a569e819 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -9397,6 +9397,9 @@ void md_do_sync(struct md_thread *thread)
>>       }
>>         action = md_sync_action(mddev);
>> +    if (action == ACTION_FROZEN || action == ACTION_IDLE)
>> +        goto skip;
>> +
>>       desc = md_sync_action_name(action);
>>       mddev->last_sync_action = action;
>
Please send a new verison with the typo fixed.

Thanks,
Kuai

>
> Kind regards,
>
> Paul
>
