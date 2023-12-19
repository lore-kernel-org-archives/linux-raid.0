Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7CC3DB8D
	for <linux-raid@vger.kernel.org>; Tue, 19 Dec 2023 22:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="STi82wbW"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5cdbc42f5efso196841a12.0
        for <linux-raid@vger.kernel.org>; Tue, 19 Dec 2023 14:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703026255; x=1703631055; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2CP0H5rwsE4JjT8zXfI3cDfMDsIw6ZEyN04bsh/kUbc=;
        b=STi82wbWQkskY4UptwL/89XL485YjAl9j5U9g6fcWBuM+9a6E1PTn6WwFRJHlejefB
         PdLOGDwkh6MWRZ5ec5DK3xgDoTsowFPYgY2OpvrdbGwUKMUC9o7wSPIFDpgavoR9uiEe
         SW/ujRnsrzfcNtDmhkWcTv0MS85SBgTiVg7UA4Xwa/ph36pXhnFmbQShi0CsefGvtPf/
         /GhLict+OE3U02ZR87SeM3KmjJsgB9DFXFrBMNHiKc11QN0pByCl8WQWSZicb9LdhETG
         OCXye+OEynO0YgrDbhej1FbhCrTHCy6hvgd096EkJC6NNGYZIb/5ZHEi4bmCwxCxO+Tu
         3pdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703026255; x=1703631055;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2CP0H5rwsE4JjT8zXfI3cDfMDsIw6ZEyN04bsh/kUbc=;
        b=apMpLLGiHG/RKUzp8EsO6J+cy9LqRtRfghfL2zTCRplRO4TV8tHpfTzEDxqddu0q1G
         xsCXcvp1mqF9tZMYlBR2KQUhO/C7VJ21nvUaiJWxP306TQeDI5nO4Gj+lkyWgynyFNeH
         TqPyoFszt7ylsIVTfmL9D/Y/tdJjJJgR4B1J3wpq0s+TUy+sfRUS9N8USfPPiWnRFTZu
         dyVotPr3pHu68K62drA264YNDXAI0SXNmkP+Mhzv6ofS2VT2KIqXrSIVyYlrmLumz3/5
         YsyGa+Hw1LT7RZhtcx0niCOVtN/Qk896HgzDwNHbtVqLIQPC7wjYjrAI+4pT65cw84l9
         gOfg==
X-Gm-Message-State: AOJu0Yw66OJMAtMapSdwQ2MWik3/aaNQInil6qghfgRvFhj3t3ZguZOa
	jsiK84XlEvYwUduPRn5BF/Gnfg==
X-Google-Smtp-Source: AGHT+IGMRpXANYngUWQLXS4DAjUGicgl3HAwUnV2z9pLszJv5v2BUOlxod/skwoW4xYTzmKvLTyHfQ==
X-Received: by 2002:a05:6a20:3d29:b0:18b:c9cf:4521 with SMTP id y41-20020a056a203d2900b0018bc9cf4521mr42674246pzi.2.1703026255300;
        Tue, 19 Dec 2023 14:50:55 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id x16-20020aa784d0000000b006ce5bb61a60sm3939556pfn.35.2023.12.19.14.50.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Dec 2023 14:50:54 -0800 (PST)
Message-ID: <6fc4a449-9904-4bc4-8020-fa4fd918da96@kernel.dk>
Date: Tue, 19 Dec 2023 15:50:53 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-next 20231219
Content-Language: en-US
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Song Liu <song@kernel.org>, Li Nan <linan122@huawei.com>,
 Alex Lyakas <alex.lyakas@zadara.com>, Gou Hao <gouhao@uniontech.com>,
 Yu Kuai <yukuai3@huawei.com>
References: <1C677396-6F6F-4930-805C-1C79CE442BE6@fb.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1C677396-6F6F-4930-805C-1C79CE442BE6@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/19/23 3:42 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your
> for-6.8/block branch. The major changes in this patch are:
> 
> 1. Remove deprecated flavors, by Song Liu;
> 2. raid1 read error check support, by Li Nan;
> 3. Better handle events off-by-1 case, by Alex Lyakas.

Pulled, thanks.

-- 
Jens Axboe


