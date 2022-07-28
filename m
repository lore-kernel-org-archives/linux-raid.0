Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D108C19F29
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbiG1MVc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238279AbiG1MVX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:21:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90614B48A
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:21:21 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 93C2F37372;
        Thu, 28 Jul 2022 12:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010880; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SyTUI8OeV0tZf+wPolKJBxWRWvvC9R45oqrJqRIiEWw=;
        b=t4uuoCsZG7+joNKOnUEkpfD1+KXchSaoUyXa6YJAIOh/K9TT9dEwZzE84JeMlBqsL1znyi
        XH0+qsPHaOOtIJOY43SjsUF986IOBXDMLlKiMqfCqwtsC47Zm4ubqj/iUlAh1KkXCnW2K4
        r8qPGvBYTtNIt6FA7jrwEcDR+SWOBb0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010880;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SyTUI8OeV0tZf+wPolKJBxWRWvvC9R45oqrJqRIiEWw=;
        b=LM6RP5/BF+ibNtuTpYbIa8hy0jqzF0HH8cAuqt7Wf+iMoB0ISfsaMbKfA4xnpvbq+MxFFV
        DHwTYUFAjuH42wCw==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id BE1322C141;
        Thu, 28 Jul 2022 12:21:17 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 02/23] DDF: Cleanup validate_geometry_ddf_container()
Date:   Thu, 28 Jul 2022 20:20:40 +0800
Message-Id: <20220728122101.28744-3-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

Move the function up so that the function declaration is not necessary
and remove the unused arguments to the function.

No functional changes are intended but will help with a bug fix in the
next patch.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 super-ddf.c | 88 ++++++++++++++++++++++++-----------------------------
 1 file changed, 39 insertions(+), 49 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index abbc8b09..9d867f69 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -503,13 +503,6 @@ struct ddf_super {
 static int load_super_ddf_all(struct supertype *st, int fd,
 			      void **sbp, char *devname);
 static int get_svd_state(const struct ddf_super *, const struct vcl *);
-static int
-validate_geometry_ddf_container(struct supertype *st,
-				int level, int layout, int raiddisks,
-				int chunk, unsigned long long size,
-				unsigned long long data_offset,
-				char *dev, unsigned long long *freesize,
-				int verbose);
 
 static int validate_geometry_ddf_bvd(struct supertype *st,
 				     int level, int layout, int raiddisks,
@@ -3322,6 +3315,42 @@ static int reserve_space(struct supertype *st, int raiddisks,
 	return 1;
 }
 
+static int
+validate_geometry_ddf_container(struct supertype *st,
+				int level, int raiddisks,
+				unsigned long long data_offset,
+				char *dev, unsigned long long *freesize,
+				int verbose)
+{
+	int fd;
+	unsigned long long ldsize;
+
+	if (level != LEVEL_CONTAINER)
+		return 0;
+	if (!dev)
+		return 1;
+
+	fd = dev_open(dev, O_RDONLY|O_EXCL);
+	if (fd < 0) {
+		if (verbose)
+			pr_err("ddf: Cannot open %s: %s\n",
+			       dev, strerror(errno));
+		return 0;
+	}
+	if (!get_dev_size(fd, dev, &ldsize)) {
+		close(fd);
+		return 0;
+	}
+	close(fd);
+	if (freesize) {
+		*freesize = avail_size_ddf(st, ldsize >> 9, INVALID_SECTORS);
+		if (*freesize == 0)
+			return 0;
+	}
+
+	return 1;
+}
+
 static int validate_geometry_ddf(struct supertype *st,
 				 int level, int layout, int raiddisks,
 				 int *chunk, unsigned long long size,
@@ -3347,11 +3376,9 @@ static int validate_geometry_ddf(struct supertype *st,
 		level = LEVEL_CONTAINER;
 	if (level == LEVEL_CONTAINER) {
 		/* Must be a fresh device to add to a container */
-		return validate_geometry_ddf_container(st, level, layout,
-						       raiddisks, *chunk,
-						       size, data_offset, dev,
-						       freesize,
-						       verbose);
+		return validate_geometry_ddf_container(st, level, raiddisks,
+						       data_offset, dev,
+						       freesize, verbose);
 	}
 
 	if (!dev) {
@@ -3449,43 +3476,6 @@ static int validate_geometry_ddf(struct supertype *st,
 	return 1;
 }
 
-static int
-validate_geometry_ddf_container(struct supertype *st,
-				int level, int layout, int raiddisks,
-				int chunk, unsigned long long size,
-				unsigned long long data_offset,
-				char *dev, unsigned long long *freesize,
-				int verbose)
-{
-	int fd;
-	unsigned long long ldsize;
-
-	if (level != LEVEL_CONTAINER)
-		return 0;
-	if (!dev)
-		return 1;
-
-	fd = dev_open(dev, O_RDONLY|O_EXCL);
-	if (fd < 0) {
-		if (verbose)
-			pr_err("ddf: Cannot open %s: %s\n",
-			       dev, strerror(errno));
-		return 0;
-	}
-	if (!get_dev_size(fd, dev, &ldsize)) {
-		close(fd);
-		return 0;
-	}
-	close(fd);
-	if (freesize) {
-		*freesize = avail_size_ddf(st, ldsize >> 9, INVALID_SECTORS);
-		if (*freesize == 0)
-			return 0;
-	}
-
-	return 1;
-}
-
 static int validate_geometry_ddf_bvd(struct supertype *st,
 				     int level, int layout, int raiddisks,
 				     int *chunk, unsigned long long size,
-- 
2.35.3

