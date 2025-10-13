Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D75A1F419B
	for <linux-raid@vger.kernel.org>; Mon, 13 Oct 2025 01:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760319764; cv=none; b=m5mmP6tc0X8Ki6Oo1mYpGjPX43YQf/klNQ2S5ESs4LqfVU9ncxa4H9OM2P/zq83U9s8PMeNNurOzB+LQ0gIS90XzMAOKooXoa0NXlju9Oc+KjBQcN9mvFyGZM8DF11C/qMQ3CjebqvYatLH1JiMcUJTfajljrMLwwB/6EMd9Om8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760319764; c=relaxed/simple;
	bh=1RXmBvZpwCUQnfnUxu504fpIYK8mVRkUaMUCkiuljCo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a3AkJpMRZRynqtVke1MPrlZtr/mJoN/gydPtB1+ZE1gYiTMbClhimf8gM+L1mOg3GkCmbCXq8wJOUcCAsPrFWNeZx0n+DMc3dGhWC93QOg1s54Z3fn+RXL1awdWXCW20ydm5bRn3XMUNdQJKUzGnkskzsV5bg8brfZIzQmNJMr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E9axQ+OV; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E9axQ+OV"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-64442ff55c2so1088307eaf.2
        for <linux-raid@vger.kernel.org>; Sun, 12 Oct 2025 18:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760319761; x=1760924561; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XZPY89QcCW1ODY+qCZOoE3O7xE8AabOtvINBloElcoI=;
        b=E9axQ+OV5SmngzW9W/8SAOGOh3cwu0VpYKFd+9NQ6gclFK9/zFRbv8Tbkx/hugO1LH
         rPJXclQSitl39BtheZljZPpfn90YFFGlIEGN7zzKHoofDw8vZiC39SRqbhi1RgcDAvH/
         1BBg1raBxJbKCMv+PzuYDzec0fgON6BsezCEPucCPlTgw65jheJh7qwv72cjH/D3EByT
         fQkfJR2jhzTaC9IwC7QMdrm0u21mgdxSkiYngrvzm4chvFOI7PiNO7nwNxEDfoili0U6
         4g3PHf0PsCUHRR9KqkGjdzr5ahhgBXdtUJbKRIZhpM4Cgfql5O0E34bRHkAQRiQuLECo
         qLmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760319761; x=1760924561;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XZPY89QcCW1ODY+qCZOoE3O7xE8AabOtvINBloElcoI=;
        b=Wk8iPTJ+T9tB/49teVlEbn2co3C5Aj2wHiTrIvNH5vcbSskjhGHuHLiXsHgERDyI3l
         KD7xaBjWSft/TTn7QgRT0GnXQZMUW7dQoj4I3HyUIJ19QPSOZQgxV+2MhVoghIB6jgEX
         MvHoXyD9yHZiBg/SVsVOzIuZPoz6DEUqjGr+kGGjCeKjAOD1bIUQSGNz2W3zYB4lsAgZ
         OQYveIxK+TrmFWGGH5WigDFWR8FrzlcUCpSb/zDyF3gAGka2Uz7WOh1dhzBGjX/HrPaG
         0HQSzvR7WfA3Ew5B+VgfBVBDtYOUYLx7Ezj9zNEHklQPoXZB8BZV53IKDhKjEHUUXHIm
         nBUw==
X-Forwarded-Encrypted: i=1; AJvYcCVFu95WljSU99lYVQJkvyWhZoeoAHgOUPR5ZsIao5ddGLEVmL8c7gjGz8QhfOKXiwzrMlMa51pk9jz7@vger.kernel.org
X-Gm-Message-State: AOJu0Yzk3gFi0X4kyzPFzl9QmjMkxc0t6VNKfqdz+6Pn9JQxsgC9RvLO
	+OCaz73kHCgmh0mBol9ZpeNX+Qfy6SrzRhqm1oTCupiUJVNgQh/oFW9kTUyPk/0NA/cNxb2u4Qm
	9QPROmtM6a7hyWIJW48bgP8fzIq7UBgs=
