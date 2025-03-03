Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA731D516A
	for <linux-raid@vger.kernel.org>; Mon,  3 Mar 2025 03:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740973425; cv=none; b=GVGaoSPX8pTm+C/QbQtsJHU1XVeeKCswp2fp7YTSgOiP1zD2zdEZcTU2r6kw3MM5k1qm0pDC+OXMQR2P3GiXTt294xr/QxLm0iy/BCnR320OK7c2i/hpR6y4bVgfrk+BrExb0huy6KltygHMzDRJt1bsGwdlb+nFueA3jYp/BKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740973425; c=relaxed/simple;
	bh=qXz0Ls+ZNHn5aWBaWxDYhN7mV6FNBygU4b6AW8iVh8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ap1jOESATSuFnHM3XPgiOBvG8QQZQQWGUPXBdLKBG/jvdstlSIPLMWRw9Fakd5tbpTNUnkX1y0yIbrjQcQfjL6ym3YmRIHThfKXGZOjkShCyvW2sdUMbKcClInm+K2XpGVy6QRyK6Ze+Y1Omuk7YmvxsOB5Llu8+gDyGplhpO0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Bi35UzR5; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Bi35UzR5"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-abf709dd679so19750066b.2
        for <linux-raid@vger.kernel.org>; Sun, 02 Mar 2025 19:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1740973421; x=1741578221; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BWYn99vUTraIvW6MH48WRwbKJeX4GNleBgwgF2O5OEA=;
        b=Bi35UzR50rPSCsUN8CoaKtyegxfYeIy0qeJe1TFCfYuo/iTR/c84isE76UfDgyY+aG
         ZVz2+E5+fWQMKwRC3EvRF2SMzzPlXNpqmkN0ebmnQMoY4q2wj+imXvAlv/6G0pxd7/R7
         Q/pQnW1727lKaW75rAvXh8uBddAC3LxYkTthnpVbWm3ayUGpYSpuhr5KCWgUI7XByLJO
         dIGOw+4Ks9VzOM136hNnsqf/nTjAZYbIFG39I8hgRTHN8DxjO6c12G+lO2JfSlTrYlL7
         tPi90kxOi+5NDwudSs8CZN/TP8796tDO6sOx48RCS6+85fJRaVL3W2JHTGjMnEGcohoy
         FMmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740973421; x=1741578221;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BWYn99vUTraIvW6MH48WRwbKJeX4GNleBgwgF2O5OEA=;
        b=MYzEIUZLpdiELzNP8Iv5ogk2KzY+dnPzCCVk15SSoygT1YA0yLRKXMqww6W/30SMhx
         apSGzBhUtkJRq5CznI0MSI1p9NAiTA14gMyCLxjXO76+8Fn6OlAXT+7nD3aPOj3mS6bI
         2V+qv4B4Gc9cd9yvmoM/BJYitriIj6blVdN8ukFGUojgihSDvaGupbb3ntjfYNuiGi5s
         BUWUmxUM0z0SndRcuwr56KVjcVK3zQDgX8N0vPrPivoCGpuRcOBwFQYGWhf29B7fXQll
         W4uNsNXPENhlUiLrgs4laIfsxkg4VY6l03vypQb/BLRPY0B72OOYzL1GNlibAL5BHiqb
         bCkw==
X-Forwarded-Encrypted: i=1; AJvYcCUGVQWBWegjWtIBdD4i46ZUvC/smwi+zW7b5gA2ZRKa4wdXdP00LlyxMPz87y2UeYco9QWuemgsI1S2@vger.kernel.org
X-Gm-Message-State: AOJu0YxKpHZhcFa56ueJGyCQLpS1jl5lnjssgF9IhdFIVtQoyA/oHZpW
	t3pEer2Lqj5J/3Gfv4bhhRi+IKX8rz9GxqKxp0rnNoKWTGMs9xsKtz0leM5XCotqdHbj2EQaAun
	TwL4=
