Return-Path: <SRS0=z15C=EH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17518C388F9
	for <linux-raid@archiver.kernel.org>; Sun,  1 Nov 2020 10:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D716420719
	for <linux-raid@archiver.kernel.org>; Sun,  1 Nov 2020 10:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgKAK1l (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 1 Nov 2020 05:27:41 -0500
Received: from verein.lst.de ([213.95.11.211]:58311 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgKAK1k (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 1 Nov 2020 05:27:40 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 56FF56736F; Sun,  1 Nov 2020 11:27:36 +0100 (CET)
Date:   Sun, 1 Nov 2020 11:27:35 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Ilya Dryomov <idryomov@gmail.com>,
        Song Liu <song@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 02/11] mtip32xx: return -ENOTTY for all unhanled ioctls
Message-ID: <20201101102735.GA26447@lst.de>
References: <20201031085810.450489-1-hch@lst.de> <20201031085810.450489-3-hch@lst.de> <f128e8bb-7ce4-b8f4-80cb-1afab503887c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f128e8bb-7ce4-b8f4-80cb-1afab503887c@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Oct 31, 2020 at 08:58:52AM -0600, Jens Axboe wrote:
> On 10/31/20 2:58 AM, Christoph Hellwig wrote:
> > -ENOTTY is the convention for "driver does not support this ioctl".
> > Use it properly in mtip32xx instead of the bogys -EINVAL.
> 
> While that's certainly true, there is a risk in making a change like this
> years after the fact. Not that I expect there are any mtip32xx users
> left at this point, but...

-ENOTTY is what most drivers return.  That being said we can keep the
old behavior, so if you prepfer that I can respin to do that.
