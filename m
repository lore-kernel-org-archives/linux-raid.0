Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90EECC43334
	for <linux-raid@archiver.kernel.org>; Wed, 13 Jul 2022 15:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236105AbiGMP0p (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Jul 2022 11:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbiGMP0o (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Jul 2022 11:26:44 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78574D150;
        Wed, 13 Jul 2022 08:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=rCgriMAFX6Fc1Z9GttOJf9X15MY+Tb2PCaFusOBQ5WU=; b=N7snfzk+LYYN0nmGLg7rxRSbff
        Pt0Dg6tNToce7TLYoSefFqPRJzDQLD54HpxYH+djGheiJICducjb0P5YxZcVUX2Q2tdOO0niln71H
        FQYgpgUOEV4M8e9aCjKoRzleXzvagKx+9BGST8ndSZxFZaN97FhuXGTsTN2ULXPv0ZQOVPQiwsU47
        23Tf0GRN9e3RJk8oUr67G2fAz1y+6srpR1QYY/zC1ANxzAAO5L5KaeMW8SfVmtYpOoPleg/jzxSkR
        YlP9R80knnIdo4ZoSb8Qz58NYg2IPIYdaki5tIWA+6ZMKNvBGiyI9REu4NG6f+Wj86irnTPoSHZG9
        6qLs7oGw==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oBeG7-00E8ZX-6n; Wed, 13 Jul 2022 09:26:39 -0600
Message-ID: <1f9beba5-3fa0-a0e6-c810-a82cec8e3496@deltatee.com>
Date:   Wed, 13 Jul 2022 09:26:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-CA
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, linux-block@vger.kernel.org
References: <20220713113125.2232975-1-hch@lst.de>
 <20220713113125.2232975-2-hch@lst.de>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220713113125.2232975-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: hch@lst.de, song@kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 1/9] md: fix error handling in md_alloc
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org




On 2022-07-13 05:31, Christoph Hellwig wrote:
> Error handling in md_alloc is a mess.  Untangle it to just free the mddev
> directly before add_disk is called and thus the gendisk is globally
> visible.  After that clear the hold flag and let the mddev_put take care
> of cleaning up the mddev through the usual mechanisms.
> 
> Fixes: 5e55e2f5fc95 ("[PATCH] md: convert compile time warnings into runtime warnings")
> Fixes: 9be68dd7ac0e ("md: add error handling support for add_disk()")
> Fixes: 7ad1069166c0 ("md: properly unwind when failing to add the kobject in md_alloc")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> 
> Note: the put_disk here is not fully correct on md-next, but will
> do the right thing once merged with the block tree.
> 
>  drivers/md/md.c | 45 ++++++++++++++++++++++++++++++++-------------
>  1 file changed, 32 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b64de313838f2..7affddade8b6b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -791,6 +791,15 @@ static struct mddev *mddev_alloc(dev_t unit)
>  	return ERR_PTR(error);
>  }
>  
> +static void mddev_free(struct mddev *mddev)
> +{
> +	spin_lock(&all_mddevs_lock);
> +	list_del(&mddev->all_mddevs);
> +	spin_unlock(&all_mddevs_lock);
> +
> +	kfree(mddev);
> +}

Sadly, I still don't think this is correct. mddev_init() has already
called kobject_init() and according to the documentation it *must* be
cleaned up with a call to kobject_put(). That doesn't happen in this
path -- so I believe this will cause memory leaks.

I have also noticed this code base already makes that same mistake in
mddev_alloc(): freeing the mddev on the error path after kobject_init().
But that would be easy to fix up.

Logan
