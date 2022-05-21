Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 352ACC433EF
	for <linux-raid@archiver.kernel.org>; Sat, 21 May 2022 11:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243240AbiEULm0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 May 2022 07:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243180AbiEULmY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 May 2022 07:42:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796FC57163;
        Sat, 21 May 2022 04:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=k4lP7sh+PQp2Fyt8ojx3/wTCDq
        W4jYRooDlf8prNyBOf8S0frXCDRPEP58uiHBnJC2uqRD0TikP+XURNQ8URO9RxrN1ZO4tG/J0kg9F
        TNCI3Vd5OkEHvyuwGaFjxNdVliVZAtmDfb5SdeXHa/KHGflfQvcOfeWLsldx8FDkzka6vSx1zh2Oo
        QjBUMTi4d7jo4KzY/uQ0NzvKbuAmq3iXfksFTKrKWizEvqK1AUQSOs0s48WassGRvRZa+B3Y39q0b
        yMgXV3QOOcZnAZlgeAVOZbvw9SLEgF35ll4G7Og125gQNZ04VuJJPHcRdI1v85JCD3DG6aXLJJyOK
        KNZ3vhUQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsNV0-00GQ3o-Sy; Sat, 21 May 2022 11:42:22 +0000
Date:   Sat, 21 May 2022 04:42:22 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH v1 08/15] md/raid5-cache: Pass the log through to
 r5c_finish_cache_stripe()
Message-ID: <YojQHk0wEWptZ/G3@infradead.org>
References: <20220519191311.17119-1-logang@deltatee.com>
 <20220519191311.17119-9-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519191311.17119-9-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
