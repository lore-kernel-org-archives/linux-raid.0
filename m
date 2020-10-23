Return-Path: <SRS0=YfF9=D6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DCA7C4363A
	for <linux-raid@archiver.kernel.org>; Fri, 23 Oct 2020 03:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17DA32177B
	for <linux-raid@archiver.kernel.org>; Fri, 23 Oct 2020 03:32:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=drivescale-com.20150623.gappssmtp.com header.i=@drivescale-com.20150623.gappssmtp.com header.b="Mt2ODQml"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460413AbgJWDcI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Oct 2020 23:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S460316AbgJWDbp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 22 Oct 2020 23:31:45 -0400
Received: from mail-ua1-x961.google.com (mail-ua1-x961.google.com [IPv6:2607:f8b0:4864:20::961])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CB7C0613D7
        for <linux-raid@vger.kernel.org>; Thu, 22 Oct 2020 20:31:44 -0700 (PDT)
Received: by mail-ua1-x961.google.com with SMTP id c7so1121797uaq.4
        for <linux-raid@vger.kernel.org>; Thu, 22 Oct 2020 20:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=drivescale-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=u4+0Y7bAzMg/YXqgTqUkzy2qMdgH2YnKP3AD74JymMo=;
        b=Mt2ODQmlOYCT3IidrPgKgGbfLpkgA2Psax0B2S4SZ1IhFmmMrYu/LmdpzG9dSy6S/P
         agS1OJiKqIEMbpEZKZTwLQ3qafEZfdlh/eCjZhk2OIWjoaHNeCI+vrnaQ9PU+n9WOZkb
         /UCIFEe/F/riaxkJpKvp9YXpvGlwNJOLgDajKXZ6Ki+KvguSIvGbdmm+Rhr1MRK8LevB
         J3QSnWnOGD1h09sr95Njjp5tbNnmDeWeguKlqYPrfMxasyCSZgxezfD2CiPI5Q0XSkZv
         9tF0iEg5z3YmSsWN7H0tGbGZ3xYpn1CQhpZqz6L59Mcw/j5qwXPvhky3mJo1qj5S/1LN
         412g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=u4+0Y7bAzMg/YXqgTqUkzy2qMdgH2YnKP3AD74JymMo=;
        b=UCjO8E6plGYu6kc2ioTgc/J/YQO86iO4ghiwFTk/HKTf9FskBNmlXwswFXHYl7Z5NI
         JOxPZi/7hHqdkZmpORJw7p2iYkIKjNtDMFrbxOKOfDEMdyZWmNY5/4+MP5UPhtK21ZW7
         P/wqXbRhg5bIE3UhVii52JNURMmHQ2+sini5wj9MEW0VlKobwLK4FA+k/qIEq/HsRqNn
         vq6ls7k9GMw8dCJPWjKP8dr7aDyu0SJQE6ozwvxSmhx8feQyzCAqHNilmcgowA4NQ6/d
         PRM524+OWClH7Iykk+aR11gVIdQkdfs8vMXGp2uqAnYq8AbRj++mAfHpspmsOEQXkzJq
         HxIA==
X-Gm-Message-State: AOAM532UgLe6mKo2aV0Lvg6GkL496+MNgl1vFpMxeJ7TJqHNz/1qi3/x
        +JVpkUD1DNXa4DY157UTZR7HhIUmuJYCmXxq8ET36pju2N7Igw==
X-Google-Smtp-Source: ABdhPJyUdYcwe2zd4NKYvrzBKEkN6jghohmqKSxi0Xp5morutnxYFFoKeujE/dWznhiLLTA6ZGZ8ILWKo7n7
X-Received: by 2002:a9f:21ab:: with SMTP id 40mr121810uac.88.1603423903843;
        Thu, 22 Oct 2020 20:31:43 -0700 (PDT)
Received: from dcs.hq.drivescale.com ([68.74.115.3])
        by smtp-relay.gmail.com with ESMTP id y14sm25617vsd.5.2020.10.22.20.31.43;
        Thu, 22 Oct 2020 20:31:43 -0700 (PDT)
