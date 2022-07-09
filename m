Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A26C433EF
	for <linux-raid@archiver.kernel.org>; Sat,  9 Jul 2022 08:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiGIIRv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 9 Jul 2022 04:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGIIRv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 9 Jul 2022 04:17:51 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA0B747A7;
        Sat,  9 Jul 2022 01:17:50 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0709368AA6; Sat,  9 Jul 2022 10:17:46 +0200 (CEST)
Date:   Sat, 9 Jul 2022 10:17:45 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
        shinichiro.kawasaki@wdc.com, dan.j.williams@intel.com,
        yukuai3@huawei.com, ming.lei@redhat.com,
        linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>
Subject: Re: REGRESSION: [PATCH 4/4] block: freeze the queue earlier in
 del_gendisk
Message-ID: <20220709081745.GA26411@lst.de>
References: <20220614074827.458955-1-hch@lst.de> <20220614074827.458955-5-hch@lst.de> <72a5bf2e-cd56-a85c-2b99-cb8729a66fed@deltatee.com> <20220708060126.GA16457@lst.de> <c43e40da-7549-0c81-2a3c-d837b59f7e76@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c43e40da-7549-0c81-2a3c-d837b59f7e76@deltatee.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Jul 08, 2022 at 09:55:55AM -0600, Logan Gunthorpe wrote:
> I agree it's a mess, probably buggy and could use a cleanup with a
> free_disk method. But I'm not sure the all_mdevs lifetime issues are the
> problem here. If the entry in all_mdevs outlasts the disk, then
> md_alloc() will just fail earlier. Many test scripts rely on the fact
> that you can stop an mddev and recreate it immediately after. We need
> some way of ensuring any deleted disks are fully deleted before trying
> to make a new mddev, in case the new one has the same name as one being
> deleted.

I think those tests are broken.  But fortunately that is just an
assumption in the tests, while device name reuse is a real problem.

I could not reproduce your problem, but on the for-5.20/block
tree I see a hang in 10ddf-geometry when running the tests.

The branch here:

    git://git.infradead.org/users/hch/block.git md-lifetime-fixes
    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/md-lifetime-fixes

fixes that for me and does not introduce new regressions.  Can you
check if that helps your problem?
