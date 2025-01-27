Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C821B8C11;
	Mon, 27 Jan 2025 08:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737967204; cv=none; b=uRprud/cEqs1FivtrIe7DQFdeYovfmk4qeF/ds9dWgNMG2lu2+Azol4c86BRGFV88aVF/v9F2haQgYWuVOntRA/aCdTgBHAw8ILEZz4IdVaMFEAEyOCF3cnAabM011P582/Ud/d8xtlv9+EXJ5Sa4EdEwq1qRv6CJSuhnNAXnXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737967204; c=relaxed/simple;
	bh=z/aqRFkJaTICKVMENbO0qpeTETlBkHOWxKlbMKyoy60=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ak9Iv1BATa9cJE7STddJzb6lbvjqVha7qwGEoX+FoZGKUmJCqUegj94kxy3TSC+si/KUfeogZ0qJxO9LGO4Cr61DGNPUnC38d/p22/FntyAso/AHjDmUVw9Uf/HVHQisubSevqVkB8PdIhZt+jQ98ZtZepsFaWhr8TSrjfdqz1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.224] (ip5f5aeeed.dynamic.kabel-deutschland.de [95.90.238.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 63D1361E6479E;
	Mon, 27 Jan 2025 09:39:12 +0100 (CET)
Message-ID: <c0a2fbeb-9a0d-4b69-bc6b-e1652e13debf@molgen.mpg.de>
Date: Mon, 27 Jan 2025 09:39:11 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] raid6: Add RISC-V SIMD syndrome and recovery
 calculations
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Charlie Jenkins <charlie@rivosinc.com>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, linux-riscv@lists.infradead.org,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chunyan Zhang <zhang.lyra@gmail.com>
References: <20250127061529.2437012-1-zhangchunyan@iscas.ac.cn>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250127061529.2437012-1-zhangchunyan@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Chunyan,


Thank you for the patch.


Am 27.01.25 um 07:15 schrieb Chunyan Zhang:
> The assembly is originally based on the ARM NEON and int.uc, but uses
> RISC-V vector instructions to implement the RAID6 syndrome and
> recovery calculations.
> 
> Results on QEMU running with the option "-icount shift=0":
> 
>    raid6: rvvx1    gen()  1008 MB/s
>    raid6: rvvx2    gen()  1395 MB/s
>    raid6: rvvx4    gen()  1584 MB/s
>    raid6: rvvx8    gen()  1694 MB/s
>    raid6: int64x8  gen()   113 MB/s
>    raid6: int64x4  gen()   116 MB/s
>    raid6: int64x2  gen()   272 MB/s
>    raid6: int64x1  gen()   229 MB/s
>    raid6: using algorithm rvvx8 gen() 1694 MB/s
>    raid6: .... xor() 1000 MB/s, rmw enabled
>    raid6: using rvv recovery algorithm

How did you start QEMU and on what host did you run it? Does it change 
between runs? (For me these benchmark values were very unreliable in the 
past on x86 hardware.)

> [Charlie: - Fixup vector options]
> Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> ---
> V2:
> - Add raid6_rvvx8;
> - Address the vector options issue;
> - Add .valid callback to raid6_rvv and raid6_recov_rvv;
> - Removed unneeded check of crypto_simd_usable();
> 
> RFC: https://lore.kernel.org/lkml/20241220114023.667347-1-zhangchunyan@iscas.ac.cn/
> ---
>   include/linux/raid/pq.h |    5 +
>   lib/raid6/Makefile      |    1 +
>   lib/raid6/algos.c       |    9 +
>   lib/raid6/recov_rvv.c   |  234 ++++++++
>   lib/raid6/rvv.c         | 1269 +++++++++++++++++++++++++++++++++++++++
>   5 files changed, 1518 insertions(+)
>   create mode 100644 lib/raid6/recov_rvv.c
>   create mode 100644 lib/raid6/rvv.c
> 
> diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
> index 98030accf641..72ff44cca864 100644
> --- a/include/linux/raid/pq.h
> +++ b/include/linux/raid/pq.h
> @@ -108,6 +108,10 @@ extern const struct raid6_calls raid6_vpermxor4;
>   extern const struct raid6_calls raid6_vpermxor8;
>   extern const struct raid6_calls raid6_lsx;
>   extern const struct raid6_calls raid6_lasx;
> +extern const struct raid6_calls raid6_rvvx1;
> +extern const struct raid6_calls raid6_rvvx2;
> +extern const struct raid6_calls raid6_rvvx4;
> +extern const struct raid6_calls raid6_rvvx8;
>   
>   struct raid6_recov_calls {
>   	void (*data2)(int, size_t, int, int, void **);
> @@ -125,6 +129,7 @@ extern const struct raid6_recov_calls raid6_recov_s390xc;
>   extern const struct raid6_recov_calls raid6_recov_neon;
>   extern const struct raid6_recov_calls raid6_recov_lsx;
>   extern const struct raid6_recov_calls raid6_recov_lasx;
> +extern const struct raid6_recov_calls raid6_recov_rvv;
>   
>   extern const struct raid6_calls raid6_neonx1;
>   extern const struct raid6_calls raid6_neonx2;
> diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
> index 29127dd05d63..5be0a4e60ab1 100644
> --- a/lib/raid6/Makefile
> +++ b/lib/raid6/Makefile
> @@ -10,6 +10,7 @@ raid6_pq-$(CONFIG_ALTIVEC) += altivec1.o altivec2.o altivec4.o altivec8.o \
>   raid6_pq-$(CONFIG_KERNEL_MODE_NEON) += neon.o neon1.o neon2.o neon4.o neon8.o recov_neon.o recov_neon_inner.o
>   raid6_pq-$(CONFIG_S390) += s390vx8.o recov_s390xc.o
>   raid6_pq-$(CONFIG_LOONGARCH) += loongarch_simd.o recov_loongarch_simd.o
> +raid6_pq-$(CONFIG_RISCV_ISA_V) += rvv.o recov_rvv.o
>   
>   hostprogs	+= mktables
>   
> diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> index cd2e88ee1f14..99980ff5b985 100644
> --- a/lib/raid6/algos.c
> +++ b/lib/raid6/algos.c
> @@ -80,6 +80,12 @@ const struct raid6_calls * const raid6_algos[] = {
>   #ifdef CONFIG_CPU_HAS_LSX
>   	&raid6_lsx,
>   #endif
> +#endif
> +#ifdef CONFIG_RISCV_ISA_V
> +	&raid6_rvvx1,
> +	&raid6_rvvx2,
> +	&raid6_rvvx4,
> +	&raid6_rvvx8,
>   #endif
>   	&raid6_intx8,
>   	&raid6_intx4,
> @@ -115,6 +121,9 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
>   #ifdef CONFIG_CPU_HAS_LSX
>   	&raid6_recov_lsx,
>   #endif
> +#endif
> +#ifdef CONFIG_RISCV_ISA_V
> +	&raid6_recov_rvv,
>   #endif
>   	&raid6_recov_intx1,
>   	NULL
> diff --git a/lib/raid6/recov_rvv.c b/lib/raid6/recov_rvv.c
> new file mode 100644
> index 000000000000..db271d2987c6
> --- /dev/null
> +++ b/lib/raid6/recov_rvv.c
> @@ -0,0 +1,234 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright 2024 Institute of Software, CAS.

Remove the dot/period at the end?

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
> +			      u8 *dq, const u8 *pbmul,
> +			      const u8 *qmul)
> +{
> +	asm volatile (
> +		".option	push\n"
> +		".option	arch,+v\n"
> +		"vsetvli	x0, %[avl], e8, m1, ta, ma\n"
> +		".option	pop\n"
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
> +			".option	push\n"
> +			".option	arch,+v\n"
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
> +			".option	pop\n"
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
> +}
> +
> +static void __raid6_datap_recov_rvv(int bytes, uint8_t *p, uint8_t *q, uint8_t *dq,
> +			      const uint8_t *qmul)
> +{
> +	asm volatile (
> +		".option	push\n"
> +		".option	arch,+v\n"
> +		"vsetvli	x0, %[avl], e8, m1, ta, ma\n"
> +		".option	pop\n"
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
> +			".option	push\n"
> +			".option	arch,+v\n"
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
> +			".option	pop\n"
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
> +	kernel_vector_begin();
> +	__raid6_2data_recov_rvv(bytes, p, q, dp, dq, pbmul, qmul);
> +	kernel_vector_end();
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
> index 000000000000..fd0ec33edb1e
> --- /dev/null
> +++ b/lib/raid6/rvv.c
> @@ -0,0 +1,1269 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * RAID-6 syndrome calculation using RISCV vector instructions
> + *
> + * Copyright 2024 Institute of Software, CAS.

Remove the dot/period at the end?

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
> +static int rvv_has_vector(void)
> +{
> +	return has_vector();
> +}
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
> +		".option	pop\n"
> +	);
> +
> +	 /* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
> +	for (d = 0 ; d < bytes ; d += NSIZE*1) {
> +		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (
> +			".option	push\n"
> +			".option	arch,+v\n"
> +			"vle8.v		v0, (%[wp0])\n"
> +			"vle8.v		v1, (%[wp0])\n"
> +			".option	pop\n"
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
> +				".option	push\n"
> +				".option	arch,+v\n"
> +				"vsra.vi	v2, v1, 7\n"
> +				"vsll.vi	v3, v1, 1\n"
> +				"vand.vx	v2, v2, %[x1d]\n"
> +				"vxor.vv	v3, v3, v2\n"
> +				"vle8.v		v2, (%[wd0])\n"
> +				"vxor.vv	v1, v3, v2\n"
> +				"vxor.vv	v0, v0, v2\n"
> +				".option	pop\n"
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
> +			".option	push\n"
> +			".option	arch,+v\n"
> +			"vse8.v		v0, (%[wp0])\n"
> +			"vse8.v		v1, (%[wq0])\n"
> +			".option	pop\n"
> +			: :
> +			[wp0]"r"(&p[d+NSIZE*0]),
> +			[wq0]"r"(&q[d+NSIZE*0])
> +		);
> +	}
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
> +		".option	push\n"
> +		".option	arch,+v\n"
> +		"vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		".option	pop\n"
> +	);
> +
> +	/* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
> +	for (d = 0 ; d < bytes ; d += NSIZE*1) {
> +		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (
> +			".option	push\n"
> +			".option	arch,+v\n"
> +			"vle8.v		v0, (%[wp0])\n"
> +			"vle8.v		v1, (%[wp0])\n"
> +			".option	pop\n"
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
> +				".option	push\n"
> +				".option	arch,+v\n"
> +				"vsra.vi	v2, v1, 7\n"
> +				"vsll.vi	v3, v1, 1\n"
> +				"vand.vx	v2, v2, %[x1d]\n"
> +				"vxor.vv	v3, v3, v2\n"
> +				"vle8.v		v2, (%[wd0])\n"
> +				"vxor.vv	v1, v3, v2\n"
> +				"vxor.vv	v0, v0, v2\n"
> +				".option	pop\n"
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
> +				".option	push\n"
> +				".option	arch,+v\n"
> +				"vsra.vi	v2, v1, 7\n"
> +				"vsll.vi	v3, v1, 1\n"
> +				"vand.vx	v2, v2, %[x1d]\n"
> +				"vxor.vv	v1, v3, v2\n"
> +				".option	pop\n"
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
> +			".option	push\n"
> +			".option	arch,+v\n"
> +			"vle8.v		v2, (%[wp0])\n"
> +			"vle8.v		v3, (%[wq0])\n"
> +			"vxor.vv	v2, v2, v0\n"
> +			"vxor.vv	v3, v3, v1\n"
> +			"vse8.v		v2, (%[wp0])\n"
> +			"vse8.v		v3, (%[wq0])\n"
> +			".option	pop\n"
> +			: :
> +			[wp0]"r"(&p[d+NSIZE*0]),
> +			[wq0]"r"(&q[d+NSIZE*0])
> +		);
> +	}
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
> +		".option	pop\n"
> +	);
> +
> +	/*
> +	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
> +	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
> +	 */
> +	for (d = 0 ; d < bytes ; d += NSIZE*2) {

*bytes* is unsigned long, but d is int. Should they match? (Also above 
and below.)


Kind regards,

Paul


> +		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (
> +			".option	push\n"
> +			".option	arch,+v\n"
> +			"vle8.v		v0, (%[wp0])\n"
> +			"vle8.v		v1, (%[wp0])\n"
> +			"vle8.v		v4, (%[wp1])\n"
> +			"vle8.v		v5, (%[wp1])\n"
> +			".option	pop\n"
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
> +				".option	push\n"
> +				".option	arch,+v\n"
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
> +				".option	pop\n"
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
> +			".option	push\n"
> +			".option	arch,+v\n"
> +			"vse8.v		v0, (%[wp0])\n"
> +			"vse8.v		v1, (%[wq0])\n"
> +			"vse8.v		v4, (%[wp1])\n"
> +			"vse8.v		v5, (%[wq1])\n"
> +			".option	pop\n"
> +			: :
> +			[wp0]"r"(&p[d+NSIZE*0]),
> +			[wq0]"r"(&q[d+NSIZE*0]),
> +			[wp1]"r"(&p[d+NSIZE*1]),
> +			[wq1]"r"(&q[d+NSIZE*1])
> +		);
> +	}
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
> +		".option	push\n"
> +		".option	arch,+v\n"
> +		"vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		".option	pop\n"
> +	);
> +
> +	/*
> +	 * v0:wp0, v1:wq0, v2:wd0/w20, v3:w10
> +	 * v4:wp1, v5:wq1, v6:wd1/w21, v7:w11
> +	 */
> +	for (d = 0 ; d < bytes ; d += NSIZE*2) {
> +		 /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (
> +			".option	push\n"
> +			".option	arch,+v\n"
> +			"vle8.v		v0, (%[wp0])\n"
> +			"vle8.v		v1, (%[wp0])\n"
> +			"vle8.v		v4, (%[wp1])\n"
> +			"vle8.v		v5, (%[wp1])\n"
> +			".option	pop\n"
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
> +				".option	push\n"
> +				".option	arch,+v\n"
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
> +				".option	pop\n"
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
> +				".option	push\n"
> +				".option	arch,+v\n"
> +				"vsra.vi	v2, v1, 7\n"
> +				"vsll.vi	v3, v1, 1\n"
> +				"vand.vx	v2, v2, %[x1d]\n"
> +				"vxor.vv	v1, v3, v2\n"
> +
> +				"vsra.vi	v6, v5, 7\n"
> +				"vsll.vi	v7, v5, 1\n"
> +				"vand.vx	v6, v6, %[x1d]\n"
> +				"vxor.vv	v5, v7, v6\n"
> +				".option	pop\n"
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
> +			".option	push\n"
> +			".option	arch,+v\n"
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
> +			".option	pop\n"
> +			: :
> +			[wp0]"r"(&p[d+NSIZE*0]),
> +			[wq0]"r"(&q[d+NSIZE*0]),
> +			[wp1]"r"(&p[d+NSIZE*1]),
> +			[wq1]"r"(&q[d+NSIZE*1])
> +		);
> +	}
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
> +		".option	pop\n"
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
> +			".option	push\n"
> +			".option	arch,+v\n"
> +			"vle8.v		v0, (%[wp0])\n"
> +			"vle8.v		v1, (%[wp0])\n"
> +			"vle8.v		v4, (%[wp1])\n"
> +			"vle8.v		v5, (%[wp1])\n"
> +			"vle8.v		v8, (%[wp2])\n"
> +			"vle8.v		v9, (%[wp2])\n"
> +			"vle8.v		v12, (%[wp3])\n"
> +			"vle8.v		v13, (%[wp3])\n"
> +			".option	pop\n"
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
> +				".option	push\n"
> +				".option	arch,+v\n"
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
> +				".option	pop\n"
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
> +			".option	push\n"
> +			".option	arch,+v\n"
> +			"vse8.v		v0, (%[wp0])\n"
> +			"vse8.v		v1, (%[wq0])\n"
> +			"vse8.v		v4, (%[wp1])\n"
> +			"vse8.v		v5, (%[wq1])\n"
> +			"vse8.v		v8, (%[wp2])\n"
> +			"vse8.v		v9, (%[wq2])\n"
> +			"vse8.v		v12, (%[wp3])\n"
> +			"vse8.v		v13, (%[wq3])\n"
> +			".option	pop\n"
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
> +		".option	push\n"
> +		".option	arch,+v\n"
> +		"vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		".option	pop\n"
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
> +			".option	push\n"
> +			".option	arch,+v\n"
> +			"vle8.v		v0, (%[wp0])\n"
> +			"vle8.v		v1, (%[wp0])\n"
> +			"vle8.v		v4, (%[wp1])\n"
> +			"vle8.v		v5, (%[wp1])\n"
> +			"vle8.v		v8, (%[wp2])\n"
> +			"vle8.v		v9, (%[wp2])\n"
> +			"vle8.v		v12, (%[wp3])\n"
> +			"vle8.v		v13, (%[wp3])\n"
> +			".option	pop\n"
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
> +				".option	push\n"
> +				".option	arch,+v\n"
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
> +				".option	pop\n"
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
> +				".option	push\n"
> +				".option	arch,+v\n"
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
> +				".option	pop\n"
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
> +			".option	push\n"
> +			".option	arch,+v\n"
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
> +			".option	pop\n"
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
> +}
> +
> +static void raid6_rvv8_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
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
> +		".option	pop\n"
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
> +	for (d = 0; d < bytes; d += NSIZE*8) {
> +		/* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (
> +			".option	push\n"
> +			".option	arch,+v\n"
> +			"vle8.v		v0, (%[wp0])\n"
> +			"vle8.v		v1, (%[wp0])\n"
> +			"vle8.v		v4, (%[wp1])\n"
> +			"vle8.v		v5, (%[wp1])\n"
> +			"vle8.v		v8, (%[wp2])\n"
> +			"vle8.v		v9, (%[wp2])\n"
> +			"vle8.v		v12, (%[wp3])\n"
> +			"vle8.v		v13, (%[wp3])\n"
> +			"vle8.v		v16, (%[wp4])\n"
> +			"vle8.v		v17, (%[wp4])\n"
> +			"vle8.v		v20, (%[wp5])\n"
> +			"vle8.v		v21, (%[wp5])\n"
> +			"vle8.v		v24, (%[wp6])\n"
> +			"vle8.v		v25, (%[wp6])\n"
> +			"vle8.v		v28, (%[wp7])\n"
> +			"vle8.v		v29, (%[wp7])\n"
> +			".option	pop\n"
> +			: :
> +			[wp0]"r"(&dptr[z0][d+0*NSIZE]),
> +			[wp1]"r"(&dptr[z0][d+1*NSIZE]),
> +			[wp2]"r"(&dptr[z0][d+2*NSIZE]),
> +			[wp3]"r"(&dptr[z0][d+3*NSIZE]),
> +			[wp4]"r"(&dptr[z0][d+4*NSIZE]),
> +			[wp5]"r"(&dptr[z0][d+5*NSIZE]),
> +			[wp6]"r"(&dptr[z0][d+6*NSIZE]),
> +			[wp7]"r"(&dptr[z0][d+7*NSIZE])
> +		);
> +
> +		for (z = z0-1; z >= 0; z--) {
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
> +				".option	push\n"
> +				".option	arch,+v\n"
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
> +
> +				"vsra.vi	v18, v17, 7\n"
> +				"vsll.vi	v19, v17, 1\n"
> +				"vand.vx	v18, v18, %[x1d]\n"
> +				"vxor.vv	v19, v19, v18\n"
> +				"vle8.v		v18, (%[wd4])\n"
> +				"vxor.vv	v17, v19, v18\n"
> +				"vxor.vv	v16, v16, v18\n"
> +
> +				"vsra.vi	v22, v21, 7\n"
> +				"vsll.vi	v23, v21, 1\n"
> +				"vand.vx	v22, v22, %[x1d]\n"
> +				"vxor.vv	v23, v23, v22\n"
> +				"vle8.v		v22, (%[wd5])\n"
> +				"vxor.vv	v21, v23, v22\n"
> +				"vxor.vv	v20, v20, v22\n"
> +
> +				"vsra.vi	v26, v25, 7\n"
> +				"vsll.vi	v27, v25, 1\n"
> +				"vand.vx	v26, v26, %[x1d]\n"
> +				"vxor.vv	v27, v27, v26\n"
> +				"vle8.v		v26, (%[wd6])\n"
> +				"vxor.vv	v25, v27, v26\n"
> +				"vxor.vv	v24, v24, v26\n"
> +
> +				"vsra.vi	v30, v29, 7\n"
> +				"vsll.vi	v31, v29, 1\n"
> +				"vand.vx	v30, v30, %[x1d]\n"
> +				"vxor.vv	v31, v31, v30\n"
> +				"vle8.v		v30, (%[wd7])\n"
> +				"vxor.vv	v29, v31, v30\n"
> +				"vxor.vv	v28, v28, v30\n"
> +				".option	pop\n"
> +				: :
> +				[wd0]"r"(&dptr[z][d+0*NSIZE]),
> +				[wd1]"r"(&dptr[z][d+1*NSIZE]),
> +				[wd2]"r"(&dptr[z][d+2*NSIZE]),
> +				[wd3]"r"(&dptr[z][d+3*NSIZE]),
> +				[wd4]"r"(&dptr[z][d+4*NSIZE]),
> +				[wd5]"r"(&dptr[z][d+5*NSIZE]),
> +				[wd6]"r"(&dptr[z][d+6*NSIZE]),
> +				[wd7]"r"(&dptr[z][d+7*NSIZE]),
> +				[x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/*
> +		 * *(unative_t *)&p[d+NSIZE*$$] = wp$$;
> +		 * *(unative_t *)&q[d+NSIZE*$$] = wq$$;
> +		 */
> +		asm volatile (
> +			".option	push\n"
> +			".option	arch,+v\n"
> +			"vse8.v		v0, (%[wp0])\n"
> +			"vse8.v		v1, (%[wq0])\n"
> +			"vse8.v		v4, (%[wp1])\n"
> +			"vse8.v		v5, (%[wq1])\n"
> +			"vse8.v		v8, (%[wp2])\n"
> +			"vse8.v		v9, (%[wq2])\n"
> +			"vse8.v		v12, (%[wp3])\n"
> +			"vse8.v		v13, (%[wq3])\n"
> +			"vse8.v		v16, (%[wp4])\n"
> +			"vse8.v		v17, (%[wq4])\n"
> +			"vse8.v		v20, (%[wp5])\n"
> +			"vse8.v		v21, (%[wq5])\n"
> +			"vse8.v		v24, (%[wp6])\n"
> +			"vse8.v		v25, (%[wq6])\n"
> +			"vse8.v		v28, (%[wp7])\n"
> +			"vse8.v		v29, (%[wq7])\n"
> +			".option	pop\n"
> +			: :
> +			[wp0]"r"(&p[d+NSIZE*0]),
> +			[wq0]"r"(&q[d+NSIZE*0]),
> +			[wp1]"r"(&p[d+NSIZE*1]),
> +			[wq1]"r"(&q[d+NSIZE*1]),
> +			[wp2]"r"(&p[d+NSIZE*2]),
> +			[wq2]"r"(&q[d+NSIZE*2]),
> +			[wp3]"r"(&p[d+NSIZE*3]),
> +			[wq3]"r"(&q[d+NSIZE*3]),
> +			[wp4]"r"(&p[d+NSIZE*4]),
> +			[wq4]"r"(&q[d+NSIZE*4]),
> +			[wp5]"r"(&p[d+NSIZE*5]),
> +			[wq5]"r"(&q[d+NSIZE*5]),
> +			[wp6]"r"(&p[d+NSIZE*6]),
> +			[wq6]"r"(&q[d+NSIZE*6]),
> +			[wp7]"r"(&p[d+NSIZE*7]),
> +			[wq7]"r"(&q[d+NSIZE*7])
> +		);
> +	}
> +}
> +
> +static void raid6_rvv8_xor_syndrome_real(int disks, int start, int stop,
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
> +		".option	push\n"
> +		".option	arch,+v\n"
> +		"vsetvli	t0, x0, e8, m1, ta, ma\n"
> +		".option	pop\n"
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
> +	for (d = 0; d < bytes; d += NSIZE*8) {
> +		 /* wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE]; */
> +		asm volatile (
> +			".option	push\n"
> +			".option	arch,+v\n"
> +			"vle8.v		v0, (%[wp0])\n"
> +			"vle8.v		v1, (%[wp0])\n"
> +			"vle8.v		v4, (%[wp1])\n"
> +			"vle8.v		v5, (%[wp1])\n"
> +			"vle8.v		v8, (%[wp2])\n"
> +			"vle8.v		v9, (%[wp2])\n"
> +			"vle8.v		v12, (%[wp3])\n"
> +			"vle8.v		v13, (%[wp3])\n"
> +			"vle8.v		v16, (%[wp4])\n"
> +			"vle8.v		v17, (%[wp4])\n"
> +			"vle8.v		v20, (%[wp5])\n"
> +			"vle8.v		v21, (%[wp5])\n"
> +			"vle8.v		v24, (%[wp6])\n"
> +			"vle8.v		v25, (%[wp6])\n"
> +			"vle8.v		v28, (%[wp7])\n"
> +			"vle8.v		v29, (%[wp7])\n"
> +			".option	pop\n"
> +			: :
> +			[wp0]"r"(&dptr[z0][d+0*NSIZE]),
> +			[wp1]"r"(&dptr[z0][d+1*NSIZE]),
> +			[wp2]"r"(&dptr[z0][d+2*NSIZE]),
> +			[wp3]"r"(&dptr[z0][d+3*NSIZE]),
> +			[wp4]"r"(&dptr[z0][d+4*NSIZE]),
> +			[wp5]"r"(&dptr[z0][d+5*NSIZE]),
> +			[wp6]"r"(&dptr[z0][d+6*NSIZE]),
> +			[wp7]"r"(&dptr[z0][d+7*NSIZE])
> +		);
> +
> +		/* P/Q data pages */
> +		for (z = z0-1; z >= start; z--) {
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
> +				".option	push\n"
> +				".option	arch,+v\n"
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
> +
> +				"vsra.vi	v18, v17, 7\n"
> +				"vsll.vi	v19, v17, 1\n"
> +				"vand.vx	v18, v18, %[x1d]\n"
> +				"vxor.vv	v19, v19, v18\n"
> +				"vle8.v		v18, (%[wd4])\n"
> +				"vxor.vv	v17, v19, v18\n"
> +				"vxor.vv	v16, v16, v18\n"
> +
> +				"vsra.vi	v22, v21, 7\n"
> +				"vsll.vi	v23, v21, 1\n"
> +				"vand.vx	v22, v22, %[x1d]\n"
> +				"vxor.vv	v23, v23, v22\n"
> +				"vle8.v		v22, (%[wd5])\n"
> +				"vxor.vv	v21, v23, v22\n"
> +				"vxor.vv	v20, v20, v22\n"
> +
> +				"vsra.vi	v26, v25, 7\n"
> +				"vsll.vi	v27, v25, 1\n"
> +				"vand.vx	v26, v26, %[x1d]\n"
> +				"vxor.vv	v27, v27, v26\n"
> +				"vle8.v		v26, (%[wd6])\n"
> +				"vxor.vv	v25, v27, v26\n"
> +				"vxor.vv	v24, v24, v26\n"
> +
> +				"vsra.vi	v30, v29, 7\n"
> +				"vsll.vi	v31, v29, 1\n"
> +				"vand.vx	v30, v30, %[x1d]\n"
> +				"vxor.vv	v31, v31, v30\n"
> +				"vle8.v		v30, (%[wd7])\n"
> +				"vxor.vv	v29, v31, v30\n"
> +				"vxor.vv	v28, v28, v30\n"
> +				".option	pop\n"
> +				: :
> +				[wd0]"r"(&dptr[z][d+0*NSIZE]),
> +				[wd1]"r"(&dptr[z][d+1*NSIZE]),
> +				[wd2]"r"(&dptr[z][d+2*NSIZE]),
> +				[wd3]"r"(&dptr[z][d+3*NSIZE]),
> +				[wd4]"r"(&dptr[z][d+4*NSIZE]),
> +				[wd5]"r"(&dptr[z][d+5*NSIZE]),
> +				[wd6]"r"(&dptr[z][d+6*NSIZE]),
> +				[wd7]"r"(&dptr[z][d+7*NSIZE]),
> +				[x1d]"r"(0x1d)
> +			);
> +		}
> +
> +		/* P/Q left side optimization */
> +		for (z = start-1; z >= 0; z--) {
> +			/*
> +			 * w2$$ = MASK(wq$$);
> +			 * w1$$ = SHLBYTE(wq$$);
> +			 * w2$$ &= NBYTES(0x1d);
> +			 * wq$$ = w1$$ ^ w2$$;
> +			 */
> +			asm volatile (
> +				".option	push\n"
> +				".option	arch,+v\n"
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
> +
> +				"vsra.vi	v18, v17, 7\n"
> +				"vsll.vi	v19, v17, 1\n"
> +				"vand.vx	v18, v18, %[x1d]\n"
> +				"vxor.vv	v17, v19, v18\n"
> +
> +				"vsra.vi	v22, v21, 7\n"
> +				"vsll.vi	v23, v21, 1\n"
> +				"vand.vx	v22, v22, %[x1d]\n"
> +				"vxor.vv	v21, v23, v22\n"
> +
> +				"vsra.vi	v26, v25, 7\n"
> +				"vsll.vi	v27, v25, 1\n"
> +				"vand.vx	v26, v26, %[x1d]\n"
> +				"vxor.vv	v25, v27, v26\n"
> +
> +				"vsra.vi	v30, v29, 7\n"
> +				"vsll.vi	v31, v29, 1\n"
> +				"vand.vx	v30, v30, %[x1d]\n"
> +				"vxor.vv	v29, v31, v30\n"
> +				".option	pop\n"
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
> +		 * v16:wp4, v17:wq4, v18:p4, v19:q4
> +		 * v20:wp5, v21:wq5, v22:p5, v23:q5
> +		 * v24:wp6, v25:wq6, v26:p6, v27:q6
> +		 * v28:wp7, v29:wq7, v30:p7, v31:q7
> +		 */
> +		asm volatile (
> +			".option	push\n"
> +			".option	arch,+v\n"
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
> +
> +			"vle8.v		v18, (%[wp4])\n"
> +			"vle8.v		v19, (%[wq4])\n"
> +			"vxor.vv	v18, v18, v16\n"
> +			"vxor.vv	v19, v19, v17\n"
> +			"vse8.v		v18, (%[wp4])\n"
> +			"vse8.v		v19, (%[wq4])\n"
> +
> +			"vle8.v		v22, (%[wp5])\n"
> +			"vle8.v		v23, (%[wq5])\n"
> +			"vxor.vv	v22, v22, v20\n"
> +			"vxor.vv	v23, v23, v21\n"
> +			"vse8.v		v22, (%[wp5])\n"
> +			"vse8.v		v23, (%[wq5])\n"
> +
> +			"vle8.v		v26, (%[wp6])\n"
> +			"vle8.v		v27, (%[wq6])\n"
> +			"vxor.vv	v26, v26, v24\n"
> +			"vxor.vv	v27, v27, v25\n"
> +			"vse8.v		v26, (%[wp6])\n"
> +			"vse8.v		v27, (%[wq6])\n"
> +
> +			"vle8.v		v30, (%[wp7])\n"
> +			"vle8.v		v31, (%[wq7])\n"
> +			"vxor.vv	v30, v30, v28\n"
> +			"vxor.vv	v31, v31, v29\n"
> +			"vse8.v		v30, (%[wp7])\n"
> +			"vse8.v		v31, (%[wq7])\n"
> +			".option	pop\n"
> +			: :
> +			[wp0]"r"(&p[d+NSIZE*0]),
> +			[wq0]"r"(&q[d+NSIZE*0]),
> +			[wp1]"r"(&p[d+NSIZE*1]),
> +			[wq1]"r"(&q[d+NSIZE*1]),
> +			[wp2]"r"(&p[d+NSIZE*2]),
> +			[wq2]"r"(&q[d+NSIZE*2]),
> +			[wp3]"r"(&p[d+NSIZE*3]),
> +			[wq3]"r"(&q[d+NSIZE*3]),
> +			[wp4]"r"(&p[d+NSIZE*4]),
> +			[wq4]"r"(&q[d+NSIZE*4]),
> +			[wp5]"r"(&p[d+NSIZE*5]),
> +			[wq5]"r"(&q[d+NSIZE*5]),
> +			[wp6]"r"(&p[d+NSIZE*6]),
> +			[wq6]"r"(&q[d+NSIZE*6]),
> +			[wp7]"r"(&p[d+NSIZE*7]),
> +			[wq7]"r"(&q[d+NSIZE*7])
> +		);
> +	}
> +}
> +
> +#define RAID6_RVV_WRAPPER(_n)						\
> +	static void raid6_rvv ## _n ## _gen_syndrome(int disks,		\
> +					size_t bytes, void **ptrs)	\
> +	{								\
> +		void raid6_rvv ## _n  ## _gen_syndrome_real(int,	\
> +						unsigned long, void**);	\
> +		kernel_vector_begin();					\
> +		raid6_rvv ## _n ## _gen_syndrome_real(disks,		\
> +				(unsigned long)bytes, ptrs);		\
> +		kernel_vector_end();					\
> +	}								\
> +	static void raid6_rvv ## _n ## _xor_syndrome(int disks,		\
> +					int start, int stop,		\
> +					size_t bytes, void **ptrs)	\
> +	{								\
> +		void raid6_rvv ## _n  ## _xor_syndrome_real(int,	\
> +				int, int, unsigned long, void**);	\
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
> +
> +RAID6_RVV_WRAPPER(1);
> +RAID6_RVV_WRAPPER(2);
> +RAID6_RVV_WRAPPER(4);
> +RAID6_RVV_WRAPPER(8);

