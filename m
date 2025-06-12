Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264612036EC
	for <linux-raid@vger.kernel.org>; Thu, 12 Jun 2025 19:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749756642; cv=none; b=QQOtZj431QKgGl9CDT+5GOvTEujkAocZAH0HQsArQIxnwkjKa5NRzrtUN6cI3rt4eJVeSv3upgWX2V+QtV5VIKyVq/jxs7c6eQMhDdv9kOY6zD5Eo2Hfcy4PsshDNdx7ATbtihZZZCetWAoPxBctse3ifyOs1VCiltxlAYaHb28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749756642; c=relaxed/simple;
	bh=RT+6+m4B8uJQ1AtCRdCzI/ZOm6JvrDT37/BylhyJAXc=;
	h=Date:Subject:In-Reply-To:CC:From:To:Message-ID:Mime-Version:
	 Content-Type; b=Nm6ms7Nayd89O0TaG5K++H6s0s5Pnr85Z/Nx2zedyem02+CjD8NoaMNTmIFEtbn2zicavAb8gQOtC1UMG3v+m4m50VRC5ysgr9ssiOcaU53g8BmNyoDcGsk/2D45hLykLb4PMK1pzha7Q6rqOKYym/zLr/YdyuHCkTzczu633Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com; spf=pass smtp.mailfrom=dabbelt.com; dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b=ax9ZfIdA; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="ax9ZfIdA"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-235f9e87f78so14878085ad.2
        for <linux-raid@vger.kernel.org>; Thu, 12 Jun 2025 12:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1749756639; x=1750361439; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kPtJ9IeClIB9n7jf1IY5kxuzpZZ2o3SK0WOHDSbPH9g=;
        b=ax9ZfIdAGsGV90wqGHAB3kgB/4glKyvKvtEW1EyvSsfHUDtTUF3zpIuPzDcyK4U+aQ
         KN4JXZmM/n8UBV+FN7zgRxqNJ7XPB7IwQocKSFED00i6xZadDZ1Bzgnx20Sz93I71cRF
         jpYoSiyH49uQbTtGzaXOX8Q9eDhK5/g2kTGe2uDdj7QscYylTx+tTnJlRghq/qsQar0v
         ClOO27At/Scu659XZRjXtCcND+MmqYluDKR2gOkxwOiDa/c8z0VJxNLSY21rFwIquY8m
         i+SqwPxqRo017OHl0rotO09NhnWeZxOTL7FcEkYAfM1rSkMB7FDHz5+7sXSjPxUL4B2D
         o+hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749756639; x=1750361439;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kPtJ9IeClIB9n7jf1IY5kxuzpZZ2o3SK0WOHDSbPH9g=;
        b=De8zhJ+iVISKQu0wa2WJhXUfOWPHOyFmsPwJYY0v2AcZv9Q3M95yEiDnLYgdD/P7ud
         tvZfZK/qzVL3b2Em/k4n+tSI7HFmM4oJUcf/A35njwJGToDD3kSydFu2KE0KiRe4hk6s
         xdnVRU/aS2N2xfNT7jLpRDGeEU8UL6MTwsNbYR5YNP0yTCVUb52/Xf6PmZ3TVXbo1RXf
         NZkB3ZHewI37e4ypYYO36L2OORCIn+haRc1ztK1OwXEWTbpyZqgwtdBf1O7VYd9qcmzL
         K648hpWwcGlofawD+expBCzozcyWisWPQ+OnJOvx0ZhVoukPm1igUQ/0TTGxz+wVMRHY
         HKnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUD4BXLzNuVavIhPXxerX0xYRAv43oqPqgBKosCTcs+sv5xjn/f/MOQCjxFA5I4CWPBHFI1F/bjWNLW@vger.kernel.org
X-Gm-Message-State: AOJu0Yxvf4zQ6Ro8qJVq2G2ec5VeP/vYPpXBlZVihR4PpxkmjhcW6vxe
	96V65KmqS0y4m8GQSVmzanNG1UKl2isy/FuGaygHiB5ylpy5xRfXfhf5yxaIdNX/72Y=
X-Gm-Gg: ASbGnctG2t8apbusgXZNs4xnh8Uok1bsZZ7ExPSPQeezlSJh8k+uCwhFZ0OyuxUUa6j
	LHXRditmZcp+p6VAgD58B3rc6FqT6o1dgtUCxrLIjq3ysm9ULKfs9ANNxAv5UoVyUKu2h3cT7xF
	xWxE8FaQaDhiR4FdUd60z/5eE1UVCMUGhdQCzPfY6J0nW7ndLnTVhnBDcyv607neaBNcjt6Arcp
	vFUpSXPyHDv1zTtmkYcEq4EHSay/d1hWNYzQEgeB3aENiXt0EVp7CbQAkTtdbqM5unBYMI8Pjd3
	hk8Mf7GJCfCVXH+aq2ksLCM1ZUQGQxJhI6FcoRDaSb8lyC+uyiIRvtrGnbOQdqOTyoXC58g=
X-Google-Smtp-Source: AGHT+IHU7fagoyX7EvCpClw9B6nwEcBcwsyEhBHfcDDWpqjq1c1A+nBkSpB2SK4VtlksaREw83mC9g==
X-Received: by 2002:a17:903:3a90:b0:234:f4da:7eef with SMTP id d9443c01a7336-2365de4e017mr4214785ad.52.1749756639208;
        Thu, 12 Jun 2025 12:30:39 -0700 (PDT)
Received: from localhost ([2620:10d:c090:500::7:116a])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-2365deca149sm801105ad.199.2025.06.12.12.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 12:30:38 -0700 (PDT)
Date: Thu, 12 Jun 2025 12:30:38 -0700 (PDT)
X-Google-Original-Date: Thu, 12 Jun 2025 12:30:30 PDT (-0700)
Subject:     Re: [PATCH 2/4] raid6: riscv: Fix NULL pointer dereference issue
In-Reply-To: <20250610101234.1100660-3-zhangchunyan@iscas.ac.cn>
CC: Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
  Alexandre Ghiti <alex@ghiti.fr>, Charlie Jenkins <charlie@rivosinc.com>, song@kernel.org, yukuai3@huawei.com,
  linux-riscv@lists.infradead.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, zhang.lyra@gmail.com
From: Palmer Dabbelt <palmer@dabbelt.com>
To: zhangchunyan@iscas.ac.cn
Message-ID: <mhng-09771FCE-11E1-401A-81E4-EF482D65AC0B@palmerdabbelt-mac>
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

I'm picking this one up as a fix, with a some slight commit message 
wording change to describe the clobber issue.  It should show up on 
fixes soon, assuming nothing goes off the rails you can base the next 
version of the patch set on bc75552b80e6 ("raid6: riscv: Fix NULL 
pointer dereference caused by a missing clobber").

On a related note: I think we have another bug if NSIZE doesn't line up 
with bytes as we're not handling the tails.  I'm not sure if that can 
happen, as I don't really know this code.

Also: unless I'm missing something you can replace one one of the loads 
in the loop with a move, which I assume will be faster on some systems.

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
