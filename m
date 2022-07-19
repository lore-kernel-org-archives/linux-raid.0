Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E5A5CCA481
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 07:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbiGSHDO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 03:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234129AbiGSHDM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 03:03:12 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699A232040;
        Tue, 19 Jul 2022 00:03:11 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 59E7168B05; Tue, 19 Jul 2022 09:03:07 +0200 (CEST)
Date:   Tue, 19 Jul 2022 09:03:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 08/10] md: stop using for_each_mddev in md_exit
Message-ID: <20220719070306.GA28422@lst.de>
References: <20220718063410.338626-1-hch@lst.de> <20220718063410.338626-9-hch@lst.de> <61d08fa6-91e4-f809-1074-d1ba2b1a3758@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61d08fa6-91e4-f809-1074-d1ba2b1a3758@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jul 18, 2022 at 09:10:59AM +0200, Hannes Reinecke wrote:
>
> Having thought about it some more ... wouldn't it make sense to modify 
> mddev_get() to
>
> if (atomic_inc_not_zero(&mddev->active))
>     return NULL;
>
> to ensure we're not missing any use-after-free issues, which previously 
> would have been caught by the 'for_each_mddev()' macro?

No.  mddev->active = 0 can still be a perfectly valid mddev and they
are not automatically deleted.  Check the conditions in mddev_put.
