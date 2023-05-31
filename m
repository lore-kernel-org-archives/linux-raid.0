Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76407C77B73
	for <linux-raid@archiver.kernel.org>; Wed, 31 May 2023 04:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbjEaEU5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 May 2023 00:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjEaEU4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 31 May 2023 00:20:56 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758EEBE;
        Tue, 30 May 2023 21:20:55 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9244068B05; Wed, 31 May 2023 06:20:52 +0200 (CEST)
Date:   Wed, 31 May 2023 06:20:52 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
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
        Mikulas Patocka <mpatocka@redhat.com>, gouhao@uniontech.com,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v6 04/20] fs: buffer: use __bio_add_page to add single
 page to bio
Message-ID: <20230531042052.GB32705@lst.de>
References: <cover.1685461490.git.johannes.thumshirn@wdc.com> <f67cc9c310bed1e3c3302ea1c206da7d5ebc14cb.1685461490.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f67cc9c310bed1e3c3302ea1c206da7d5ebc14cb.1685461490.git.johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
