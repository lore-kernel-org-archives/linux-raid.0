Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10659C433EF
	for <linux-raid@archiver.kernel.org>; Sat, 21 May 2022 11:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350067AbiEULoF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 May 2022 07:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349960AbiEULoE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 May 2022 07:44:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CE75717D;
        Sat, 21 May 2022 04:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ZXTWu5ySCQTyau6WRyQYBo6gOg
        197NfPsQGq5285W+0zZdI+Vos8S3ig1Jdok+QF3Tjvg+ltfU6fTZpIHM2n7MMxeRQCLze/5pFfa+T
        ggU0sgfAcUDHGJdsHAW0GheARy800Gb+NUqCPuWd3rVlTt+VDGT+qGF05HVh+5XXXau/Z0arNGdqu
        z72Hz1UywP1WwpUuaiUOlo5DWS2kWGmid+51hTAQqgP/m7IxxE0DzZ1tV3lzid6C2jum3Ny8pBU5g
        XaZnLV3tiYJ4iLCW3WkXIucus4/F5LfmMDvNMpu4US/u7kzG7wCkxCP82UJoIbP4SA6Ne9Kha86NA
        iVSwrFgA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsNWd-00GQGw-IW; Sat, 21 May 2022 11:44:03 +0000
Date:   Sat, 21 May 2022 04:44:03 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH v1 11/15] md/raid5: Ensure array is suspended for calls
 to log_exit()
Message-ID: <YojQg66T2oKHDV9m@infradead.org>
References: <20220519191311.17119-1-logang@deltatee.com>
 <20220519191311.17119-12-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519191311.17119-12-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
