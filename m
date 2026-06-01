Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C992DF144
	for <linux-raid@vger.kernel.org>; Mon,  1 Jun 2026 18:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780340128; cv=none; b=seF+b4aFE8tLMFhxvheTcm3/z/XFycdl2RJCdkomtBpBjvDqFSGFpyz1nN/sR0F1MHpBwKp1lVJU0RYuD/ptr49TSnNaYt4WdW/Ew3qhXcmQqhrL6enSGDjO6kbqMwKMI9tljawLEtbHdwyiX+MywWgFaoN8KCWgx74UAirLzTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780340128; c=relaxed/simple;
	bh=92Odugj+uqpqoYzi39SNfTycubqdCPubhM2crY0//Ec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kRTTOWJeK8KPrZMF2JGpd2U3fmyNLif9u0eLyk1GqzO8pq/0dxjPUcPwAo8sfGKkWfRjog8sTQPgONT6u0VFXI9KxEgW4FIQQk/GDoDpLwmk/sWKLraDWPh0g9ErYE/rsmQCRsIXpxm0XQBQToZAlUGhjLcgxYXNVitwczTHX5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=QV2T7QNL; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="QV2T7QNL"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-69de16f5f79so2681132eaf.0
        for <linux-raid@vger.kernel.org>; Mon, 01 Jun 2026 11:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780340125; x=1780944925; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=on/PdQMM/Rm6Fk0z4T5hTZtddcW3TdPodKG2MMd3qBY=;
        b=QV2T7QNLc9vB/Oirl/z89JlU0PFtHyj9FJ9EgseLNPSjxtcNXloLZcSyZ0bN8Ktxaa
         ZoOXXwRA/wR2Q6m8+zPzihH2PejLkVl+75QhId1IQLTFaeL/i7GwzfY0BHbaHs4Huq6H
         IM40udvJAUZNNbIPal0HyuYvhbSmFuX/zngpTiY6CRYDyM9eItC5Ib8BR/Rwaj0NESJ6
         1jtrv01wAfLzbv2yoiIpy35KOehNWUVMuItaH6JE0iZbOTv80FeaKVWjGVklbRUpxFXf
         5AXKLPHIONNbUBB6IgdZ8z3CXDjWYW1KPxj5WmMVpi73VxwOIvLzMUbpdXYDCEMvxh8q
         mWEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780340125; x=1780944925;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=on/PdQMM/Rm6Fk0z4T5hTZtddcW3TdPodKG2MMd3qBY=;
        b=l7ILDq9MaWqJ9YNF40X4FoMA+23GDoBG6g2oxOn1wg1Jf8lJdwiL7cs+nJcEdSAD4r
         KNx8Vf7+C6XtHHblsLF8sPMwowEJ01n8d5vx9mpQGhMArmSUZ2e+V+rOaohR9Ppjeqjy
         TMxnt85erKZcaq8RWqexD79czUNxXm1mZKt3pIrKTZtx22BY7Wl+jvDEI5ajwdxFU4E5
         k8RDeVVkz7Qgc2Q+Lq1j3Qn2QU5pPfuy6iqTKmoZfpnQpqXHQiwHe0qnit/hDHBXTbfX
         gNkv4vLcVuAW8UKv6B8U5qMPKDeQ8C0O7s0upjgpAqwuGS/uNmn7P6VH9CAgnjazGOko
         b5uQ==
X-Gm-Message-State: AOJu0Yx1oZuJzi9qVScqfXMCJdn/PG7HVNKK2XKs9dv+CaahqCsevLOU
	mC6CDQfHFExe8ozurazL2+aiwGMAG5yhipbifSCl0GIzRbUT869HC+ubXLI3tU6XtOk=
X-Gm-Gg: Acq92OGKEYgQixhcpwDc332TroBkqPXxhOXCaTZG0i4Q+/XKztkMRO6eNxX4dVbtPCg
	U/YBILj2RJGADImFGnryDk/4gEJ97l4jPgl+b7pJtZr8J48ID75YvKngOGvMPaNGE9Jhaiql0eo
	4FAQYu2WyMvKh59qHa32UdTTNFxNms6ODqqdEbtZFcB0ANImLz4TNeChL+NzY/vqY8dRwPNRU9+
	/zqYhQpKOw19KZVWdPJMXvYAGwMndbwWP/lEJsfN8rVe6VRW76YKj5abW07bV+H3GAlcqxEt55b
	RpYPPPjAHFPi5kGGbikKXnMlibjAreURvvWIhpZpaN6/njMAP+ivjDQcp6DwxhO9zi/IaPC366N
	64F9j2zpm72dgbWziQQZ+RnuZ4pDzHPVVm6SPHAsbd+6pSYdOzFrgMBzgYbaVAW/RJKvV7HNSiu
	Nn/+m3zGCZMq9Xy6ryjx18Rt0l7UrhlGUhftk6x9O1Z5FCyDNKir8WWIsJUYj1yayCCTe/+uydG
	AOR9swP37/dm/Kai+0=
X-Received: by 2002:a4a:d191:0:b0:69e:2da0:c1e2 with SMTP id 006d021491bc7-69e2da0c366mr1336452eaf.26.1780340124939;
        Mon, 01 Jun 2026 11:55:24 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69e067de2b8sm6985070eaf.4.2026.06.01.11.55.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 11:55:24 -0700 (PDT)
Message-ID: <753dfdb4-7d68-4183-af3f-d51e92d4dd31@kernel.dk>
Date: Mon, 1 Jun 2026 12:55:23 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-7.2-20260531
To: Yu Kuai <yukuai@fygo.io>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
 Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, Chen Cheng <chencheng@fnnas.com>,
 Christoph Hellwig <hch@lst.de>, Li Nan <magiclinan@didiglobal.com>,
 Thorsten Blum <thorsten.blum@linux.dev>
References: <20260531112618.160409-1-yukuai@fygo.io>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260531112618.160409-1-yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/31/26 5:26 AM, Yu Kuai wrote:
> Hi Jens,
> 
> Please consider pulling the following changes into your for-7.2/block
> branch.
> 
> This pull request contains:
> 
> Bug Fixes:
> - Only requeue dm-raid bios when dm is suspending. (Benjamin Marzinski)
> - Reset raid10 read_slot when reusing r10bio for discard. (Chen Cheng)
> - Fix raid1/raid10 deadlock in read error recovery path. (Abd-Alrhman Masalkhi)
> - Fix raid1/raid10 error-path detection with md_cloned_bio(). (Abd-Alrhman Masalkhi)
> - Fix raid1/raid10 bio accounting for split md cloned bios. (Abd-Alrhman Masalkhi)
> - Fix raid1 nr_pending leak in REQ_ATOMIC bad-block path. (Abd-Alrhman Masalkhi)
> 
> Improvements:
> - Skip redundant raid_disks updates when the value is unchanged. (Abd-Alrhman Masalkhi)
> 
> Cleanups:
> - Update MAINTAINERS email addresses. (Yu Kuai, Li Nan)
> - Clean up raid1 read error handling. (Christoph Hellwig)
> - Move the exceed_read_errors condition out of fix_read_error(). (Christoph Hellwig)
> - Use str_plural() in raid0 dump_zones(). (Thorsten Blum)

Pulled, thanks.

Side note - emails from you with the new email address all end up in
spam. I just noticed some of them this morning. But I think you want to
ensure that the DKIM etc part of your email is all kosher, gmail flags
all of it.

-- 
Jens Axboe
