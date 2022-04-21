Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95595C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 21 Apr 2022 06:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384726AbiDUGVA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 21 Apr 2022 02:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352817AbiDUGU6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 21 Apr 2022 02:20:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65DA13D04;
        Wed, 20 Apr 2022 23:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=danppd18zmWJSI5yiuJOh+P/ow
        hDyqbRY3EfxE2YfbwndZDHv1P2sZHTuLHEoaD+qpd9tgPCbjXGAhhC4b7lknkgrsfxI/dGfS6mrKU
        U2rrcjPdYscUTyv1/UrXLs2a21S5J93ucnISWARcMUxDPU/IWtypcrbqiuFaF3RHzQ2JsIU+9J8Fm
        kSRPj43seoquP11JZDU55i1R0crS/a2MH7QK8WZeHTogfrNuBVP8e7lvf0b5ljfKWJqxxTjeidcd2
        LXAPRc+qkNdvi8onOC9d0NvZcRS7a2s8HT2sZtorYulIpKZDDN6iJiMwa2p+fqyr01eP8e9V8PlhR
        rYAHEtpw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nhQ8n-00BfY9-Rj; Thu, 21 Apr 2022 06:18:09 +0000
Date:   Wed, 20 Apr 2022 23:18:09 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH v2 10/12] md/raid5: Refactor add_stripe_bio()
Message-ID: <YmD3IWas3L2aNx17@infradead.org>
References: <20220420195425.34911-1-logang@deltatee.com>
 <20220420195425.34911-11-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420195425.34911-11-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
