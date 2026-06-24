Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0555A39281B
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 08:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782288500; cv=none; b=esBcYEJa+XJdqOBJcnhCjDMYdc+QSNH9swEFS3XVQQNCvRAdtWpcz9EPh9mL4eBLbQOJ08cjiX5OEhd6tKrza5xkPSIMIoh3CQswu3j3yZI7GdIflq9OQzs4Gu+9Y9gN0GJV9lh8mZolI09CTSypkr2lOG6mH6PqNI7dUzGXN4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782288500; c=relaxed/simple;
	bh=eAWUuP8xKywSlpbDj5vHPgvt1HEPv2PVR5iSivYStj4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=AsqdPjL10i6kamj5pPeu9Dqa63gY/enIN7rn4ZcA8+0lXKWKO3OZ7FeQY7tNo7yvFDCI5FE9Y1qi11p7VYE0vE9xq1p5gQZP94k7gf/4SlpYGOsTwjfrjgvi86gSNAsxbHV6SDbr+qPXGDE57x091UEM2Pf8/Pr8PWdvc/IazFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I9vLYQM6; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I9vLYQM6"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4922244f7c7so6592115e9.0
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 01:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782288497; x=1782893297; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eAWUuP8xKywSlpbDj5vHPgvt1HEPv2PVR5iSivYStj4=;
        b=I9vLYQM6SzLITCcrde55x1vKzeLUpsCnbLmEqK5VNb3HhRRIGKAfsGvykgF04s/m6c
         pkrISSubXErweY//67kA+UB6i445e0DrtLMBAa1lZeCHOBW5b7vDfjIXyzloakqWgvB8
         9OYayfcodhzJzjohXYbE0v8pp1rkfxRI4g6ofn6Og/v/yq1lgZTwQF/8wcguF644raSE
         8+agN3rIP5goxRjHTRQWrqTL6V2GBTtfL6UbhN0UeW8+zmCTkYDS9t9LTHhKgCv/8hOa
         Zecar4RODqGVxlSC+IaF/BFNspxXIkH8169l25ItTRathGdzjP4obBzB/hOMK15jPPjQ
         UngA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782288497; x=1782893297;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eAWUuP8xKywSlpbDj5vHPgvt1HEPv2PVR5iSivYStj4=;
        b=aj2IiQTK/FaDYrwUcEhUTme98uLz/uacDFPzaWxVhYKYvWmKVf186DMKnTTSdhQ/96
         UFLTkBbjBcAoDso/1TkpDki/srhzu+40qdJwm+UcZ8arV17xBy42/iP4r6q76RkuUI8J
         lEf931Ywb34csxtuUja3Nyhum1SORLRMWnB4Fls7PHGKXoWjUMk9lJ4xGA2kr8H7XPAK
         e8rZK+aH6l0aC/Kv0qlMf4QebQ2fXCsGGJW3Qjxe5vJRp3sW513/oh7MbfDFTx0aqcMA
         z9h4kYQLKe/bytZIw5zC2hVA6FvmXf5wN7sWYzgg0Ayj6sABU7VBt+QlesKWhTkfbiuJ
         HOWQ==
X-Gm-Message-State: AOJu0YyR9MSwU+/rb7/Kg3Xv6EzjIg8sSZR1cg+c7TDiUvPL0hiwua12
	sqEjB4lIIu0uzCQUt517sx97aXrWdUjj2FWgK85q1t6/GG/kmKelc9co
X-Gm-Gg: AfdE7ckpKMG2nVCQbgVrTuvyxwSy7ABe7fBBaQ6CIJizhG18s5Mrexo1QdnpuuVcKoK
	yycwsiLL9YBeVdUf9vo/MeBLZGxmXTubvRex/st9Y5K4cZd0W5j+4yBGqs8ZO+z/7BAZywsmMIT
	s8uBeIHzDG69i/uTggVVmPqz2oSsr0Ky54TdkDIs0hz0h7LZJ6vDJFxFGrUjcDnQg1FVMXzRsgF
	p0cc89UuBf6S7lIe0p3VpKKk/O136DCMYmjkIh20v143RZRuHMcU1TbcpGxYd26rvp9EFuMbB6e
	9xS0ctzbjhea6PwWUna/8XXijRdDdTKAjX1bFKQUpQZK2e1GO17WxC4397ypnIVsW3pjJka4UUA
	816jpRzhCagJNlEidN/qqIG+sirycvONa98xAYD88k9tgY4XEnMpY85FUSzH9WuULsq8zZbKqQY
	nA4+9ziQSnuBdQ7Cq15Y16eXIcGB8PPx3n9vZvabqoJa3Olg==
X-Received: by 2002:a05:600c:1906:b0:490:d38c:7836 with SMTP id 5b1f17b1804b1-4926084aa9fmr29128995e9.3.1782288496763;
        Wed, 24 Jun 2026 01:08:16 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([141.2.113.191])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c1ee018e8sm4831624f8f.11.2026.06.24.01.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 01:08:16 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: yu kuai <yukuai@fygo.io>, song@kernel.org, magiclinan@didiglobal.com,
 xiao@kernel.org, vverma@digitalocean.com, axboe@kernel.dk
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai@fygo.io
Subject: Re: [PATCH] md/raid1: honor REQ_NOWAIT when waiting for behind writes
In-Reply-To: <868207d0-d20f-42e8-8257-f57816987bf5@fygo.io>
References: <20260611083514.754922-1-abd.masalkhi@gmail.com>
 <61361f20-f81c-46c3-bdd2-3de24e90a0aa@fnnas.com>
 <m2y0g722bp.fsf@gmail.com> <868207d0-d20f-42e8-8257-f57816987bf5@fygo.io>
Date: Wed, 24 Jun 2026 10:08:15 +0200
Message-ID: <m2echw1hu8.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 24, 2026 at 14:39 +0800, yu kuai wrote:
> Hi,
>
> =E5=9C=A8 2026/6/22 2:08, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>> What if on a partial nowait failure we just end the master bio as
>> success, but set NEEDED on that chunk's bitmap counter and start_sync()
>> picks it up for resync? That way we don't have to decide why rdev2
>> failed at all, resync just copies from rdev1 to rdev2 without nowait,
>> so if it's a real bad block, end_sync_write() records it then.
>>
>> We kinda have the idea of ending the bio before the write lands on all
>> mirrors in write-behind already, though it's not quite the same, there
>> the deferred write still lands, here we ACK after it already failed and
>> lean on resync to redo it.
>>
>> My worry is the loaded case: AGAIN under queue pressure isn't that rare,
>> so we might end up triggering resync frequently. Do you think that's
>> acceptable, or is dropping nowait better? Happy to prototype either way.
>
> Yes, AGAIN under queue pressure isn't rare, and I don't think trigger res=
ync
> for a nowait IO failure is acceptable. This can cause lots of offline IO
> pressure which will affect disk service life. Meanwhile, resync will cause
> performance degradation for user.
>
> I still feel dropping nowait is better.
>

That makes sense. I'll drop nowait for md and post a patch.

> --=20
> Thanks,
> Kuai

--=20
Best Regards,
Abd-Alrhman
