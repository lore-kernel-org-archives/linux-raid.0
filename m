Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="D/vCc+rx"
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F3B8E
	for <linux-raid@vger.kernel.org>; Thu,  7 Dec 2023 11:17:05 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-35d626e4f79so546525ab.0
        for <linux-raid@vger.kernel.org>; Thu, 07 Dec 2023 11:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701976625; x=1702581425; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7obInfpDp/zaQyCnC4rgRYUjsYNAs6clCSKMpr1a14I=;
        b=D/vCc+rxwrEoBsl13w5vQNpaSIkrrwlRFNTCrs+GHlnFAQ9T9xS7ojsymPHqPjpL6c
         XjOFUHKyf+AzVGfE5HpmNmzxdnXahiPPc5T2UOqhg8vrPz7lluq5khdchPzvHwrYPjyF
         q35KA+vz2cZ6Ek6oC9ocEhbgfI5ZYw36BwM4TcmHVrr3z09iqo4O4dchq2HhvBoo2Oxu
         QKiyKGu4lTx19nmgBUzbJCtYLNjRhxjAgQ7kZOtn0Qn+pvvLqlZl8fmZm3DXxJBA/KSo
         D0fg9sdZZeUV86q79qCyjE6Vh5ERx7MIGO1QI6fARgWatH1tkPF5+ccHXhj+9r5pTrha
         qc2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701976625; x=1702581425;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7obInfpDp/zaQyCnC4rgRYUjsYNAs6clCSKMpr1a14I=;
        b=JLkHJ3zZxGXPa07CNJP/hR7oV8JvHZJWFRyo+Vrln/lcF4J/lEk3mTiQZ9+5nim0Sa
         6B+y0fJq6XD3u8am3A0IotCiHFui7efVF5PIKRJ1OtzHQhJYyZsGogHSkT++hXD6sFHF
         SaWVSJmz9x7Wj/XYPEt9dAXYfQWbWH9WfA56GAD53MsMz4tq49GyEI4ibaqU4JjPdKK3
         Jo24t855lLEmlqEa7fzGQaIEzF9Lbd6CRHgPwKmUbvCrpMEV1Y0/XdCOnQt7ncq/tm8J
         xjrityV80zqjWjwmmIz6BoVwmmdoxx+qW4Kw53HJUe/ALp4QaUbmqSDgR8nzF9IWANa2
         WboA==
X-Gm-Message-State: AOJu0Yx2UC+ZVNVo3U1nsckGFjmi3ixYx+OWWATbwzntgfNT/004g2zU
	TszIJVXVaZkZfxc8Ia37fNbN2TMX88m4rfHgYcTkYw==
X-Google-Smtp-Source: AGHT+IGGtXLELul8tKXl8h0NNSD+tF7QSTGULiaX5tl1/x+LdhSMY/eOGP4Du2BBTqS3XDHMSMHuEQ==
X-Received: by 2002:a05:6602:2bfc:b0:7b6:fc49:a5f9 with SMTP id d28-20020a0566022bfc00b007b6fc49a5f9mr2204042ioy.1.1701976624842;
        Thu, 07 Dec 2023 11:17:04 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id cd24-20020a0566381a1800b00469328386c8sm77288jab.162.2023.12.07.11.17.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Dec 2023 11:17:03 -0800 (PST)
Message-ID: <240983c5-9d1c-43b9-bb3d-7f77b702e147@kernel.dk>
Date: Thu, 7 Dec 2023 12:17:03 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-fixes 20231207
Content-Language: en-US
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
 Song Liu <song@kernel.org>
References: <32698B02-C181-4183-9FA5-F4D5C17F11AB@fb.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <32698B02-C181-4183-9FA5-F4D5C17F11AB@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/7/23 11:33 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following change for md-fixes on top of your
> block-6.7 branch. This change from Yu Kuai fixes a bug reported on 
> bugzilla [1].

Pulled, thanks.

-- 
Jens Axboe

