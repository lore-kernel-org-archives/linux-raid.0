Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451871B0424;
	Thu, 12 Jun 2025 12:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749730918; cv=none; b=G0FqO6PyC8UOVJK3ghi8PHzRyuh0ka5MoMs8VZPxGKFmxuDDcV3l25ZQ+jjsvR++9Ww3tqJfnbJa+KkBii9d87j9y7JoebVAP2D1udUaBu+NuBY0NBjV4Squg24vQhqRCQG+c4B5b52uLR3Q8+UXSWEr3exM771hO6e0aMXhhVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749730918; c=relaxed/simple;
	bh=mx0Cc92nJJ3zT6EAzmBR3Iha+RWueZbG7taTjsjNdUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lTr++X9DywRqzDXBYfuCpaWti8HlV/CI5cUgTs1h6CNq7fyQgUqq3zC3Me7s9l43CNBwGFtCHZ5NPVj7BNun+R7R7uhpwZgLxSmezBmdRCL0nhut+aYGg20qmJ0U8nk/K0r/M51aPVwnabQoPuFwpxyLdzrXQUL3QcFe8K826kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SopO+q2f; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SopO+q2f"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3135f3511bcso707408a91.0;
        Thu, 12 Jun 2025 05:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749730916; x=1750335716; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ips9XmJA491ust1kuaJxylsO+HtOgjRvxVEBF3R5x50=;
        b=SopO+q2f+W8p8IknCNzC5ZFMPBtwzW7OvKRxzWBJdWslFoDKlE3lD2BlEw9veooaYH
         IS4RuYVe94/7j4tIsjF0O5TCRTN7hhXDP1Odf6u/0LLhsHx5ZpKevg2z/mZf/QfsdEAd
         spLKZZVFsrirq48XhZ/t5kz77zeWOMoHGJXyNHertfIyYzSvtDwQW4fBWfVC9Md8QE8m
         IinCmsU8XVU1qESBI0BWk6yvBkEOEkJpaaIPqyK/FcPvlaxXbo1vJaZKyPjnLzQyRc8J
         RtB1o6nq5qENlVYYsU6KCfqR3QTX9XCfV7pG+KXe2I+K0vu+YEcvdq2KZ7kDr68wVB1t
         C1Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749730916; x=1750335716;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ips9XmJA491ust1kuaJxylsO+HtOgjRvxVEBF3R5x50=;
        b=bUnmRqYl601QhTIdehM31nKGm1xT+ZXKTexsUkCqbPuaTlVQ6BJU1P9RJd6XJK8DPY
         XX/rcpxFnuB5EiPLxln0nPPBLQlMWHCs+s8oo393FCm/Jn6oxTkCb3h+6OwnYaOfnoRS
         +KKndV+d6oK+c6B9+JjuJJ7F/eX1SgPMhgqo7MFpH0WgEVq04V6LEjVUp7/hhbAz6at7
         SNxJ06TA4TlErFlA5n5125bu9KFaB5WoA/fHLGDTE05yAFTMlWfLXdKzqcD2XC5meHoJ
         yRS6eYM2EmKBEaaCfvxsKUhR0h0CARGm3EJCmKWMENyPBhQbLVdLOW5UlA29Qk8I1NRZ
         EXkA==
X-Forwarded-Encrypted: i=1; AJvYcCXDmNGokhQdKdIu0m7hqyUFKe9zcaYFQAU6b7x8IToeU2mpk50u69BnrmRvY/0AV64EgmC2mELYYGZKk5k=@vger.kernel.org
X-Gm-Message-State: AOJu0YypSDn4ySwSH23AhG70ELIxMbqm/r7AV4NfecMQHcb3YC8CKxAC
	NIzXnaXQ2bw6kI80a7gGocSE7ViAJM1aWgheCjTpez3nYSUkZvtjvrpMmjFucQWg6/c=
