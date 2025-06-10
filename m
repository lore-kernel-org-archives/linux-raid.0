Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3381386C9
	for <linux-raid@vger.kernel.org>; Tue, 10 Jun 2025 21:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749592169; cv=none; b=oxnrc7ncVNXZp0jOOL6lWBxk+6veZ+ftsvBl2MYh2bSjm02WZX7VJ3TCEzTNXuNJSu07gDF0Tje8f5g6nWy6/aGPepaMguiYVw+JsamMqDkCZG0ocAxxPig5lGrnRaITVkiAhC1gh1a48MKbb9RmvCJiQvLeRaSJxN4GYP/UCTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749592169; c=relaxed/simple;
	bh=3PJrnlE9l7goenT1GqEvBmxqddP8k9h5GO0ovuesl7o=;
	h=Date:Subject:In-Reply-To:CC:From:To:Message-ID:Mime-Version:
	 Content-Type; b=HAvPkkzXvbcKUyDaF7Y0FQF01NXwr8PMh8b+Cq5nEXEbBo2nDOSDFLgD0d7y7nRt/v8KJP+PBpMd48S3sYyVHVm0oJdHeIAFaoiA58X17MgWZvl5UElJsuf6YnSTUrEBshSvRNLew455W37leKeJBY8mmUfDZ34fAn48oGBMU/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com; spf=pass smtp.mailfrom=dabbelt.com; dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b=tha7glbG; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="tha7glbG"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-742c27df0daso5468187b3a.1
        for <linux-raid@vger.kernel.org>; Tue, 10 Jun 2025 14:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1749592166; x=1750196966; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TjJH9V4U9x9kcVvi7yh3O2o0xgnB/u5infpmLTK6+do=;
        b=tha7glbGgJ7YatmQ4MAliX0jPTQQ0kbN6kF/lMBA8wydAcYyGvLYKgJqlCb2SXxkY9
         cN5qIGcHJgYMGz6/nUTdKpM+hRjtCmUAug3HwSoWsX8IeM60WVAaU57gU2l2sG40zird
         tP27RdkfBgzSVzMuOiWrfddB7Ug4CsRK58Km47eU8rlJLITpHKNdPZtnANlyEm1k3/v7
         FtFAmVGYG3P2dEFehsIK8faufJnJ/hzUM/rJLFqRkahs5cpvvbAN6MMvD5YCWVVTqTNP
         iSaDTPlpDiG05xApxien8arbgtiTn6crVjV+ZpixsYOy/vXRrSIHuLpckgmacKaqdSv7
         EVZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749592166; x=1750196966;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TjJH9V4U9x9kcVvi7yh3O2o0xgnB/u5infpmLTK6+do=;
        b=l1HK52IznTexS+GMo5otTtb+GsKC/Uxp4VfGlzhfGyj7AJbvtzfYQAko6V8LI53IIh
         4UqSnASp3Er80zuy9hlJUfM3hUSEX1m1D7p3CkQhCTvp3ESetar/+ZpTMm/DBjaX0IZQ
         +IQBC1K2/ozqyQNHUIBBn0Wz6N/+hz4ttgDg67yeIsLIeYWEMcI3TuEb6e1dNllh/zi0
         Zp9QTx7v3WfH1bdtwBSKRVnjj6FuYHtR/uPJj6YfxdfTfLk0xK4JAWPcX0Z9LEDWxf0R
         NiJB7+fGkwmvd/aTEqfGyky/O+w/mKkAHArlVXVaj3MBBR9/jgYNsLwU5PSIhrgwiCCh
         JHVw==
X-Forwarded-Encrypted: i=1; AJvYcCX6C6Ga3TeO6IjqvAtoNCb/VPC7U0oFx04fa6Sp6j4Un6sHAn5J7L4hvkMyorFPC7oEtfqmlgYv39IC@vger.kernel.org
X-Gm-Message-State: AOJu0YxJPWzkZzIMHbDSzBgQhSBKS6ypSdT6r5hD7TNgciuMldihhCTO
	Y5DKX2FL6fgc157PsteCRDmOiSFunTf7iqznpnJssRv1r/b1GGcAiuk7XQV5S02y+qU=
X-Gm-Gg: ASbGncsLNinM0hiPrewzHa2hhfssWo1iLHs75b4Ltv9+g03yLD0bFncI4FdM0NfLxMJ
	gzS4OM6pnMW86TDzYJYjmfPJCDAysyWwCydlauJu8NV6+ZY6Q29jfCevrN+ZILJF0IFcVQY2bzS
	NZeMvF2X/uFXpHTdlPag8SK/piRQ3/xQXO7a5enkvslirytNbHvfXfEN0sCsifRUzK94sRzt0LO
	c3A3eyiRwPa6t6t9k9mqrlotWprPy9Sqj5vAUSYyii0LehhmUx2YEye3AREfy4Ku2/LW6pJ6kJE
	GAZQQ/NyPhSQnycCbGNb5m+LVZ5xGoDZZUedBKtR9rDGg41LniHTkrG6spD0
