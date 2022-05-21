Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BBE3C433F5
	for <linux-raid@archiver.kernel.org>; Sat, 21 May 2022 11:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350780AbiEULwZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 May 2022 07:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241361AbiEULwY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 May 2022 07:52:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0DF606E5;
        Sat, 21 May 2022 04:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SA3xRokzR4Et1R/kgtmVPGpB/9
        Qy91X8a6+sGerANrSJof4xX6roXc5VvLq0nROnA+YxaDmn33lR6+/G4mgT0Gx+GZBIfP6huA6K5w3
        NuBQJFiWGmNsrGsLRrIm8hW26RIs1X05X+FuLKj7YYCzjQdK6ScAMiKNMZxx5GTezduD998utXZF1
        Ef2/ToJoeENV2D5mJ8IrIyxQotz4qJUNj99RwDCL6DhWf/7y0x9avaJHhxkDhve8shRiruYyjMjlU
        0jR2FU4pN7mIvC0anL3n7R+f0kKUEbsvxMR0Ca4XeQjSFGThmGX3uQ0m9IiwQMKKVy7v1Qx7+2zwH
        xaMAKDnQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsNef-00GR12-SA; Sat, 21 May 2022 11:52:21 +0000
Date:   Sat, 21 May 2022 04:52:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH v1 15/15] md: Notify sysfs sync_completed in
 md_reap_sync_thread()
Message-ID: <YojSdcOgQKrS35XB@infradead.org>
References: <20220519191311.17119-1-logang@deltatee.com>
 <20220519191311.17119-16-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519191311.17119-16-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
