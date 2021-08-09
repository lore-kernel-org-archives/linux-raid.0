Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB286C432BE
	for <linux-raid@archiver.kernel.org>; Mon,  9 Aug 2021 06:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91D8C60E78
	for <linux-raid@archiver.kernel.org>; Mon,  9 Aug 2021 06:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbhHIGqE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 Aug 2021 02:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbhHIGqE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 Aug 2021 02:46:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DEDC0613D3;
        Sun,  8 Aug 2021 23:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=NyjYltYC/raPlF4XHxY3F3mjS/roqOl5OXN2A+UG0sI=; b=XZ6Fe+c5WNOFVTjVMBbxBIYwan
        kL5bvLiWDk3ACEJbkJIh5zEAbxuSN+MsbJDwesuoaxxImWmaxyXh/frS+U19dFu0G7r9/n+9tlNHz
        VCtOyz+kJ/h1Nlx/nuaBBjuoeTAKm2ii/Hq0fHLb7IPwS6LMFgk7zoD/2UOlQpY+nt7yhpfPkGGLu
        RaLw1uVCSJbyPY4Inv/2gCXwYecsVAxRjZdErcC0yH69I0/+GOkhPyqJo+w+anKm0FMDxNM7IV9IX
        eZVSzPRvs1YMM4n1j+x0rg2PLhIiOU9w97Z8MeA3grTRsoWNxGe5o0odFl2MQkpEiCXhaaAoHSeWe
        J8SpJHQg==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mCz1G-00Aild-HU; Mon, 09 Aug 2021 06:44:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Coly Li <colyli@suse.de>, Song Liu <song@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: [PATCH 4/8] nvme: replace the GENHD_FL_UP check in nvme_mpath_shutdown_disk
Date:   Mon,  9 Aug 2021 08:40:24 +0200
Message-Id: <20210809064028.1198327-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210809064028.1198327-1-hch@lst.de>
References: <20210809064028.1198327-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Use the nvme-internal NVME_NSHEAD_DISK_LIVE flag instead of abusing
the block layer state.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/multipath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 3f32c5e86bfc..37ce3e8b1db2 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -765,7 +765,7 @@ void nvme_mpath_shutdown_disk(struct nvme_ns_head *head)
 	if (!head->disk)
 		return;
 	kblockd_schedule_work(&head->requeue_work);
-	if (head->disk->flags & GENHD_FL_UP) {
+	if (test_bit(NVME_NSHEAD_DISK_LIVE, &head->flags)) {
 		nvme_cdev_del(&head->cdev, &head->cdev_device);
 		del_gendisk(head->disk);
 	}
-- 
2.30.2

