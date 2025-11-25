Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E969D2E8E13
	for <linux-raid@vger.kernel.org>; Tue, 25 Nov 2025 09:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764063823; cv=none; b=EfHiHPojXkhuKGbedFkwew8OvvsLlBuRF1dPiocTeJkcbFuBXb+iVUCSM4jzt5AG8s9FtUIMBm+GYGRtM2CpoENxZCRQsAOLzR0CFMmajNBQuPZfbLUezxl90MNzKcieFjZVOZJ0mKa2ai9uwP/yAotKPN8frt9sjYvwh9+Q1Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764063823; c=relaxed/simple;
	bh=4XsfezmjHfW52ys2fgbjNWaPwBjuyhkdLp4vccqFVO0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GddgMykIX3Ie9s8kKLSetjsnquqz141+L+71Kvbkw1O2bb+upaw/osDaE1YWzRvIVpx756je+M6MA4x+5YK32qm9dN/6PkEEZTZRUSRwlJszENtgqqK2AX0mO71y9eSlBJrKJa6ufTDXV9MzpzKmXYyuclQfZaivMJ8un1YFgC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KWHktgZZ; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KWHktgZZ"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-4507605e19aso2523458b6e.2
        for <linux-raid@vger.kernel.org>; Tue, 25 Nov 2025 01:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764063820; x=1764668620; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1DEMhoyJR5Ya2N+6ATmyeN5MRN5ywYpjrwxCrvpqK9g=;
        b=KWHktgZZRNCqsgbOrHdiQvBA/vk0XmaPjRk6C6JuDSlhWCNT+u3iZHLt96NzVC+05/
         0MwvLjbzWlYNWCc+knzKXe8oa73Mw7ja+dEvyUSU7JSsZWqrqD45EitW7SDdKwmsXhg0
         tdbM7fPfUVw1iM6WT364vqM0IJ1hfDnhKtshL25jihdNhVhyPDeHfBDL4N/VmaRtEeRE
         hSTGgZ/dmOcle043K69m6Gy1gg2D9jiUu20v7QCuf3UPr5gv9lh3H7LM9Cu2yPSb3F1l
         s9eGejft9Nis4LqlTqKn7jQxTvzzVBtPsyR6O21l4+eXSwQR4zC4IP7a8mmUPZg1i5yr
         kiyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764063820; x=1764668620;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1DEMhoyJR5Ya2N+6ATmyeN5MRN5ywYpjrwxCrvpqK9g=;
        b=Bk8QUvUOfv0NSM1VIHsdeZziX9LWWJvfaq+bY7WNlr4X+V/JSXqT/T9u4JdXvGgKyT
         6J73sE5oexJSKbdlp6Pl3GbK1oywtdeSvAAibnrHmoPKbK8+0oVzLyUeJ7OXbkRnrITr
         JToJ6nGEONcZLtgHcSwmcUoofux9PGUGeDU9VmHfGwrm5wTQNKUsxyBStmPRLVy3hZyo
         JmKvWHTYet04qnPGNluFUTWiBbfsk6ICY0geiqT0l/bhwtLhsvrX+090FJWMhVoxjTf1
         qnYchfDCmpTNuTLZ7WGDCTriTtgbfmbyI7A2YgyZTGTKQwSydrODUmxoj4YICNhqm+fT
         sDIw==
X-Forwarded-Encrypted: i=1; AJvYcCWv17N4Ak7QsQThAJGWjhQ6VfANKw8mWNIk5Ik/BXXyp6BlXRXiAVXie/tMtoUN7tXZMNm/AZXtMTpN@vger.kernel.org
X-Gm-Message-State: AOJu0YyT/1j5L8+OUpDQqGG08MtIVGetOSjjm2zb1uZk6vx/S1naA5YJ
	BYgE3jEEwmP0lS7k7aK9MLF39Kp7IbA8qT/2LPOMKnkXVmwfshKrV3hNmmRVHaeniBqAcyiegnE
	Ar7+nXU6JwIptfr4DFG0HiNWpTd2WFcA=
