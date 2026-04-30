Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A5E3FFAD7
	for <linux-raid@vger.kernel.org>; Thu, 30 Apr 2026 11:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777550046; cv=none; b=GT9AHffbMFHhaKC1FDXMXvg9qqrQG9fYOWOu53uPB3UP9zJ+Nvn0AeIg01kTRIWx9UhFk8OdTvWqP6C8qZsjwIVZtEvvoT0zJ8EHVgtplJ5effHy30g1stSrQov7LsXupJ/6xy4Jps6a1+gU+cMGKyPjwv4S/znJvtcjZhyE4zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777550046; c=relaxed/simple;
	bh=oTa7tnyBpqyehEW4ZBA2nWLcTSort0c0oK0WzkQ4vDM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KthQBH+sBrKxQA5UP7W3hARbkSZWHaG85x2jJh6P7v0/ZAnzU2qFp/v8iGHAGbt3mJ1QKeXk9C8l9UwwJ8zasAM/2NrJC+iyP6RSIVdhm/gFKgZi5cq5JeqtZwA8RthVn+o2rmb3bvwdM41UPUDIPZvlxcmou7ruJujun59NfAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JqHxWXsn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XfCAAYM0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JqHxWXsn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XfCAAYM0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777550041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oVf21Q87wMxstABQQ4yKTOo3PL5/bOYlW9ggMldczV4=;
	b=JqHxWXsnd1Q0aEnvrz62CEhX08r/5Nlks6CY02QzeHDAD49+KrV4yKhjxfAN94Y+i3ZnDp
	2BHezXGjj2P4eiz41Blx186BEERiawCfyrAgXEvYL83NBktTV19wMGnrDbnBAjmhSD7Ljf
	AZw/PZaFWLQeXhTtBnvU3Vx+GvrbpJY=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-PEgOKPb5OL-oK4Cgwevogg-1; Thu, 30 Apr 2026 07:54:00 -0400
X-MC-Unique: PEgOKPb5OL-oK4Cgwevogg-1
X-Mimecast-MFC-AGG-ID: PEgOKPb5OL-oK4Cgwevogg_1777550040
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8d5107ec672so187246285a.0
        for <linux-raid@vger.kernel.org>; Thu, 30 Apr 2026 04:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777550039; x=1778154839; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oVf21Q87wMxstABQQ4yKTOo3PL5/bOYlW9ggMldczV4=;
        b=XfCAAYM0CJtJbojbLjF6YUVt5ZJgFaKiWYlDCWlW1Elc8oYSVm4GYLsUIJFpPJ0M8a
         Ttm8om7Lqc3H59QZWpMbY/2z7kuKV9aVigni/gbEjftPjcsJlk3c3HQ1//EVlnsXtyub
         lymNFpi3g+NVIuXl45ideerDbRuweAHQb37x3ac2AcQcqx8F8aJjtOumQqhxLE3eLLrp
         jRWqBz0IFhKEA0MUFMl+ttmZJIt2zdNczVjkJmpHojAoCDotGHrUSJzKdHN+WqSv9644
         kMu3XvYgcq/fmKF68wa5GOSBeJjk8N+9xbJEGV0RdiNww9qSy4Khty8ihKMc1Wv2DKhN
         KWHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777550039; x=1778154839;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oVf21Q87wMxstABQQ4yKTOo3PL5/bOYlW9ggMldczV4=;
        b=LLQUi9LS8+LbAur2Ov0SX1sztATwy2tQcmBnAV7860xzXYvnJiZUHiq2CW0aVovdC9
         JfENBD+bkswGb0w4EihVjhJO9HqMemzE4WaHaZCr9rgqyq01UxFkB04VbVGqeP79jUHY
         LAwHYywGM7+V8Mx0v+TcLaFyi9OBmoeTAPdq/JNLeq6noSJDwNyGCL6KfvR+OmA1M8dW
         mlwoH0R1eHFLXtVgTmv6ccw1E2G1qoItmt+aWfCf1hZR5raeDj2PcftJVkIartvyuzdZ
         MRRX/3bptaSailvvLKw5PE+51/C4ZwcCthxCb9mipkRC7hEK9pAoQf7ZhND3dLjvFGFJ
         R6Yw==
X-Forwarded-Encrypted: i=1; AFNElJ9iM8C+41qBaF7pIULsnYk4084PAXZ2o2rZfJkcNVKzLakPQw7WjFSIILAda/y/grRSZ9ZzKzq03Dl7@vger.kernel.org
X-Gm-Message-State: AOJu0YxvL/3p2DofzOhsWe4stmZi3mDemnkw2zk8kXaobpY4M7Q7q3uB
	dnptVxEECRAV3HPg4diuuBhqlFHkM34xyOiGPwFRtTCLfJfpQyGQ86gdUfXMnUecH8SgZs4cxpf
	gRawtIDCZizzjoS+4sWBwEBI4ppeoPrjP6UhtEnsZVhEy9KLBSiLK3vAugiP8ICY9jpOO5Tw=
