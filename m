Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3213ABA2E;
	Mon, 23 Jun 2025 03:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750648689; cv=none; b=cSCRrNk0BdkEC2T/kqz6DDBnPmRRu67xVA0ZDpWjAGg6swsvgNMyp30oZib3KaeJDNW57wT0bLTzQtDWL+s2wZLXU+2i2oOTIk0096sLm3kzSL+e2h6YcayHrxrMTVqKxT9fjwG4GoK5+4aEfUdOAywj+Csb8ELItLRJFQDLqao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750648689; c=relaxed/simple;
	bh=5KgJ/iVCk/hXOQVjVktarsxy1gYDRTr65AQwlsnflts=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pmhyPzf7z30VU2lFLq0axwVmZz9WXETLNEJc+t1UYiWiLbjyaeGOteCm+6OmLy+22p5ANVGpcMgAkxwSjtStZNxUmLmxSASvVHoNyqw/VePypZhkCBSWW/NraWgVf/an228MnfskaWy02zRtyZXe2fHXTLNOjjESiriKjYpBaNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S6xI98k2; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S6xI98k2"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2349f096605so54512445ad.3;
        Sun, 22 Jun 2025 20:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750648687; x=1751253487; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xmT4D9hgTBMR3gIYgRKWxfW3yQ4aGn+EWxBBm4FeBzU=;
        b=S6xI98k2gcRiqxOGNBpuNbjyjqKViRe12qubVq41x+2XXf6MJxQeRZBu31c6avVZic
         F/vSNKPzy1f/s+cAeWiMAxlxMGjZqo7326gq1CdDz4ukmxqcFRbJRMJweSbyCZPW48pz
         PB4Q9jVR12wO03XNW4G2Ovc9BTx5VzkVegcyduB51ikav82+AmOZ7eGTYXgB3KAXPIRw
         dylY5rAPJM/x0wZL2QZ1GvI/Aq0GMyXZ3YS63nP7ETIA9I+YULKW+miB9UCnA2cZmb9b
         XaHZ9qwZSEPBJB9XRlZjVW9tY22FOu6eWgLoj7iYlpab4XQs63ivSDXWtFdPQyE5Og8B
         ghNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750648687; x=1751253487;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xmT4D9hgTBMR3gIYgRKWxfW3yQ4aGn+EWxBBm4FeBzU=;
        b=DlkeLCSDcCnilBqkjCGkPgFsvGCfdkhohIIaRytbw9eTpA3flUg/hY9SfgqqgF77Uu
         PCbtwupKvPruQO9sOcAoCYcrhKezb+uWBTanVpzc0CYaSIrzFymxCuQYD0CmeS2EGtUb
         OyNIJvRuS2gMH7sU001EdspsobURZ8auG6c7tGwgppY1bJYbNLo9gGuj/qhASMF4A4al
         C5eATGd0uqqf2d6ytonKtdMXyvYQuVHAT7exN8bVYa83McDkM1nJ8Px20oKIeIZPYjOx
         hRzX9H4XYOwIEupaBK/LF6ELSTWsKgDwgrziTvcku1gW9E33PioeL830XdbWfv21q3I/
         b0Sg==
X-Forwarded-Encrypted: i=1; AJvYcCXY9j7VLp99bzh9i+tCDp18zG0Bf70OQgrW2or2H3nGD6USlwArlZo5uRS7x1lMeRu9WCg6lqQbaqzFAw0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyN7CpKG0vcOL7owZ4NVQP2JbqvZvqJXscrac+QcVTkufBODHKU
	rbbGE3ovrMWvJGrnmWBhuLNQjNY94RdbEY36V27/9DaM8kO4XJcjsGgq
X-Gm-Gg: ASbGncstEQCzGbav05A91doj+9fC4CEmv5I/yvC9M9xGOIZbxtMzBrGE7VURlrO7KjB
	c3rjVd+NrvES36U6DamrFXZDsReWb6a9i/DdjqJxPVaFHq/xjztt3s+RRIgzT3QRj1uo3KAJmsU
	fjq+trt92oA0ooPz2r3RDzOH4vsbtCGMFdf7t6h+Ge4E0xZOjLWJs7AbqATZ5bOD2LxDU6yCdbg
	ddDQGslIRBnqaTmIWkEiGBf/Q6QDho3pOfiqIH+SaTCbY5iIbjCi58UbpAVDiWvGPLcEHhr56wg
	fOmCtgsez5zQC3OeXlhTHUmefO6+dC9pNZt54ZMefgvjDS0vRLNgvqk=
X-Google-Smtp-Source: AGHT+IEsscPvrsZ4xtlWAm7wpXUlEqf8yvsYCZJp4bq/i0hJCSIVg9JubZd5bUcsbTtx9K+NEHKK2Q==
X-Received: by 2002:a17:903:120f:b0:235:efbb:953c with SMTP id d9443c01a7336-237d97cccd7mr156791165ad.13.1750648687314;
        Sun, 22 Jun 2025 20:18:07 -0700 (PDT)
Received: from [127.0.0.1] ([2604:a840:3::1028])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d8608efasm70633275ad.133.2025.06.22.20.18.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Jun 2025 20:18:06 -0700 (PDT)
Message-ID: <35358897-5009-4843-8234-136bd5756e0b@gmail.com>
Date: Mon, 23 Jun 2025 11:18:03 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid1: change r1conf->r1bio_pool to a pointer type
Content-Language: en-US
To: Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
 linux-kernel@vger.kernel.org
References: <20250618114120.130584-1-wangjinchao600@gmail.com>
From: Wang Jinchao <wangjinchao600@gmail.com>
In-Reply-To: <20250618114120.130584-1-wangjinchao600@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/18/25 19:41, Wang Jinchao wrote:
>> In raid1_reshape(), newpool is a stack variable.
>> mempool_init() initializes newpool->wait with the stack address.
>> After assigning newpool to conf->r1bio_pool, the wait queue
>> need to be reinitialized, which is not ideal.
>> 
>> Change raid1_conf->r1bio_pool to a pointer type and
>> replace mempool_init() with mempool_create() to
>> avoid referencing a stack-based wait queue.
>>


>Can you also switch to kmalloc pool in this patch?

>Thanks,
>Kuai

Hi Kuai,

Comparing mempool_create_kmalloc_pool() and mempool_create(), the former 
requires the pool element size as a parameter, while the latter uses 
r1bio_pool_alloc() to allocate new elements, with the size calculated 
based on poolinfo->raid_disks.
The key point is poolinfo, which is used for both r1bio_pool and r1buf_pool.
If we change from mempool_create() to mempool_create_kmalloc_pool(), we 
would need to introduce a new concept, such as r1bio_pool_size, and 
store it somewhere. In this case, the original conf->poolinfo would lose 
its meaning and become just r1buf_poolinfo.
So I think keeping poolinfo is a better fit for the pool in RAID1.

By the way, I did not receive your email in my Gmail inbox; I found your 
message on lore.org. The last email I received from you was on June 16, 
so I am not sure what the problem is.
I also sent you an email mentioning that not using poolinfo makes 
rollback in raid1_reshape more difficult.
I wonder whether you received it, or maybe I missed your reply.

I am looking forward to your discussion. I want to gain a deeper 
understanding and contribute more to md/raid.

Thanks.


