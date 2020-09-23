Return-Path: <SRS0=yBIz=DA=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3327C4363D
	for <linux-raid@archiver.kernel.org>; Wed, 23 Sep 2020 15:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4E882075B
	for <linux-raid@archiver.kernel.org>; Wed, 23 Sep 2020 15:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgIWPQS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Sep 2020 11:16:18 -0400
Received: from verein.lst.de ([213.95.11.211]:48859 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbgIWPQN (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 23 Sep 2020 11:16:13 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D31FF6736F; Wed, 23 Sep 2020 17:16:06 +0200 (CEST)
Date:   Wed, 23 Sep 2020 17:16:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jan Kara <jack@suse.cz>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Song Liu <song@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Coly Li <colyli@suse.de>, Richard Weinberger <richard@nod.at>,
        Minchan Kim <minchan@kernel.org>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Justin Sanders <justin@coraid.com>,
        linux-mtd@lists.infradead.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 05/13] bdi: initialize ->ra_pages and ->io_pages in
 bdi_init
Message-ID: <20200923151606.GB16073@lst.de>
References: <20200921080734.452759-1-hch@lst.de> <20200921080734.452759-6-hch@lst.de> <20200922084954.GC16464@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922084954.GC16464@quack2.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Sep 22, 2020 at 10:49:54AM +0200, Jan Kara wrote:
> On Mon 21-09-20 10:07:26, Christoph Hellwig wrote:
> > Set up a readahead size by default, as very few users have a good
> > reason to change it.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Acked-by: David Sterba <dsterba@suse.com> [btrfs]
> > Acked-by: Richard Weinberger <richard@nod.at> [ubifs, mtd]
> 
> The patch looks good to me. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> I'd just prefer if the changelog explicitely mentioned that this patch
> results in enabling readahead for coda, ecryptfs, and orangefs... Just in
> case someone bisects some issue down to this patch :).

Ok, I've updated the changelog.
