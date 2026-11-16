Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794867264;
	b=hkcRONrhAZwg3xygNWAKtctfcd7f03u1Zr84iBnynkeWDvbkw7ZQfqgNyy8HqmOBXfb8
	 2YzSiP82lFAy7s6Ubh/NlfS/Z6c/XYdY30KynRqk6Fm1jwQ7PC4Ta5Y9DdvHrtZey2yJ+
	 xvbdqA9t6WbELbTQurXIRJjZWw07Kp4x+/5KFxeQ8lsPzs1b8/iC/gifZiVsZrG6xZEIY
	 oPaYntJK2SRdggQfoRZLFUeCTrMz49S8xChY9Hyk2tcU0r6P29BQyvOeePCknNQtdA9tt
	 PYWDYxhMnq1/qKwQikAfkOcsJGJyBBgJzGD1KuoxzrE9zx3KhWCfIS+YbLn46D31QVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794867264;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=OHWSdKyMsFGERyYaZ5X8roMwAxwTPbXTa9d588Vrarc=;
	b=bUTztXaOLdyZWCtytPAAbxtVzFTrhYGJG4cypdyCIdJaQsNZAF4l47V3cX3dEqkMuvoW
	 FF9Id95f8OdQxtnMbXHfam8SHuTnR8sOORc3DfpMknGvMauaxI/cdCfnX9LtYAPis9KOq
	 gc5ylYkzJMEvsDnp2CCfDo5yliJyggJ8MVZk5j4WPIAj6a0TA00MwS3LWcPD8e1th+v09
	 8KTEjS8P7vP4t9npVzc0+4m7crxxulsMa2ucQVwP2p8BnbmCMXD/F4vgEihozXXumgxJ2
	 B2f14h/YwxJjTvD6j9gL5FxT3XiU9zR0hYZ9lqQyRlyHWJWLFLQPfW+edeRWisNEHSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bn7G40PT;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3C7606A31C
	for <linux-raid@vger.kernel.org>; Mon, 16 Nov 2026 22:14:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA3C7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bn7G40PT
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso41333815e9.3
        for <linux-raid@vger.kernel.org>; Mon, 16 Nov 2026 14:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794867262; x=1795472062; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OHWSdKyMsFGERyYaZ5X8roMwAxwTPbXTa9d588Vrarc=;
        b=bn7G40PTdP5DIuspwL8Lcuae/ZYiqiq4pdYaNcCLNaagZgRcXddlWADxHt1/1QXlaV
         +WTvgMec/FEttFruOqRpL+d/CrX+8QhznijNDikFz02S03PIaJq635CCfohMgC2A8uXL
         0CKRmCULq3hGkuIa5uN4ESSomXwcPqw7zrzsxVwehqxZ5OZ3dKZLvxN1400G6dl6Rg0Y
         /EE9mCYG6MIsUVqqrHqkKqzXDhYS/ohdRGjedmE6ouI8cAzK2CDw7uifWgg827yw5lq7
         eNioAXsnDR35ISAcdamY7xxqqTcHdn3pWeuou147ek3IZEKsZ0UJ4k8vVhbf4KcPYqEW
         tOVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794867262; x=1795472062;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OHWSdKyMsFGERyYaZ5X8roMwAxwTPbXTa9d588Vrarc=;
        b=Tjy+TuBEdPNGXvhj8Kcc1BiVfe3FaQeFdZ6pRtqYfwRJ/bXw3/mQLZXQs7TtKiLtKS
         LsFRGHcjq5UYZIt9FG2YPvGsJ3VVJuPb45CggdpPbCngNzA1xsP032ynwKOiuPS4x0rU
         s9ZqzQIR6aFbB4ZmCvwpkadpcUFZD/wPLkbSRWhCabSVwwyD3xvJAG7dZJAKc8qzkf/E
         A6C0unZ0l+rZV7MKoCUHMeGzFuMMhMAJ8xT9yXpchCejala5rxar+2ozlDC5O27dG4oE
         z0vUaHiUIuUAFg4qYtqJHQqoEgxwrYT1T3tuxCl9lEg4LTeyyBtbL5hxHjIVAKTmQCfU
         p0Bg==
