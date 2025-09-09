Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB54350D45
	for <linux-raid@vger.kernel.org>; Tue,  9 Sep 2025 17:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757438706; cv=none; b=B0LJe05bntP/RIGZL2Mv9yLAnmJUqVG3Pe9yN7QtMWbWM99oKGTUflFNDEEOIqDCG6exwOfnobQh576F80XV3h+5m5SbT6d/3MIVzA7X4JsjePP1eW7BoOII5VOlWW3S5D/B0Jt1uzB1Z2kbqG6ONKz2SWJ4VQ/i5FTfBS4rS9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757438706; c=relaxed/simple;
	bh=GxX8esyfHUOzyn1nbvdyM3kzfLY/i6mmOtX0dvajPUo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E5cMiQPeOtxK5G7qPIv5OdqKuvMqeTZFd308SyGEV79Ak/dB/dhuKWAL1y2YIayDYaGWb2Tzwueu9uLWHTqywlXjs5LQBuTbQ4UKlSIs0tBgEm5W7CYkyHoQF4dCuHRH2IEAJehJXh59mJcCIcG9aMBInXsJNBJbQi1q5ysP5UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=b2gRo43M; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="b2gRo43M"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3f664c47adbso61735245ab.2
        for <linux-raid@vger.kernel.org>; Tue, 09 Sep 2025 10:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757438703; x=1758043503; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GtJFSvBHbG4cz0l8W9N+fN70Uv12jmFund9WRET9NFQ=;
        b=b2gRo43MQFuGtER6CyJhYExnNF18pjv15zJa2fMhjM6ttIACu8D+nnnAWxwg3jJh/+
         EqNgyJnUewQhkkm/Pf3xge1gLwGWxvYM03lIcr/a1yYvutmeidVZsA5TTiFMKcsyCgjh
         dEcvSKiQYBWrymqs3ZdSDi49Jbk9R63tOftymy6gW7hHvKuf09DA/Txd3/xyjEQ9oXCn
         H7lOjocFKxveBuW1I+nBjY+obBLlQTVvWL3ZuQxZFm5zb+nGSBB+qiPgqCM2htMSw3G3
         S7gqL/c2hr6XkbgaxkWuPzAP+rp7eGLYG87gQ/owGm1hyVTaj80NcOb5A0I1RL64HARn
         NSrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757438703; x=1758043503;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GtJFSvBHbG4cz0l8W9N+fN70Uv12jmFund9WRET9NFQ=;
        b=YQRGhJACOcrlGu4xk5LeEV042G6NpDXvtPzgDzdXFYrrPKVti0q8w+FKg0Hsdq+/SU
         xqzrClivwLSv2FDLZOK8KjTnE3jnRT+f8dg+OM+r7w3k3b8S5Ii1U+7UAth7AGjeOHZS
         YXMVg0mYS5C92xJWYZfqTgZzuXMq/VlhIiTAJH15WJuP2RUNfVTUJVCva5t71n5mzIZO
         3k4s/dh0TKTwbFBOP1BYUGcoaJHt8R7P+RzrACNvf7JpeCaZFXvH5x6Un2KKP+3999bn
         L3oOut7H5cZo5PZ2kLfKYT5pC56VJPDdMuJSwA9elon6sPT1d1gbdgJR03bt4y12OMYd
         mO+g==
X-Forwarded-Encrypted: i=1; AJvYcCUuOEdKFXF95cRz8GFirqEXx7s5LF9/lhKxbnyHe3qEuBCP+FgaKhMh9OT2P8/QdG3ca4Y2g6RE7ngN@vger.kernel.org
X-Gm-Message-State: AOJu0YzrW6OXxhzMRZxS8YcpZSOEfMjjPH2uEgkctRokkHRyzjor6N7w
	LWrkUcr4geL7hy/CXH67cnIGioDmjYLVl2HWYF/RjDewFyEoWsR3V3FlQdu5q4Vw/QYmqRHcu8e
	+E5xV
X-Gm-Gg: ASbGncsO3cxfefzTl+3y42r+hFYL6Ly6gNRd4EX2sEmMRVuyPt6RsFZiOtfj3lGSHUK
	2hUB15v3ie5tTjjzoihCndPNryYWO/fdNc722Hh8QNW86ERKXHMq4+HVzotO4VnhHbbPXHxfV8M
	+RFWJ8UW2eNaWhS7NVmpjSqr+DauniOwUh8NonVC7ZvK5Y6Q/s5xT0hU9qXdIjM7W9e/cDbcIFI
	onRn4izalE5FGOpp+lYq/vaK04CTHaOr3aiLMWczKy3HBSa4k8A/yLdbtLWmZfdGfjnTuKncOHC
	xf2Yfzh+KVnvCYhUApGrliVIH8/sOEtVdDJCB3b8hqOK3zQoalimSvmZwEiJLZVMv3h0+zSsCMy
	uQedskjlsGxTwnjY/pxGQ8aIOFseGlQ==
X-Google-Smtp-Source: AGHT+IHw3W8XExwwEsXUvAVGW3t5lxP4OUVBcfgIYshMPU1SR0wVT5HUrtuzxi4b4jeVJvg662d+Pg==
X-Received: by 2002:a05:6e02:451a:b0:3fe:f1f4:77b2 with SMTP id e9e14a558f8ab-3fef1f4788emr155227595ab.5.1757438703279;
        Tue, 09 Sep 2025 10:25:03 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50d8f0f020csm9796359173.29.2025.09.09.10.25.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 10:25:02 -0700 (PDT)
Message-ID: <dc6a5862-547e-446e-a444-53b105ab00cb@kernel.dk>
Date: Tue, 9 Sep 2025 11:25:02 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL v2] md-6.18-20250909
To: Yu Kuai <yukuai@kernel.org>, linux-block@vger.kernel.org,
 linux-raid@vger.kernel.org
Cc: linan122@huawei.com, xni@redhat.com, colyli@kernel.org,
 yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250909171328.2691074-1-yukuai@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250909171328.2691074-1-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/9/25 11:13 AM, Yu Kuai wrote:
> Hi, Jens
> 
> Redundant data is used to enhance data fault tolerance, and the storage
> method for redundant data vary depending on the RAID levels. And it's
> important to maintain the consistency of redundant data.
> 
> Bitmap is used to record which data blocks have been synchronized and which
> ones need to be resynchronized or recovered. Each bit in the bitmap
> represents a segment of data in the array. When a bit is set, it indicates
> that the multiple redundant copies of that data segment may not be
> consistent. Data synchronization can be performed based on the bitmap after
> power failure or readding a disk. If there is no bitmap, a full disk
> synchronization is required.
> 
> Due to known performance issues with md-bitmap and the unreasonable
> implementations:
> 
>  - self-managed IO submitting like filemap_write_page();
>  - global spin_lock
>  - ...
> 
> I have decided not to continue optimizing based on the current bitmap
> implementation, this new bitmap is invented without locking from IO fast
> path and can be used with fast disks.
> 
> Key features for the new bitmap:
>  - IO fastpath is lockless, if user issues lots of write IO to the same
>    bitmap bit in a short time, only the first write has additional 
>    overhead to update bitmap bit, no additional overhead for the following
>    writes;
>  - support only resync or recover written data, means in the case creating
>    new array or replacing with a new disk, there is no need to do a full
>    disk resync/recovery;

Much better! Though I suspect you forgot to add more where you have
the "..." above, I just removed it.

Pulled, thanks.

-- 
Jens Axboe
