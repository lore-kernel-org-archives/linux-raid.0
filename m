Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545FD224234
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 12:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782304426; cv=none; b=N0QxEtaH7j51GfAjhfO2JxnmQeCii8mjrCLnhri343oTgToXmc2U7/xs/p60lyT8omFSUzo1Hn0+i4RjdY4KxJPuvXrSlrvNhoYUSeXkkfcK5dECnA9qLlSRqPlME2K8F0W9+vCDljaPO/A4HGXY9n/aJ4JFeFd/Y3RGde/YhF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782304426; c=relaxed/simple;
	bh=sLtMKNNBxNPRoTT7i52CS+cA3UpL8EVU7zz6HmezOgM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cQvh0ijpPM0B+0OZLm4FeZAYJ7qehmbkdLlCotVlR+osSzR4702GUvgfHyXT3xEztBHDHmKovYl2ANCVfeTYILX8a4/AfV3Bg/3v7QERnDsDkPmHk3mLa9Jel7MkS/Z3/X3Rc+nATu3DdJM/83DUcEesop5fWNo4ZdrzzBdJrB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=vCTIeBQ8; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="vCTIeBQ8"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6a0a38a013eso810352eaf.0
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 05:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1782304423; x=1782909223; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rgCaZQUlPbeknSjtTTO3LBzo17VyVdrEEzXLcaDWWkM=;
        b=vCTIeBQ8VMHyy4Qr7rcvl+Y50X9SjiMg9riC03uhQfjsrmznHRFssgTDo5LOVHP5eG
         h65OlqG3++iGyJ7CWHM1qYcO/HXXDQmLUI8XXsH9XqPnvHtAFYbyscL76aRow1rvB0Qd
         ogQEKLUwsYOoahGZi6PYz09j5E3ZqeVmeASmzp9Nu0FmxETz+TZ3ZoLGLTVtr+LRr4l4
         0XERG2mx5q2TKIIOFWhxer7vtnutdyzgYCTBHn1EYEHaNxtjZwdiE5qpbyTKr+MYpAeE
         nomlmKMFHhCf44J9DSsI/8bKQyce/l4O+AImsfxTfBU4NjHLD0dk1QXoNEe5ab67Tumv
         45Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782304423; x=1782909223;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rgCaZQUlPbeknSjtTTO3LBzo17VyVdrEEzXLcaDWWkM=;
        b=hX7X8O039U6ur/vHYo2Mt5IKlRL8oiaszt3AnZaVeAXEyEWj5DpU88KDZ808kTD/iM
         KaQ/2IDT1c88Zs1ijt5+86HU/7zWRw24AJcm6nX/UYMCMgYk4O/qW78xIYI3LstvImwH
         gqbgQNYoyCokvCA/5f39Mn7BNnKAjYEJEgtvgqYIsmes71m/Z2r87TN5uOpYmmIgKjYV
         iTgOSzOD1Si1OYsWcXj6kBE5n+QYeeP9v6+NFpyQ41ZLQzPYLhkSGDS02h+1m4wPltKv
         o3qyOYlhC3f6Ktm0VAC4an5ibjVZ9t0CSATPpNVeJkHlBDATyC3vUxG9F3eXBDAo/gec
         VUpw==
X-Gm-Message-State: AOJu0YzmAokQY4lzwnUAkifEJrF1E1AjZoVLdC/Z+/zN4JHR5dL5PNoz
	a0vjFjqclFtqNvyqEmway5OMGcIhJUbF+MT/Pb/JyDbaVmhZgJlUV3Z9vqyrkhIvsFo=
X-Gm-Gg: AfdE7cnsoLYgw5Tu/X0IOjKB0bumNhNBqfI9dg8bITLASa7aLEuwFnVr5qaUotoaP55
	2tP+/0XswqvLIQepg6uDC3n+HpcgLDvmwYPtaDcI5kpz4cTnxrN/CUkBH1D0uN2qMF1LBzkcHo+
	5pS6NVugEk0Pdf06aRkzds/D570qSqNqsKt2a1PfXGzc4Ebn4aOtDvbPNwX7JluQ68RYrNLC3G2
	Gksxb9tnd2KP5iYNguauMxsy4ZoS0CLLjoVStEvjQEJ2bU0NjGnCIqfwHqIEOb9HsmrptejH1bV
	NussXXVNtEmkjHTJ8u7ZpJBAP+x3l+6pz4nfYLxg9iHwQAWXcxdkY7w5D1oeYOfXPa27FLVMB+0
	98PT10jZEIfpm2+gMr1qVnFoD4AUYxZsVKp+PVhUFrKpSkauGyoZFPNZIx7POMq0+kEfAH96J8m
	oRUz0AK3rXd4mz0ppH8pZmmk24yfYSTMX+p1kn5HQdEoAcgx1sKgk8in3iUZn4t2l/PSqyQak=
X-Received: by 2002:a05:6820:1c94:b0:69d:ecb9:4a2 with SMTP id 006d021491bc7-6a12d788b4dmr115278eaf.4.1782304423346;
        Wed, 24 Jun 2026 05:33:43 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a0e9f698ccsm8680170eaf.4.2026.06.24.05.33.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2026 05:33:42 -0700 (PDT)
Message-ID: <354f8038-e402-42d3-a706-6c1fac284e0d@kernel.dk>
Date: Wed, 24 Jun 2026 06:33:41 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-7.2-20260623
To: Yu Kuai <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
 Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
 Chen Cheng <chencheng@fnnas.com>
References: <20260623090327.1097428-1-yukuai@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260623090327.1097428-1-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/23/26 3:03 AM, Yu Kuai wrote:
> Hi Jens,
> 
> Please consider pulling the following changes into your block-7.2
> branch.
> 
> This pull request contains:
> 
> Bug Fixes:
> - Fix raid1 writes_pending and barrier reference leaks on write failures.
>   (Abd-Alrhman Masalkhi)
> - Fix raid10 writes_pending leak on write request failures.
>   (Abd-Alrhman Masalkhi)
> - Fix raid10 writes_pending and barrier reference leaks on discard failures.
>   (Abd-Alrhman Masalkhi)
> - Fix raid1 REQ_NOWAIT handling while waiting for behind writes.
>   (Abd-Alrhman Masalkhi)
> - Fix raid1 r1_bio leak when a REQ_NOWAIT retry would block.
>   (Abd-Alrhman Masalkhi)
> - Fix raid1 read-balance head_position data race. (Chen Cheng)
> - Fix raid5 stripe batch bm_seq wraparound comparison. (Chen Cheng)
> - Fix raid5 stripe batch state snapshot KCSAN noise. (Chen Cheng)
> - Fix raid5 R5_Overlap races while breaking stripe batches. (Chen Cheng)
> 
> Improvements:
> - Add raid5 discard IO accounting. (Yu Kuai)
> - Always convert raid5 llbitmap bits for discard. (Yu Kuai)
> 
> Cleanups:
> - Simplify raid1_write_request() error handling. (Abd-Alrhman Masalkhi)

Pulled, thanks.

-- 
Jens Axboe

