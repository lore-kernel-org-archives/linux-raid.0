Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962E9C433E0
	for <linux-raid@archiver.kernel.org>; Sun,  7 Feb 2021 16:21:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B6AD64DDB
	for <linux-raid@archiver.kernel.org>; Sun,  7 Feb 2021 16:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhBGQV5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 7 Feb 2021 11:21:57 -0500
Received: from verein.lst.de ([213.95.11.211]:38631 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhBGQV5 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 7 Feb 2021 11:21:57 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9B8B868B02; Sun,  7 Feb 2021 17:21:14 +0100 (CET)
Date:   Sun, 7 Feb 2021 17:21:14 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: cleanup bvec allocation
Message-ID: <20210207162114.GA25630@lst.de>
References: <20210202171929.1504939-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202171929.1504939-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Feb 02, 2021 at 06:19:18PM +0100, Christoph Hellwig wrote:
> Hi Jens,
> 
> This series cleans up various lose ends in the bvec allocator.

Any comments?
