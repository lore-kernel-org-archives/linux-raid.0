Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B42FC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 11 Jul 2022 04:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiGKEd0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 11 Jul 2022 00:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiGKEd0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 11 Jul 2022 00:33:26 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B33C19005;
        Sun, 10 Jul 2022 21:33:25 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7046268AA6; Mon, 11 Jul 2022 06:33:21 +0200 (CEST)
Date:   Mon, 11 Jul 2022 06:33:21 +0200
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
Message-ID: <20220711043321.GA21925@lst.de>
References: <20220614074827.458955-1-hch@lst.de> <20220614074827.458955-5-hch@lst.de> <72a5bf2e-cd56-a85c-2b99-cb8729a66fed@deltatee.com> <20220708060126.GA16457@lst.de> <c43e40da-7549-0c81-2a3c-d837b59f7e76@deltatee.com> <20220709081745.GA26411@lst.de> <55940f1e-bd93-e167-2580-35880ab1e702@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55940f1e-bd93-e167-2580-35880ab1e702@deltatee.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Jul 10, 2022 at 09:33:51PM -0600, Logan Gunthorpe wrote:
> I did a fairly quick review of the patches:
> 
>  - In the patch that introduces md_free_disk() it looks like md_free()
> can still be called from the error path of md_alloc() before
> mddev->gendisk is set... which seems to make things rather complicated
> seeing we then can't use free_disk to finish the cleanup if the disk
> hasn't been created yet. I probably need to take closer look at this
> but, it might make more sense for the cleanup to remain in md_free() but
> call kobject_put() in md_free_disk() and del_gendisk() in
> mdev_delayed_delete(). Then md_alloc() can still use kobject_put() in
> the error path and it makes a little more sense seeing we'd still be
> freeing the kobject stuff in it's own release method instead of the
> disks free method.

Uww, yes.  I suspect the best fix is to actually stop the kobject
from taking part in the md life time directly.  Because the kobject
contributes a reference to the disk until it is deleted, we might
as well stop messing with the refcounts entirely and just call
kobject_del on it just before del_gendisk.  Let me see what I can do
there.

> 
>  - In the patch with md_rdevs_overlap, it looks like we remove the
> rcu_read_lock(), which definitely seems out of place and probably isn't
> correct. But the comment that was recreated still references the rcu so
> probably should be changed.

Fixed.

>  - The last patch has a typo in the title (disk is *a* freed).

Fixed.
