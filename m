Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C013FF8AE
	for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 14:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777387328; cv=none; b=lJJTLG20l+MPZjJYoMmKF5fC8ojDXzzaUDDl7uyPpJyr1+MEhE/EX9ZMeIa1DR/ZEQvDnJPshN4sCrIBRlRyDFjnHpYZUKACQAfZA5slUEvroUrI64f7CInOb8vMpiRO6peRP9aTvhGhKuXZ6sggEs22BH/A36Op1/NP0SUuGkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777387328; c=relaxed/simple;
	bh=2V0vjuyXy6kypG+oH5jFBocr0VPTC18fKm+B9G1R/N8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tUNeOrkK5Voqe58fK6LQuNAe7NRBH+1WoG1xSanHrZIO0/BX0n3GzeYaQfyrm57Vo05QNxy+UL3xlu1NM0dPj8ZXBJeYN5Nq7dhaI9hWfDuogQg9H6qj4iAI5h49SdIQAwP8suP4RkWQE+4D9TX6T6oNfCoC4H32QTzsyf16L1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=nNpHN7By; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="nNpHN7By"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-42fc6923f38so3765080fac.1
        for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 07:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777387316; x=1777992116; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=crdUSZaMOcLRVl8zoeEkk4g0iNo7njp/hRFe4REvY7o=;
        b=nNpHN7ByVkqbD9hDMOQ8bifILBGqFTDMA0VESPvyBqcY1k2CAtycZjuNtPUBTeIJGi
         hS/yVEDbHSl5mUlRfxvh8XbQCrNvnEUxNYBbHHU9GMmBbBnTHI67PwPDEbmPtB5AafIh
         PHFbjIBqdagli2KdnuFVz0yacXJOcXpQ9VCivcLqOLry0bzydTES0piFdvUj//xSjfch
         2qid6YyzLYVA3MIn6mBwCvtPaEqz+HNJugNFrmOISGcrlbjKGMU2PqP9Xh518/YM0oP4
         +tmhijqGX3N4V6111JbB7R5oPbi7EBhkAwC5Vfvawl2XC65io9kuBC9DeXs2HeDK1BZN
         svPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777387316; x=1777992116;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=crdUSZaMOcLRVl8zoeEkk4g0iNo7njp/hRFe4REvY7o=;
        b=kBwcBuJ4yqhZq3+7jNKXOmSYgn9KLWfZ2ZQPb+1HKyfyVF4zGVsQl3E5v8CxD2Vw6f
         sWH1VJAf3EUii5avGmalmgU5GwSB6LJqVudx/pxG2AXLVpw/Xi4WR7ftYb/I5RTxyyp5
         SV9J0CfwHoM5q6kpfUjSWSFrp21ZyyrwAN+o1cEvb3VprBMCZTRZ1O9CbY4JzSyx4myz
         EwaIexBDwd1kB/ve8iq8K8OzzacYrk94xDUqLL1kXnPiNfQGbPNd/rnDi05b/WQRqYPa
         DFFExLNLcT31eMGaqy/FmwPfF3j0ZLqOhMHcSC7FakDgn03VwErLBpD4G1UFIpelP7Ww
         5kmg==
X-Forwarded-Encrypted: i=1; AFNElJ8TzXCjZS8hwKQZCvEWY9E3RAwb6NTD09ZJFM+5AqS3WPGMMQyo4i5/cS1MJaRTrCGcnysy2OatGp4r@vger.kernel.org
X-Gm-Message-State: AOJu0YymrZW5Z8LtJDtXqbq3YR4VoJpJgGvSw3xTNoPjQ7b3jJ8xNHLs
	kmJTz6fK0dW8VWYqHnoeGNgyh8vbnE+2qPjLjUUYGmmV2fAE6Jj0yuLkGZMe4Abvpow=
X-Gm-Gg: AeBDieuLrXzm3aSyaINzME5XCVupxIUYIGHra3aJa8i57xlIM3V809MlhavJn10kmn4
	JHnvJv+xVJQDLWugfgtm8FELWsG5/Uj77nTG99uV99VLuT3wZpiLNOkJyuKVosEG4+Qn3J/IXdY
	oQpL1v09lX9DnAB4yHjFRhLj2Pgp0S3GzkIGbPo93NpGGL2hQm3Dc/kV7X1mU61YGMCgzqgx4ec
	UNHdTUwlWhyEhqeIbQ57Gyc8oi95mKIwHO0tlKTVmHgHOaRRx/nUEjVuDjJXpf88T4qo6ZqeR6g
	88h6VOitisv6ticOPCWub3c4Pp2hVGb6MyN05+Uapd5hZXb+oM8e4+4oabXP2rrbhgYbAPVTzmY
	IUKNGu83DR8K09XzRGvmrWX2/8Woc/z0iyx2zflHVNku/hEyxbxPhlp6qVUOONtFg1t1GwQCtvM
	8nNc+ML5vWcsoXB9wSCQN0fC4hYi6f/GoqvVUPK5LoFf6ncPv3o3dxMxrSz29bqu/cIsYNVQu+w
	UIoa8V/ySE0Y/PRsqfThSfl9qus6w==
X-Received: by 2002:a05:6871:781b:b0:404:2e44:18b6 with SMTP id 586e51a60fabf-433f1f393e9mr1575881fac.16.1777387315738;
        Tue, 28 Apr 2026 07:41:55 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-433efbf1d8dsm2015750fac.6.2026.04.28.07.41.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 07:41:55 -0700 (PDT)
Message-ID: <982f5bcc-8caf-465d-99c7-3b457cab20c7@kernel.dk>
Date: Tue, 28 Apr 2026 08:41:53 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-7.1-20260428
To: Yu Kuai <yukuai@fnnas.com>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, Li Nan <linan122@huawei.com>,
 Xiao Ni <xiao@kernel.org>, Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Junrui Luo <moonafterrain@outlook.com>, Keith Busch <kbusch@kernel.org>
References: <20260428143340.1088943-1-yukuai@fnnas.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260428143340.1088943-1-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/28/26 8:33 AM, Yu Kuai wrote:
> Hi Jens,
> 
> Please consider pulling the following changes into your block-7.1
> branch.
> 
> This pull request contains:
> 
> Bug Fixes:
> - Fix a raid5 UAF on IO across the reshape position.
> - Avoid failing RAID1/RAID10 devices for invalid IO errors.
> - Fix RAID10 divide-by-zero when far_copies is zero.
> - Restore bitmap grow through sysfs.
> 
> Cleanups:
> - Use mddev_is_dm() instead of open-coding gendisk checks.
> - Use ATTRIBUTE_GROUPS() for md default sysfs attributes.
> - Replace open-coded wait loops with wait_event helpers.
> 
> Others:
> - Add Xiao Ni as md/raid reviewer.

Two notes:

1) Why are you rebasing the tree right before sending it? There
   should be zero need to do that, please don't.

2) Please switch to https://patch.msgid.link/ for you Link tags,
   if they are just links to the patch submission. That makes it
   clear this is the case, just the patch. You can use lore for
   actual bug reports etc.

Pulled, but please change the above two things going forward.

-- 
Jens Axboe

