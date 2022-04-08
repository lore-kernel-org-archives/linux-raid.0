Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 774D4C433EF
	for <linux-raid@archiver.kernel.org>; Fri,  8 Apr 2022 06:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235146AbiDHGJb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Apr 2022 02:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235120AbiDHGJa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Apr 2022 02:09:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD861275DB;
        Thu,  7 Apr 2022 23:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=E0lWgy5UezDBGhUAFoqnFena11
        8WbbE3Hos5oXFMiMzmaAIS9Lxdu0t3DmRkJHIBUIaEGysWakCJb6hMH/CUGJ+XqI//jc6UG4wYemB
        O49Era4tvSPs2/J87CVjql6FKsNPVqmGMeSpcbqwJkG/RCuB6Pa2fhX7FeIJFETMpRxOdGH4upLNk
        sHpaUnbjUrRvfrPTVuyCblG5de2du1L2dHUD4CKURcnS3AB7Vl3RUoFcRBfmdokrPjTePRlIELisa
        OOP5PBp4V0P3RnjrI/LpZ8Fhgx3mNDB0DeeTDQ47w5kfnVDb4VOqF2rYlbm9p5n/KPazrZnZp3hC+
        yy7/6eBg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nchmJ-00FESF-UP; Fri, 08 Apr 2022 06:07:27 +0000
Date:   Thu, 7 Apr 2022 23:07:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH v1 4/7] md/raid5: Annotate rdev/replacement accesses when
 nr_pending is elevated
Message-ID: <Yk/RH+qHio2X5IBE@infradead.org>
References: <20220407165713.9243-1-logang@deltatee.com>
 <20220407165713.9243-5-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407165713.9243-5-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
