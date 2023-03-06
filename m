Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED46C61DA4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjCFV3q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjCFV3L (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91AE46097
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=loruWx+IofCSbiLRR0IdR2DFgCl8R6FSWFgPINy/p2A=;
        b=ERJ1Q1ZjGFXcaCD20D++sFTccAQ+Tw3FGkbkf825371A/9g3WR0AJk3E3pZn4jws8zXa41
        glGYlpYYxSDO9GdycgcZQiztCEGxHEmOT7JywM8MmmjwvuMcZ91N89Y8lsJEKSkFVx4rrI
        8evj07ZIVdQXdekCd0mALHjU5IdUxtw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-StXZ-MJdNI6AdwtaEjOzdA-1; Mon, 06 Mar 2023 16:28:16 -0500
X-MC-Unique: StXZ-MJdNI6AdwtaEjOzdA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EDAE802C18
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:16 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB88240B40E4;
        Mon,  6 Mar 2023 21:28:15 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 17/34] md: add missing function identifier names to function definition arguments [WARNING]
Date:   Mon,  6 Mar 2023 22:27:40 +0100
Message-Id: <4971d9e404b4cdb6b6803d6f2866e9f5f291113e.1678136717.git.heinzm@redhat.com>
In-Reply-To: <cover.1678136717.git.heinzm@redhat.com>
References: <cover.1678136717.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: heinzm <heinzm@redhat.com>
---
 drivers/md/md.c          |  4 ++--
 include/linux/raid/pq.h  |  8 ++++----
 include/linux/raid/xor.h | 28 ++++++++++++++--------------
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e63543c98ba6..dbdd0288ddd2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2878,8 +2878,8 @@ static int cmd_match(const char *cmd, const char *str)
 
 struct rdev_sysfs_entry {
 	struct attribute attr;
-	ssize_t (*show)(struct md_rdev *, char *);
-	ssize_t (*store)(struct md_rdev *, const char *, size_t);
+	ssize_t (*show)(struct md_rdev *rdev, char *buf);
+	ssize_t (*store)(struct md_rdev *rdev, const char *buf, size_t sz);
 };
 
 static ssize_t
diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 7fa2bef58ff3..41c525e4c959 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -70,8 +70,8 @@ extern const char raid6_empty_zero_page[PAGE_SIZE];
 
 /* Routine choices */
 struct raid6_calls {
-	void (*gen_syndrome)(int, size_t, void **);
-	void (*xor_syndrome)(int, int, int, size_t, void **);
+	void (*gen_syndrome)(int disks, size_t bytes, void **ptrs);
+	void (*xor_syndrome)(int disks, int start, int stop, size_t bytes, void **ptrs);
 	int  (*valid)(void);	/* Returns 1 if this routine set is usable */
 	const char *name;	/* Name of this routine set */
 	int priority;		/* Relative priority ranking if non-zero */
@@ -111,8 +111,8 @@ extern const struct raid6_calls raid6_vpermxor4;
 extern const struct raid6_calls raid6_vpermxor8;
 
 struct raid6_recov_calls {
-	void (*data2)(int, size_t, int, int, void **);
-	void (*datap)(int, size_t, int, void **);
+	void (*data2)(int disks, size_t bytes, int faila, int failb, void **ptrs);
+	void (*datap)(int disks, size_t bytes, int faila, void **ptrs);
 	int  (*valid)(void);
 	const char *name;
 	int priority;
diff --git a/include/linux/raid/xor.h b/include/linux/raid/xor.h
index 231f467935a9..1630b0681099 100644
--- a/include/linux/raid/xor.h
+++ b/include/linux/raid/xor.h
@@ -11,20 +11,20 @@ struct xor_block_template {
 	struct xor_block_template *next;
 	const char *name;
 	int speed;
-	void (*do_2)(unsigned long, unsigned long *__restrict,
-		     const unsigned long *__restrict);
-	void (*do_3)(unsigned long, unsigned long *__restrict,
-		     const unsigned long *__restrict,
-		     const unsigned long *__restrict);
-	void (*do_4)(unsigned long, unsigned long *__restrict,
-		     const unsigned long *__restrict,
-		     const unsigned long *__restrict,
-		     const unsigned long *__restrict);
-	void (*do_5)(unsigned long, unsigned long *__restrict,
-		     const unsigned long *__restrict,
-		     const unsigned long *__restrict,
-		     const unsigned long *__restrict,
-		     const unsigned long *__restrict);
+	void (*do_2)(unsigned long bytes, unsigned long *__restrict p1,
+		     const unsigned long *__restrict p2);
+	void (*do_3)(unsigned long bytes, unsigned long *__restrict p1,
+		     const unsigned long *__restrict p2,
+		     const unsigned long *__restrict p3);
+	void (*do_4)(unsigned long bytes, unsigned long *__restrict p1,
+		     const unsigned long *__restrict p2,
+		     const unsigned long *__restrict p3,
+		     const unsigned long *__restrict p4);
+	void (*do_5)(unsigned long bytes, unsigned long *__restrict p1,
+		     const unsigned long *__restrict p2,
+		     const unsigned long *__restrict p3,
+		     const unsigned long *__restrict p4,
+		     const unsigned long *__restrict p5);
 };
 
 #endif
-- 
2.39.2

