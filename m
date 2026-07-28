Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0309441F368
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 09:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785231023; cv=none; b=U6Pc8L8QEsm+2HJikzV1+D0JR7a1wOKuSpHLiDZ3WhFSgjM5Ed5NNSe2QLiVB0mthMlxxPaVZjYPFsOVZD+BXtrg3XpFgnWlmgrch6P3mj+gcEsSaVkISL4jXRHJfhjavs8CEgaIwQ35Zfz4g+qk2xF0a8fStQrxnCsJv9x+9bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785231023; c=relaxed/simple;
	bh=5birTs3jZadiSM71ETEkOn2VcKNyOlS3GF0BwSWxb4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fL52i/J4t9a4dAxnPG+c43A60F8i/ZJLq8dsJ/EqIc+RANH0K15nojA5nINi/rp+Kv8X9pT6bx62AI15msVFXYxEdAG0a2/WShbTE5IvLu6A/6yqlViyM9M2wpRJYLhRJCQtk8pxAKrK1rhHOVhmtOINtPE1J1HF+0aRHy1z0nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qdfn5M+9; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qdfn5M+9"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4955de8797cso22908035e9.3
        for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 02:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785231020; x=1785835820; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fd4u7HbSw7LmAIg2c748Ol/BOezHkKcbVf+2ouQF5V0=;
        b=qdfn5M+990Eb/ueBBcYv4rI4czjhL32WeHkZFSAwMUANwR8LSeNpH9aJ042VXMwygF
         ilJzjV2kFlmv8zcvodkKL6qEEq9OLAEUc8cG1tReGvP/w6VrGzYTJCN/2IXLqS4FiuPW
         CAlnz2cyfJg9e1dct16QM0RR31YC1zXwXuantdTNbo23qLau2NL3cvQvFw5RrUVZ9tR2
         69ejLOml3G0SKy9/U9MZCK/Ic5d3i13kxbul28Uk7Dg1rc9gPkWMRbb2oBQCBtXOrgB/
         jR0/3u88g+ms7a6sUW2hWd4AH2mMI8mm8zfa6m9kFgp1MQnCnexOdM3Gy7QrMDcMXCl2
         obHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785231020; x=1785835820;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fd4u7HbSw7LmAIg2c748Ol/BOezHkKcbVf+2ouQF5V0=;
        b=ZODMpeuL0AUEPS4mqIlFRc30wRrr3FsmYiDx2IUzF65yBUafmWwic9O7v5sSNaWgtd
         P5bvY5EHwzQ3E7S73T0c4/7Jo5G63caoxk0cIN8zlwJ4e6PUf0Sx8/guf81JSd0dLw2l
         e5+MMgkWwlr1hB7aKqrL8qGKzouycRkdaMFxsr5ciGLcjyXxPAWFV0bQaYJTe7pFYalz
         uaEQJ35WhS1ijjmnW/Lrvj5X9OwnLTm89tCXmyi//UBPmIY5INfW0tu2jBXCwaQb/8Wz
         qbGyyeaQcGJKkm8JZ9hqsaf6IR0U+rRVay1yGUifGQkV9iIlvtTkC7JollZjUxduvp1+
         a/cg==
X-Forwarded-Encrypted: i=1; AHgh+Rr3WUR8jNT6oYKD0r0s0jbM+ZAdev4iayeVsudQGTQrzoEzwznoprjT/I/Ek9ttb0tzAYDox/yndhIA@vger.kernel.org
X-Gm-Message-State: AOJu0YxF9EydYnyK5+taug/2SG4W4ECOWp6euXH+n/AToJZ6+8TsSPbB
	WaulQrDP8GhCTZ+1Bcn6aHv80jhKO1aq4IFZGzhBmzZNBt6hLN/lk7ft
X-Gm-Gg: AR+sD10aorTpzl+VBVdkWrL0DvJd5jY1rkL+tx1pzv/SDRv3gPDt2/LS48GkAF5fwis
	k6oCZOTzaG1KTe9f6HpF66dZm/XKmRmHTeugbvEcpVbkmfD6qBXJoisOEDCCGwjW8LFKZAAfEZ6
	FgqHZtGGO78j+WpqEzQJKzJcHqtTbPlDRguIjwfJbbbyFKM6ffTz/o1U+n4QVl25U7fWKqbdllB
	LNL//xXk82Cp5oPm71BmQg/srjz2mqHwQoPlkJW5JhOfcfvAnYzIIaDYELex8cB3ZReneYhTBDz
	AJgvQU2XX08Fb+9/3M5078T/HlK5Xk5kCDVEoxrPRZTFEG8ekMoWJJ3E00iIp6YE+LYQH/5Ei9C
	1MdSMiwzK5kuoep5XogUQ4f1K/yb3dmVZcSBQrmlnC2fRyJM4iky1/IOApcBxHTBKxddcfMmXvF
	LNq/JTm0rJjP600DgHR3pNJ36AovOVBWqlMPGSPRE=
X-Received: by 2002:a05:600c:310b:b0:495:779c:fbef with SMTP id 5b1f17b1804b1-496c65aaf28mr16540495e9.37.1785231020039;
        Tue, 28 Jul 2026 02:30:20 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c44b84edsm99732275e9.5.2026.07.28.02.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 02:30:19 -0700 (PDT)
Date: Tue, 28 Jul 2026 10:30:18 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
 linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/8] crypto: x86 - Stop using cpu_has_xfeatures()
Message-ID: <20260728103018.00938ac6@pumpkin>
In-Reply-To: <20260728021603.79870-4-ebiggers@kernel.org>
References: <20260728021603.79870-1-ebiggers@kernel.org>
	<20260728021603.79870-4-ebiggers@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 27 Jul 2026 19:15:58 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> Checking both boot_cpu_has(X86_FEATURE_AVX*) and cpu_has_xfeatures() has
> never really been needed in practice, and it's never been universally
> done (e.g., lib/raid/ omits cpu_has_xfeatures()).  Nevertheless, both
> x86 and UML now explicitly clear the AVX and AVX-512 flags if their
> xfeatures are missing, which should remove any remaining doubts.
> 
> Thus, remove all the calls to cpu_has_xfeatures(), as well as the
> related checks of boot_cpu_has(X86_FEATURE_OSXSAVE).
> 
> In a few cases there was no corresponding boot_cpu_has(X86_FEATURE_AVX*)
> check, so add the missing ones.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
...
> --- a/arch/x86/crypto/aria_gfni_avx512_glue.c
> +++ b/arch/x86/crypto/aria_gfni_avx512_glue.c
> @@ -196,24 +196,15 @@ static struct skcipher_alg aria_algs[] = {
>  
>  static int __init aria_avx512_init(void)
>  {
> -	const char *feature_name;
> -
>  	if (!boot_cpu_has(X86_FEATURE_AVX) ||
>  	    !boot_cpu_has(X86_FEATURE_AVX2) ||

Doesn't AVX2 require AVX support?

>  	    !boot_cpu_has(X86_FEATURE_AVX512F) ||
>  	    !boot_cpu_has(X86_FEATURE_AVX512VL) ||

And (less sure) AVX512xxx require AVX2?

So the extra checks could be reduced.

	David

> -	    !boot_cpu_has(X86_FEATURE_GFNI) ||
> -	    !boot_cpu_has(X86_FEATURE_OSXSAVE)) {
> +	    !boot_cpu_has(X86_FEATURE_GFNI)) {
