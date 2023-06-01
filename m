Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED90C77B7A
	for <linux-raid@archiver.kernel.org>; Thu,  1 Jun 2023 04:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjFAEUa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 1 Jun 2023 00:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjFAEU1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 1 Jun 2023 00:20:27 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D96101;
        Wed, 31 May 2023 21:20:25 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B611767373; Thu,  1 Jun 2023 06:20:21 +0200 (CEST)
Date:   Thu, 1 Jun 2023 06:20:21 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        dm-devel@redhat.com, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, gouha7@uniontech.com
Subject: Re: [PATCH v7 19/20] fs: iomap: use bio_add_folio_nofail where
 possible
Message-ID: <20230601042021.GA21768@lst.de>
References: <cover.1685532726.git.johannes.thumshirn@wdc.com> <58fa893c24c67340a63323f09a179fefdca07f2a.1685532726.git.johannes.thumshirn@wdc.com> <ZHfMC86ktyLtIxNb@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHfMC86ktyLtIxNb@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jun 01, 2023 at 08:36:59AM +1000, Dave Chinner wrote:
> We lose adjacent page merging with this change.

This is only used for adding the first folio to a brand new bio,
so there is nothing to merge with yet at this point.
