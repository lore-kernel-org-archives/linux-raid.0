Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46000C001DF
	for <linux-raid@archiver.kernel.org>; Thu, 15 Jun 2023 06:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244215AbjFOGuZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Jun 2023 02:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244478AbjFOGty (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 15 Jun 2023 02:49:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E036420F;
        Wed, 14 Jun 2023 23:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=IPL12G5QH3eCAuhTXdricCuM4vzgBPefrkzFmXPBPRQ=; b=RmI7qGQIuXQr/XhUskGsTrth/V
        IMasjn/EJgohNxgOJK2BRTgkIPpy0lkfzKeLsm7zzeyqIoIvUrznoQLw2sXHNMzI5+2OOho70CGUk
        5lQ8ieew48pBH00J50eVtGZRo/neW0pWuI0IsP4ltR9kaQtgue+ki2gFIKlGTm7QnEJUSidroRAVa
        SZdT29wIZiOIcHRgan2V2F+Ofn7d6mHqEatfvDIsHOi/7ko1rDEI/m0WWdekjCdAYHozWdhVZ1b6a
        H/kPtFTFXBBnBTCMg5pRVJK283PAQM+evLlhYcFOxLdSzdd88atRcXFIBCs273bC+mHg2iJQK0ok1
        bUogW08A==;
Received: from 2a02-8389-2341-5b80-8c8c-28f8-1274-e038.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8c8c:28f8:1274:e038] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q9gmh-00Du8k-2D;
        Thu, 15 Jun 2023 06:48:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: deprecate md bitmap file support
Date:   Thu, 15 Jun 2023 08:48:29 +0200
Message-Id: <20230615064840.629492-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,

the md bitmap file support is very problematic in how it bypasses the
file system for file access.  I looked into fixing it in preparation
for making buffer_head optionals but had to give up because it is so
convoluted.  This series includes the cleanups I've started which seem
useful even for the internal bitmap support, then makes the bitmap file
support conditional and adds a deprecation warning.

Diffstat:
 Kconfig     |   10 +
 md-bitmap.c |  339 ++++++++++++++++++++++++++++++------------------------------
 md-bitmap.h |    1 
 md.c        |    9 +
 4 files changed, 191 insertions(+), 168 deletions(-)
