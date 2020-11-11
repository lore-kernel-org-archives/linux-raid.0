Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 484DDC56201
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 08:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED859206E3
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 08:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgKKIDs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 Nov 2020 03:03:48 -0500
Received: from verein.lst.de ([213.95.11.211]:39122 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgKKIDq (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 11 Nov 2020 03:03:46 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id E204A6736F; Wed, 11 Nov 2020 09:03:34 +0100 (CET)
Date:   Wed, 11 Nov 2020 09:03:34 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
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
Subject: Re: [PATCH, RFC 11/10] block: propagate BLKROSET to all partitions
Message-ID: <20201111080334.GA23062@lst.de>
References: <20201106140817.GA23557@lst.de> <yq1imacecwz.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1imacecwz.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Nov 10, 2020 at 11:38:22PM -0500, Martin K. Petersen wrote:
> 
> Christoph,
> 
> > When setting the whole device read-only (or clearing the read-only
> > state), also update the policy for all partitions.  The s390 dasd
> > driver has awlways been doing this and it makes a lot of sense.
> 
> For your amusement, here's my attempt at addressing this from a while
> back. Can't remember exactly why this stranded, I even wrote blktests
> for it...

I added you to the Cc list because I had a vague memory that you were
looking into this area a while ago.

I actually think your patch that goes further is the right thing to do,
and I was going to look into something similar for a problem with
hardware read-only namespaces in NVMe.  I think I'll take your patch
as a starting point and will work from there.
