Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A20C3E3D90
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 09:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783676557; cv=none; b=t73rKo630dWfTc4ZavaEv6xjcaA9Gw4COscRNwWulnMtOYTKvXNeEtal6EL9uatFFIKLuVGP948vsfWQ9bCnObfJt8xD87zJLCd3gTn9UrIjWP8NmfkZ06PMPu8X3R7xBJ01ircpLsW1AW8gf/LmWbedYZnyo3fm+6qrqJ2LQ2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783676557; c=relaxed/simple;
	bh=xFH1rD3UNKEwCfdYVeHdylrKlpH4ZHCenwweazMVWcs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gW+vzo4XCy/+tz3gthhmpM2jMDxMDgVHYOn2CKZ7QLGA05WKa1Epb5E6DeyfRG7o8wz2OtcSxuMbLLQZUEAE8P1oQvetM69W2H7/1FCSek/1RGf6zKb7sutChtyEh3oy9k5qYW7Y2v06wm375WPAKJwSu/s8fO/fpcl/IjSm3uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IpeVesOg; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IpeVesOg"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493b779003fso3083805e9.3
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 02:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783676554; x=1784281354; darn=vger.kernel.org;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PxqgrnbODxEIpAImap5RWx9OoAsN974AT1Di2zs2rHA=;
        b=IpeVesOgf5SGsJw6cwnFgMmUSwOeJZDskraZ/F5GcUl1EgYkFE5GeT56q6jA6YvDHZ
         5j3jCb3b8WOyLZv5yYkhe+d8PD1u0DdvjQkbDtqzHGOSZh1ERHIHUyNFk6TRu+6ZJUoE
         VAnLl55wPJ1Gm5Kb806TIa/DITWKpnwyr9iOP6Tp179W99DMT59WK+NT/OdZ++Iq6BzX
         qIvMvUGxDhy0yIA7TFRDxsaS7AgMILqfpG4VnbjFnid1k8NRluK4SYpkNrfdhPmMBXH7
         TPWZLQn8RqyhOWFffkChtFKh2sBo/qQEumkXwttPyW2GNgmLOAXAKTj1nRyf+mljbb78
         id1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783676554; x=1784281354;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PxqgrnbODxEIpAImap5RWx9OoAsN974AT1Di2zs2rHA=;
        b=YaVHXLp1FApnCE7fSjnT3Zr827VfvlsaNQWagbAir/M5qPNFVdgzcN6rpwQDWIAZo0
         2IftqBpNgVkXzyF4ISTv9QaVGyaFcI/Y1wsN/xxPYd709JH0AKvAKuWclDOtXq/EnZ0w
         nQHv9MVdlByLDX2yZfO/INt3Rr459vV3uIamjxUaL7A+0b21tXY17TRPI1SLOgBqIsRT
         0QR6j52sa9rYBMDUxDubrww/zZqb1Y/9qNWlui8t95ICTsMbD/5R7VznQdwa583YiuZ4
         aE+7hjn1/hPCWxxDZ9ZT+VgY4k81nMNe3Ef+ZN6bKKsQyTVLy/ABHMYNgQ8kGUH/hKYK
         hbzQ==
X-Gm-Message-State: AOJu0Yxsiw/kVPzmHyTLtSYEKnmbvFbdAikkYSaHf+2yq6PRDAZYr/WD
	X1tOWiP1QXHdADIVnLV8K6RyyrFcV/qI8hQIKFdG0ET2Z/GMTbHrQHgoEltRuPJJ
X-Gm-Gg: AfdE7cnFzX4nH90igJzok48yIKPU3gGaqRdX6DuIFkGo4OE7BAgkpbLIwY0vK4f2pDq
	px64bUp93mgdE7r7kn1hfpr2SWQioKXhEXdZpqH7/eqn4cCUVNCLj6Mf+5D+u4fBJDi950tX3gg
	1Hfep1PG9gwDVD7kDDxUkNoZOuRDm6tkCU36tAX5MCqn8xxxtnf7ecxSNM3MHhNgJdRYMID3EZh
	ke2hfenT+CLYLE7dC31aUenP8Mjx+fDnrccSs88EkdwewK1GbLS3zSdLSwBbXpdnpYA+kyb9pSm
	zjbEWZ8kErKpW3g51l7pFu1Uudq05qoivnKK6TUfaXz4KFUvTF+liy2CqOI7IoOvH/9/btjENEz
	7/B1Eh4hIaLp73Q5354UWwYdYs1MUTj+XX0jlB1FMjw+f2TytCtBcAQYDroDspcUyzg06tc0IAk
	NFFA9LEYlI5E1lt4MIk7Yk6shnZg77unShLrdVjA7DxPlNAgaYChyaVS0PqHCjwmBG8A==
X-Received: by 2002:a05:600c:c16d:b0:493:a5da:e5d2 with SMTP id 5b1f17b1804b1-493f4fd49e4mr14403075e9.26.1783676553540;
        Fri, 10 Jul 2026 02:42:33 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:622:2a80:61e9:bcbe:f38b:f871])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6f3b85sm205135245e9.2.2026.07.10.02.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 02:42:33 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: John Garry <john.g.garry@oracle.com>, song@kernel.org, yukuai@fygo.io,
 magiclinan@didiglobal.com, xiao@kernel.org, axboe@kernel.dk,
 vverma@digitalocean.com, martin.petersen@oracle.com,
 abd.masalkhi@gatech.edu, linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH v3 2/7] md/raid1: advertise atomic write limits and
 handle runtime constraints
In-Reply-To: <350a2662-7de0-45e6-a905-76dbd0a99e98@oracle.com>
References: <20260708101341.473750-1-abd.masalkhi@gmail.com>
 <20260708101341.473750-3-abd.masalkhi@gmail.com>
 <350a2662-7de0-45e6-a905-76dbd0a99e98@oracle.com>
Date: Fri, 10 Jul 2026 11:42:31 +0200
Message-ID: <m2bjcfkwoo.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Jul 09, 2026 at 13:11 +0100, John Garry wrote:
> On 08/07/2026 11:13, Abd-Alrhman Masalkhi wrote:
>> Atomic writes in RAID1 must fit within a single barrier unit. Set
>> chunk_sectors to BARRIER_UNIT_SECTOR_SIZE so that bios which would cross
>> a barrier-unit boundary are rejected by the block layer before reaching
>> MD.
>
> More accurate would be to say that we restrict the atomic write limits 
> so that we never produce a write which straddles BARRIER_UNIT_SECTOR_SIZE.
>
Yes, that is more accurate. I'll update the commit message accordingly.
Thanks for the suggestion.

>> 
>> A bio that passes block-layer validation may still become unserviceable
>> within RAID1 due to bad blocks or write-behind constraints. In the former
>> case, complete the bio with EIO. In the latter case, disable
>> write-behind rather than failing the bio with EIO.
>> 
>> Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
>> Fixes: a4c55c902670 ("md/raid1: simplify raid1_write_request() error handling")
>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
>
>

-- 
Best Regards,
Abd-Alrhman
