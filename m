Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5506C433FE
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 07:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244606AbiEaHnh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 03:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238520AbiEaHnf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 03:43:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCF76F4BC;
        Tue, 31 May 2022 00:43:33 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AD9E021AC2;
        Tue, 31 May 2022 07:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1653983012; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T+FFkKNp43RHD1ngM5lCL37MJPYNS2ZnW39NxBjZ8LY=;
        b=zAqJtrSKhYf+Upt0qWeri7IPZMWSmF4/O4N9FOaACqLtcUj37dkE7116uDcjWOEkZyGy1N
        mg29FQWAXE3lGN94QKQXwDK+LQasMUW6xK+Fmctf3aHZa7b2xzTFNq57BqAEw1ov/yZf8/
        kRsC7ve8inQdEmYqh3kOuW0oj2ap6yU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1653983012;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T+FFkKNp43RHD1ngM5lCL37MJPYNS2ZnW39NxBjZ8LY=;
        b=5rydVaWVjCjaJYBfzWO2EwqKiahXJuBIlrSkZN1DdZTR4OQio3WEle8NGA2MzQkLwVLoZB
        NlmULj0Eo6R8aYDw==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8FAAD2C142;
        Tue, 31 May 2022 07:43:32 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 96622A0633; Tue, 31 May 2022 09:43:26 +0200 (CEST)
Date:   Tue, 31 May 2022 09:43:26 +0200
From:   Jan Kara <jack@suse.cz>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jan Kara <jack@suse.cz>, Logan Gunthorpe <logang@deltatee.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, linux-block@vger.kernel.org
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
Message-ID: <20220531074326.wvjmjtih4tyilijp@quack3.lan>
References: <b4244eab-d9e2-20a0-ebce-1a96e8fadb91@deltatee.com>
 <836b2a93-65be-8d6c-8610-18373b88f86d@molgen.mpg.de>
 <5b0584a3-c128-cb53-7c8a-63744c60c667@linux.dev>
 <4edc9468-d195-6937-f550-211bccbd6756@molgen.mpg.de>
 <954f9c33-7801-b6d2-65e3-9e5237905886@linux.dev>
 <82a08e9c-e3f4-4eb6-cb06-58b96c0f01a8@deltatee.com>
 <775d6734-2b08-21a8-a093-f750d31ce6ce@linux.dev>
 <ae6d294a-e9ec-a81d-6085-a9341ed8a470@deltatee.com>
 <20220526115336.2whsfdcuqwfzk5fk@quack3.lan>
 <YpWxo7rCmarXMdVa@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YpWxo7rCmarXMdVa@infradead.org>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon 30-05-22 23:11:47, Christoph Hellwig wrote:
> On Thu, May 26, 2022 at 01:53:36PM +0200, Jan Kara wrote:
> > So I've debugged this. The crash happens on the very first bio submitted to
> > the md0 device. The problem is that this bio gets remapped to loop0 - this
> > happens through bio_alloc_clone() -> __bio_clone() which ends up calling
> > bio_clone_blkg_association(). Now the resulting bio is inconsistent - it's
> > dst_bio->bi_bdev is pointing to loop0 while dst_bio->bi_blkg is pointing to
> > blkcg_gq associated with md0 request queue. And this breaks BFQ because
> > when this bio is inserted to loop0 request queue, BFQ looks at
> > bio->bi_blkg->q (it is a bit more complex than that but this is the gist
> > of the problem), expects its data there but BFQ is not initialized for md0
> > request_queue.
> > 
> > Now I think this is a bug in __bio_clone() but the inconsistency in the bio
> > is very much what we asked bio_clone_blkg_association() to do so maybe I'm
> > missing something and bios that are associated with one bdev but pointing
> > to blkg of another bdev are fine and controllers are supposed to handle
> > that (although I'm not sure how should they do that). So I'm asking here
> > before I just go and delete bio_clone_blkg_association() from
> > __bio_clone()...
> 
> This behavior probably goes back to my commit here:
> 
> ommit d92c370a16cbe0276954c761b874bd024a7e4fac
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Sat Jun 27 09:31:48 2020 +0200
> 
>     block: really clone the block cgroup in bio_clone_blkg_association
> 
> and it seems everyone else was fine with that behavior so far.

Yes, thanks for the pointer. I agree nobody else was crashing due to this
but it will be causing interesting inconsistencies in accounting and
throttling in all the IO controllers - e.g. usually both original
and cloned bio will get accounted to md0 device and loop0 device settings
will be completely ignored. From my experience these things do not
get really tested too much until some customer tries to use them :). So I
think we have to effectively revert your above change. I'll send a patch.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
