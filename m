Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDABEC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 06:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbiGRGeR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 02:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiGRGeR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 02:34:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7716311C34;
        Sun, 17 Jul 2022 23:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=WLGE2HieRyMcwW3Dc664JxKk5wXe2Zaq3xG/XxSWQqQ=; b=KRn8zixwRJ0O8Do7apYZga+Yru
        iiNIkhPsrEHS9k2lef92AH/hR/Q2EHYBZ72OepA4My+sEQVtTwVpbKL5oBanhyxyufGRixgEB0Hqb
        em7QmobTNOCRIN5O8kOsEGIjDM7IHpqC3cAhA5SCE8m+Mshr2plSDn8ZHl6g4ngK8Q3GJCo5neHne
        v45AtSQYPKahp8jHGETUQ472qsJMj9Bh4xnY4fZbGySifUvXFOcgM1jU9/apsAfE7YxAbY0SGW4xL
        8psdF5BMPIPk/DPYSaWwXgXZUV5XbNMt+idfjhwkiMEVdJ234ITysWX4KEU5M7bYgreQ/svbiKN7i
        IJzTN+Og==;
Received: from 089144198117.atnat0007.highway.a1.net ([89.144.198.117] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDKKb-00BEX3-6H; Mon, 18 Jul 2022 06:34:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: fix md disk_name lifetime problems v3
Date:   Mon, 18 Jul 2022 08:34:00 +0200
Message-Id: <20220718063410.338626-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all,

this series tries to fix a problem repored by Logan where we see
duplicate sysfs file name in md.  It is due to the fact that the
md driver only checks for duplicates on currently live mddevs,
while the sysfs name can live on longer.  It is an old problem,
but the race window got longer due to waiting for the device freeze
earlier in del_gendisk.

Changes since v2:
 - delay mddex->kobj initialization

Changes since v1:
 - rebased to the md-next branch
 - fixed error handling in md_alloc for real
 - add a little cleanup patch

Diffstat:
 md.c |  304 +++++++++++++++++++++++++++++++++++--------------------------------
 md.h |    1 
 2 files changed, 162 insertions(+), 143 deletions(-)
