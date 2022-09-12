Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 146A1ECAAA1
	for <linux-raid@archiver.kernel.org>; Mon, 12 Sep 2022 07:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiILHTF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Sep 2022 03:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiILHSf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Sep 2022 03:18:35 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A0F31DC2;
        Mon, 12 Sep 2022 00:16:50 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B5EA96732D; Mon, 12 Sep 2022 09:16:18 +0200 (CEST)
Date:   Mon, 12 Sep 2022 09:16:18 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Dusty Mabe <dusty@dustymabe.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: regression caused by block: freeze the queue earlier in
 del_gendisk
Message-ID: <20220912071618.GA4971@lst.de>
References: <017845ae-fbae-70f6-5f9e-29aff2742b8c@dustymabe.com> <YxBZ4BBjxvAkvI2A@T590> <20220907073324.GB23826@lst.de> <Yxr4SD4d0rZ9TZik@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxr4SD4d0rZ9TZik@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Sep 09, 2022 at 04:24:40PM +0800, Ming Lei wrote:
> On Wed, Sep 07, 2022 at 09:33:24AM +0200, Christoph Hellwig wrote:
> > On Thu, Sep 01, 2022 at 03:06:08PM +0800, Ming Lei wrote:
> > > It is a bit hard to associate the above commit with reported issue.
> > 
> > So the messages clearly are about something trying to open a device
> > that went away at the block layer, but somehow does not get removed
> > in time by udev (which seems to be a userspace bug in CoreOS).  But
> > even with that we really should not hang.
> 
> Xiao Ni provides one script[1] which can reproduce the issue more or less.

I've run the reproduced 10000 times on current mainline, and while
it prints one of the autoloading messages per run, I've not actually
seen any kind of hang.
