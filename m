Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB76C77B73
	for <linux-raid@archiver.kernel.org>; Tue, 30 May 2023 15:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbjE3P66 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 30 May 2023 11:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbjE3P6x (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 30 May 2023 11:58:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44C7EC;
        Tue, 30 May 2023 08:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Xo+9YJqIlNX5CkXFPT9/tOeJlUpNZJWwJsWPiPRjO34=; b=a/4wUBQBOA7ZKeL+US2Hb0UQ5B
        /uyae9/MztFBLT6xagj5Kj2uv4hUiq2xViYGiPyQzX5Dq1TrmE8j/2BmArhkvRNdZnoJKHuR3oGjT
        q70EOipgTCOr/gMVzEKY8Fld1WQ3d/Wei+V81fuf1wVcN0h4k+CwBCbTwkDA5byJ8rA+Q75oIpbuM
        iI75d5d8+/HxTAiGtolR57f7tauEk6fbSDNcy1G4kDvEbevNMhKYhPjvMkEn8KzgDS5lB3DBvpG4n
        vFNEkSG3LolLX4YWiZguakd3aNdyD1HVVpI5G4nS+PAQU4T04qEMPX+yl4QDrn2KolGB81WSxTBfA
        Ed6MfK9g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1q41jm-006QJo-VH; Tue, 30 May 2023 15:58:19 +0000
Date:   Tue, 30 May 2023 16:58:18 +0100
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
Subject: Re: [PATCH v6 19/20] fs: iomap: use __bio_add_folio where possible
Message-ID: <ZHYdGlqnl922CDe0@casper.infradead.org>
References: <cover.1685461490.git.johannes.thumshirn@wdc.com>
 <e809b83d60d9fb0f65a8116b3e50f1432f594725.1685461490.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e809b83d60d9fb0f65a8116b3e50f1432f594725.1685461490.git.johannes.thumshirn@wdc.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, May 30, 2023 at 08:49:22AM -0700, Johannes Thumshirn wrote:
> When the iomap buffered-io code can't add a folio to a bio, it allocates a
> new bio and adds the folio to that one. This is done using bio_add_folio(),
> but doesn't check for errors.
> 
> As adding a folio to a newly created bio can't fail, use the newly
> introduced __bio_add_folio() function.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

