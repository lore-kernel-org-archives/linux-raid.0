Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1577C204C18
	for <linux-raid@vger.kernel.org>; Wed,  8 Jan 2025 23:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736379924; cv=none; b=G/zhdwGu40HZUP067GxZgewjfNzWhqON27KRqTQLvifzxvL++wrLAhqocTvPhJ/6LBsR5OYibhcgLPfKGNrLJYvsouts/Bo9cGwJgjEOXtl77U/CWtECCOwR3TOrrLHxbS4wZDiAPQz6xlwXjAjvqyVA4PB8HTR2juUY/oDp2ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736379924; c=relaxed/simple;
	bh=RgB2QaTDX66/NVPXmwQSPedG5hQ4aTobF8NuvXb/i8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R38qsNSUGJ/OZ0Ady24fIx+w+mAvj6HDPTIViZkaz/Nk/0JrTvIyHqYQJIjMWbniZu0/Smw8qq8BKvTsliinkaCTVAV1n4mgPW3aPVtuEniHpgD6puD/JAIa9UBtKECtEZxI6hIK3nS/k81nTw5vSRv4BKsuAbPrwoPqPxvAmYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=XRXoWKH8; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="XRXoWKH8"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2161eb95317so4154515ad.1
        for <linux-raid@vger.kernel.org>; Wed, 08 Jan 2025 15:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736379919; x=1736984719; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=n04hWB4Gk98hLfclBb+qe72ao+x7pfesVUwK71GCVrE=;
        b=XRXoWKH82vB6Kc+S5P7euMARj42FlYLPwr4eZfQe/dfQf+bwolGcQVqUT3x1VsQxcI
         HQMO569jJ/qUL8v2yupJp+oYbx6SiP9iQkOwA+bKXXb7sqRKv51+r237G6q1PpNHE1qr
         OgWH6qbo5h0pURZTSNwidarwTYBaTeMqsZtOS9u3MVqRzKtXnHnDdYbumSay62uhzz0v
         TBX8rICFpi98cjR8oRlKbBSnTzEI0r2+kySNni0DWbG25FNVPTiBSpa2JsAzUTbDdPSh
         VeZo7sQWnPIMyHw0OtXa3AYEfE4HzGeZIcglBjSOQF6Opj6B4UVbPm6YF5XJnmt/+vdH
         J3ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736379919; x=1736984719;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n04hWB4Gk98hLfclBb+qe72ao+x7pfesVUwK71GCVrE=;
        b=PSXjfwYjKjTsdQ1BWpz08P2bLGNte6FmhOlLXcI1m4WcKLoPUBbOvrYwUT0JXR47ON
         eIfywSX3+cRloSDYVEzLNTnfVfCJrOKzFLdo65Elv34uED/3yqgClavlkNnNJ5qizwT3
         xjIAjva057F66XkbW4jb2zbQ146u6F/+blFeL7fRg0JyHYgBI7c4Q5/VF6EcIag3Oh09
         0/iE1N6srYg5uhEAsiRArGncO9cyUqjvCSoc1nhtKhRBCz4a/IO0C+ztkVpyV406yQZD
         D2+bhS77Dow35TPuRJcIbocJCHGi4rXqjNvIvKtSHVQxAjtXDpisl9Ca8vJq9rqJU/GZ
         s2Fw==
X-Forwarded-Encrypted: i=1; AJvYcCUhjykf/4kLSUUCoSgxg3L54NdPtNBSyhmEIJ3csjNvJnSjpkPT3kZts3bC6Fpd+wpb8KyFJdJ2Q2/f@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ/XnLlP2ej3TPMaVTNXXVRU3ZQUrzNOx5ARxmBjAYVqXlTVwa
	N2RKQvpWSWJGtOIVAkbyxCVp+hGLls3qiyzWbe2HBhmAa7UIeCAapZiTwF234bc=
X-Gm-Gg: ASbGncv3uLcAj2idutzk1H9+WkWTL0OPrYcBSHbsib7saql/KXVGZNc2Gjw4X7DYOZi
	gxHErCJxOHBIQCUqsdJ7zyhOZv+tqQI5H/HdACypMQlePt2PiDDvpmZAIjCH9rQmjOcqB7DKZIw
	wnaBMabvgQhTGzYyraSLEM/lHUhOVpZJ4TzBIKKlyNqXAbFs5m8jm2ix4Y7hS1WQVO1NC/YJl+p
	wa7C6TJumV8ciZZgUtTNBwl6p4771jJY7dXOxRxctWEGyk=
X-Google-Smtp-Source: AGHT+IE4K86nZhxH67OFnzwzadVw/70Z5n3t9N6HCqVWIdc3NLjhYygvY3gsFAo6Y/YBoof3Iq6I2Q==
X-Received: by 2002:a05:6a00:e8e:b0:725:460e:6bc0 with SMTP id d2e1a72fcca58-72d21df408dmr6550197b3a.0.1736379918960;
        Wed, 08 Jan 2025 15:45:18 -0800 (PST)
Received: from ghost ([50.145.13.30])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad90c2e9sm37068310b3a.180.2025.01.08.15.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 15:45:18 -0800 (PST)
Date: Wed, 8 Jan 2025 15:45:12 -0800
From: Charlie Jenkins <charlie@rivosinc.com>
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>, linux-riscv@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: Re: [RFC PATCH] raid6: Add RISC-V SIMD syndrome and recovery
 calculations
Message-ID: <Z38OCF7cMqz6z7p3@ghost>
References: <20241220114023.667347-1-zhangchunyan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241220114023.667347-1-zhangchunyan@iscas.ac.cn>

