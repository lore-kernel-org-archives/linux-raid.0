Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66C4C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 16:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D779611C2
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 16:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237434AbhJMQfU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:35:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55641 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237416AbhJMQfO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 13 Oct 2021 12:35:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634142790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TjCWmnE6MJF99gg8Np4o8A6IWCobyce/lSwyYSU7+H4=;
        b=O+FeHHOVrtnS98EfIseNxhRitaHuxUUbBpdtbWgJwcYv8H32PWQkq9f6XDSKaUvZWt37fQ
        +HPB3Re46x4kS73xb4L2zBam/2tD90HOKYIYT4A69BB99n72Mlsc5xLVFIEnThmy4M9DLL
        NUewrx4JYDW4ajlBqdvjzmKFyEg7WXU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-tdcZaU3pOpGKsu6-MGGMvA-1; Wed, 13 Oct 2021 12:33:09 -0400
X-MC-Unique: tdcZaU3pOpGKsu6-MGGMvA-1
Received: by mail-wr1-f71.google.com with SMTP id f11-20020adfc98b000000b0015fedc2a8d4so2486117wrh.0
        for <linux-raid@vger.kernel.org>; Wed, 13 Oct 2021 09:33:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=TjCWmnE6MJF99gg8Np4o8A6IWCobyce/lSwyYSU7+H4=;
        b=MzEYx/a3cgMDS0PAfC8RRcMO71pNgnK+sljipezhD+2a46E3e4mBdVOPRjEGYYk5m2
         RYtD4gIqOD0WVO17gL3bBKxBKrS+eN+Kk++7C9g5flKOuMfIf/JUMFX3/tNZ3YvfzfUA
         lFRY7pudhp0vBG+VHEPG9l2cf94DvlfcS8ESsbiyV7P/6kFYF3RrQ8NHrPNzAjF7BIlU
         SlBVGWQGstiIYUDH9cY9N6jQ5MYCSHvlRtOB5iahnDvsLxN8EbTqtc7jnsVbgbo8DjNV
         7MizrTh7GqlsRDo9hyU4G/AjpobluXIUPpOcDBchgkfLlLuiftsiIVJ+ScPttyns4lB2
         KCKQ==
X-Gm-Message-State: AOAM533U0+XcfPxnMrOiBD6/HiItsrNzzQzufGAjZ5zH8Izh9JJ1QqkQ
        xWBHM9z6XOZ2KRfXeG2QLXrYBKQqQQjL5xc+ZqXa6VUGVqDye8saivDvCyUnsgqtuCs4WPaRlOE
        RH/RJ5VtNJ0CC40V9HE5tPA==
X-Received: by 2002:a05:600c:354c:: with SMTP id i12mr268479wmq.59.1634142788084;
        Wed, 13 Oct 2021 09:33:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyATebHvkYdlIXZFLJ2uDSsgne/PQrLVCIJg9XLuSnik4UsKAxmcj1cRWI3KVGh8y6j1hSz/w==
X-Received: by 2002:a05:600c:354c:: with SMTP id i12mr268443wmq.59.1634142787798;
        Wed, 13 Oct 2021 09:33:07 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6774.dip0.t-ipconnect.de. [91.12.103.116])
        by smtp.gmail.com with ESMTPSA id i24sm5497209wml.26.2021.10.13.09.33.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 09:33:07 -0700 (PDT)
Message-ID: <e29733c7-e65a-935a-4e05-3a060240ea5a@redhat.com>
Date:   Wed, 13 Oct 2021 18:33:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Content-Language: en-US
To:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, axboe@kernel.dk
Cc:     alexander.h.duyck@linux.intel.com
References: <20211013160034.3472923-1-kent.overstreet@gmail.com>
 <20211013160034.3472923-2-kent.overstreet@gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH 1/5] mm: Make free_area->nr_free per migratetype
In-Reply-To: <20211013160034.3472923-2-kent.overstreet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Mostly LGTM. I recall that in some corner cases the migratetype stored
for a pcppage does not correspond to the pagetype of the pfnblock ... I
do wonder if that can trick us here in doing some accounting wrong., no
that we account free pages per mirgatetype.

>  	/*
>  	 * Set the pageblock if the isolated page is at least half of a
> @@ -6038,14 +6038,16 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
>  			struct free_area *area = &zone->free_area[order];
>  			int type;
>  
> -			nr[order] = area->nr_free;
> -			total += nr[order] << order;
> +			nr[order]	= 0;
> +			types[order]	= 0;

Why the indentation change? Looks unrelated to me.

>  
> -			types[order] = 0;
>  			for (type = 0; type < MIGRATE_TYPES; type++) {
>  				if (!free_area_empty(area, type))
>  					types[order] |= 1 << type;
> +				nr[order] += area->nr_free[type];
>  			}
> +
> +			total += nr[order] << order;
>  		}
>  		spin_unlock_irqrestore(&zone->lock, flags);
>  		for (order = 0; order < MAX_ORDER; order++) {
> @@ -6623,7 +6625,7 @@ static void __meminit zone_init_free_lists(struct zone *zone)
>  	unsigned int order, t;
>  	for_each_migratetype_order(order, t) {
>  		INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
> -		zone->free_area[order].nr_free = 0;
> +		zone->free_area[order].nr_free[t] = 0;
>  	}
>  }
>  
> @@ -9317,6 +9319,7 @@ void __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
>  	struct page *page;
>  	struct zone *zone;
>  	unsigned int order;
> +	unsigned int migratetype;
>  	unsigned long flags;
>  
>  	offline_mem_sections(pfn, end_pfn);
> @@ -9346,7 +9349,8 @@ void __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
>  		BUG_ON(page_count(page));
>  		BUG_ON(!PageBuddy(page));
>  		order = buddy_order(page);
> -		del_page_from_free_list(page, zone, order);
> +		migratetype = get_pfnblock_migratetype(page, pfn);

As the free pages are isolated, theoretically this should be
MIGRATE_ISOLATE.

> +		del_page_from_free_list(page, zone, order, migratetype);
>  		pfn += (1 << order);
>  	}
>  	spin_unlock_irqrestore(&zone->lock, flags);
> @@ -9428,7 +9432,7 @@ bool take_page_off_buddy(struct page *page)
>  			int migratetype = get_pfnblock_migratetype(page_head,
>  								   pfn_head);
>  
> -			del_page_from_free_list(page_head, zone, page_order);
> +			del_page_from_free_list(page_head, zone, page_order, migratetype);
>  			break_down_buddy_pages(zone, page_head, page, 0,
>  						page_order, migratetype);
>  			if (!is_migrate_isolate(migratetype))
> diff --git a/mm/page_reporting.c b/mm/page_reporting.c
> index 382958eef8..4e45ae95db 100644
> --- a/mm/page_reporting.c
> +++ b/mm/page_reporting.c
> @@ -145,7 +145,7 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
>  	 * The division here should be cheap since PAGE_REPORTING_CAPACITY
>  	 * should always be a power of 2.
>  	 */
> -	budget = DIV_ROUND_UP(area->nr_free, PAGE_REPORTING_CAPACITY * 16);
> +	budget = DIV_ROUND_UP(area->nr_free[mt], PAGE_REPORTING_CAPACITY * 16);
>  

I think we might want the total free pages here. If we want to change
the behavior, we should do it in a separate patch.


-- 
Thanks,

David / dhildenb

