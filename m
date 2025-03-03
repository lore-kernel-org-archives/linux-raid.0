Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1779F3C3C
	for <linux-raid@vger.kernel.org>; Mon,  3 Mar 2025 03:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740971314; cv=none; b=sNWgrPN1Ea48OW1SY33iui2ObcP7TwOZVo/SPBM8Cnb9CGADs5BJ+5dBe2FBg2pfh4djDeuuHaevf6MZze5flRxrW94DA0H/fhPnJ7nUoCWTG4A5hrYBSzV8/2mr7xMNFyIc9iLJbpdj8WarIFjiLu8CW5BvPdFEwcqhtvt+ykE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740971314; c=relaxed/simple;
	bh=440fKd3UNMwlwo+plccK+HtANI+3sL5K9m1WPzuWDc4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cbd1Lb1HRegMbt2G93SkNtdxZLzvzl9SIu9wVA8+5Cl0kGO+VfCXEiziBs5BLoMGJ7MlzKJExgv8VA7A5SuxMmqO5GpEhcY0GoF/vR/g1FNnGfFLtcnpkQJ0rY8UrLGkdozGRDdR58ee9sKQJoqQsKIsgPg2BWSYjMWdSMJ4g3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NEAr3hSN; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NEAr3hSN"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-abc28af1ba4so89469066b.1
        for <linux-raid@vger.kernel.org>; Sun, 02 Mar 2025 19:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1740971310; x=1741576110; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hP5a/itPR+SxUB4xFyr5eW0Pkvy9qA+nGq68Ne9ChsA=;
        b=NEAr3hSNJpiNIHJRTmlbROfLEedeNuQ6if42A/6cnLh63RvYbuSqlucPewPwkZtNbH
         JZvtNdfLBChHAReAPrAzPCYMWHrMu6RaEMWHTdRtkQIAHoSpgX4392XNVcKM7R0ujMEk
         /4tJo2eNVandhZNU1R6qg6vXI8qvEjvmrftXKInHSqvEqNwHhLP13SfCCGD56LRs/JDP
         xkQNSjTlmRuVIoJkmy2XgXJfUvb8jCp0m59k3RsmXPpiKPtmJ1n9pSD7m7jWuhmQTFPO
         CxpaN9B6Dc+5/93sReasC1XOyKkZFdF92Z91GczXwoaFF3Ww0qx4VdCID5hGrJ3qdq5T
         6UBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740971310; x=1741576110;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hP5a/itPR+SxUB4xFyr5eW0Pkvy9qA+nGq68Ne9ChsA=;
        b=LOhiBmNnsmnSdmOtdHoAcRq1KGC9DqdnU5XvfKiiXIYHOqAi1OHNBCp90csf2uyvR/
         o1X2fDPbN7oclEFzc5F18Q+3v1UJ6LQgj99PXvuLcY3Lsr7f12LkPXE9NNMEDCiFUkFV
         3fyG6Dzv//DOrOHkomNjOZjnIKsnt+GHIQa5zByom+/0QhaIiyTWgyfJxd083Fcboe5q
         b8IU5Pk2fkbLo8L3fl5BG8PWr6lRIoeUSaRW1U1U1bAT0dMo9WNJxrktNKBi7f780n+4
         FM24rlQJnmNIWJSup9J3Am9q3m9TvKSm9KLYwUUi2IUu2X9mjXze52dO3axTqP7h2LDu
         g2ig==
X-Forwarded-Encrypted: i=1; AJvYcCXghNWPcVl3W+IKi2CH7yFBAqjlPUB8u9s8NOZjH/AVp2r0SzML7vIUJ+okFwLDyymNs7scxwvrTUyQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp9tkceAduhUecYiYzfEn1bQIYpENyS+kVD2FgHvPdp3aszTZC
	QHXEcYb27fNFNPrwOqlQgWmcPm24gHJmfXy7MGvCeM9DQqfaMywY/e++sBLrnQg=
X-Gm-Gg: ASbGnctFr9ZRDLfCAeM6MIcRIPZLkbfRu7dhKbUVuoZUd2maNI6eQyd4UPaU5/C2bbg
	pBPYnL4qDT8g8KOxnrslxfsLFawfUi/9+WKKT7R2FkZDkG/UEwL1N/zXNkV9DUAMASqAH8w5EWh
	/3vrWAffw9sp8nXfogLkDlJv+WqQanIcAXdyPEl3MNBOY4buuMqZp83EJlKqz7FTe9j8ksI0gzF
	hupllnO4CMzMqbHkYP1TmeF8Z2QoflKzB6IFeIdK+dwA4ri4331dlcpQA3rgVabKpShSFitLUMC
	naRgDldUehY/+1GDFZa6GbedOCQjbvOk3mySsH7dE+tUswcZpRA=
X-Google-Smtp-Source: AGHT+IHzA2gHEZY4+NIFXyZnKZ03cfV6935pjPdMO23F51TrQiZFrDdwwkNxNXXaZ3VJB7VjOKYj+w==
X-Received: by 2002:a05:6402:2694:b0:5d0:d183:cc11 with SMTP id 4fb4d7f45d1cf-5e4d6acd351mr5142711a12.2.1740971310289;
        Sun, 02 Mar 2025 19:08:30 -0800 (PST)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22350531c78sm67216225ad.241.2025.03.02.19.08.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 19:08:29 -0800 (PST)
Message-ID: <5925f944-be6a-4f49-9946-a77ef4d3c2f3@suse.com>
Date: Mon, 3 Mar 2025 11:08:25 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] md/md-bitmap: fix wrong bitmap_limit for clustermd
 when write sb
To: Su Yue <glass.su@suse.com>, linux-raid@vger.kernel.org
Cc: hch@lst.de, ofir.gal@volumez.com, yukuai3@huawei.com, l@damenly.org
References: <20250302043905.95887-1-glass.su@suse.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20250302043905.95887-1-glass.su@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Glass,

The code looks good to me.
The commit log needs to be revised.

On 3/2/25 12:39, Su Yue wrote:
> In clustermd, Separate write-intent-bitmaps are used for each cluster
> node:

Change 'Separate' to lowercase 'separate'.
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
> That means node the first 4k sb area of node 1 will never be updated
> through filemap_write_page().

"That means node the ...", should remove the word 'node'?

- Heming

> This bug causes hang of mdadm/clustermd_tests/01r1_Grow_resize.
> 
> Here use (pg_index % bitmap->storage.file_pages) to calculation of
> bitmap_limit correct.
> 
> Fixes: ab99a87542f1 ("md/md-bitmap: fix writing non bitmap pages")
> Signed-off-by: Su Yue <glass.su@suse.com>
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

