Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A6220FABB
	for <linux-raid@vger.kernel.org>; Fri, 10 Jan 2025 14:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736520878; cv=none; b=CV09cFgKmvb4GHMUoz8f+MnP2VEWbjI4OddAy1eYJ7Xqslv84/ZZ/Cxo5QDGCer5WYXfnk8ckfjYwKKrpyJSgB2HvUoP+kxtGLt+utW2pnAAlYnLFz8JlT6Je5Uc6hkVF5I8/EKdh/fHGVrdCJMH44mt3BH9jPaT/zA4Engq/Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736520878; c=relaxed/simple;
	bh=V9JKbIN+rgKaNyPPYRN8+IxQwa4zyAmZy7gxY8kzsLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rjuDXzTHgHvl/psJiupei26dOp6x8bW16CUMV9wNk1YU3DPmpdJ8WTCbz19LF4PKq8DcNOjhzBe79Rcj9ciMwuFMHtfwRSOAeJha+5aFtw6r/sX+7sD90Bmv2bQsMwuvzblBPhoagThh1Rhy9MHiu3SWXkpBVu5Z9eAUsfJ8onE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zIt1YV9P; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zIt1YV9P"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3c6b0be237cso15347405ab.2
        for <linux-raid@vger.kernel.org>; Fri, 10 Jan 2025 06:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736520875; x=1737125675; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OsFg65yV9fg1igYopJhB4Bs2VMnos1TTWuKh2SUiboE=;
        b=zIt1YV9PeSgvR3lfMiqTjCufZiXMw/KFBRhVNYcDeeSJX5vQsJQ1UNXgDNN5hGa7of
         FJ5ziL3PDzh9FHj1DnM9ZrXMDg2MmYVCftvDsMCsE7ePlczlL2S3y660EO1zFhWGs5JG
         XfZW4Zl21NYawJkSK+G9GNtTb/IZwp9/AIzM63cLHEfeT4o3JvWLOO7MCX6bbmTrA+NR
         zk+1Og5/61UYsOxkthayi+teYPFECMP5Pekq4P5Mhc4mw+F+jHF5vm85JkmP0RaX3gOV
         D1mPp/Rx6aPDHSw+JM5w4C/NSMD2K5rji7Ta133AD+YVHl7U7KRh6Y+ebf20IvUjuiB1
         kF/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736520875; x=1737125675;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OsFg65yV9fg1igYopJhB4Bs2VMnos1TTWuKh2SUiboE=;
        b=N2tXTpyEtEyu/quQaBXzW3uerXcip2079aOP5SUB778ZIZYC9nB6NfJgCogDubkBZA
         /JN4bhdlKG/aeamG4SMBQ+HErYfi5BgYgWCdymZNv2mOLSWLgNTYyvg41DlK+RHV1jDw
         V1EHBVl+qi+i9ykRJR25MsUriN29VIFuDsPkrGz3UO2GOUO5E35Ol51HLJuPRoGVyUQ0
         yKzxDxUyvuwCc33xpSpuxLqsT89zQK7zhAXvurpTGkCuitDpAb9qYD+gqwxHuCX6PCWV
         xvzoqq3qHsCFwipYc7XJ0Zl5T6gHTXIQ/6mW1WQIXAAGHznpqFUb3i5clnM1ZZnYyjwF
         /MEA==
X-Forwarded-Encrypted: i=1; AJvYcCV3kkg1iUCOAAmXB93j51oJ7u7vvn6CYXZRxh7cXOCrVk0ET/2nIDUrX7foQITWAiMoOvzOgEdQM1DC@vger.kernel.org
X-Gm-Message-State: AOJu0YyA2sQeY+6mNIONJ3YeTdoUUArQcYrXzs08dhQAm+sSwrxc23LQ
	A3WUpagMT9X4UdprB7nqiRSYgXufoFXH0+lRjIH1Ac6w9YooQYm6DclRH8RDt1o=
X-Gm-Gg: ASbGncuI19eFbqZYOh/CP7sz8v+iuIhhiefQkISbRfVdM+rSQRlfdh+CvPZXOV2Tele
	MLMTpQsUPzibCaF0n2afUrOXwzXhM6SIymvo05CK459WXJdzMNPrs9jffokIHphCT6qATrXs9+O
	DYgbnvOEzF426JP18TtPo8hAQsydmtlyBZizJBv4Wc40g2gby3Yk9BUIIeb8SheBIeADe68FvCg
	D04ud+LF7Af4vRMbCbaip1BJ/kzZ88W5J4YGxBrceUp77afWldY
X-Google-Smtp-Source: AGHT+IHPSkNgfbOXRJqYty2Q3bBhdigFw3g2DWV+a/jyZ4Y/wSufKLgaSKRA467ajZZwAIXkMYL0DQ==
X-Received: by 2002:a05:6e02:3891:b0:3a7:4826:b057 with SMTP id e9e14a558f8ab-3ce3a9669c8mr96249625ab.21.1736520875134;
        Fri, 10 Jan 2025 06:54:35 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b718433sm917630173.109.2025.01.10.06.54.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 06:54:34 -0800 (PST)
Message-ID: <f84fa2ae-cabd-4211-b0ab-f3aa6c905b3f@kernel.dk>
Date: Fri, 10 Jan 2025 07:54:33 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.14 20250109
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
 Song Liu <song@kernel.org>, David Reaver <me@davidreaver.com>
References: <4A41A8E1-FF2C-405C-8BAD-DA2157E3CDCA@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4A41A8E1-FF2C-405C-8BAD-DA2157E3CDCA@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/9/25 12:14 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-6.14 on top of your
> for-6.14/block branch. Major changes in this set are:
> 
> 1. Reintroduce md-linear, by Yu Kuai.
> 2. md-bitmap refactor and fix, by Yu Kuai.
> 3. Replace kmap_atomic with kmap_local_page, by David Reaver. 

Pulled, thanks.

-- 
Jens Axboe

