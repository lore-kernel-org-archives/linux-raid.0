Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97130C7EE2E
	for <linux-raid@archiver.kernel.org>; Wed, 31 May 2023 04:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbjEaEXn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 May 2023 00:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234153AbjEaEXm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 31 May 2023 00:23:42 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C5E10B;
        Tue, 30 May 2023 21:23:41 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2A61568B05; Wed, 31 May 2023 06:23:39 +0200 (CEST)
Date:   Wed, 31 May 2023 06:23:38 +0200
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
Subject: Re: [PATCH v6 13/20] md: check for failure when adding pages in
 alloc_behind_master_bio
Message-ID: <20230531042338.GK32705@lst.de>
References: <cover.1685461490.git.johannes.thumshirn@wdc.com> <d7cfd04d410accee4148d8c0e51230bcb8b4bb8f.1685461490.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7cfd04d410accee4148d8c0e51230bcb8b4bb8f.1685461490.git.johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, May 30, 2023 at 08:49:16AM -0700, Johannes Thumshirn wrote:
> alloc_behind_master_bio() can possibly add multiple pages to a bio, but it
> is not checking for the return value of bio_add_page() if adding really
> succeeded.
> 
> Check if the page adding succeeded and if not bail out.
> 
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