X-Gm-Gg: ASbGnctZoWYDTp6Z/r5ee7yyAYtI2DX+MfpmVb63keI9yx8LiJAhmieY7b+X8mEgl0B
	Lze7eY7mJvYqFox2kkQI/grUOjNgH7P1FDWp46NSTPQPSwkjhN9MJSmhDSFtUBrJOQr/yRKfw/l
	UXP2LZ9ivOGurMTR/uW7VPNIvbRVK+LT78Yb1pvoIHhEcyxep3YPlTm46y500qqJwf0RZms/8Ki
	EjD1ZQHGy8cWHqR0IrypD+Ghnl1M4n+3cOZJUG982WGE0n0aLGXj1XgdUikSpaeczwbpf/YCHm8
	0alFvpEVQAR6jhil0ZLW1aB1
X-Google-Smtp-Source: AGHT+IHjzSP1vWUEYyBNaB+pfgCIn3GULdkosRoCxVHby5roWsTS+mvA7mK21fdZj6eeT1wFTa8Kc1BkazSk1OlxVSU=
X-Received: by 2002:a05:6808:d4a:b0:450:d143:b79f with SMTP id
 5614622812f47-45112d661afmr5677499b6e.66.1764063819856; Tue, 25 Nov 2025
 01:43:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250718072711.3865118-1-zhangchunyan@iscas.ac.cn>
 <20250718072711.3865118-4-zhangchunyan@iscas.ac.cn> <6c2a11f4-27ac-1389-23a6-5f5bcf1c5048@kernel.org>
In-Reply-To: <6c2a11f4-27ac-1389-23a6-5f5bcf1c5048@kernel.org>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Tue, 25 Nov 2025 17:43:04 +0800
X-Gm-Features: AWmQ_bkkJeJE09vs1ypjMmGjNJm9TFEXHZ69kcAmZZd9hlplsqwCoCW6EAigUqQ
Message-ID: <CAAfSe-uMCVGS6a0YLQxBrQAdYK16EOUPNM1t-7jPaoGgZzbs6g@mail.gmail.com>
Subject: Re: [PATCH V3 3/5] raid6: riscv: Prevent compiler with vector support
 to build already vectorized code
To: Paul Walmsley <pjw@kernel.org>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Charlie Jenkins <charlie@rivosinc.com>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai3@huawei.com>, linux-riscv@lists.infradead.org, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Paul,

On Tue, 25 Nov 2025 at 17:26, Paul Walmsley <pjw@kernel.org> wrote:
>
> Hi,
>
> On Fri, 18 Jul 2025, Chunyan Zhang wrote:
>
> > To avoid the inline assembly code to break what the compiler could have
> > vectorized, this code must be built without compiler support for vector.
> >
> > Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
>
> This one has been queued with a somewhat modified commit message to
> reflect what I thought the intention is.  But I might be wrong.  Can you
> check it, please?
>
> thanks,
>
>
> - Paul
>
> From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> Date: Mon, 17 Nov 2025 21:19:24 -0700
>
> raid6: riscv: Prevent compiler from breaking inline vector assembly code
>
> To prevent the compiler from breaking the inline vector assembly code,
> this code must be built without compiler support for vector.

This is more clear and easier to understand.

Thanks for the review and rephrasing the commit message.

Chunyan

>
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> Link: https://patch.msgid.link/20250718072711.3865118-4-zhangchunyan@iscas.ac.cn
> [pjw@kernel.org: cleaned up commit message]
> Signed-off-by: Paul Walmsley <pjw@kernel.org>
> ---
>  lib/raid6/rvv.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
> index 89da5fc247aa..015f3ee4da25 100644
> --- a/lib/raid6/rvv.c
> +++ b/lib/raid6/rvv.c
> @@ -20,6 +20,10 @@ static int rvv_has_vector(void)
>         return has_vector();
>  }
>
> +#ifdef __riscv_vector
> +#error "This code must be built without compiler support for vector"
> +#endif
> +
>  static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
>  {
>         u8 **dptr = (u8 **)ptrs;
> --
> 2.48.1
>
