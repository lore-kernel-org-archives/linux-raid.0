Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3EDCC4321E
	for <linux-raid@archiver.kernel.org>; Tue, 29 Nov 2022 13:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbiK2Nd2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Nov 2022 08:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbiK2NdB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 29 Nov 2022 08:33:01 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403C5627E3
        for <linux-raid@vger.kernel.org>; Tue, 29 Nov 2022 05:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=YU5BVEpt7TnokiHDNzQZcyOgYAqAp/58NiFkaktcO4A=; b=TTPQtpk1nj8A9zsj1HnW6cJkj4
        0y7yPUIqc5WpHgLKKnXLMrUiO7D2YDmUlCXduXyztxJv323uFQTW0XyYifscx+c2e1wG37/2MMy9c
        KgLvYnrDyDt5urxgE72LNsKxgQ01I+ltHwW9C1Vfn4ElZaLVMI8WtDJ4JYtoHiDW3PWnkiEWpsLfP
        2gu6qBySJf6PcDsznixzbO2+xB7RTiiAUkJ8RUHshyqGWoSm/O5IcZlXDfH7kMk9LLT3F+rNFQ7Pu
        a90ff3v3ZsyMKL6kDE6ilpxLjFh5DCyYh4eDrzvVl1V+B4ByG0SHnl67HWRMcWL4pOL6r07jp9kLF
        0Wmzea3g==;
Received: from [2001:4bb8:192:26e7:691d:40a8:d7b5:b2f5] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p00jK-008pkR-5a; Tue, 29 Nov 2022 13:32:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: minor md cleanups
Date:   Tue, 29 Nov 2022 14:32:52 +0100
Message-Id: <20221129133255.8228-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,

this small series has a few random md cleanups.

Diffstat:
 md.c |   97 ++++++++++++++++++++++++-------------------------------------------
 md.h |    1 
 2 files changed, 36 insertions(+), 62 deletions(-)