X-Gm-Gg: AeBDietHWxFIwJNwtUAlhk4Jq50w16hU0VbmGHRefsW2iAznFb/jCmYhlnT8QkGNo8o
	0MLAFQWCQD6yQta0saE0mYriRDXXnkUS88QPhXo+ednvjr7hRNDOJ5omo7CE6u8aZDmrOvM8HS1
	7oLiyAKEYwYWHTDe5HtNkoevUFe1p0/PFo/X/ZjI8KY8fDDXmG6V5z6KM7G2chnIvi0PPbSNlpm
	4nIn6Za2g8ZUvUAdtvm+S1kIG1x1TR7QjoLmi2o8GZr17L1lf1vx7guhCdhlfbjQH0r3pgh5F71
	/JsHuZYu8fLs1ba2H+OFEoSsgJ4pu362oJSbezwYhwgQG0LrvCS811suPZYMw12QCc3BtziB0cz
	5Ch5GPWdI01V20kxlxqh8wBBa+YlRGIykzbmopOtD1i8fuPCAuvCdCA==
X-Received: by 2002:a05:620a:319f:b0:8ef:2a7a:e6f8 with SMTP id af79cd13be357-8fa8941a8d6mr394062785a.50.1777550039517;
        Thu, 30 Apr 2026 04:53:59 -0700 (PDT)
X-Received: by 2002:a05:620a:319f:b0:8ef:2a7a:e6f8 with SMTP id af79cd13be357-8fa8941a8d6mr394058985a.50.1777550039029;
        Thu, 30 Apr 2026 04:53:59 -0700 (PDT)
Received: from [192.168.50.139] ([23.160.248.161])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8f94014bd1csm429315285a.43.2026.04.30.04.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 04:53:58 -0700 (PDT)
Message-ID: <6601c3ed-df0f-462a-b8a1-440976089536@redhat.com>
Date: Thu, 30 Apr 2026 07:53:57 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid5: Fix bio retry on interrupted reshape
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org
References: <f861791b-d539-45ce-8575-5ec74d58d15d@redhat.com>
 <a7e94a16-439e-4b28-bc0b-580e00953473@molgen.mpg.de>
Content-Language: en-US
From: Nigel Croxon <ncroxon@redhat.com>
In-Reply-To: <a7e94a16-439e-4b28-bc0b-580e00953473@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Looks like this was just fixed by Benjamin Marzinski's

commit 418b3e64e4459 md/raid5: Fix UAF on IO across the reshape position

So my patch is not needed anymore.

-Nigel


On 4/29/26 9:07 AM, Paul Menzel wrote:
> Dear Nigel,
>
>
> Thank you for your patch.
>
> Am 29.04.26 um 13:10 schrieb Nigel Croxon:
>> When a bio encounters LOC_INSIDE_RESHAPE during a reshape that is
>> interrupted (stopped or unable to progress), the code sets
>> bi->bi_status = BLK_STS_RESOURCE to signal the block layer for retry.
>> However, bio_endio() is never called, so the block layer never
>> receives the completion notification and the retry never happens.
>>
>> This causes I/O to hang when a filesystem is layered over RAID5 and
>> reshape gets stuck.
>>
>> Fix this by calling bio_endio(bi) before md_free_cloned_bio(bi) so
>> the block layer is properly notified of the BLK_STS_RESOURCE status
>> and can retry the request.
>>
>> Tested stripes and stripe size conversions under load comparing
>> files multiple times during each conversion (i.e. MD reshape) on
>> ext4 after dropping caches degrading the RaidLV each time and
>
> I thought RaidLV misspelled Raid V (Raid 5), so should you resend, 
> maybe write it as RAID LV.
>
>> no data corruption.
>>
>> Fixes: https://lwn.net/Articles/757123/
>
> Which paragraph/comment exactly?
>
>> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
>> ---
>>   drivers/md/raid5.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 6e79829c5acb..9a3475429ef4 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -6217,6 +6217,7 @@ static bool raid5_make_request(struct mddev 
>> *mddev, struct bio * bi)
>>
>>       mempool_free(ctx, conf->ctx_pool);
>>       if (res == STRIPE_WAIT_RESHAPE) {
>> +         bio_endio(bi);
>>           md_free_cloned_bio(bi);
>>           return false;
>>       }
>
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
>
>
> Kind regards,
>
> Paul
>

