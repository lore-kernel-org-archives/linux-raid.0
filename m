Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323A415852F;
	Sun, 16 Mar 2025 04:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742097993; cv=none; b=UCwRbpMyo7V4jeiwCssEX2XD879iZ6GxI9g8Vlf96mP/B9w5OchuBoooiWtzC3RbnkIqdD6l/NiwSO727LdffjLKnqqKBzX+ZWt/MjomSBO/Dt2y7z1WTgCiIHGI/vNFNyH7EzAun+VVUPDzlZaGHNhtYCvJk7EScC7rLSU6sQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742097993; c=relaxed/simple;
	bh=leamfZRJ+S6XKKZg2yDcY/8afEbTZ//r1GenVNsXW8U=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=JFCENrAImgEvvz4k9teailkSpFyiQ0Pd+2Agy0QDV39E60JMLNax6VUmghm/h82NxaKtFoJ6DwcdQqDrlwb/qdCRv0r4Y0K7ifT85i1qKKc+jtD5uYd22MOBpUS3qMdqKJKCj71Ld8mq2eXqe5iYv1qEeJXWqIOn3L2cjlGoP+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JvJu8Gdm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JvJu8Gdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CABC4CEDD;
	Sun, 16 Mar 2025 04:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742097992;
	bh=leamfZRJ+S6XKKZg2yDcY/8afEbTZ//r1GenVNsXW8U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JvJu8GdmY19GxPIRPkgYx2xH28rv7FlDiUsgfLydaBcPiAX8rUNC4XEyx5x5JTddW
	 N/ApwqhHScpHmDaX4NRj14vNIIYh1CKldc458n6r965ysSiZbktLq7NJmFyEmc5eaY
	 4teM6Apk2Fe9oXdQbz3Bf1ldSMsTY3ub+nUqslXY=
Date: Sat, 15 Mar 2025 21:06:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Song Liu
 <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, linux-raid@vger.kernel.org
Subject: Re: [PATCH] lib/raid6: Replace custom zero page with ZERO_PAGE
Message-Id: <20250315210631.d79637b9c55c7ee3287aa426@linux-foundation.org>
In-Reply-To: <Z9U0_uj1E2MlYhGx@gondor.apana.org.au>
References: <Z9U0_uj1E2MlYhGx@gondor.apana.org.au>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 15 Mar 2025 16:06:22 +0800 Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Use the system-wide zero page instead of a custom zero page.
> 

I'll assume the MD maintainers will process this.

> --- a/include/linux/raid/pq.h
> +++ b/include/linux/raid/pq.h
> @@ -11,8 +11,9 @@
>  #ifdef __KERNEL__
>  
>  #include <linux/blkdev.h>
> +#include <linux/mm.h>
>  
> -extern const char raid6_empty_zero_page[PAGE_SIZE];
> +#define raid6_empty_zero_page ((const char *)page_address(ZERO_PAGE(0)))

This will of course meet the aligned(256) requirement. 

I do think it would be nicer to write this as a real inlined C function
and to convert usage sites to raid6_empty_zero_page().  IOW, let's tell
the truth rather than pretending that raid6_empty_zero_page is a global
variable.

>  #else /* ! __KERNEL__ */
>  /* Used for testing in user space */
> diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> index cd2e88ee1f14..03f1a8c179f7 100644
> --- a/lib/raid6/algos.c
> +++ b/lib/raid6/algos.c
> @@ -18,9 +18,6 @@
>  #else
>  #include <linux/module.h>
>  #include <linux/gfp.h>
> -/* In .bss so it's zeroed */
> -const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(256)));
> -EXPORT_SYMBOL(raid6_empty_zero_page);
>  #endif

Is there any possibility that the MD drivers will point DMA hardware at
the global zero page, thereby invalidating that page from CPU caches in
some manner?
