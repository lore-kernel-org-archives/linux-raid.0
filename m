Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5392B4A9D76
	for <linux-raid@vger.kernel.org>; Wed,  2 Sep 2026 16:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788365230; cv=none; b=b5n/Hr5emoVYSZ++OAJJj0oZqiz5orfus6W3abdjKdfrM3LLrVuBRG2n44zNCUiTY3DEeE+vQnMN2iL8OlmipQHyq0jEI713Xlej3T9HKmNlS6uCYcV1HDskGjkbVy7diJq3B4FH6svjbcBp3dPvQp5HQXXvvfvMEYpynGExtnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788365230; c=relaxed/simple;
	bh=byZTt5R6BjpzTu8+p8/eAxBr5GXUWYt9qNckwpzaZvs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qrxTijcJ4v9wvhkhIzWGh08JYudYjai9G1BlCdLzdo39AWr2uyHby4PyDMsL7mS1taQ9MjY/fr1GLJTpVS83xvyZvzecrRY7ICU5inLjZwUNP/FOcHpV1Lxs63T8E7/KpxUA20HimvtnDn34KjAq+I7Dqw9RpyEZRdRSGoIV0GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xp4exYyY; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xp4exYyY"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so11569165e9.2
        for <linux-raid@vger.kernel.org>; Wed, 02 Sep 2026 09:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788365226; x=1788970026; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0jnVwXo8Qv+75toQ73l7dAA+32JWKJPezOLtyqrUA2Q=;
        b=Xp4exYyYpT5tyUME3p1PWfQsqIkGqo/wS46qQm98CwI4mVFkw/z1IphW+NUjRhWG60
         4ltumy3caJ8tkGAGusoxicYN6AxRcLTXNvPWhR4rrwFWc3nuYVozXTFAGf37EAa6cAMS
         dCuG1Fmd25PmXM8DwhfXr1GzN38/Ken7yy1NrxH6yUsFf9V0C81ZsXyLqXNxizGmtMnU
         lhogqrx+4GskOwp+SyP44dAuj7OqZEx/Q9kzmcz82WGcGzbeD787LfxANiFJa5wXb2Ym
         Bb7dA9Xdo6kUti1V11rMUrbBn18nCD+b8DeKcAzuDCKGGIWGxLcSauTOZxa3fiWZ9d2A
         9QTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788365226; x=1788970026;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0jnVwXo8Qv+75toQ73l7dAA+32JWKJPezOLtyqrUA2Q=;
        b=q5zuleI45U2VGeDHAGO1tLjkJ2TgAEcVz44MOINaophVUNSle4ssgqLLbq5XlT75rO
         +EvMBAbnmwkF1BZHZpujs7hn8vsxIWAOj06QX7spnKLs6EXh9tby5NZg8MkuCEqoq7w1
         g5oQJXpFIHr0/XVvm5hb9xY+2ANpRMuybGsjkcapD16J68e1kxdtAnOwHOF3Gkx1pA5y
         RpejWUjeb4Qk+pNxMKC8022GZqQU4p8K+eN/SbIsbhJJby/9Q/1OtVgYU597MqPGsmfL
         MttWCDksor4R6ty+tngFE/1bGavi0UZ9odiqFJlS1I9Bpm99jhjWMm3i9jjQ9IJlBLYc
         F/MQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp5gtxS1qZNPhChtquqgKKHUU4XZEhB4Y1tW7C//tpnz6wD1BpV49kLSt4LyAPmVXMV+ICwN9yd6gJ0@vger.kernel.org
X-Gm-Message-State: AFuF++n81qWLrk50sCBWn1vw1B+BYuxLEiPJh098SrZguOqf7zBvDI+i
	VYeDOLwB73xG9o2e9eXdCBdZWyMHIev+Ek4FAyuJDuCxAu/FEB/nONDg
X-Gm-Gg: AR+sD10GD6LIy1y0UaWePN65yTiisSPWHy3F/NBBYpxyC6kgW+W7BW9DUaIUk8zuXkn
	1g66kgHN/9Rn44DiEkfPsOTSkBimSMmXZQoZiNwtMPl82IXtVW6NDjB/cwW59bIfNj81kRJDGb0
	Tw7JLICd/AdmJ3sjcsr7ITAk64WilmFvVDHUpLi0++VDov+0cJ3oyEZRrD2AymGvTCCjdBtH/iA
	4S5q5H3KTeA+PURmsQ7l00KUHIzMEY1yYcNiZetNau6Os3eTBhXDJVXctTBFXI/dSEv/lIzgNMx
	8y+EhvWufVoGP+mP6707LlMMMzHsB8ZKKCAlHt1TI4US+i0bJ1UvzR8PXZewf+EJFdDMVmUi1gL
	ubzWPcx39TfD5Wc076RYB0qB5/Ou+sDpMKwN34i+YYsDKWAZmWNkLicBJWfiAZ63a+kAFDfMlyS
	5tL3WmV1ASfixn+LfrwijaANwBIihaUv2/xMLYSumQqBKHOOhiz/zIA7/sYw4dWMoX9nTHxTBqm
	BY0yLZCy5a7PcxqE6Xf9eg6dA==
X-Received: by 2002:a05:600c:45c4:b0:499:79b9:e220 with SMTP id 5b1f17b1804b1-49ce5816186mr109276985e9.10.1788365226253;
        Wed, 02 Sep 2026 09:07:06 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5d476esm2206255e9.1.2026.09.02.09.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 09:07:05 -0700 (PDT)
Date: Wed, 2 Sep 2026 17:07:05 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RESEND] xor: add missing vzeroupper to AVX code
Message-ID: <20260902170705.213d432d@pumpkin>
In-Reply-To: <20260902133706.GA21538@lst.de>
References: <20260831212248.213805-1-ebiggers@kernel.org>
	<20260902133706.GA21538@lst.de>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 2 Sep 2026 15:37:06 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Mon, Aug 31, 2026 at 02:22:48PM -0700, Eric Biggers wrote:
> > Since the AVX optimized XOR code uses YMM registers, execute vzeroupper
> > before returning from it.  This is needed to avoid degrading the
> > performance of any later SSE code that may happen to be executed.
> > 
> > Fixes: ea4d26ae24e5 ("raid5: add AVX optimized RAID5 checksumming")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> > 
> > This didn't get taken through the x86 tree.  Andrew, it seems you're
> > taking patches to lib/raid/.  Can you apply this one?  
> 
> Can we do kernel_avx_{begin,end} instead of having to open code
> and document this everywhere, please?

In which case I think you want the vzeroupper in kernel_avx_begin().

Actually, for some cpu at least, you need vzeroupper in kernel_fpu_begin()
even if the code only uses the SSE registers.

See: https://stackoverflow.com/questions/41303780/why-is-this-sse-code-6-times-slower-without-vzeroupper-on-skylake
Basically, on Skylake, all SSE hit a penalty if any ymm high bits might be non-zero.
Don't know what has changed since...

I don't have the Intel optimisation manual downloaded (ok, I might have
it but have NFI where), and the link on that page is broken.

David
