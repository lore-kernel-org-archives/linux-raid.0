Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022BC17E4
	for <linux-raid@vger.kernel.org>; Mon, 20 Jan 2025 04:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737348618; cv=none; b=pIRA3f+DCI9auURqCJLspQi/l0JICTq0EMg616Hh4H2zzRkS8ngFlyVT2r5fzC+Io9QvaAk5iiPIXzGw3e7bnszxjSyqog4crZaFBn5G6bO9nOzPdYhgX8lGpGkBop7sKeWdgHj7mdfh1V2uLy/W39FGm5D9niUxCTJpgcKeV1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737348618; c=relaxed/simple;
	bh=6xgSNF6nm1/bOhS9EzsxubeHMdZiALiIz9hmBvxVXOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tIL7dRoUmSoLtVYbRfnSj8VnUk1NB4AW7Mv/UQ0icorRIcUm7q34fpFqkd4MYOL3DP/P2mmj+yIFlfWlcQLo7to7W2/o1zrw0UwsdOneh9RBjEuUWtUwDIY0lngIlBrK1HE1VY0FJAqoKTYjg86WU0902+Bn3E5mL0ko7gWcH6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=1YBlX7Mh; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="1YBlX7Mh"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2161eb94cceso49427045ad.2
        for <linux-raid@vger.kernel.org>; Sun, 19 Jan 2025 20:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1737348613; x=1737953413; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YPxhHVSVg4x5plR0NRyuxvAYVrPGQG7JMzV/NLUrSvg=;
        b=1YBlX7MhllXA9xzPFNyTAY5re9lQNIyvxmi1usjRt879bd7M+ocjcKTofVgZ0P5BOI
         DDjUNLwDPTwL85h1SCqmZP9cWHfuFcMCzZ/LtoDwiFeBPjUWSwM0VKSp5C4kL31D4hs+
         DdLojOFWg7jLA5fDGACxbJttt8ziPjq1iSmCcXiFNwBZ7dqvRROoUy65apI7I2bRhVBc
         XIyIcGc4V55r6C8+glcGbgmfYU9wP4PomHCGo7FFoP8WAJXHSfojG0hdJu5wCt5WscqI
         GzbTCKyH9Lt9ADUWXYv3Z+g9kvvAMr/D3sLjeJT1ljPAiWAQvAPxxgLBpdqJ1Cb0Q/2o
         BTlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737348613; x=1737953413;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YPxhHVSVg4x5plR0NRyuxvAYVrPGQG7JMzV/NLUrSvg=;
        b=setGw7+UtkWBZUOrmw46rsPHMl0ukZEPUYIV4/eIs4zOCYZni2+Z4BTYJWx0RlZxWS
         4t+8O/PGHPVruV9uPCWlTv5D867kajxlB4sh1A7ePTPOCzR7eTY37jlIc6h4K7Y8XRQI
         DFyQbT1c8jdPBD+WpXQVjTZlzqNp5qrEp47cwhizwqzSd/RtVBhi3o6BtJKarkVyPYb4
         HO0WOsg4SDkxpGWv0b+aup/IgLx/M1B8Fs0dRsR3ITLjCt/jQA6AmxFtGzLSr0kEnU9Z
         ND7JaH5GhTO4w+t5gk0T0jKlMUIgxrU8uvcieR8gPGh7fTTgaq5Kk0FOEeVVOMn5W2wV
         VTeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjL0DYAp4g0bB4pyTVvfMArOf5SargVTXL9Jl7In+Sr9OWxyt4MzhMdjVric+pbs97mz/A09weJZ4s@vger.kernel.org
X-Gm-Message-State: AOJu0Yx47y6lLmt4XHCDxq3/P99TWRaTUF8AY+qYSBBkHzx87YHRARut
	/p2/IyBjEKwQOpp7GREaX1cWLju2lcIlljcdc5TEdiwCMvjVTYLw1fsY1hQ6Y98=
X-Gm-Gg: ASbGncsLv0EKBGJSOVESeNMn5ghBfYfvWjsZYmTZq1Ohr/nXvTLBWUY550IKHtWwJWS
	L8ShN/MT0WrP2xV7VCJjHN6FObyixRPYn9J9N327XoCNqHcZW7srLZsMw85pC2RVjfT9LDtGygC
	hPuOh2Z2oZ4JU5qOKW2oU/PFYjkpyq4kLgW7gp6pjeMJbnCBe+q/WBxRZr7+GWbwaPg6RTudv5V
	kwV8etByVJ9rCfaq8Kbm4RkCKtFq4aqQ8KjLxTroFw8nE+kk/hdHiiECxPIWkep0g==
X-Google-Smtp-Source: AGHT+IFIEY4ZIPejTWRHsRYJkjY1IfqpikLXBclVzk1+nhDgXzd6BG6MUPgPBkaO9eRrXfYpCYcfHw==
X-Received: by 2002:a17:903:1205:b0:216:7ee9:2227 with SMTP id d9443c01a7336-21c355dcff6mr173820715ad.36.1737348613063;
        Sun, 19 Jan 2025 20:50:13 -0800 (PST)
