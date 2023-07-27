Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BA0DC04FE1
	for <linux-raid@archiver.kernel.org>; Thu, 27 Jul 2023 22:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbjG0W7p (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbjG0W7o (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 27 Jul 2023 18:59:44 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BFB30C0
        for <linux-raid@vger.kernel.org>; Thu, 27 Jul 2023 15:59:41 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-686f94328a4so673978b3a.0
        for <linux-raid@vger.kernel.org>; Thu, 27 Jul 2023 15:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1690498781; x=1691103581;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8CTrna5t3S7P99W+zrM1I2ApZYIkXTVQedDFVAI6oIw=;
        b=X7pt5OuyEbf8f6R9fnvI9dxfnaaqjP1RGRY8ZMiJ1wEZkopGyRUZXV3N7HE87n67xj
         XeLWxsKHlNX6ErnVJUF/xO5BY5VT61hhmCqWCbxit+6W6UUMx7WmvB86s0q+wgGSoL6W
         koucWxrpBOYNBJME5+HxRa/lXlSreJXWQaoDeJrNnWxYMUw7bNkMz2551ucFVRtsjQZW
         0ldvdZqoq1ohkP2t1Jbzv+uf1kwplqapkGN1TtrTmsgZICGsR0gfv1ElN5pvcVjNfGjj
         OPatiCTf9mYCZ8F6QAcUCONXn7kELLjAWaYShbgFOaFFniHTDeIvjRJJRIf4kK+rSYkZ
         RVyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690498781; x=1691103581;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8CTrna5t3S7P99W+zrM1I2ApZYIkXTVQedDFVAI6oIw=;
        b=ZFEj+hy8yJUY20y2yfM8r67b14Tt4q930uuuUHh7dyUvw/YIUikVSphxZpeVWHNYt4
         66oUUsIX5a1NsxJrgboWwA9uowRStwiSGxcDO3x6IaZ5gjiubTN0+D5HjAXSi/ZGU01k
         w1HcBS5rkt9V5EjhssJqg5r1XZRpcRgo2BK4Abu4Q7hhIVMTdtGB1hdbAGf+PBdb9+91
         U13P9qOsNFnq5twjZGxJRxvF7c3QEQl+wxp2s08ZEvW9VaC41iRKzztPHGGXxMvXUDbZ
         6SDSHyZ8VdaNG01z+GMYh9LEfXfludv4uIiBqCnd1ZuqKthpriDYfeBOCzZyJq2nIrcU
         TCAw==
X-Gm-Message-State: ABy/qLYEF857F5sQeXZYKTdyCopbpqWrISW4GyRs4odRwQTKLdmm1vyo
        9cra9iRAXjcqD90PANMeTXQeWQ==
X-Google-Smtp-Source: APBJJlGFE8oAcAZu2XvzWjC5bjR81v7OIjjTfZ8m+EaEe6Rjpq3cuwvHN3I08mErFwOZJpneP9Ly1g==
X-Received: by 2002:a05:6a00:17a8:b0:64d:42b9:6895 with SMTP id s40-20020a056a0017a800b0064d42b96895mr61072pfg.5.1690498780930;
        Thu, 27 Jul 2023 15:59:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id p24-20020aa78618000000b0068702b66ab1sm1115813pfn.174.2023.07.27.15.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 15:59:40 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qP9xJ-00BKKZ-1O;
        Fri, 28 Jul 2023 08:59:37 +1000
Date:   Fri, 28 Jul 2023 08:59:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Qi Zheng <zhengqi.arch@bytedance.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-erofs@lists.ozlabs.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-nfs@vger.kernel.org, linux-mtd@lists.infradead.org,
        rcu@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        akpm@linux-foundation.org, tkhai@ya.ru, vbabka@suse.cz,
        roman.gushchin@linux.dev, djwong@kernel.org, brauner@kernel.org,
        paulmck@kernel.org, tytso@mit.edu, steven.price@arm.com,
        cel@kernel.org, senozhatsky@chromium.org, yujie.liu@intel.com,
        gregkh@linuxfoundation.org, muchun.song@linux.dev
Subject: Re: [PATCH v3 28/49] dm zoned: dynamically allocate the
 dm-zoned-meta shrinker
Message-ID: <ZML22YJi5vPBDEDj@dread.disaster.area>
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
 <20230727080502.77895-29-zhengqi.arch@bytedance.com>
 <baaf7de4-9a0e-b953-2b6a-46e60c415614@kernel.org>
 <56ee1d92-28ee-81cb-9c41-6ca7ea6556b0@bytedance.com>
 <ba0868b2-9f90-3d81-1c91-8810057fb3ce@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ba0868b2-9f90-3d81-1c91-8810057fb3ce@kernel.org>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jul 27, 2023 at 07:20:46PM +0900, Damien Le Moal wrote:
> On 7/27/23 17:55, Qi Zheng wrote:
> >>>           goto err;
> >>>       }
> >>>   +    zmd->mblk_shrinker->count_objects = dmz_mblock_shrinker_count;
> >>> +    zmd->mblk_shrinker->scan_objects = dmz_mblock_shrinker_scan;
> >>> +    zmd->mblk_shrinker->seeks = DEFAULT_SEEKS;
> >>> +    zmd->mblk_shrinker->private_data = zmd;
> >>> +
> >>> +    shrinker_register(zmd->mblk_shrinker);
> >>
> >> I fail to see how this new shrinker API is better... Why isn't there a
> >> shrinker_alloc_and_register() function ? That would avoid adding all this code
> >> all over the place as the new API call would be very similar to the current
> >> shrinker_register() call with static allocation.
> > 
> > In some registration scenarios, memory needs to be allocated in advance.
> > So we continue to use the previous prealloc/register_prepared()
> > algorithm. The shrinker_alloc_and_register() is just a helper function
> > that combines the two, and this increases the number of APIs that
> > shrinker exposes to the outside, so I choose not to add this helper.
> 
> And that results in more code in many places instead of less code + a simple
> inline helper in the shrinker header file...

It's not just a "simple helper" - it's a function that has to take 6
or 7 parameters with a return value that must be checked and
handled.

This was done in the first versions of the patch set - the amount of
code in each caller does not go down and, IMO, was much harder to
read and determine "this is obviously correct" that what we have
now.

> So not adding that super simple
> helper is not exactly the best choice in my opinion.

Each to their own - I much prefer the existing style/API over having
to go look up a helper function every time I want to check some
random shrinker has been set up correctly....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
