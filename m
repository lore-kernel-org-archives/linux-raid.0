Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAA32C21F0
	for <linux-raid@vger.kernel.org>; Sat, 27 Jun 2026 10:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782557550; cv=none; b=fCf42eRyKY81L+H2+lFVjNO5Q+Opdkzj/fV9E4AjXRHL4FbmjDrAhtAiHKtBPVtaWIuxPPUBLLUnyxMcSoNYcESQEup/Gu5rKRcHrvpXXGXTRqeVcnvSOYsXCz7hKDKtV0g5cpvzq9nDDMjLGamPgbEiFOm7l+OlrS5g24ZOvmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782557550; c=relaxed/simple;
	bh=21Hq6ALjxv/93wqb/w2iw1fI969DIwvlDVU4zYpbZok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E+/KTyOPZlkTnE2GdZfHihz9QaMsve2KEWA4/t7neoRgvHxV0dlYOPLfc1mcOh5qlH9M4Pe20kES36gXOo1GvIF5xiyo5b+AvrkMWNGjfsMBxJUMMCZ0DrRUw9SQ+I3WAoVNUNQ8NS/t7KxcZusKscnFBICa2Ce/m+EnN96VE9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UHdGVzPI; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UHdGVzPI"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-37d46e0d246so865494a91.2
        for <linux-raid@vger.kernel.org>; Sat, 27 Jun 2026 03:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782557548; x=1783162348; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RZJ799kdyJmydhBAGH9SH2bTgzw3gyEFMe2ta7BOqjo=;
        b=UHdGVzPI6m6j0CWV/Lv91llsDT6wPv90DpvUy5Bupe4spdMx/3pGJ5t0V2QRwswohQ
         tE3ns7oLazO+SJ7Gw6XcVZvKkT1uSAs2UcczZdeBV9cjUpTzI4N8Y8IzQBCIIvf98ppt
         l13c0qpcODKAXlJu0yQiJwxGx6ITIeqQgEB8XwapgPphuN33Zdlvinn5OIMUYdoj4otf
         DaYfegcUbDj+li9JxDV+b6UY0esD7CfH1HmwF+XOYTbXjKLHQyMWXV+dPp1+N09Spk8E
         Aw685oftNu5nQmefWSDa4lRbHBoKBU3z+OkqMSG8+6ckz/noXcjtiqXiCbxVIsrtPmBt
         BYMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782557548; x=1783162348;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RZJ799kdyJmydhBAGH9SH2bTgzw3gyEFMe2ta7BOqjo=;
        b=jnbNjyI0CtG85aAg5F7HA6tXlYe0Md9qjIMasIBUdFRi6r9HWV1Aayfh+Fh+QFdlxC
         uGjp4c/Wa0zTlkg4qJoKtqYNE2JaCiVxclP7ryFbQgSAZvg2KeIuedA9ipoIFSbVATKy
         Np3u/Ssqld09P0Qp1GiqW7ftvpxPB0iz5XLGQCuQHCt5zMNsb0ouLvDCXXdSTvdeSL2K
         5VyVLusTsOboLEJ2Y+tzVc3sSvRGn5CmDrFavJIEPjoWZ9P+lmsLtpowxH1JdkgV9N1p
         vF+6bACIwuk2Pd8pUSZzTwLwxzjVYfLhInC1lcT4PkhEXmpOZVRbBzvVHFWRUetSsomt
         cKgg==
X-Forwarded-Encrypted: i=1; AHgh+RooWrdYaEPDk8ynWS1yZbL+bVePCT5uu4Ovt/6bwiaDFFLxc9vNZxekzAinG+61CjzCeQZhi1wmIRrS@vger.kernel.org
X-Gm-Message-State: AOJu0YyvMfkghskemYOFJhl4XCshng36jQUVme9jFkCk7QMQOPaSHzK4
	CAEYKwThtjVtmNLW2LFvUL/8g8szcl+kA9+/MYLf4P+pNv5+mVLMJJ01
