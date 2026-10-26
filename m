Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793026628;
	b=c280Y3y/EAwVYsYmtOnvtR1nN2+QXjrlWC5tA1sYl+Xt8pcOLJaUjaqA+enJVRB7Ltw8
	 OuCgpu3IEmiqx1xdA8eeGIn8pRRWdFhh096n/kC2IwK1NarkKN3d1SSuaQB8PerDnz6nt
	 wa2yC7iUsTcMXOyOlVrz0ZflOiN22Ss7lLgLbNRo/iCIHqPXOcfZ8w+O/KaJTM5L4oSh1
	 wPv+eMacVdEf47vA4BwAfMxWEUpgps+9llMuAJV573CGndKsddfA+dxR5/njzUeLYdyT8
	 pa5Gp/LOZfaVmqcgzZcPDXI55bpgWeMgoBSY7C17R7APhhUc1vGLndnsyNvgEN0ZIPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793026628;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:In-Reply-To:References:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=r4TeSRrJfvEb9bXGYtvTmzKxtpAZeorrt+MbujrYaNo=;
	b=X7865anJBKtn0FbtP2QW4ka357Er1M2y68ECYYeaXZET5174t5Y1N8bwP6cUTnlFxMFL
	 E0StdasfTDRy8IhcYxVkcfn/y8qMkeltOQuXywPaJZbxbgSEozkEvNKwXvxyGGPkVJy/j
	 c8iKJPl6goE9Z9Y3x2IkKq74b86uBtDeSKO/IgLC0rhrbcTdC66vIKyZ1GBQ936GVuaec
	 f12Ua8D0iiH6PyjLTyLSOAf29l1UHdATanilyHAa9idVuA4/s8Y0ySESQ9PkCYV/3Kyd9
	 xHRW4FjcNfNAd/KT89l86n6/+Y9szuIdv75K4q6AXY87LzK3YOtrv2YpfgdZ7gTuKPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iNVvKNRO;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A5A606A31E
	for <linux-raid@vger.kernel.org>; Mon, 26 Oct 2026 14:57:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04A5A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iNVvKNRO
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a20a37703bso23805015e9.1
        for <linux-raid@vger.kernel.org>; Mon, 26 Oct 2026 07:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793026626; x=1793631426; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=r4TeSRrJfvEb9bXGYtvTmzKxtpAZeorrt+MbujrYaNo=;
        b=iNVvKNROw0TJV/07MSUPeQWkiFUyo/r8Mun0JgwcYN1aZGEO0Sv9204nzc6yLc+hls
         lVDl0aZxytSZYw6BSeTenz/KJCMjoIb3xqnZcqJByX9Q1EVWAOI4/EPnmwvYoqYnj6dd
         x3IhiPjf9SGcxTw9rFWvRlZWALlhTOvZHCIyZSp43diZHDSMZ2IxvGB66IJT+IVb/U4T
         xUqg6QFK6dKmeVQ7PYbVwsYmJYaeHZg8gB7z8rmiLz9RLTzAgFaL21Re3C9M8ShTE0WW
         XGN8R0/rpsSwV0e9tmEqkvS8gli54EjPIrO8yhunGeG3DJ2Xh3hXiCO6wU93iVLhlOu3
         bZEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793026626; x=1793631426;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r4TeSRrJfvEb9bXGYtvTmzKxtpAZeorrt+MbujrYaNo=;
        b=W02CKK9WDYSt4atr2ErsU3cnu2zSQrEGm7IqaGlaUEI3YtFgseIBFOzyXLGjGp7zYm
         nY0v1aI/TfW0DuydSTdEaIS+50H2hEIcV6Xxtkg/BqKkubNqn6dCZdkMabNYLVDILw5B
         63PxjFif95BGxYwDkOgB5aC5mTHx2nUXnrPcxtGULkUTaAva5sLfkBpfq6E9qBMVLy0X
         Y61C8mH6SRjQrqTLc2+/T3VsYo1ra8jPJ3gYU6pmETHGYlh45H+xyu5sslMBRgr2WYcj
         ml+RFcNO4oMYLXac7xtNWvUFeXgMHfkzmYpVPKJ/sQ1gAyKxzwIDX1KGTHhT2q+QowcC
         zb2Q==
X-Gm-Message-State: AFq9FYJwfzgpS6STKRv4qMTQxNdRv+7Xh3c2lOQ3LwolxAsRw5YJgUOb
	L9IwUTus9jP2K/ChTFIj/RaxFCqjaIE9uVUSoms3y7P7A/0TyNwV5Rt7
