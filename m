Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3CF283154
	for <linux-raid@vger.kernel.org>; Tue, 10 Jun 2025 22:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749592825; cv=none; b=F5IiEiG6P3Drf+vI/w/sffoZwM3quVk/5j8dLz2WjNULyUZxgelAxITRvB38FQ41ts4216cMcadu1CEv4f6o/Mmr9PtIv2Yfm3qdG/0mwwdmzzlOqDzOt1YWR5fjl4ez+5Ecn2y86/oQb1MKcKP+uozWwsPInCMi6Jh7oemo67E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749592825; c=relaxed/simple;
	bh=UpwUFDrv2H2y0hTjwiZ8+emZ/Ud1s3QuDb4OOZFkd2c=;
	h=Date:Subject:In-Reply-To:CC:From:To:Message-ID:Mime-Version:
	 Content-Type; b=SxOJdJ7TM4qSHwSWVQUW3SO6dI+twMQL6l9g40aDBxtaZXv0VdSaRLmMhVxDBiZscSZGf6xk7+R/SF6oNuO8y/ciQEpQGJ+XhUR1NKQLPQ+6NKEA8ZUUMd50ZyYFqls/dkaTp4RP4teB1WQ7kx5cEAiFQMpDPFS7xRRm1s3HaVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com; spf=pass smtp.mailfrom=dabbelt.com; dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b=EXshuVzO; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="EXshuVzO"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-236192f8770so2398305ad.0
        for <linux-raid@vger.kernel.org>; Tue, 10 Jun 2025 15:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1749592822; x=1750197622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4G2dsRaNLfs2nkgAzSn0O1Z1VlS3VRtVJRLvHcMgFCE=;
        b=EXshuVzOFkz+Wp2oNWGb1H1bm/0OaSSfJR3dDRCixfmAxIGOzVjUAuWAv2gIxGDBcK
         evyXRI9VaJ/ifOm2rkm8LyYdwsOcbpxJach4FceAQIykiv+qgxj2yAkk90mcNvxAiz1i
         dObWGs4b7Tg1kRmv/67yz293YOuHENGyg3DSIqvXX7rRQuFhebdJis95DRkpWWrU8ywN
         3ksfh94u1tTvsekfte4odMHbdyzyj2jWQBm7j6eBIJ2Vt7Rk2RbTWXt+/RBmpkgsLXBX
         ZP4iOWW9eJXqnJbqHcd3pAMEglvTkQGG0Fr4xqwN+56cs3JIR59ubTfGrqPuy3/JeJJ7
         wU7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749592822; x=1750197622;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4G2dsRaNLfs2nkgAzSn0O1Z1VlS3VRtVJRLvHcMgFCE=;
        b=OOfLCx8dwokxnj9T5kYawGIVENNglVe3JsfqiMk9AGrvF9wCx6m1Gd1pigXHpKGGiD
         pzSYqBF6BcOJuk/wFvJrpYTh9MHYaCD6+Rzf0cQwd1ltSjryLVH10gJuZU/gUbJMlKvH
         j4LwfqPm50vuuu4/jCty35YWlfLiDtW/l7sjSZqnRHeXMjK1s7OsAYsMANsodTVQIXWb
         KMcHMUo+NnkVPuhtqdRFnH/BtaUHjPt+kgbKzi7wX0Kceizny755nog44/Or7DI+JOnt
         ohAr9ivZJVTnlV42dx76vS08UNk2grhzYMQPkoCqQkHwTXALnu02q+m9/QVvguk+LlkS
         EyUA==
X-Forwarded-Encrypted: i=1; AJvYcCVFxuDmNXGuizxYesmG9rXIsKjpXntFUIf5Z5FjE4j/s8GoBX5+N4agj0xPKt7123NvkJ8tTf0F783P@vger.kernel.org
X-Gm-Message-State: AOJu0YxM3bYmY02Jmfy1Czs5yNB+gZEs2nFWJ5jJNr/yDIpO1PZzXQfc
	UwEvxg9CVXF2JuoBzze30Ah60fS1BDy7ssITDRgq7DSU+7Pg3nlnbViW5fXnEDaP1Rk=
X-Gm-Gg: ASbGncvkCF4dhxN1+Zgv+C/qcsx+CD8au17tgVLyqbWpymz5zTo0YRqhQPjN5j3//sA
	0iS1ZsYGeEcfV0RLRqPBmMcdyB9+IIj2h+SjNHqePcQ32CTSWU69bAgtWe1JYVlnfdoqRr8EoUV
	k8ZTE+gcNQZ5vkQh3U8fozz7oUQ+1Ah+Y/GrtB+ljkoa6cxzb5b4yi62IjuyQMJj9NVtvC6tdB2
	rvAvZxIAQ8Yqq2FKJLe7KGDvPkI+QiQRYueQhU1n1zW4iINZOafBigEHOLONXyC2g1d+Iaxcw7t
	beNxeSn3SIW70tqIuCC1fYZkrJUCXy2J8eGfed08RU1poQFhlGCfDo1rZF0u