X-Gm-Gg: ASbGncsZw1Lep+lOVDBnzHUxk+AX7S+shh8y0ypu2P+7KcN+N2YcJ6rQLuJ4mVA6drc
	Z8gwjPEak8J86r6oNUgGXR26v2s8J3OHuuyKlk+3mOd4A7VNgzp5miEJ+djAhO6sq9IreIrAuw9
	G7iPPPMh8LjZ2ONti9RjcImzBEIpmxg4mgRM5CVIwbwo4dfBfzMOkCHDMA7jEq5inolbmsYA9qZ
	5irAtpS7k04fUYn5yWRaecp32HgPl5BS8rn1QelDHqbIeT+UTnL0FEfyc5+zp1Kz0JaXQF8/wLr
	ZnPWSa4es1TjAcfjy7mgoZVizrCnbIa5q6Qy2vJWEvDvlE3WZSk=
X-Google-Smtp-Source: AGHT+IEmocBJhbz0B/X36KyyG28rbB9CYrFnuBNGG0Odh1JlD9Zr5SKBQ+ZowU+sCfIHrOV6gHgk3w==
X-Received: by 2002:a05:6402:1e89:b0:5e0:8dfe:1c9c with SMTP id 4fb4d7f45d1cf-5e4d6ba82e5mr4167123a12.9.1740973421479;
        Sun, 02 Mar 2025 19:43:41 -0800 (PST)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501d279csm67808285ad.44.2025.03.02.19.43.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 19:43:40 -0800 (PST)
Message-ID: <2d8b5981-7648-4f7c-8157-5d6bb0822bda@suse.com>
Date: Mon, 3 Mar 2025 11:43:36 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] md/md-bitmap: fix wrong bitmap_limit for clustermd
 when write sb
To: Su Yue <glass.su@suse.com>, linux-raid@vger.kernel.org
Cc: hch@lst.de, ofir.gal@volumez.com, yukuai3@huawei.com, l@damenly.org
References: <20250303033918.32136-1-glass.su@suse.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20250303033918.32136-1-glass.su@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/3/25 11:39, Su Yue wrote:
> In clustermd, separate write-intent-bitmaps are used for each cluster
> node:
> 
> 0                    4k                     8k                    12k
> -------------------------------------------------------------------
> | idle                | md super            | bm super [0] + bits |
> | bm bits[0, contd]   | bm super[1] + bits  | bm bits[1, contd]   |
> | bm super[2] + bits  | bm bits [2, contd]  | bm super[3] + bits  |
> | bm bits [3, contd]  |                     |                     |
> 
> So in node 1, pg_index in __write_sb_page() could equal to
> bitmap->storage.file_pages. Then bitmap_limit will be calculated to
> 0. md_super_write() will be called with 0 size.
> That means the first 4k sb area of node 1 will never be updated
> through filemap_write_page().
> This bug causes hang of mdadm/clustermd_tests/01r1_Grow_resize.
> 
> Here use (pg_index % bitmap->storage.file_pages) to make calculation
> of bitmap_limit correct.
> 
> Fixes: ab99a87542f1 ("md/md-bitmap: fix writing non bitmap pages")
> Signed-off-by: Su Yue <glass.su@suse.com>

Looks good to me
Reviewed-by: Heming Zhao <heming.zhao@suse.com>

> ---
> Changelog:
> v3:
>      Amend commit message suggested by Heming.
> v2:
>      Remove unintended change calling md_super_write().
> ---
>   drivers/md/md-bitmap.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 23c09d22fcdb..9ae6cc8e30cb 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -426,8 +426,8 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
>   	struct block_device *bdev;
>   	struct mddev *mddev = bitmap->mddev;
>   	struct bitmap_storage *store = &bitmap->storage;
> -	unsigned int bitmap_limit = (bitmap->storage.file_pages - pg_index) <<
> -		PAGE_SHIFT;
> +	unsigned long num_pages = bitmap->storage.file_pages;
> +	unsigned int bitmap_limit = (num_pages - pg_index % num_pages) << PAGE_SHIFT;
>   	loff_t sboff, offset = mddev->bitmap_info.offset;
>   	sector_t ps = pg_index * PAGE_SIZE / SECTOR_SIZE;
>   	unsigned int size = PAGE_SIZE;
> @@ -436,7 +436,7 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
>   
>   	bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
>   	/* we compare length (page numbers), not page offset. */
> -	if ((pg_index - store->sb_index) == store->file_pages - 1) {
> +	if ((pg_index - store->sb_index) == num_pages - 1) {
>   		unsigned int last_page_size = store->bytes & (PAGE_SIZE - 1);
>   
>   		if (last_page_size == 0)

