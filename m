Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4558AC433DB
	for <linux-raid@archiver.kernel.org>; Mon,  1 Feb 2021 13:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7E7F64E7A
	for <linux-raid@archiver.kernel.org>; Mon,  1 Feb 2021 13:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhBANVy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 1 Feb 2021 08:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbhBANSJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 1 Feb 2021 08:18:09 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFEBC061756;
        Mon,  1 Feb 2021 05:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=wgwsamQCiJKtov5OHwT8lGnNWW3TS9NAkb3MFLDX0zs=; b=v35GGUCNHk/G/tTdr8HvJb2Dmd
        hbdM89KYGpGIhfA7SdR/+v08KdBSJXQY+ADJp0h3RwxleCin6HKOQmRO5hceJ+lgGEmaft6psM7Bn
        cBk+SjB3Yb28wNfuBP+1FOUMVK4KknlLjCXZO9wdwmf5nRJPasHsUqweQelETeoJFsL8c5TSfo25G
        UmzzEHzXZqFpdgnMEZA/RfDfcxxoU855WKvwC04jBjCkktAsdyg4QoMqNSry7LOj0XJytw9uEVPCu
        Ft5sJhfeOQ4aADKQQwB5N926AKvrfuk86cEln1cCwXyU4n3t5bMdjqnm9rHV59up9t/UNUNqw6jk6
        0cpDDfmw==;
Received: from [2001:4bb8:198:6bf4:18db:1a43:4422:423f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l6Z51-00Do2n-B6; Mon, 01 Feb 2021 13:17:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk, song@kernel.org
Cc:     guoqing.jiang@cloud.ionos.com, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: md read-only fixes
Date:   Mon,  1 Feb 2021 14:17:19 +0100
Message-Id: <20210201131721.750412-1-hch@lst.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all,

patch 1 fixes a regression in md in for-5.12/block, and patch 2
fixes a little inconsistency in the same area.
