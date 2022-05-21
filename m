Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 090F0C433EF
	for <linux-raid@archiver.kernel.org>; Sat, 21 May 2022 11:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353281AbiEULvz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 May 2022 07:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350067AbiEULvy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 May 2022 07:51:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19BE5EBE5;
        Sat, 21 May 2022 04:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=48TGnIkHSD+XtWIUAmFNP5PC0Ohgphv/jDpddBnWplY=; b=S2twlDCp2QheXLtKjqJiFbVpv3
        byVpcmskx0DzguD7q6nZqyqI+/poBwaDM1H+H9Wa2iDNnRaCo8jtnuJbbrEAMqeYHHqc1wq7Z3tu/
        tzr0jZAtbRAheP8pER9/p1KkF0HQgEDQN+9D0fnihqsBy+WfHC949tEPMFCA4BLb3kwhN9R+3bXTu
        H3hag0Y3qAqNu2rI8iWbuI7HatRxzEFKSPbnr2f02aE8FSYVykmMJ5oJCpcjZ0w72/Ad864ExxGpi
        uHU7C9qiss7booBHfN4f2Z9sDJaNLuBFzTrjaD4//UxFlzfLwOKZKC7p9nsBQdtJzv5D/PsPQy5Sg
        nhAb0Qsw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsNe9-00GQvI-2V; Sat, 21 May 2022 11:51:49 +0000
Date:   Sat, 21 May 2022 04:51:49 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH v1 14/15] md: Ensure resync is reported after it starts
Message-ID: <YojSVXNF1ITIhlUl@infradead.org>
References: <20220519191311.17119-1-logang@deltatee.com>
 <20220519191311.17119-15-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519191311.17119-15-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, May 19, 2022 at 01:13:10PM -0600, Logan Gunthorpe wrote:
> The 07layouts test in mdadm fails on some systems. The failure
> presents itself as the backup file not being removed before the next
> layout is grown into:
> 
>   mdadm: /dev/md0: cannot create backup file /tmp/md-test-backup:
>       File exists
> 
> This is because the background mdadm process, which is responsible for
> cleaning up this backup file gets into an infinite loop waiting for
> the reshape to start. mdadm checks the mdstat file if a reshape is
> going and, if it is not, it waits for an event on the file or times
> out in 5 seconds. On faster machines, the reshape may complete before
> the 5 seconds times out, and thus the background mdadm process loops
> waiting for a reshape to start that has already occurred.
> 
> mdadm reads the mdstat file to start, but mdstat does not report that the
> reshape has begun, even though it has indeed begun. So the mdstat_wait()
> call (in mdadm) which polls on the mdstat file won't ever return until
> timing out.
> 
> The reason mdstat reports the reshape has started is due to an issue
> in status_resync(). recovery_active is subtracted from curr_resync which
> will result in a value of zero for the first chunk of reshaped data, and
> the resulting read will report no reshape in progress.
> 
> To fix this, if "resync - recovery_active" is zero: force the value to
> be 4 so the code reports a resync in progress.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>  drivers/md/md.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 8273ac5eef06..dbac63c8e35c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8022,10 +8022,18 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
>  		if (test_bit(MD_RECOVERY_DONE, &mddev->recovery))
>  			/* Still cleaning up */
>  			resync = max_sectors;
> -	} else if (resync > max_sectors)
> +	} else if (resync > max_sectors) {
>  		resync = max_sectors;
> -	else
> +	} else {
>  		resync -= atomic_read(&mddev->recovery_active);
> +		if (!resync) {
> +			/*
> +			 * Resync has started, but if it's zero, ensure
> +			 * it is still reported, by forcing it to be 4
> +			 */
> +			resync = 4;

Where does this magic 4 come from?
