Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408EA344052
	for <linux-raid@vger.kernel.org>; Thu, 18 Dec 2025 16:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766073868; cv=none; b=sCODDC+bEYxSCaLRegl4m2AV07avPE8RJvYnF0MvUaUrnw5gXHdMXx948VL719x3Wo/aNn9gZcgE8/Za+OcivGfXM6KWCQfzo7Q2S7CuCu8bGSZ2ErEWY6DPCUtY7ObXPxcbhZUVC36hYTnZjorJehfZiEPz9rDNUCjYfFda+Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766073868; c=relaxed/simple;
	bh=BCA/SRPicRnNA+oAfbxquX6IyZHZEnY4FlyOnN7Ejyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iCTt223PGz2G+u9ZRUWTHEBkh6H5MB7g8rq/SN7eKqhS3KtJPtSHQXNj+7J81mdAznXQFYZzM/OzrXSuSaOvKN7vSdxvuUuyM7fVWukobKgyEeb9lUDFZm4ppLxfLj7ZB6f9VSpTMxGO/SoBWFxDliC2qXTXewkrh7Tn0x/lHCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fTqzMBa+; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fTqzMBa+"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso7980085e9.3
        for <linux-raid@vger.kernel.org>; Thu, 18 Dec 2025 08:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766073865; x=1766678665; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sXrJAapuGYH3zPdhGB6sw2F//XRVsqFBb0KTrc2NmCI=;
        b=fTqzMBa+bq0Itkv2gHCFeDqt9uD98diRSu48icdfzB2pRyUxC/DLQZgp+GVZtJB47b
         PHBlWX88U1w9vAQj/U04Ed/qKyoaR1Ml4lhfJYJD9RD+qhUaJUXgCK4LMMpNLCinlXOG
         tt3k62etqg+LvCUuy8c8UEZ3JAWI7FpaknZAmMwBwnphAULcTVkoA/fBByivGZe8lehY
         GRwwKCuQyyuMVcBS0z2Uxoehfd2jnwPDpoUglFvgfcidCslyK+u9NkgeW5Y0H4njBd5Y
         1sAqgP60TmWUfs99rbkxhL0yYtoORhah5R305RF/m7wieT0vHq027htm6vbJdS2QPFee
         pVDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766073865; x=1766678665;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sXrJAapuGYH3zPdhGB6sw2F//XRVsqFBb0KTrc2NmCI=;
        b=fbw7DcbInFMdpTuWSyOKAUdPQjIR9ywBaWD+832lGTW0EdhA0g3K3PlNdz7B3ODqo1
         U6G2He6n6tbikAe4ax2mr69ahJjQjq4pM1SkaB8T9OywDB3W/VayAa62dh/Ak/97Sqa4
         B0bz090/4OHYSnxBvTQJCNxmboGO8AKA4xmXQh+4tU+VnPcLvkv+zC5I0Jh7EuOHum5h
         i2sOuQponzSs4lw8fXF6npy6LQg/z0+7Tu4DSw6DAXEBKIxZgPlFK7C4AMexJR3ipKGO
         xLt9hoK5pLkvbVYFHWEOX9R0azsYl0xKGhlobt0YFlcGorKWuQyZsttS+gTvlQmR6Rx6
         QLog==
X-Forwarded-Encrypted: i=1; AJvYcCWyG2eARtKdiUWFhqABX65KxW1djvVjp9gxHFgxj9QMlQ3+ybhelQWY6uHpnTZyrZeyP0ljzDyUaZ1E@vger.kernel.org
X-Gm-Message-State: AOJu0YxyX6rM9D3llZFf/5hDIqjcQ5cDiB4U5r8iTSDcg2QyxFz6Q585
	TxUapAu5u4jX8vPPA0P3OtwM2+CbYUCFKNWQDfFf+1Fs4nJtuvsr16xx2F0etg==
