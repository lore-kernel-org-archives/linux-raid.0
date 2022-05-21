Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB5FC433EF
	for <linux-raid@archiver.kernel.org>; Sat, 21 May 2022 11:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241868AbiEULmD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 May 2022 07:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiEULmB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 May 2022 07:42:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA0C48E51;
        Sat, 21 May 2022 04:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3RM74IgYt2Wlx0/u9ckYoY2Dbl
        u9fE4pjvw/bbwk0SFdo8mWvoxX5S1hdlmbBUKWZXQ9VA20GavQtbSMghM8KPxk/N0Lw3lHGhy6HtJ
        5JQmzfFc3GvyWwrH6NHxpEawoY4qic6fHOVmTtWgrO8Je71B3FNyJkl4xBdNrmyeKX/P5yzrhnabD
        a3PCPc98Eaz4ddEoykcTJNS43hng/rxG3mWHWAgaHGwD2PVq4OvcHC2TJvtNmgEFKf1pDAc5UtnD0
        44XpKUW5AqtkUiyDX8CWcQfZyLq8mWlqOMlTjDoK1kHvueHLQShC0xJrGkJ/e/xV9OsokZoXRFvUA
        uEBQsblw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsNUd-00GPwJ-H4; Sat, 21 May 2022 11:41:59 +0000
Date:   Sat, 21 May 2022 04:41:59 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH v1 07/15] md/raid5-ppl: Drop unused argument from
 ppl_handle_flush_request()
Message-ID: <YojQBypoFBzG+xwo@infradead.org>
References: <20220519191311.17119-1-logang@deltatee.com>
 <20220519191311.17119-8-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519191311.17119-8-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
