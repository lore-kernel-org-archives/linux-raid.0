Received: from va-1-20.ptr.blmpb.com (va-1-20.ptr.blmpb.com [209.127.230.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316B7285C8E
	for <linux-raid@vger.kernel.org>; Mon, 21 Jul 2025 07:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753084394; cv=none; b=SgJoL/+0r4rV08x6fOzFeg5cG14nD8xYDtGRmbx2p1Ri6UTHnkNWjGQNHHz6+Jkt5O5cwIs2+GYb6ngg5mTYJLdRRm+G5qPB7tK1y/eiB8ioWzMZ2/429e4Poa6M+CkREMbhNLTzKgX5/+sikurcH73jMVISLY3itAr9yD76Jdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753084394; c=relaxed/simple;
	bh=piE1KZipH6AhPultPptmn7fkpUU6EewB4qN0e6j/ZU8=;
	h=To:Cc:From:Subject:References:In-Reply-To:Date:Content-Type:
	 Message-Id:Mime-Version; b=jZuNwaa/cnJssmO2pQgjbfELsEFIjPshDpvvki6w5CWBiQTAXwVl27kUIcwVMKdn5AWzzc/4rYYZkxJP2C/e6dCF6MEpsEOrLh46wC2nLR9pbzwhUVIyHyt69X/IOMfGQh0H9ErOkAFbOuimzzMxMmU9MIyhkaHb6X4Cux7lyOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=V5FXtHiM; arc=none smtp.client-ip=209.127.230.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="V5FXtHiM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1753084336;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=iPv+sitKDBk+AkqJ/K8rYIXbyZ6KkpKpVwlxt13ZGCw=;
 b=V5FXtHiMAnfws8mMWpFs/k78FHEa3CiLXqsQDMWLAgyf++RVjq6p+03bXskDotQLhCQ6kQ
 RE0dOxFq4HK6RkPMb7gSdATJsfGLzHvnVUonnSVMvWE/HIknMGFYmixcd+gcow4bDK5yYV
 v6Pxc2VuelawTTLxITc0Xpz1Bx/UbAWge3k6HjJ7O4EmMROqzddFK03qF0epNxZaKR2obY
 Ruw3weJM17rCqwSX6ugSa8bt7PBDQoRNpZXiSyVEI6KMwJzgsJawDmoDCOPJlDtniVHqj0
 FK/SDPEe9grkOkIlvWyyzXRB2HjAi/PPRcIvAp7pB87UbGk7bhYO1SusZs1xNQ==
To: "Chunyan Zhang" <zhangchunyan@iscas.ac.cn>, 
	"Paul Walmsley" <paul.walmsley@sifive.com>, 
	"Palmer Dabbelt" <palmer@dabbelt.com>, 
	"Albert Ou" <aou@eecs.berkeley.edu>, "Alexandre Ghiti" <alex@ghiti.fr>, 
	"Charlie Jenkins" <charlie@rivosinc.com>, "Song Liu" <song@kernel.org>, 
	"Yu Kuai" <yukuai3@huawei.com>
Cc: <linux-riscv@lists.infradead.org>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, "Chunyan Zhang" <zhang.lyra@gmail.com>
User-Agent: Mozilla Thunderbird
Content-Language: en-US
X-Lms-Return-Path: <lba+2687df1ae+d57f97+vger.kernel.org+liujingqi@lanxincomputing.com>
From: "Nutty Liu" <liujingqi@lanxincomputing.com>
Subject: Re: [PATCH V2 1/5] raid6: riscv: Clean up unused header file inclusion
References: <20250711100930.3398336-1-zhangchunyan@iscas.ac.cn> <20250711100930.3398336-2-zhangchunyan@iscas.ac.cn>
In-Reply-To: <20250711100930.3398336-2-zhangchunyan@iscas.ac.cn>
Date: Mon, 21 Jul 2025 15:52:11 +0800
Received: from [127.0.0.1] ([116.237.111.137]) by smtp.feishu.cn with ESMTPS; Mon, 21 Jul 2025 15:52:13 +0800
X-Original-From: Nutty Liu <liujingqi@lanxincomputing.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <5c879527-221e-45df-86ea-b564ee49c473@lanxincomputing.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On 7/11/2025 6:09 PM, Chunyan Zhang wrote:
> These two C files don't reference things defined in simd.h or types.h
> so remove these redundant #inclusions.
>
> Fixes: 6093faaf9593 ("raid6: Add RISC-V SIMD syndrome and recovery calculations")
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> ---
>   lib/raid6/recov_rvv.c | 2 --
>   lib/raid6/rvv.c       | 3 ---
>   2 files changed, 5 deletions(-)

Reviewed-by: Nutty Liu <liujingqi@lanxincomputing.com>

Thanks,
Nutty
> diff --git a/lib/raid6/recov_rvv.c b/lib/raid6/recov_rvv.c
> index f29303795ccf..500da521a806 100644
> --- a/lib/raid6/recov_rvv.c
> +++ b/lib/raid6/recov_rvv.c
> @@ -4,9 +4,7 @@
>    * Author: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
>    */
>   
> -#include <asm/simd.h>
>   #include <asm/vector.h>
> -#include <crypto/internal/simd.h>
>   #include <linux/raid/pq.h>
>   
>   static int rvv_has_vector(void)
> diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
> index 7d82efa5b14f..b193ea176d5d 100644
> --- a/lib/raid6/rvv.c
> +++ b/lib/raid6/rvv.c
> @@ -9,11 +9,8 @@
>    *	Copyright 2002-2004 H. Peter Anvin
>    */
>   
> -#include <asm/simd.h>
>   #include <asm/vector.h>
> -#include <crypto/internal/simd.h>
>   #include <linux/raid/pq.h>
> -#include <linux/types.h>
>   #include "rvv.h"
>   
>   #define NSIZE	(riscv_v_vsize / 32) /* NSIZE = vlenb */