X-Gm-Gg: AYBFou1WrVNFjpltfCfn3uuQ6bUHxJL+eMca83ul/DBQsx6VMpwogJx7FoPJ4rBu9+v
	vHZOPM/9X5r5rF+QH/0K29WSMfuHdIbPsQ13PzSyXP6My9dL0+KRBHeqrcf2axIC8KtUh3F2gSv
	92b2Xx6y4g+uB3uwJE/4WsgRnGADt0VIXQqBD2qmKMzRjsgpf47tSnaelAe9CTnQpNZ9Jrm28Rx
	cJ4isLM6rpRTTqv4QruExp91L0+HwftSfpunqd+3cHdUWaNTVRsnfQujJ/Pafziw+erFk+ZqKrR
	nFi/WRqeLTarvI8V3sU53iMLc7Kfo00rZT9nyhXnnSKaQ8P+dLvOzm82g2/Hxqx/Da8uae5R/jJ
	NCRsKqjiDZMfQiFLrNk8//J9xFGmT5ABNNhOzS/JLGCJffXvBfrP0Q9BefbwQZDz70ireg/CoHq
	1qU2+z4SEBXm6nrRMVSbWU6INuW2lvTYcTCTCqG2El3sARXxj5rXbTNvEkDENrYix6Q+3APAbsQ
	FlsuNe6G5d0pXP4ahEahlzUhQN8Uyse9ELInRmSGz/klxMTDmdUHLoGa6Kh7Fr/5eFyDLyIoziv
	nvniH1WeX2byqPDo
X-Received: by 2002:a05:600c:83c7:b0:4a2:c9b:9b98 with SMTP id 5b1f17b1804b1-4a35ac95f44mr128561225e9.17.1793026626028;
        Mon, 26 Oct 2026 07:57:06 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a07ebc0sm94940725e9.3.2026.10.26.07.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 07:57:05 -0700 (PDT)
Date: Mon, 26 Oct 2026 14:57:04 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] raid6: simplify CPU feature checks
Message-ID: <20261026145704.5601466f@pumpkin>
In-Reply-To: <20261025191207.86590-4-ebiggers@kernel.org>
References: <20261025191207.86590-1-ebiggers@kernel.org>
	<20261025191207.86590-4-ebiggers@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 25 Oct 2026 12:12:07 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> Remove unnecessary checks for features that are prerequisites for other
> features, such as AVX which is a prerequisite for AVX2.
> 
> (Note: in most cases arch/x86/kernel/cpu/cpuid-deps.c warns about
> missing prerequisites rather than enforcing them.  This is intentional,
> and it does not mean the prerequisites should be checked elsewhere.)
> 
> Then, move the raid6_recov_algo_add() lines into the appropriate places
> just above so that the same CPU features aren't checked multiple times.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/raid/raid6/x86/pq_arch.h | 51 ++++++++----------------------------
>  1 file changed, 11 insertions(+), 40 deletions(-)
> 
> diff --git a/lib/raid/raid6/x86/pq_arch.h b/lib/raid/raid6/x86/pq_arch.h
> index 4a863b253b909..418e4d4a2930f 100644
> --- a/lib/raid/raid6/x86/pq_arch.h
> +++ b/lib/raid/raid6/x86/pq_arch.h
> @@ -16,63 +16,34 @@ extern const struct raid6_recov_calls raid6_recov_ssse3;
>  extern const struct raid6_recov_calls raid6_recov_avx2;
>  extern const struct raid6_recov_calls raid6_recov_avx512;
>  
> ...
>  static __always_inline void __init arch_raid6_init(void)
>  {
> -	if (raid6_has_avx2()) {
> +	if (boot_cpu_has(X86_FEATURE_AVX2)) {
>  		raid6_algo_add(&raid6_avx2x1);
>  		raid6_algo_add(&raid6_avx2x2);
>  		if (IS_ENABLED(CONFIG_X86_64))
>  			raid6_algo_add(&raid6_avx2x4);
> -		if (raid6_has_avx512()) {
> +		if (boot_cpu_has(X86_FEATURE_AVX512BW) &&
> +		    boot_cpu_has(X86_FEATURE_AVX512VL) &&
> +		    boot_cpu_has(X86_FEATURE_AVX512DQ)) {
>  			raid6_algo_add(&raid6_avx512x1);
>  			raid6_algo_add(&raid6_avx512x2);
>  			if (IS_ENABLED(CONFIG_X86_64))
>  				raid6_algo_add(&raid6_avx512x4);
> +			raid6_recov_algo_add(&raid6_recov_avx512);
> +		} else {
> +			raid6_recov_algo_add(&raid6_recov_avx2);

Is that right (you haven't changed it)?
You get both the avx2 and axv512 normal algorithms, but only one
of the recov ones.

I presume these are added in addition to the generic C code and
some startup test decides which is fastest and so used?

David


>  		}
> -	} else if (IS_ENABLED(CONFIG_X86_64) || raid6_has_sse2()) {
> +	} else if (IS_ENABLED(CONFIG_X86_64) ||
> +		   boot_cpu_has(X86_FEATURE_XMM2)) {
>  		/* x86_64 can assume SSE2 as baseline */
>  		raid6_algo_add(&raid6_sse2x1);
>  		raid6_algo_add(&raid6_sse2x2);
>  		if (IS_ENABLED(CONFIG_X86_64))
>  			raid6_algo_add(&raid6_sse2x4);
> +		if (boot_cpu_has(X86_FEATURE_SSSE3))
> +			raid6_recov_algo_add(&raid6_recov_ssse3);
>  	} else {
>  		raid6_algo_add_default();
>  	}
> -
> -	if (raid6_has_avx512())
> -		raid6_recov_algo_add(&raid6_recov_avx512);
> -	else if (raid6_has_avx2())
> -		raid6_recov_algo_add(&raid6_recov_avx2);
> -	else if (raid6_has_ssse3())
> -		raid6_recov_algo_add(&raid6_recov_ssse3);
>  }