X-Gm-Gg: ASbGncvxcOxMPR0dl0Zb93+MyPbkagKbcw9TxMfD6cYKuuZ55xU1tpbWkjB2OTA+kah
	xJAX1rcV3yGjXyVAGz+BdEmnWLpmHOZP/ZMmT4u0CHvduoTxUaZNK+Q4+55mrh7EjCZ/3HHyn1H
	Fo1nMtH4ONo0OdxGvM3U3mUyxyC/DVPXD92D/uBIPj5kOHMF00wNVTU+LPfQWQYcziF3AgGop75
	+GxhLiQmzXBgtVje2j5l09f
X-Google-Smtp-Source: AGHT+IHYP3dibH/f1x2CaUF5Y5qltN0GZfOBX7majkaJVuTomgK3AWbTQB+oXo1Tc7gUg4HY3nLwGt47mmcXZ0kFDMQ=
X-Received: by 2002:a05:6808:6ec7:b0:441:8f74:e7f with SMTP id
 5614622812f47-4418f741aeamr5973198b6e.57.1760319761263; Sun, 12 Oct 2025
 18:42:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250718072711.3865118-1-zhangchunyan@iscas.ac.cn>
 <20250718072711.3865118-6-zhangchunyan@iscas.ac.cn> <00a97b26-0269-4c07-99b9-33bb759067f5@ghiti.fr>
In-Reply-To: <00a97b26-0269-4c07-99b9-33bb759067f5@ghiti.fr>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Mon, 13 Oct 2025 09:42:05 +0800
X-Gm-Features: AS18NWAl8D98G1NQ5dYcpQkVO0Vnz4Q2Mr7ADFdoZHPtKW0Eo0sci0K7w0wIY68
Message-ID: <CAAfSe-umv64D011cjxPJEc0dBK29Xa4u6m1T=-THZ+V=a3f+JA@mail.gmail.com>
Subject: Re: [PATCH V3 5/5] raid6: test: Add support for RISC-V
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Charlie Jenkins <charlie@rivosinc.com>, Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	linux-riscv@lists.infradead.org, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 18 Jul 2025 at 22:09, Alexandre Ghiti <alex@ghiti.fr> wrote:
>
> Hi Chunyan,
>
> On 7/18/25 09:27, Chunyan Zhang wrote:
> > From: Chunyan Zhang <zhang.lyra@gmail.com>
> >
> > Add RISC-V code to be compiled to allow the userspace raid6test program
> > to be built and run on RISC-V.
> >
> > Signed-off-by: Chunyan Zhang <zhang.lyra@gmail.com>
> > ---
> >   lib/raid6/test/Makefile | 8 ++++++++
> >   1 file changed, 8 insertions(+)
> >
> > diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
> > index 8f2dd2210ba8..09bbe2b14cce 100644
> > --- a/lib/raid6/test/Makefile
> > +++ b/lib/raid6/test/Makefile
> > @@ -35,6 +35,11 @@ ifeq ($(ARCH),aarch64)
> >           HAS_NEON = yes
> >   endif
> >
> > +ifeq ($(findstring riscv,$(ARCH)),riscv)
> > +        CFLAGS += -I../../../arch/riscv/include -DCONFIG_RISCV=1
> > +        HAS_RVV = yes
> > +endif
> > +
> >   ifeq ($(findstring ppc,$(ARCH)),ppc)
> >           CFLAGS += -I../../../arch/powerpc/include
> >           HAS_ALTIVEC := $(shell printf '$(pound)include <altivec.h>\nvector int a;\n' |\
> > @@ -63,6 +68,9 @@ else ifeq ($(HAS_ALTIVEC),yes)
> >                   vpermxor1.o vpermxor2.o vpermxor4.o vpermxor8.o
> >   else ifeq ($(ARCH),loongarch64)
> >           OBJS += loongarch_simd.o recov_loongarch_simd.o
> > +else ifeq ($(HAS_RVV),yes)
> > +        OBJS   += rvv.o recov_rvv.o
> > +        CFLAGS += -DCONFIG_RISCV_ISA_V=1
> >   endif
> >
> >   .c.o:
>
>
> Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com>
>
> Thanks for the new version, I'll take that for 6.17,

I noticed patch 1-2 are in 6.18-rc1, patch 3-5 haven't got merged, not
sure if there's some other plan for these patches.

Thanks,
Chunyan

> Alex
>
