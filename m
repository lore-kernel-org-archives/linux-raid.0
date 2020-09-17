Return-Path: <SRS0=RAIN=C2=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA147C433E2
	for <linux-raid@archiver.kernel.org>; Thu, 17 Sep 2020 09:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB219206C9
	for <linux-raid@archiver.kernel.org>; Thu, 17 Sep 2020 09:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgIQJZk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 17 Sep 2020 05:25:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:41094 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgIQJZg (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 17 Sep 2020 05:25:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CA2C7AC12;
        Thu, 17 Sep 2020 09:25:58 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id BC6F61E12E1; Thu, 17 Sep 2020 11:25:24 +0200 (CEST)
Date:   Thu, 17 Sep 2020 11:25:24 +0200
From:   Jan Kara <jack@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Richard Weinberger <richard@nod.at>,
        Minchan Kim <minchan@kernel.org>,
        linux-mtd@lists.infradead.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 10/12] bdi: replace BDI_CAP_STABLE_WRITES with a queue
 and a sb flag
Message-ID: <20200917092524.GC7347@quack2.suse.cz>
References: <20200910144833.742260-1-hch@lst.de>
 <20200910144833.742260-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910144833.742260-11-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu 10-09-20 16:48:30, Christoph Hellwig wrote:
> The BDI_CAP_STABLE_WRITES is one of the few bits of information in the
> backing_dev_info shared between the block drivers and the writeback code.
> To help untangling the dependency replace it with a queue flag and a
> superblock flag derived from it.  This also helps with the case of e.g.
> a file system requiring stable writes due to its own checksumming, but
> not forcing it on other users of the block device like the swap code.
> 
> One downside is that we can't support the stable_pages_required bdi
> attribute in sysfs anymore.  It is replaced with a queue attribute, that
> can also be made writable for easier testing.
  ^^^^^^^^^^^^^^^^
  is also made

For a while I was confused thinking that the new attribute is not writeable
but when I checked the code I saw that it is.

Not supporting stable_pages_required attribute is not nice but probably it
isn't widely used. Maybe the deprecation message can even mention to use
the queue attribute? Otherwise the patch looks good to me so feel free to
add:

Reviewed-by: Jan Kara <jack@suse.cz>


								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
