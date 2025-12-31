Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E61CC8CE
	for <linux-raid@vger.kernel.org>; Wed, 31 Dec 2025 14:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767189636; cv=none; b=fzD5hhRQmeu0mI2chrthYq4bljVhrUkYjxfdOZXIexaOBl1T1i+iR0LI3ZaSIJHukrHFpGchG8OY3XFfYuPTSkTNH+NF6Azai9vfod6bIckDMED5o9OqwkMLYigW/CTHtsLZ/1eJxPLA98nTSRJaN1D+EkvZevVDqwoP9cngQmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767189636; c=relaxed/simple;
	bh=BOt80TWAlzsyCinqdLVYmsvJ386QzQRR83aL2v1in5k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zfg92HrvjwC5Phoq0tHenKXdq5QzOpUlntlS5SB7lQ15dYckj494tU4oBTSqgBMnq0BpyoNrRIdfcmMYIUqNtFLtvHCmcsbU/ycSvr7/zLh9nq+Ff2fLHGbGd69GbMKOz1t45jpCeDFgWjw+LvRToqBWemA1z8H5BIgK+4JWWUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=afFG5LWQ; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="afFG5LWQ"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-6575e760f06so2812419eaf.0
        for <linux-raid@vger.kernel.org>; Wed, 31 Dec 2025 06:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767189632; x=1767794432; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y23pRxBQqrSDyo7LNxDDUtSMxRfvlMn24l6u+kU+XH8=;
        b=afFG5LWQTsBuDsbhIWKQbtPgIdG0Xd3kr5T842A7JbAAjziwNuCSWyW3salvbnI4Up
         0h5s1fstraMbe37Q+/4U3WrzBW/J2ju2R3Q9LqwqEAekyJDWK1181CpuC6ogNjKbRBnY
         cE/dMkL4YEt0d1n3SGvOM301kpkGauBHSYoMNtdNo7YvyJelT8x241y3YJO037bU+tfm
         X9yw3g4RIiFc/KO+yJlUV5Eig3aEvyiDAaillvSleUXTsjMhaQZzTmm9mMERrW3oiL36
         X7WGInOTJBU7lojRJ4M7stCm7isy0gVynR1Ah2l8vC+JAwGbITJG9D00BP4aaFKZcxSy
         JYOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767189632; x=1767794432;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y23pRxBQqrSDyo7LNxDDUtSMxRfvlMn24l6u+kU+XH8=;
        b=ZwCHedare/5ThwHERQ3CS91qjKGXC4MuT7t3KTFelmfpw7FjOci35E979URjLeq0ei
         jppv7qZdNFnUCuFQKqXNFb2foVla2yxW6ZRjs9rXKYZK6Nrn6f+fYhGj9P0JfNliqvG3
         dPsvjmPT0Hmq+pDGVGx3UqgUmItKpfhPxOm3W+WT66zXz/kIhGJNe5HiS3InApZTMy4h
         9sY/jQFSfEiFyT6f9UldF9CkA3cplTe7s5Fgd1yPgkhQ/rUykcj6oPJsMWpRVeymtPsD
         gjswo0bvm6E9Prp6tUV/L+w10ul9Kn2AMaykrg/Qw1Q6ModYtalhhzFjh/zeYCkLk+/9
         Vnvw==
X-Forwarded-Encrypted: i=1; AJvYcCU5cRUwGrqnLDLYvGlRT9vsSw9yp1GTIr2hBWnDKHOABHVgpEWpScHxghF2sMIXUtYFHxxeKYMjbCf6@vger.kernel.org
X-Gm-Message-State: AOJu0Yzbt9CH8thK1Vx0Bdigjz9yFLr3n0bASXQHGrvkdJQA5wCl9DI7
	mwdsbJuVenWYnW8U3J1CtjPNJsYRylCW8Y7ga9kzvbWx7apaT0mlub4pOt4tnor6L2Q=
X-Gm-Gg: AY/fxX5DPPAqByXN4ddqZxgtw5sboWcb0GNqRhNS6nJX7I262PHeEf48qS/LuZomQgQ
	xea+ss1+SQEw6r9dE8WRbI+vDo3iwQZYUDE2+cGAYVXRkQKm1kptj6PT0Q91E1ry7/Fvyjfn4O3
	ExdzQ0ZZIvDskxKNJx/vHVCBqSHTh6uI0e2Hdxj/DjicWOflS6ni1xVQukjygIan/eYHEHGKvP6
	+69jdPLvp7fwXNbQ86psYOvX4QGUoqnKu7If2cuvmE36vDUJa0kyYy9JvLr8RVnVjSloNauKHxQ
	0ISy0HLMfRtIIaLJ2OE8+8qSHZssA7Eno0xFLCuuQgSny1Ztj3cq1MtXguzRTF23seazhTi2Dk9
	D0GrNXM6ntHj3cvci+evhtxRwhRwtImbwF4OR4w4wdZ4/T4qggBMqtGiR5gbvqr1Qh5THCqQSB4
	vmpnyBUIAn
X-Google-Smtp-Source: AGHT+IEJTWeeJmVjUHuR4zws5/FZzesd9X+daLWNvN0vX+BxWuJTQySB9pISvfKxN4xR8NfdeyZKCQ==
X-Received: by 2002:a05:6820:80f:b0:659:9a49:8e53 with SMTP id 006d021491bc7-65d0ea15d0amr15634024eaf.35.1767189632104;
        Wed, 31 Dec 2025 06:00:32 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3fdaa8d4521sm22162034fac.4.2025.12.31.06.00.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Dec 2025 06:00:31 -0800 (PST)
Message-ID: <b2e5e9cd-21ae-48fa-ae61-f23f61da8a63@kernel.dk>
Date: Wed, 31 Dec 2025 07:00:29 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.19-20251230
To: Yu Kuai <yukuai@fnnas.com>, linux-block@vger.kernel.org,
 linux-raid@vger.kernel.org
Cc: linan122@huawei.com, dannyshih@synology.com, islituo@gmail.com
References: <20251231091740.217388-1-yukuai@fnnas.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251231091740.217388-1-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/31/25 2:17 AM, Yu Kuai wrote:
> Hi Jens,
> 
> Please consider pulling the following changes into your block-6.19 branch.
> 
> This pull request contains:
> 
> - Fix null-pointer dereference in raid5 sysfs group_thread_cnt store
>   (Tuo Li)
> - Fix possible mempool corruption during raid1 raid_disks update via
>   sysfs (FengWei Shih)
> - Fix logical_block_size configuration being overwritten during
>   super_1_validate() (Li Nan)
> - Fix forward incompatibility with configurable logical block size:
>   arrays assembled on new kernels could not be assembled on kernels
>   <=6.18 due to non-zero reserved pad rejection (Li Nan)
> - Fix static checker warning about iterator not incremented (Li Nan)

Pulled, thanks.

-- 
Jens Axboe