X-Google-Smtp-Source: AGHT+IFLPow5jYp5zMiGI3endsHgUoSX1Zhup9/kVCQx41lYvnTsdXa40pifHL03xoD2yGkUfXqlnA==
X-Received: by 2002:a05:6a00:1490:b0:73e:2d7a:8fc0 with SMTP id d2e1a72fcca58-7486cb219b7mr1369977b3a.1.1749592166377;
        Tue, 10 Jun 2025 14:49:26 -0700 (PDT)
Received: from localhost ([2620:10d:c090:500::7:116a])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-7482af7aae7sm7871092b3a.49.2025.06.10.14.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 14:49:25 -0700 (PDT)
Date: Tue, 10 Jun 2025 14:49:25 -0700 (PDT)
X-Google-Original-Date: Tue, 10 Jun 2025 14:49:18 PDT (-0700)
Subject:     Re: [PATCH 3/4] raid6: riscv: Allow code to be compiled in userspace
In-Reply-To: <20250610101234.1100660-4-zhangchunyan@iscas.ac.cn>
CC: Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
  Alexandre Ghiti <alex@ghiti.fr>, Charlie Jenkins <charlie@rivosinc.com>, song@kernel.org, yukuai3@huawei.com,
  linux-riscv@lists.infradead.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, zhang.lyra@gmail.com
From: Palmer Dabbelt <palmer@dabbelt.com>
To: zhangchunyan@iscas.ac.cn
Message-ID: <mhng-A7AD8208-FB68-4F06-9E71-15DD06E99579@palmerdabbelt-mac>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Tue, 10 Jun 2025 03:12:33 PDT (-0700), zhangchunyan@iscas.ac.cn wrote:
> To support userspace raid6test, this patch adds __KERNEL__ ifdef for kernel
> header inclusions also userspace wrapper definitions to allow code to be
> compiled in userspace.
>
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> ---
>  lib/raid6/recov_rvv.c |  7 +------
>  lib/raid6/rvv.c       | 11 ++++-------
>  lib/raid6/rvv.h       | 15 +++++++++++++++
>  3 files changed, 20 insertions(+), 13 deletions(-)
>
> diff --git a/lib/raid6/recov_rvv.c b/lib/raid6/recov_rvv.c
> index 500da521a806..8f2be833c015 100644
> --- a/lib/raid6/recov_rvv.c
> +++ b/lib/raid6/recov_rvv.c
> @@ -4,13 +4,8 @@
>   * Author: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
>   */
>
> -#include <asm/vector.h>
>  #include <linux/raid/pq.h>
> -
> -static int rvv_has_vector(void)
> -{
> -	return has_vector();
> -}
> +#include "rvv.h"
>
>  static void __raid6_2data_recov_rvv(int bytes, u8 *p, u8 *q, u8 *dp,
>  				    u8 *dq, const u8 *pbmul,
> diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
> index b193ea176d5d..99dfa16d37c7 100644
> --- a/lib/raid6/rvv.c
> +++ b/lib/raid6/rvv.c
> @@ -9,16 +9,13 @@
>   *	Copyright 2002-2004 H. Peter Anvin
>   */
>
> -#include <asm/vector.h>
> -#include <linux/raid/pq.h>
>  #include "rvv.h"
>
> +#ifdef __KERNEL__
>  #define NSIZE	(riscv_v_vsize / 32) /* NSIZE = vlenb */
> -
> -static int rvv_has_vector(void)
> -{
> -	return has_vector();
> -}
> +#else
> +#define NSIZE  16
> +#endif
>
>  static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
>  {
> diff --git a/lib/raid6/rvv.h b/lib/raid6/rvv.h
> index 94044a1b707b..595dfbf95d4e 100644
> --- a/lib/raid6/rvv.h
> +++ b/lib/raid6/rvv.h
> @@ -7,6 +7,21 @@
>   * Definitions for RISC-V RAID-6 code
>   */
>
> +#ifdef __KERNEL__
> +#include <asm/vector.h>
> +#else
> +#define kernel_vector_begin()
> +#define kernel_vector_end()
> +#define has_vector()		(1)

This should be gated on something, as we don't have vector everywhere in 
userspace.  We could dynamically check via hwprobe(), that's probably 
best?

> +#endif
> +
> +#include <linux/raid/pq.h>
> +
> +static int rvv_has_vector(void)
> +{
> +	return has_vector();
> +}
> +
>  #define RAID6_RVV_WRAPPER(_n)						\
>  	static void raid6_rvv ## _n ## _gen_syndrome(int disks,		\
>  					size_t bytes, void **ptrs)	\
