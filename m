Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6A310F1
	for <linux-raid@vger.kernel.org>; Mon, 19 Oct 2026 00:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792369655; cv=none; b=NSef9blLOMPvI4xY+tcWuFNR3b+3H0ANK0103C412dZ2m7eAGmj8e2We152pMcLBSQExFGektIsTYroci0yV1O6ZwLSudQypTPhQiweYBPY1xky8ZDTmXaUJoy07UFtaZ4znSSvFjThy5qC0WMQxfL5NlGnDS2wriMqOGswveco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792369655; c=relaxed/simple;
	bh=DcNC5JqAop2940F+ZHsuOWPvmFKGsq60CzpZ/ZL4XEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=HNcjX400LrCIbKTTo39VOFWzLN+rJpsfr5gWYrB7n55whelkScsaqaov/RQnOW2z4ZI8liVC/OMpGrw+ZAdf2LFRgynmqJplZxiB8obfu+KZtv/FW1Ck+c6IQMfVBHtQtfPcIu0rIAC1LW6TbIgvAI0yVR0lZDMNXwIPn4SC9XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K6ne6XPP; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K6ne6XPP"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e934449bb0so13704015ad.0
        for <linux-raid@vger.kernel.org>; Sun, 18 Oct 2026 17:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792369654; x=1792974454; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:cc:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=p9/9pP8tSRbRvmGnH8l8O7whlqIOrMQawgFdBIhtXHk=;
        b=K6ne6XPP/krhttF/sxqSjBJLr/nhflEDop+jDwWcoOzEj3S+5kvRNeMRYG4vuy+8am
         s1uHhUNVPlnLpCypoLD+bFXmQHXO0Tk1W05xYteTxn1ZabZuaXBL7XbdeY8uskiwiDoQ
         knDG+MYn1mZmn7QwC5kjaWlSQa9dNpK5V3HG6qWyCeHsm/jBVgPnUzJzjD2PK9AnGLV8
         GmUKrrR2vfmYiX6Kwz92mmGr0JFt4HSbWPZYvED6R/7N+MMjXhrCHeKr5Kb+4a6rIAT2
         nng5EubHBfAIGXZtTPyaSsgr+z4wOo46UIAZ9eDAvIDJYU2zUTE/b9hibO4+JDiTU9fq
         K7cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792369654; x=1792974454;
        h=content-transfer-encoding:content-type:in-reply-to:cc:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p9/9pP8tSRbRvmGnH8l8O7whlqIOrMQawgFdBIhtXHk=;
        b=G2CivXjBFTg4VPM3k56oAmqXH/ndbSa1VXlsU7+tvobSbjABzHo9DvD+gWf2tJH6jQ
         wogwKw76hiYJbFPLNfrTVMMmq1QawaMGBYJ/7gXkCAURiUwd+QKBW92L7xrkczMgOHSa
         LQf2G+ZytGQeLzu01G64xa2R/YvzXtBZeLae5XpN8fWA/YX9kxqpAwZAZwwgv7newNYx
         Qjkazo7OvMFl6ln6E3AnIMiZmV2SYuabgwCLbRd9PiI5q3LZo9ZlpCDYOEHrZTYkVE0G
         NBKUg6lAIEocfWYkpZ4Y88BXKxQBkQ6iJIahSc3h326sY8Uy6EpwC97iqF6nkKHesnkO
         OsNw==
X-Forwarded-Encrypted: i=1; AKwUvBw52s2PkhQx39g5y9w5bqlSiNJ7de+TtZ0q/IVehUe9m98C0ZEUOZbKS+O6aRIaP0hkAVgEx2f/NMaw@vger.kernel.org
X-Gm-Message-State: AFq9FYKdWqiIpKgY4W3/1Ib/LwOT2ebiJrGn+/mFQqVeH169ABynaurc
	L90TgQA7dzRf3ROT5h6lZyE5SHCD8PMVQdjM8MDwHBOjRQxNEX96Gcle
