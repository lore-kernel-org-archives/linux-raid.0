Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5431293C78;
	Wed, 18 Jun 2025 11:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750247239; cv=none; b=YXclgjEQg9lMCDaZosBRRWPrqPnQIkwCfVsEukRHlg3psvHKgNlqW23Lto82rel7cuy0LbC9CCrQBzG/DDb8T9snYpb806GTZm6ujOD8TcPSm3/1QYUfYsrOshKbCoxxQ9Cgxam2Iqd2042yryxulEZ5qMbxN/gXAgfM96zOgQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750247239; c=relaxed/simple;
	bh=e9U0n3o6Pcz4xU0TkYwH6TgkEelJaXWWf/uNPsoHr0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eTesnnMgJsf8+j65oQY82A1F67KqsegWVo9ivzuYSOA3I7YYdJR7vJosmSz7oucdtmhmJPqLpGev6MSyi4Q1sid4CQ6tKhjlHrLfZK5x0AqUmEkxivGAzBOiPMf2mif0rC8dsSc/eSpZtga9EQxFd7iBdu3LkvMmh5pdCL64YM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kmgZ7zvT; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kmgZ7zvT"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b26df8f44e6so7441085a12.2;
        Wed, 18 Jun 2025 04:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750247237; x=1750852037; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FQfwPBYxs3p+u6aXaKNnP0EG9aszC5zPogIUvJ9ZXbY=;
        b=kmgZ7zvTxuyJm7pITWbzf9CdwgAAcSCr172l/8RMAxyWsZP5h6OsGBscRKsujbwU6P
         lFn9pXpCZCiTTqaCNok+XC41/wICpr7LKqmnAeWKnnD1WY3J1tynXJODM26E4H9I9LoJ
         K6NMI8iAtkolRBpT5bScjUz3GGoMgaJntmSleawZOh74ZO9YS3K9b+Iis1bxmLYzuFaN
         CGYwooDx7FIG26B+xUhsX0AoB5STfyeY1f+B/xsqzR3gya2t+zTcSC4STbSADaBxIAeY
         gLdk8QynBW8oUCmRRrsyOpmY+UZeX7B9RbxnwsOPt3sbf3Qxgc/6z3B8Xz6vPxrxVfEk
         RzQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750247237; x=1750852037;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FQfwPBYxs3p+u6aXaKNnP0EG9aszC5zPogIUvJ9ZXbY=;
        b=OfV49KMLk0092b8f11jfy4jLIJu5pOCG7q4xJHRJWD/ab4SbZJu0h1yCO+dqZNE3V0
         NMyhFLQNSmltMKV3/WaEL8WGEIBa+W6QZoOPpaTV2C4dflEcCd0r4wLcnzDXEzGBhB8+
         ioKgpjJSOoVUEDy58jmnXkwgRZb8B5Gq2Ff02Hx7885acLxSgjjgsCh+8qRF1LGt3hf1
         ZLOIa0zDffbkefMe2CHkl3g6JKDSgZnQ4nMb7qUt0j9mcMMyEIQzhnm2XOlfabNTUC0w
         481c4oGB1QK1lwtWcj3TJ/Kij6jF3iLGUMA75w2haCuHk2wRHn3oybl58Agh4oDHmPhA
         iIkw==
X-Forwarded-Encrypted: i=1; AJvYcCVVSGWRgoloICh4PHXubtQ+Cm8e24tDs3pOtwSVWXh1aGPuPTn7uMBwlARUjWVkiuurHFf6MxlXb8ver8c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxufyFh+zpkWrSB1s1ZQpTO+TmNYjbYAeB4q49IYuphG/Mu3VpK
	Un9O+wn+Aa02dlxT5jd1wY2ZUTySH2cKRYwkQRFRp5k/Fiuww4l3B1zg
X-Gm-Gg: ASbGnctLHGoqw1SXdepC3OCemCI450FH8Da+XyOtcHic75vscL7UQMWAYbDkvXOgUoe
	YMvMhOCMiHW+F7NAhiPiei4/89jromcJpbRyjEesh1Mey+itE/qqR1a+6vH3U5mDlctFQNaAQND
	h5KXmq6Z0NqwDUa14TT29RhclliC9sUYkTU3/M+livlP1G9zGyhyaK+LYbTBDvr7myK8wMe6oqC
	z9Du/FzV/OItJ5kaNxcDeOimeoG2MNuZ4+UZ2u16jcMgVYx+lvZl/DkpnhIB2iljsL8xxIaqXx/
	6bD9TDdnB3z2hvPwaOnrrxvptqNtUUy/ENlYf4yfvWhu
X-Google-Smtp-Source: AGHT+IF0uhweeaSnklYVCzHzfOVC4PIDrn4Uv4wiU4Ph2g+9+GzDQmh5vM9BoHbZraXPrfBr9NWc+A==
X-Received: by 2002:a17:90b:3a05:b0:313:62ee:45a with SMTP id 98e67ed59e1d1-313f1cd69femr24532130a91.13.1750247236929;
        Wed, 18 Jun 2025 04:47:16 -0700 (PDT)
Received: from [127.0.0.1] ([2403:2c80:6::3058])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1b595aesm14097154a91.35.2025.06.18.04.47.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jun 2025 04:47:16 -0700 (PDT)
Message-ID: <d6481ddf-67e3-41ed-8ecf-d11ffdc6f4aa@gmail.com>
Date: Wed, 18 Jun 2025 19:47:13 +0800
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
 <351b7dc4-7a2c-4032-bf2c-2edaa9da9300@gmail.com>
 <d7022eb3-4dee-8d15-1018-051b882467b2@huaweicloud.com>
From: Wang Jinchao <wangjinchao600@gmail.com>
In-Reply-To: <d7022eb3-4dee-8d15-1018-051b882467b2@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/16/25 19:32, Yu Kuai wrote:
> Hi,
> 
> 在 2025/06/16 18:11, Wang Jinchao 写道:
>> On 6/13/25 19:53, Wang Jinchao wrote:
>>> On 2025/6/13 17:15, Yu Kuai wrote:
>>>> Hi,
>>>>
>>>> 在 2025/06/12 20:21, Wang Jinchao 写道:
>>>>> BTW, I feel raid1_reshape can be better coding with following：
>>>>
>>>> And another hint:
>>>>
>>>> The poolinfo can be removed directly, the only other place to use it
>>>> is r1buf_pool, and can covert to pass in conf or &conf->raid_disks.
>>> Thanks, I'll review these relationships carefully before refactoring.
>>>>
>>>> Thanks,
>>>> Kuai
>>>>
Hi,
I’ve changed r1bio_pool to a pointer type and sent the patch.
As for the other two optimization suggestions, I found it challenging
to implement proper error rollback after the changes.
I tried a few times but couldn't come up with code I’m happy with,
so I’ve decided to put it on hold for now.

Thanks for your guidance.
>> .
>>
> 

