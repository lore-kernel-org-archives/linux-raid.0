Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C84F23BD06
	for <linux-raid@vger.kernel.org>; Sun, 22 Mar 2026 19:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774208362; cv=none; b=RC9bpi8mm89vWccZF/kCytZ1nIB0fjiu7zpjfnwYLvzGohMzIj3ZOTBihzu09xmVE/3IPyW7zzqIEQiQOHAkYFglxSM39YTe8a3HjEvSA7brQtKHgpjefczF+jZF3SpY9kdCG61OffkI996s9dgcadmaRSyGsBFd9axaow15ST8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774208362; c=relaxed/simple;
	bh=D9E6Rr8nA+FXrztt1eze3WF8u8xyh8DQ7RYxR6Fg87A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DvQEwfkpf3wbjhH/aO/JupW28FqIW3OwXNUF1M+F/0UHnkSvi75NjL3Rz/B713reaUNU14hazAWZLbamwtVa0dXxbATZyiysrkImaSgES7/tA5nlrdPhk1ga8j9WK8VgrF9qMZiO8jCenJWeIOZ3YI5FNvyX0R1sTyqE2vVTq9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=B2sl0sMJ; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="B2sl0sMJ"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d556c1a79eso3707376a34.3
        for <linux-raid@vger.kernel.org>; Sun, 22 Mar 2026 12:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774208359; x=1774813159; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C3DmNtLk1wf4jjtAROBFHuUNL5Vgccw8aS4NdR89/9E=;
        b=B2sl0sMJ/7BibgIEok2BykY2mvdYJfKd8+iIdUeHFo5SCROypn2Vpp04MQa9jAL73P
         ZBZeJ2P2F/Rk56a0gIpKgWsOB2sM9lLTIhnAnikYn4BZUmH9Vy+LI83gwLlEQIDT79Ai
         qgVz7959k70vYtbo2ec3qNwQ7uMUZP/Eyw0vp6qrye09TS5C7xnumxCcmW0Zo0yjOZln
         RTUMKtAdCyGK7+2aPLV2osASfbL6P6e5tRGXMAFJr+NZpN2vXYcCVbe3hljwn8tR7+/o
         8skZnVklC2mZYQl0f0bJMGzzDYx21MALYYhCXH8+/MkURDDXc6Iv/nTK4rVEJshhKEPC
         iPqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774208359; x=1774813159;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C3DmNtLk1wf4jjtAROBFHuUNL5Vgccw8aS4NdR89/9E=;
        b=hMfoRpSBn+ynfmA64TB6tXk2K9TMV43f3fXR8eytZ3WqXNmGBsizHSska1wUgZv2Yt
         blyofrG5IWKFsDPMARo32kWtaq3MTLGuOD+/WJPjg3lLciMkYOgUoy3hBcOSglkhqQvW
         IMKI0XEyah5ZfyeOg/Wq6TmhpT9HIWrbzaBRxubzl/Dsvc09JbLbvGMsu9MessKpAoWn
         FxajkzkHHewbw3prvy7mxGX4WQJRnweZ1Zosg3dnTI8AgwNz3+TwHalqVVOcAtrPgC/6
         YlrF8Hlz7d1Sp75l39R3onUr17KJUDpYZfgP4GD56aP1FUD4ozCRydPKCS1HBeBNgPfV
         LLnA==
X-Gm-Message-State: AOJu0YxcX9lK1C97mM1HduuVBTi3sHy4hX7r1OZJmKwsLQ/nylcCm5v5
	z3vkHwCNr41FmHu/Wt+hD1VEy+MOIh0PzJaFobTJZbay3+TO6AJ9UtkPilsu2Gt21sA=
X-Gm-Gg: ATEYQzzsD/RHBDq3nPWPXOAHRJbjQhIrnBYiiFj9BM04KOEWsgv9ClotUPAigr3RczC
	G0NNBA+boSrUjukwHnH4A4g5ym6hl/uiC/ZyWt0dS3Bh9g8me1Jrse3b3J+QuWAJ6esoJtvcmQ0
	6fdS66GGG6Pgwi15tGysjQwuNi9ljDAhikiaJdVbUMRDzVhmjoKza5+1EmN/E7jyHfx1+Nx3yay
	bO7ZOZIj6p2wqE8gWIvlK2vccyV4HfBbVnx0uhNG8d/+uX348ef8MAFtFyJr+6J7r2jzUDQBOgC
	f3pGGvE3bVT3+cZW6yRjjpVhqJOrBTgx9adGExmCX1F8eK1BnmrdSIxUYG7GGG+DoDLLPRxYnA1
	jY7Yb2Z4Rew4sN7VBzS4QT3xzkMSKufKVPKl1dgjwZsVue6N5Ndvo5CeWKGtaXzGC2IUk0MLP2j
	2qMLAfFYZn6A7ZT074n9hMMsQg90moun989QC6xKFVkPsoLXkwFrJTJWcPbvsvNV7OQg88Sp5Q0
	EjZIIAJ/kw/728DVy8m
X-Received: by 2002:a05:6871:4085:b0:417:5828:ecd with SMTP id 586e51a60fabf-41c112a2057mr6839945fac.46.1774208359167;
        Sun, 22 Mar 2026 12:39:19 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c14ddf9d4sm7787972fac.16.2026.03.22.12.39.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2026 12:39:18 -0700 (PDT)
Message-ID: <42871942-c61e-460d-af48-d10f4b947d8e@kernel.dk>
Date: Sun, 22 Mar 2026 13:39:17 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-7.1-20260323
To: Yu Kuai <yukuai@fnnas.com>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
 Chen Cheng <chencheng@fnnas.com>, FengWei Shih <dannyshih@synology.com>,
 Josh Hunt <johunt@akamai.com>, Xiao Ni <xni@redhat.com>
References: <20260322183911.2732398-1-yukuai@fnnas.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260322183911.2732398-1-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/22/26 12:39 PM, Yu Kuai wrote:
> Hi Jens,
> 
> Please consider pulling the following changes into your for-7.1/block branch.
> 
> This pull request contains:
> 
> Bug Fixes:
> - md: suppress spurious superblock update error message for dm-raid (Chen Cheng)
> - md/raid1: fix the comparing region of interval tree (Xiao Ni)
> - md/raid10: fix deadlock with check operation and nowait requests (Josh Hunt)
> - md/raid5: skip 2-failure compute when other disk is R5_LOCKED (FengWei Shih)
> - md/md-llbitmap: raise barrier before state machine transition (Yu Kuai)
> - md/md-llbitmap: skip reading rdevs that are not in_sync (Yu Kuai)
> 
> Improvements:
> - md/raid5: set chunk_sectors to enable full stripe I/O splitting (Yu Kuai)
> 
> Cleanups:
> - md: remove unused mddev argument from export_rdev (Chen Cheng)
> - md/raid5: remove stale md_raid5_kick_device() declaration (Chen Cheng)
> - md/raid5: move handle_stripe() comment to correct location (Chen Cheng)

Pulled, thanks.

-- 
Jens Axboe

