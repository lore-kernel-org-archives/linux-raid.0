Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3543414B965;
	Wed, 11 Jun 2025 02:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749607754; cv=none; b=lcXhemSSsCnveOp4AXy4cU1tGtPX44QnEoSjssvFUgCtli44q0beDZWUImsyFl6XyA4c4A2j8am2i6IenwfjT51JPZKj3oZ7jfOQ6taG+hCNQwrF+5PBp1i8W5FWIRuBj979MzJuUjV3Qwjozw3iwWdgWfwKFfhWJOY8U164GUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749607754; c=relaxed/simple;
	bh=I7yjLDCSaLdRJjVNniqC5HkjGP6w8dmzXiVbjwJYDvo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q2e/JDdpALEJGkfVDDNSP4CmBmJ2Ihu//6Nrh7TWBkzs5dAhxMuZG/DjflRVPeWRICv/KRV69k1BKTA996fJyNXy8YRhwt53oSmi7PivvQPvtQenS5khk4iOVLzFt6Tde5IDaFu8lYsoOnKgPSbso14YGshW2Pj7yZ34PlYGDJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iTfXm9jT; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iTfXm9jT"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-610cbca60cdso1732064eaf.0;
        Tue, 10 Jun 2025 19:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749607752; x=1750212552; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gxKo71rX6rlY0KRUmmuSGoEjab+AY2c0qjzSck5nf48=;
        b=iTfXm9jTtg33h5kfFexylM4Ahn93rJv8jA9LTCI4JkkPQCtLE8ECXb6a54YTz+utwX
         afovVIymxI9JRuaJCslgIzErLFiFgYfqr94tuDQ6RmFOA9FLOdD5eiwg7iTkvAQzSjsJ
         tAy+IpUV0WLYE+W4q1Kniaqft7rwlkw5s6aROv9o5upBEuM8fD9vyd9rtuB4u+5gNB+X
         BnNNrNxb+0Vc0AyGzPg3Vmw6lUsfWTisy5N+QyKMXWIXJ203sJ1rDIOj0WYF9w+fDwUk
         UF8IjwHIDbxiIgi2ZOmzZxlBCtBuhMLm4ZLlHH14tk4WxAhdHlzSRVDi9qdnvBP6h/zS
         SkiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749607752; x=1750212552;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gxKo71rX6rlY0KRUmmuSGoEjab+AY2c0qjzSck5nf48=;
        b=H3qoNHAsZETzRqmrgqrXIkTtgfWkFcXg80+xR54EsxsPrmfyuK4zz7p0AL8pg6SatL
         6V25Mc5F20zZn/Ab7n7wfreOxGGNTio8yBl0okzibSH3r3EDx7+i+MAvGhtbmfwyMcjX
         dNPCnftBvw8nBlJ0Cre7uwrRIejSXlAohvINo+RaGynrbi1j2Ou//rS2CMk8oKaEJbDJ
         4YQ3Qpc4pu8ijVLvEaXu7VEWTkU3tD1oWzo4cp1dg6IaZOtwg7tuFMrLRDOX8pMxED6S
         S8bWHk4IJczj73hCBCLu6HpS8gK8IYTzgByBaSuoLm4f363l610HyWnb4DA8pfnJPeRw
         B6SA==
X-Forwarded-Encrypted: i=1; AJvYcCUD0J4ou5ZsY7ramHsYOIHAHBowyx9LmhuXEVjbegpt98oI4Bjwk2szP1g6y7sGtl8+7/qWMYFflwu5SQ==@vger.kernel.org, AJvYcCVDBuTyIv/Pv7cEDL4pEmjxenBWk5Udo5LRvcaQAbUVtYVxM+U11kLvcUeXE8F2uk5owC8O+BQ8mlmiX3w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2Kxi/LO7mIAlqIR/oxYqlCOmcv6R1Cndu9c+jCeEdDNkNtHsK
	UWKbjc0eT6eEC9+K+pNxCerkUbHXoPmHx8DfbkyEXrnz+XZtgv1/us+p+9Xx1ehrNK8NV3b/Fx4
	PiEowoBMmz6Kvbu/0+Fth3hXRIpHC49s=
