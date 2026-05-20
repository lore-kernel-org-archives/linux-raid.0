Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3E9346AC2
	for <linux-raid@vger.kernel.org>; Wed, 20 May 2026 13:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779282422; cv=none; b=UrmeXrsYDN/VuVkL+Kt8DNfwaN60i7P6wDrd4Bvl82xk2zXWfc9fOz8YRIOQ821Hhx4R34cluZ9UZzC8zrQx9KET4NTy6N/SE8XvwWA8/keLiPlKbBRkO87SWFNft+44cyuWPshnYpacjqwvYAXebyOjy2RFf9e+HyTssvGNTM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779282422; c=relaxed/simple;
	bh=3pE7FwjMhrFLZ047m9z+vjvMVv5nChg0KsI2fRW7T6k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H+1K9LpztYPil8kvjqL0YoKDnFofDS5l6dYla2NWzuvuubWQGaOV7NeX7Qv9Z0NvDeSrrAZRO0V6cYxUARBdtFPZO4F7BJDqncKVHqh/T6qhgjz4akwUW7afJSl5AWcHaPCKf0ubT9Cu7lkW07gMwdxCegiFhW74LxDa6CdFtjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bl7KNaDA; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bl7KNaDA"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-44a044cb827so3495897f8f.0
        for <linux-raid@vger.kernel.org>; Wed, 20 May 2026 06:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779282419; x=1779887219; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5gunmBLjCjS6Gti7CYJba8OZxUFE4BT2dND5fh8wPSA=;
        b=Bl7KNaDA5U697R9al84oXEzdD004vzuEA67t/l8SkmJX75Dv0vBSAbry0XSED1nemE
         jVV5P8KSVbORS7mC6lODs1pqwyla5pLxaNsRNTFb0fAIl3OvIshGwB2S77pbNXxaoSjw
         5jLyUw1tyIN+e1wFivhdWSahIYjeCoj/FXgH1DVKWPiXOqjqO9CfqTptnRdKO/bRu/w1
         jnubOwniR0RNBTnHLBfT4OubIcJKmCMl24Oi8J/Orki0eR9skVHNZOyxL6maBSydfRVA
         sK09Os/4fCJE62+jTv3dCPbaZPSeqhJlnJ7UgCt48bFvidq9j7rd0jkU1y4t766c+Bv4
         AeAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779282419; x=1779887219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5gunmBLjCjS6Gti7CYJba8OZxUFE4BT2dND5fh8wPSA=;
        b=Vkv4cmEpZzfZT1D0QHXDBia8QmgH+jvUQ9hKmog5t8FrTijwi4NVPqG3CADcArak4n
         QWMyKMqdhWK+pTH423IG62YIJ+EtH9RdYR7eoLimFq5MyZw1uxWXWZF9DAhz5jU9yKf4
         9KykWB4qCEenoddWktCYH8N15jFN2lQwY9sj32bjbm/ISvSLXdy1K7bPKUH5BdRcraNV
         f4q6MMsYEjFj/uXwDAqoMxz5yy26AU1dnimjcbh3cCsBZo7rDRPYOiEVbhaUK1XBvrV8
         wpPXBwqyLW1PJpryCn9X265cM63JKuXFsGWr1glN9U4LpHDBfyWamQdi8YWDC8fWIr6G
         4O4g==
X-Forwarded-Encrypted: i=1; AFNElJ/KIRsU9SBO8wNSsjocvfKLRlIXT0yYqeWxFYKEy0OkBeiokvdAFW4qWYpEm0zPD9JI4pMJm3ljLcyX@vger.kernel.org
X-Gm-Message-State: AOJu0YzLXtzfYAGGhvs6jnadaB63l/u5RfxBjADloeUkznNycMGBO0Gj
	wky/K7dpx+Ig4gEg+5ZTpp6jRKW2iiybqC34YQTebSxVG4wR6xZ21IRh
