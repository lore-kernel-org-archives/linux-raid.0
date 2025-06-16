Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF9E27EFE2;
	Mon, 16 Jun 2025 10:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750068702; cv=none; b=cpgVzs9g+XipO1/kP97uk/2y1nPamx621omuem0dQWvpuoGFytVRJlgg7+D0Nr7YiTkUlpue1KYaRtiQriZFgeNuJ1XIc/GOElXIY8YrUDWkcAuEwsybKaqkI9DQtDBscZgqu7sihuXlrJTXsh6vv1TAUXUt0Ue3VXuU08Z13EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750068702; c=relaxed/simple;
	bh=DBFfuZeOGbZOlUTLbOIHoL51WjpzR1Cb4s1pUhSsSqs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ptlYXLCq94uKLjyxGVnQDY7mJucKQ1nZvNwHL+15INB4u/vrGih/s3k7R9yc0mYpKHDfBPz3700+BWUTgnnMqcngm4iytLKlN7z2Ux2WBaXgYMKninVxgCyc3FzMU8Cqm3RJBZVeM+6PviXfWcEzHNYaJmCvyMrAAba816uqI8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cx2RabJ9; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cx2RabJ9"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b2c40a7ca6eso4414370a12.1;
        Mon, 16 Jun 2025 03:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750068700; x=1750673500; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uCY/2lWyIdRDSDAH+SP+gwtY/Y3WYN4+BpMczBHtBhw=;
        b=Cx2RabJ9NpoJLnAO+sAGgxXKm2Z0muMtaHiDvCLcL9MFnxuM+qasHO+CuY31k5KdFG
         2uoQrkTSV1JR2kH7NkI8TD3hp6XoHwqV4r9My/S2LefUjP4uw+KvuVpCGAR3KAuen8LN
         sugr3P5/zk1DSpl1h5em010kma/TClPaxIqbOh6EDi1pcTk8/jspBJlbA2Kh7jLpZ0I2
         lGW3WN1t3LeoyRz4dNqg/xEWSHtn7WhHHCNwyhkd8/sy0TZITpB6HJmX5rdPSh2W5CtW
         bWReGJLY77YUPPEhuA9B9CpecZuUdkNw3EULAgbpZqwz7WubQz8nFMx9aVQyx3/dc3sP
         khcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750068700; x=1750673500;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uCY/2lWyIdRDSDAH+SP+gwtY/Y3WYN4+BpMczBHtBhw=;
        b=rIBxxMbYcNVu5iBQ0mukGCWj/YwzXiQCY6U47UVbhdInMsGIjgTlsMUXCKzlbfTFYV
         m2CfuK9TMjbCkH39LyPjRrH/PwYiBEyHHzVAFNbsIpFEuYPviPV9MPVpgzEpWhZ+hiAa
         jh9/w4Bx3sYt8/RUEKN0xdTC3yrlQPjHQbbDpuwEi/H5p8JukNIKzqJzYeMDG/1OuSY4
         kVI3JKEltmfA7vwJ5TIscU8jwtynChsA6o4taFxNcq9XAH4kibdPDv8hsa6adMFwFy90
         sZk0dpvBkv0VpPAiMpoG4H5Hs3w0iNl+wpKI3xW1hZYakk1lOUIQHKsKCz5Gae9synHW
         Jd2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWmftZG68EagPww62kTUzx1qkYMEZ2UeZ/zwyrBLwb3eLLr0sN4q4vB/eq7Nrsvp4EC8eaICxoPEkgubk4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOlWvo8jxxb2zGsxah1VRKTLaAhXTm+eW0eI1RzW+cDRy916vd
	LUutU4AZeP2qER225q1r99/5Yk/iPlAvyazChd840L9iA5haPeYFBRmx
X-Gm-Gg: ASbGncuxOwhso5n2lJPyiLGWllIZyeGH3Dawjvtw/leeN3o4S4XiYDh32awdDpcyxZ8
	C8VksQNYS0H6XKMDWpHzRkG/XNTuy+tW9sLChJWyAhs6R2kfidOU+Tfxb6OIh8hNiBlO8eSlCT7
	gWYE9oUPCvXtu3g3XKdO9wsuOm5TrGtW0mKbGOTwY0wDH2eV5d5GrNzyPa1fke4B3NbqNz2tMvo
	fJlOnC/A7Wo4axwSHH8bvMtHZEkwlS0ufHm+FDoochVFVwJUoO3TMxAQZDO5k6ak46rPnH6tl2X
	/Y5H1RIGp3/beFZbSAT3xywLNVcllg/bFt18yEkliq1PEHg26WyZOkA=
