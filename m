Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF272F432D;
	Thu, 12 Jun 2025 11:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749728800; cv=none; b=ByVbjhBkJVu1q1/xSfKnmZBLnFy/Bsjjt59MiP7VmxA+XFaVVgQSNFFtKuee+3FBXL67+VKDzhyFqknlDtdn6fgb7HNS4y5jCpUYmuTQZJbygoBRC2ObhJtj/NIc+a8UanD8ZWq7U0m5Y85c6gZmHiBJi2Z1djgwfZuiIidXymE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749728800; c=relaxed/simple;
	bh=6kyCd79elVVz9w7C1iL0q4pP1juNCRt97yDdVokwHFo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eOQsSzkw/tf9JK/excWPIvUNTUgjaGNXHjUAmPvHoniHQ1T83jESuSWkZSePnj+jx1FrmZuUB9zxfyklFZUNnhpwBMGjnQihfbogr6lrPL+OwzK8qEIUIQ9agZYg4SnEcl7l8EIYJnlritcQggB1cmTy951Tjfs1LxeqS6JthAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gRcI0QwJ; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gRcI0QwJ"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b2c49373c15so550955a12.3;
        Thu, 12 Jun 2025 04:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749728794; x=1750333594; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qAwCLsOB9UNaMoXfUZNh8nWkRvCrRoLVHEF2NKA4kRI=;
        b=gRcI0QwJ5RUiNxsOKgXNzNcbv/Ie0TutC/mhoPFvSuzVTv19AxP3aKU7ynNecNn1yG
         joinsT7CesrpT+GuH7AFMR7VKv6mkxn7MB3XBpEChD9xco7OcsqsD/NRKwM6IncqjoTA
         c50vjZc9WaxTOO7RjX7fc18bztMmCMfnZpXsoeKzFLNp1IUQwy8h1eJJ7KK6XJfqH8Cp
         4anotbeg8NjADWFvzc2XK+f7LmZ5VOP96AYFcTokg9p4ljy0t08LP5LHuImMNQ0FSSUs
         DOEivim9jFPDJJt5fhUTXSPWziM6+ubjF+Sr/Lj56Cxc+IJ69UGOUym3vnCbSPHGGPy3
         Y5Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749728794; x=1750333594;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qAwCLsOB9UNaMoXfUZNh8nWkRvCrRoLVHEF2NKA4kRI=;
        b=PrUjhqw6e1wM9SHOHPTDPV6mE+VH9vaysTym81x8L02qyUbH4pdfLP/3AoLOBYIDsi
         6s5pSAv0QMCbgUUx+OsF5l4/0qOw34V8eVPGagaAvztxNvrqF9yLuMogktPH57mPwR7z
         dTeGZlNrPQi7NNzYuojSJHwdiPaUnOt5rJ5/8PxSEKhS/oBI6XR0dx+kfbhT81eDxOXF
         OaHgqoI7GvSTzlKgPFjCCPFbZ0fS1uA/2dT7jpAE2eJiKS0gjZK6IsItqW8AKFAHeS/s
         mtAg8hzCM2+cx+rcBjTdWPYyGLTkjy5ongsPnbdeYxDZEy2si/ZQLW8IM+/r4mtdeDYH
         05fQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRo3KTP7ES0zdpkt613RwHdmDCEccDZdRdDzGDw0pKx2YQCT7+kfs9hV0vY2pBmW5DeFwxijLjoQPwNO8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf+XPeHR3n+mwEY31xyRrz51xsR0rspRVqoqp9qDkxCfJGXPuX
	pWyJevrrQKNYu1K4M0J9tcYol2pnrR0vvrHLz0OJH+u+VKPrLbAxirde
X-Gm-Gg: ASbGncsDPb1PYhxH8JCenIcwLJ4GpOqwO66deaP4iRO+LIo706CAyR4od0UOWG9PmmU
	rherzgP1grUHH2q16jT8/4lcOwcGGjqe+OFbs9UMIf2hAumaGv+PzlTkCzJRdhxm7YnLBRuykPz
	zICAypKAlop1MtJboIU5fL4ujYS97tMakVr+ZmowlK+w9Rga3+Vm5j5DC/kiS38txLdn/dcrHG0
	dYJOtZAfKA2TCtawyyFkA748l6uedAiLO1tNzFz4KN6gOPPHIvyZTWIl5BhOk1NKoUrqagzKynp
	slPcGCisCCD/d6VSHHoWepPsvAAxw4ywOoswMqy8AEBF
X-Google-Smtp-Source: AGHT+IG96EwuutwCEbVWsKYGM+6CIpHZb8TyjaAWUB8nUkhwOKnSk9cwsGQowjwYbBYpeG+8/ZGmwQ==
X-Received: by 2002:a17:90b:4cc8:b0:311:c1ec:7cfd with SMTP id 98e67ed59e1d1-313bfbdaf8emr3944291a91.26.1749728794460;
        Thu, 12 Jun 2025 04:46:34 -0700 (PDT)
Received: from [127.0.0.1] ([2403:2c80:6::3058])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1b49a8asm1251226a91.32.2025.06.12.04.46.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 04:46:34 -0700 (PDT)
Message-ID: <726fe46d-afd5-4247-86a0-14d7f0eeb3b3@gmail.com>
Date: Thu, 12 Jun 2025 19:46:31 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] md/raid1: Fix stack memory use after return in
 raid1_reshape
To: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250611090203.271488-1-wangjinchao600@gmail.com>
 <5143c5c3-3a77-919f-0d38-8adb0e8923e9@huaweicloud.com>
 <06935480-a959-4e3f-8e41-286d7f54754a@gmail.com>
 <9c7d5e66-4f5f-b984-c291-f19c3d568b85@huaweicloud.com>
 <938b0969-cace-4998-8e4a-88d445c220b1@gmail.com>
 <8a876d8f-b8d1-46c0-d969-cbabb544eb03@huaweicloud.com>
Content-Language: en-US
From: Wang Jinchao <wangjinchao600@gmail.com>
In-Reply-To: <8a876d8f-b8d1-46c0-d969-cbabb544eb03@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025/6/12 19:23, Yu Kuai wrote:
> Hi,
> 
> 在 2025/06/12 17:55, Wang Jinchao 写道:
>> Now that we have the same information, I prefer patch-v1 before 
>> refactoring raid1_reshape,
>> because it’s really simple (only one line) and clearer to show the 
>> backup and restore logic.
>> Another reason is that v2 freezes the RAID longer than v1.
>> Would you like me to provide a v3 patch combining the v2 explanation 
>> with the v1 diff?
>> Thanks for your reviewing.
> 
> I don't have preference here, feel free to do this.
> 
> BTW, I feel raid1_reshape can be better coding with following：
> 
> - covert r1bio_pool to use mempool_create_kmalloc_pool(use create
> instead of init to get rid of the werid assigment);
mempool_create_kmalloc_pool also calls init_waitqueue_head(&pool->wait) 
internally, just like mempool_init.
So the issue only exists if newpool is allocated on the stack.
> - no need to reallocate pool_info;
> - convert raid1_info to use krealloc;
I think reallocating pool_info is only for backup and restore, similar 
to newpool.
> 
> Welcome if you are willing to, otherwise I'll find myself sometime.
I'm a newcomer to RAID and can't quite catch up with it right now.
Maybe I can refactor it later, and I look forward to your guidance.
> 
> Thanks,
> Kuai
> 

