Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CE121170D
	for <linux-raid@vger.kernel.org>; Mon, 31 Mar 2025 15:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743436509; cv=none; b=JuBsDp2h/auK+8NPRGQhWMGnpRD3yTcvY5CfF0uqDnEg87KNB3CO38UmSLMwgU9N5JnPk8EDTyY+zgaX+HFY34WKzzTqygxgReJ52r0Nz/G2v91wTLM9e7EulP+OIB+Kv3vt1STCOsaiRsx5fytE8hu8Pj/BzH4L1DFfYZ9X9cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743436509; c=relaxed/simple;
	bh=delNYSRvlqsHP/6dcq7XoA+pPOto5fFJYPWsNAgUEgE=;
	h=Date:Subject:In-Reply-To:CC:From:To:Message-ID:Mime-Version:
	 Content-Type; b=LzkbGNhZz/uhoDbpC8qm2IQjApx09grfwDsVeKoaxwmUYyqmyDMFhjzCumikFqHGJdu9P2Nbc40N+Yvs9I5S4VWjGtp+JubF68QyLKNHW86yPKyZ7rtLkQ1g+wy/gKUANXCnK1Q+f75+ZqbIxTcWIdt2dp8yoKMmTm3cWdRst1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com; spf=pass smtp.mailfrom=dabbelt.com; dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b=lDcec+wv; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="lDcec+wv"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22401f4d35aso89427315ad.2
        for <linux-raid@vger.kernel.org>; Mon, 31 Mar 2025 08:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1743436505; x=1744041305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z1djU9uk81UFCvXIrjOaZ9u+lLJP4kD23652bqn2BnQ=;
        b=lDcec+wvH5pP3w74gNdJmc15cZu8gEtkXozWir8p+W9GhRo8Ih+wsPT+X5XFJ6muBS
         UT6e0745+3bVoLY0ZozG5tNhN6lHQZJ7IhRx1X91XOr+AlXJ083ofHBrN5SL6W1dlOzg
         0CAIgdC8R7GnqH+HiDGkBs2SiP4lpMzvAiQAiwFvv7y+r6qNuhpoCaeqcbQov3Rb3FyZ
         ms0edaD3zOMS4jx86zaJnGyhYy9XIA/qtkmDkdRYckKg3GBmH3XkpBb+3Ro4DgXjPP5H
         FUWRtoK8F6wlu/FSZj8uksDdB649Ixdm8FQI4x1Olc7uOlT0u7y6BDVsaQ6NRD8mL2fB
         ZfuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743436505; x=1744041305;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z1djU9uk81UFCvXIrjOaZ9u+lLJP4kD23652bqn2BnQ=;
        b=LOU0NnCv3QKgesLErnIBaJnXZIbUtOxTUUTkeR212gRMw17fwemjTbN0O7/MNuy1O0
         mHELcgbCA6wLOvfmWwNr3KegJeLMTr+du7ItNS7FUNkDEPpBYj7RctXsb4xzYiKFFxTF
         o5X2VoEBerrrD/cKWdalTEttgU4l0mT6/Y6QtCBSM0GhLzdWVFm+EAfDVM8Cy2lNgXAS
         BBJx4QYXfHxamBOgvjklsvgBnax31zdxnpJTdLu95q8fyYYhZmKAdHMIkSmAN8wrStRh
         DFsYsr9P/Doq1c9o0B5QYFUSr/xrl8GWnkE3lAwYYdrN4ej8etOUfbbweRhOKgXe5MHo
         ynQw==
X-Forwarded-Encrypted: i=1; AJvYcCXLtldHowEJ1UaaYrPxjy5IeFqyznJmPITwYoLKBqICLDFF5SmEg4AzoFJdksEbDdOWYlSnnYOUd3IZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+0TtEiCiVXymihJf5Smtc9DhqjBoa//MrRQ5O0dPcXBD7qpPP
	w57WC0TRCUujs+KqYfkA8Kvpz8mhqhunOgC9gzYy6zYk5PzsB5wJz2e2twMZXsA=
X-Gm-Gg: ASbGnctyRPw5b/z43GQFtRYQQhOxspc/tL7Q8lajznywOUJcZTbkBQF+7yEhJbwHLrC
	REBhlQ9S7UFlRErj5FTAj9NC0c5Lgs6rjMOxVk6uHZlRs2HxZ9g08NVXu1LfJKyfbSYl6hSqw8f
	4jZFBngeW4mcM71kpiSsL0WBF0QpXKaQYqaZao2jvxafm2Pd9Ie7QsotBcFSYqPp1MXWrQ33aaR
	QeeQXlOkPK3rmZ2D+5IStdc4W2TCWfmMtv5rh0/YdG2tmVx0q5RK/41VWBztbaOdShYFSVebVgl
	nSp5j7658mIqE1VsLBRAEpDUgjBQD5IvspQs3j9xsw==
X-Google-Smtp-Source: AGHT+IFfuXXCc6NrrUUVE0ZqrAw/3apmLtiGPCnIijFNoYkatnvXDMwAS/RJ62kVz33Pve508roWBg==
X-Received: by 2002:a17:902:ea07:b0:223:5e76:637a with SMTP id d9443c01a7336-2292f975602mr143291445ad.23.1743436504434;
        Mon, 31 Mar 2025 08:55:04 -0700 (PDT)
Received: from localhost ([192.184.165.199])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73971063689sm7339438b3a.99.2025.03.31.08.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 08:55:03 -0700 (PDT)
Date: Mon, 31 Mar 2025 08:55:03 -0700 (PDT)
X-Google-Original-Date: Mon, 31 Mar 2025 08:55:00 PDT (-0700)
Subject:     Re: [PATCH V5] raid6: Add RISC-V SIMD syndrome and recovery calculations
In-Reply-To: <20250305083707.74218-1-zhangchunyan@iscas.ac.cn>
CC: Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
  Charlie Jenkins <charlie@rivosinc.com>, song@kernel.org, yukuai3@huawei.com, linux-riscv@lists.infradead.org,
  linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, zhang.lyra@gmail.com
From: Palmer Dabbelt <palmer@dabbelt.com>
To: zhangchunyan@iscas.ac.cn
Message-ID: <mhng-63c49bc7-0f86-47f7-bc41-0186f77b9d6f@palmer-ri-x1c9>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Wed, 05 Mar 2025 00:37:06 PST (-0800), zhangchunyan@iscas.ac.cn wrote:
> The assembly is originally based on the ARM NEON and int.uc, but uses
> RISC-V vector instructions to implement the RAID6 syndrome and
> recovery calculations.
>
> The functions are tested on QEMU running with the option "-icount shift=0":

Does anyone have hardware benchmarks for this?  There's a lot more code 
here than the other targets have.  If all that unrolling is necessary for 
performance on real hardware then it seems fine to me, but just having 
it for QEMU doesn't really tell us much.

