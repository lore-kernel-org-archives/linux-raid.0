Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72224155382
	for <linux-raid@vger.kernel.org>; Tue, 13 May 2025 02:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747101686; cv=none; b=ZOhW0LUWGma7vOucLsvyUQPWBUH1BNGdFGnnBFbm6qI7VddcaM60kr4+z2RIzXF9wt+tt3HPN1MUZzly5oqFW1W9Gur7/H0kZvCtWuUp36linKTLKOG3aQcUkwRs9QpT3z0A9Z35Q4x+wA80LYEC14bTl7sVhLH9OgVSIlkXjkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747101686; c=relaxed/simple;
	bh=yE9onY8NdkX6czJobUjo5eMPrPhawKkNNLM7/xsPmNw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=au3kxjWv/DwwWvQ6/nxh5umi1hySyrHUapv/gB0X0J00GFL9iTM7UAY9S7GcqNiG/w11h6tXigcBg55+G09Mq/upl3CuQ2/bXO+txuFL0nNqBQlLDOfX+TFnOsO0LrpyN2r0ODXEI9M+2Anz2oa+1buAhTt/rJI7cy6xyFdGOs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NDHQcDHB; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NDHQcDHB"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3d96d16b369so48987855ab.0
        for <linux-raid@vger.kernel.org>; Mon, 12 May 2025 19:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747101683; x=1747706483; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R8abbrAIv7/r15E8DFHFVQc+1YpAhVWDr3HIPA0EMBc=;
        b=NDHQcDHBLxfoGhYcPsLwLb0vEASgFrLxkZkIVrHQESlKxHNDlJ1MnfPtoezN/sc4kl
         mqkzPOo5Xp0WUdb1IPR11CrmsohQwdkhxjnffcPOzR40B7TrGoWHVEDXpxzqRGiazUwb
         hD/CfoITyrBbtI3/veOfM7M0Lvfx5U3UhLwmSXrFTdDC4sTopm9sSvmJJEhJnmkGdE2r
         7M0Ljzr+4sVG7VpMqdlMWkCovV/H5MkSUYDizOh3ZyAQgaWDjGM6i1WCgdFJbFfhGXtZ
         R/W8d036MwRu4dFne6oIITroY30hAfXAQViyjSpgm2rSIFl5lthF79+PcDvdg1CphHDY
         1LfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747101683; x=1747706483;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R8abbrAIv7/r15E8DFHFVQc+1YpAhVWDr3HIPA0EMBc=;
        b=Guq4bg4K4o/e9DZvay4e70QmTAzi94U6WKUwPRf6sPgFmBz5TE2eNiy0rt55NTLwVd
         Otxo2gKTf0qhdmHVTlVtkLvH8vyiXMqxE8UPRkXvgh60PL0jvW7tmSRNvViVBi3PtXza
         c3dTAwDV+79q74O3/KCr/G878qVocY9TgonGFLE+wRlrCvBUYwOgSqybr5bxSWBDWt7S
         6xpcAApK2AUTEtH+Oy8NT9V8GmSVyT2oYFZaAqvzf+GxDWuZ3IDBWOI2hqPtm5WuG5EY
         cnAer/Zpc6bHUH+7DnyH2DIEsPSPBaxV31CBolegJi4EcjtkLvyZQJur1EN5ZMqoNE+h
         Yd6w==
X-Forwarded-Encrypted: i=1; AJvYcCWoeAw1/zwU3hSJIXAP0vsNHcAFpGJkhn7HjlSQ5n23JDLrng71ohGCYxZZbmrmX4QpLgBJda9+wqGQ@vger.kernel.org
X-Gm-Message-State: AOJu0YziXcjWMnZC2JjB5BnMasWOmD/2bgNvqXHHura/9c0SPxdYfQ2d
	bbwcxccJbdJYI5SX0hi/nJl+yGvsG3tCGHWZZ2v/oGoxw9qW18XOkPsa10a2uh0=
X-Gm-Gg: ASbGncsxMdhgXEKuEShbBU+VgJFtGAIBiqQrdjq3y06GkRbUK9aSZq7cF0s6bRlwv7Y
	xNP6IB1QB2BtkaOheSaw8kr99dBjtKTOIm/Z0YNeDKfzOG5Ila1FLCqumOxqN+vnzb7q2nJy8UN
	V+3CvSwg6Bst/w9oWQvZ924tR9pyzj0SM4AN1h0b+vDOSqlj9xRWjTB4w5+LP8rXPwlSVaZzB+T
	Nz5zHO/v8FZ+2/Po4xmjRo79QFGCsrSXlR5KbKe1xE9OVJmnoUyjHaUwZQVrFmT2SWVosxMrU3D
	GVvD2dZGC4NtwhlNuBH5jO8XfyL8F2cRdEcK83S4L7MVqo4R
X-Google-Smtp-Source: AGHT+IGgGoNQmPots6zyxLTSAGIzSCEkUgaB5DFa4uAZa2ua9qL8VZt7gV6Fp8rhuYcHEaCNFuh1LA==
X-Received: by 2002:a05:6e02:1648:b0:3d9:4785:3dd5 with SMTP id e9e14a558f8ab-3da7e20d7demr166180865ab.15.1747101683404;
        Mon, 12 May 2025 19:01:23 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fa224de163sm1878797173.48.2025.05.12.19.01.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 May 2025 19:01:22 -0700 (PDT)
Message-ID: <4df296d5-e6cb-4d11-9d47-76d38a442d24@kernel.dk>
Date: Mon, 12 May 2025 20:01:21 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.16-20250512
To: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
 song@kernel.org
Cc: yukuai3@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com,
 johnny.chenyi@huawei.com
References: <20250513013837.4067413-1-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250513013837.4067413-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/12/25 7:38 PM, Yu Kuai wrote:
> Hi Jens,
> 
> Please consider pulling following changes for md-6.6 on your for-6.16/block
> branch, this pull request contains:
> 
> - fix normal IO can be starved by sync IO, found by mkfs on newly created
> large raid5, with some clean up patches for bdev inflight counters;
> - add kconfig for md-bitmap, I have decided not to continue optimizing
> based on the old bitmap implementation, and plan to invent a new lock-less
> bitmap. And a new kconfig option is a good way for isolation;

Pulled, and then unpulled. This doesn't even build...

ERROR: modpost: "md_bitmap_exit" [drivers/md/md-mod.ko] undefined!
ERROR: modpost: "md_bitmap_init" [drivers/md/md-mod.ko] undefined!
make[2]: *** [scripts/Makefile.modpost:147: Module.symvers] Error 1
make[1]: *** [/home/axboe/git/build/Makefile:1954: modpost] Error 2
make: *** [Makefile:248: __sub-make] Error 2

Before you send out pull requests, at least ensure that it builds
both built-in and modular.

-- 
Jens Axboe