X-Relaying-Domain: drivescale.com
Received: from localhost.localdomain (gw1-dc.hq.drivescale.com [192.168.33.175])
        by dcs.hq.drivescale.com (Postfix) with ESMTP id EA60A4211B;
        Fri, 23 Oct 2020 03:31:42 +0000 (UTC)
From:   Christopher Unkel <cunkel@drivescale.com>
To:     linux-raid@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Song Liu <song@kernel.org>,
        cunkel@drivescale.com
Subject: [PATCH 2/3] md: factor sb write alignment check into function
Date:   Thu, 22 Oct 2020 20:31:29 -0700
Message-Id: <20201023033130.11354-3-cunkel@drivescale.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201023033130.11354-1-cunkel@drivescale.com>
References: <20201023033130.11354-1-cunkel@drivescale.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Refactor in preparation for a second use of the logic.

Signed-off-by: Christopher Unkel <cunkel@drivescale.com>
---
 drivers/md/md-bitmap.c | 72 +++++++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 32 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 200c5d0f08bf..600b89d5a3ad 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -209,6 +209,44 @@ static struct md_rdev *next_active_rdev(struct md_rdev *rdev, struct mddev *mdde
 	return NULL;
 }
 
+static int sb_write_alignment_ok(struct mddev *mddev, struct md_rdev *rdev,
+				 struct page *page, int offset, int size)
+{
+	if (mddev->external) {
+		/* Bitmap could be anywhere. */
+		if (rdev->sb_start + offset + (page->index
+					       * (PAGE_SIZE/512))
+		    > rdev->data_offset
+		    &&
+		    rdev->sb_start + offset
+		    < (rdev->data_offset + mddev->dev_sectors
+		     + (PAGE_SIZE/512)))
+			return 0;
+	} else if (offset < 0) {
+		/* DATA  BITMAP METADATA  */
+		if (offset
+		    + (long)(page->index * (PAGE_SIZE/512))
+		    + size/512 > 0)
+			/* bitmap runs in to metadata */
+			return 0;
+		if (rdev->data_offset + mddev->dev_sectors
+		    > rdev->sb_start + offset)
+			/* data runs in to bitmap */
+			return 0;
+	} else if (rdev->sb_start < rdev->data_offset) {
+		/* METADATA BITMAP DATA */
+		if (rdev->sb_start
+		    + offset
+		    + page->index*(PAGE_SIZE/512) + size/512
+		    > rdev->data_offset)
+			/* bitmap runs in to data */
+			return 0;
+	} else {
+		/* DATA METADATA BITMAP - no problems */
+	}
+	return 1;
+}
+
 static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 {
 	struct md_rdev *rdev;
@@ -234,38 +272,8 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 		/* Just make sure we aren't corrupting data or
 		 * metadata
 		 */
-		if (mddev->external) {
-			/* Bitmap could be anywhere. */
-			if (rdev->sb_start + offset + (page->index
-						       * (PAGE_SIZE/512))
-			    > rdev->data_offset
-			    &&
-			    rdev->sb_start + offset
-			    < (rdev->data_offset + mddev->dev_sectors
-			     + (PAGE_SIZE/512)))
-				goto bad_alignment;
-		} else if (offset < 0) {
-			/* DATA  BITMAP METADATA  */
-			if (offset
-			    + (long)(page->index * (PAGE_SIZE/512))
-			    + size/512 > 0)
-				/* bitmap runs in to metadata */
-				goto bad_alignment;
-			if (rdev->data_offset + mddev->dev_sectors
-			    > rdev->sb_start + offset)
-				/* data runs in to bitmap */
-				goto bad_alignment;
-		} else if (rdev->sb_start < rdev->data_offset) {
-			/* METADATA BITMAP DATA */
-			if (rdev->sb_start
-			    + offset
-			    + page->index*(PAGE_SIZE/512) + size/512
-			    > rdev->data_offset)
-				/* bitmap runs in to data */
-				goto bad_alignment;
-		} else {
-			/* DATA METADATA BITMAP - no problems */
-		}
+		if (!sb_write_alignment_ok(mddev, rdev, page, offset, size))
+			goto bad_alignment;
 		md_super_write(mddev, rdev,
 			       rdev->sb_start + offset
 			       + page->index * (PAGE_SIZE/512),
-- 
2.17.1

