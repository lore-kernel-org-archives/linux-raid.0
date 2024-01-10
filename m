Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E8E4CDFD
	for <linux-raid@vger.kernel.org>; Wed, 10 Jan 2024 17:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sSjCa//W"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-35d374bebe3so1946135ab.1
        for <linux-raid@vger.kernel.org>; Wed, 10 Jan 2024 09:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1704909069; x=1705513869; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kKycaOc9aClWKD8sMIBD0oz8RyIXJ3lsqF3R2kXNEaU=;
        b=sSjCa//WME0ju+f43sn4tlgEBYp4AC3HaZMthZBzHhpTlhDTtsj1ogQdoGDD5O7iey
         Nkm1afQQxizaWUXFsCEqSM8Fqc8LLoAlUBeCfkeOUEr+4YI/TAVKBoVvDdzrsXK64s37
         5jfQ2aukwuHDNNyv6trFGoHPtny5Ri4coVS7QbQFlY4ePpmUO3Ii2RgJuIe9fiUGydaw
         hOsGEA+kXU6E1ME5ZFnokru6Nj0IzQtQAjNAHgFglC282EidrHYS/T4VuAE6bYFLykF3
         JzxbpHd2QQjIf3m0wIWcJHnPwFGlbGdmLSBg8iwCQSNj34mbqHlZ8xjRJV8WXPZUCihT
         wDMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704909069; x=1705513869;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kKycaOc9aClWKD8sMIBD0oz8RyIXJ3lsqF3R2kXNEaU=;
        b=gDZJczHwApP3StUITyxH8a8V6h16ER/NYEYq25H+V1OFIbnKCJDTqYtAN96NXiNzPQ
         OIPg5GehU98GWt4Wb0icVSqcG2PfomXXrD7qyBbc+QLciv4doBwEe5i8b6xO0aIy5wRM
         gLoJUr2NPlt/2FiDr6pyFwLAqHsOEd31wOk18y7fzskAm35BRgpOJh4GwJTobXOqgBEi
         NsAnwhiWBNG4/+hkEwleRnhNWWMXHTpzx4OJfEiUNAwP507x0VhCKV7I+p3feA9N4vxL
         BWRM0l2PPp/99Dt+I59Vwz8AtHWyowKAcl0etemYWM1bmX7kvWGPgz4bgeJu5yhOMUIQ
         kcog==
X-Gm-Message-State: AOJu0YxFFJb1IeGNwKQTrevmA1GoRDP+P3n9wTQ83hY/ts7UPrWOwoZb
	EMILUf07z9ylRkSy0MlvVUS7ZJ85Dbt081f4nU9vaXTE2Urj4Q==
X-Google-Smtp-Source: AGHT+IEqRVR2Tp4xdDo7VXyOBEZUz84APEQlWyan/VEcKlBw/hgjEVuZoKtTk2eydcpCF08DUPU8Cw==
X-Received: by 2002:a5d:94ce:0:b0:7be:e328:5e3a with SMTP id y14-20020a5d94ce000000b007bee3285e3amr2872423ior.0.1704909069038;
        Wed, 10 Jan 2024 09:51:09 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id du10-20020a056638604a00b0046e3314cefdsm1422814jab.3.2024.01.10.09.51.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jan 2024 09:51:08 -0800 (PST)
Message-ID: <e6572896-39e3-44f3-b1a7-91dac1dc28ae@kernel.dk>
Date: Wed, 10 Jan 2024 10:51:06 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Changes in md branch management
Content-Language: en-US
To: Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>,
 "yukuai (C)" <yukuai3@huawei.com>, Yu Kuai <yukuai1@huaweicloud.com>
References: <CAPhsuW5YspxV-xhYdGF7HUVw=o_2PbJXMH45Y1fYRDymD8-Cqw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAPhsuW5YspxV-xhYdGF7HUVw=o_2PbJXMH45Y1fYRDymD8-Cqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/10/24 10:42 AM, Song Liu wrote:
> In the past, we managed the md patches in two branches: md-next and md-fixes.
> This approach has a few issues:
> 1. It is not very clear which upstream version a patch will land in;
> 2. Around the merge window, there is no good base for md-next.
> 
> We will try to solve these issues with a new approach:
> 1. We will use numbered branches like md-6.9. Patches applied to the numbered
>    branches are planned to land in the numbered upstream release. Git commit
>    hash in these numbered branches should be the same as their final hash.
> 2. When there is no good base for the next numbered branch, which is usually
>    after previous rc7 and before the next rc2, accepted patches will
> be applied to
>    md-tmp branch. These patches are expected to be cherry-picked later to a
>    numbered branch, so the git commit hash may change.
> 
> Please let me know if you have comments and suggestions with this approach.

Sounds pretty reasonable, maybe name md-tmp md-tmp-6.10 or whatever the
case may be?

Outside of that, I like the idea of just having an md-6.9 branch. This
can continue to roll forward post the merge window, as there really
should only be md changes in there. Eg I can pull from that for both
before-merge-window times and for fixes post the merge window. That one
should never get rebased, you should just keep piling patches and fixes
on top.

-- 
Jens Axboe

