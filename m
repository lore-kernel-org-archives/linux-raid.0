Return-Path: <SRS0=1sSQ=DF=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A06C4727F
	for <linux-raid@archiver.kernel.org>; Mon, 28 Sep 2020 07:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC4F320809
	for <linux-raid@archiver.kernel.org>; Mon, 28 Sep 2020 07:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgI1Had (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 28 Sep 2020 03:30:33 -0400
Received: from verein.lst.de ([213.95.11.211]:34518 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgI1Hac (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 28 Sep 2020 03:30:32 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id BCC2268AFE; Mon, 28 Sep 2020 09:30:28 +0200 (CEST)
Date:   Mon, 28 Sep 2020 09:30:28 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Veronika Kabatova <vkabatov@redhat.com>,
        linux-raid@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH V5 1/3] percpu_ref: add percpu_ref_is_initialized for MD
Message-ID: <20200928073028.GA16536@lst.de>
References: <20200927062654.2750277-1-ming.lei@redhat.com> <20200927062654.2750277-2-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200927062654.2750277-2-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Sep 27, 2020 at 02:26:52PM +0800, Ming Lei wrote:
> MD code uses perpcu-refcount internal to check if this percpu-refcount
> variable is initialized, this way is a hack.
> 
> Add percpu_ref_is_initialized for MD so that the hack can be avoided.
> 
> Acked-by: Song Liu <song@kernel.org>
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Tested-by: Veronika Kabatova <vkabatov@redhat.com>
> Cc: Song Liu <song@kernel.org>
> Cc: linux-raid@vger.kernel.org
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/md/md.c                 | 2 +-
>  include/linux/percpu-refcount.h | 1 +
>  lib/percpu-refcount.c           | 6 ++++++
>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index de8419b7ae98..241ff618d84e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5631,7 +5631,7 @@ static void no_op(struct percpu_ref *r) {}
>  
>  int mddev_init_writes_pending(struct mddev *mddev)
>  {
> -	if (mddev->writes_pending.percpu_count_ptr)
> +	if (percpu_ref_is_initialized(&mddev->writes_pending))
>  		return 0;

I'd much rather use a flag in the containing mddev structure then
exposing this new "API".  That mddev code is pretty gross to be honest,
we should just initialize the percpu_ref once instea of such a hack.
