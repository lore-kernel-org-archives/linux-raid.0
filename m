Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD1FBCCA485
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 09:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237201AbiGSJTR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 05:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237030AbiGSJSt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 05:18:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CF23CBCA;
        Tue, 19 Jul 2022 02:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=BWHU/qiQ/hDDEsc8QOBKzO6kidTibXRobxGYXa9myaE=; b=VzJqY+2LrcHq/kzj/zmTOjx8kY
        R1vx3fgu3B791DdMuAdGubgextv43rd9RWOPbOpSy/uxlrBtE7gMMhfSKbqUipG/Nj6pOBPmoMJRe
        Ro2T7gLt+lWe6eBqW3N3Eao9v4zwY17mefj0fkiheen61acsO82taVdMQjqxMxJzz5Pe5ofYy70WP
        uDiXLPWIzhl2z+FxBlqYJO8sEZKVfSZQFzYee2+m12TcUT8AOz1x8+L5XFq7zhi1jI0CQ+YlJSFJN
        /d4DiWAoYIq6v9BTIJH0In5J92LqJVEDaC1ylzvAOs9hzFuHbxwy/JTiGkW9olDCQ/MwAwq1F2jn1
        7/mpwcYA==;
Received: from 089144198117.atnat0007.highway.a1.net ([89.144.198.117] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDjN6-007C3N-Aw; Tue, 19 Jul 2022 09:18:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: fix md disk_name lifetime problems v4
Date:   Tue, 19 Jul 2022 11:18:14 +0200
Message-Id: <20220719091824.1064989-1-hch@lst.de>
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

Changes since v3:
 - remove a now superflous mddev->gendisk NULL check
 - use a bit in mddev->flags instead of a new field

Changes since v2:
 - delay mddev->kobj initialization

Changes since v1:
 - rebased to the md-next branch
 - fixed error handling in md_alloc for real
 - add a little cleanup patch

Diffstat:
 md.c |  310 +++++++++++++++++++++++++++++++++++--------------------------------
 md.h |    2 
 2 files changed, 165 insertions(+), 147 deletions(-)
