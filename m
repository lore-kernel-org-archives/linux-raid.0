Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCA33E7167
	for <linux-raid@vger.kernel.org>; Mon, 27 Jul 2026 10:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149698; cv=none; b=pDmdDL/Xmc+J22oustDzOd1D5LT3Mdt9tDvvBgFJBOZ/dST9jkEcy2fhWItOii/iFWf3g0B/74cgLuN0fzSKt0GfDcGJJYYLTHmCR9+SmIo3yzIv3JZyS8Sxo9lnxTjdN+wAObU/CVScrffIKQObqAGfe+jOZrZakEmtxSau5GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149698; c=relaxed/simple;
	bh=TwvJvF+IFOxdPjMalEtm3bMDlBiCPp/CDsXL3BUntdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gOWhSFZYSyC2AXWNpI+uXmq2DJAY9pJ9mXVVu11cB89es/vq5PbRIYw1+QkC6VVyLp2hox6ORZDdPyVQIsM5WbfuyU9r4108YhBXiR++DZ+UKgxv4jt7Ft1Ag2BQFP4LxbaNd6U98ysV0JGIyGnJUY98iO/uhmAfaCBFoXq4wsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=rGmGe9vA; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="rGmGe9vA"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47f904e80eeso2081429f8f.1
        for <linux-raid@vger.kernel.org>; Mon, 27 Jul 2026 03:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785149695; x=1785754495; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1ddzBsb4381N9y6zb8HnZC8qOhqxLg7V/jEwPzZdJjY=;
        b=rGmGe9vAfAtoI6wqkoOj/wsfbk1cDlIBB/2yX7WSUUjYWX50pb4ZbrQGHkKJKwnxxe
         VmHlk0l1MpBL5icE0Bzsan4zAVIcCj00QKNN4dee+sZP4DjXOpxcTS32JXcGCBz/R5d1
         csP79AVnHdhqzQkVJx5P8OswsRfDLOjLap79BJAqYWHMFsGchbvOYOvGAilBJ4KenK2X
         CF/MkV+6r5exE3IxtI2wpn0ldi5jgG88LRz51wRC4Xtbe5xRoDUPrDZGcXxK3E6kFvFE
         RBgljpYLvuCBaHGq2qM4gzDhngzPLZmI+YJ7jic9H/NQ+J7kyEZpOYVNQCmSw+F9cD+G
         2z3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785149695; x=1785754495;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1ddzBsb4381N9y6zb8HnZC8qOhqxLg7V/jEwPzZdJjY=;
        b=rWz9zOeI4FGEK+6TdRihFIwFQYVPicOpiNMTcrHgLnFVLg85AwdLBmOaLQLtnXtuUt
         o/26+OMMQapDRhxSNsMJA97Q52SotQLNAiVV3prcaGgdajxRumwEcqnTmEf5eMUqVtCB
         wD2R51mLHpCMieSgImgPR23M9q2DNHvO83TwIlQUrNzS64kBQzMGfBtUPU+nWlRK2fPb
         fI2CtR0icIVsyiwBq1CVH5LLy10qKVNVMZYujpzm18s7/EgC5JOARd1byRywvoN1og1s
         pE/EETIExwFnXVPyh2pxLJWTSYdaIKL2SLLw3fGMALATfitAxf+v1GQX1KbrNCoReMkF
         sZTg==
X-Gm-Message-State: AOJu0YzpF1WP8CVsWllBY+fnJvfrE9V3Y4wbW+Mn/LGLxJ7pHAngLabM
	RO7CpC/zApK/m7zz2nR2DLA/yPGS6VjrzDEPbz3rBrCk9uzaeMTt7PEAarEgWyZUTA==
