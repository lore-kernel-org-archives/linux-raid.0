Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9025C746E;
	Mon, 23 Dec 2024 01:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734916638; cv=none; b=gR6bFtjxiJ92z0Gwz7qOrnIBnVm+J8kq/UwvrTzT/wZztbtxWtwfV3PrVNnr7883/p0cLAvhbsuf/xTmULxqtxytkT3VRSJ7+bnMoNLWtfFuO9Hby8JK/lbd+9HRjTncfiiEtaznRdaN2XyDMrh0chddIXJVG6ynFxlO58wOuJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734916638; c=relaxed/simple;
	bh=mABjsjgczxxesAFttLm0gzGjJxca1KUtbgwyTRFPdto=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q/3dCI8GEfWsJFOqoWz7fVG8tUx64Nk65xmtbzZFUjKIcnRGZ8m0OFFSSB8+Y0UG7FsYdhGGAtXBs9tYm04qa5f24RGou+0+ooakKtsQIy8zue12YfF5+3BBsZHB9d5wNafT+frtcqAFeO6NwP+i1OygYKoIphh1tdgMV3dRjLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UTBVPAy8; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UTBVPAy8"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-29f7b5fbc9aso1017113fac.3;
        Sun, 22 Dec 2024 17:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734916634; x=1735521434; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bHKditMwHF8yzMC7Amcucs9pLzOVlRtRe7sZOQG37xA=;
        b=UTBVPAy8N/f1W7k+Nbk9gW7221mkbLdSd1DpmIMtA7KbU72Ruue+eDvtkulxpa/h9I
         xLIeV09LObep3Sz5yzTQv7fiDyOi/k3kbmY6lk7wTWYF9mAel99ocgVvhiY7Mr29bvbZ
         CUdW4sp2Fp/rGqW9H5GURAPGDXMfjtLXGJHk+4WtwoV0FzfbbKUDF/zxdSdLVGf7gxzO
         xwNyc8Oua9XRpiEdX51lOnIVffl7eD5MTlQXMO3uGsSdmDJQE+KJ0en7g1Q4JoVR0Whr
         xievMx7LQr42dk/3PFOoZs5vu7sSeB3hiPVGJY/kOpcTPe51m1bhJ0DZnGflrpiBxnOZ
         BnZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734916634; x=1735521434;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bHKditMwHF8yzMC7Amcucs9pLzOVlRtRe7sZOQG37xA=;
        b=ajMuuJuVL3UeMQpp0E+nwpZ4PWDMqXvYdY6mpMheL43kOCB92cuXUYJwFmCqvxJXbA
         /2SfZaHY5fZgguqhKmBWBuHEqNZDANW47ufExL7HH3inyXbjornRDpzqM8RcsJ6k6n3O
         9LC3VQMeWLw8mxsbZ3EntCm4yDkEm2uN5e1eagCp4JjVfR3rBs/ZgwBSwiitw+MlQGXX
         64CAkWFGH23fzwCS1rm3x8eKQ5IUpdv2cWlYEvQKmXenL6nv/XU5XWMiqbt7D/kjIeCe
         qimF4CQGmSyaPca1JUCpC66dH+a7IAWIE8T1j6PdOrB4EyN4akLENw9pIQhixFCIjyr8
         omJg==
X-Forwarded-Encrypted: i=1; AJvYcCWAP0UXVtLOIezvudj/eaWpg7UdtVDVEC/uLytKOpQktUzh7+YYmy5QJILsjlr65HOAGKx4re6j6w7z8g==@vger.kernel.org, AJvYcCXEO5Z/oHKPdh32HDvreEBlLZX4uVHuBaggSYF5wcyyYcRUhRiAlEBYb+JI2ewloMsb23t6ngZvEsKOzyY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzF19iqskbT6Cto+V0z4/MS2OB9jWV4h5JQieF0pfvi4+UBBGtg
	wBwlOvTPZ+IGTs//F+yurxB7RXtQdkOaJnDnV9fSxVytghLVre7VP2fav9eyRZj6UuiMLXx2BNk
	ie13B4J/OdSssUylSJFEX4snnjWo=
X-Gm-Gg: ASbGncuvCgKCXwST/sbSdUU0+JXYD+/y+NoTwdBsfe/G8xaN1dvZXYxtRXAF54Dr5er
	OyjBYkQGioGVcDj6BFxrJfr8vkXNaxlvZG2X/c/6Qmhe4rXCfv/Or/TMn4nW36HlNb/IcgQ==
X-Google-Smtp-Source: AGHT+IF0PJfQz0iMDIKaer9mf/niYjoBzq6a2Y733Hyfh3OCW9CA/nDv0Wouag7c3c98R8eOz38ZVc+L+OYb0LzK4b8=
X-Received: by 2002:a05:6871:890a:b0:29e:362b:2162 with SMTP id
 586e51a60fabf-2a7fb162ad6mr6388650fac.20.1734916634443; Sun, 22 Dec 2024
 17:17:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241220114023.667347-1-zhangchunyan@iscas.ac.cn> <20241220-chaste-mundane-5514462147b6@spud>
In-Reply-To: <20241220-chaste-mundane-5514462147b6@spud>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Mon, 23 Dec 2024 09:16:38 +0800
Message-ID: <CAAfSe-tT7f3to0CPyF-DK09E+NNwN+tRpmuNwtTqbe3=_y3sFg@mail.gmail.com>
Subject: Re: [RFC PATCH] raid6: Add RISC-V SIMD syndrome and recovery calculations
To: Conor Dooley <conor@kernel.org>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai3@huawei.com>, linux-riscv@lists.infradead.org, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Conor,

