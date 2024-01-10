Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF0123CE
	for <linux-raid@vger.kernel.org>; Wed, 10 Jan 2024 01:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VfKtnFQU"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-28d00f8ddbaso1028704a91.1
        for <linux-raid@vger.kernel.org>; Tue, 09 Jan 2024 17:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1704850178; x=1705454978; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LphsGQ40t4Su8M/8ceW8+5TGcdMaZo31aYelAi6AxGw=;
        b=VfKtnFQUN3XBKAKe4W1LH8yLgLwDX2WVeO4AYj0HaJP3XtdGez2iJzZIqm28Rs4PBW
         Lhq+hjJ549VHtvJOYpLxo/uebAES9ep169kLbk4C+8rFR12oSIolFU1s565fFGPOl1TZ
         dcixf/JJ0DqSzgqZxA9Oa1Yf4f2JiQUvJsVVE1yhyz90NX+vfWS0VqiVW8wuTQRIVg2o
         kHZEVoCNls8hlDhZ2U4FQbXXgTjiA0+XZMNpSKX0YDdfEGKxcxeGRaDwM/JNZ19K8SBq
         bqhvsAtym/nuImR1VlolZ26m47DgEEETe0N3pFhOb2nRM1cuaGp8sqwboyS9kofKay2m
         FU3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704850178; x=1705454978;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LphsGQ40t4Su8M/8ceW8+5TGcdMaZo31aYelAi6AxGw=;
        b=vqWjoZf5kJUtV1F7bNw1KDQPdCqCZ3dgkliOJ8gpVTuCWhsFXzm/8ugXw1wp+0TUJQ
         6po8XA9hKW9B7uS93LlRHeAkF3Lk3it2bZDvquiW+LQuCS26qPjNvOl7JRClpCokzl8X
         NZ9N2lB431Iwt7r0yPEUvIbznft4K7jF0Zi0Gz7sRMrXHS5NcXaM1W87mjVz9cE1KP2l
         uEzIUA2fw9X3XPF6y+e5hUJmnb9gGLSEM32pnKzlCXQokBqafnddAT26MrLPTau1S2Xp
         86XJc56I3q2NX/D10STCCiIdia00lKD201eVefBhRcY3unmCqs774mojF00zAIKlpx9/
         gNfw==
X-Gm-Message-State: AOJu0Yx3wZbELMLJ7Z2lWIWY16M5YTtt6E3G/dL1LWXCNdQCigDUj1XD
	JSxT5b2dg8eCeKv3ub+FpoDqmQ1Jgc6WBA+fNAhcC511k3cl1g==
X-Google-Smtp-Source: AGHT+IFSW/gng8zExTv8f+KLMDi+RPO5TTIfFzSK7Li3DaxBCpN/d1esoLR26dmrXtwFjaK/B0Af7g==
X-Received: by 2002:a05:6a20:4297:b0:199:8dbe:49b1 with SMTP id o23-20020a056a20429700b001998dbe49b1mr464884pzj.2.1704850178384;
        Tue, 09 Jan 2024 17:29:38 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id ix20-20020a170902f81400b001cc1dff5b86sm2433214plb.244.2024.01.09.17.29.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jan 2024 17:29:37 -0800 (PST)
Message-ID: <65535506-319e-445c-be70-7dd2cc5dd998@kernel.dk>
Date: Tue, 9 Jan 2024 18:29:36 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.8 20240109
Content-Language: en-US
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Yu Kuai <yukuai3@huawei.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
References: <34CC54F8-1887-4DF2-A073-4E815510C3F1@fb.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <34CC54F8-1887-4DF2-A073-4E815510C3F1@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/9/24 5:29 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-6.8 on top of your
> for-6.8/block branch. These changes fixed two issues:
> 
> 1. Sparse warning since v6.0, by Bart;
> 2. /proc/mdstat regression since v6.7, by Yu Kuai.

Pulled, thanks.

-- 
Jens Axboe


