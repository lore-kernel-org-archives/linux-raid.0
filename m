Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBD3C433F5
	for <linux-raid@archiver.kernel.org>; Sat, 21 May 2022 11:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348782AbiEULn1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 May 2022 07:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237616AbiEULnZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 May 2022 07:43:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E73527D7;
        Sat, 21 May 2022 04:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=fWFYujZ8qo4zQKXFx7rIYP+uHb
        BTifA8bft482RcZ9QVxrKhLYHgr0ZJFp6O7xuzFvaij4wNHWz1UPQge4q67PB8xzVv4/RLr4G0TT3
        NchTK1ysPiVz5a2xvnk1F3JKZcZ9xKHyszNwm1CJTR4Gb+ORdCUTpLhzNdCUWFAlb1eBPHNoENfkf
        kBgcaS5c1CJOsCwRw40RkCXKx2uprfFy0+LchPbJqsxjfhf5Kr7aCXQMDCCocycCZfA2754+WG2bf
        G6J7F016QvUpDviNzuzALwjsu3u50qh1Cc5ZJs98ci8lLdv7+BZ9ZwQwHr0v8irKTlutp4+79oZWl
        k/wiLFxw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsNVz-00GQBt-VJ; Sat, 21 May 2022 11:43:23 +0000
Date:   Sat, 21 May 2022 04:43:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH v1 10/15] md/raid5-cache: Take struct r5l_log in
 r5c_log_required_to_flush_cache()
Message-ID: <YojQW+IpNxwRbTQ5@infradead.org>
References: <20220519191311.17119-1-logang@deltatee.com>
 <20220519191311.17119-11-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519191311.17119-11-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
