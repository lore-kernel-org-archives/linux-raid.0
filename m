Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47D3274FD3
	for <linux-raid@vger.kernel.org>; Wed, 17 Dec 2025 07:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765956328; cv=none; b=stNUDYIT/UoUKUpSSVznjyXQ5fsdbkE3SZP9cjxF1UHe67QUW8GaabonqwyjgXda3lACYhZh9AvQ1LbPDF2wnuU9oWdmoOORuiPez/QhyvAoQX5Mz4kMDd5a9S3hbp/lihTQhyq/0Jf++UWsQejoDLeJAS4d32hw2yCw5FfnIGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765956328; c=relaxed/simple;
	bh=LWwwt93TCYNdOdrr+76ZXtaQ7I2Uj2REk7tjPmXx3io=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Gks8EMe9rEV5sjoYyVFT8DwvDNR3UDPQOuZ992HZ+Z4017ezH7FpzVm7J7h7je0rC0AVo4TpbVP8fckU8IRl+Ic4W1l9Ghexn/gb28Qz8kfeghqD+AeLUyYpKwYvG7mU5uKso0YLHwXd/PTpzrCZehxRL5Ym9EuhCDkepDX7TBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M1HlJnpR; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M1HlJnpR"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4779aa4f928so65425475e9.1
        for <linux-raid@vger.kernel.org>; Tue, 16 Dec 2025 23:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765956325; x=1766561125; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LWwwt93TCYNdOdrr+76ZXtaQ7I2Uj2REk7tjPmXx3io=;
        b=M1HlJnpRSeT48XPl8lVAFoVfYXJIHpNiJ+rOnHTdR8omW1iPUpVcsEfRSXFhNHdxNe
         y/pffaZosYkqbXfb0DVo3+JMU/JlzcUHfkWVLBBuF/aLgErh21MJt3C/ieQx67ayoCb8
         PrfDqZ8dOQV4M09KKonHpVMAmbuk9dYMHl8hn7CSOYM3NLa8keXoqBoazPzzOFCuK/Ob
         s+dJ7CEkHVeWPwm2I/5g3RHrS/u04Djnxa9EsxSXbnGK4frjNGWD6zY1H6zukMbkLVAh
         wOlTEM2MhqpE49SbIWczXv5ICzkBci7dAzvYYsHCQytmxeVWn5nt4Q6g/39w3GN+zTZg
         oDVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765956325; x=1766561125;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LWwwt93TCYNdOdrr+76ZXtaQ7I2Uj2REk7tjPmXx3io=;
        b=kMsFQ0HiKnAUKJTRrinsE/iEqxkiLh84sFAPnxg3OSk270k5P5k868aktJlaqN5yt6
         a9iBtdVNqX417jye6PNkaIWEMx1PCaciyvqiSv9+g8WZYGJuLjurrYMJRI/zSItbALUO
         Rl/pM6hqh/FS7XYIc1iDuLp99MBYyuDsKiAG8heJ4qF/VUYJfqWIpC1s5wYUy1msaTaY
         5OwANOMgkTvhhRZFW3p/cIX4J13vpdYZhE63pkdm+jNNMg1L36zsmFlBjvOhmV/ZSaZc
         COSvCRQQhuNl2IizMCVumNOJPnBerkZIrVHuKc3nfzzQukFjX8qCz/sBflHpHMK86Lpn
         7ZTw==
X-Forwarded-Encrypted: i=1; AJvYcCXBW3yg3V8YKWMghBmg0Eejz3vk3uBMhbXfMvAVPMJWuPkw+NjQ9OKM/dioxnMKsncSqHTd1PJAJk2r@vger.kernel.org
X-Gm-Message-State: AOJu0Yw30uhF7CIGWxWxPqVIKb6bu7MkJIXVUiG/FQU14k9+IVs2jeOc
	QOIZI/TrpFc5bJ/yZFrQr92eVCJ55duW1Hm0+7C5JCyNLYtrnjOa49GQ
