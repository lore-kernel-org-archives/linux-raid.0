Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBFC6C433B4
	for <linux-raid@archiver.kernel.org>; Sat,  3 Apr 2021 16:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DF086124B
	for <linux-raid@archiver.kernel.org>; Sat,  3 Apr 2021 16:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236868AbhDCQPj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Apr 2021 12:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbhDCQPj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Apr 2021 12:15:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E14C0613E6
        for <linux-raid@vger.kernel.org>; Sat,  3 Apr 2021 09:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=ZCzyJp/szRj42DxvF7tYQkW86L4YloRj/HygXGsETBo=; b=L0E0zXIMsYmCApWCRITwuwbFEo
        Bf8UpS1JK7qGrFk/R+TNFQNgOBrkgGQVYX3wvRZoSnWc8bURWXlvQH8dMwpG2qVyEcDP5XjEF8Wr6
        Le7pcAK88LjvRU9xmjyDKFl7hHuU6Oq7d2VWzZ6Vgp2Fw8CADJh8SKlatv844KXcktBFqen2dG8Jx
        lsUO3ENS2X42KsiMsrnpPADxPxXQoVx3OHAkzSKs9d7E3LVTc0mgYmo4JfUIAh7n049BU7/xY30Vl
        G5gjNAayoZVlizuWD2Qif3W0sWBkwZ0CHtm+/V5euJgqdELEr/g+gNCKK6+x08iDMQy4yVE0u54sl
        OzdxTZSg==;
Received: from [2001:4bb8:180:7517:4144:afdd:43c5:e0fc] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lSivs-000PIx-EM; Sat, 03 Apr 2021 16:15:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     song@kernel.org, Zhao Heming <heming.zhao@suse.com>
Cc:     lidong.zhong@suse.com, linux-raid@vger.kernel.org
Subject: split mddev_find and don't create new instance in ->open
Date:   Sat,  3 Apr 2021 18:15:27 +0200
Message-Id: <20210403161529.659555-1-hch@lst.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Hi Song,

this series split mddev_find so that no new instances get created
in ->open.  This was originally part of a larger cleanup, but it
turns out to actually fix a bug found by Zhao.
