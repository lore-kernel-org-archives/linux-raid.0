Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B136E1DF273
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 18:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731004059; cv=none; b=S/zWMHNG/604ouOTix76C4tVvVUo0bOE2f/88fhp5+FSpxsDBz3jOCsdNroHODkrDVR3LJUmNKy+JH83fn7rb+IWhSBX49FNO4EKtMDUdDQ438HIlhBTyn6L92cHuFfSJISGN3YcD/gnJCF7xCTUt2sDRkDy5TEJnbz9IeritS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731004059; c=relaxed/simple;
	bh=20LrKDdXKwohLrR7m/+QaoGSjbWanGlIA0WTQG1VuBE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YLYvVX2ScsbkQeFjpPBno7KDjfgFPtKXLkye9TsXF1djdX31fJptRb23Xf4QCqcgCerNTkFXcqmv4peG3FwLCEkViQRaMjLc6xOxbwAFxevL40xxAGM/semGKBk6iT+FqwGW5J3tOG+gGuNFg31crm8pRdO0gdGjeB3A+GdIPSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gjT+5qAO; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gjT+5qAO"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-290ff24354dso644219fac.0
        for <linux-raid@vger.kernel.org>; Thu, 07 Nov 2024 10:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731004057; x=1731608857; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uVnaoenE/nrPuz7L1JcnZlXT27mO9irch1BC/+wWZcY=;
        b=gjT+5qAOs6q+hOnTQLfvkunfI2tkPZ9VwKkZIDzUu2L0pYWahtTs8cwco7Pf2qe0sM
         mx7+dQaKkcwEpx6cq6+3VeVOJgBThU4Yx0TSL2CvOI1xNLYjl7oikVhmSCFNKyTj5MFw
         VU6z8LSL4lMtVha4IyXb41aT1LcvQ+f87OsIUlRpX43S3z6sUSEHOv+ghc7ggObIx/z7
         wdPRKnNx9coOdSrl3Tzg8OkeqYwpVoLsbNOBDbfsogk0/txzNVM8gIGT/Q555/+CUb4x
         1Cz9CkvESPRyz5SHYrUNKMbstSRlUI14EKnIpG0MbYqt4+D2j1cBUF19sl+L4spzDyxY
         q/rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731004057; x=1731608857;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uVnaoenE/nrPuz7L1JcnZlXT27mO9irch1BC/+wWZcY=;
        b=sYxjf6/7skAshdhc8BDf/DetyTvOeOYOd83DL8/s+gQ9azZqUQF+nX8rYkLqYaipQZ
         r056uEaNqCFmqLuAKj2UTpHyEkKuevEUGq/xEOLRtQu4SnB3ZytoPBk4eR5U2rvyBdwp
         w2qJmw/Swh1pMKnefmFb7P8E8FB0c2TD0ZeFR+RqE5rpDIDrhP+eN3Oi4fnQIRFutJdO
         L7t1BREH3P0tcbkh5CJLb2ifAgOxs9OGy1vjC3v+W+NR9VLbkYwFIOiZVx5Xl2FhyEh+
         /6QVCyi58t45vGEu0jT3ObiCwBXmRiOf+tTPDaxuqkMPtdjyD2oKeXdTwqUPItHbXO94
         O7lg==
X-Forwarded-Encrypted: i=1; AJvYcCXVpTcha1WhfN7cEGvDSmAd8H0rz93ZZhuLaroRtucmPYbHHZfFmuiVGZInfOV17TcqQhDzxlDDGPTr@vger.kernel.org
X-Gm-Message-State: AOJu0Yww91E7vx20zy2TIiio8wghbgSKxdk5mt3dHeiIX86H0xn4qBvO
	VzTQeD3TOtMBjxJNaMVmJjgDuFIohmNn56bqGkaVzbgsBnO/KozJy08YMyejZk4=
X-Google-Smtp-Source: AGHT+IHmQOgwVXtosc5C3zjOqsrNAr1v/lfSp7QNRqpm1iXYwNBCmnKvsMh+W3pIhyccXko0ObQGvA==
X-Received: by 2002:a05:6871:5891:b0:288:59d3:2a03 with SMTP id 586e51a60fabf-2949f07a886mr21485563fac.39.1731004056679;
        Thu, 07 Nov 2024 10:27:36 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-29546f3f58dsm490090fac.49.2024.11.07.10.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2024 10:27:35 -0800 (PST)
Message-ID: <26049689-238e-4f04-9a68-db002ed5c1e0@kernel.dk>
Date: Thu, 7 Nov 2024 11:27:34 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] bio_split() error handling rework
To: John Garry <john.g.garry@oracle.com>, song@kernel.org,
 yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
 Johannes.Thumshirn@wdc.com
References: <20241031095918.99964-1-john.g.garry@oracle.com>
 <e0a82859-6c9e-43d4-b6ee-4b96fa193fa9@oracle.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e0a82859-6c9e-43d4-b6ee-4b96fa193fa9@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/24 11:49 PM, John Garry wrote:
> On 31/10/2024 09:59, John Garry wrote:
> 
> Hi Jens,
> 
> Could you kindly consider picking up this series via the block tree?
> 
> Please note that the raid 0/1/10 atomic write support in https://lore.kernel.org/linux-block/20241101144616.497602-1-john.g.garry@oracle.com/ depends on this series, so maybe you would also be willing to pick that one up (when it's fully reviewed). Or create a branch with all the block changes, like which was done for the atomic writes XFS support.

The series doesn't apply to for-6.13/block - the 3rd patch for bio
splitting conflicts with:

commit b35243a447b9fe6457fa8e1352152b818436ba5a
Author: Christoph Hellwig <hch@lst.de>
Date:   Mon Aug 26 19:37:54 2024 +0200

    block: rework bio splitting

which was in long before for-6.13/block, which it's supposed to be based
on?

Please double check and resend a v4.

-- 
Jens Axboe