X-Gm-Gg: ASbGncve/BQPKOAvXOQ1CR1U5DgcEhcuGz5dz+OnrhZ9qCYLjxPjl50TbfNPks1MGnE
	YkrVoVkQCFjNv3Gs10N9ErBGpURJkYQ5XRPo9MH4nCA0IOW7sQZIkAedHBKscAQ2noAqDaiqc7r
	oT1kGVLrX1PhHhsPk3hmGZqZ1kpF1OJEXJ/2gFnTZXubQXcYaf6p2nbHFvDlLrFmCll7NVa7uCy
	xK73H6VAw69RvP7ToHQSFSOC3je7z6qHRP6XZ9NSWg1ZODRCZVZoK1mzA8CMDl5D04507HkW/fW
	njfMk1UNTgyIhyEl7BxkWk5YpRixXRhWtCGsjAGF3sSqQuc8s+q4fom1a2SlYyHMI+w=
X-Google-Smtp-Source: AGHT+IEENy86yrtyWtwuPouB2JFmEHwxS/dZyJdHaK+faDqd4sGmZCvaEXOSxis88IGOtYNVdpO0Hg==
X-Received: by 2002:a17:90b:6ce:b0:313:2b30:e7bb with SMTP id 98e67ed59e1d1-313bfbc198bmr4856060a91.15.1749730916312;
        Thu, 12 Jun 2025 05:21:56 -0700 (PDT)
Received: from [127.0.0.1] ([103.56.52.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1bcbb62sm1313228a91.4.2025.06.12.05.21.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 05:21:56 -0700 (PDT)
Message-ID: <9275145b-3066-41e5-a971-eba219ef0d3c@gmail.com>
Date: Thu, 12 Jun 2025 20:21:51 +0800
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
 <726fe46d-afd5-4247-86a0-14d7f0eeb3b3@gmail.com>
 <c328bc72-0143-d11c-2345-72d307920428@huaweicloud.com>
Content-Language: en-US
From: Wang Jinchao <wangjinchao600@gmail.com>
In-Reply-To: <c328bc72-0143-d11c-2345-72d307920428@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025/6/12 19:58, Yu Kuai wrote:
> Hi,
> 
> 在 2025/06/12 19:46, Wang Jinchao 写道:
>> On 2025/6/12 19:23, Yu Kuai wrote:
>>> Hi,
>>>
>>> 在 2025/06/12 17:55, Wang Jinchao 写道:
>>>> Now that we have the same information, I prefer patch-v1 before 
>>>> refactoring raid1_reshape,
>>>> because it’s really simple (only one line) and clearer to show the 
>>>> backup and restore logic.
>>>> Another reason is that v2 freezes the RAID longer than v1.
>>>> Would you like me to provide a v3 patch combining the v2 explanation 
>>>> with the v1 diff?
>>>> Thanks for your reviewing.
>>>
>>> I don't have preference here, feel free to do this.
>>>
>>> BTW, I feel raid1_reshape can be better coding with following：
>>>
>>> - covert r1bio_pool to use mempool_create_kmalloc_pool(use create
>>> instead of init to get rid of the werid assigment);
>> mempool_create_kmalloc_pool also calls init_waitqueue_head(&pool- 
>> >wait) internally, just like mempool_init.
> 
> Please notice that creat will allocate memory for mempool, the list is
> no longer a stack value, the field bio_pool inside conf should also
> covert to a pointer.
> 
>> So the issue only exists if newpool is allocated on the stack.
>>> - no need to reallocate pool_info;
>>> - convert raid1_info to use krealloc;
>> I think reallocating pool_info is only for backup and restore, similar 
>> to newpool.
> 
> You can just change the old value directly, after everything is ready,
> with the first mempool change, pool_info is not needed for bio_pool.
>>>
>>> Welcome if you are willing to, otherwise I'll find myself sometime.
>> I'm a newcomer to RAID and can't quite catch up with it right now.
>> Maybe I can refactor it later, and I look forward to your guidance.
>>>
> 
> No hurry, take you time :)
👍
You're right — now I understand the whole.
I'm willing to try refactoring raid1_reshape later.
> 
> Thanks,
> Kuai
> 