X-Google-Smtp-Source: AGHT+IEHygQuRQmcpm3Zn4j4pduojeokahmiVVQJDy8o56yodyMF2rjdCCK/u2RBqmQlMoaKDuzeog==
X-Received: by 2002:a17:902:f54e:b0:235:eca0:12e8 with SMTP id d9443c01a7336-2364169ef07mr10412215ad.4.1749592821979;
        Tue, 10 Jun 2025 15:00:21 -0700 (PDT)
Received: from localhost ([2620:10d:c090:500::7:116a])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-236030789cdsm75361745ad.11.2025.06.10.15.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 15:00:21 -0700 (PDT)
Date: Tue, 10 Jun 2025 15:00:21 -0700 (PDT)
X-Google-Original-Date: Tue, 10 Jun 2025 14:57:09 PDT (-0700)
Subject:     Re: [PATCH 2/4] raid6: riscv: Fix NULL pointer dereference issue
In-Reply-To: <20250610101234.1100660-3-zhangchunyan@iscas.ac.cn>
CC: Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
  Alexandre Ghiti <alex@ghiti.fr>, Charlie Jenkins <charlie@rivosinc.com>, song@kernel.org, yukuai3@huawei.com,
  linux-riscv@lists.infradead.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, zhang.lyra@gmail.com
From: Palmer Dabbelt <palmer@dabbelt.com>
To: zhangchunyan@iscas.ac.cn
Message-ID: <mhng-8AD2A457-504F-4EF6-AB17-2CF316DFF6A0@palmerdabbelt-mac>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Tue, 10 Jun 2025 03:12:32 PDT (-0700), zhangchunyan@iscas.ac.cn wrote:
> When running the raid6 user-space test program on RISC-V QEMU, there's a
> segmentation fault which seems caused by accessing a NULL pointer,
> which is the pointer variable p/q in raid6_rvv*_gen/xor_syndrome_real(),
> p/q should have been equal to dptr[x], but when I use GDB command to
> see its value, which was 0x10 like below:
>
> "
> Program received signal SIGSEGV, Segmentation fault.
> 0x0000000000011062 in raid6_rvv2_xor_syndrome_real (disks=<optimized out>, start=0, stop=<optimized out>, bytes=4096, ptrs=<optimized out>) at rvv.c:386
> (gdb) p p
> $1 = (u8 *) 0x10 <error: Cannot access memory at address 0x10>
> "
>
> The issue was found to be related with:
> 1) Compile optimization
>    There's no segmentation fault if compiling the raid6test program with
>    the optimization flag -O0.
> 2) The RISC-V vector command vsetvli
>    If not used t0 as the first parameter in vsetvli, there's no
>    segmentation fault either.
>
> This patch selects the 2nd solution to fix the issue.