X-Gm-Gg: Acq92OGMjLHjwiFpW85ZfMDnMUpMQNNiPvcGPGsj+ubYscMvbFGl8914N4FzgmG4Gdb
	M9FAcT5IQx3O3r6kXHEhDUX7lgVl9HphQNbVfYNHLM2KGEjSeG6BclzgRO8czaqVZMpZnpG+rUY
	Tbg4P3C5+BKoV8kWYfPnDhy2UcESwwo21S7wWELc7beKEvGT6vM3L/O/z+1wzg+hvv6BJZ68spJ
	sCIPo20EkhIMEAfafXwVXkZnV8GGdsv1YPtVNj99erTltxNiPDzGX1hBb1BQuQv9leJCIvdTTtx
	PV4xFWbVJscUTmQ5GGwAiTj/sSwHNRis3gONCqt0VB9axF4dBxLNLDSuA68/fvogmLWfFKTEGcz
	tbDNpBn7nDCEa3gUKtB2I/DMowNK/cPq8mua1xzQ99X5JMm5Wmo1v1sSCS6ymhWw+1muHgUBCy8
	d3LRJu/O0NP9N6Opehx5Px2OgpPd5gPILuSmYFjvvdMXgDspTOEGrpPAQ0M6jZ44wZXAbycFp18
	Fk=
X-Received: by 2002:a05:6000:2207:b0:45e:73eb:2a75 with SMTP id ffacd0b85a97d-45e73eb2ab3mr27313880f8f.16.1779282418850;
        Wed, 20 May 2026 06:06:58 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9e768bcesm56306140f8f.4.2026.05.20.06.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 06:06:58 -0700 (PDT)
Date: Wed, 20 May 2026 14:06:57 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, Li Nan
 <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/2] lib/raid6: use kmalloc() in raid6_select_algo()
Message-ID: <20260520140657.2b5b5f3b@pumpkin>
In-Reply-To: <20260520-lib-v1-2-cb3045bef2d8@kernel.org>
References: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
	<20260520-lib-v1-2-cb3045bef2d8@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 20 May 2026 11:17:52 +0300
"Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> raid6_select_algo() allocates an order 3 (8 pages) buffer that is used
> as a scratch area for selection of the best algorithm.

Should this code really be using a 4k buffer rather than a PAGE_SIZE one?

-- David

> 
> For such large allocations kmalloc() would fall back to alloc_pages() but
> still kmalloc() is a better API as it does not require unnecessary
> castings and may provide more debugging possibilities.
> 
> Replace __get_free_pages() call with kmalloc().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  lib/raid6/algos.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> index 799e0e5eac26..89e627c62e30 100644
> --- a/lib/raid6/algos.c
> +++ b/lib/raid6/algos.c
> @@ -12,6 +12,7 @@
>   */
>  
>  #include <linux/raid/pq.h>
> +#include <linux/slab.h>
>  #ifndef __KERNEL__
>  #include <sys/mman.h>
>  #include <stdio.h>
> @@ -129,7 +130,6 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
>  #endif
>  
>  #define RAID6_TEST_DISKS	8
> -#define RAID6_TEST_DISKS_ORDER	3
>  
>  static inline const struct raid6_recov_calls *raid6_choose_recov(void)
>  {
> @@ -250,7 +250,7 @@ int __init raid6_select_algo(void)
>  	int i, cycle;
>  
>  	/* prepare the buffer and fill it circularly with gfmul table */
> -	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
> +	disk_ptr = kmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);
>  	if (!disk_ptr) {
>  		pr_err("raid6: Yikes!  No memory available.\n");
>  		return -ENOMEM;
> @@ -275,7 +275,7 @@ int __init raid6_select_algo(void)
>  	/* select raid recover functions */
>  	rec_best = raid6_choose_recov();
>  
> -	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
> +	kfree(disk_ptr);
>  
>  	return gen_best && rec_best ? 0 : -EINVAL;
>  }
> 