X-Gm-Gg: ASbGncsQnv1GwsmqkhoHUYMdv9B0C80E2QrhJIUz62X5x8I5nDGRkGudo/Rg+MIQDnZ
	4g3yVVxBC0082VI4ut7/w0w1JA/N938RJ+vLvXwnfuYW/GJBg8W4Hk3WncRoahLvOxWn7LmmoTW
	nY1OvsW6VgZNQXPS9iMoU2MU6wvtyj68ksjoRTMOsgJa6F6R+2TB8X2H14IEQ0PC+xo6K+oFRt1
	LCL/uywG90dQA==
X-Google-Smtp-Source: AGHT+IHyJRyj40Bz/LBpIhLYcMRdpMcH4YYawUfvEOhIJ/n8plnPEVv4INd3H7MIibUkZgrNmCuE9Lq5Kd/IU/Un3DY=
X-Received: by 2002:a05:6870:164c:b0:2d5:b914:fe40 with SMTP id
 586e51a60fabf-2ea96d59f39mr884660fac.20.1749607752076; Tue, 10 Jun 2025
 19:09:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250610101234.1100660-1-zhangchunyan@iscas.ac.cn> <d052f010-410a-4405-9ae6-f679649851ea@ghiti.fr>
In-Reply-To: <d052f010-410a-4405-9ae6-f679649851ea@ghiti.fr>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Wed, 11 Jun 2025 10:08:36 +0800
X-Gm-Features: AX0GCFvQK2GyRzBZQ9wryH17mKXhHeim9DS4RegYUkUd3QrryodeeBQJklb1Enk
Message-ID: <CAAfSe-svuyG01qyCVERn2iU9HTJEiHD5Wwc3FtJX_gsL59qP8g@mail.gmail.com>
Subject: Re: [PATCH 0/4] Fix a segmentation fault also add raid6test for
 RISC-V support
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Charlie Jenkins <charlie@rivosinc.com>, Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	linux-riscv@lists.infradead.org, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Alex,

On Wed, 11 Jun 2025 at 03:23, Alexandre Ghiti <alex@ghiti.fr> wrote:
>
> Hi Chunyan,
>
> On 6/10/25 12:12, Chunyan Zhang wrote:
> > The first two patches are fixes.
> > The last two are for userspace raid6test support on RISC-V.
> >
> > The issue fixed in patch 2/4 was probably the same which was spotted by
> > Charlie [1], I couldn't reproduce it at that time.
> >
> > When running raid6test in userspace on RISC-V, I saw a segmentation fault,
> > I used gdb command to print pointer p, it was an unaccessible address.
>
>
> Can you give me your config, kernel and toolchain versions? I can't
> reproduce the segfault on my machine.

I can use the below combination to reproduce:

- riscv/configs/defconfig
- Kernel v6.16-rc1
- Cross-compile toolchain [1] for building kernel which brings up QEMU
(running Ubuntu 22.04)
- Two choices for compiling raid6test program after applying patches 3-4:
1) Use toolchain [1] to cross-compile it as statically linked.
2) Compile it locally on QEMU (running Ubuntu 22.04) with local riscv gcc:

root@riscv-ubuntu2204:~# gcc --version
gcc (Ubuntu 12.3.0-1ubuntu1~22.04) 12.3.0

Thanks,
Chunyan

[1] https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/2025.05.30/riscv64-glibc-ubuntu-22.04-gcc-nightly-2025.05.30-nightly.tar.xz



>
> Thanks for the fixes and the test, I'll take a look this week.
>
> Alex
>
>
> >
> > With patch 2/4, the issue didn't appear anymore.
> >
> > [1] https://lore.kernel.org/lkml/Z5gJ35pXI2W41QDk@ghost/
> >
> > Chunyan Zhang (4):
> >    raid6: riscv: clean up unused header file inclusion
> >    raid6: riscv: Fix NULL pointer dereference issue
> >    raid6: riscv: Allow code to be compiled in userspace
> >    raid6: test: add support for RISC-V
> >
> >   lib/raid6/recov_rvv.c   |  9 +-----
> >   lib/raid6/rvv.c         | 62 +++++++++++++++++++++--------------------
> >   lib/raid6/rvv.h         | 15 ++++++++++
> >   lib/raid6/test/Makefile |  8 ++++++
> >   4 files changed, 56 insertions(+), 38 deletions(-)
> >