X-Gm-Gg: AYBFou2tGHs2h1NjqAeTfQeIdvs+18Ki4ecOfsru/qLn566ZFQXclXjogjqnSsXE6qR
	ejpXovlrgngv92NT1tJ5guKq9yVroJtFLLU9WklrOg+divFS1U2wfM1ecZ8/m4V3KskdZ7B/p3M
	RV0xx96yKO7sfU2Q+VlHfh3H+HloxtMEF7zMfyMh3Pp7QoS2XOnAWWkQdMoldTwZtwRk2wl334k
	p/zNPtc2hapnjunQuq6AZk/2IsjaREGzEm6V3Jxs2Y25SSlfO9/P71/+7Z/zgZiVkjIG6s7KyJG
	l6uSz5vD3RRLA7ftSOyY5P/FaqACY+CGcFa08M67Zcnlaz82uAP3LywxSY3x2sTpqLp4I97dga3
	LEMJCkYrgZ1+JATiLEEWsvsELp0pqthPT4MhOiLDWvDGChYpVxMi6/sFw55k2ijNG2BIl3IXQoX
	WUjd4SpF0duktwfPhUtCqWwzcXmXQqMysJ1uT1G7+d+dTOtib6Xx+PviP2tRf0WqKu18H+vVqjp
	EwNw66ZX5iE+kL7hoc=
X-Received: by 2002:a17:90b:48c2:b0:3aa:6b5d:a018 with SMTP id 98e67ed59e1d1-3acef57d165mr4987357a91.67.1792369653799;
        Sun, 18 Oct 2026 17:27:33 -0700 (PDT)
Received: from [10.55.55.45] ([172.103.152.75])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac94627250sm18219426a91.8.2026.10.18.17.27.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2026 17:27:33 -0700 (PDT)
Message-ID: <ab359253-846e-4a8b-944e-06718b17a315@gmail.com>
Date: Sun, 18 Oct 2026 17:27:31 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/4] md/raid5-ppl: replace async_tx with synchronous
 xor
To: Frank.Li@oss.nxp.com
References: <20261015-asycn_tx_remove-v1-0-056a7085e0a1@nxp.com>
 <20261015-asycn_tx_remove-v1-2-056a7085e0a1@nxp.com>
Content-Language: en-US
From: Alex Naylor <alex.r.naylor@gmail.com>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
 Dan Williams <djbw@kernel.org>, linux-raid@vger.kernel.org
In-Reply-To: <20261015-asycn_tx_remove-v1-2-056a7085e0a1@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Frank,

I encountered a PPL recovery failure that appears relevant to this 
proposal, on a QNAP TS-410 (Marvell Kirkwood, ARMv5).

The system runs a custom Linux 6.1-based kernel with CONFIG_MV_XOR=y and 
CONFIG_ASYNC_TX_DMA=y, plus a local PCIe startup-reset patch. Storage is 
a four-member RAID5 with metadata 1.2, 512 KiB chunks and PPL enabled.

After a power outage, array startup hit:

kernel BUG at crypto/async_tx/async_tx.c:269!
PC: async_tx_quiesce
LR: ppl_xor [raid456]

The call trace included:

async_tx_quiesce
ppl_xor
ppl_recover_entry
ppl_init_log
raid5_run
md_run
do_md_run

All four members had matching event counts and valid superblock 
checksums, with no members marked failed.

The apparent issue is that ppl_xor() submits with ASYNC_TX_ACK, then 
passes the returned descriptor to async_tx_quiesce(), which asserts that 
it is not already acknowledged.

Disabling both Marvell XOR engines through their device-tree status 
properties, while retaining the same kernel binary and modules, allowed 
the existing array to assemble and the filesystem to recover. No forced 
assembly, array recreation or PPL-policy change was used. File transfers 
are working again.

I have not tested this RFC or reproduced the crash on a current kernel. 
Source inspection found the same ACK/quiesce sequence in v6.1.190 and 
current mainline.

I’m sharing this because the ppl_xor() change below removes the exact 
ACK/quiesce sequence implicated in my crash. I haven’t tested your 
patch, but disabling hardware XOR allowed recovery to complete on the 
same kernel.

