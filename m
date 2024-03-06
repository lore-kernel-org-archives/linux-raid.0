Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004371350C6
	for <linux-raid@vger.kernel.org>; Wed,  6 Mar 2024 15:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709738947; cv=none; b=HH8/9R7O/OFlzOkyeYPj6mVEmUodH6oo4lJ99HASDJc1+9+szunBiOvqgYHsGLwcLmdIIThExwc3056QrMxoojXJTJPY0X9j7GG8AxQBwX78bDo7hcyzRlOtZ0Ezc+fsRYwzwBw7lbiN9th07E3k64wZdgxbaSxKzsG+ejdlJ6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709738947; c=relaxed/simple;
	bh=VhXw0RGdwJ3yBwNfC77fS+QJ5ba/tqo/u1fSxdI9gVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CMeMNuiqtZDeMzfCgpLpmYrfS3O7n+r3yKVEbBX1D2124KcE0pplzcz4WQxsauU7GuQ5Z+40/+s3DBpK005rPr17mMQAaGt4MJSewG3PuV7Rd+RH6PlWa4ssPZ7q+H6NuHvrLYCdJDvMBazwACXnL3Tl4kwpgSvE3qB6d2EQVG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=r/msX1qE; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="r/msX1qE"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7c49c979b5dso102479139f.1
        for <linux-raid@vger.kernel.org>; Wed, 06 Mar 2024 07:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709738945; x=1710343745; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HuiHolB1Euh2agtRTRDo+ej1B7ApR1A/nMWa1zjFtyM=;
        b=r/msX1qE98eNF3BCBZlN83/qg4AdFr31S1+47Oegmf0qnUOgXc7IN37XyxBCBxsLEu
         WQy0l2MkTvpD3gY4OH60WwPbJz2MxbUq+diXdKwSP+r6wwtKOHw9oV1XWO18StwYOg8A
         zmEKUjANHFJkZHzpMq6cZjva2KIua7HH1bCaMA+5gYnRBkt47phA7dYem+sWaM0wLm9o
         76WJE0GqePest2mqo0hBVMcbnUK9fQY834o08I+QLZNwZ9oj/82VtwKgpKjPrVK6JWdQ
         ISSTfNCNrOGVS/NC3AjzlUVc+KMDvlLEqfsJk9eeh9FJhEzk2BwfFtM/ucyQDLkSAv+c
         NJpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709738945; x=1710343745;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HuiHolB1Euh2agtRTRDo+ej1B7ApR1A/nMWa1zjFtyM=;
        b=olLgX0nRYc9AbPep/M8aLbd90X/sZdqChglcSWU8qSogLOTNTWc9dY4SSZsAvPNC67
         /ZAhsJThY8iSjOnbw9Izx43wC5tCW55UQPgfxs/UtzXNVaXgH5FRD+7Y1/hZHT5sXevd
         vYELDd+eoVlKPJ/gpv2w+yZMr8Us88LY/1rPivmvhskRM297PKlT9G36Ctyhgkiew7Uv
         lzL6EghlzTlselQJCC7BSo0qeKi9lo5ulyk/18m1KwvgbxcDo7wMTH4aiA3KKieKxqsG
         /7iViZkT0BFn47dl5Q1N3MWB26b0wh1qMySdVOiBhnOFT1jOhc2gqmclcvHsLAuHIy8G
         /BvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYJYK1yluxN0ch3y5DoCgriEf0ZvREptnYYz9GEGX7BC9mEziZcD8gkurhvIITAQotmGI/hEpDpdr1uDINf8oFuliWCRUM359+Kw==
X-Gm-Message-State: AOJu0Yy6tykwh0RrwsUibGP0XD4uXSwSvjpl4LnWM0bZ4ZI/q42f0oAf
	y5c4ilH21LbML4rljxRJkKXGmrA9BfTIH4JyDq/YLe7xjSRR0flwqGUrKq2R/JY=
X-Google-Smtp-Source: AGHT+IFfFfT6TfzD8hpsFF9DRyNIvUMsP7yklx651z5MiIECpjaDta7a2YFi5GznQsk+b7UFUUVBlQ==
X-Received: by 2002:a5d:990c:0:b0:7c8:789b:b3d8 with SMTP id x12-20020a5d990c000000b007c8789bb3d8mr1868870iol.0.1709738945072;
        Wed, 06 Mar 2024 07:29:05 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z20-20020a056638241400b00474e0c312acsm2291532jat.49.2024.03.06.07.29.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 07:29:04 -0800 (PST)
Message-ID: <b4731092-7028-4852-8186-5bc805bd1ba6@kernel.dk>
Date: Wed, 6 Mar 2024 08:29:03 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.9 20240305
Content-Language: en-US
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Cc: Xiao Ni <xni@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Junxiao Bi <junxiao.bi@oracle.com>,
 Dan Moulding <dan@danm.net>, Song Liu <song@kernel.org>
References: <1C22EE73-62D9-43B0-B1A2-2D3B95F774AC@fb.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1C22EE73-62D9-43B0-B1A2-2D3B95F774AC@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/5/24 4:42 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fixes for md-6.9 on top of your 
> for-6.9/block branch. This set fixes two issues:
> 
> 1. dmraid regression since 6.7 kernels. This issue was initially 
>   reported in [1]. This set of fix has been reviewed and tested by
>   md and dm folks. 
> 
> 2. raid5 hang since 6.7 kernel, reported in [2]. We haven't got a 
>   better fix for this issue yet. This revert is a workaround. It has
>   been applied to 6.7 stable kernels [3], and proved to be affective.
>   We will look more into this issue for a better fix. 
> 
> Note: Some recent fixes were shipped via the md-6.8 branch, so the 
> md-6.9 branch doesn't have all the fixes. I tested that there is no 
> conflict between these fixes and those shipped earlier. I run the 
> tests with upstream kernel and changes in block tree and md tree 
> (v6.8-rc7 + for-6.9/block + md-6.9).

Pulled, thanks.

-- 
Jens Axboe