X-Gm-Gg: AfdE7ckh5Bq85cF4sz3gZWh1yhvNk+Fd9wOQ6ju1ZCTbcKeqdBw4oa0oG+0py7bUtdI
	k6xqoJA7/q67Y4lK4SN48qOySgf/YFaA0WJre9LGbtsdbJuibw+Pr2hi+PEVlCTiO1Pyy0cuSGU
	rcOZ629W/7vXLSGg3mHmCYo09PEck0/DQi1x0v/MhEpQyYc0mAouNNN76uagQtLcfnssZY8MxWP
	lbzCvXD/rn91j0fStm+FkQy7dwqicM9wZfoKqtNuunTKSD2/e2mdQmyknZOW1Rx+eSvMwHhAuN6
	wGYhpzIG7AsaT1BVvMHh4dzbQsRXqFEDjo7QGsVZEds4OHxyRFVt/0+duvvwhHLZycrBIo0zn08
	n0ex+fsUswg2kozKxBOrLfGK2091gB0tiV5aqPOihpJkoY5LOKKzTW3yNkod+8YaEd8m7nVlAV5
	t0aTrRLcMrInlUHUcf4HsmFlGb6El1/pq6rSS+sBhjA3IpUvQ=
X-Received: by 2002:a17:90a:d888:b0:36d:9e0b:3801 with SMTP id 98e67ed59e1d1-37dfa1f02cdmr8414628a91.8.1782557548337;
        Sat, 27 Jun 2026 03:52:28 -0700 (PDT)
Received: from [192.168.8.16] ([154.83.91.239])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c92b9eb8a30sm5036792a12.10.2026.06.27.03.52.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Jun 2026 03:52:28 -0700 (PDT)
Message-ID: <da95c106-6416-4abd-8fef-3b71986c17f8@gmail.com>
Date: Sat, 27 Jun 2026 18:52:26 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: protect read mddev->recovery in md_sync_action()
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
 Chen Cheng <chencheng@fnnas.com>, linux-raid@vger.kernel.org, yukuai@fygo.io
Cc: linux-kernel@vger.kernel.org
References: <20260627102909.141036-1-chencheng@fnnas.com>
 <m25x341cro.fsf@gmail.com>
From: Chen Cheng <chenchneg33@gmail.com>
In-Reply-To: <m25x341cro.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/27 18:46, Abd-Alrhman Masalkhi 写道:
> On Sat, Jun 27, 2026 at 18:29 +0800, Chen Cheng wrote:
>> From: Chen Cheng <chencheng@fnnas.com>
>>
>> md_sync_action() read mddev->recovery in lockless path, use READ_ONCE()
>> instead of u64 plain read.
>>
> unisgned long is not always u64...
> I can not see what it fixes, is this just to silence KCSAN? If so,
> please say so in the commit message.

I need to find KCSAN report , I lost this one, but I think it's easy to 
find locklessly path to call md_sync_action(), so. READ_ONCE is need.

> 
>> Fixes: e792a4c2156a3 ("md: add new helpers for sync_action")
>>
>> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
>> ---
>>   drivers/md/md.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index c5c50640b684..f4415c1a79d9 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -5074,11 +5074,11 @@ static enum sync_action md_get_active_sync_action(struct mddev *mddev)
>>   	return is_recover ? ACTION_RECOVER : ACTION_IDLE;
>>   }
>>   
>>   enum sync_action md_sync_action(struct mddev *mddev)
>>   {
>> -	unsigned long recovery = mddev->recovery;
>> +	unsigned long recovery = READ_ONCE(mddev->recovery);
>>   	enum sync_action active_action;
>>   
>>   	/*
>>   	 * frozen has the highest priority, means running sync_thread will be
>>   	 * stopped immediately, and no new sync_thread can start.
>> -- 
>> 2.54.0
>>
> 

