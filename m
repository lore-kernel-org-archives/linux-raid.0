Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE5AC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Oct 2021 07:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94AE56124F
	for <linux-raid@archiver.kernel.org>; Mon, 18 Oct 2021 07:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhJRHqy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Oct 2021 03:46:54 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33280 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhJRHqx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Oct 2021 03:46:53 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7A87721A6B;
        Mon, 18 Oct 2021 07:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1634543081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uRitaSdTVQaJHWkcEYYfsZh1e5H5O4Y2u6C6EN9RHZw=;
        b=gUoGOZZobYJpoYjwU2IYPymMA2YuQ+2qgz7MpnioolDyxfQi34gjYGErciu7THulCvDIqH
        E7qmjTjvluoTqPaG4qvEl19HG8kMSL6uyXSBA/+xPDdly7aws8Gi9L8GNw+9p5mYyMAd4V
        djR7gC7CKd0VOHwEq/c5fpRQ7D+qZ2o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1634543081;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uRitaSdTVQaJHWkcEYYfsZh1e5H5O4Y2u6C6EN9RHZw=;
        b=fIfevUhOPCPCtiqRALZ1/X9QKxZrhIYuKH49E96y7E0LnvrY8Z1tbgxJtHXE3fpRTpSYki
        Fq56TopyYm6xSyBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 504DD13CC9;
        Mon, 18 Oct 2021 07:44:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wgNzEuklbWFDFgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Mon, 18 Oct 2021 07:44:41 +0000
Message-ID: <11b2fa69-ebcf-fec4-73e5-51ada24c5aaf@suse.cz>
Date:   Mon, 18 Oct 2021 09:44:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Kent Overstreet <kent.overstreet@gmail.com>,
        David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, axboe@kernel.dk,
        alexander.h.duyck@linux.intel.com,
        David Rientjes <rientjes@google.com>
References: <20211013160034.3472923-1-kent.overstreet@gmail.com>
 <20211013160034.3472923-2-kent.overstreet@gmail.com>
 <e29733c7-e65a-935a-4e05-3a060240ea5a@redhat.com>
 <YWhCp/lKbJS9XSqn@moria.home.lan>
From:   Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 1/5] mm: Make free_area->nr_free per migratetype
In-Reply-To: <YWhCp/lKbJS9XSqn@moria.home.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/14/21 16:45, Kent Overstreet wrote:
> On Wed, Oct 13, 2021 at 06:33:06PM +0200, David Hildenbrand wrote:
>> > @@ -9317,6 +9319,7 @@ void __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
>> >  	struct page *page;
>> >  	struct zone *zone;
>> >  	unsigned int order;
>> > +	unsigned int migratetype;
>> >  	unsigned long flags;
>> >  
>> >  	offline_mem_sections(pfn, end_pfn);
>> > @@ -9346,7 +9349,8 @@ void __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
>> >  		BUG_ON(page_count(page));
>> >  		BUG_ON(!PageBuddy(page));
>> >  		order = buddy_order(page);
>> > -		del_page_from_free_list(page, zone, order);
>> > +		migratetype = get_pfnblock_migratetype(page, pfn);
>> 
>> As the free pages are isolated, theoretically this should be
>> MIGRATE_ISOLATE.
> 
> Thanks for noticing that - I somehow missed the fact that pageblock migratetypes
> change at runtime,

Not only that. Buddy merging will also merge pages from different
migratetypes. I think that's the main reason why nr_free is not per
migratetype. Your patch has been attempted few times already, e.g. here [1].

[1]
https://lore.kernel.org/all/alpine.DEB.2.10.1611161731350.17379@chino.kir.corp.google.com/

> so my patch is wrong. I'm going to have to rework my patch to
> store the migratetype of free pages in the page itself.

Yeah that would be the solution. Will likely bring some overhead to
alloc/free fastpaths, which would have to be worth it, so nobody attempted it.


