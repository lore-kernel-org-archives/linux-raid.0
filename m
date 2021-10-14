Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9F0C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 14 Oct 2021 14:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB8A3610D1
	for <linux-raid@archiver.kernel.org>; Thu, 14 Oct 2021 14:46:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhJNOsI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Oct 2021 10:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbhJNOsI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 14 Oct 2021 10:48:08 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B52C061570;
        Thu, 14 Oct 2021 07:46:03 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id t2so1493617qtn.12;
        Thu, 14 Oct 2021 07:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TGPp3QpJpJ141U9yeWl+a+2g/BVVjWKEO91eJs21Hfk=;
        b=QFy6Mi2z8Kldcn4G6XIOJH0lh8f3SYLh+rPvcnxLiNaCn8Rz5vH8187aRZ617o+4q0
         1b/XeB7iad/yBYxZgURgufTlMQYK/sEu8KxNMFBD+LRCYm8cEMoftnrOeSR2b2RA9USr
         r9AIu/rJHLy9R+bLiT3tS56AtpS7TpgEUW2W7pFcbS8fSMnMOcmCeV4aACIeO4plfmIu
         8ub4/2fdPXCsipsLVpatikdII3KyNOUwUp8MJDPjkZ3STWiokau3L/AH/9L38Y6nScHO
         /VAmUZg9bTTBqK0e/LFUzb+nQK98CWAhNSZbqHiXtfp5DcqK/a0v+T2wAfniMR6yyRW8
         960Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TGPp3QpJpJ141U9yeWl+a+2g/BVVjWKEO91eJs21Hfk=;
        b=XrXubaM3QlPFhbch+OLCKdhogbUr5SLN3qPlI/MLZyVkVo1H7IS5zsH5uNxx2jcXrm
         TThz05h9ACOLxmc5RiBaBq7PEQjvRYEwKg54ZN1vijIFC6BsfUBCB8b5t3g4ufwKV2Xg
         1z1JJoGBWRn74V+jgnPjEK3idyNKwzz3sN+BfbScvl7cjg3/K3PFqsjFML+TVhnaTu7r
         moJhayZ0oUbVTrcrTRYmCk5hTluRImYsiZR3durTcqiamGsV3i2LaxdRGToX5dfOWONo
         gByJwlWJGA30gyZNTotKJULTX4UBZKT63RavnokU0C8D8azjOI+AqdUEjQhNOpfC0ayH
         q2zQ==
X-Gm-Message-State: AOAM531hqgC8PlAxXXWkIJ42vhx7QSIgoKM5yeuoQGG1olXsF7v/xW4W
        3Fhj922dhgoyHi/tV2D6fw==
X-Google-Smtp-Source: ABdhPJyAtwEB+aqbfv0H1uUK0NBx3De4Dn3GmcFlOsAe7LDREAd0ZmU0/SXghhGFx62bEPBunF414A==
X-Received: by 2002:a05:622a:54c:: with SMTP id m12mr779161qtx.192.1634222762473;
        Thu, 14 Oct 2021 07:46:02 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id i85sm1421227qke.61.2021.10.14.07.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 07:46:01 -0700 (PDT)
Date:   Thu, 14 Oct 2021 10:45:59 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, axboe@kernel.dk,
        alexander.h.duyck@linux.intel.com
Subject: Re: [PATCH 1/5] mm: Make free_area->nr_free per migratetype
Message-ID: <YWhCp/lKbJS9XSqn@moria.home.lan>
References: <20211013160034.3472923-1-kent.overstreet@gmail.com>
 <20211013160034.3472923-2-kent.overstreet@gmail.com>
 <e29733c7-e65a-935a-4e05-3a060240ea5a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e29733c7-e65a-935a-4e05-3a060240ea5a@redhat.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Oct 13, 2021 at 06:33:06PM +0200, David Hildenbrand wrote:
> > @@ -9317,6 +9319,7 @@ void __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
> >  	struct page *page;
> >  	struct zone *zone;
> >  	unsigned int order;
> > +	unsigned int migratetype;
> >  	unsigned long flags;
> >  
> >  	offline_mem_sections(pfn, end_pfn);
> > @@ -9346,7 +9349,8 @@ void __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
> >  		BUG_ON(page_count(page));
> >  		BUG_ON(!PageBuddy(page));
> >  		order = buddy_order(page);
> > -		del_page_from_free_list(page, zone, order);
> > +		migratetype = get_pfnblock_migratetype(page, pfn);
> 
> As the free pages are isolated, theoretically this should be
> MIGRATE_ISOLATE.

Thanks for noticing that - I somehow missed the fact that pageblock migratetypes
change at runtime, so my patch is wrong. I'm going to have to rework my patch to
store the migratetype of free pages in the page itself.
