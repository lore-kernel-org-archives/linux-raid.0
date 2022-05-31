Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9896C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 06:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244174AbiEaGMC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 02:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235006AbiEaGMB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 02:12:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB51C43AF6;
        Mon, 30 May 2022 23:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=K6NX6TML8cMFb/94Pony4ZKvrLquBcu1LBU/oFppeD0=; b=q1nhoMFJyIEwB44vi2o+lT+xYL
        xuUmhHCMspky/xW5AYQ4uzJpBSE7aqWmAILzbtffxkyYTXgr/fyKOGgJSFDbP3TTNU9LHukwVMC/A
        Di2L5kJFfl0ZzUSE0dBgilUeCrYETB0evF2XJAMR+85hheUHwBCJpdKGrGTKfaVV4bsD7+tYuA4ZG
        rfSpXqXuHvhEv2Q2fOD+VcdcAl9tXCAd6CR34N6lao3bo06OBCwNGKVax38Lcn+1ZKh98ICUlMwCp
        xTz0F7h6ym0ws0H4hKQEOOLYaAgSJwovo3IQnEqYbgL0basTbt+CrsSeG8SxbE5TWNheFOcsC/9Hn
        bRxjrhlw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nvv6Z-009W2p-4J; Tue, 31 May 2022 06:11:47 +0000
Date:   Mon, 30 May 2022 23:11:47 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
Message-ID: <YpWxo7rCmarXMdVa@infradead.org>
References: <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
 <b4244eab-d9e2-20a0-ebce-1a96e8fadb91@deltatee.com>
 <836b2a93-65be-8d6c-8610-18373b88f86d@molgen.mpg.de>
 <5b0584a3-c128-cb53-7c8a-63744c60c667@linux.dev>
 <4edc9468-d195-6937-f550-211bccbd6756@molgen.mpg.de>
 <954f9c33-7801-b6d2-65e3-9e5237905886@linux.dev>
 <82a08e9c-e3f4-4eb6-cb06-58b96c0f01a8@deltatee.com>
 <775d6734-2b08-21a8-a093-f750d31ce6ce@linux.dev>
 <ae6d294a-e9ec-a81d-6085-a9341ed8a470@deltatee.com>
 <20220526115336.2whsfdcuqwfzk5fk@quack3.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526115336.2whsfdcuqwfzk5fk@quack3.lan>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, May 26, 2022 at 01:53:36PM +0200, Jan Kara wrote:
> So I've debugged this. The crash happens on the very first bio submitted to
> the md0 device. The problem is that this bio gets remapped to loop0 - this
> happens through bio_alloc_clone() -> __bio_clone() which ends up calling
> bio_clone_blkg_association(). Now the resulting bio is inconsistent - it's
> dst_bio->bi_bdev is pointing to loop0 while dst_bio->bi_blkg is pointing to
> blkcg_gq associated with md0 request queue. And this breaks BFQ because
> when this bio is inserted to loop0 request queue, BFQ looks at
> bio->bi_blkg->q (it is a bit more complex than that but this is the gist
> of the problem), expects its data there but BFQ is not initialized for md0
> request_queue.
> 
> Now I think this is a bug in __bio_clone() but the inconsistency in the bio
> is very much what we asked bio_clone_blkg_association() to do so maybe I'm
> missing something and bios that are associated with one bdev but pointing
> to blkg of another bdev are fine and controllers are supposed to handle
> that (although I'm not sure how should they do that). So I'm asking here
> before I just go and delete bio_clone_blkg_association() from
> __bio_clone()...

This behavior probably goes back to my commit here:

ommit d92c370a16cbe0276954c761b874bd024a7e4fac
Author: Christoph Hellwig <hch@lst.de>
Date:   Sat Jun 27 09:31:48 2020 +0200

    block: really clone the block cgroup in bio_clone_blkg_association

and it seems everyone else was fine with that behavior so far.
