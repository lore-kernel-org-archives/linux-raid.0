Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDCA15E96;
	Mon, 23 Dec 2024 02:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734920245; cv=none; b=qUrLP3pR57SN+qzwyJaq/866Bfs4Afmmq44d06Z8VzAym9ZtmlGyO1FVSb7pohxg2T2vJcbCaUD+bO7S5/mFzrl97VdafyDV4Revvuep6CQOEKFt0KDEBtveScUPyTHgJax9ib+wRtgxnB1jE3SvG1wRdduZSdefYjwmHXUQ+5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734920245; c=relaxed/simple;
	bh=f6EjKyeSgxHpQbloRxe8lYOB5Xu5ubrgFw0Jop3M5yQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A+zjKKMDvPLxMIWx8AAGF9nPhhfx6dlnN6yC6fG+yzYhG/X/icTjETsbk/DvkyWiYlQ9tnfsQqYufiSGfx1Q/5qI6Mm4bN+RdcmbbjhA1E8kN/jCBxENOCwYCRFsitJYm/vT9IvBo1Hh/imsfEnfAahKduMny2NMsfU4sabRMGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DqMEn8bn; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DqMEn8bn"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5f6497fbccbso455765eaf.0;
        Sun, 22 Dec 2024 18:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734920242; x=1735525042; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W8Z8lmmwR8uvxSP9AWR+3lYFC2EvS9zFcprUPj/Bjjc=;
        b=DqMEn8bnjgkwWjV0Rfo+U65wgyAjesEAq3aZCVPvm9+zoXPQljDcw7ZTRfSkPKcAyH
         lh8N7gIgtwx62i2GFzZrxl7uXY5tiNBT+lSV0OVUvaMoDHVmwbBLWgMlnQkP6qPN/1WK
         tI1wrLQphy1hXaCSRl9Sb3QRRc3CUfv+5htHYZ7ETUQJqKGE7FrVn7+/X0iMcKKEl7uA
         9KAgCgoOJ5EkuZWwrZzuFOtIxhIwm5WmJB17V9dOIwVYckY68wb4OATbvUaTh6Ru5Jqm
         WrCyIA32ClqBeTVUOgkLzd4BsFWJT21K/AuqDzMxgbsFaLYrlt/SfvVmqHFweZPnd47g
         P3gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734920242; x=1735525042;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W8Z8lmmwR8uvxSP9AWR+3lYFC2EvS9zFcprUPj/Bjjc=;
        b=j/dO+zpqxxOvIGF4jtcUiu96PKEoZJKhQRx9wVhNfiRKVduhW5vgNEymEZp7Wf83DO
         6fOw8efoThrjr1t5V7ypN8XQd3/tVyDWHwWwOfH19Ghpfn3NeGdmqM/+X5Sf+C+B7+ls
         FrTGbrX3AFw0BdCz9sGExPuNnK0Cedswnbw7SpJwLuSmGgYSN34+C33cFcrKwKvSGpph
         vjNWb1mD7oakAWyB8HrzAt64QAuoaJB7wqHoODTQxH87Q3CiF//lsew8lZeMe0UxFWjf
         Ey5X8CUTi2d7uCSvVpUvbVQHmJCwR54zIbH8pDmF2Iai6caNsOwFbqCAH3kMDKKkrUC+
         IuVw==
X-Forwarded-Encrypted: i=1; AJvYcCU3R7n/jleyzNZqey46AsyGbRJUAJDs9zh5A2A6BP6MsA99jmc6PK2kIfz1j4zEQTKKxpuSl6AETiZcLQ==@vger.kernel.org, AJvYcCX15VoYEeivZKz5MKbNacx0e46dWQi0lnIyEr3OuVgPLA44uAquF8Rb+yQIe9JYKnfBGaHgedwchzqoXV8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd5SHABZWUsPJKKipwRq6FYByxPIVMCBQSCowap66UF7eYR4j8
	5/dXRjFvxJHDcmB4fqEAY3Z1dkKZ2u5mSjVb4KgI7gZq3wZC2H5A083DK1tHIMSKfP40lYK0ayr
	K7fJNLySJRE7oqFjNPjcnRRUak8c=
