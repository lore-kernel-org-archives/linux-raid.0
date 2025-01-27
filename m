Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344C5B64A
	for <linux-raid@vger.kernel.org>; Mon, 27 Jan 2025 22:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738017252; cv=none; b=okb1u4DaUcMrz3Y8WFBe0ogLk6p7ZgS6M+7LmULKrwfcgCE68XrOuQuo4Vz52og+yg64D+Jd2/qvWIwIcjUntPteZ3RNjmwW1t3xPhb/CWjkyI7cyTaqsxEHFjzU0XPzYzbwhTmBIAp3iBALTEB8BdVsweZnfgp6Z/bYANklbUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738017252; c=relaxed/simple;
	bh=X+fdaoNWKK19bTid6DEtWhmhH6C4lsqCwHCWOFrdL8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZMp/DI784VGD3WtTfQZ75xwHBpfOWQFF66fYIFUzQ5JJLFn5DBe18ixrhqr3kGZG+QZUG89eXJnn4xgaQgUuQaTi8SxA5NZjTGfvrQbxGdRWiIa5WBwA7fFgxGj4x080or5JObkfnuUk4VesM8nC7PejrWt55vpBPqQjAeoL/Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=HgcRvlDS; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="HgcRvlDS"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2164b662090so97115325ad.1
        for <linux-raid@vger.kernel.org>; Mon, 27 Jan 2025 14:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738017250; x=1738622050; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hNUQf/BH62XVFiSZqVQheOvs7cvOxVQxNhdOPTli9YQ=;
        b=HgcRvlDSy5Sq1egAqRxSAQ1HRFMZtN3aVDsCwpjOkAY/y9XSjqZcrZIwKaqQxjRJ4b
         dG4/GIBSwE0+xwQDK8oQO7a9HTII02s4ZhC2bGPRx95KtsZbadyu82gja4n3nzxoBjPA
         MP6sqL+Tq2B8LxpaG3/hNmnlkTSU8UA6/MxPFAAPgaKxlqlqtzF0b8QDuErZfbjQ2ZlD
         YH/CWMvDmmgYxwWpMmhvw4IeiOPmBs+Gd87BE3aWuzVzZxUHVy+wqj3IfjofiDjl0WN7
         BmbGA6wXfGiQHGZkTRYhgAqzlEohhmXJsUyUlc8ulIgS5lwMu4hfsE+fUdm0MrbQ3/xc
         Og/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738017250; x=1738622050;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hNUQf/BH62XVFiSZqVQheOvs7cvOxVQxNhdOPTli9YQ=;
        b=dtQgfmR7GjdGpIWojDrzFt98LzKSalJPxKxRRwKSfeNDzZ3hWBGAyPei3YJzEyRnOI
         sknn9DJiKCFKyHG5GlVyRw3dlgHNsLIbBZeuq+cWqDr9tb8sutOBTMGNyysgeYNUe+wl
         YMswwhjTS9onYdEWSsN39pJbrHsjNLwHrgZApGoXn7PdFBbt6SdU8qwo6EFpNCIRoGYu
         4kU14ScjwG/56DxLkGvxd42T8t79HmzHmZ4wvUATDt82ylpnm48hUPI3zpSG0fOlo5nw
         IpBs28YKwZm8HZHyTh/kvjwGZY8anvI11cMGnaxvn7pGtOpmAHeAspwjjkId1YnhXtEk
         gNtw==
X-Forwarded-Encrypted: i=1; AJvYcCV+VnObaWUSp7M/1BFwgc5A5Sfgxd33L4H64vA60IMVmlqbnETPc+m9v5xt6VqvFqFw6quq2jG72qjc@vger.kernel.org
X-Gm-Message-State: AOJu0Ywa707xI34H3YZMw1UCKQOeidxAg6QF33P0vvLDaJe1fRqQju1C
	ufIBQANgZU/7OVnIrLIOFVfwePhwc79ycPgrV1rSU3w3/2xNOPONokd0MxLdkJ3ZHrLkJCnEWq4
	85ck=
