Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923C7C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 14 Jul 2022 05:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbiGNFIS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Jul 2022 01:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234453AbiGNFHe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 14 Jul 2022 01:07:34 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE24C6E;
        Wed, 13 Jul 2022 22:06:54 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id BE58D67373; Thu, 14 Jul 2022 07:06:50 +0200 (CEST)
Date:   Thu, 14 Jul 2022 07:06:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Song Liu <song@kernel.org>, Christoph Hellwig <hch@lst.de>,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH] md: Ensure mddev object is cleaned up with kobject_put
 on error path
Message-ID: <20220714050650.GA23332@lst.de>
References: <20220713210623.14705-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713210623.14705-1-logang@deltatee.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Jul 13, 2022 at 03:06:23PM -0600, Logan Gunthorpe wrote:
> The documentation for kobject_init() clearly states that the new
> object must be cleaned up with a call to kobject_put(), not a
> kfree() call directly.
> 
> However, the error path in mddev_alloc() frees the newly allocated
> mddev object directly with kfree() after kobject_init() is called
> in mddev_init().
> 
> Fix this by changing the kfree() call to a kobject_put().

I think the right answer is to only initialize the kobject just
before we add it.  I'll send an updated patch for that in a bit.