X-Gm-Gg: ASbGncuz4kcw5idbBQ/j08D9vfNCn8YYyUpKI4SdrvE+9yUEfCU1eYCFZzCaKi5M9Y0
	277UgORiGpnSUWhxx8pZLBKwJtky3eQvE1zTGy9uOdG4kUAvI9ghnI8vOuDCd+SN5+9dLjw==
X-Google-Smtp-Source: AGHT+IHrAiva6+861CNkYIYsWDV0r177Tfu+s274YXCQb4sRs+JgfStLdAgVU1KibB4pbKVN+AhiTYfQNt+u7nv5bMk=
X-Received: by 2002:a05:6870:5686:b0:29d:ccd5:16f0 with SMTP id
 586e51a60fabf-2a7fcd5bc8cmr6625539fac.20.1734920242345; Sun, 22 Dec 2024
 18:17:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241220114023.667347-1-zhangchunyan@iscas.ac.cn>
 <20241220-chaste-mundane-5514462147b6@spud> <CAAfSe-tT7f3to0CPyF-DK09E+NNwN+tRpmuNwtTqbe3=_y3sFg@mail.gmail.com>
 <20241223-bunch-deceased-33c10c5b3dc4@spud>
In-Reply-To: <20241223-bunch-deceased-33c10c5b3dc4@spud>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Mon, 23 Dec 2024 10:16:46 +0800
Message-ID: <CAAfSe-sPBHY_AUCksMj2qxHi2PchWpkV4JH0DzXF56Kvpwm0bg@mail.gmail.com>
Subject: Re: [RFC PATCH] raid6: Add RISC-V SIMD syndrome and recovery calculations
To: Conor Dooley <conor@kernel.org>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai3@huawei.com>, linux-riscv@lists.infradead.org, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 23 Dec 2024 at 09:35, Conor Dooley <conor@kernel.org> wrote:
>
> On Mon, Dec 23, 2024 at 09:16:38AM +0800, Chunyan Zhang wrote:
> > Hi Conor,
> >
> > On Sat, 21 Dec 2024 at 06:52, Conor Dooley <conor@kernel.org> wrote:
> > >
> > > On Fri, Dec 20, 2024 at 07:40:23PM +0800, Chunyan Zhang wrote:
> > > > The assembly is originally based on the ARM NEON and int.uc, but uses
> > > > RISC-V vector instructions to implement the RAID6 syndrome and
> > > > recovery calculations.
> > > >
> > > > The functions are tested on QEMU.
> > > >
> > > > Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> > > > ---
> > > >  include/linux/raid/pq.h |   4 +
> > > >  lib/raid6/Makefile      |   3 +
> > > >  lib/raid6/algos.c       |   8 +
> > > >  lib/raid6/recov_rvv.c   | 229 +++++++++++++
> > > >  lib/raid6/rvv.c         | 715 ++++++++++++++++++++++++++++++++++++++++
> > > >  5 files changed, 959 insertions(+)
> > > >  create mode 100644 lib/raid6/recov_rvv.c
> > > >  create mode 100644 lib/raid6/rvv.c
> > > >
> > > > diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
> > > > index 98030accf641..4c21f06c662a 100644
> > > > --- a/include/linux/raid/pq.h
> > > > +++ b/include/linux/raid/pq.h
> > > > @@ -108,6 +108,9 @@ extern const struct raid6_calls raid6_vpermxor4;
> > > >  extern const struct raid6_calls raid6_vpermxor8;
> > > >  extern const struct raid6_calls raid6_lsx;
> > > >  extern const struct raid6_calls raid6_lasx;
> > > > +extern const struct raid6_calls raid6_rvvx1;
> > > > +extern const struct raid6_calls raid6_rvvx2;
> > > > +extern const struct raid6_calls raid6_rvvx4;
> > > >
> > > >  struct raid6_recov_calls {
> > > >       void (*data2)(int, size_t, int, int, void **);
> > > > @@ -125,6 +128,7 @@ extern const struct raid6_recov_calls raid6_recov_s390xc;
> > > >  extern const struct raid6_recov_calls raid6_recov_neon;
> > > >  extern const struct raid6_recov_calls raid6_recov_lsx;
> > > >  extern const struct raid6_recov_calls raid6_recov_lasx;
> > > > +extern const struct raid6_recov_calls raid6_recov_rvv;
> > > >
> > > >  extern const struct raid6_calls raid6_neonx1;
> > > >  extern const struct raid6_calls raid6_neonx2;
> > > > diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
> > > > index 29127dd05d63..e62fb7cd773e 100644
> > > > --- a/lib/raid6/Makefile
> > > > +++ b/lib/raid6/Makefile
> > > > @@ -10,6 +10,9 @@ raid6_pq-$(CONFIG_ALTIVEC) += altivec1.o altivec2.o altivec4.o altivec8.o \
> > > >  raid6_pq-$(CONFIG_KERNEL_MODE_NEON) += neon.o neon1.o neon2.o neon4.o neon8.o recov_neon.o recov_neon_inner.o
> > > >  raid6_pq-$(CONFIG_S390) += s390vx8.o recov_s390xc.o
> > > >  raid6_pq-$(CONFIG_LOONGARCH) += loongarch_simd.o recov_loongarch_simd.o
> > > > +raid6_pq-$(CONFIG_RISCV_ISA_V) += rvv.o recov_rvv.o
> > > > +CFLAGS_rvv.o += -march=rv64gcv
> > > > +CFLAGS_recov_rvv.o += -march=rv64gcv
> > >
> > > I'm curious - why do you need this when you're using .option arch,+v
> > > below?
> >
> > Compiler would complain the errors like below without this flag:
> >
> > Error: unrecognized opcode `vle8.v v0,(a3)', extension `v' or `zve64x'
> > or `zve32x' required
>
> Right, but the reason for using .option arch,+v elsewhere in the kernel
> is because we don't want the compiler to generate vector code at all,
> and the directive lets the assembler handle the vector instructions. If
> I recall correctly, the error you pasted above is from the assembler,

Yes, it is from the assembler.

> not the compiler. You should be able to just set AFLAGS, given that all

It complains the same errors after simply replacing CFLAGS with AFLAGS
here. What am I missing?

Thanks,
Chunyan

> of the vector code you're adding is hand written as far as I can see.
>
> > > >  hostprogs    += mktables
> > > >
> > > > diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> > > > index cd2e88ee1f14..0a388a605131 100644
> > > > --- a/lib/raid6/algos.c
> > > > +++ b/lib/raid6/algos.c
> > > > @@ -80,6 +80,11 @@ const struct raid6_calls * const raid6_algos[] = {
> > > >  #ifdef CONFIG_CPU_HAS_LSX
> > > >       &raid6_lsx,
> > > >  #endif
> > > > +#endif
> > > > +#ifdef CONFIG_RISCV_ISA_V
> > > > +     &raid6_rvvx1,
> > > > +     &raid6_rvvx2,
> > > > +     &raid6_rvvx4,
> > > >  #endif
> > > >       &raid6_intx8,
> > > >       &raid6_intx4,
> > > > @@ -115,6 +120,9 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
> > > >  #ifdef CONFIG_CPU_HAS_LSX
> > > >       &raid6_recov_lsx,
> > > >  #endif
> > > > +#endif
> > > > +#ifdef CONFIG_RISCV_ISA_V
> > > > +     &raid6_recov_rvv,
> > > >  #endif
> > > >       &raid6_recov_intx1,
> > > >       NULL
> > > > diff --git a/lib/raid6/recov_rvv.c b/lib/raid6/recov_rvv.c
> > > > new file mode 100644
> > > > index 000000000000..8ae74803ea7f
> > > > --- /dev/null
> > > > +++ b/lib/raid6/recov_rvv.c
> > > > @@ -0,0 +1,229 @@
> > > > +// SPDX-License-Identifier: GPL-2.0-only
> > > > +/*
> > > > + * Copyright 2024 Institute of Software, CAS.
> > > > + * Author: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> > > > + */
> > > > +
> > > > +#include <asm/simd.h>
> > > > +#include <asm/vector.h>
> > > > +#include <crypto/internal/simd.h>
> > > > +#include <linux/raid/pq.h>
> > > > +
> > > > +static void __raid6_2data_recov_rvv(int bytes, u8 *p, u8 *q, u8 *dp,
> > > > +                           u8 *dq, const u8 *pbmul,
> > > > +                           const u8 *qmul)
> > > > +{
> > > > +     asm volatile (
> > > > +             ".option        push\n"
> > > > +             ".option        arch,+v\n"