X-Gm-Gg: ASbGncvPQOU5ReXA7bZnmjr2ykmOpQpMBt8nDjiWiJyIfsN/4H2rKvbD4KjuWpTqKKh
	Shnji7aGLNLK2Ze1bNsUiHhK0NGgOU7RNPDbwQoZWOgcXbTf7useHcKMImUMhS8jnfx7s4S5aex
	vetPNHTSo3GchybqkvB/etyOfA9vfuZD8Ivx+A/nV8UQalopE3bGK/KEwpb+ZnuR5jK5LhbFvKh
	4c8H5B0wggYC0tTvYLjmpOrmMU9y6QbmefWhEW/KB0gXBJL7SgY3cd8IeIToiP7cSFuhkU=
X-Google-Smtp-Source: AGHT+IG1PsIZ6jEY35m/19n24um/49j+2QwIysUJvG8QmgPY/IM3AWJfA7DedGeF/WQstxSfxXf+TA==
X-Received: by 2002:a17:903:320e:b0:217:9172:2ce1 with SMTP id d9443c01a7336-21c35544407mr700049175ad.22.1738017250514;
        Mon, 27 Jan 2025 14:34:10 -0800 (PST)
Received: from ghost ([50.145.13.30])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da3ea3bb9sm69323645ad.92.2025.01.27.14.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 14:34:09 -0800 (PST)
Date: Mon, 27 Jan 2025 14:34:07 -0800
From: Charlie Jenkins <charlie@rivosinc.com>
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>, linux-riscv@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH V2] raid6: Add RISC-V SIMD syndrome and recovery
 calculations
Message-ID: <Z5gJ35pXI2W41QDk@ghost>
References: <20250127061529.2437012-1-zhangchunyan@iscas.ac.cn>
 <c0a2fbeb-9a0d-4b69-bc6b-e1652e13debf@molgen.mpg.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0a2fbeb-9a0d-4b69-bc6b-e1652e13debf@molgen.mpg.de>

On Mon, Jan 27, 2025 at 09:39:11AM +0100, Paul Menzel wrote:
> Dear Chunyan,
> 
> 
> Thank you for the patch.
> 
> 
> Am 27.01.25 um 07:15 schrieb Chunyan Zhang:
> > The assembly is originally based on the ARM NEON and int.uc, but uses
> > RISC-V vector instructions to implement the RAID6 syndrome and
> > recovery calculations.
> > 
> > Results on QEMU running with the option "-icount shift=0":
> > 
> >    raid6: rvvx1    gen()  1008 MB/s
> >    raid6: rvvx2    gen()  1395 MB/s
> >    raid6: rvvx4    gen()  1584 MB/s
> >    raid6: rvvx8    gen()  1694 MB/s
> >    raid6: int64x8  gen()   113 MB/s
> >    raid6: int64x4  gen()   116 MB/s
> >    raid6: int64x2  gen()   272 MB/s
> >    raid6: int64x1  gen()   229 MB/s
> >    raid6: using algorithm rvvx8 gen() 1694 MB/s
> >    raid6: .... xor() 1000 MB/s, rmw enabled
> >    raid6: using rvv recovery algorithm
> 
> How did you start QEMU and on what host did you run it? Does it change
> between runs? (For me these benchmark values were very unreliable in the
> past on x86 hardware.)

I reported dramatic gains on vector as well in this response [1]. Note
that these gains are only present when using the QEMU option "-icount
shift=0" vector becomes dramatically more performant. Without this
option we do not see a performance gain on QEMU. However riscv vector is
known to not be less optimized on QEMU so having vector be less
performant on some QEMU configurations is not necessarily representative
of hardware implementations.


My full qemu command is (running on x86 host):

qemu-system-riscv64 -nographic -m 1G -machine virt -smp 1\
    -kernel arch/riscv/boot/Image \
    -append "root=/dev/vda rw earlycon console=ttyS0" \
    -drive file=rootfs.ext2,format=raw,id=hd0,if=none \
    -bios default -cpu rv64,v=true,vlen=256,vext_spec=v1.0 \
    -device virtio-blk-device,drive=hd0

This is with version 9.2.0.


I am also facing this issue when executing this:

raid6: rvvx1    gen()   717 MB/s
raid6: rvvx2    gen()   734 MB/s
Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020

Only rvvx4 is failing. I applied this patch to 6.13.

- Charlie