On Fri, Dec 20, 2024 at 07:40:23PM +0800, Chunyan Zhang wrote:
> The assembly is originally based on the ARM NEON and int.uc, but uses
> RISC-V vector instructions to implement the RAID6 syndrome and
> recovery calculations.
> 
> The functions are tested on QEMU.
> 
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> ---
>  include/linux/raid/pq.h |   4 +
>  lib/raid6/Makefile      |   3 +
>  lib/raid6/algos.c       |   8 +
>  lib/raid6/recov_rvv.c   | 229 +++++++++++++
>  lib/raid6/rvv.c         | 715 ++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 959 insertions(+)
>  create mode 100644 lib/raid6/recov_rvv.c
>  create mode 100644 lib/raid6/rvv.c
> 
> diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
> index 98030accf641..4c21f06c662a 100644
> --- a/include/linux/raid/pq.h
> +++ b/include/linux/raid/pq.h
> @@ -108,6 +108,9 @@ extern const struct raid6_calls raid6_vpermxor4;
>  extern const struct raid6_calls raid6_vpermxor8;
>  extern const struct raid6_calls raid6_lsx;
>  extern const struct raid6_calls raid6_lasx;
> +extern const struct raid6_calls raid6_rvvx1;
> +extern const struct raid6_calls raid6_rvvx2;
> +extern const struct raid6_calls raid6_rvvx4;
>  
>  struct raid6_recov_calls {
>  	void (*data2)(int, size_t, int, int, void **);
> @@ -125,6 +128,7 @@ extern const struct raid6_recov_calls raid6_recov_s390xc;
>  extern const struct raid6_recov_calls raid6_recov_neon;
>  extern const struct raid6_recov_calls raid6_recov_lsx;
>  extern const struct raid6_recov_calls raid6_recov_lasx;
> +extern const struct raid6_recov_calls raid6_recov_rvv;
>  
>  extern const struct raid6_calls raid6_neonx1;
>  extern const struct raid6_calls raid6_neonx2;
> diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
> index 29127dd05d63..e62fb7cd773e 100644
> --- a/lib/raid6/Makefile
> +++ b/lib/raid6/Makefile
> @@ -10,6 +10,9 @@ raid6_pq-$(CONFIG_ALTIVEC) += altivec1.o altivec2.o altivec4.o altivec8.o \
>  raid6_pq-$(CONFIG_KERNEL_MODE_NEON) += neon.o neon1.o neon2.o neon4.o neon8.o recov_neon.o recov_neon_inner.o
>  raid6_pq-$(CONFIG_S390) += s390vx8.o recov_s390xc.o
>  raid6_pq-$(CONFIG_LOONGARCH) += loongarch_simd.o recov_loongarch_simd.o
> +raid6_pq-$(CONFIG_RISCV_ISA_V) += rvv.o recov_rvv.o
> +CFLAGS_rvv.o += -march=rv64gcv
> +CFLAGS_recov_rvv.o += -march=rv64gcv
>  
>  hostprogs	+= mktables
>  
> diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> index cd2e88ee1f14..0a388a605131 100644
> --- a/lib/raid6/algos.c
> +++ b/lib/raid6/algos.c
> @@ -80,6 +80,11 @@ const struct raid6_calls * const raid6_algos[] = {
>  #ifdef CONFIG_CPU_HAS_LSX
>  	&raid6_lsx,
>  #endif
> +#endif
> +#ifdef CONFIG_RISCV_ISA_V
> +	&raid6_rvvx1,
> +	&raid6_rvvx2,
> +	&raid6_rvvx4,
>  #endif
>  	&raid6_intx8,
>  	&raid6_intx4,
> @@ -115,6 +120,9 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
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
> index 000000000000..8ae74803ea7f
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
> +static void __raid6_2data_recov_rvv(int bytes, u8 *p, u8 *q, u8 *dp,
> +			      u8 *dq, const u8 *pbmul,
> +			      const u8 *qmul)
> +{
> +	asm volatile (
> +		".option	push\n"
> +		".option	arch,+v\n"
> +		"vsetvli	x0, %[avl], e8, m1, ta, ma\n"
> +		: :
> +		[avl]"r"(16)
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
> +		asm volatile (
> +			"vle8.v		v0, (%[px])\n"
> +			"vle8.v		v1, (%[dp])\n"
> +			"vxor.vv	v0, v0, v1\n"
> +			"vle8.v		v2, (%[qx])\n"
> +			"vle8.v		v3, (%[dq])\n"
> +			"vxor.vv	v4, v2, v3\n"
> +			"vsrl.vi	v5, v4, 4\n"
> +			"vand.vi	v4, v4, 0xf\n"
> +			"vle8.v		v6, (%[qm0])\n"
> +			"vle8.v		v7, (%[qm1])\n"
> +			"vrgather.vv	v14, v6, v4\n" /* v14 = qm[vx] */
> +			"vrgather.vv	v15, v7, v5\n" /* v15 = qm[vy] */
> +			"vxor.vv	v2, v14, v15\n" /* v2 = qmul[*q ^ *dq] */
> +
> +			"vsrl.vi	v5, v0, 4\n"
> +			"vand.vi	v4, v0, 0xf\n"
> +			"vle8.v		v8, (%[pm0])\n"
> +			"vle8.v		v9, (%[pm1])\n"
> +			"vrgather.vv	v14, v8, v4\n" /* v14 = pm[vx] */
> +			"vrgather.vv	v15, v9, v5\n" /* v15 = pm[vy] */
> +			"vxor.vv	v4, v14, v15\n" /* v4 = pbmul[px] */
> +			"vxor.vv	v3, v4, v2\n" /* v3 = db = pbmul[px] ^ qx */
> +			"vxor.vv	v1, v3, v0\n" /* v1 = db ^ px; */
> +			"vse8.v		v3, (%[dq])\n"
> +			"vse8.v		v1, (%[dp])\n"
> +			: :
> +			[px]"r"(p),
> +			[dp]"r"(dp),
> +			[qx]"r"(q),
> +			[dq]"r"(dq),
> +			[qm0]"r"(qmul),
> +			[qm1]"r"(qmul + 16),
> +			[pm0]"r"(pbmul),
> +			[pm1]"r"(pbmul + 16)
> +			:);
> +
> +		bytes -= 16;
> +		p += 16;
> +		q += 16;
> +		dp += 16;
> +		dq += 16;
> +	}
> +
> +	asm volatile (".option pop\n");
> +}
> +
> +static void __raid6_datap_recov_rvv(int bytes, uint8_t *p, uint8_t *q, uint8_t *dq,
> +			      const uint8_t *qmul)
> +{
> +	asm volatile (
> +		".option	push\n"
> +		".option	arch,+v\n"
> +		"vsetvli	x0, %[avl], e8, m1, ta, ma\n"
> +		: :
> +		[avl]"r"(16)
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
> +		asm volatile (
> +			"vle8.v		v0, (%[vx])\n"
> +			"vle8.v		v2, (%[dq])\n"
> +			"vxor.vv	v0, v0, v2\n"
> +			"vsrl.vi	v1, v0, 4\n"
> +			"vand.vi	v0, v0, 0xf\n"
> +			"vle8.v		v4, (%[qm0])\n"
> +			"vle8.v		v5, (%[qm1])\n"
> +			"vrgather.vv	v10, v4, v0\n"
> +			"vrgather.vv	v11, v5, v1\n"
> +			"vxor.vv	v0, v10, v11\n"
> +			"vle8.v		v1, (%[vy])\n"
> +			"vxor.vv	v1, v0, v1\n"
> +			"vse8.v		v0, (%[dq])\n"
> +			"vse8.v		v1, (%[vy])\n"
> +			: :
> +			[vx]"r"(q),
> +			[vy]"r"(p),
> +			[dq]"r"(dq),
> +			[qm0]"r"(qmul),
> +			[qm1]"r"(qmul + 16)
> +			:);
> +
> +		bytes -= 16;
> +		p += 16;
> +		q += 16;
> +		dq += 16;
> +	}
> +
> +	asm volatile (".option pop\n");
> +}
> +
> +
> +static void raid6_2data_recov_rvv(int disks, size_t bytes, int faila,
> +		int failb, void **ptrs)
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
> +	pbmul = raid6_vgfmul[raid6_gfexi[failb-faila]];
> +	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila] ^
> +					 raid6_gfexp[failb]]];
> +
> +	if (crypto_simd_usable()) {

There should be an alternate recovery mechanism if it's not currently
usable right? I don't know what case could happen when this function is
called but crypto_simd_usable() returns false.

> +		kernel_vector_begin();
> +		__raid6_2data_recov_rvv(bytes, p, q, dp, dq, pbmul, qmul);
> +		kernel_vector_end();
> +	}
> +}
> +
> +static void raid6_datap_recov_rvv(int disks, size_t bytes, int faila,
> +		void **ptrs)
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
> +	if (crypto_simd_usable()) {

Same here

> +		kernel_vector_begin();
> +		__raid6_datap_recov_rvv(bytes, p, q, dq, qmul);
> +		kernel_vector_end();
> +	}
> +}
> +
> +const struct raid6_recov_calls raid6_recov_rvv = {
> +	.data2		= raid6_2data_recov_rvv,
> +	.datap		= raid6_datap_recov_rvv,
> +	.valid		= NULL,

These functions should only be called if vector is enabled, so this
valid bit should call has_vector(). has_vector() returns a bool and
valid expects an int so you can wrap it in something like:

static int check_vector(void)
{
	return has_vector();
}

Just casting has_vector to int (*)(void) doesn't work, I get:

warning: cast between incompatible function types from ‘bool (*)(void)’ {aka ‘_Bool (*)(void)’} to ‘int (*)(void)’ [-Wcast-function-type]


> +	.name		= "rvv",
> +	.priority	= 1,
> +};
> diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
> new file mode 100644
> index 000000000000..21f5432506da
> --- /dev/null
> +++ b/lib/raid6/rvv.c
> @@ -0,0 +1,715 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * RAID-6 syndrome calculation using RISCV vector instructions
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
> +
> +#define NSIZE	(riscv_v_vsize / 32) /* NSIZE = vlenb */
> +
> +static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	int d, z, z0;
> +	u8 *p, *q;
> +
> +	z0 = disks - 3;		/* Highest data disk */
> +	p = dptr[z0+1];		/* XOR parity */
> +	q = dptr[z0+2];		/* RS syndrome */
> +
> +	asm volatile (
> +		".option	push\n"
> +		".option	arch,+v\n"
> +		"vsetvli	t0, x0, e8, m1, ta, ma\n"
> +	);
> +
> +	 /* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
> +	for (d = 0 ; d < bytes ; d += NSIZE*1) {
> +		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (
> +			"vle8.v	v0, (%[wp0])\n"
> +			"vle8.v	v1, (%[wp0])\n"
> +			: :
> +			[wp0]"r"(&dptr[z0][d+0*NSIZE])
> +		);
> +
> +		for (z = z0-1 ; z >= 0 ; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * w1$$ ^= w2$$;
> +			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
> +			 * wq$$ = w1$$ ^ wd$$;
> +			 * wp$$ ^= wd$$;
> +			 */
> +			asm volatile (
> +				"vsra.vi	v2, v1, 7\n"
> +				"vsll.vi	v3, v1, 1\n"
> +				"vand.vx	v2, v2, %[x1d]\n"
> +				"vxor.vv	v3, v3, v2\n"
> +				"vle8.v		v2, (%[wd0])\n"
> +				"vxor.vv	v1, v3, v2\n"
> +				"vxor.vv	v0, v0, v2\n"
> +				: :
> +				[wd0]"r"(&dptr[z][d+0*NSIZE]),
> +				[x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/*
> +		 * *(unative_t *)&p[d+NSIZE*$$] = wp$$;
> +		 * *(unative_t *)&q[d+NSIZE*$$] = wq$$;
> +		 */
> +		asm volatile (
> +			"vse8.v		v0, (%[wp0])\n"
> +			"vse8.v		v1, (%[wq0])\n"
> +			: :
> +			[wp0]"r"(&p[d+NSIZE*0]),
> +			[wq0]"r"(&q[d+NSIZE*0])
> +		);
> +	}
> +
> +	asm volatile (".option pop\n");
> +}
> +
> +static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
> +				    unsigned long bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	u8 *p, *q;
> +	int d, z, z0;
> +
> +	z0 = stop;		/* P/Q right side optimization */
> +	p = dptr[disks-2];	/* XOR parity */
> +	q = dptr[disks-1];	/* RS syndrome */
> +
> +	asm volatile (
> +		".option push\n"
> +		".option arch,+v\n"
> +		"vsetvli	t0, x0, e8, m1, ta, ma\n"
> +	);
> +
> +	/* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
> +	for (d = 0 ; d < bytes ; d += NSIZE*1) {
> +		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (
> +			"vle8.v	v0, (%[wp0])\n"
> +			"vle8.v	v1, (%[wp0])\n"
> +			: :
> +			[wp0]"r"(&dptr[z0][d+0*NSIZE])
> +		);
> +
> +		/* P/Q data pages */
> +		for (z = z0-1 ; z >= start ; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * w1$$ ^= w2$$;
> +			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
> +			 * wq$$ = w1$$ ^ wd$$;
> +			 * wp$$ ^= wd$$;
> +			 */
> +			asm volatile (
> +				"vsra.vi	v2, v1, 7\n"
> +				"vsll.vi	v3, v1, 1\n"
> +				"vand.vx	v2, v2, %[x1d]\n"
> +				"vxor.vv	v3, v3, v2\n"
> +				"vle8.v		v2, (%[wd0])\n"
> +				"vxor.vv	v1, v3, v2\n"
> +				"vxor.vv	v0, v0, v2\n"
> +				: :
> +				[wd0]"r"(&dptr[z][d+0*NSIZE]),
> +				[x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/* P/Q left side optimization */
> +		for (z = start-1 ; z >= 0 ; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * wq$$ = w1$$ ^ w2$$;
> +			 */
> +			asm volatile (
> +				"vsra.vi	v2, v1, 7\n"
> +				"vsll.vi	v3, v1, 1\n"
> +				"vand.vx	v2, v2, %[x1d]\n"
> +				"vxor.vv	v1, v3, v2\n"
> +				: :
> +				[x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/*
> +		 * *(unative_t *)&p[d+NSIZE*$$] ^= wp$$;
> +		 * *(unative_t *)&q[d+NSIZE*$$] ^= wq$$;
> +		 * v0:wp0, v1:wq0, v2:p0, v3:q0
> +		 */
> +		asm volatile (
> +			"vle8.v		v2, (%[wp0])\n"
> +			"vle8.v		v3, (%[wq0])\n"
> +			"vxor.vv	v2, v2, v0\n"
> +			"vxor.vv	v3, v3, v1\n"
> +			"vse8.v		v2, (%[wp0])\n"
> +			"vse8.v		v3, (%[wq0])\n"
> +			: :
> +			[wp0]"r"(&p[d+NSIZE*0]),
> +			[wq0]"r"(&q[d+NSIZE*0])
> +		);
> +	}
> +
> +	asm volatile (".option pop\n");
> +}
> +
> +static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	int d, z, z0;
> +	u8 *p, *q;
> +
> +	z0 = disks - 3;		/* Highest data disk */
> +	p = dptr[z0+1];		/* XOR parity */
> +	q = dptr[z0+2];		/* RS syndrome */
> +
> +	asm volatile (
> +		".option	push\n"
> +		".option	arch,+v\n"
> +		"vsetvli	t0, x0, e8, m1, ta, ma\n"
> +	);
> +
> +	/*
> +	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
> +	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
> +	 */
> +	for (d = 0 ; d < bytes ; d += NSIZE*2) {
> +		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (
> +			"vle8.v	v0, (%[wp0])\n"
> +			"vle8.v	v1, (%[wp0])\n"
> +			"vle8.v	v4, (%[wp1])\n"
> +			"vle8.v	v5, (%[wp1])\n"
> +			: :
> +			[wp0]"r"(&dptr[z0][d+0*NSIZE]),
> +			[wp1]"r"(&dptr[z0][d+1*NSIZE])
> +		);
> +
> +		for (z = z0-1 ; z >= 0 ; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * w1$$ ^= w2$$;
> +			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
> +			 * wq$$ = w1$$ ^ wd$$;
> +			 * wp$$ ^= wd$$;
> +			 */
> +			asm volatile (
> +				"vsra.vi	v2, v1, 7\n"
> +				"vsll.vi	v3, v1, 1\n"
> +				"vand.vx	v2, v2, %[x1d]\n"
> +				"vxor.vv	v3, v3, v2\n"
> +				"vle8.v		v2, (%[wd0])\n"
> +				"vxor.vv	v1, v3, v2\n"
> +				"vxor.vv	v0, v0, v2\n"
> +
> +				"vsra.vi	v6, v5, 7\n"
> +				"vsll.vi	v7, v5, 1\n"
> +				"vand.vx	v6, v6, %[x1d]\n"
> +				"vxor.vv	v7, v7, v6\n"
> +				"vle8.v		v6, (%[wd1])\n"
> +				"vxor.vv	v5, v7, v6\n"
> +				"vxor.vv	v4, v4, v6\n"
> +				: :
> +				[wd0]"r"(&dptr[z][d+0*NSIZE]),
> +				[wd1]"r"(&dptr[z][d+1*NSIZE]),
> +				[x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/*
> +		 * *(unative_t *)&p[d+NSIZE*$$] = wp$$;
> +		 * *(unative_t *)&q[d+NSIZE*$$] = wq$$;
> +		 */
> +		asm volatile (
> +			"vse8.v		v0, (%[wp0])\n"
> +			"vse8.v		v1, (%[wq0])\n"
> +			"vse8.v		v4, (%[wp1])\n"
> +			"vse8.v		v5, (%[wq1])\n"
> +			: :
> +			[wp0]"r"(&p[d+NSIZE*0]),
> +			[wq0]"r"(&q[d+NSIZE*0]),
> +			[wp1]"r"(&p[d+NSIZE*1]),
> +			[wq1]"r"(&q[d+NSIZE*1])
> +		);
> +	}
> +
> +	asm volatile (".option pop\n");
> +}
> +
> +static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
> +					 unsigned long bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	u8 *p, *q;
> +	int d, z, z0;
> +
> +	z0 = stop;		/* P/Q right side optimization */
> +	p = dptr[disks-2];	/* XOR parity */
> +	q = dptr[disks-1];	/* RS syndrome */
> +
> +	asm volatile (
> +		".option push\n"
> +		".option arch,+v\n"
> +		"vsetvli	t0, x0, e8, m1, ta, ma\n"
> +	);
> +
> +	/*
> +	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
> +	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
> +	 */
> +	for (d = 0 ; d < bytes ; d += NSIZE*2) {
> +		 /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (
> +			"vle8.v	v0, (%[wp0])\n"
> +			"vle8.v	v1, (%[wp0])\n"
> +			"vle8.v	v4, (%[wp1])\n"
> +			"vle8.v	v5, (%[wp1])\n"
> +			: :
> +			[wp0]"r"(&dptr[z0][d+0*NSIZE]),
> +			[wp1]"r"(&dptr[z0][d+1*NSIZE])
> +		);
> +
> +		/* P/Q data pages */
> +		for (z = z0-1 ; z >= start ; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * w1$$ ^= w2$$;
> +			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
> +			 * wq$$ = w1$$ ^ wd$$;
> +			 * wp$$ ^= wd$$;
> +			 */
> +			asm volatile (
> +				"vsra.vi	v2, v1, 7\n"
> +				"vsll.vi	v3, v1, 1\n"
> +				"vand.vx	v2, v2, %[x1d]\n"
> +				"vxor.vv	v3, v3, v2\n"
> +				"vle8.v		v2, (%[wd0])\n"
> +				"vxor.vv	v1, v3, v2\n"
> +				"vxor.vv	v0, v0, v2\n"
> +
> +				"vsra.vi	v6, v5, 7\n"
> +				"vsll.vi	v7, v5, 1\n"
> +				"vand.vx	v6, v6, %[x1d]\n"
> +				"vxor.vv	v7, v7, v6\n"
> +				"vle8.v		v6, (%[wd1])\n"
> +				"vxor.vv	v5, v7, v6\n"
> +				"vxor.vv	v4, v4, v6\n"
> +				: :
> +				[wd0]"r"(&dptr[z][d+0*NSIZE]),
> +				[wd1]"r"(&dptr[z][d+1*NSIZE]),
> +				[x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/* P/Q left side optimization */
> +		for (z = start-1 ; z >= 0 ; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * wq$$ = w1$$ ^ w2$$;
> +			 */
> +			asm volatile (
> +				"vsra.vi	v2, v1, 7\n"
> +				"vsll.vi	v3, v1, 1\n"
> +				"vand.vx	v2, v2, %[x1d]\n"
> +				"vxor.vv	v1, v3, v2\n"
> +
> +				"vsra.vi	v6, v5, 7\n"
> +				"vsll.vi	v7, v5, 1\n"
> +				"vand.vx	v6, v6, %[x1d]\n"
> +				"vxor.vv	v5, v7, v6\n"
> +				: :
> +				[x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/*
> +		 * *(unative_t *)&p[d+NSIZE*$$] ^= wp$$;
> +		 * *(unative_t *)&q[d+NSIZE*$$] ^= wq$$;
> +		 * v0:wp0, v1:wq0, v2:p0, v3:q0
> +		 * v4:wp1, v5:wq1, v6:p1, v7:q1
> +		 */
> +		asm volatile (
> +			"vle8.v		v2, (%[wp0])\n"
> +			"vle8.v		v3, (%[wq0])\n"
> +			"vxor.vv	v2, v2, v0\n"
> +			"vxor.vv	v3, v3, v1\n"
> +			"vse8.v		v2, (%[wp0])\n"
> +			"vse8.v		v3, (%[wq0])\n"
> +
> +			"vle8.v		v6, (%[wp1])\n"
> +			"vle8.v		v7, (%[wq1])\n"
> +			"vxor.vv	v6, v6, v4\n"
> +			"vxor.vv	v7, v7, v5\n"
> +			"vse8.v		v6, (%[wp1])\n"
> +			"vse8.v		v7, (%[wq1])\n"
> +			: :
> +			[wp0]"r"(&p[d+NSIZE*0]),
> +			[wq0]"r"(&q[d+NSIZE*0]),
> +			[wp1]"r"(&p[d+NSIZE*1]),
> +			[wq1]"r"(&q[d+NSIZE*1])
> +		);
> +	}
> +
> +	asm volatile (".option pop\n");
> +}
> +
> +static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	int d, z, z0;
> +	u8 *p, *q;
> +
> +	z0 = disks - 3;	/* Highest data disk */
> +	p = dptr[z0+1];	/* XOR parity */
> +	q = dptr[z0+2];	/* RS syndrome */
> +
> +	asm volatile (
> +		".option	push\n"
> +		".option	arch,+v\n"
> +		"vsetvli	t0, x0, e8, m1, ta, ma\n"
> +	);
> +
> +	/*
> +	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
> +	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
> +	 * v8:wp2, v9:wq2, v10:wd2/w22, v11:w12
> +	 * v12:wp3, v13:wq3, v14:wd3/w23, v15:w13
> +	 */
> +	for (d = 0 ; d < bytes ; d += NSIZE*4) {
> +		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (
> +			"vle8.v v0, (%[wp0])\n"
> +			"vle8.v v1, (%[wp0])\n"
> +			"vle8.v v4, (%[wp1])\n"
> +			"vle8.v v5, (%[wp1])\n"
> +			"vle8.v v8, (%[wp2])\n"
> +			"vle8.v v9, (%[wp2])\n"
> +			"vle8.v v12, (%[wp3])\n"
> +			"vle8.v v13, (%[wp3])\n"
> +			: :
> +			[wp0]"r"(&dptr[z0][d+0*NSIZE]),
> +			[wp1]"r"(&dptr[z0][d+1*NSIZE]),
> +			[wp2]"r"(&dptr[z0][d+2*NSIZE]),
> +			[wp3]"r"(&dptr[z0][d+3*NSIZE])
> +		);
> +
> +		for (z = z0-1 ; z >= 0 ; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * w1$$ ^= w2$$;
> +			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
> +			 * wq$$ = w1$$ ^ wd$$;
> +			 * wp$$ ^= wd$$;
> +			 */
> +			asm volatile (
> +				"vsra.vi	v2, v1, 7\n"
> +				"vsll.vi	v3, v1, 1\n"
> +				"vand.vx	v2, v2, %[x1d]\n"
> +				"vxor.vv	v3, v3, v2\n"
> +				"vle8.v		v2, (%[wd0])\n"
> +				"vxor.vv	v1, v3, v2\n"
> +				"vxor.vv	v0, v0, v2\n"
> +
> +				"vsra.vi	v6, v5, 7\n"
> +				"vsll.vi	v7, v5, 1\n"
> +				"vand.vx	v6, v6, %[x1d]\n"
> +				"vxor.vv	v7, v7, v6\n"
> +				"vle8.v		v6, (%[wd1])\n"
> +				"vxor.vv	v5, v7, v6\n"
> +				"vxor.vv	v4, v4, v6\n"
> +
> +				"vsra.vi	v10, v9, 7\n"
> +				"vsll.vi	v11, v9, 1\n"
> +				"vand.vx	v10, v10, %[x1d]\n"
> +				"vxor.vv	v11, v11, v10\n"
> +				"vle8.v		v10, (%[wd2])\n"
> +				"vxor.vv	v9, v11, v10\n"
> +				"vxor.vv	v8, v8, v10\n"
> +
> +				"vsra.vi	v14, v13, 7\n"
> +				"vsll.vi	v15, v13, 1\n"
> +				"vand.vx	v14, v14, %[x1d]\n"
> +				"vxor.vv	v15, v15, v14\n"
> +				"vle8.v		v14, (%[wd3])\n"
> +				"vxor.vv	v13, v15, v14\n"
> +				"vxor.vv	v12, v12, v14\n"
> +				: :
> +				[wd0]"r"(&dptr[z][d+0*NSIZE]),
> +				[wd1]"r"(&dptr[z][d+1*NSIZE]),
> +				[wd2]"r"(&dptr[z][d+2*NSIZE]),
> +				[wd3]"r"(&dptr[z][d+3*NSIZE]),
> +				[x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/*
> +		 * *(unative_t *)&p[d+NSIZE*$$] = wp$$;
> +		 * *(unative_t *)&q[d+NSIZE*$$] = wq$$;
> +		 */
> +		asm volatile (
> +			"vse8.v	v0, (%[wp0])\n"
> +			"vse8.v	v1, (%[wq0])\n"
> +			"vse8.v	v4, (%[wp1])\n"
> +			"vse8.v	v5, (%[wq1])\n"
> +			"vse8.v	v8, (%[wp2])\n"
> +			"vse8.v	v9, (%[wq2])\n"
> +			"vse8.v	v12, (%[wp3])\n"
> +			"vse8.v	v13, (%[wq3])\n"
> +			: :
> +			[wp0]"r"(&p[d+NSIZE*0]),
> +			[wq0]"r"(&q[d+NSIZE*0]),
> +			[wp1]"r"(&p[d+NSIZE*1]),
> +			[wq1]"r"(&q[d+NSIZE*1]),
> +			[wp2]"r"(&p[d+NSIZE*2]),
> +			[wq2]"r"(&q[d+NSIZE*2]),
> +			[wp3]"r"(&p[d+NSIZE*3]),
> +			[wq3]"r"(&q[d+NSIZE*3])
> +		);
> +	}
> +
> +	asm volatile (".option pop\n");
> +}
> +
> +static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
> +					unsigned long bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	u8 *p, *q;
> +	int d, z, z0;
> +
> +	z0 = stop;		/* P/Q right side optimization */
> +	p = dptr[disks-2];	/* XOR parity */
> +	q = dptr[disks-1];	/* RS syndrome */
> +
> +	asm volatile (
> +		".option push\n"
> +		".option arch,+v\n"
> +		"vsetvli	t0, x0, e8, m1, ta, ma\n"
> +	);
> +
> +	/*
> +	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
> +	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
> +	 * v8:wp2, v9:wq2, v10:wd2/w22, v11:w12
> +	 * v12:wp3, v13:wq3, v14:wd3/w23, v15:w13
> +	 */
> +	for (d = 0 ; d < bytes ; d += NSIZE*4) {
> +		 /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (
> +			"vle8.v v0, (%[wp0])\n"
> +			"vle8.v v1, (%[wp0])\n"
> +			"vle8.v v4, (%[wp1])\n"
> +			"vle8.v v5, (%[wp1])\n"
> +			"vle8.v v8, (%[wp2])\n"
> +			"vle8.v v9, (%[wp2])\n"
> +			"vle8.v v12, (%[wp3])\n"
> +			"vle8.v v13, (%[wp3])\n"
> +			: :
> +			[wp0]"r"(&dptr[z0][d+0*NSIZE]),
> +			[wp1]"r"(&dptr[z0][d+1*NSIZE]),
> +			[wp2]"r"(&dptr[z0][d+2*NSIZE]),
> +			[wp3]"r"(&dptr[z0][d+3*NSIZE])
> +		);
> +
> +		/* P/Q data pages */
> +		for (z = z0-1 ; z >= start ; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * w1$$ ^= w2$$;
> +			 * wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
> +			 * wq$$ = w1$$ ^ wd$$;
> +			 * wp$$ ^= wd$$;
> +			 */
> +			asm volatile (
> +				"vsra.vi	v2, v1, 7\n"
> +				"vsll.vi	v3, v1, 1\n"
> +				"vand.vx	v2, v2, %[x1d]\n"
> +				"vxor.vv	v3, v3, v2\n"
> +				"vle8.v		v2, (%[wd0])\n"
> +				"vxor.vv	v1, v3, v2\n"
> +				"vxor.vv	v0, v0, v2\n"
> +
> +				"vsra.vi	v6, v5, 7\n"
> +				"vsll.vi	v7, v5, 1\n"
> +				"vand.vx	v6, v6, %[x1d]\n"
> +				"vxor.vv	v7, v7, v6\n"
> +				"vle8.v		v6, (%[wd1])\n"
> +				"vxor.vv	v5, v7, v6\n"
> +				"vxor.vv	v4, v4, v6\n"
> +
> +				"vsra.vi	v10, v9, 7\n"
> +				"vsll.vi	v11, v9, 1\n"
> +				"vand.vx	v10, v10, %[x1d]\n"
> +				"vxor.vv	v11, v11, v10\n"
> +				"vle8.v		v10, (%[wd2])\n"
> +				"vxor.vv	v9, v11, v10\n"
> +				"vxor.vv	v8, v8, v10\n"
> +
> +				"vsra.vi	v14, v13, 7\n"
> +				"vsll.vi	v15, v13, 1\n"
> +				"vand.vx	v14, v14, %[x1d]\n"
> +				"vxor.vv	v15, v15, v14\n"
> +				"vle8.v		v14, (%[wd3])\n"
> +				"vxor.vv	v13, v15, v14\n"
> +				"vxor.vv	v12, v12, v14\n"
> +				: :
> +				[wd0]"r"(&dptr[z][d+0*NSIZE]),
> +				[wd1]"r"(&dptr[z][d+1*NSIZE]),
> +				[wd2]"r"(&dptr[z][d+2*NSIZE]),
> +				[wd3]"r"(&dptr[z][d+3*NSIZE]),
> +				[x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/* P/Q left side optimization */
> +		for (z = start-1 ; z >= 0 ; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * wq$$ = w1$$ ^ w2$$;
> +			 */
> +			asm volatile (
> +				"vsra.vi	v2, v1, 7\n"
> +				"vsll.vi	v3, v1, 1\n"
> +				"vand.vx	v2, v2, %[x1d]\n"
> +				"vxor.vv	v1, v3, v2\n"
> +
> +				"vsra.vi	v6, v5, 7\n"
> +				"vsll.vi	v7, v5, 1\n"
> +				"vand.vx	v6, v6, %[x1d]\n"
> +				"vxor.vv	v5, v7, v6\n"
> +
> +				"vsra.vi	v10, v9, 7\n"
> +				"vsll.vi	v11, v9, 1\n"
> +				"vand.vx	v10, v10, %[x1d]\n"
> +				"vxor.vv	v9, v11, v10\n"
> +
> +				"vsra.vi	v14, v13, 7\n"
> +				"vsll.vi	v15, v13, 1\n"
> +				"vand.vx	v14, v14, %[x1d]\n"
> +				"vxor.vv	v13, v15, v14\n"
> +				: :
> +				[x1d]"r"(0x1d)
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
> +		asm volatile (
> +			"vle8.v		v2, (%[wp0])\n"
> +			"vle8.v		v3, (%[wq0])\n"
> +			"vxor.vv	v2, v2, v0\n"
> +			"vxor.vv	v3, v3, v1\n"
> +			"vse8.v		v2, (%[wp0])\n"
> +			"vse8.v		v3, (%[wq0])\n"
> +
> +			"vle8.v		v6, (%[wp1])\n"
> +			"vle8.v		v7, (%[wq1])\n"
> +			"vxor.vv	v6, v6, v4\n"
> +			"vxor.vv	v7, v7, v5\n"
> +			"vse8.v		v6, (%[wp1])\n"
> +			"vse8.v		v7, (%[wq1])\n"
> +
> +			"vle8.v		v10, (%[wp2])\n"
> +			"vle8.v		v11, (%[wq2])\n"
> +			"vxor.vv	v10, v10, v8\n"
> +			"vxor.vv	v11, v11, v9\n"
> +			"vse8.v		v10, (%[wp2])\n"
> +			"vse8.v		v11, (%[wq2])\n"
> +
> +			"vle8.v		v14, (%[wp3])\n"
> +			"vle8.v		v15, (%[wq3])\n"
> +			"vxor.vv	v14, v14, v12\n"
> +			"vxor.vv	v15, v15, v13\n"
> +			"vse8.v		v14, (%[wp3])\n"
> +			"vse8.v		v15, (%[wq3])\n"
> +			: :
> +			[wp0]"r"(&p[d+NSIZE*0]),
> +			[wq0]"r"(&q[d+NSIZE*0]),
> +			[wp1]"r"(&p[d+NSIZE*1]),
> +			[wq1]"r"(&q[d+NSIZE*1]),
> +			[wp2]"r"(&p[d+NSIZE*2]),
> +			[wq2]"r"(&q[d+NSIZE*2]),
> +			[wp3]"r"(&p[d+NSIZE*3]),
> +			[wq3]"r"(&q[d+NSIZE*3])
> +		);
> +	}
> +
> +	asm volatile (".option pop\n");
> +}
> +
> +#define RAID6_RVV_WRAPPER(_n)						\
> +	static void raid6_rvv ## _n ## _gen_syndrome(int disks,		\
> +					size_t bytes, void **ptrs)	\
> +	{								\
> +		void raid6_rvv ## _n  ## _gen_syndrome_real(int,	\
> +						unsigned long, void**);	\
> +		if (crypto_simd_usable()) {				\

Same note about crypto_simd_usable as above

> +			kernel_vector_begin();				\
> +			raid6_rvv ## _n ## _gen_syndrome_real(disks,	\
> +					(unsigned long)bytes, ptrs);	\
> +			kernel_vector_end();				\
> +		}							\
> +	}								\
> +	static void raid6_rvv ## _n ## _xor_syndrome(int disks,		\
> +					int start, int stop,		\
> +					size_t bytes, void **ptrs)	\
> +	{								\
> +		void raid6_rvv ## _n  ## _xor_syndrome_real(int,	\
> +				int, int, unsigned long, void**);	\
> +		if (crypto_simd_usable()) {				\

... and here

> +			kernel_vector_begin();				\
> +		raid6_rvv ## _n ## _xor_syndrome_real(disks,		\
> +			start, stop, (unsigned long)bytes, ptrs);	\
> +			kernel_vector_end();				\
> +		}							\
> +	}								\
> +	struct raid6_calls const raid6_rvvx ## _n = {			\
> +		raid6_rvv ## _n ## _gen_syndrome,			\
> +		raid6_rvv ## _n ## _xor_syndrome,			\
> +		NULL,							\

Same note about calling has_vector here.

> +		"rvvx" #_n,						\
> +		0							\
> +	}
> +
> +RAID6_RVV_WRAPPER(1);
> +RAID6_RVV_WRAPPER(2);
> +RAID6_RVV_WRAPPER(4);
> -- 
> 2.34.1
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

Some interesting results, on QEMU (vlen=256) these vectorized versions
are around 6x faster on my CPU. Vector in QEMU is not optimized so I am
surprised that there is this much speedup.

# modprobe raid6_pq
[   36.238377] raid6: rvvx1    gen()  2668 MB/s
[   36.306381] raid6: rvvx2    gen()  3097 MB/s
[   36.374376] raid6: rvvx4    gen()  3366 MB/s
[   36.442385] raid6: int64x8  gen()   548 MB/s
[   36.510397] raid6: int64x4  gen()   600 MB/s
[   36.578388] raid6: int64x2  gen()   585 MB/s
[   36.646384] raid6: int64x1  gen()   518 MB/s
[   36.646395] raid6: using algorithm rvvx4 gen() 3366 MB/s
[   36.714377] raid6: .... xor() 1942 MB/s, rmw enabled
[   36.714387] raid6: using rvv recovery algorithm

I also ran the raid6tests:

raid6test: complete (2429 tests, 0 failures)

I am not familiar with this algorithm, but since it passed all of the
test cases and shows a remarkable speedup, this patch seems like a great
improvement.

As Jessica pointed out, please put the vector pop/push in the same block
as your vector instructions. While testing this code, I threw together a
patch for this that you can squash:

From 32117c0a5b2bbba7439af37e55631e0e38b63a7c Mon Sep 17 00:00:00 2001
From: Charlie Jenkins <charlie@rivosinc.com>
Date: Wed, 8 Jan 2025 14:32:26 -0800
Subject: [PATCH] Fixup vector options

Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
---
 lib/raid6/Makefile    |  2 --
 lib/raid6/recov_rvv.c | 12 ++++---
 lib/raid6/rvv.c       | 81 ++++++++++++++++++++++++++++++++++++-------
 3 files changed, 77 insertions(+), 18 deletions(-)

diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
index e62fb7cd773e..5be0a4e60ab1 100644
--- a/lib/raid6/Makefile
+++ b/lib/raid6/Makefile
@@ -11,8 +11,6 @@ raid6_pq-$(CONFIG_KERNEL_MODE_NEON) += neon.o neon1.o neon2.o neon4.o neon8.o re
 raid6_pq-$(CONFIG_S390) += s390vx8.o recov_s390xc.o
 raid6_pq-$(CONFIG_LOONGARCH) += loongarch_simd.o recov_loongarch_simd.o
 raid6_pq-$(CONFIG_RISCV_ISA_V) += rvv.o recov_rvv.o
-CFLAGS_rvv.o += -march=rv64gcv
-CFLAGS_recov_rvv.o += -march=rv64gcv
 
 hostprogs	+= mktables
 
diff --git a/lib/raid6/recov_rvv.c b/lib/raid6/recov_rvv.c
index 8ae74803ea7f..02b97d885510 100644
--- a/lib/raid6/recov_rvv.c
+++ b/lib/raid6/recov_rvv.c
@@ -17,6 +17,7 @@ static void __raid6_2data_recov_rvv(int bytes, u8 *p, u8 *q, u8 *dp,
 		".option	push\n"
 		".option	arch,+v\n"
 		"vsetvli	x0, %[avl], e8, m1, ta, ma\n"
+		".option	pop\n"
 		: :
 		[avl]"r"(16)
 	);
@@ -42,6 +43,8 @@ static void __raid6_2data_recov_rvv(int bytes, u8 *p, u8 *q, u8 *dp,
 		 * v14:p/qm[vx], v15:p/qm[vy]
 		 */
 		asm volatile (
+			".option	push\n"
+			".option	arch,+v\n"
 			"vle8.v		v0, (%[px])\n"
 			"vle8.v		v1, (%[dp])\n"
 			"vxor.vv	v0, v0, v1\n"
@@ -67,6 +70,7 @@ static void __raid6_2data_recov_rvv(int bytes, u8 *p, u8 *q, u8 *dp,
 			"vxor.vv	v1, v3, v0\n" /* v1 = db ^ px; */
 			"vse8.v		v3, (%[dq])\n"
 			"vse8.v		v1, (%[dp])\n"
+			".option	pop\n"
 			: :
 			[px]"r"(p),
 			[dp]"r"(dp),
@@ -84,8 +88,6 @@ static void __raid6_2data_recov_rvv(int bytes, u8 *p, u8 *q, u8 *dp,
 		dp += 16;
 		dq += 16;
 	}
-
-	asm volatile (".option pop\n");
 }
 
 static void __raid6_datap_recov_rvv(int bytes, uint8_t *p, uint8_t *q, uint8_t *dq,
@@ -95,6 +97,7 @@ static void __raid6_datap_recov_rvv(int bytes, uint8_t *p, uint8_t *q, uint8_t *
 		".option	push\n"
 		".option	arch,+v\n"
 		"vsetvli	x0, %[avl], e8, m1, ta, ma\n"
+		".option	pop\n"
 		: :
 		[avl]"r"(16)
 	);
@@ -113,6 +116,8 @@ static void __raid6_datap_recov_rvv(int bytes, uint8_t *p, uint8_t *q, uint8_t *
 		 * v10:m[vx], v11:m[vy]
 		 */
 		asm volatile (
+			".option	push\n"
+			".option	arch,+v\n"
 			"vle8.v		v0, (%[vx])\n"
 			"vle8.v		v2, (%[dq])\n"
 			"vxor.vv	v0, v0, v2\n"
@@ -127,6 +132,7 @@ static void __raid6_datap_recov_rvv(int bytes, uint8_t *p, uint8_t *q, uint8_t *
 			"vxor.vv	v1, v0, v1\n"
 			"vse8.v		v0, (%[dq])\n"
 			"vse8.v		v1, (%[vy])\n"
+			".option	pop\n"
 			: :
 			[vx]"r"(q),
 			[vy]"r"(p),
@@ -140,8 +146,6 @@ static void __raid6_datap_recov_rvv(int bytes, uint8_t *p, uint8_t *q, uint8_t *
 		q += 16;
 		dq += 16;
 	}
-
-	asm volatile (".option pop\n");
 }
 
 
diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
index 21f5432506da..81b38dcafeb6 100644
--- a/lib/raid6/rvv.c
+++ b/lib/raid6/rvv.c
@@ -31,14 +31,18 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
 		".option	push\n"
 		".option	arch,+v\n"
 		"vsetvli	t0, x0, e8, m1, ta, ma\n"
+		".option	pop\n"
 	);
 
 	 /* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
 	for (d = 0 ; d < bytes ; d += NSIZE*1) {
 		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
 		asm volatile (
+			".option	push\n"
+			".option	arch,+v\n"
 			"vle8.v	v0, (%[wp0])\n"
 			"vle8.v	v1, (%[wp0])\n"
+			".option	pop\n"
 			: :
 			[wp0]"r"(&dptr[z0][d+0*NSIZE])
 		);
@@ -54,6 +58,8 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
 			 * wp$$ ^= wd$$;
 			 */
 			asm volatile (
+				".option	push\n"
+				".option	arch,+v\n"
 				"vsra.vi	v2, v1, 7\n"
 				"vsll.vi	v3, v1, 1\n"
 				"vand.vx	v2, v2, %[x1d]\n"
@@ -61,6 +67,7 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
 				"vle8.v		v2, (%[wd0])\n"
 				"vxor.vv	v1, v3, v2\n"
 				"vxor.vv	v0, v0, v2\n"
+				".option	pop\n"
 				: :
 				[wd0]"r"(&dptr[z][d+0*NSIZE]),
 				[x1d]"r"(0x1d)
@@ -72,15 +79,16 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
 		 * *(unative_t *)&q[d+NSIZE*$$] = wq$$;
 		 */
 		asm volatile (
+			".option	push\n"
+			".option	arch,+v\n"
 			"vse8.v		v0, (%[wp0])\n"
 			"vse8.v		v1, (%[wq0])\n"
+			".option	pop\n"
 			: :
 			[wp0]"r"(&p[d+NSIZE*0]),
 			[wq0]"r"(&q[d+NSIZE*0])
 		);
 	}
-
-	asm volatile (".option pop\n");
 }
 
 static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
@@ -98,14 +106,18 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
 		".option push\n"
 		".option arch,+v\n"
 		"vsetvli	t0, x0, e8, m1, ta, ma\n"
+		".option	pop\n"
 	);
 
 	/* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
 	for (d = 0 ; d < bytes ; d += NSIZE*1) {
 		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
 		asm volatile (
+			".option	push\n"
+			".option	arch,+v\n"
 			"vle8.v	v0, (%[wp0])\n"
 			"vle8.v	v1, (%[wp0])\n"
+			".option	pop\n"
 			: :
 			[wp0]"r"(&dptr[z0][d+0*NSIZE])
 		);
@@ -122,6 +134,8 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
 			 * wp$$ ^= wd$$;
 			 */
 			asm volatile (
+				".option	push\n"
+				".option	arch,+v\n"
 				"vsra.vi	v2, v1, 7\n"
 				"vsll.vi	v3, v1, 1\n"
 				"vand.vx	v2, v2, %[x1d]\n"
@@ -129,6 +143,7 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
 				"vle8.v		v2, (%[wd0])\n"
 				"vxor.vv	v1, v3, v2\n"
 				"vxor.vv	v0, v0, v2\n"
+				".option	pop\n"
 				: :
 				[wd0]"r"(&dptr[z][d+0*NSIZE]),
 				[x1d]"r"(0x1d)
@@ -144,10 +159,13 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
 			 * wq$$ = w1$$ ^ w2$$;
 			 */
 			asm volatile (
+				".option	push\n"
+				".option	arch,+v\n"
 				"vsra.vi	v2, v1, 7\n"
 				"vsll.vi	v3, v1, 1\n"
 				"vand.vx	v2, v2, %[x1d]\n"
 				"vxor.vv	v1, v3, v2\n"
+				".option	pop\n"
 				: :
 				[x1d]"r"(0x1d)
 			);
@@ -159,19 +177,20 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
 		 * v0:wp0, v1:wq0, v2:p0, v3:q0
 		 */
 		asm volatile (
+			".option	push\n"
+			".option	arch,+v\n"
 			"vle8.v		v2, (%[wp0])\n"
 			"vle8.v		v3, (%[wq0])\n"
 			"vxor.vv	v2, v2, v0\n"
 			"vxor.vv	v3, v3, v1\n"
 			"vse8.v		v2, (%[wp0])\n"
 			"vse8.v		v3, (%[wq0])\n"
+			".option	pop\n"
 			: :
 			[wp0]"r"(&p[d+NSIZE*0]),
 			[wq0]"r"(&q[d+NSIZE*0])
 		);
 	}
-
-	asm volatile (".option pop\n");
 }
 
 static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
@@ -188,6 +207,7 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
 		".option	push\n"
 		".option	arch,+v\n"
 		"vsetvli	t0, x0, e8, m1, ta, ma\n"
+		".option	pop\n"
 	);
 
 	/*
@@ -197,10 +217,13 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
 	for (d = 0 ; d < bytes ; d += NSIZE*2) {
 		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
 		asm volatile (
+			".option	push\n"
+			".option	arch,+v\n"
 			"vle8.v	v0, (%[wp0])\n"
 			"vle8.v	v1, (%[wp0])\n"
 			"vle8.v	v4, (%[wp1])\n"
 			"vle8.v	v5, (%[wp1])\n"
+			".option	pop\n"
 			: :
 			[wp0]"r"(&dptr[z0][d+0*NSIZE]),
 			[wp1]"r"(&dptr[z0][d+1*NSIZE])
@@ -217,6 +240,8 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
 			 * wp$$ ^= wd$$;
 			 */
 			asm volatile (
+				".option	push\n"
+				".option	arch,+v\n"
 				"vsra.vi	v2, v1, 7\n"
 				"vsll.vi	v3, v1, 1\n"
 				"vand.vx	v2, v2, %[x1d]\n"
@@ -232,6 +257,7 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
 				"vle8.v		v6, (%[wd1])\n"
 				"vxor.vv	v5, v7, v6\n"
 				"vxor.vv	v4, v4, v6\n"
+				".option	pop\n"
 				: :
 				[wd0]"r"(&dptr[z][d+0*NSIZE]),
 				[wd1]"r"(&dptr[z][d+1*NSIZE]),
@@ -244,10 +270,13 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
 		 * *(unative_t *)&q[d+NSIZE*$$] = wq$$;
 		 */
 		asm volatile (
+			".option	push\n"
+			".option	arch,+v\n"
 			"vse8.v		v0, (%[wp0])\n"
 			"vse8.v		v1, (%[wq0])\n"
 			"vse8.v		v4, (%[wp1])\n"
 			"vse8.v		v5, (%[wq1])\n"
+			".option	pop\n"
 			: :
 			[wp0]"r"(&p[d+NSIZE*0]),
 			[wq0]"r"(&q[d+NSIZE*0]),
@@ -255,8 +284,6 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
 			[wq1]"r"(&q[d+NSIZE*1])
 		);
 	}
-
-	asm volatile (".option pop\n");
 }
 
 static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
@@ -274,6 +301,7 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
 		".option push\n"
 		".option arch,+v\n"
 		"vsetvli	t0, x0, e8, m1, ta, ma\n"
+		".option	pop\n"
 	);
 
 	/*
@@ -283,10 +311,13 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
 	for (d = 0 ; d < bytes ; d += NSIZE*2) {
 		 /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
 		asm volatile (
+			".option	push\n"
+			".option	arch,+v\n"
 			"vle8.v	v0, (%[wp0])\n"
 			"vle8.v	v1, (%[wp0])\n"
 			"vle8.v	v4, (%[wp1])\n"
 			"vle8.v	v5, (%[wp1])\n"
+			".option	pop\n"
 			: :
 			[wp0]"r"(&dptr[z0][d+0*NSIZE]),
 			[wp1]"r"(&dptr[z0][d+1*NSIZE])
@@ -304,6 +335,8 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
 			 * wp$$ ^= wd$$;
 			 */
 			asm volatile (
+				".option push\n"
+				".option arch,+v\n"
 				"vsra.vi	v2, v1, 7\n"
 				"vsll.vi	v3, v1, 1\n"
 				"vand.vx	v2, v2, %[x1d]\n"
@@ -319,6 +352,7 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
 				"vle8.v		v6, (%[wd1])\n"
 				"vxor.vv	v5, v7, v6\n"
 				"vxor.vv	v4, v4, v6\n"
+				".option	pop\n"
 				: :
 				[wd0]"r"(&dptr[z][d+0*NSIZE]),
 				[wd1]"r"(&dptr[z][d+1*NSIZE]),
@@ -335,6 +369,8 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
 			 * wq$$ = w1$$ ^ w2$$;
 			 */
 			asm volatile (
+				".option push\n"
+				".option arch,+v\n"
 				"vsra.vi	v2, v1, 7\n"
 				"vsll.vi	v3, v1, 1\n"
 				"vand.vx	v2, v2, %[x1d]\n"
@@ -344,6 +380,7 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
 				"vsll.vi	v7, v5, 1\n"
 				"vand.vx	v6, v6, %[x1d]\n"
 				"vxor.vv	v5, v7, v6\n"
+				".option	pop\n"
 				: :
 				[x1d]"r"(0x1d)
 			);
@@ -356,6 +393,8 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
 		 * v4:wp1, v5:wq1, v6:p1, v7:q1
 		 */
 		asm volatile (
+			".option push\n"
+			".option arch,+v\n"
 			"vle8.v		v2, (%[wp0])\n"
 			"vle8.v		v3, (%[wq0])\n"
 			"vxor.vv	v2, v2, v0\n"
@@ -369,6 +408,7 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
 			"vxor.vv	v7, v7, v5\n"
 			"vse8.v		v6, (%[wp1])\n"
 			"vse8.v		v7, (%[wq1])\n"
+			".option	pop\n"
 			: :
 			[wp0]"r"(&p[d+NSIZE*0]),
 			[wq0]"r"(&q[d+NSIZE*0]),
@@ -376,8 +416,6 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
 			[wq1]"r"(&q[d+NSIZE*1])
 		);
 	}
-
-	asm volatile (".option pop\n");
 }
 
 static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
@@ -394,6 +432,7 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
 		".option	push\n"
 		".option	arch,+v\n"
 		"vsetvli	t0, x0, e8, m1, ta, ma\n"
+		".option	pop\n"
 	);
 
 	/*
@@ -405,6 +444,8 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
 	for (d = 0 ; d < bytes ; d += NSIZE*4) {
 		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
 		asm volatile (
+			".option push\n"
+			".option arch,+v\n"
 			"vle8.v v0, (%[wp0])\n"
 			"vle8.v v1, (%[wp0])\n"
 			"vle8.v v4, (%[wp1])\n"
@@ -413,6 +454,7 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
 			"vle8.v v9, (%[wp2])\n"
 			"vle8.v v12, (%[wp3])\n"
 			"vle8.v v13, (%[wp3])\n"
+			".option	pop\n"
 			: :
 			[wp0]"r"(&dptr[z0][d+0*NSIZE]),
 			[wp1]"r"(&dptr[z0][d+1*NSIZE]),
@@ -431,6 +473,8 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
 			 * wp$$ ^= wd$$;
 			 */
 			asm volatile (
+				".option push\n"
+				".option arch,+v\n"
 				"vsra.vi	v2, v1, 7\n"
 				"vsll.vi	v3, v1, 1\n"
 				"vand.vx	v2, v2, %[x1d]\n"
@@ -462,6 +506,7 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
 				"vle8.v		v14, (%[wd3])\n"
 				"vxor.vv	v13, v15, v14\n"
 				"vxor.vv	v12, v12, v14\n"
+				".option	pop\n"
 				: :
 				[wd0]"r"(&dptr[z][d+0*NSIZE]),
 				[wd1]"r"(&dptr[z][d+1*NSIZE]),
@@ -476,6 +521,8 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
 		 * *(unative_t *)&q[d+NSIZE*$$] = wq$$;
 		 */
 		asm volatile (
+			".option push\n"
+			".option arch,+v\n"
 			"vse8.v	v0, (%[wp0])\n"
 			"vse8.v	v1, (%[wq0])\n"
 			"vse8.v	v4, (%[wp1])\n"
@@ -484,6 +531,7 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
 			"vse8.v	v9, (%[wq2])\n"
 			"vse8.v	v12, (%[wp3])\n"
 			"vse8.v	v13, (%[wq3])\n"
+			".option	pop\n"
 			: :
 			[wp0]"r"(&p[d+NSIZE*0]),
 			[wq0]"r"(&q[d+NSIZE*0]),
@@ -495,8 +543,6 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
 			[wq3]"r"(&q[d+NSIZE*3])
 		);
 	}
-
-	asm volatile (".option pop\n");
 }
 
 static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
@@ -514,6 +560,7 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
 		".option push\n"
 		".option arch,+v\n"
 		"vsetvli	t0, x0, e8, m1, ta, ma\n"
+		".option	pop\n"
 	);
 
 	/*
@@ -525,6 +572,8 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
 	for (d = 0 ; d < bytes ; d += NSIZE*4) {
 		 /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
 		asm volatile (
+			".option push\n"
+			".option arch,+v\n"
 			"vle8.v v0, (%[wp0])\n"
 			"vle8.v v1, (%[wp0])\n"
 			"vle8.v v4, (%[wp1])\n"
@@ -533,6 +582,7 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
 			"vle8.v v9, (%[wp2])\n"
 			"vle8.v v12, (%[wp3])\n"
 			"vle8.v v13, (%[wp3])\n"
+			".option	pop\n"
 			: :
 			[wp0]"r"(&dptr[z0][d+0*NSIZE]),
 			[wp1]"r"(&dptr[z0][d+1*NSIZE]),
@@ -552,6 +602,8 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
 			 * wp$$ ^= wd$$;
 			 */
 			asm volatile (
+				".option push\n"
+				".option arch,+v\n"
 				"vsra.vi	v2, v1, 7\n"
 				"vsll.vi	v3, v1, 1\n"
 				"vand.vx	v2, v2, %[x1d]\n"
@@ -583,6 +635,7 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
 				"vle8.v		v14, (%[wd3])\n"
 				"vxor.vv	v13, v15, v14\n"
 				"vxor.vv	v12, v12, v14\n"
+				".option	pop\n"
 				: :
 				[wd0]"r"(&dptr[z][d+0*NSIZE]),
 				[wd1]"r"(&dptr[z][d+1*NSIZE]),
@@ -601,6 +654,8 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
 			 * wq$$ = w1$$ ^ w2$$;
 			 */
 			asm volatile (
+				".option push\n"
+				".option arch,+v\n"
 				"vsra.vi	v2, v1, 7\n"
 				"vsll.vi	v3, v1, 1\n"
 				"vand.vx	v2, v2, %[x1d]\n"
@@ -620,6 +675,7 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
 				"vsll.vi	v15, v13, 1\n"
 				"vand.vx	v14, v14, %[x1d]\n"
 				"vxor.vv	v13, v15, v14\n"
+				".option	pop\n"
 				: :
 				[x1d]"r"(0x1d)
 			);
@@ -634,6 +690,8 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
 		 * v12:wp3, v13:wq3, v14:p3, v15:q3
 		 */
 		asm volatile (
+			".option push\n"
+			".option arch,+v\n"
 			"vle8.v		v2, (%[wp0])\n"
 			"vle8.v		v3, (%[wq0])\n"
 			"vxor.vv	v2, v2, v0\n"
@@ -661,6 +719,7 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
 			"vxor.vv	v15, v15, v13\n"
 			"vse8.v		v14, (%[wp3])\n"
 			"vse8.v		v15, (%[wq3])\n"
+			".option	pop\n"
 			: :
 			[wp0]"r"(&p[d+NSIZE*0]),
 			[wq0]"r"(&q[d+NSIZE*0]),
@@ -672,8 +731,6 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
 			[wq3]"r"(&q[d+NSIZE*3])
 		);
 	}
-
-	asm volatile (".option pop\n");
 }
 
 #define RAID6_RVV_WRAPPER(_n)						\
-- 
2.34.1


- Charlie

