Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067F7C43334
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jul 2022 07:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbiGLHDo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Jul 2022 03:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbiGLHDk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Jul 2022 03:03:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCD61057E;
        Tue, 12 Jul 2022 00:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=sTQGdJSCJ/rBteNrfOF6Wt85x3qfsMQ6GlW2+UrLatk=; b=3TVYRfxfcyBrYzIvKw+tI2eztW
        ObWUgcTh+Jj+8cQ3WrE9OFidC6v7dQJ1bYaIrtycOuTKnLqey7JOB1SV+Rx8wPgSaRLKEU7XYviNj
        gYyTzp+J2noMzRc9YCqqRBM9nWQi2zMbxzjCql96QvBFLookku4677hNp+cwbYxJ5fVhDeIMcGyy1
        oVjHGlT4oIxwVx7kPaEQv3mujl5gPd9/VtoqcVKxHTWmZ45UzHgt+gJsM72uZdU7YvWQjb/d22SoF
        lWrNOA1FTAN0j4TElCNYiHJmfKl+2YAA+uzF/DS9U0og/U+c+YSUqfjrvwcGrw7ED9VSTKIFjgue3
        KoNQ/h6g==;
Received: from ip4d15c27d.dynamic.kabel-deutschland.de ([77.21.194.125] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oB9vi-008DR4-Nb; Tue, 12 Jul 2022 07:03:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: fix md disk_name lifetime problems
Date:   Tue, 12 Jul 2022 09:03:23 +0200
Message-Id: <20220712070331.1390700-1-hch@lst.de>
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

Note that I still can't reproduce this problem so this was based
on code inspection.  Also note that I occasionally run into a hang
in the 07layouts tests with or without this series.

Diffstat:
 md.c |  272 +++++++++++++++++++++++++++++++++----------------------------------
 md.h |    1 
 2 files changed, 139 insertions(+), 134 deletions(-)