X-Gm-Gg: AY/fxX71USAFksf69z9tGO77xZsmka7iQuwLXI3kPhqFGmRK0OmX0OJ6M/tzyfA3+B/
	zqN/ZD7/hTxf0nqD9nxu0w9A/lS8Pgoc+DyiRa0MLQsBDHV9jMfmDFW8irlkjwkFlwXEJ7BGKHS
	ZwOyFhax8zhoJbJJUVmFKrNXD8FeqPdDI/g8WyLtlvo4xNskOLw3nqcdJyysdqtSYWD9pFhC6F+
	cFr1R61O/3kVRSoEuDPuTTdVdC39VfK28cAB+pcuiUoRludtBoaecuy4gGWYKUJyFrVGTrjWtdj
	dNYCtv9q/KT4dLcmzCT3INPiZBqD+v5PeFcofTmj46MNKQyD0aXXS2HF9/axw1mR3jpPrz1poJv
	CHp24Z1gpDPZSL0JcGgostxep/dgoTA9jlrIXZjdj9TE0wYII7W4qPWwbExMIE6E0LGkCit5PFS
	7M4Kz1Bm871iCrvxt4QAFGC67UVKT/s53GAEm4qO7aRg10AvfrbIY=
X-Google-Smtp-Source: AGHT+IFrhoEmMKFNLrc5CgdQ7lVsD1v0NVri5T2Yf/L7/w5uyH1B9swqGR8QKmXS8ijPo4W1b2XW2Q==
X-Received: by 2002:a05:600c:3f08:b0:477:58af:a91d with SMTP id 5b1f17b1804b1-47bdd99b2femr65349565e9.5.1766073865239;
        Thu, 18 Dec 2025 08:04:25 -0800 (PST)
Received: from [192.168.179.27] (p57afa6c3.dip0.t-ipconnect.de. [87.175.166.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be26a81b6sm51772955e9.0.2025.12.18.08.04.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Dec 2025 08:04:24 -0800 (PST)
Message-ID: <abd640b6-6b14-4752-80ca-242fca19fe47@gmail.com>
Date: Thu, 18 Dec 2025 17:04:23 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Issues with md raid 1 on kernel 6.18 after booting kernel 6.19rc1
 once
To: Li Nan <linan666@huaweicloud.com>, yukuai@fnnas.com,
 linux-raid@vger.kernel.org, xni@redhat.com
References: <b3e941b0-38d1-4809-a386-34659a20415e@gmail.com>
 <8fd97a33-eb5a-4c88-ac8a-bfa1dd2ced61@fnnas.com>
 <825e532d-d1e1-44bb-5581-692b7c091796@huaweicloud.com>
 <af9b7a8e-be62-4b5a-8262-8db2f8494977@gmail.com>
 <c6389212-3651-c85a-a713-693351aaf690@huaweicloud.com>
Content-Language: en-US
From: BugReports <bugreports61@gmail.com>
In-Reply-To: <c6389212-3651-c85a-a713-693351aaf690@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

ok, so no easy way back for me to the original state sadly.

The patch for 6.18 here: 
https://lore.kernel.org/stable/20251217130513.2706844-1-linan666@huaweicloud.com/T/#u

has the following in:

+ memcmp(sb->pad3, sb->pad3+1, sizeof(sb->pad3) - sizeof(sb->pad3[1]))) 
{ + pr_warn("Some padding is non-zero on %pg, might be a new feature\n", 
+ rdev->bdev); + if (check_new_feature) + return -EINVAL; + 
pr_warn("check_new_feature is disabled, data corruption possible\n"); + }

Data corruption (especially the one happening in the background without 
noticing) would be the worst case.

So is it really safe to use that patch+module option with my modified md 
raid  on kernel 6.18 (can easily apply the patch on my 6.18 kernel) ?

Br

Am 18.12.25 um 15:54 schrieb Li Nan:
>
>
> 在 2025/12/18 18:41, Bugreports61 写道:
>> Hi,
>>
>>
>> reading the threads it was now decided that only newly created arrays 
>> will get the lbs adjustment and patches to make it work on older 
>> kernels will not happen:
>>
>>
>> How do i get back my md raid1 to a state which makes it usable again 
>> on older kernels ?
>>
>> Is it  safe to simply mdadm --create --assume-clean /dev/mdX /sdX 
>> /sdY on kernel 6.18 to get the old superblock 1.2 information back 
>> without loosing data ?
>>
>>
>> My thx !
>>
>
> In principle, this works but remains a high-risk operation. I still
> recommend backporting this patch and add module parameters to mitigate 
> the
> risk.
>
> https://lore.kernel.org/stable/20251217130513.2706844-1-linan666@huaweicloud.com/T/#u 
>
>
> This issue will be fixed upstream soon. The patch is under validation and
> expected to be submitted tomorrow. However, the existing impact cannot be
> undone – apologies for this.
>
