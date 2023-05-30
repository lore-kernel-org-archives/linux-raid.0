Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 567EEC7EE31
	for <linux-raid@archiver.kernel.org>; Tue, 30 May 2023 15:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbjE3P73 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 30 May 2023 11:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233146AbjE3P7T (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 30 May 2023 11:59:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A361AD;
        Tue, 30 May 2023 08:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=18OSvYiG0zIcEikpFuO5yhaNcppNczPdkyzmCbvrupw=; b=PQ7AUm4XmnRX/4BaMtwqnZFAQx
        xQiTbKyqkKcVG7e15O+WskcS69vdvksxtc/q+R7kTa8LZmQPPAqJSJZWh3nyQA4iG1u4z/VA14rAd
        zPBVbJI0piRA8g5fixcGudecRTQ0mT67MUv19JKHQKsELGGBWyBOx+H1/e8yB25df7rj4TVyBDBmt
        K/X0ZvHTImU88VELnSxLmQ8k9uq5mntW+w3tblr9JupFCIvj3BfZ23BMFw+fi0UkIrPg/v/qEe3MC
        9jBcrMWe3r05qiGG8t/0HubdNMJh+3SYkCxGNMu0ArKeSbop61CdcLGnJvi0JBDefL8H8BAhUcHRo
        kxzwRIog==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1q41kO-006QMe-SK; Tue, 30 May 2023 15:58:56 +0000
Date:   Tue, 30 May 2023 16:58:56 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        dm-devel@redhat.com, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
        Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, gouhao@uniontech.com
Subject: Re: [PATCH v6 20/20] block: mark bio_add_folio as __must_check
Message-ID: <ZHYdQJQ7S4ya09Jt@casper.infradead.org>
References: <cover.1685461490.git.johannes.thumshirn@wdc.com>
 <3d45098a7640897cbace54713efe10d88b74c160.1685461490.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d45098a7640897cbace54713efe10d88b74c160.1685461490.git.johannes.thumshirn@wdc.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, May 30, 2023 at 08:49:23AM -0700, Johannes Thumshirn wrote:
> Now that all callers of bio_add_folio() check the return value, mark it as
> __must_check.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

