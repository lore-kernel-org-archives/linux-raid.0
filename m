Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACED30F803
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 10:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784109942; cv=none; b=NTbLpUZVc6XmnHUh9cFCjVXTCf0r1A3/XLUqVaGFs/wYzWaXH319BWwEdzaxHZYBjKclJYrYCvOkvzPLyxTReoh/Dm+ATG4ma8Y7mgbkPfsMrBvxFQ3I1RG9FK/lgcUkNDoaPZ64rSSkjV4B/R1tVzEMFAZbgXkXx0LeR4wQSnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784109942; c=relaxed/simple;
	bh=Ux0F0Qhdjpc3kA+spVxS3uX+ga8tQBOxTm/Q/+IrdxA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YX8V0vpC59awaXDIO6fyicqrUuf48CH4JK1mvik0OyodHCfidmzMW/txzV3AMqvo+3IwGpwzq7zawipn2mQ0CqxiH9AiKtNzsUVB1fQJ2NjpiT2Rzqlx2tS60OQi52hlCAwpPWVFogp5Cm/15FI99Rk/KnnJgTgepe8NhKFssGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sFOO2xLF; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sFOO2xLF"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47ddf7b09aaso3587290f8f.3
        for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 03:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784109939; x=1784714739; darn=vger.kernel.org;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0gm93EXu8tVWP7J4vvZFy9rPp6hlCa+L3OB3X8B0H68=;
        b=sFOO2xLFlE6DP/M1Myqhld/AwJnIbT8q5gXa40Kl7YrF6WMRhxRpuVqYpWiSUYensT
         pPn9lvuAJcw3NrqWJ4z11NuJ0bae/EupVlENPZbBVFAFppkxs5k1NZUH2MIkprY9KK5+
         7EC+BpJnd8YwUZk5naiQm3/CGjzFY1eWYpkXcrrQZCcsIuPoqEdDrBpc4jxhQXT1rIeK
         VGCQW6FK5cZxMvFreM2VSt45NpeuXjRoZ+aN480E8qC8EINtP6HPDeg4Cnz3TU5YE2BH
         PAm7SqOqtPmP5dEcNIHM2erfqRqTO1nhl3UHdS7GMeWUHolDvqMak+xaftiZ3/P3kW1a
         y4Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784109939; x=1784714739;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0gm93EXu8tVWP7J4vvZFy9rPp6hlCa+L3OB3X8B0H68=;
        b=ZDydNuWfacehoP0YarFLEeOxVLgdi8pZ10uLb43/BUv4gQPrg2vQTqV/a4xlavNLNj
         4NxxVg8F9skt6WhuIIxppP/2H7+gcWE8TcmyJ8sOSQbDvPMMNMjyo5+JIkLVxokkbNqz
         xLiXMnTOECZXIirYJnjEBfxUwELdDJlyXqAtdp/X4rZQF3GM9x2lOuAYZtykqYxWneOP
         8BjLXW3MFfORjGVtTHqj8p0T2+OkoMD+sczbtZtUr57k3mGENgVucf6+5BDGYCtRPQ7Y
         HmojiSQyCjmbPynIk2Z4AuxMC8+4KeDkJkoQswxMugNUI2MnplMbHlX17+Z0JNCLyJqm
         WAlQ==
X-Gm-Message-State: AOJu0YxnV7VFQN+XZjFHSM4BewWrAlULr4JBeCNcUwycCwpcO6H5mDIt
	g5e89dcFQ8z1eC5rsMVvV4tDKcSmaR/EYNl8iUyNquxFPT7bcVGnWzLUDE8VPQ==
X-Gm-Gg: AfdE7clUZFkKVGu8ueAHa/l39ZWFH8Uso2f1TWKblsmsFjpMj/L3p0Ts1ayBEVAOFoq
	A2grPdIy0uoWMpACy8YTRTOO/xVNt0x4Q41poNpbOvAr/A/zGdQhuJqxQhEY9MVRRhyy0Yv+OuK
	ktuB5kGVRi8yMxGN4xGNi2YkdvQfQj/92IndwgXyec0MHCgiXfLKtzH8DErq0k/Q17qQY0ul+jS
	ZTszUF/946kJDgQ+vnnE1MTaEKgF2QdnkH+ZjEgTZegr5kPnOL2eKetMAUBMWCrc/KOu28yKa/J
	IG8DUU78uvCW5KzfHn6VQA8pvcKJXxI8DHYm3GUnJ/67MvpNAvCHcNThrBFoBNFEDzuQMZJXTJO
	xHhqMV+gQK6KtkqD0q7/xg/7NYoOME/xxTW8vsSVQRw1XmShEA59gwaEFzWNfJt5UhaJYhUbws0
	VA0dqG32vbWfEPQ1X4LgONDdIkjZmO4oon2XUrZNYHzzw4trhdfp9QZ0Q=
X-Received: by 2002:a05:600c:1f90:b0:493:f29d:d591 with SMTP id 5b1f17b1804b1-4951832618amr73205035e9.39.1784109939257;
        Wed, 15 Jul 2026 03:05:39 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:666:1871:58bc:7d51:1d31:ba60])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495087366c0sm253289385e9.7.2026.07.15.03.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 03:05:38 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: John Garry <john.g.garry@oracle.com>, song@kernel.org, yukuai@fygo.io,
 magiclinan@didiglobal.com, xiao@kernel.org, axboe@kernel.dk,
 vverma@digitalocean.com, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH v4 3/7] md/raid10: consistently fail atomic writes that
 require splitting
In-Reply-To: <33aca226-f744-45e0-a137-1f85ab146e02@oracle.com>
References: <20260710101521.1714-1-abd.masalkhi@gmail.com>
 <20260710101521.1714-4-abd.masalkhi@gmail.com>
 <33aca226-f744-45e0-a137-1f85ab146e02@oracle.com>
Date: Wed, 15 Jul 2026 12:05:35 +0200
Message-ID: <m2tsq0eff4.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Jul 15, 2026 at 10:25 +0100, John Garry wrote:
> On 10/07/2026 11:15, Abd-Alrhman Masalkhi wrote:
>> RAID10 currently handles one badblock path explicitly by failing atomic
>> writes with EIO. However, another badblock path can also reduce the
>> writable range and force the bio through bio_submit_split_bioset(),
>
> What is this other badblock path which you are referring to?
>
The other path is when the requested write overlaps a bad-block region
from the beginning, but the intended write extends beyond the bad-block
region. In that case, the current code silently reduces max_sectors.
As a result, we end up calling bio_submit_split_bioset(), which
completes the bio with -EINVAL rather than -EIO. This is the same issue
that existed in raid1 and was fixed by patch 2.

>> which implicitly completes the bio with EINVAL.
>> 
>> Fix this by handling atomic writes in the common split check. If RAID10
>> determines that an atomic write would require splitting, complete the
>> bio with EIO.
>> 
>> Fixes: a1d9b4fd42d9 ("md/raid10: Atomic write support")
>> Signed-off-by: Abd-Alrhman Masalkhi<abd.masalkhi@gmail.com>
>> ---
>

-- 
Best Regards,
Abd-Alrhman