On Sat, 21 Dec 2024 at 06:52, Conor Dooley <conor@kernel.org> wrote:
>
> On Fri, Dec 20, 2024 at 07:40:23PM +0800, Chunyan Zhang wrote:
> > The assembly is originally based on the ARM NEON and int.uc, but uses
> > RISC-V vector instructions to implement the RAID6 syndrome and
> > recovery calculations.
> >
> > The functions are tested on QEMU.
> >
> > Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> > ---
> >  include/linux/raid/pq.h |   4 +
> >  lib/raid6/Makefile      |   3 +
> >  lib/raid6/algos.c       |   8 +
> >  lib/raid6/recov_rvv.c   | 229 +++++++++++++
> >  lib/raid6/rvv.c         | 715 ++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 959 insertions(+)
> >  create mode 100644 lib/raid6/recov_rvv.c
> >  create mode 100644 lib/raid6/rvv.c
> >
> > diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
> > index 98030accf641..4c21f06c662a 100644
> > --- a/include/linux/raid/pq.h
> > +++ b/include/linux/raid/pq.h
> > @@ -108,6 +108,9 @@ extern const struct raid6_calls raid6_vpermxor4;
> >  extern const struct raid6_calls raid6_vpermxor8;
> >  extern const struct raid6_calls raid6_lsx;
> >  extern const struct raid6_calls raid6_lasx;
> > +extern const struct raid6_calls raid6_rvvx1;
> > +extern const struct raid6_calls raid6_rvvx2;
> > +extern const struct raid6_calls raid6_rvvx4;
> >
> >  struct raid6_recov_calls {
> >       void (*data2)(int, size_t, int, int, void **);
> > @@ -125,6 +128,7 @@ extern const struct raid6_recov_calls raid6_recov_s390xc;
> >  extern const struct raid6_recov_calls raid6_recov_neon;
> >  extern const struct raid6_recov_calls raid6_recov_lsx;
> >  extern const struct raid6_recov_calls raid6_recov_lasx;
> > +extern const struct raid6_recov_calls raid6_recov_rvv;
> >
> >  extern const struct raid6_calls raid6_neonx1;
> >  extern const struct raid6_calls raid6_neonx2;
> > diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
> > index 29127dd05d63..e62fb7cd773e 100644
> > --- a/lib/raid6/Makefile
> > +++ b/lib/raid6/Makefile
> > @@ -10,6 +10,9 @@ raid6_pq-$(CONFIG_ALTIVEC) += altivec1.o altivec2.o altivec4.o altivec8.o \
> >  raid6_pq-$(CONFIG_KERNEL_MODE_NEON) += neon.o neon1.o neon2.o neon4.o neon8.o recov_neon.o recov_neon_inner.o
> >  raid6_pq-$(CONFIG_S390) += s390vx8.o recov_s390xc.o
> >  raid6_pq-$(CONFIG_LOONGARCH) += loongarch_simd.o recov_loongarch_simd.o
> > +raid6_pq-$(CONFIG_RISCV_ISA_V) += rvv.o recov_rvv.o
> > +CFLAGS_rvv.o += -march=rv64gcv
> > +CFLAGS_recov_rvv.o += -march=rv64gcv
>
> I'm curious - why do you need this when you're using .option arch,+v
> below?

Compiler would complain the errors like below without this flag:

Error: unrecognized opcode `vle8.v v0,(a3)', extension `v' or `zve64x'
or `zve32x' required

>
> >  hostprogs    += mktables
> >
> > diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> > index cd2e88ee1f14..0a388a605131 100644
> > --- a/lib/raid6/algos.c
> > +++ b/lib/raid6/algos.c
> > @@ -80,6 +80,11 @@ const struct raid6_calls * const raid6_algos[] = {
> >  #ifdef CONFIG_CPU_HAS_LSX
> >       &raid6_lsx,
> >  #endif
> > +#endif
> > +#ifdef CONFIG_RISCV_ISA_V
> > +     &raid6_rvvx1,
> > +     &raid6_rvvx2,
> > +     &raid6_rvvx4,
> >  #endif
> >       &raid6_intx8,
> >       &raid6_intx4,
> > @@ -115,6 +120,9 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
> >  #ifdef CONFIG_CPU_HAS_LSX
> >       &raid6_recov_lsx,
> >  #endif
> > +#endif
> > +#ifdef CONFIG_RISCV_ISA_V
> > +     &raid6_recov_rvv,
> >  #endif
> >       &raid6_recov_intx1,
> >       NULL
> > diff --git a/lib/raid6/recov_rvv.c b/lib/raid6/recov_rvv.c
> > new file mode 100644
> > index 000000000000..8ae74803ea7f
> > --- /dev/null
> > +++ b/lib/raid6/recov_rvv.c
> > @@ -0,0 +1,229 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright 2024 Institute of Software, CAS.
> > + * Author: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> > + */
> > +
> > +#include <asm/simd.h>
> > +#include <asm/vector.h>
> > +#include <crypto/internal/simd.h>
> > +#include <linux/raid/pq.h>
> > +
> > +static void __raid6_2data_recov_rvv(int bytes, u8 *p, u8 *q, u8 *dp,
> > +                           u8 *dq, const u8 *pbmul,
> > +                           const u8 *qmul)
> > +{
> > +     asm volatile (
> > +             ".option        push\n"
> > +             ".option        arch,+v\n"
