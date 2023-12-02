Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vWIcI0yD"
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1D810E5
	for <linux-raid@vger.kernel.org>; Fri,  1 Dec 2023 17:38:02 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1d03f90b0cbso3961425ad.1
        for <linux-raid@vger.kernel.org>; Fri, 01 Dec 2023 17:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701481082; x=1702085882; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gXgCsR6L0W5rVyHKd0o5tY8hcBRdiMWodCwSN7IfIbE=;
        b=vWIcI0yDjBLy6i860fvXYcVeBKZltHF+IZS7crfz5ZpjGICFX+LIegk2C15Pfe1iUH
         yxMwm9p0kdRjTSlFfAA7U2dp2p71jTvLCxi0IhQyAttGJHpz/jpKM4Ylq6GwMSegi2Gt
         nnxu99Ejw6sDer7CUfmJaJ9dNfPWcpmD8SNjf87VeJb99e7yvfztROjMczXCo72XyVVo
         wBEo3M0ZAeDv0tcmDqDqayabgollIqP4IsEAjXh6SNJID4iv0jSF1rNwMtM3uedZpB59
         PH8KnH4zdh3P6cNW7uKTWP3VU3vpkeX1e+f2OVdHCXhId8gQPdecG7hUzG44rLN/fKdi
         YqsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701481082; x=1702085882;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gXgCsR6L0W5rVyHKd0o5tY8hcBRdiMWodCwSN7IfIbE=;
        b=tMls54sNmOxM5KR0pUPpdQ267roi/+NvdRRmMccI8Q9dO3MZOyh2Vqzl3rFswsD6H7
         Ap8EpVOkFOQMdZa3zsqCq3WmPJWI8ARZp7KwfKf4WblM6XKvLaFlOxcREIWHqGE7YMym
         qtToMYtl6GOEeX3YDXEwuZfkIhAg0/L6Wn2gtgrlSUgBkYpAVXUJ/NbHlUBrkpuLhkZv
         Xl/VU0+JecV6HjBpD7moSN5kGS5BDEsK2DFs72kvKkoxJ9yLfLiC8I+lZLzkO/Qwk/fK
         NO/iGXrDBOvvHo5xRJR3KQ4V/7RC8d5VVITwRHg0EsBZxZV3iG3zGq5jNPsZ/bY+qdiU
         K8Pg==
X-Gm-Message-State: AOJu0Yx/1N6camsBhRGIFzCn/KfPLvfSX2Wni+h7uS4CiW2ua52LFpmX
	2p9SkOD+f3BWxrM2FGvTKVJeHg==
X-Google-Smtp-Source: AGHT+IHASsLGwjTZO7Y7Y4hlrvBB4iBAEwxA7iSU2VhXAogEloXa2q5XVEKXzm9ZnGJH/xhPnbYRLw==
X-Received: by 2002:a17:902:d501:b0:1cf:7962:656d with SMTP id b1-20020a170902d50100b001cf7962656dmr7288341plg.3.1701481081585;
        Fri, 01 Dec 2023 17:38:01 -0800 (PST)
Received: from [10.0.0.185] (50-255-6-74-static.hfc.comcastbusiness.net. [50.255.6.74])
        by smtp.gmail.com with ESMTPSA id z14-20020a170903018e00b001cfcd4eca11sm194911plg.114.2023.12.01.17.38.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Dec 2023 17:38:00 -0800 (PST)
Message-ID: <4c67f6c1-6804-4dbb-8388-48d27632cd15@kernel.dk>
Date: Fri, 1 Dec 2023 18:37:59 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-fixes 20231201
Content-Language: en-US
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: David Jeffery <djeffery@redhat.com>,
 Laurence Oberman <loberman@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
References: <DA07D7E2-9386-4816-8EC8-4420A026181A@fb.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <DA07D7E2-9386-4816-8EC8-4420A026181A@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/1/23 4:48 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following change for md-fixes on top of your
> block-6.7 branch. This change fixes issue with raid456 reshape. 

Pulled, thanks.

-- 
Jens Axboe