Thanks,

Alex

On 2026-10-15 12:22, Frank.Li@oss.nxp.com wrote:
> From: Frank Li <Frank.Li@nxp.com>
>
> Remove the async_tx dependency from ops_run_partial_parity() and
> ppl_xor().  The function now returns void and operates synchronously:
>
> - count==1: copy_page() replaces async_memcpy
> - count>1:  memcpy + xor_blocks() replaces async_xor
> - ppl_xor(): xor_blocks() replaces async_xor + async_tx_quiesce
>
> Drop #include <linux/async_tx.h> and add #include <linux/xor.h>.
>
> Signed-off-by: Frank Li <Frank.Li@nxp.com>
> ---
>   drivers/md/raid5-ppl.c | 40 ++++++++++++++++------------------------
>   1 file changed, 16 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
> index 7f8a9d3fd578d..bd844b4e8b372 100644
> --- a/drivers/md/raid5-ppl.c
> +++ b/drivers/md/raid5-ppl.c
> @@ -8,7 +8,7 @@
>   #include <linux/blkdev.h>
>   #include <linux/slab.h>
>   #include <linux/crc32c.h>
> -#include <linux/async_tx.h>
> +#include <linux/raid/xor.h>
>   #include <linux/raid/md_p.h>
>   #include "md.h"
>   #include "raid5.h"
> @@ -154,14 +154,11 @@ struct ppl_io_unit {
>   	struct bio_vec biovec[PPL_IO_INLINE_BVECS];
>   };
>   
> -struct dma_async_tx_descriptor *
> -ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu,
> -		       struct dma_async_tx_descriptor *tx)
> +void ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu)
>   {
>   	int disks = sh->disks;
>   	struct page **srcs = percpu->scribble;
>   	int count = 0, pd_idx = sh->pd_idx, i;
> -	struct async_submit_ctl submit;
>   
>   	pr_debug("%s: stripe %llu\n", __func__, (unsigned long long)sh->sector);
>   
> @@ -186,20 +183,20 @@ ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu,
>   				srcs[count++] = dev->page;
>   		}
>   	} else {
> -		return tx;
> +		return;
>   	}
>   
> -	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, tx,
> -			  NULL, sh, (void *) (srcs + sh->disks + 2));
> -
> -	if (count == 1)
> -		tx = async_memcpy(sh->ppl_page, srcs[0], 0, 0, PAGE_SIZE,
> -				  &submit);
> -	else
> -		tx = async_xor(sh->ppl_page, srcs, 0, count, PAGE_SIZE,
> -			       &submit);
> +	if (count == 1) {
> +		copy_page(page_address(sh->ppl_page), page_address(srcs[0]));
> +	} else {
> +		void *dest = page_address(sh->ppl_page);
> +		void **ptrs = (void **)srcs;
> +		int j;
>   
> -	return tx;
> +		for (j = 0; j < count; j++)
> +			ptrs[j] = page_address(srcs[j]);
> +		xor_gen(dest, ptrs, count, PAGE_SIZE);
> +	}
>   }
>   
>   static void *ppl_io_pool_alloc(gfp_t gfp_mask, void *pool_data)
> @@ -706,15 +703,10 @@ void ppl_stripe_write_finished(struct stripe_head *sh)
>   
>   static void ppl_xor(int size, struct page *page1, struct page *page2)
>   {
> -	struct async_submit_ctl submit;
> -	struct dma_async_tx_descriptor *tx;
> -	struct page *xor_srcs[] = { page1, page2 };
> -
> -	init_async_submit(&submit, ASYNC_TX_ACK|ASYNC_TX_XOR_DROP_DST,
> -			  NULL, NULL, NULL, NULL);
> -	tx = async_xor(page1, xor_srcs, 0, 2, size, &submit);
> +	void *dest = page_address(page1);
> +	void *ptrs[2] = { dest, page_address(page2) };
>   
> -	async_tx_quiesce(&tx);
> +	xor_gen(dest, ptrs, 2, size);
>   }
>   
>   /*
>
