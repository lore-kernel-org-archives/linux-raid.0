Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D5CC77B7D
	for <linux-raid@archiver.kernel.org>; Thu, 18 May 2023 04:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjERE11 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 May 2023 00:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjERE10 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 18 May 2023 00:27:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A359C2D7B;
        Wed, 17 May 2023 21:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=IIh0xyShHYBnGc/27EVj7yoyG+ak+BCL39xppvaJjok=; b=AJq0aKz+QUghrtDlp/jXXr9/Fx
        locRhYrtiRNRY/uVMSLcOSR7aiXSwb81k5TalCtWKCKsnum1KXAqsGVqyXnBwmkFGUhA9X492pNkP
        7p9Gib7K7lrwrEI89IK4qmN04olflRaBLPgiJpxC4DvnAGPMJKN7NVbD3zR6Pa56q0n6p8BnOfXyt
        J4iLxNNzoAarXjhDBHHJCU+vWI6KhXI/tpGYThZdUA5hnZJ2kJcm5gugPtOvv2zXvucl33pabEK1f
        FaILxIlmmNIRds9AtXQ2glJUcmc1Na61NDLQsjTdcAFWKyjCt9HDLuSjdjGuMP1scmsmv4BPw8ARm
        H+BvELnw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pzVEa-00BqkQ-2L;
        Thu, 18 May 2023 04:27:24 +0000
Date:   Wed, 17 May 2023 21:27:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] md/raid5: Convert stripe_head's "dev" to flexible array
 member
Message-ID: <ZGWpLClY7vz+xl5A@infradead.org>
References: <20230517233313.never.130-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230517233313.never.130-kees@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, May 17, 2023 at 04:33:14PM -0700, Kees Cook wrote:
>  	sc = kmem_cache_create(conf->cache_name[conf->active_name],
> -			       sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),
> +			       struct_size((struct stripe_head *)0, dev, devs),
>  			       0, 0, NULL);
>  	if (!sc)
>  		return 1;
> @@ -2559,7 +2559,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
>  
>  	/* Step 1 */
>  	sc = kmem_cache_create(conf->cache_name[1-conf->active_name],
> -			       sizeof(struct stripe_head)+(newsize-1)*sizeof(struct r5dev),
> +			       struct_size((struct stripe_head *)0, dev, newsize),

The constant you're casting here should be NULL, not 0.
Also given that this expression is duplicated, I'd suggest a little
helper for it…

> -	} dev[1]; /* allocated with extra space depending of RAID geometry */
> +	} dev[]; /* allocated with extra space depending of RAID geometry */

And this isn't extra space over the single entry anymore, so I'd
change this to:

	/* allocated depending of RAID geometry */
