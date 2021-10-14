Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69AAAC433EF
	for <linux-raid@archiver.kernel.org>; Thu, 14 Oct 2021 15:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 413E860F36
	for <linux-raid@archiver.kernel.org>; Thu, 14 Oct 2021 15:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbhJNPMO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Oct 2021 11:12:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233350AbhJNPL7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 14 Oct 2021 11:11:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634224194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jTxRkwer/L1jMFbVHe+gmT8Lx5IDhS6y3cTZBhYxWZc=;
        b=V+NR87M6Ke+kFJ2EtEeR73PG6AmqBO24ZB74tC6610L/qviMPRbP4He5TibtZptsx0x/MY
        FSqKVGvQtr/QMVxUNsvQWgD22uKMyndh2oMNIUcIH8zwvCR4bJUqdGYEZuV0+Qm2WBkM22
        j8NF3awX3f43eTPWwCfXkuSfa6Ecayc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-ptQvEvyOMOOx3prtfk7T5A-1; Thu, 14 Oct 2021 11:09:53 -0400
X-MC-Unique: ptQvEvyOMOOx3prtfk7T5A-1
Received: by mail-wr1-f70.google.com with SMTP id l6-20020adfa386000000b00160c4c1866eso4811851wrb.4
        for <linux-raid@vger.kernel.org>; Thu, 14 Oct 2021 08:09:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=jTxRkwer/L1jMFbVHe+gmT8Lx5IDhS6y3cTZBhYxWZc=;
        b=m0X/6wD33oAqJosMHTudDtJtdfHA3LNk9elyQE/vk9v4joFrtqJBiXPYVB4I7rwmrt
         RwPMe3/WKSvjAsOeTbWRI7X+xhtzG21xknrnUmCN3zahu68oYHCa64Wf9cJkOlMIJlyE
         xTKkkALQwT6mDpvl2kk0y9nZURUaEjBlTcXFHxZ6CmidlpaT2yAsyKasNzTHiBMZJNJh
         /3YI0LBGXt1D42EAvKg/I/FUV3TIfVwgmMSKFlhp2eQGcajniQ7fOn45XavmBWqcVNbY
         8AEnSOzWU+kQnkvyuky9FTSF6KAVbtgyxWDOlK3G0ut4dfK7NvKQLzwQUcMmdPboCBVC
         dKug==
X-Gm-Message-State: AOAM532oGZOj+fboIVGBlXMbdkMWMV0qnWtRZ74KjgYg2I1dFE2ijohh
        5p1Vlr9rXZRBPLRZmeqKGf8SMMf2tFuC8Oi0Cz313nO5YQWFp+bYCFBPpqhpBgINcj6BvJb3Im1
        B2I8DJeH9IyoYsON+40+9tA==
X-Received: by 2002:a1c:29c7:: with SMTP id p190mr6271735wmp.65.1634224192158;
        Thu, 14 Oct 2021 08:09:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwspjmnn2UgF3wC80ffKADbfFGgTEqNvflKbpG+cgCWjua1idvpQ2j9r374S0fE1PxL0yFKA==
X-Received: by 2002:a1c:29c7:: with SMTP id p190mr6271697wmp.65.1634224191871;
        Thu, 14 Oct 2021 08:09:51 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c694e.dip0.t-ipconnect.de. [91.12.105.78])
        by smtp.gmail.com with ESMTPSA id p25sm7981463wma.2.2021.10.14.08.09.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 08:09:51 -0700 (PDT)
Message-ID: <eaa8ed55-f364-5518-0b30-3fec6bde99dc@redhat.com>
Date:   Thu, 14 Oct 2021 17:09:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 5/5] brd: Kill usage of page->index
Content-Language: en-US
To:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, axboe@kernel.dk
Cc:     alexander.h.duyck@linux.intel.com
References: <20211013160034.3472923-1-kent.overstreet@gmail.com>
 <20211013160034.3472923-6-kent.overstreet@gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20211013160034.3472923-6-kent.overstreet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 13.10.21 18:00, Kent Overstreet wrote:
> As part of the struct page cleanups underway, we want to remove as much
> usage of page->mapping and page->index as possible, as frequently they
> are known from context.
> 
> In the brd code, we're never actually reading from page->index except in
> assertions, so references to it can be safely deleted.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> ---
>  drivers/block/brd.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index 58ec167aa0..0a55aed832 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -72,8 +72,6 @@ static struct page *brd_lookup_page(struct brd_device *brd, sector_t sector)
>  	page = radix_tree_lookup(&brd->brd_pages, idx);
>  	rcu_read_unlock();
>  
> -	BUG_ON(page && page->index != idx);
> -
>  	return page;
>  }
>  
> @@ -108,12 +106,10 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
>  
>  	spin_lock(&brd->brd_lock);
>  	idx = sector >> PAGE_SECTORS_SHIFT;
> -	page->index = idx;
>  	if (radix_tree_insert(&brd->brd_pages, idx, page)) {
>  		__free_page(page);
>  		page = radix_tree_lookup(&brd->brd_pages, idx);
>  		BUG_ON(!page);
> -		BUG_ON(page->index != idx);
>  	} else {
>  		brd->brd_nr_pages++;
>  	}
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