>
>   raid6: rvvx1    gen()  1008 MB/s
>   raid6: rvvx2    gen()  1395 MB/s
>   raid6: rvvx4    gen()  1584 MB/s
>   raid6: rvvx8    gen()  1694 MB/s
>   raid6: int64x8  gen()   113 MB/s
>   raid6: int64x4  gen()   116 MB/s
>   raid6: int64x2  gen()   272 MB/s
>   raid6: int64x1  gen()   229 MB/s
>   raid6: using algorithm rvvx8 gen() 1694 MB/s
>   raid6: .... xor() 1000 MB/s, rmw enabled
>   raid6: using rvv recovery algorithm
>
> [Charlie: - Fixup vector options]
> Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> ---
> V5:
> - Add rvv.h to fix a few checkpatch warnings.
>
> V4: https://lore.kernel.org/lkml/20250225013754.633056-1-zhangchunyan@iscas.ac.cn/
> - Fixed CHECK issues reported by checkpatch script.
>
> V3: https://lore.kernel.org/lkml/20250221022818.487885-1-zhangchunyan@iscas.ac.cn/
> - The variable type of index is int, while the variable of end number
>   in the loop is unsigned long, change to use unsigned long for both
>   to avoid an infinite loop risk.
>
> V2: https://lore.kernel.org/lkml/20250127061529.2437012-1-zhangchunyan@iscas.ac.cn/
> - Add raid6_rvvx8;
> - Address the vector options issue;
> - Add .valid callback to raid6_rvv and raid6_recov_rvv;
> - Removed unneeded check of crypto_simd_usable();
>
> RFC: https://lore.kernel.org/lkml/20241220114023.667347-1-zhangchunyan@iscas.ac.cn/
> ---
>  include/linux/raid/pq.h |    5 +
>  lib/raid6/Makefile      |    1 +
>  lib/raid6/algos.c       |    9 +
>  lib/raid6/recov_rvv.c   |  229 ++++++++
>  lib/raid6/rvv.c         | 1212 +++++++++++++++++++++++++++++++++++++++
>  lib/raid6/rvv.h         |   39 ++
>  6 files changed, 1495 insertions(+)
>  create mode 100644 lib/raid6/recov_rvv.c
>  create mode 100644 lib/raid6/rvv.c
>  create mode 100644 lib/raid6/rvv.h
>
> diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
> index 98030accf641..72ff44cca864 100644
> --- a/include/linux/raid/pq.h
> +++ b/include/linux/raid/pq.h
> @@ -108,6 +108,10 @@ extern const struct raid6_calls raid6_vpermxor4;
>  extern const struct raid6_calls raid6_vpermxor8;
>  extern const struct raid6_calls raid6_lsx;
>  extern const struct raid6_calls raid6_lasx;
> +extern const struct raid6_calls raid6_rvvx1;
> +extern const struct raid6_calls raid6_rvvx2;
> +extern const struct raid6_calls raid6_rvvx4;
> +extern const struct raid6_calls raid6_rvvx8;
>
>  struct raid6_recov_calls {
>  	void (*data2)(int, size_t, int, int, void **);
> @@ -125,6 +129,7 @@ extern const struct raid6_recov_calls raid6_recov_s390xc;
>  extern const struct raid6_recov_calls raid6_recov_neon;
>  extern const struct raid6_recov_calls raid6_recov_lsx;
>  extern const struct raid6_recov_calls raid6_recov_lasx;
> +extern const struct raid6_recov_calls raid6_recov_rvv;
>
>  extern const struct raid6_calls raid6_neonx1;
>  extern const struct raid6_calls raid6_neonx2;
> diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
> index 29127dd05d63..5be0a4e60ab1 100644
> --- a/lib/raid6/Makefile
> +++ b/lib/raid6/Makefile
> @@ -10,6 +10,7 @@ raid6_pq-$(CONFIG_ALTIVEC) += altivec1.o altivec2.o altivec4.o altivec8.o \
>  raid6_pq-$(CONFIG_KERNEL_MODE_NEON) += neon.o neon1.o neon2.o neon4.o neon8.o recov_neon.o recov_neon_inner.o
>  raid6_pq-$(CONFIG_S390) += s390vx8.o recov_s390xc.o
>  raid6_pq-$(CONFIG_LOONGARCH) += loongarch_simd.o recov_loongarch_simd.o
> +raid6_pq-$(CONFIG_RISCV_ISA_V) += rvv.o recov_rvv.o
>
>  hostprogs	+= mktables
>
> diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> index cd2e88ee1f14..99980ff5b985 100644
> --- a/lib/raid6/algos.c
> +++ b/lib/raid6/algos.c
> @@ -80,6 +80,12 @@ const struct raid6_calls * const raid6_algos[] = {
>  #ifdef CONFIG_CPU_HAS_LSX
>  	&raid6_lsx,
>  #endif
> +#endif
> +#ifdef CONFIG_RISCV_ISA_V
> +	&raid6_rvvx1,
> +	&raid6_rvvx2,
> +	&raid6_rvvx4,
> +	&raid6_rvvx8,
>  #endif
>  	&raid6_intx8,
>  	&raid6_intx4,
> @@ -115,6 +121,9 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
>  #ifdef CONFIG_CPU_HAS_LSX
>  	&raid6_recov_lsx,
>  #endif
> +#endif
> +#ifdef CONFIG_RISCV_ISA_V
> +	&raid6_recov_rvv,
>  #endif
>  	&raid6_recov_intx1,
>  	NULL
> diff --git a/lib/raid6/recov_rvv.c b/lib/raid6/recov_rvv.c
> new file mode 100644
> index 000000000000..f29303795ccf
> --- /dev/null
> +++ b/lib/raid6/recov_rvv.c
> @@ -0,0 +1,229 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright 2024 Institute of Software, CAS.
> + * Author: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> + */
> +
> +#include <asm/simd.h>
> +#include <asm/vector.h>
> +#include <crypto/internal/simd.h>
> +#include <linux/raid/pq.h>
> +
> +static int rvv_has_vector(void)
> +{
> +	return has_vector();
> +}
> +
> +static void __raid6_2data_recov_rvv(int bytes, u8 *p, u8 *q, u8 *dp,
> +				    u8 *dq, const u8 *pbmul,
> +				    const u8 *qmul)
> +{
> +	asm volatile (".option	push\n"
> +		      ".option	arch,+v\n"
> +		      "vsetvli	x0, %[avl], e8, m1, ta, ma\n"
> +		      ".option	pop\n"
> +		      : :
> +		      [avl]"r"(16)
> +	);
> +
> +	/*
> +	 * while ( bytes-- ) {
> +	 *	uint8_t px, qx, db;
> +	 *
> +	 *	px	  = *p ^ *dp;
> +	 *	qx	  = qmul[*q ^ *dq];
> +	 *	*dq++ = db = pbmul[px] ^ qx;
> +	 *	*dp++ = db ^ px;
> +	 *	p++; q++;
> +	 * }
> +	 */
> +	while (bytes) {
> +		/*
> +		 * v0:px, v1:dp,
> +		 * v2:qx, v3:dq,
> +		 * v4:vx, v5:vy,
> +		 * v6:qm0, v7:qm1,
> +		 * v8:pm0, v9:pm1,
> +		 * v14:p/qm[vx], v15:p/qm[vy]
> +		 */
> +		asm volatile (".option		push\n"
> +			      ".option		arch,+v\n"
> +			      "vle8.v		v0, (%[px])\n"
> +			      "vle8.v		v1, (%[dp])\n"
> +			      "vxor.vv		v0, v0, v1\n"
> +			      "vle8.v		v2, (%[qx])\n"
> +			      "vle8.v		v3, (%[dq])\n"
> +			      "vxor.vv		v4, v2, v3\n"
> +			      "vsrl.vi		v5, v4, 4\n"
> +			      "vand.vi		v4, v4, 0xf\n"
> +			      "vle8.v		v6, (%[qm0])\n"
> +			      "vle8.v		v7, (%[qm1])\n"
> +			      "vrgather.vv	v14, v6, v4\n" /* v14 = qm[vx] */
> +			      "vrgather.vv	v15, v7, v5\n" /* v15 = qm[vy] */
> +			      "vxor.vv		v2, v14, v15\n" /* v2 = qmul[*q ^ *dq] */
> +
> +			      "vsrl.vi		v5, v0, 4\n"
> +			      "vand.vi		v4, v0, 0xf\n"
> +			      "vle8.v		v8, (%[pm0])\n"
> +			      "vle8.v		v9, (%[pm1])\n"
> +			      "vrgather.vv	v14, v8, v4\n" /* v14 = pm[vx] */
> +			      "vrgather.vv	v15, v9, v5\n" /* v15 = pm[vy] */
> +			      "vxor.vv		v4, v14, v15\n" /* v4 = pbmul[px] */
> +			      "vxor.vv		v3, v4, v2\n" /* v3 = db = pbmul[px] ^ qx */
> +			      "vxor.vv		v1, v3, v0\n" /* v1 = db ^ px; */
> +			      "vse8.v		v3, (%[dq])\n"
> +			      "vse8.v		v1, (%[dp])\n"
> +			      ".option		pop\n"
> +			      : :
> +			      [px]"r"(p),
> +			      [dp]"r"(dp),
> +			      [qx]"r"(q),
> +			      [dq]"r"(dq),
> +			      [qm0]"r"(qmul),
> +			      [qm1]"r"(qmul + 16),
> +			      [pm0]"r"(pbmul),
> +			      [pm1]"r"(pbmul + 16)
> +			      :);
> +
> +		bytes -= 16;
> +		p += 16;
> +		q += 16;
> +		dp += 16;
> +		dq += 16;
> +	}
> +}
> +
> +static void __raid6_datap_recov_rvv(int bytes, u8 *p, u8 *q,
> +				    u8 *dq, const u8 *qmul)
> +{
> +	asm volatile (".option	push\n"
> +		      ".option	arch,+v\n"
> +		      "vsetvli	x0, %[avl], e8, m1, ta, ma\n"
> +		      ".option	pop\n"
> +		      : :
> +		      [avl]"r"(16)
> +	);
> +
> +	/*
> +	 * while (bytes--) {
> +	 *  *p++ ^= *dq = qmul[*q ^ *dq];
> +	 *  q++; dq++;
> +	 * }
> +	 */
> +	while (bytes) {
> +		/*
> +		 * v0:vx, v1:vy,
> +		 * v2:dq, v3:p,
> +		 * v4:qm0, v5:qm1,
> +		 * v10:m[vx], v11:m[vy]
> +		 */
> +		asm volatile (".option		push\n"
> +			      ".option		arch,+v\n"
> +			      "vle8.v		v0, (%[vx])\n"
> +			      "vle8.v		v2, (%[dq])\n"
> +			      "vxor.vv		v0, v0, v2\n"
> +			      "vsrl.vi		v1, v0, 4\n"
> +			      "vand.vi		v0, v0, 0xf\n"
> +			      "vle8.v		v4, (%[qm0])\n"
> +			      "vle8.v		v5, (%[qm1])\n"
> +			      "vrgather.vv	v10, v4, v0\n"
> +			      "vrgather.vv	v11, v5, v1\n"
> +			      "vxor.vv		v0, v10, v11\n"
> +			      "vle8.v		v1, (%[vy])\n"
> +			      "vxor.vv		v1, v0, v1\n"
> +			      "vse8.v		v0, (%[dq])\n"
> +			      "vse8.v		v1, (%[vy])\n"
> +			      ".option		pop\n"
> +			      : :
> +			      [vx]"r"(q),
> +			      [vy]"r"(p),
> +			      [dq]"r"(dq),
> +			      [qm0]"r"(qmul),
> +			      [qm1]"r"(qmul + 16)
> +			      :);
> +
> +		bytes -= 16;
> +		p += 16;
> +		q += 16;
> +		dq += 16;
> +	}
> +}
> +
> +static void raid6_2data_recov_rvv(int disks, size_t bytes, int faila,
> +				  int failb, void **ptrs)
> +{
> +	u8 *p, *q, *dp, *dq;
> +	const u8 *pbmul;	/* P multiplier table for B data */
> +	const u8 *qmul;		/* Q multiplier table (for both) */
> +
> +	p = (u8 *)ptrs[disks - 2];
> +	q = (u8 *)ptrs[disks - 1];
> +
> +	/*
> +	 * Compute syndrome with zero for the missing data pages
> +	 * Use the dead data pages as temporary storage for
> +	 * delta p and delta q
> +	 */
> +	dp = (u8 *)ptrs[faila];
> +	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[disks - 2] = dp;
> +	dq = (u8 *)ptrs[failb];
> +	ptrs[failb] = (void *)raid6_empty_zero_page;
> +	ptrs[disks - 1] = dq;
> +
> +	raid6_call.gen_syndrome(disks, bytes, ptrs);
> +
> +	/* Restore pointer table */
> +	ptrs[faila]     = dp;
> +	ptrs[failb]     = dq;
> +	ptrs[disks - 2] = p;
> +	ptrs[disks - 1] = q;
> +
> +	/* Now, pick the proper data tables */
> +	pbmul = raid6_vgfmul[raid6_gfexi[failb - faila]];
> +	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila] ^
> +					 raid6_gfexp[failb]]];
> +
> +	kernel_vector_begin();
> +	__raid6_2data_recov_rvv(bytes, p, q, dp, dq, pbmul, qmul);
> +	kernel_vector_end();
> +}
> +
> +static void raid6_datap_recov_rvv(int disks, size_t bytes, int faila,
> +				  void **ptrs)
> +{
> +	u8 *p, *q, *dq;
> +	const u8 *qmul;		/* Q multiplier table */
> +
> +	p = (u8 *)ptrs[disks - 2];
> +	q = (u8 *)ptrs[disks - 1];
> +
> +	/*
> +	 * Compute syndrome with zero for the missing data page
> +	 * Use the dead data page as temporary storage for delta q
> +	 */
> +	dq = (u8 *)ptrs[faila];
> +	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[disks - 1] = dq;
> +
> +	raid6_call.gen_syndrome(disks, bytes, ptrs);
> +
> +	/* Restore pointer table */
> +	ptrs[faila]     = dq;
> +	ptrs[disks - 1] = q;
> +
> +	/* Now, pick the proper data tables */
> +	qmul = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila]]];
> +
> +	kernel_vector_begin();
> +	__raid6_datap_recov_rvv(bytes, p, q, dq, qmul);
> +	kernel_vector_end();
> +}
> +
> +const struct raid6_recov_calls raid6_recov_rvv = {
> +	.data2		= raid6_2data_recov_rvv,
> +	.datap		= raid6_datap_recov_rvv,
> +	.valid		= rvv_has_vector,
> +	.name		= "rvv",
> +	.priority	= 1,
> +};
> diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
> new file mode 100644
> index 000000000000..1be10ba18cb0
> --- /dev/null
> +++ b/lib/raid6/rvv.c
> @@ -0,0 +1,1212 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * RAID-6 syndrome calculation using RISC-V vector instructions
> + *
> + * Copyright 2024 Institute of Software, CAS.
> + * Author: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> + *
> + * Based on neon.uc:
> + *	Copyright 2002-2004 H. Peter Anvin
> + */
> +
> +#include <asm/simd.h>
> +#include <asm/vector.h>
> +#include <crypto/internal/simd.h>
> +#include <linux/raid/pq.h>
> +#include <linux/types.h>
> +#include "rvv.h"
> +
> +#define NSIZE	(riscv_v_vsize / 32) /* NSIZE = vlenb */
> +
> +static int rvv_has_vector(void)
> +{
> +	return has_vector();
> +}
> +
> +static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	unsigned long d;
> +	int z, z0;
> +	u8 *p, *q;
> +
> +	z0 = disks - 3;		/* Highest data disk */
> +	p = dptr[z0 + 1];		/* XOR parity */
> +	q = dptr[z0 + 2];		/* RS syndrome */
> +
> +	asm volatile (".option	push\n"
> +		      ".option	arch,+v\n"
> +		      "vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		      ".option	pop\n"
> +	);
> +
> +	 /* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
> +	for (d = 0; d < bytes; d += NSIZE * 1) {
> +		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (".option	push\n"
> +			      ".option	arch,+v\n"
> +			      "vle8.v	v0, (%[wp0])\n"
> +			      "vle8.v	v1, (%[wp0])\n"
> +			      ".option	pop\n"
> +			      : :
> +			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE])
> +		);
> +
> +		for (z = z0 - 1 ; z >= 0 ; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * w1$$ ^= w2$$;
> +			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
> +			 * wq$$ = w1$$ ^ wd$$;
> +			 * wp$$ ^= wd$$;
> +			 */
> +			asm volatile (".option	push\n"
> +				      ".option	arch,+v\n"
> +				      "vsra.vi	v2, v1, 7\n"
> +				      "vsll.vi	v3, v1, 1\n"
> +				      "vand.vx	v2, v2, %[x1d]\n"
> +				      "vxor.vv	v3, v3, v2\n"
> +				      "vle8.v	v2, (%[wd0])\n"
> +				      "vxor.vv	v1, v3, v2\n"
> +				      "vxor.vv	v0, v0, v2\n"
> +				      ".option	pop\n"
> +				      : :
> +				      [wd0]"r"(&dptr[z][d + 0 * NSIZE]),
> +				      [x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/*
> +		 * *(unative_t *)&p[d+NSIZE*$$] = wp$$;
> +		 * *(unative_t *)&q[d+NSIZE*$$] = wq$$;
> +		 */
> +		asm volatile (".option	push\n"
> +			      ".option	arch,+v\n"
> +			      "vse8.v	v0, (%[wp0])\n"
> +			      "vse8.v	v1, (%[wq0])\n"
> +			      ".option	pop\n"
> +			      : :
> +			      [wp0]"r"(&p[d + NSIZE * 0]),
> +			      [wq0]"r"(&q[d + NSIZE * 0])
> +		);
> +	}
> +}
> +
> +static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
> +					 unsigned long bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	u8 *p, *q;
> +	unsigned long d;
> +	int z, z0;
> +
> +	z0 = stop;		/* P/Q right side optimization */
> +	p = dptr[disks - 2];	/* XOR parity */
> +	q = dptr[disks - 1];	/* RS syndrome */
> +
> +	asm volatile (".option	push\n"
> +		      ".option	arch,+v\n"
> +		      "vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		      ".option	pop\n"
> +	);
> +
> +	/* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
> +	for (d = 0 ; d < bytes ; d += NSIZE * 1) {
> +		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (".option	push\n"
> +			      ".option	arch,+v\n"
> +			      "vle8.v	v0, (%[wp0])\n"
> +			      "vle8.v	v1, (%[wp0])\n"
> +			      ".option	pop\n"
> +			      : :
> +			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE])
> +		);
> +
> +		/* P/Q data pages */
> +		for (z = z0 - 1; z >= start; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * w1$$ ^= w2$$;
> +			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
> +			 * wq$$ = w1$$ ^ wd$$;
> +			 * wp$$ ^= wd$$;
> +			 */
> +			asm volatile (".option	push\n"
> +				      ".option	arch,+v\n"
> +				      "vsra.vi	v2, v1, 7\n"
> +				      "vsll.vi	v3, v1, 1\n"
> +				      "vand.vx	v2, v2, %[x1d]\n"
> +				      "vxor.vv	v3, v3, v2\n"
> +				      "vle8.v	v2, (%[wd0])\n"
> +				      "vxor.vv	v1, v3, v2\n"
> +				      "vxor.vv	v0, v0, v2\n"
> +				      ".option	pop\n"
> +				      : :
> +				      [wd0]"r"(&dptr[z][d + 0 * NSIZE]),
> +				      [x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/* P/Q left side optimization */
> +		for (z = start - 1; z >= 0; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * wq$$ = w1$$ ^ w2$$;
> +			 */
> +			asm volatile (".option	push\n"
> +				      ".option	arch,+v\n"
> +				      "vsra.vi	v2, v1, 7\n"
> +				      "vsll.vi	v3, v1, 1\n"
> +				      "vand.vx	v2, v2, %[x1d]\n"
> +				      "vxor.vv	v1, v3, v2\n"
> +				      ".option	pop\n"
> +				      : :
> +				      [x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/*
> +		 * *(unative_t *)&p[d+NSIZE*$$] ^= wp$$;
> +		 * *(unative_t *)&q[d+NSIZE*$$] ^= wq$$;
> +		 * v0:wp0, v1:wq0, v2:p0, v3:q0
> +		 */
> +		asm volatile (".option	push\n"
> +			      ".option	arch,+v\n"
> +			      "vle8.v	v2, (%[wp0])\n"
> +			      "vle8.v	v3, (%[wq0])\n"
> +			      "vxor.vv	v2, v2, v0\n"
> +			      "vxor.vv	v3, v3, v1\n"
> +			      "vse8.v	v2, (%[wp0])\n"
> +			      "vse8.v	v3, (%[wq0])\n"
> +			      ".option	pop\n"
> +			      : :
> +			      [wp0]"r"(&p[d + NSIZE * 0]),
> +			      [wq0]"r"(&q[d + NSIZE * 0])
> +		);
> +	}
> +}
> +
> +static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	unsigned long d;
> +	int z, z0;
> +	u8 *p, *q;
> +
> +	z0 = disks - 3;		/* Highest data disk */
> +	p = dptr[z0 + 1];		/* XOR parity */
> +	q = dptr[z0 + 2];		/* RS syndrome */
> +
> +	asm volatile (".option	push\n"
> +		      ".option	arch,+v\n"
> +		      "vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		      ".option	pop\n"
> +	);
> +
> +	/*
> +	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
> +	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
> +	 */
> +	for (d = 0; d < bytes; d += NSIZE * 2) {
> +		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (".option	push\n"
> +			      ".option	arch,+v\n"
> +			      "vle8.v	v0, (%[wp0])\n"
> +			      "vle8.v	v1, (%[wp0])\n"
> +			      "vle8.v	v4, (%[wp1])\n"
> +			      "vle8.v	v5, (%[wp1])\n"
> +			      ".option	pop\n"
> +			      : :
> +			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
> +			      [wp1]"r"(&dptr[z0][d + 1 * NSIZE])
> +		);
> +
> +		for (z = z0 - 1; z >= 0; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * w1$$ ^= w2$$;
> +			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
> +			 * wq$$ = w1$$ ^ wd$$;
> +			 * wp$$ ^= wd$$;
> +			 */
> +			asm volatile (".option	push\n"
> +				      ".option	arch,+v\n"
> +				      "vsra.vi	v2, v1, 7\n"
> +				      "vsll.vi	v3, v1, 1\n"
> +				      "vand.vx	v2, v2, %[x1d]\n"
> +				      "vxor.vv	v3, v3, v2\n"
> +				      "vle8.v	v2, (%[wd0])\n"
> +				      "vxor.vv	v1, v3, v2\n"
> +				      "vxor.vv	v0, v0, v2\n"
> +
> +				      "vsra.vi	v6, v5, 7\n"
> +				      "vsll.vi	v7, v5, 1\n"
> +				      "vand.vx	v6, v6, %[x1d]\n"
> +				      "vxor.vv	v7, v7, v6\n"
> +				      "vle8.v	v6, (%[wd1])\n"
> +				      "vxor.vv	v5, v7, v6\n"
> +				      "vxor.vv	v4, v4, v6\n"
> +				      ".option	pop\n"
> +				      : :
> +				      [wd0]"r"(&dptr[z][d + 0 * NSIZE]),
> +				      [wd1]"r"(&dptr[z][d + 1 * NSIZE]),
> +				      [x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/*
> +		 * *(unative_t *)&p[d+NSIZE*$$] = wp$$;
> +		 * *(unative_t *)&q[d+NSIZE*$$] = wq$$;
> +		 */
> +		asm volatile (".option	push\n"
> +			      ".option	arch,+v\n"
> +			      "vse8.v	v0, (%[wp0])\n"
> +			      "vse8.v	v1, (%[wq0])\n"
> +			      "vse8.v	v4, (%[wp1])\n"
> +			      "vse8.v	v5, (%[wq1])\n"
> +			      ".option	pop\n"
> +			      : :
> +			      [wp0]"r"(&p[d + NSIZE * 0]),
> +			      [wq0]"r"(&q[d + NSIZE * 0]),
> +			      [wp1]"r"(&p[d + NSIZE * 1]),
> +			      [wq1]"r"(&q[d + NSIZE * 1])
> +		);
> +	}
> +}
> +
> +static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
> +					 unsigned long bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	u8 *p, *q;
> +	unsigned long d;
> +	int z, z0;
> +
> +	z0 = stop;		/* P/Q right side optimization */
> +	p = dptr[disks - 2];	/* XOR parity */
> +	q = dptr[disks - 1];	/* RS syndrome */
> +
> +	asm volatile (".option	push\n"
> +		      ".option	arch,+v\n"
> +		      "vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		      ".option	pop\n"
> +	);
> +
> +	/*
> +	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
> +	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
> +	 */
> +	for (d = 0; d < bytes; d += NSIZE * 2) {
> +		 /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (".option	push\n"
> +			      ".option	arch,+v\n"
> +			      "vle8.v	v0, (%[wp0])\n"
> +			      "vle8.v	v1, (%[wp0])\n"
> +			      "vle8.v	v4, (%[wp1])\n"
> +			      "vle8.v	v5, (%[wp1])\n"
> +			      ".option	pop\n"
> +			      : :
> +			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
> +			      [wp1]"r"(&dptr[z0][d + 1 * NSIZE])
> +		);
> +
> +		/* P/Q data pages */
> +		for (z = z0 - 1; z >= start; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * w1$$ ^= w2$$;
> +			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
> +			 * wq$$ = w1$$ ^ wd$$;
> +			 * wp$$ ^= wd$$;
> +			 */
> +			asm volatile (".option	push\n"
> +				      ".option	arch,+v\n"
> +				      "vsra.vi	v2, v1, 7\n"
> +				      "vsll.vi	v3, v1, 1\n"
> +				      "vand.vx	v2, v2, %[x1d]\n"
> +				      "vxor.vv	v3, v3, v2\n"
> +				      "vle8.v	v2, (%[wd0])\n"
> +				      "vxor.vv	v1, v3, v2\n"
> +				      "vxor.vv	v0, v0, v2\n"
> +
> +				      "vsra.vi	v6, v5, 7\n"
> +				      "vsll.vi	v7, v5, 1\n"
> +				      "vand.vx	v6, v6, %[x1d]\n"
> +				      "vxor.vv	v7, v7, v6\n"
> +				      "vle8.v	v6, (%[wd1])\n"
> +				      "vxor.vv	v5, v7, v6\n"
> +				      "vxor.vv	v4, v4, v6\n"
> +				      ".option	pop\n"
> +				      : :
> +				      [wd0]"r"(&dptr[z][d + 0 * NSIZE]),
> +				      [wd1]"r"(&dptr[z][d + 1 * NSIZE]),
> +				      [x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/* P/Q left side optimization */
> +		for (z = start - 1; z >= 0; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * wq$$ = w1$$ ^ w2$$;
> +			 */
> +			asm volatile (".option	push\n"
> +				      ".option	arch,+v\n"
> +				      "vsra.vi	v2, v1, 7\n"
> +				      "vsll.vi	v3, v1, 1\n"
> +				      "vand.vx	v2, v2, %[x1d]\n"
> +				      "vxor.vv	v1, v3, v2\n"
> +
> +				      "vsra.vi	v6, v5, 7\n"
> +				      "vsll.vi	v7, v5, 1\n"
> +				      "vand.vx	v6, v6, %[x1d]\n"
> +				      "vxor.vv	v5, v7, v6\n"
> +				      ".option	pop\n"
> +				      : :
> +				      [x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/*
> +		 * *(unative_t *)&p[d+NSIZE*$$] ^= wp$$;
> +		 * *(unative_t *)&q[d+NSIZE*$$] ^= wq$$;
> +		 * v0:wp0, v1:wq0, v2:p0, v3:q0
> +		 * v4:wp1, v5:wq1, v6:p1, v7:q1
> +		 */
> +		asm volatile (".option	push\n"
> +			      ".option	arch,+v\n"
> +			      "vle8.v	v2, (%[wp0])\n"
> +			      "vle8.v	v3, (%[wq0])\n"
> +			      "vxor.vv	v2, v2, v0\n"
> +			      "vxor.vv	v3, v3, v1\n"
> +			      "vse8.v	v2, (%[wp0])\n"
> +			      "vse8.v	v3, (%[wq0])\n"
> +
> +			      "vle8.v	v6, (%[wp1])\n"
> +			      "vle8.v	v7, (%[wq1])\n"
> +			      "vxor.vv	v6, v6, v4\n"
> +			      "vxor.vv	v7, v7, v5\n"
> +			      "vse8.v	v6, (%[wp1])\n"
> +			      "vse8.v	v7, (%[wq1])\n"
> +			      ".option	pop\n"
> +			      : :
> +			      [wp0]"r"(&p[d + NSIZE * 0]),
> +			      [wq0]"r"(&q[d + NSIZE * 0]),
> +			      [wp1]"r"(&p[d + NSIZE * 1]),
> +			      [wq1]"r"(&q[d + NSIZE * 1])
> +		);
> +	}
> +}
> +
> +static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	unsigned long d;
> +	int z, z0;
> +	u8 *p, *q;
> +
> +	z0 = disks - 3;	/* Highest data disk */
> +	p = dptr[z0 + 1];	/* XOR parity */
> +	q = dptr[z0 + 2];	/* RS syndrome */
> +
> +	asm volatile (".option	push\n"
> +		      ".option	arch,+v\n"
> +		      "vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		      ".option	pop\n"
> +	);
> +
> +	/*
> +	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
> +	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
> +	 * v8:wp2, v9:wq2, v10:wd2/w22, v11:w12
> +	 * v12:wp3, v13:wq3, v14:wd3/w23, v15:w13
> +	 */
> +	for (d = 0; d < bytes; d += NSIZE * 4) {
> +		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (".option	push\n"
> +			      ".option	arch,+v\n"
> +			      "vle8.v	v0, (%[wp0])\n"
> +			      "vle8.v	v1, (%[wp0])\n"
> +			      "vle8.v	v4, (%[wp1])\n"
> +			      "vle8.v	v5, (%[wp1])\n"
> +			      "vle8.v	v8, (%[wp2])\n"
> +			      "vle8.v	v9, (%[wp2])\n"
> +			      "vle8.v	v12, (%[wp3])\n"
> +			      "vle8.v	v13, (%[wp3])\n"
> +			      ".option	pop\n"
> +			      : :
> +			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
> +			      [wp1]"r"(&dptr[z0][d + 1 * NSIZE]),
> +			      [wp2]"r"(&dptr[z0][d + 2 * NSIZE]),
> +			      [wp3]"r"(&dptr[z0][d + 3 * NSIZE])
> +		);
> +
> +		for (z = z0 - 1; z >= 0; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * w1$$ ^= w2$$;
> +			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
> +			 * wq$$ = w1$$ ^ wd$$;
> +			 * wp$$ ^= wd$$;
> +			 */
> +			asm volatile (".option	push\n"
> +				      ".option	arch,+v\n"
> +				      "vsra.vi	v2, v1, 7\n"
> +				      "vsll.vi	v3, v1, 1\n"
> +				      "vand.vx	v2, v2, %[x1d]\n"
> +				      "vxor.vv	v3, v3, v2\n"
> +				      "vle8.v	v2, (%[wd0])\n"
> +				      "vxor.vv	v1, v3, v2\n"
> +				      "vxor.vv	v0, v0, v2\n"
> +
> +				      "vsra.vi	v6, v5, 7\n"
> +				      "vsll.vi	v7, v5, 1\n"
> +				      "vand.vx	v6, v6, %[x1d]\n"
> +				      "vxor.vv	v7, v7, v6\n"
> +				      "vle8.v	v6, (%[wd1])\n"
> +				      "vxor.vv	v5, v7, v6\n"
> +				      "vxor.vv	v4, v4, v6\n"
> +
> +				      "vsra.vi	v10, v9, 7\n"
> +				      "vsll.vi	v11, v9, 1\n"
> +				      "vand.vx	v10, v10, %[x1d]\n"
> +				      "vxor.vv	v11, v11, v10\n"
> +				      "vle8.v	v10, (%[wd2])\n"
> +				      "vxor.vv	v9, v11, v10\n"
> +				      "vxor.vv	v8, v8, v10\n"
> +
> +				      "vsra.vi	v14, v13, 7\n"
> +				      "vsll.vi	v15, v13, 1\n"
> +				      "vand.vx	v14, v14, %[x1d]\n"
> +				      "vxor.vv	v15, v15, v14\n"
> +				      "vle8.v	v14, (%[wd3])\n"
> +				      "vxor.vv	v13, v15, v14\n"
> +				      "vxor.vv	v12, v12, v14\n"
> +				      ".option	pop\n"
> +				      : :
> +				      [wd0]"r"(&dptr[z][d + 0 * NSIZE]),
> +				      [wd1]"r"(&dptr[z][d + 1 * NSIZE]),
> +				      [wd2]"r"(&dptr[z][d + 2 * NSIZE]),
> +				      [wd3]"r"(&dptr[z][d + 3 * NSIZE]),
> +				      [x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/*
> +		 * *(unative_t *)&p[d+NSIZE*$$] = wp$$;
> +		 * *(unative_t *)&q[d+NSIZE*$$] = wq$$;
> +		 */
> +		asm volatile (".option	push\n"
> +			      ".option	arch,+v\n"
> +			      "vse8.v	v0, (%[wp0])\n"
> +			      "vse8.v	v1, (%[wq0])\n"
> +			      "vse8.v	v4, (%[wp1])\n"
> +			      "vse8.v	v5, (%[wq1])\n"
> +			      "vse8.v	v8, (%[wp2])\n"
> +			      "vse8.v	v9, (%[wq2])\n"
> +			      "vse8.v	v12, (%[wp3])\n"
> +			      "vse8.v	v13, (%[wq3])\n"
> +			      ".option	pop\n"
> +			      : :
> +			      [wp0]"r"(&p[d + NSIZE * 0]),
> +			      [wq0]"r"(&q[d + NSIZE * 0]),
> +			      [wp1]"r"(&p[d + NSIZE * 1]),
> +			      [wq1]"r"(&q[d + NSIZE * 1]),
> +			      [wp2]"r"(&p[d + NSIZE * 2]),
> +			      [wq2]"r"(&q[d + NSIZE * 2]),
> +			      [wp3]"r"(&p[d + NSIZE * 3]),
> +			      [wq3]"r"(&q[d + NSIZE * 3])
> +		);
> +	}
> +}
> +
> +static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
> +					 unsigned long bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	u8 *p, *q;
> +	unsigned long d;
> +	int z, z0;
> +
> +	z0 = stop;		/* P/Q right side optimization */
> +	p = dptr[disks - 2];	/* XOR parity */
> +	q = dptr[disks - 1];	/* RS syndrome */
> +
> +	asm volatile (".option	push\n"
> +		      ".option	arch,+v\n"
> +		      "vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		      ".option	pop\n"
> +	);
> +
> +	/*
> +	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
> +	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
> +	 * v8:wp2, v9:wq2, v10:wd2/w22, v11:w12
> +	 * v12:wp3, v13:wq3, v14:wd3/w23, v15:w13
> +	 */
> +	for (d = 0; d < bytes; d += NSIZE * 4) {
> +		 /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (".option	push\n"
> +			      ".option	arch,+v\n"
> +			      "vle8.v	v0, (%[wp0])\n"
> +			      "vle8.v	v1, (%[wp0])\n"
> +			      "vle8.v	v4, (%[wp1])\n"
> +			      "vle8.v	v5, (%[wp1])\n"
> +			      "vle8.v	v8, (%[wp2])\n"
> +			      "vle8.v	v9, (%[wp2])\n"
> +			      "vle8.v	v12, (%[wp3])\n"
> +			      "vle8.v	v13, (%[wp3])\n"
> +			      ".option	pop\n"
> +			      : :
> +			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
> +			      [wp1]"r"(&dptr[z0][d + 1 * NSIZE]),
> +			      [wp2]"r"(&dptr[z0][d + 2 * NSIZE]),
> +			      [wp3]"r"(&dptr[z0][d + 3 * NSIZE])
> +		);
> +
> +		/* P/Q data pages */
> +		for (z = z0 - 1; z >= start; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * w1$$ ^= w2$$;
> +			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
> +			 * wq$$ = w1$$ ^ wd$$;
> +			 * wp$$ ^= wd$$;
> +			 */
> +			asm volatile (".option	push\n"
> +				      ".option	arch,+v\n"
> +				      "vsra.vi	v2, v1, 7\n"
> +				      "vsll.vi	v3, v1, 1\n"
> +				      "vand.vx	v2, v2, %[x1d]\n"
> +				      "vxor.vv	v3, v3, v2\n"
> +				      "vle8.v	v2, (%[wd0])\n"
> +				      "vxor.vv	v1, v3, v2\n"
> +				      "vxor.vv	v0, v0, v2\n"
> +
> +				      "vsra.vi	v6, v5, 7\n"
> +				      "vsll.vi	v7, v5, 1\n"
> +				      "vand.vx	v6, v6, %[x1d]\n"
> +				      "vxor.vv	v7, v7, v6\n"
> +				      "vle8.v	v6, (%[wd1])\n"
> +				      "vxor.vv	v5, v7, v6\n"
> +				      "vxor.vv	v4, v4, v6\n"
> +
> +				      "vsra.vi	v10, v9, 7\n"
> +				      "vsll.vi	v11, v9, 1\n"
> +				      "vand.vx	v10, v10, %[x1d]\n"
> +				      "vxor.vv	v11, v11, v10\n"
> +				      "vle8.v	v10, (%[wd2])\n"
> +				      "vxor.vv	v9, v11, v10\n"
> +				      "vxor.vv	v8, v8, v10\n"
> +
> +				      "vsra.vi	v14, v13, 7\n"
> +				      "vsll.vi	v15, v13, 1\n"
> +				      "vand.vx	v14, v14, %[x1d]\n"
> +				      "vxor.vv	v15, v15, v14\n"
> +				      "vle8.v	v14, (%[wd3])\n"
> +				      "vxor.vv	v13, v15, v14\n"
> +				      "vxor.vv	v12, v12, v14\n"
> +				      ".option	pop\n"
> +				      : :
> +				      [wd0]"r"(&dptr[z][d + 0 * NSIZE]),
> +				      [wd1]"r"(&dptr[z][d + 1 * NSIZE]),
> +				      [wd2]"r"(&dptr[z][d + 2 * NSIZE]),
> +				      [wd3]"r"(&dptr[z][d + 3 * NSIZE]),
> +				      [x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/* P/Q left side optimization */
> +		for (z = start - 1; z >= 0; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * wq$$ = w1$$ ^ w2$$;
> +			 */
> +			asm volatile (".option	push\n"
> +				      ".option	arch,+v\n"
> +				      "vsra.vi	v2, v1, 7\n"
> +				      "vsll.vi	v3, v1, 1\n"
> +				      "vand.vx	v2, v2, %[x1d]\n"
> +				      "vxor.vv	v1, v3, v2\n"
> +
> +				      "vsra.vi	v6, v5, 7\n"
> +				      "vsll.vi	v7, v5, 1\n"
> +				      "vand.vx	v6, v6, %[x1d]\n"
> +				      "vxor.vv	v5, v7, v6\n"
> +
> +				      "vsra.vi	v10, v9, 7\n"
> +				      "vsll.vi	v11, v9, 1\n"
> +				      "vand.vx	v10, v10, %[x1d]\n"
> +				      "vxor.vv	v9, v11, v10\n"
> +
> +				      "vsra.vi	v14, v13, 7\n"
> +				      "vsll.vi	v15, v13, 1\n"
> +				      "vand.vx	v14, v14, %[x1d]\n"
> +				      "vxor.vv	v13, v15, v14\n"
> +				      ".option	pop\n"
> +				      : :
> +				      [x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/*
> +		 * *(unative_t *)&p[d+NSIZE*$$] ^= wp$$;
> +		 * *(unative_t *)&q[d+NSIZE*$$] ^= wq$$;
> +		 * v0:wp0, v1:wq0, v2:p0, v3:q0
> +		 * v4:wp1, v5:wq1, v6:p1, v7:q1
> +		 * v8:wp2, v9:wq2, v10:p2, v11:q2
> +		 * v12:wp3, v13:wq3, v14:p3, v15:q3
> +		 */
> +		asm volatile (".option	push\n"
> +			      ".option	arch,+v\n"
> +			      "vle8.v	v2, (%[wp0])\n"
> +			      "vle8.v	v3, (%[wq0])\n"
> +			      "vxor.vv	v2, v2, v0\n"
> +			      "vxor.vv	v3, v3, v1\n"
> +			      "vse8.v	v2, (%[wp0])\n"
> +			      "vse8.v	v3, (%[wq0])\n"
> +
> +			      "vle8.v	v6, (%[wp1])\n"
> +			      "vle8.v	v7, (%[wq1])\n"
> +			      "vxor.vv	v6, v6, v4\n"
> +			      "vxor.vv	v7, v7, v5\n"
> +			      "vse8.v	v6, (%[wp1])\n"
> +			      "vse8.v	v7, (%[wq1])\n"
> +
> +			      "vle8.v	v10, (%[wp2])\n"
> +			      "vle8.v	v11, (%[wq2])\n"
> +			      "vxor.vv	v10, v10, v8\n"
> +			      "vxor.vv	v11, v11, v9\n"
> +			      "vse8.v	v10, (%[wp2])\n"
> +			      "vse8.v	v11, (%[wq2])\n"
> +
> +			      "vle8.v	v14, (%[wp3])\n"
> +			      "vle8.v	v15, (%[wq3])\n"
> +			      "vxor.vv	v14, v14, v12\n"
> +			      "vxor.vv	v15, v15, v13\n"
> +			      "vse8.v	v14, (%[wp3])\n"
> +			      "vse8.v	v15, (%[wq3])\n"
> +			      ".option	pop\n"
> +			      : :
> +			      [wp0]"r"(&p[d + NSIZE * 0]),
> +			      [wq0]"r"(&q[d + NSIZE * 0]),
> +			      [wp1]"r"(&p[d + NSIZE * 1]),
> +			      [wq1]"r"(&q[d + NSIZE * 1]),
> +			      [wp2]"r"(&p[d + NSIZE * 2]),
> +			      [wq2]"r"(&q[d + NSIZE * 2]),
> +			      [wp3]"r"(&p[d + NSIZE * 3]),
> +			      [wq3]"r"(&q[d + NSIZE * 3])
> +		);
> +	}
> +}
> +
> +static void raid6_rvv8_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	unsigned long d;
> +	int z, z0;
> +	u8 *p, *q;
> +
> +	z0 = disks - 3;	/* Highest data disk */
> +	p = dptr[z0 + 1];	/* XOR parity */
> +	q = dptr[z0 + 2];	/* RS syndrome */
> +
> +	asm volatile (".option	push\n"
> +		      ".option	arch,+v\n"
> +		      "vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		      ".option	pop\n"
> +	);
> +
> +	/*
> +	 * v0:wp0,   v1:wq0,  v2:wd0/w20,  v3:w10
> +	 * v4:wp1,   v5:wq1,  v6:wd1/w21,  v7:w11
> +	 * v8:wp2,   v9:wq2, v10:wd2/w22, v11:w12
> +	 * v12:wp3, v13:wq3, v14:wd3/w23, v15:w13
> +	 * v16:wp4, v17:wq4, v18:wd4/w24, v19:w14
> +	 * v20:wp5, v21:wq5, v22:wd5/w25, v23:w15
> +	 * v24:wp6, v25:wq6, v26:wd6/w26, v27:w16
> +	 * v28:wp7, v29:wq7, v30:wd7/w27, v31:w17
> +	 */
> +	for (d = 0; d < bytes; d += NSIZE * 8) {
> +		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (".option	push\n"
> +			      ".option	arch,+v\n"
> +			      "vle8.v	v0, (%[wp0])\n"
> +			      "vle8.v	v1, (%[wp0])\n"
> +			      "vle8.v	v4, (%[wp1])\n"
> +			      "vle8.v	v5, (%[wp1])\n"
> +			      "vle8.v	v8, (%[wp2])\n"
> +			      "vle8.v	v9, (%[wp2])\n"
> +			      "vle8.v	v12, (%[wp3])\n"
> +			      "vle8.v	v13, (%[wp3])\n"
> +			      "vle8.v	v16, (%[wp4])\n"
> +			      "vle8.v	v17, (%[wp4])\n"
> +			      "vle8.v	v20, (%[wp5])\n"
> +			      "vle8.v	v21, (%[wp5])\n"
> +			      "vle8.v	v24, (%[wp6])\n"
> +			      "vle8.v	v25, (%[wp6])\n"
> +			      "vle8.v	v28, (%[wp7])\n"
> +			      "vle8.v	v29, (%[wp7])\n"
> +			      ".option	pop\n"
> +			      : :
> +			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
> +			      [wp1]"r"(&dptr[z0][d + 1 * NSIZE]),
> +			      [wp2]"r"(&dptr[z0][d + 2 * NSIZE]),
> +			      [wp3]"r"(&dptr[z0][d + 3 * NSIZE]),
> +			      [wp4]"r"(&dptr[z0][d + 4 * NSIZE]),
> +			      [wp5]"r"(&dptr[z0][d + 5 * NSIZE]),
> +			      [wp6]"r"(&dptr[z0][d + 6 * NSIZE]),
> +			      [wp7]"r"(&dptr[z0][d + 7 * NSIZE])
> +		);
> +
> +		for (z = z0 - 1; z >= 0; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * w1$$ ^= w2$$;
> +			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
> +			 * wq$$ = w1$$ ^ wd$$;
> +			 * wp$$ ^= wd$$;
> +			 */
> +			asm volatile (".option	push\n"
> +				      ".option	arch,+v\n"
> +				      "vsra.vi	v2, v1, 7\n"
> +				      "vsll.vi	v3, v1, 1\n"
> +				      "vand.vx	v2, v2, %[x1d]\n"
> +				      "vxor.vv	v3, v3, v2\n"
> +				      "vle8.v	v2, (%[wd0])\n"
> +				      "vxor.vv	v1, v3, v2\n"
> +				      "vxor.vv	v0, v0, v2\n"
> +
> +				      "vsra.vi	v6, v5, 7\n"
> +				      "vsll.vi	v7, v5, 1\n"
> +				      "vand.vx	v6, v6, %[x1d]\n"
> +				      "vxor.vv	v7, v7, v6\n"
> +				      "vle8.v	v6, (%[wd1])\n"
> +				      "vxor.vv	v5, v7, v6\n"
> +				      "vxor.vv	v4, v4, v6\n"
> +
> +				      "vsra.vi	v10, v9, 7\n"
> +				      "vsll.vi	v11, v9, 1\n"
> +				      "vand.vx	v10, v10, %[x1d]\n"
> +				      "vxor.vv	v11, v11, v10\n"
> +				      "vle8.v	v10, (%[wd2])\n"
> +				      "vxor.vv	v9, v11, v10\n"
> +				      "vxor.vv	v8, v8, v10\n"
> +
> +				      "vsra.vi	v14, v13, 7\n"
> +				      "vsll.vi	v15, v13, 1\n"
> +				      "vand.vx	v14, v14, %[x1d]\n"
> +				      "vxor.vv	v15, v15, v14\n"
> +				      "vle8.v	v14, (%[wd3])\n"
> +				      "vxor.vv	v13, v15, v14\n"
> +				      "vxor.vv	v12, v12, v14\n"
> +
> +				      "vsra.vi	v18, v17, 7\n"
> +				      "vsll.vi	v19, v17, 1\n"
> +				      "vand.vx	v18, v18, %[x1d]\n"
> +				      "vxor.vv	v19, v19, v18\n"
> +				      "vle8.v	v18, (%[wd4])\n"
> +				      "vxor.vv	v17, v19, v18\n"
> +				      "vxor.vv	v16, v16, v18\n"
> +
> +				      "vsra.vi	v22, v21, 7\n"
> +				      "vsll.vi	v23, v21, 1\n"
> +				      "vand.vx	v22, v22, %[x1d]\n"
> +				      "vxor.vv	v23, v23, v22\n"
> +				      "vle8.v	v22, (%[wd5])\n"
> +				      "vxor.vv	v21, v23, v22\n"
> +				      "vxor.vv	v20, v20, v22\n"
> +
> +				      "vsra.vi	v26, v25, 7\n"
> +				      "vsll.vi	v27, v25, 1\n"
> +				      "vand.vx	v26, v26, %[x1d]\n"
> +				      "vxor.vv	v27, v27, v26\n"
> +				      "vle8.v	v26, (%[wd6])\n"
> +				      "vxor.vv	v25, v27, v26\n"
> +				      "vxor.vv	v24, v24, v26\n"
> +
> +				      "vsra.vi	v30, v29, 7\n"
> +				      "vsll.vi	v31, v29, 1\n"
> +				      "vand.vx	v30, v30, %[x1d]\n"
> +				      "vxor.vv	v31, v31, v30\n"
> +				      "vle8.v	v30, (%[wd7])\n"
> +				      "vxor.vv	v29, v31, v30\n"
> +				      "vxor.vv	v28, v28, v30\n"
> +				      ".option	pop\n"
> +				      : :
> +				      [wd0]"r"(&dptr[z][d + 0 * NSIZE]),
> +				      [wd1]"r"(&dptr[z][d + 1 * NSIZE]),
> +				      [wd2]"r"(&dptr[z][d + 2 * NSIZE]),
> +				      [wd3]"r"(&dptr[z][d + 3 * NSIZE]),
> +				      [wd4]"r"(&dptr[z][d + 4 * NSIZE]),
> +				      [wd5]"r"(&dptr[z][d + 5 * NSIZE]),
> +				      [wd6]"r"(&dptr[z][d + 6 * NSIZE]),
> +				      [wd7]"r"(&dptr[z][d + 7 * NSIZE]),
> +				      [x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/*
> +		 * *(unative_t *)&p[d+NSIZE*$$] = wp$$;
> +		 * *(unative_t *)&q[d+NSIZE*$$] = wq$$;
> +		 */
> +		asm volatile (".option	push\n"
> +			      ".option	arch,+v\n"
> +			      "vse8.v	v0, (%[wp0])\n"
> +			      "vse8.v	v1, (%[wq0])\n"
> +			      "vse8.v	v4, (%[wp1])\n"
> +			      "vse8.v	v5, (%[wq1])\n"
> +			      "vse8.v	v8, (%[wp2])\n"
> +			      "vse8.v	v9, (%[wq2])\n"
> +			      "vse8.v	v12, (%[wp3])\n"
> +			      "vse8.v	v13, (%[wq3])\n"
> +			      "vse8.v	v16, (%[wp4])\n"
> +			      "vse8.v	v17, (%[wq4])\n"
> +			      "vse8.v	v20, (%[wp5])\n"
> +			      "vse8.v	v21, (%[wq5])\n"
> +			      "vse8.v	v24, (%[wp6])\n"
> +			      "vse8.v	v25, (%[wq6])\n"
> +			      "vse8.v	v28, (%[wp7])\n"
> +			      "vse8.v	v29, (%[wq7])\n"
> +			      ".option	pop\n"
> +			      : :
> +			      [wp0]"r"(&p[d + NSIZE * 0]),
> +			      [wq0]"r"(&q[d + NSIZE * 0]),
> +			      [wp1]"r"(&p[d + NSIZE * 1]),
> +			      [wq1]"r"(&q[d + NSIZE * 1]),
> +			      [wp2]"r"(&p[d + NSIZE * 2]),
> +			      [wq2]"r"(&q[d + NSIZE * 2]),
> +			      [wp3]"r"(&p[d + NSIZE * 3]),
> +			      [wq3]"r"(&q[d + NSIZE * 3]),
> +			      [wp4]"r"(&p[d + NSIZE * 4]),
> +			      [wq4]"r"(&q[d + NSIZE * 4]),
> +			      [wp5]"r"(&p[d + NSIZE * 5]),
> +			      [wq5]"r"(&q[d + NSIZE * 5]),
> +			      [wp6]"r"(&p[d + NSIZE * 6]),
> +			      [wq6]"r"(&q[d + NSIZE * 6]),
> +			      [wp7]"r"(&p[d + NSIZE * 7]),
> +			      [wq7]"r"(&q[d + NSIZE * 7])
> +		);
> +	}
> +}
> +
> +static void raid6_rvv8_xor_syndrome_real(int disks, int start, int stop,
> +					 unsigned long bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	u8 *p, *q;
> +	unsigned long d;
> +	int z, z0;
> +
> +	z0 = stop;		/* P/Q right side optimization */
> +	p = dptr[disks - 2];	/* XOR parity */
> +	q = dptr[disks - 1];	/* RS syndrome */
> +
> +	asm volatile (".option	push\n"
> +		      ".option	arch,+v\n"
> +		      "vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		      ".option	pop\n"
> +	);
> +
> +	/*
> +	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
> +	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
> +	 * v8:wp2, v9:wq2, v10:wd2/w22, v11:w12
> +	 * v12:wp3, v13:wq3, v14:wd3/w23, v15:w13
> +	 * v16:wp4, v17:wq4, v18:wd4/w24, v19:w14
> +	 * v20:wp5, v21:wq5, v22:wd5/w25, v23:w15
> +	 * v24:wp6, v25:wq6, v26:wd6/w26, v27:w16
> +	 * v28:wp7, v29:wq7, v30:wd7/w27, v31:w17
> +	 */
> +	for (d = 0; d < bytes; d += NSIZE * 8) {
> +		 /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (".option	push\n"
> +			      ".option	arch,+v\n"
> +			      "vle8.v	v0, (%[wp0])\n"
> +			      "vle8.v	v1, (%[wp0])\n"
> +			      "vle8.v	v4, (%[wp1])\n"
> +			      "vle8.v	v5, (%[wp1])\n"
> +			      "vle8.v	v8, (%[wp2])\n"
> +			      "vle8.v	v9, (%[wp2])\n"
> +			      "vle8.v	v12, (%[wp3])\n"
> +			      "vle8.v	v13, (%[wp3])\n"
> +			      "vle8.v	v16, (%[wp4])\n"
> +			      "vle8.v	v17, (%[wp4])\n"
> +			      "vle8.v	v20, (%[wp5])\n"
> +			      "vle8.v	v21, (%[wp5])\n"
> +			      "vle8.v	v24, (%[wp6])\n"
> +			      "vle8.v	v25, (%[wp6])\n"
> +			      "vle8.v	v28, (%[wp7])\n"
> +			      "vle8.v	v29, (%[wp7])\n"
> +			      ".option	pop\n"
> +			      : :
> +			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
> +			      [wp1]"r"(&dptr[z0][d + 1 * NSIZE]),
> +			      [wp2]"r"(&dptr[z0][d + 2 * NSIZE]),
> +			      [wp3]"r"(&dptr[z0][d + 3 * NSIZE]),
> +			      [wp4]"r"(&dptr[z0][d + 4 * NSIZE]),
> +			      [wp5]"r"(&dptr[z0][d + 5 * NSIZE]),
> +			      [wp6]"r"(&dptr[z0][d + 6 * NSIZE]),
> +			      [wp7]"r"(&dptr[z0][d + 7 * NSIZE])
> +		);
> +
> +		/* P/Q data pages */
> +		for (z = z0 - 1; z >= start; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * w1$$ ^= w2$$;
> +			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
> +			 * wq$$ = w1$$ ^ wd$$;
> +			 * wp$$ ^= wd$$;
> +			 */
> +			asm volatile (".option	push\n"
> +				      ".option	arch,+v\n"
> +				      "vsra.vi	v2, v1, 7\n"
> +				      "vsll.vi	v3, v1, 1\n"
> +				      "vand.vx	v2, v2, %[x1d]\n"
> +				      "vxor.vv	v3, v3, v2\n"
> +				      "vle8.v	v2, (%[wd0])\n"
> +				      "vxor.vv	v1, v3, v2\n"
> +				      "vxor.vv	v0, v0, v2\n"
> +
> +				      "vsra.vi	v6, v5, 7\n"
> +				      "vsll.vi	v7, v5, 1\n"
> +				      "vand.vx	v6, v6, %[x1d]\n"
> +				      "vxor.vv	v7, v7, v6\n"
> +				      "vle8.v	v6, (%[wd1])\n"
> +				      "vxor.vv	v5, v7, v6\n"
> +				      "vxor.vv	v4, v4, v6\n"
> +
> +				      "vsra.vi	v10, v9, 7\n"
> +				      "vsll.vi	v11, v9, 1\n"
> +				      "vand.vx	v10, v10, %[x1d]\n"
> +				      "vxor.vv	v11, v11, v10\n"
> +				      "vle8.v	v10, (%[wd2])\n"
> +				      "vxor.vv	v9, v11, v10\n"
> +				      "vxor.vv	v8, v8, v10\n"
> +
> +				      "vsra.vi	v14, v13, 7\n"
> +				      "vsll.vi	v15, v13, 1\n"
> +				      "vand.vx	v14, v14, %[x1d]\n"
> +				      "vxor.vv	v15, v15, v14\n"
> +				      "vle8.v	v14, (%[wd3])\n"
> +				      "vxor.vv	v13, v15, v14\n"
> +				      "vxor.vv	v12, v12, v14\n"
> +
> +				      "vsra.vi	v18, v17, 7\n"
> +				      "vsll.vi	v19, v17, 1\n"
> +				      "vand.vx	v18, v18, %[x1d]\n"
> +				      "vxor.vv	v19, v19, v18\n"
> +				      "vle8.v	v18, (%[wd4])\n"
> +				      "vxor.vv	v17, v19, v18\n"
> +				      "vxor.vv	v16, v16, v18\n"
> +
> +				      "vsra.vi	v22, v21, 7\n"
> +				      "vsll.vi	v23, v21, 1\n"
> +				      "vand.vx	v22, v22, %[x1d]\n"
> +				      "vxor.vv	v23, v23, v22\n"
> +				      "vle8.v	v22, (%[wd5])\n"
> +				      "vxor.vv	v21, v23, v22\n"
> +				      "vxor.vv	v20, v20, v22\n"
> +
> +				      "vsra.vi	v26, v25, 7\n"
> +				      "vsll.vi	v27, v25, 1\n"
> +				      "vand.vx	v26, v26, %[x1d]\n"
> +				      "vxor.vv	v27, v27, v26\n"
> +				      "vle8.v	v26, (%[wd6])\n"
> +				      "vxor.vv	v25, v27, v26\n"
> +				      "vxor.vv	v24, v24, v26\n"
> +
> +				      "vsra.vi	v30, v29, 7\n"
> +				      "vsll.vi	v31, v29, 1\n"
> +				      "vand.vx	v30, v30, %[x1d]\n"
> +				      "vxor.vv	v31, v31, v30\n"
> +				      "vle8.v	v30, (%[wd7])\n"
> +				      "vxor.vv	v29, v31, v30\n"
> +				      "vxor.vv	v28, v28, v30\n"
> +				      ".option	pop\n"
> +				      : :
> +				      [wd0]"r"(&dptr[z][d + 0 * NSIZE]),
> +				      [wd1]"r"(&dptr[z][d + 1 * NSIZE]),
> +				      [wd2]"r"(&dptr[z][d + 2 * NSIZE]),
> +				      [wd3]"r"(&dptr[z][d + 3 * NSIZE]),
> +				      [wd4]"r"(&dptr[z][d + 4 * NSIZE]),
> +				      [wd5]"r"(&dptr[z][d + 5 * NSIZE]),
> +				      [wd6]"r"(&dptr[z][d + 6 * NSIZE]),
> +				      [wd7]"r"(&dptr[z][d + 7 * NSIZE]),
> +				      [x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/* P/Q left side optimization */
> +		for (z = start - 1; z >= 0; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * wq$$ = w1$$ ^ w2$$;
> +			 */
> +			asm volatile (".option	push\n"
> +				      ".option	arch,+v\n"
> +				      "vsra.vi	v2, v1, 7\n"
> +				      "vsll.vi	v3, v1, 1\n"
> +				      "vand.vx	v2, v2, %[x1d]\n"
> +				      "vxor.vv	v1, v3, v2\n"
> +
> +				      "vsra.vi	v6, v5, 7\n"
> +				      "vsll.vi	v7, v5, 1\n"
> +				      "vand.vx	v6, v6, %[x1d]\n"
> +				      "vxor.vv	v5, v7, v6\n"
> +
> +				      "vsra.vi	v10, v9, 7\n"
> +				      "vsll.vi	v11, v9, 1\n"
> +				      "vand.vx	v10, v10, %[x1d]\n"
> +				      "vxor.vv	v9, v11, v10\n"
> +
> +				      "vsra.vi	v14, v13, 7\n"
> +				      "vsll.vi	v15, v13, 1\n"
> +				      "vand.vx	v14, v14, %[x1d]\n"
> +				      "vxor.vv	v13, v15, v14\n"
> +
> +				      "vsra.vi	v18, v17, 7\n"
> +				      "vsll.vi	v19, v17, 1\n"
> +				      "vand.vx	v18, v18, %[x1d]\n"
> +				      "vxor.vv	v17, v19, v18\n"
> +
> +				      "vsra.vi	v22, v21, 7\n"
> +				      "vsll.vi	v23, v21, 1\n"
> +				      "vand.vx	v22, v22, %[x1d]\n"
> +				      "vxor.vv	v21, v23, v22\n"
> +
> +				      "vsra.vi	v26, v25, 7\n"
> +				      "vsll.vi	v27, v25, 1\n"
> +				      "vand.vx	v26, v26, %[x1d]\n"
> +				      "vxor.vv	v25, v27, v26\n"
> +
> +				      "vsra.vi	v30, v29, 7\n"
> +				      "vsll.vi	v31, v29, 1\n"
> +				      "vand.vx	v30, v30, %[x1d]\n"
> +				      "vxor.vv	v29, v31, v30\n"
> +				      ".option	pop\n"
> +				      : :
> +				      [x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/*
> +		 * *(unative_t *)&p[d+NSIZE*$$] ^= wp$$;
> +		 * *(unative_t *)&q[d+NSIZE*$$] ^= wq$$;
> +		 * v0:wp0, v1:wq0, v2:p0, v3:q0
> +		 * v4:wp1, v5:wq1, v6:p1, v7:q1
> +		 * v8:wp2, v9:wq2, v10:p2, v11:q2
> +		 * v12:wp3, v13:wq3, v14:p3, v15:q3
> +		 * v16:wp4, v17:wq4, v18:p4, v19:q4
> +		 * v20:wp5, v21:wq5, v22:p5, v23:q5
> +		 * v24:wp6, v25:wq6, v26:p6, v27:q6
> +		 * v28:wp7, v29:wq7, v30:p7, v31:q7
> +		 */
> +		asm volatile (".option	push\n"
> +			      ".option	arch,+v\n"
> +			      "vle8.v	v2, (%[wp0])\n"
> +			      "vle8.v	v3, (%[wq0])\n"
> +			      "vxor.vv	v2, v2, v0\n"
> +			      "vxor.vv	v3, v3, v1\n"
> +			      "vse8.v	v2, (%[wp0])\n"
> +			      "vse8.v	v3, (%[wq0])\n"
> +
> +			      "vle8.v	v6, (%[wp1])\n"
> +			      "vle8.v	v7, (%[wq1])\n"
> +			      "vxor.vv	v6, v6, v4\n"
> +			      "vxor.vv	v7, v7, v5\n"
> +			      "vse8.v	v6, (%[wp1])\n"
> +			      "vse8.v	v7, (%[wq1])\n"
> +
> +			      "vle8.v	v10, (%[wp2])\n"
> +			      "vle8.v	v11, (%[wq2])\n"
> +			      "vxor.vv	v10, v10, v8\n"
> +			      "vxor.vv	v11, v11, v9\n"
> +			      "vse8.v	v10, (%[wp2])\n"
> +			      "vse8.v	v11, (%[wq2])\n"
> +
> +			      "vle8.v	v14, (%[wp3])\n"
> +			      "vle8.v	v15, (%[wq3])\n"
> +			      "vxor.vv	v14, v14, v12\n"
> +			      "vxor.vv	v15, v15, v13\n"
> +			      "vse8.v	v14, (%[wp3])\n"
> +			      "vse8.v	v15, (%[wq3])\n"
> +
> +			      "vle8.v	v18, (%[wp4])\n"
> +			      "vle8.v	v19, (%[wq4])\n"
> +			      "vxor.vv	v18, v18, v16\n"
> +			      "vxor.vv	v19, v19, v17\n"
> +			      "vse8.v	v18, (%[wp4])\n"
> +			      "vse8.v	v19, (%[wq4])\n"
> +
> +			      "vle8.v	v22, (%[wp5])\n"
> +			      "vle8.v	v23, (%[wq5])\n"
> +			      "vxor.vv	v22, v22, v20\n"
> +			      "vxor.vv	v23, v23, v21\n"
> +			      "vse8.v	v22, (%[wp5])\n"
> +			      "vse8.v	v23, (%[wq5])\n"
> +
> +			      "vle8.v	v26, (%[wp6])\n"
> +			      "vle8.v	v27, (%[wq6])\n"
> +			      "vxor.vv	v26, v26, v24\n"
> +			      "vxor.vv	v27, v27, v25\n"
> +			      "vse8.v	v26, (%[wp6])\n"
> +			      "vse8.v	v27, (%[wq6])\n"
> +
> +			      "vle8.v	v30, (%[wp7])\n"
> +			      "vle8.v	v31, (%[wq7])\n"
> +			      "vxor.vv	v30, v30, v28\n"
> +			      "vxor.vv	v31, v31, v29\n"
> +			      "vse8.v	v30, (%[wp7])\n"
> +			      "vse8.v	v31, (%[wq7])\n"
> +			      ".option	pop\n"
> +			      : :
> +			      [wp0]"r"(&p[d + NSIZE * 0]),
> +			      [wq0]"r"(&q[d + NSIZE * 0]),
> +			      [wp1]"r"(&p[d + NSIZE * 1]),
> +			      [wq1]"r"(&q[d + NSIZE * 1]),
> +			      [wp2]"r"(&p[d + NSIZE * 2]),
> +			      [wq2]"r"(&q[d + NSIZE * 2]),
> +			      [wp3]"r"(&p[d + NSIZE * 3]),
> +			      [wq3]"r"(&q[d + NSIZE * 3]),
> +			      [wp4]"r"(&p[d + NSIZE * 4]),
> +			      [wq4]"r"(&q[d + NSIZE * 4]),
> +			      [wp5]"r"(&p[d + NSIZE * 5]),
> +			      [wq5]"r"(&q[d + NSIZE * 5]),
> +			      [wp6]"r"(&p[d + NSIZE * 6]),
> +			      [wq6]"r"(&q[d + NSIZE * 6]),
> +			      [wp7]"r"(&p[d + NSIZE * 7]),
> +			      [wq7]"r"(&q[d + NSIZE * 7])
> +		);
> +	}
> +}
> +
> +RAID6_RVV_WRAPPER(1);
> +RAID6_RVV_WRAPPER(2);
> +RAID6_RVV_WRAPPER(4);
> +RAID6_RVV_WRAPPER(8);
> diff --git a/lib/raid6/rvv.h b/lib/raid6/rvv.h
> new file mode 100644
> index 000000000000..ac4dea0830b4
> --- /dev/null
> +++ b/lib/raid6/rvv.h
> @@ -0,0 +1,39 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Copyright 2024 Institute of Software, CAS.
> + *
> + * raid6/rvv.h
> + *
> + * Definitions for RISC-V RAID-6 code
> + */
> +
> +#define RAID6_RVV_WRAPPER(_n)						\
> +	static void raid6_rvv ## _n ## _gen_syndrome(int disks,		\
> +					size_t bytes, void **ptrs)	\
> +	{								\
> +		void raid6_rvv ## _n  ## _gen_syndrome_real(int d,	\
> +					unsigned long b, void **p);	\
> +		kernel_vector_begin();					\
> +		raid6_rvv ## _n ## _gen_syndrome_real(disks,		\
> +				(unsigned long)bytes, ptrs);		\
> +		kernel_vector_end();					\
> +	}								\
> +	static void raid6_rvv ## _n ## _xor_syndrome(int disks,		\
> +					int start, int stop,		\
> +					size_t bytes, void **ptrs)	\
> +	{								\
> +		void raid6_rvv ## _n  ## _xor_syndrome_real(int d,	\
> +					int s1, int s2,			\
> +					unsigned long b, void **p);	\
> +		kernel_vector_begin();					\
> +		raid6_rvv ## _n ## _xor_syndrome_real(disks,		\
> +			start, stop, (unsigned long)bytes, ptrs);	\
> +		kernel_vector_end();					\
> +	}								\
> +	struct raid6_calls const raid6_rvvx ## _n = {			\
> +		raid6_rvv ## _n ## _gen_syndrome,			\
> +		raid6_rvv ## _n ## _xor_syndrome,			\
> +		rvv_has_vector,						\
> +		"rvvx" #_n,						\
> +		0							\
> +	}
