Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21411C433EF
	for <linux-raid@archiver.kernel.org>; Fri,  8 Jul 2022 06:01:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237142AbiGHGBf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Jul 2022 02:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiGHGBe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Jul 2022 02:01:34 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA4D796B0;
        Thu,  7 Jul 2022 23:01:34 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5A4AE68BFE; Fri,  8 Jul 2022 08:01:27 +0200 (CEST)
Date:   Fri, 8 Jul 2022 08:01:26 +0200
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
Message-ID: <20220708060126.GA16457@lst.de>
References: <20220614074827.458955-1-hch@lst.de> <20220614074827.458955-5-hch@lst.de> <72a5bf2e-cd56-a85c-2b99-cb8729a66fed@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72a5bf2e-cd56-a85c-2b99-cb8729a66fed@deltatee.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jul 07, 2022 at 11:41:40PM -0600, Logan Gunthorpe wrote:
> I'm not really sure why this is yet, but this patch in rc4 causes some
> random failures with mdadm tests.
> 
> It seems the 11spare-migration tests starts failing roughly every other
> run because the block device is not quite cleaned up after mdadm --stop
> by the time the next mdadm --create commands starts, or rather there
> appears to be a race now between the newly created device and the one
> being cleaned up. This results in an infrequent sysfs panic with a
> duplicate filename error (see the end of this email).
> 
> I managed to bisect this and found a09b314005f3a09 to be the problematic
> commit.

Taking a look at the mddev code this commit just seems to increase the
race window of hitting horrible life time problems in md, but I'll also
try to reproduce and verify it myself.

Take a look at how md searches for a duplicate name in md_alloc,
mddev_alloc_unit and mddev_find_locked based on the all_mddevs list,
and how the mddev gets dropped from all_mddevs very early and long
before the gendisk is gone in mddev_put.  I think what needs to be
done is to implement a free_disk method and drop the mddev (and free it)
from that.  But given how much intricate mess is based on all_mddevs
we'll have to be very careful about that.