X-Forwarded-Encrypted: i=1; AL+hErFF7eaLiIi7NcN49b4JyHlb27nNOrNbze2qo21R00dMY74M8jvykEVUfOc4WMUWaDuMH1IqnnlA/gvt@vger.kernel.org
X-Gm-Message-State: APuU4Z8aJOeUwamLCuzHl94qUWMdqLe0Vi++jrnPpKhXkPGZVcZo0UcQ
	R9vN3H/N1P4Us79X3JMq9rRv53cTHq4jez+mKKbqYG0yzia7MsNXhcm9
X-Gm-Gg: AZFdTZdbV8KiyZcXazuTT6WlPsshKudumDpUiljdBGGLm9RF4Q1mo2IPKBFuE5Ulp3U
	EvVSYZPqjoXIom/g9t16aXaTID89e3eapaKEYDPd6/AFhD22EumudOKQjgE9Vl4BlwcWQ51u4bF
	F8mt9TDueX8mM4jFb2E5ZCviRNQU2oVF+9OVkA4zqAn53B9LKWe2qyG0/UEuauDJNrNgIGeBZX7
	a3c6aHwwb+cUQIPitkvIwQ1kb0KbQ3wXSc88UMAOpyepIECU8C/LXku+GEO1LZ6DsTiwNPoE3p9
	8rdrrV4Bkfrrlq7Yw5CKF+5xcZvG2AeaF5QcqIUfonZQWUunQ0G7sp2ztorysrFwwnizFNDT5pA
	n3HFL3ftAvZu8Zmh4y/aSKPEKIjS8/qAMRdCDnqvs+Po9j7oaDrkHEjaQV8+jE2wnA92dWYQhE7
	r1kI0gJ2pfjGwbjUO91WnDoJ3ApMkS+JElxuxMmAanrubsrhj94ByY0amAIlt7S3hgRMptbmLiZ
	8kLWoFf93tqQLiGqUGgkrkA8CDtEHl8LzvUx7WxsDWckAXMr/mIG4Uua+JMicVNv436FDGiiWgn
	srBiY7WJv9YJ8JUOk36AsEz0oXGF7hO4a82A585BvnQ8GSt47oMfNoqCf8MvaKyzU1xmjkaZGda
	CJDAgrDIi4AmS
X-Received: by 2002:a5d:5f09:0:b0:48d:f730:bda8 with SMTP id ffacd0b85a97d-49c733510e7mr23688407f8f.50.1794867262185;
        Mon, 16 Nov 2026 14:14:22 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c69406640sm24099098f8f.12.2026.11.16.14.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 14:14:21 -0800 (PST)
Date: Mon, 16 Nov 2026 22:14:20 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Miroslav Cimerman <mc@raidlab.org>, Song Liu <song@kernel.org>, Yu Kuai
 <yukuai@fygo.io>, Andrew Morton <akpm@linux-foundation.org>, Li Nan
 <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>, Ard Biesheuvel
 <ardb@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] raid6: use normal stores in the x86 x4 xor_syndrome
 functions
Message-ID: <20261116221420.35ab3bcc@pumpkin>
In-Reply-To: <20261116210440.GE229817@google.com>
References: <20261109030805.25709-1-mc@raidlab.org>
	<20261116210440.GE229817@google.com>
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

On Mon, 16 Nov 2026 21:04:40 +0000
Eric Biggers <ebiggers@kernel.org> wrote:

> On Mon, Nov 09, 2026 at 03:08:05AM +0000, Miroslav Cimerman wrote:
> > - The sfence at the end of the xor_syndrome() functions (x1, x2 versions
> >   since 2014, x4 with this patch) is no longer needed, as it no longer
> >   orders any non-temporal stores. Removing it made no measurable
> >   difference. I am happy to send a follow-up patch that removes it from
> >   all xor_syndrome() variants.  
> 
> Removing the 'asm volatile("sfence" : : : "memory");' too sounds good,
> but be careful: a lot of the inline asm statements in
> lib/raid/raid6/x86/avx512.c incorrectly list the memory operands as
> inputs only.  So, technically they rely on that "memory" clobber.  The
> constraints should be fixed accordingly.

Or, at least, put in a barrier() and a comment.

David

> Also, ideally the 'prefetchnta' on q in the x4 xor_syndrome() functions
> would become 'prefetcht0', to match the temporal stores.
> 
> If the scope of this patch is just replacing the store instructions
> though, it looks fine.
> 
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> 
> - Eric
> 

