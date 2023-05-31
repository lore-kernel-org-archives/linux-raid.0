Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6939EC77B7C
	for <linux-raid@archiver.kernel.org>; Wed, 31 May 2023 04:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbjEaEX7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 May 2023 00:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234153AbjEaEX5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 31 May 2023 00:23:57 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543CBC9;
        Tue, 30 May 2023 21:23:56 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9924A68B05; Wed, 31 May 2023 06:23:53 +0200 (CEST)
Date:   Wed, 31 May 2023 06:23:53 +0200
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
Subject: Re: [PATCH v6 14/20] md: raid1: use __bio_add_page for adding
 single page to bio
Message-ID: <20230531042353.GL32705@lst.de>
References: <cover.1685461490.git.johannes.thumshirn@wdc.com> <05f4a70914885813a2ccdbb8aa7eb7d75f79329a.1685461490.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05f4a70914885813a2ccdbb8aa7eb7d75f79329a.1685461490.git.johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
