Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B26CCA482
	for <linux-raid@archiver.kernel.org>; Wed, 13 Jul 2022 11:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbiGMLbf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Jul 2022 07:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbiGMLbe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Jul 2022 07:31:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28855102706;
        Wed, 13 Jul 2022 04:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=YNS/89eo3e8dDi3IaxpFjCw0cuOTBuwT1526YK4upVk=; b=fZu0K/p1wLy5jqBPUySQMkC390
        NtkoDOul4jyYpp8ku3dh0JxB/7QdB1Z4JpRP1L99QExj7iCoBCC0LT98BY+3uPqafbRpXg0mqHsX8
        gFIVH2y56dBjjLvr+sNQhT+2gL3N2qQWfWpIVNYB57O04QmHhaOj5qMVcXeA2WIaNcVMqhab6BUdn
        MD+/qLZBwdilwKZLEq4BCvkSClXn0JlbN74ttvgeSuSH7IqgECCBGeV/obg+8avBIYy8T7my4IU4h
        aTok8nKKTEHiQcLYNxqvQezMa/iWXwsJr7Ckku3hScEJoT8G/j2JNGDxeHKGDX+1GSkbCUEktTu46
        weRUt5xA==;
Received: from ip4d15c27d.dynamic.kabel-deutschland.de ([77.21.194.125] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oBaaW-0039xt-6D; Wed, 13 Jul 2022 11:31:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: fix md disk_name lifetime problems v2
Date:   Wed, 13 Jul 2022 13:31:16 +0200
Message-Id: <20220713113125.2232975-1-hch@lst.de>
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

Changes since v1:
 - rebased to the md-next branch
 - fixed error handling in md_alloc for real
 - add a little cleanup patch

Diffstat:
 md.c |  301 +++++++++++++++++++++++++++++++++++--------------------------------
 md.h |    1 
 2 files changed, 161 insertions(+), 141 deletions(-)
