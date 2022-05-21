Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B361C433F5
	for <linux-raid@archiver.kernel.org>; Sat, 21 May 2022 11:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346710AbiEULm4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 May 2022 07:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237616AbiEULmy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 May 2022 07:42:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7B5527D7;
        Sat, 21 May 2022 04:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dbtGjLXlpuQi4mE3g186QKbVfT
        WaYzjjDLE9cloTcxRFW7lU9CTdajkj1qPE7ta6KWPsqJYfJOKQLp9hyfS58cYkCvFMeuGAtsgCZM5
        VVS2AHD3krPEUNutG1MgYJjxEoMO6oMv6Pu6DUJmwM9dJjRbNk5biRjVKCijuAnXetDjBiv3T7MwH
        8aOHZw0ZxKD1Oe0vT5r3VxM1kErQP6AUZa1vHbI5/X/2K3Jb8JRqkhZS68BR8TK4lQrbU+qfcPbCu
        kNXUAjO8oLQWlIQll721Wfr3EA8k4Ytxe/TL51QaOxTvKzRul+ERmnlrH20/cS/675g7oC3QICQDo
        TFfr9tBw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsNVV-00GQ7P-5R; Sat, 21 May 2022 11:42:53 +0000
Date:   Sat, 21 May 2022 04:42:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH v1 09/15] md/raid5-cache: Don't pass conf to
 r5c_calculate_new_cp()
Message-ID: <YojQPbWWzOAB21NP@infradead.org>
References: <20220519191311.17119-1-logang@deltatee.com>
 <20220519191311.17119-10-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519191311.17119-10-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
