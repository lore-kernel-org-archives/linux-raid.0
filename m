Return-Path: <SRS0=1EIv=EJ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0097DC388F2
	for <linux-raid@archiver.kernel.org>; Tue,  3 Nov 2020 09:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7EA9223BD
	for <linux-raid@archiver.kernel.org>; Tue,  3 Nov 2020 09:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgKCJcw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 3 Nov 2020 04:32:52 -0500
Received: from verein.lst.de ([213.95.11.211]:36466 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgKCJcv (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 3 Nov 2020 04:32:51 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5F1EC68B05; Tue,  3 Nov 2020 10:32:37 +0100 (CET)
Date:   Tue, 3 Nov 2020 10:32:32 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     James Troup <james.troup@canonical.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Ilya Dryomov <idryomov@gmail.com>, Song Liu <song@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 06/11] md: implement ->set_read_only to hook into
 BLKROSET processing
Message-ID: <20201103093232.GB17061@lst.de>
References: <20201031085810.450489-1-hch@lst.de> <20201031085810.450489-7-hch@lst.de> <87y2jjpa09.fsf@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2jjpa09.fsf@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Nov 03, 2020 at 12:19:34AM +0000, James Troup wrote:
> Christoph Hellwig <hch@lst.de> writes:
> 
> > @@ -7809,6 +7778,36 @@ static int md_compat_ioctl(struct block_device *bdev, fmode_t mode,
> 
> [...]
> 
> > +	 * Transitioning to readauto need only happen for arrays that call
> > +	 * md_write_start and which are not ready for writes yet.
> 
> I realise you're just moving the comment around but perhaps you could
> s/readauto/readonly/ while you're doing so?

readonly doesn't make sense here as we transition away from read-only.
MD seems to have a read-auto mode, although it usually is spelled with
the dash, so I'll switch this comment to use the more common spelling.