X-Gm-Gg: AY/fxX6KQDiHsXVdEbFRLZ5giyj4mGluz015/QqfLDcscH4mTudlgnlKHtPyfdZoQtB
	tBAPjCLaHij5sU2jIGOgvgBLmG77QFGqUL9sUUkoUB/P6rFhju+78DNvWM8RRMaF3e2q80h28c/
	msx8K0nIIy72mxGDRqZx+mC/JXk+1tTpJrc0iCbpUn3nOgwQzSL0NSKdRwX6y5yjJ0jT83oseOz
	LLVUpr0dkqKKReqqioWFuni1bR0gXLfVmcJ3J0ALZ4Uxn5Vk7JBkJKbViiQ4YoAoU4NjLb2zOZI
	KVhxYhx9CaIXa/r+v4S+yZMR6Ffyy9lxpHTTRzoFyMS3XdQOZ5BnHOznVm7Ia1R+2efLqdYsJQ7
	j6fS29Wf3DS0OSXABSZ6cEavOpy5mAzm32fJ4zrKsf5y2UzomANfVo/DVsmoQVGyDU0skIfBs+M
	TAv55wXttwYxJYSSs/mf5WdGUx9CuyV6D+kKBmy3fzFyw0Xlj+4uQ=
X-Google-Smtp-Source: AGHT+IHOP0kAWL72l973qtw6uQIzjlD4F0jgYf62VV4mOXzGmirQ3J2QTTyJfzP7+H8QI/lL2NcM3A==
X-Received: by 2002:a05:600c:1e0d:b0:477:54cd:2030 with SMTP id 5b1f17b1804b1-47a8f903c68mr180145825e9.21.1765956324879;
        Tue, 16 Dec 2025 23:25:24 -0800 (PST)
Received: from [192.168.179.27] (p57afaeaa.dip0.t-ipconnect.de. [87.175.174.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4310ada818dsm3293204f8f.8.2025.12.16.23.25.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Dec 2025 23:25:24 -0800 (PST)
Message-ID: <2d9aa651-93b6-407c-b7a1-092e454134bf@gmail.com>
Date: Wed, 17 Dec 2025 08:25:24 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Issues with md raid 1 on kernel 6.18 after booting kernel 6.19rc1
 once
To: yukuai@fnnas.com, linux-raid@vger.kernel.org, linan122@huawei.com,
 xni@redhat.com
References: <b3e941b0-38d1-4809-a386-34659a20415e@gmail.com>
 <8fd97a33-eb5a-4c88-ac8a-bfa1dd2ced61@fnnas.com>
 <619a9b00-43dd-4897-8bb0-9ff29a760f52@gmail.com>
 <f20c3a92-d562-4ac2-98b6-39ff4f3e3bbf@fnnas.com>
Content-Language: en-US
From: BugReports <bugreports61@gmail.com>
In-Reply-To: <f20c3a92-d562-4ac2-98b6-39ff4f3e3bbf@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

many thx for the clarification cause that makes a huge diff !

Br

Am 17.12.25 um 08:17 schrieb Yu Kuai:
> Hi,
>
> 在 2025/12/17 15:13, BugReports 写道:
>> ...
>>
>> We'll have to backport following patch into old kernels to make new
>> arrays to assemble in old
>> kernels.
>>
>> ....
>>
>>
>> The md array which i am talking about was not created with kernel
>> 6.19, it was created sometime in 2024.
>>
>> It was just used in kernel 6.19 and that broke compatibility with my
>> 6.18 kernel.
> I know, I mean any array that is created or assembled in new kernels will now have
> lsb field stored in metadata. This field is not defined in old kernels and that's why
> array can't assembled in old kernels, due to unknown metadata.
>
> This is what we have to do for new features, and we're planning to avoid the forward
> compatibility issue with the above patch that I mentioned.
>
