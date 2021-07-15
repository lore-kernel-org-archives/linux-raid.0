Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0585BC47E48
	for <linux-raid@archiver.kernel.org>; Thu, 15 Jul 2021 03:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4A0E61396
	for <linux-raid@archiver.kernel.org>; Thu, 15 Jul 2021 03:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbhGODTZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Jul 2021 23:19:25 -0400
Received: from foss.arm.com ([217.140.110.172]:46074 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234086AbhGODTY (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 14 Jul 2021 23:19:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA20D11D4;
        Wed, 14 Jul 2021 20:16:31 -0700 (PDT)
Received: from entos-ampere-02.shanghai.arm.com (entos-ampere-02.shanghai.arm.com [10.169.214.103])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 68A823F7D8;
        Wed, 14 Jul 2021 20:16:29 -0700 (PDT)
From:   Jia He <justin.he@arm.com>
To:     linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, nd@arm.com,
        Jia He <justin.he@arm.com>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org
Subject: [PATCH RFC 11/13] md/bitmap: simplify the printing with '%pD' specifier
Date:   Thu, 15 Jul 2021 11:15:31 +0800
Message-Id: <20210715031533.9553-12-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210715031533.9553-1-justin.he@arm.com>
References: <20210715031533.9553-1-justin.he@arm.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

After the behavior of '%pD' is changed to print the full path of file,
the log printing can be simplified.

Given the space with proper length would be allocated in vprintk_store(),
it is worthy of dropping kmalloc()/kfree() to avoid additional space
allocation. The error case is well handled in d_path_unsafe(), the error
string would be copied in '%pD' buffer, no need to additionally handle
IS_ERR().

Cc: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Jia He <justin.he@arm.com>
---
 drivers/md/md-bitmap.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index e29c6298ef5c..a82f1c2ef83c 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -862,21 +862,12 @@ static void md_bitmap_file_unmap(struct bitmap_storage *store)
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
-
-			kfree(path);
+			pr_warn("%s: kicking failed bitmap file %pD from array!\n",
+				bmname(bitmap), bitmap->storage.file);
 		} else
 			pr_warn("%s: disabling internal bitmap due to errors\n",
 				bmname(bitmap));
-- 
2.17.1