Received: from ghost ([2601:647:6700:64d0:f6ba:e4b8:8306:4306])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2d3acb53sm51659235ad.154.2025.01.19.20.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2025 20:50:12 -0800 (PST)
Date: Sun, 19 Jan 2025 20:50:09 -0800
From: Charlie Jenkins <charlie@rivosinc.com>
To: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>, linux-riscv@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] raid6: Add RISC-V SIMD syndrome and recovery
 calculations
Message-ID: <Z43WAd5KYDA-bzWY@ghost>
References: <20241220114023.667347-1-zhangchunyan@iscas.ac.cn>
 <Z38OCF7cMqz6z7p3@ghost>
 <CAAfSe-sJ7Hwc6mdn492FZupdBL9PPBksGO=VACg34W1owY253A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAfSe-sJ7Hwc6mdn492FZupdBL9PPBksGO=VACg34W1owY253A@mail.gmail.com>

On Mon, Jan 20, 2025 at 11:33:52AM +0800, Chunyan Zhang wrote:
> Hi Charlie,
> 
> On Thu, 9 Jan 2025 at 07:45, Charlie Jenkins <charlie@rivosinc.com> wrote:
> >
> > On Fri, Dec 20, 2024 at 07:40:23PM +0800, Chunyan Zhang wrote:
> [snip]
> > > +static void raid6_2data_recov_rvv(int disks, size_t bytes, int faila,
> > > +             int failb, void **ptrs)
> > > +{
> > > +     u8 *p, *q, *dp, *dq;
> > > +     const u8 *pbmul;        /* P multiplier table for B data */
> > > +     const u8 *qmul;         /* Q multiplier table (for both) */
> > > +
> > > +     p = (u8 *)ptrs[disks - 2];
> > > +     q = (u8 *)ptrs[disks - 1];
> > > +
> > > +     /*
> > > +      * Compute syndrome with zero for the missing data pages
> > > +      * Use the dead data pages as temporary storage for
> > > +      * delta p and delta q
> > > +      */
> > > +     dp = (u8 *)ptrs[faila];
> > > +     ptrs[faila] = (void *)raid6_empty_zero_page;
> > > +     ptrs[disks - 2] = dp;
> > > +     dq = (u8 *)ptrs[failb];
> > > +     ptrs[failb] = (void *)raid6_empty_zero_page;
> > > +     ptrs[disks - 1] = dq;
> > > +
> > > +     raid6_call.gen_syndrome(disks, bytes, ptrs);
> > > +
> > > +     /* Restore pointer table */
> > > +     ptrs[faila]     = dp;
> > > +     ptrs[failb]     = dq;
> > > +     ptrs[disks - 2] = p;
> > > +     ptrs[disks - 1] = q;
> > > +
> > > +     /* Now, pick the proper data tables */
> > > +     pbmul = raid6_vgfmul[raid6_gfexi[failb-faila]];
> > > +     qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila] ^
> > > +                                      raid6_gfexp[failb]]];
> > > +
> > > +     if (crypto_simd_usable()) {
> >
> > There should be an alternate recovery mechanism if it's not currently
> > usable right? I don't know what case could happen when this function is
> > called but crypto_simd_usable() returns false.
> 
> crypto_simd_usable() looks like not needed here.
> The callers would call preempt_disable() before calling this function.
> And I will add .valid callback like you commented below.
> 
> >
> > > +             kernel_vector_begin();
> > > +             __raid6_2data_recov_rvv(bytes, p, q, dp, dq, pbmul, qmul);
> > > +             kernel_vector_end();
> > > +     }
> > > +}
> > > +
> > > +static void raid6_datap_recov_rvv(int disks, size_t bytes, int faila,
> > > +             void **ptrs)
> > > +{
> > > +     u8 *p, *q, *dq;
> > > +     const u8 *qmul;         /* Q multiplier table */
> > > +
> > > +     p = (u8 *)ptrs[disks - 2];
> > > +     q = (u8 *)ptrs[disks - 1];
> > > +
> > > +     /*
> > > +      * Compute syndrome with zero for the missing data page
> > > +      * Use the dead data page as temporary storage for delta q
> > > +      */
> > > +     dq = (u8 *)ptrs[faila];
> > > +     ptrs[faila] = (void *)raid6_empty_zero_page;
> > > +     ptrs[disks - 1] = dq;
> > > +
> > > +     raid6_call.gen_syndrome(disks, bytes, ptrs);
> > > +
> > > +     /* Restore pointer table */
> > > +     ptrs[faila]     = dq;
> > > +     ptrs[disks - 1] = q;
> > > +
> > > +     /* Now, pick the proper data tables */
> > > +     qmul = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila]]];
> > > +
> > > +     if (crypto_simd_usable()) {
> >
> > Same here
> >
> > > +             kernel_vector_begin();
> > > +             __raid6_datap_recov_rvv(bytes, p, q, dq, qmul);
> > > +             kernel_vector_end();
> > > +     }
> > > +}
> > > +
> > > +const struct raid6_recov_calls raid6_recov_rvv = {
> > > +     .data2          = raid6_2data_recov_rvv,
> > > +     .datap          = raid6_datap_recov_rvv,
> > > +     .valid          = NULL,
> >
> > These functions should only be called if vector is enabled, so this
> > valid bit should call has_vector(). has_vector() returns a bool and
> > valid expects an int so you can wrap it in something like:
> 
> Ok, will add.
> >
> > static int check_vector(void)
> > {
> >         return has_vector();
> > }
> >
> > Just casting has_vector to int (*)(void) doesn't work, I get:
> >
> > warning: cast between incompatible function types from ‘bool (*)(void)’ {aka ‘_Bool (*)(void)’} to ‘int (*)(void)’ [-Wcast-function-type]
> >
> >
> [snip]
> > > +#define RAID6_RVV_WRAPPER(_n)                                                \
> > > +     static void raid6_rvv ## _n ## _gen_syndrome(int disks,         \
> > > +                                     size_t bytes, void **ptrs)      \
> > > +     {                                                               \
> > > +             void raid6_rvv ## _n  ## _gen_syndrome_real(int,        \
> > > +                                             unsigned long, void**); \
> > > +             if (crypto_simd_usable()) {                             \
> >
> > Same note about crypto_simd_usable as above
> 
> Ok.
> 
> >
> > > +                     kernel_vector_begin();                          \
> > > +                     raid6_rvv ## _n ## _gen_syndrome_real(disks,    \
> > > +                                     (unsigned long)bytes, ptrs);    \
> > > +                     kernel_vector_end();                            \
> > > +             }                                                       \
> > > +     }                                                               \
> > > +     static void raid6_rvv ## _n ## _xor_syndrome(int disks,         \
> > > +                                     int start, int stop,            \
> > > +                                     size_t bytes, void **ptrs)      \
> > > +     {                                                               \
> > > +             void raid6_rvv ## _n  ## _xor_syndrome_real(int,        \
> > > +                             int, int, unsigned long, void**);       \
> > > +             if (crypto_simd_usable()) {                             \
> >
> > ... and here
> 
> Ok.
> 
> >
> > > +                     kernel_vector_begin();                          \
> > > +             raid6_rvv ## _n ## _xor_syndrome_real(disks,            \
> > > +                     start, stop, (unsigned long)bytes, ptrs);       \
> > > +                     kernel_vector_end();                            \
> > > +             }                                                       \
> > > +     }                                                               \
> > > +     struct raid6_calls const raid6_rvvx ## _n = {                   \
> > > +             raid6_rvv ## _n ## _gen_syndrome,                       \
> > > +             raid6_rvv ## _n ## _xor_syndrome,                       \
> > > +             NULL,                                                   \
> >
> > Same note about calling has_vector here.
> 
> Yes.
> 
> >
> > > +             "rvvx" #_n,                                             \
> > > +             0                                                       \
> > > +     }
> > > +
> > > +RAID6_RVV_WRAPPER(1);
> > > +RAID6_RVV_WRAPPER(2);
> > > +RAID6_RVV_WRAPPER(4);
> > > --
> > > 2.34.1
> > >
> > >
> > > _______________________________________________
> > > linux-riscv mailing list
> > > linux-riscv@lists.infradead.org
> > > http://lists.infradead.org/mailman/listinfo/linux-riscv
> >
> > Some interesting results, on QEMU (vlen=256) these vectorized versions
> > are around 6x faster on my CPU. Vector in QEMU is not optimized so I am
> > surprised that there is this much speedup.
> 
> Which version of QEMU did you use? What options were used when running QEMU?
> 
> I want to try on my side, since this test didn't run as fast like your
> test result on my QEMU (I'm using v9.0.0, vlen=128).

Oh interesting, I had the "icount" plugin enabled and that apparently
really messes up this performance counting.

My original test was on QEMU 9.1.0.

I upgraded my QEMU to v9.2.0 and tested again.

With the option "-icount shift=0" I get:

[    0.128304] raid6: rvvx1    gen()  2671 MB/s
[    0.196358] raid6: rvvx2    gen()  3101 MB/s
[    0.264410] raid6: rvvx4    gen()  3370 MB/s
[    0.332488] raid6: int64x8  gen()   548 MB/s
[    0.400552] raid6: int64x4  gen()   601 MB/s
[    0.468600] raid6: int64x2  gen()   585 MB/s
[    0.536661] raid6: int64x1  gen()   519 MB/s
[    0.536673] raid6: using algorithm rvvx4 gen() 3370 MB/s
[    0.604688] raid6: .... xor() 1944 MB/s, rmw enabled

Without it I get:

[    0.366142] raid6: rvvx1    gen()   712 MB/s
[    0.440205] raid6: rvvx2    gen()   733 MB/s
[    0.508751] raid6: rvvx4    gen()   739 MB/s
[    0.577269] raid6: int64x8  gen()  1475 MB/s
[    0.645781] raid6: int64x4  gen()  2164 MB/s
[    0.714363] raid6: int64x2  gen()  1149 MB/s
[    0.782837] raid6: int64x1  gen()  1709 MB/s
[    0.782986] raid6: using algorithm int64x4 gen() 2164 MB/s
[    0.851910] raid6: .... xor() 1131 MB/s, rmw enabled

I will need to keep that in mind when comparing vector performance!
Seems like this option does something weird.

- Charlie

> 
> >
> > # modprobe raid6_pq
> > [   36.238377] raid6: rvvx1    gen()  2668 MB/s
> > [   36.306381] raid6: rvvx2    gen()  3097 MB/s
> > [   36.374376] raid6: rvvx4    gen()  3366 MB/s
> > [   36.442385] raid6: int64x8  gen()   548 MB/s
> > [   36.510397] raid6: int64x4  gen()   600 MB/s
> > [   36.578388] raid6: int64x2  gen()   585 MB/s
> > [   36.646384] raid6: int64x1  gen()   518 MB/s
> > [   36.646395] raid6: using algorithm rvvx4 gen() 3366 MB/s
> > [   36.714377] raid6: .... xor() 1942 MB/s, rmw enabled
> > [   36.714387] raid6: using rvv recovery algorithm
> >
> > I also ran the raid6tests:
> >
> > raid6test: complete (2429 tests, 0 failures)
> >
> > I am not familiar with this algorithm, but since it passed all of the
> > test cases and shows a remarkable speedup, this patch seems like a great
> > improvement.
> >
> > As Jessica pointed out, please put the vector pop/push in the same block
> > as your vector instructions. While testing this code, I threw together a
> > patch for this that you can squash:
> 
> Ok, will do.
> 
> >
> > From 32117c0a5b2bbba7439af37e55631e0e38b63a7c Mon Sep 17 00:00:00 2001
> > From: Charlie Jenkins <charlie@rivosinc.com>
> > Date: Wed, 8 Jan 2025 14:32:26 -0800
> > Subject: [PATCH] Fixup vector options
> >
> > Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
> 
> Thanks for the test, review and the patch.
> Chunyan
> 
> > ---
> >  lib/raid6/Makefile    |  2 --
> >  lib/raid6/recov_rvv.c | 12 ++++---
> >  lib/raid6/rvv.c       | 81 ++++++++++++++++++++++++++++++++++++-------
> >  3 files changed, 77 insertions(+), 18 deletions(-)
> >
> > diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
> > index e62fb7cd773e..5be0a4e60ab1 100644
> > --- a/lib/raid6/Makefile
> > +++ b/lib/raid6/Makefile
> > @@ -11,8 +11,6 @@ raid6_pq-$(CONFIG_KERNEL_MODE_NEON) += neon.o neon1.o neon2.o neon4.o neon8.o re
> >  raid6_pq-$(CONFIG_S390) += s390vx8.o recov_s390xc.o
> >  raid6_pq-$(CONFIG_LOONGARCH) += loongarch_simd.o recov_loongarch_simd.o
> >  raid6_pq-$(CONFIG_RISCV_ISA_V) += rvv.o recov_rvv.o
> > -CFLAGS_rvv.o += -march=rv64gcv
> > -CFLAGS_recov_rvv.o += -march=rv64gcv
> >
> >  hostprogs      += mktables
> >
> > diff --git a/lib/raid6/recov_rvv.c b/lib/raid6/recov_rvv.c
> > index 8ae74803ea7f..02b97d885510 100644
> > --- a/lib/raid6/recov_rvv.c
> > +++ b/lib/raid6/recov_rvv.c
> > @@ -17,6 +17,7 @@ static void __raid6_2data_recov_rvv(int bytes, u8 *p, u8 *q, u8 *dp,
> >                 ".option        push\n"
> >                 ".option        arch,+v\n"
> >                 "vsetvli        x0, %[avl], e8, m1, ta, ma\n"
> > +               ".option        pop\n"
> >                 : :
> >                 [avl]"r"(16)
> >         );
> > @@ -42,6 +43,8 @@ static void __raid6_2data_recov_rvv(int bytes, u8 *p, u8 *q, u8 *dp,
> >                  * v14:p/qm[vx], v15:p/qm[vy]
> >                  */
> >                 asm volatile (
> > +                       ".option        push\n"
> > +                       ".option        arch,+v\n"
> >                         "vle8.v         v0, (%[px])\n"
> >                         "vle8.v         v1, (%[dp])\n"
> >                         "vxor.vv        v0, v0, v1\n"
> > @@ -67,6 +70,7 @@ static void __raid6_2data_recov_rvv(int bytes, u8 *p, u8 *q, u8 *dp,
> >                         "vxor.vv        v1, v3, v0\n" /* v1 = db ^ px; */
> >                         "vse8.v         v3, (%[dq])\n"
> >                         "vse8.v         v1, (%[dp])\n"
> > +                       ".option        pop\n"
> >                         : :
> >                         [px]"r"(p),
> >                         [dp]"r"(dp),
> > @@ -84,8 +88,6 @@ static void __raid6_2data_recov_rvv(int bytes, u8 *p, u8 *q, u8 *dp,
> >                 dp += 16;
> >                 dq += 16;
> >         }
> > -
> > -       asm volatile (".option pop\n");
> >  }
> >
> >  static void __raid6_datap_recov_rvv(int bytes, uint8_t *p, uint8_t *q, uint8_t *dq,
> > @@ -95,6 +97,7 @@ static void __raid6_datap_recov_rvv(int bytes, uint8_t *p, uint8_t *q, uint8_t *
> >                 ".option        push\n"
> >                 ".option        arch,+v\n"
> >                 "vsetvli        x0, %[avl], e8, m1, ta, ma\n"
> > +               ".option        pop\n"
> >                 : :
> >                 [avl]"r"(16)
> >         );
> > @@ -113,6 +116,8 @@ static void __raid6_datap_recov_rvv(int bytes, uint8_t *p, uint8_t *q, uint8_t *
> >                  * v10:m[vx], v11:m[vy]
> >                  */
> >                 asm volatile (
> > +                       ".option        push\n"
> > +                       ".option        arch,+v\n"
> >                         "vle8.v         v0, (%[vx])\n"
> >                         "vle8.v         v2, (%[dq])\n"
> >                         "vxor.vv        v0, v0, v2\n"
> > @@ -127,6 +132,7 @@ static void __raid6_datap_recov_rvv(int bytes, uint8_t *p, uint8_t *q, uint8_t *
> >                         "vxor.vv        v1, v0, v1\n"
> >                         "vse8.v         v0, (%[dq])\n"
> >                         "vse8.v         v1, (%[vy])\n"
> > +                       ".option        pop\n"
> >                         : :
> >                         [vx]"r"(q),
> >                         [vy]"r"(p),
> > @@ -140,8 +146,6 @@ static void __raid6_datap_recov_rvv(int bytes, uint8_t *p, uint8_t *q, uint8_t *
> >                 q += 16;
> >                 dq += 16;
> >         }
> > -
> > -       asm volatile (".option pop\n");
> >  }
> >
> >
> > diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
> > index 21f5432506da..81b38dcafeb6 100644
> > --- a/lib/raid6/rvv.c
> > +++ b/lib/raid6/rvv.c
> > @@ -31,14 +31,18 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
> >                 ".option        push\n"
> >                 ".option        arch,+v\n"
> >                 "vsetvli        t0, x0, e8, m1, ta, ma\n"
> > +               ".option        pop\n"
> >         );
> >
> >          /* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
> >         for (d = 0 ; d < bytes ; d += NSIZE*1) {
> >                 /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> >                 asm volatile (
> > +                       ".option        push\n"
> > +                       ".option        arch,+v\n"
> >                         "vle8.v v0, (%[wp0])\n"
> >                         "vle8.v v1, (%[wp0])\n"
> > +                       ".option        pop\n"
> >                         : :
> >                         [wp0]"r"(&dptr[z0][d+0*NSIZE])
> >                 );
> > @@ -54,6 +58,8 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
> >                          * wp$$ ^= wd$$;
> >                          */
> >                         asm volatile (
> > +                               ".option        push\n"
> > +                               ".option        arch,+v\n"
> >                                 "vsra.vi        v2, v1, 7\n"
> >                                 "vsll.vi        v3, v1, 1\n"
> >                                 "vand.vx        v2, v2, %[x1d]\n"
> > @@ -61,6 +67,7 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
> >                                 "vle8.v         v2, (%[wd0])\n"
> >                                 "vxor.vv        v1, v3, v2\n"
> >                                 "vxor.vv        v0, v0, v2\n"
> > +                               ".option        pop\n"
> >                                 : :
> >                                 [wd0]"r"(&dptr[z][d+0*NSIZE]),
> >                                 [x1d]"r"(0x1d)
> > @@ -72,15 +79,16 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
> >                  * *(unative_t *)&q[d+NSIZE*$$] = wq$$;
> >                  */
> >                 asm volatile (
> > +                       ".option        push\n"
> > +                       ".option        arch,+v\n"
> >                         "vse8.v         v0, (%[wp0])\n"
> >                         "vse8.v         v1, (%[wq0])\n"
> > +                       ".option        pop\n"
> >                         : :
> >                         [wp0]"r"(&p[d+NSIZE*0]),
> >                         [wq0]"r"(&q[d+NSIZE*0])
> >                 );
> >         }
> > -
> > -       asm volatile (".option pop\n");
> >  }
> >
> >  static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
> > @@ -98,14 +106,18 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
> >                 ".option push\n"
> >                 ".option arch,+v\n"
> >                 "vsetvli        t0, x0, e8, m1, ta, ma\n"
> > +               ".option        pop\n"
> >         );
> >
> >         /* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
> >         for (d = 0 ; d < bytes ; d += NSIZE*1) {
> >                 /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> >                 asm volatile (
> > +                       ".option        push\n"
> > +                       ".option        arch,+v\n"
> >                         "vle8.v v0, (%[wp0])\n"
> >                         "vle8.v v1, (%[wp0])\n"
> > +                       ".option        pop\n"
> >                         : :
> >                         [wp0]"r"(&dptr[z0][d+0*NSIZE])
> >                 );
> > @@ -122,6 +134,8 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
> >                          * wp$$ ^= wd$$;
> >                          */
> >                         asm volatile (
> > +                               ".option        push\n"
> > +                               ".option        arch,+v\n"
> >                                 "vsra.vi        v2, v1, 7\n"
> >                                 "vsll.vi        v3, v1, 1\n"
> >                                 "vand.vx        v2, v2, %[x1d]\n"
> > @@ -129,6 +143,7 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
> >                                 "vle8.v         v2, (%[wd0])\n"
> >                                 "vxor.vv        v1, v3, v2\n"
> >                                 "vxor.vv        v0, v0, v2\n"
> > +                               ".option        pop\n"
> >                                 : :
> >                                 [wd0]"r"(&dptr[z][d+0*NSIZE]),
> >                                 [x1d]"r"(0x1d)
> > @@ -144,10 +159,13 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
> >                          * wq$$ = w1$$ ^ w2$$;
> >                          */
> >                         asm volatile (
> > +                               ".option        push\n"
> > +                               ".option        arch,+v\n"
> >                                 "vsra.vi        v2, v1, 7\n"
> >                                 "vsll.vi        v3, v1, 1\n"
> >                                 "vand.vx        v2, v2, %[x1d]\n"
> >                                 "vxor.vv        v1, v3, v2\n"
> > +                               ".option        pop\n"
> >                                 : :
> >                                 [x1d]"r"(0x1d)
> >                         );
> > @@ -159,19 +177,20 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
> >                  * v0:wp0, v1:wq0, v2:p0, v3:q0
> >                  */
> >                 asm volatile (
> > +                       ".option        push\n"
> > +                       ".option        arch,+v\n"
> >                         "vle8.v         v2, (%[wp0])\n"
> >                         "vle8.v         v3, (%[wq0])\n"
> >                         "vxor.vv        v2, v2, v0\n"
> >                         "vxor.vv        v3, v3, v1\n"
> >                         "vse8.v         v2, (%[wp0])\n"
> >                         "vse8.v         v3, (%[wq0])\n"
> > +                       ".option        pop\n"
> >                         : :
> >                         [wp0]"r"(&p[d+NSIZE*0]),
> >                         [wq0]"r"(&q[d+NSIZE*0])
> >                 );
> >         }
> > -
> > -       asm volatile (".option pop\n");
> >  }
> >
> >  static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
> > @@ -188,6 +207,7 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
> >                 ".option        push\n"
> >                 ".option        arch,+v\n"
> >                 "vsetvli        t0, x0, e8, m1, ta, ma\n"
> > +               ".option        pop\n"
> >         );
> >
> >         /*
> > @@ -197,10 +217,13 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
> >         for (d = 0 ; d < bytes ; d += NSIZE*2) {
> >                 /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> >                 asm volatile (
> > +                       ".option        push\n"
> > +                       ".option        arch,+v\n"
> >                         "vle8.v v0, (%[wp0])\n"
> >                         "vle8.v v1, (%[wp0])\n"
> >                         "vle8.v v4, (%[wp1])\n"
> >                         "vle8.v v5, (%[wp1])\n"
> > +                       ".option        pop\n"
> >                         : :
> >                         [wp0]"r"(&dptr[z0][d+0*NSIZE]),
> >                         [wp1]"r"(&dptr[z0][d+1*NSIZE])
> > @@ -217,6 +240,8 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
> >                          * wp$$ ^= wd$$;
> >                          */
> >                         asm volatile (
> > +                               ".option        push\n"
> > +                               ".option        arch,+v\n"
> >                                 "vsra.vi        v2, v1, 7\n"
> >                                 "vsll.vi        v3, v1, 1\n"
> >                                 "vand.vx        v2, v2, %[x1d]\n"
> > @@ -232,6 +257,7 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
> >                                 "vle8.v         v6, (%[wd1])\n"
> >                                 "vxor.vv        v5, v7, v6\n"
> >                                 "vxor.vv        v4, v4, v6\n"
> > +                               ".option        pop\n"
> >                                 : :
> >                                 [wd0]"r"(&dptr[z][d+0*NSIZE]),
> >                                 [wd1]"r"(&dptr[z][d+1*NSIZE]),
> > @@ -244,10 +270,13 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
> >                  * *(unative_t *)&q[d+NSIZE*$$] = wq$$;
> >                  */
> >                 asm volatile (
> > +                       ".option        push\n"
> > +                       ".option        arch,+v\n"
> >                         "vse8.v         v0, (%[wp0])\n"
> >                         "vse8.v         v1, (%[wq0])\n"
> >                         "vse8.v         v4, (%[wp1])\n"
> >                         "vse8.v         v5, (%[wq1])\n"
> > +                       ".option        pop\n"
> >                         : :
> >                         [wp0]"r"(&p[d+NSIZE*0]),
> >                         [wq0]"r"(&q[d+NSIZE*0]),
> > @@ -255,8 +284,6 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
> >                         [wq1]"r"(&q[d+NSIZE*1])
> >                 );
> >         }
> > -
> > -       asm volatile (".option pop\n");
> >  }
> >
> >  static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
> > @@ -274,6 +301,7 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
> >                 ".option push\n"
> >                 ".option arch,+v\n"
> >                 "vsetvli        t0, x0, e8, m1, ta, ma\n"
> > +               ".option        pop\n"
> >         );
> >
> >         /*
> > @@ -283,10 +311,13 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
> >         for (d = 0 ; d < bytes ; d += NSIZE*2) {
> >                  /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> >                 asm volatile (
> > +                       ".option        push\n"
> > +                       ".option        arch,+v\n"
> >                         "vle8.v v0, (%[wp0])\n"
> >                         "vle8.v v1, (%[wp0])\n"
> >                         "vle8.v v4, (%[wp1])\n"
> >                         "vle8.v v5, (%[wp1])\n"
> > +                       ".option        pop\n"
> >                         : :
> >                         [wp0]"r"(&dptr[z0][d+0*NSIZE]),
> >                         [wp1]"r"(&dptr[z0][d+1*NSIZE])
> > @@ -304,6 +335,8 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
> >                          * wp$$ ^= wd$$;
> >                          */
> >                         asm volatile (
> > +                               ".option push\n"
> > +                               ".option arch,+v\n"
> >                                 "vsra.vi        v2, v1, 7\n"
> >                                 "vsll.vi        v3, v1, 1\n"
> >                                 "vand.vx        v2, v2, %[x1d]\n"
> > @@ -319,6 +352,7 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
> >                                 "vle8.v         v6, (%[wd1])\n"
> >                                 "vxor.vv        v5, v7, v6\n"
> >                                 "vxor.vv        v4, v4, v6\n"
> > +                               ".option        pop\n"
> >                                 : :
> >                                 [wd0]"r"(&dptr[z][d+0*NSIZE]),
> >                                 [wd1]"r"(&dptr[z][d+1*NSIZE]),
> > @@ -335,6 +369,8 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
> >                          * wq$$ = w1$$ ^ w2$$;
> >                          */
> >                         asm volatile (
> > +                               ".option push\n"
> > +                               ".option arch,+v\n"
> >                                 "vsra.vi        v2, v1, 7\n"
> >                                 "vsll.vi        v3, v1, 1\n"
> >                                 "vand.vx        v2, v2, %[x1d]\n"
> > @@ -344,6 +380,7 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
> >                                 "vsll.vi        v7, v5, 1\n"
> >                                 "vand.vx        v6, v6, %[x1d]\n"
> >                                 "vxor.vv        v5, v7, v6\n"
> > +                               ".option        pop\n"
> >                                 : :
> >                                 [x1d]"r"(0x1d)
> >                         );
> > @@ -356,6 +393,8 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
> >                  * v4:wp1, v5:wq1, v6:p1, v7:q1
> >                  */
> >                 asm volatile (
> > +                       ".option push\n"
> > +                       ".option arch,+v\n"
> >                         "vle8.v         v2, (%[wp0])\n"
> >                         "vle8.v         v3, (%[wq0])\n"
> >                         "vxor.vv        v2, v2, v0\n"
> > @@ -369,6 +408,7 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
> >                         "vxor.vv        v7, v7, v5\n"
> >                         "vse8.v         v6, (%[wp1])\n"
> >                         "vse8.v         v7, (%[wq1])\n"
> > +                       ".option        pop\n"
> >                         : :
> >                         [wp0]"r"(&p[d+NSIZE*0]),
> >                         [wq0]"r"(&q[d+NSIZE*0]),
> > @@ -376,8 +416,6 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
> >                         [wq1]"r"(&q[d+NSIZE*1])
> >                 );
> >         }
> > -
> > -       asm volatile (".option pop\n");
> >  }
> >
> >  static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
> > @@ -394,6 +432,7 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
> >                 ".option        push\n"
> >                 ".option        arch,+v\n"
> >                 "vsetvli        t0, x0, e8, m1, ta, ma\n"
> > +               ".option        pop\n"
> >         );
> >
> >         /*
> > @@ -405,6 +444,8 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
> >         for (d = 0 ; d < bytes ; d += NSIZE*4) {
> >                 /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> >                 asm volatile (
> > +                       ".option push\n"
> > +                       ".option arch,+v\n"
> >                         "vle8.v v0, (%[wp0])\n"
> >                         "vle8.v v1, (%[wp0])\n"
> >                         "vle8.v v4, (%[wp1])\n"
> > @@ -413,6 +454,7 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
> >                         "vle8.v v9, (%[wp2])\n"
> >                         "vle8.v v12, (%[wp3])\n"
> >                         "vle8.v v13, (%[wp3])\n"
> > +                       ".option        pop\n"
> >                         : :
> >                         [wp0]"r"(&dptr[z0][d+0*NSIZE]),
> >                         [wp1]"r"(&dptr[z0][d+1*NSIZE]),
> > @@ -431,6 +473,8 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
> >                          * wp$$ ^= wd$$;
> >                          */
> >                         asm volatile (
> > +                               ".option push\n"
> > +                               ".option arch,+v\n"
> >                                 "vsra.vi        v2, v1, 7\n"
> >                                 "vsll.vi        v3, v1, 1\n"
> >                                 "vand.vx        v2, v2, %[x1d]\n"
> > @@ -462,6 +506,7 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
> >                                 "vle8.v         v14, (%[wd3])\n"
> >                                 "vxor.vv        v13, v15, v14\n"
> >                                 "vxor.vv        v12, v12, v14\n"
> > +                               ".option        pop\n"
> >                                 : :
> >                                 [wd0]"r"(&dptr[z][d+0*NSIZE]),
> >                                 [wd1]"r"(&dptr[z][d+1*NSIZE]),
> > @@ -476,6 +521,8 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
> >                  * *(unative_t *)&q[d+NSIZE*$$] = wq$$;
> >                  */
> >                 asm volatile (
> > +                       ".option push\n"
> > +                       ".option arch,+v\n"
> >                         "vse8.v v0, (%[wp0])\n"
> >                         "vse8.v v1, (%[wq0])\n"
> >                         "vse8.v v4, (%[wp1])\n"
> > @@ -484,6 +531,7 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
> >                         "vse8.v v9, (%[wq2])\n"
> >                         "vse8.v v12, (%[wp3])\n"
> >                         "vse8.v v13, (%[wq3])\n"
> > +                       ".option        pop\n"
> >                         : :
> >                         [wp0]"r"(&p[d+NSIZE*0]),
> >                         [wq0]"r"(&q[d+NSIZE*0]),
> > @@ -495,8 +543,6 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
> >                         [wq3]"r"(&q[d+NSIZE*3])
> >                 );
> >         }
> > -
> > -       asm volatile (".option pop\n");
> >  }
> >
> >  static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
> > @@ -514,6 +560,7 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
> >                 ".option push\n"
> >                 ".option arch,+v\n"
> >                 "vsetvli        t0, x0, e8, m1, ta, ma\n"
> > +               ".option        pop\n"
> >         );
> >
> >         /*
> > @@ -525,6 +572,8 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
> >         for (d = 0 ; d < bytes ; d += NSIZE*4) {
> >                  /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> >                 asm volatile (
> > +                       ".option push\n"
> > +                       ".option arch,+v\n"
> >                         "vle8.v v0, (%[wp0])\n"
> >                         "vle8.v v1, (%[wp0])\n"
> >                         "vle8.v v4, (%[wp1])\n"
> > @@ -533,6 +582,7 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
> >                         "vle8.v v9, (%[wp2])\n"
> >                         "vle8.v v12, (%[wp3])\n"
> >                         "vle8.v v13, (%[wp3])\n"
> > +                       ".option        pop\n"
> >                         : :
> >                         [wp0]"r"(&dptr[z0][d+0*NSIZE]),
> >                         [wp1]"r"(&dptr[z0][d+1*NSIZE]),
> > @@ -552,6 +602,8 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
> >                          * wp$$ ^= wd$$;
> >                          */
> >                         asm volatile (
> > +                               ".option push\n"
> > +                               ".option arch,+v\n"
> >                                 "vsra.vi        v2, v1, 7\n"
> >                                 "vsll.vi        v3, v1, 1\n"
> >                                 "vand.vx        v2, v2, %[x1d]\n"
> > @@ -583,6 +635,7 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
> >                                 "vle8.v         v14, (%[wd3])\n"
> >                                 "vxor.vv        v13, v15, v14\n"
> >                                 "vxor.vv        v12, v12, v14\n"
> > +                               ".option        pop\n"
> >                                 : :
> >                                 [wd0]"r"(&dptr[z][d+0*NSIZE]),
> >                                 [wd1]"r"(&dptr[z][d+1*NSIZE]),
> > @@ -601,6 +654,8 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
> >                          * wq$$ = w1$$ ^ w2$$;
> >                          */
> >                         asm volatile (
> > +                               ".option push\n"
> > +                               ".option arch,+v\n"
> >                                 "vsra.vi        v2, v1, 7\n"
> >                                 "vsll.vi        v3, v1, 1\n"
> >                                 "vand.vx        v2, v2, %[x1d]\n"
> > @@ -620,6 +675,7 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
> >                                 "vsll.vi        v15, v13, 1\n"
> >                                 "vand.vx        v14, v14, %[x1d]\n"
> >                                 "vxor.vv        v13, v15, v14\n"
> > +                               ".option        pop\n"
> >                                 : :
> >                                 [x1d]"r"(0x1d)
> >                         );
> > @@ -634,6 +690,8 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
> >                  * v12:wp3, v13:wq3, v14:p3, v15:q3
> >                  */
> >                 asm volatile (
> > +                       ".option push\n"
> > +                       ".option arch,+v\n"
> >                         "vle8.v         v2, (%[wp0])\n"
> >                         "vle8.v         v3, (%[wq0])\n"
> >                         "vxor.vv        v2, v2, v0\n"
> > @@ -661,6 +719,7 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
> >                         "vxor.vv        v15, v15, v13\n"
> >                         "vse8.v         v14, (%[wp3])\n"
> >                         "vse8.v         v15, (%[wq3])\n"
> > +                       ".option        pop\n"
> >                         : :
> >                         [wp0]"r"(&p[d+NSIZE*0]),
> >                         [wq0]"r"(&q[d+NSIZE*0]),
> > @@ -672,8 +731,6 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
> >                         [wq3]"r"(&q[d+NSIZE*3])
> >                 );
> >         }
> > -
> > -       asm volatile (".option pop\n");
> >  }
> >
> >  #define RAID6_RVV_WRAPPER(_n)                                          \
> > --
> > 2.34.1
> >
> >
> > - Charlie
> >