This code is super fragile, it's got a bunch of vector asm blocks in 
there that aren't declaring their cobbers.  At a bare minimum we should 
have something like

    diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
    index 99dfa16d37c7..3c9b3fd9f2ed 100644
    --- a/lib/raid6/rvv.c
    +++ b/lib/raid6/rvv.c
    @@ -17,6 +17,10 @@
     #define NSIZE  16
     #endif
    
    +#ifdef __riscv_vector
    +#error "This code must be built without compiler support for vector"
    +#endif
    +
     static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
     {
     	u8 **dptr = (u8 **)ptrs;

because it just won't work when built with a compiler that can use 
vector instructions.

> Fixes: 6093faaf9593 ("raid6: Add RISC-V SIMD syndrome and recovery calculations")
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> ---
>  lib/raid6/rvv.c | 48 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 28 insertions(+), 20 deletions(-)
>
> diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
> index bf7d5cd659e0..b193ea176d5d 100644
> --- a/lib/raid6/rvv.c
> +++ b/lib/raid6/rvv.c
> @@ -23,9 +23,9 @@ static int rvv_has_vector(void)
>  static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
>  {
>  	u8 **dptr = (u8 **)ptrs;
> -	unsigned long d;
> -	int z, z0;
>  	u8 *p, *q;
> +	unsigned long vl, d;
> +	int z, z0;
>
>  	z0 = disks - 3;		/* Highest data disk */
>  	p = dptr[z0 + 1];		/* XOR parity */
> @@ -33,8 +33,9 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
>
>  	asm volatile (".option	push\n"
>  		      ".option	arch,+v\n"
> -		      "vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		      "vsetvli	%0, x0, e8, m1, ta, ma\n"
>  		      ".option	pop\n"
> +		      : "=&r" (vl)
>  	);
>
>  	 /* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
> @@ -96,7 +97,7 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
>  {
>  	u8 **dptr = (u8 **)ptrs;
>  	u8 *p, *q;
> -	unsigned long d;
> +	unsigned long vl, d;
>  	int z, z0;
>
>  	z0 = stop;		/* P/Q right side optimization */
> @@ -105,8 +106,9 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
>
>  	asm volatile (".option	push\n"
>  		      ".option	arch,+v\n"
> -		      "vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		      "vsetvli	%0, x0, e8, m1, ta, ma\n"
>  		      ".option	pop\n"
> +		      : "=&r" (vl)
>  	);
>
>  	/* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
> @@ -192,9 +194,9 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
>  static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
>  {
>  	u8 **dptr = (u8 **)ptrs;
> -	unsigned long d;
> -	int z, z0;
>  	u8 *p, *q;
> +	unsigned long vl, d;
> +	int z, z0;
>
>  	z0 = disks - 3;		/* Highest data disk */
>  	p = dptr[z0 + 1];		/* XOR parity */
> @@ -202,8 +204,9 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
>
>  	asm volatile (".option	push\n"
>  		      ".option	arch,+v\n"
> -		      "vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		      "vsetvli	%0, x0, e8, m1, ta, ma\n"
>  		      ".option	pop\n"
> +		      : "=&r" (vl)
>  	);
>
>  	/*
> @@ -284,7 +287,7 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
>  {
>  	u8 **dptr = (u8 **)ptrs;
>  	u8 *p, *q;
> -	unsigned long d;
> +	unsigned long vl, d;
>  	int z, z0;
>
>  	z0 = stop;		/* P/Q right side optimization */
> @@ -293,8 +296,9 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
>
>  	asm volatile (".option	push\n"
>  		      ".option	arch,+v\n"
> -		      "vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		      "vsetvli	%0, x0, e8, m1, ta, ma\n"
>  		      ".option	pop\n"
> +		      : "=&r" (vl)
>  	);
>
>  	/*
> @@ -410,9 +414,9 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
>  static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
>  {
>  	u8 **dptr = (u8 **)ptrs;
> -	unsigned long d;
> -	int z, z0;
>  	u8 *p, *q;
> +	unsigned long vl, d;
> +	int z, z0;
>
>  	z0 = disks - 3;	/* Highest data disk */
>  	p = dptr[z0 + 1];	/* XOR parity */
> @@ -420,8 +424,9 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
>
>  	asm volatile (".option	push\n"
>  		      ".option	arch,+v\n"
> -		      "vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		      "vsetvli	%0, x0, e8, m1, ta, ma\n"
>  		      ".option	pop\n"
> +		      : "=&r" (vl)
>  	);
>
>  	/*
> @@ -536,7 +541,7 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
>  {
>  	u8 **dptr = (u8 **)ptrs;
>  	u8 *p, *q;
> -	unsigned long d;
> +	unsigned long vl, d;
>  	int z, z0;
>
>  	z0 = stop;		/* P/Q right side optimization */
> @@ -545,8 +550,9 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
>
>  	asm volatile (".option	push\n"
>  		      ".option	arch,+v\n"
> -		      "vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		      "vsetvli	%0, x0, e8, m1, ta, ma\n"
>  		      ".option	pop\n"
> +		      : "=&r" (vl)
>  	);
>
>  	/*
> @@ -718,9 +724,9 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
>  static void raid6_rvv8_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
>  {
>  	u8 **dptr = (u8 **)ptrs;
> -	unsigned long d;
> -	int z, z0;
>  	u8 *p, *q;
> +	unsigned long vl, d;
> +	int z, z0;
>
>  	z0 = disks - 3;	/* Highest data disk */
>  	p = dptr[z0 + 1];	/* XOR parity */
> @@ -728,8 +734,9 @@ static void raid6_rvv8_gen_syndrome_real(int disks, unsigned long bytes, void **
>
>  	asm volatile (".option	push\n"
>  		      ".option	arch,+v\n"
> -		      "vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		      "vsetvli	%0, x0, e8, m1, ta, ma\n"
>  		      ".option	pop\n"
> +		      : "=&r" (vl)
>  	);
>
>  	/*
> @@ -912,7 +919,7 @@ static void raid6_rvv8_xor_syndrome_real(int disks, int start, int stop,
>  {
>  	u8 **dptr = (u8 **)ptrs;
>  	u8 *p, *q;
> -	unsigned long d;
> +	unsigned long vl, d;
>  	int z, z0;
>
>  	z0 = stop;		/* P/Q right side optimization */
> @@ -921,8 +928,9 @@ static void raid6_rvv8_xor_syndrome_real(int disks, int start, int stop,
>
>  	asm volatile (".option	push\n"
>  		      ".option	arch,+v\n"
> -		      "vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		      "vsetvli	%0, x0, e8, m1, ta, ma\n"
>  		      ".option	pop\n"
> +		      : "=&r" (vl)
>  	);
>
>  	/*