X-Google-Smtp-Source: AGHT+IHTt/a97wReIhLu0XIrlIXxqH5CisKlmkfc18nSOryCKYAoK2Xs7Z/vAUDjtlZRA92dsVRanQ==
X-Received: by 2002:a17:90b:4f81:b0:311:c1ec:7d05 with SMTP id 98e67ed59e1d1-313f1d86e3bmr12187740a91.35.1750068699747;
        Mon, 16 Jun 2025 03:11:39 -0700 (PDT)
Received: from [127.0.0.1] ([2604:a840:3::1088])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1b2b545sm8189327a91.0.2025.06.16.03.11.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jun 2025 03:11:39 -0700 (PDT)
Message-ID: <351b7dc4-7a2c-4032-bf2c-2edaa9da9300@gmail.com>
Date: Mon, 16 Jun 2025 18:11:35 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] md/raid1: Fix stack memory use after return in
 raid1_reshape
Content-Language: en-US
From: Wang Jinchao <wangjinchao600@gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 Song Liu <song@kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
References: <20250611090203.271488-1-wangjinchao600@gmail.com>
 <5143c5c3-3a77-919f-0d38-8adb0e8923e9@huaweicloud.com>
 <06935480-a959-4e3f-8e41-286d7f54754a@gmail.com>
 <9c7d5e66-4f5f-b984-c291-f19c3d568b85@huaweicloud.com>
 <938b0969-cace-4998-8e4a-88d445c220b1@gmail.com>
 <8a876d8f-b8d1-46c0-d969-cbabb544eb03@huaweicloud.com>
 <726fe46d-afd5-4247-86a0-14d7f0eeb3b3@gmail.com>
 <c328bc72-0143-d11c-2345-72d307920428@huaweicloud.com>
 <9275145b-3066-41e5-a971-eba219ef0d3c@gmail.com>
 <a4f9b5a2-bf83-482e-e1fe-589f9ff004a1@huaweicloud.com>
 <0ccb9479-92ac-4c8e-afdc-a1e3f14fe401@gmail.com>
In-Reply-To: <0ccb9479-92ac-4c8e-afdc-a1e3f14fe401@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/13/25 19:53, Wang Jinchao wrote:
> On 2025/6/13 17:15, Yu Kuai wrote:
>> Hi,
>>
>> 在 2025/06/12 20:21, Wang Jinchao 写道:
>>> BTW, I feel raid1_reshape can be better coding with following：
>>
>> And another hint:
>>
>> The poolinfo can be removed directly, the only other place to use it
>> is r1buf_pool, and can covert to pass in conf or &conf->raid_disks.
> Thanks, I'll review these relationships carefully before refactoring.
>>
>> Thanks,
>> Kuai
>>
> 
Hi Kuai,

After reading the related code, I’d like to discuss the possibility of 
rewriting raid1_reshape.

I am considering converting r1bio_pool to use 
mempool_create_kmalloc_pool. However, mempool_create_kmalloc_pool 
requires the element size as a parameter, but the size is calculated 
dynamically in r1bio_pool_alloc(). Because of this, I feel that 
mempool_create() may be more suitable here.

I noticed that mempool_create() was used historically and was later 
replaced by mempool_init() in commit afeee514ce7f. Using 
mempool_create() would essentially be a partial revert of that commit, 
so I’m not sure whether this is appropriate.

Regarding raid1_info and pool_info, I feel the original design might be 
more suitable for the reshape process.

The goals of raid1_reshape() are:

- Keep the array usable for as long as possible.
- Be able to restore the previous state if reshape fails.
So I think we need to follow some constraints:

- conf should not be modified before freeze_array().
- We should try to prepare everything possible before freeze_array().
- If an error occurs after freeze_array(), it must be possible to roll back.

Now, regarding the idea of rewriting raid1_info or pool_info:

Convert raid1_info using krealloc:

According to rule 1, krealloc() must be called after freeze_array(). 
According to rule 2, it should be called before freeze_array(). → So 
this approach seems to violate one of the rules.

Use conf instead of pool_info:

According to rule 1, conf->raid_disks must be modified after 
freeze_array(). According to rule 2, conf->raid_disks needs to be 
updated before calling mempool_create(), i.e., before freeze_array().
These also seem to conflict.

For now, I’m not considering rule 3, as that would make the logic even 
more complex.

I’d really appreciate your thoughts on whether this direction makes 
sense or if there’s a better approach.

Thank you for your time and guidance.
