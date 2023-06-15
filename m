Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F43AEB64DB
	for <linux-raid@archiver.kernel.org>; Thu, 15 Jun 2023 06:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244323AbjFOGu2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Jun 2023 02:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244506AbjFOGt4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 15 Jun 2023 02:49:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145E330DE;
        Wed, 14 Jun 2023 23:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=s/d9J5cjhwUF91aZ137qKB6WODACzD1ASHC4knW7Yd4=; b=GftCUxStd82lvmb0kbar3xxuTc
        qzRKvI99qTcEw19ZVq+WCOr+G10KCyJ8ONpzVQdgInu8j8VwAqF8xYR2sNt34GMWXJ3AgHcIPvyOP
        fuq7tiJ9K3OAeS5SfyEaNzScKqEEzk08hB1dFYIK0lzudeWLLs8ubZzn7PUy5tBSdUhYqr4Dngvd6
        ulf08yUjJw59/1sCBs3ydswma2xx52LP5Td0jxv6q1n1+KvaxrKdaX7dgjvx9OQte5ZQiTE/h6/NK
        1LjdPI1t8d22eUd1HipcuneLl6aS8LciAvEaSsIUv1H7g8ilGb2Ph+CPA7kZ3L/3/oqhsLMrl5cMW
        qmuoUY5w==;
Received: from 2a02-8389-2341-5b80-8c8c-28f8-1274-e038.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8c8c:28f8:1274:e038] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q9gmo-00Du9f-1z;
        Thu, 15 Jun 2023 06:48:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 03/11] md-bitmap: use %pD to print the file name in md_bitmap_file_kick
Date:   Thu, 15 Jun 2023 08:48:32 +0200
Message-Id: <20230615064840.629492-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230615064840.629492-1-hch@lst.de>
References: <20230615064840.629492-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Don't bother allocating an extra buffer in the I/O failure handler and
instead use the printk built-in format to print the last 4 path name
components.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md-bitmap.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 0b2d8933cbc75e..e4b466522d4e74 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -870,21 +870,13 @@ static void md_bitmap_file_unmap(struct bitmap_storage *store)
  */
 static void md_bitmap_file_kick(struct bitmap *bitmap)
 {
-	char *path, *ptr = NULL;
-
 	if (!test_and_set_bit(BITMAP_STALE, &bitmap->flags)) {
 		md_bitmap_update_sb(bitmap);
 
 		if (bitmap->storage.file) {
-			path = kmalloc(PAGE_SIZE, GFP_KERNEL);
-			if (path)
-				ptr = file_path(bitmap->storage.file,
-					     path, PAGE_SIZE);
-
-			pr_warn("%s: kicking failed bitmap file %s from array!\n",
-				bmname(bitmap), IS_ERR(ptr) ? "" : ptr);
+			pr_warn("%s: kicking failed bitmap file %pD4 from array!\n",
+				bmname(bitmap), bitmap->storage.file);
 
-			kfree(path);
 		} else
 			pr_warn("%s: disabling internal bitmap due to errors\n",
 				bmname(bitmap));
-- 
2.39.2