X-Gm-Gg: AR+sD13pvMzQ5lTuR9XYTYkhHiKQ+4zNkPb12uXHOKEqm1xoC2UhFLv8sg5H2yjHfFt
	0yU6ImdOfi5Y0DvKB8odzZ3OjjXAUHY2uV7A8Nf4O0yxvKVy7dnWf2C4wfzmYRt8NVXah0oi+dg
	7tRGu6JghvvCxypLjIrg8C3b5PpjEtus+B1iNJ0JOOKJcBz68Zr7qOVbbmcM6dscHDWOmJ7e1Ot
	S0LHGIZehQT8t7w8TieCj+KI6ari7POSwbCrnB6XEUvbTcUmOKJeojhR9lwkPAl6nUFjHwAbc6P
	fTaQegWyUkitepgBaIcot8eChS4BNMyDuyrc0aSq2KD+61fLaigkXuVitLNJnLiG68FLblb+LYE
	ITlDRp22O5k/oLvDnyg+wiOLJiSA/7Zjx6R4p8qX6fDjqzJr0nI+KY6+6VKfJodNYivPvEzI1gv
	ayFCb1VwZMK6so2X7l7io5UyUQ8OToirmifgiF/ip5nOqXdCaEBnkPmPq1YVM5ghTezRwGixhaY
	/9htrsfbLBaIf2b97JUweqHjZvZvjfH/CnGiiLwFOUri1RgIu2O
X-Received: by 2002:a05:6000:188e:b0:47f:921f:3a37 with SMTP id ffacd0b85a97d-47f9fea4346mr10098687f8f.35.1785149694783;
        Mon, 27 Jul 2026 03:54:54 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c52fa9sm48930631f8f.20.2026.07.27.03.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 03:54:54 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Chen Cheng <chencheng@fnnas.com>
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yu Kuai <yukuai@fygo.io>,
	Song Liu <song@kernel.org>
Subject: Re: [PATCH v7 0/3] md/raid10: fix r10bio width mismatches across reshape
Date: Mon, 27 Jul 2026 12:54:30 +0200
Message-ID: <20260727105434.2516516-1-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726185640.2222714-1-mykola@meshstor.io>
References: <20260711100352.425177-1-chencheng@fnnas.com> <20260726185640.2222714-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Cheng,

Here are the test results I promised. v7 fixes it.

I used one kernel tree, rebuilt incrementally between the two builds,
so the only difference is your three patches. The array is raid10 n2
with 4 members. The load is four fio jobs: 4k randwrite, O_DIRECT,
iodepth 32. While the load runs, I --add two spares and then
--grow --raid-devices=6. The kernel is KASAN generic with
kasan_multi_shot. Each run is 5 cycles:

  kernel      runs  cycles  grows completed  slab-out-of-bounds
  base           1       5             5/5   128 (in 4 of 5 cycles)
  base + v7      2   5 + 5           10/10     0

All 128 base reports are in free_r10bio(): 64 reads and 64 writes,
each of 8 bytes. There is also a second report site,
raid10_make_request(). A warm-up run on the same base hit it too,
with 2 slab-out-of-bounds there alongside 568 in free_r10bio(). So
both report sites are reachable with this workload.

Every cycle on both kernels logged "md: md0: reshape done." and the
same capacity change, so the grow really did run 10/10 on the patched
kernel, and fio was alive throughout each cycle.

The bug does not fire in every cycle: per-cycle counts on the base
were 0, 40, 8, 56, 24, so the base hit it in 4 of 5 cycles. That rate
is what gives the patched 10/10 zero its meaning.

Tested-by: Mykola Marzhan <mykola@meshstor.io>

One practical note: v7 does not apply to mainline. Patch 2/3 carries
context

  static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)

but e045d6ed33f8 ("md/raid10: fix writes_pending leak on write request
failures") changed __make_request() to return bool. Applying
1/3..3/3 with --fuzz=0:

  8e065a160251 (= e045d6ed33f8^)        applies clean
  e045d6ed33f8                          fails
  55b77337bdd0                          fails
  v7.2-rc4                              fails
  current mainline                      fails

So the numbers above are from 8e065a160251, which is the newest base v7
applies to. A rebase would probably help it get picked up — happy to
re-run the same rig on a v8 if you post one.

Thanks,
Mykola
