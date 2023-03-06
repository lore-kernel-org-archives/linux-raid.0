Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9F4C61DA4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjCFV3S (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjCFV25 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:28:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB04298CE
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V79xxj0yJFNR7580OLy2ZxJq6stifnVYtPHWblk1Eh8=;
        b=b8QSCBHtV2ziCLIn6spykvzvHhwyyDdoPJFT3jsR9tNNCrNslk8s2yqnGb/RszZ/UEx1rD
        J9WVgJDzKX76Ha5k1uvpUbmeIhRW6M6CzZ7/FBx4KoS6D2NuMJ1YhaB0DFQK/BZHj1G+ls
        s1P3XFtxhWVd0Ig9+tQjR52igoSn4IY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-qB951-IZO1mzv1i5n9MlDQ-1; Mon, 06 Mar 2023 16:28:04 -0500
X-MC-Unique: qB951-IZO1mzv1i5n9MlDQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE6A929DD9A1
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:03 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16A6E400DFA1;
        Mon,  6 Mar 2023 21:28:02 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 05/34] md: correct code indent [ERROR]
Date:   Mon,  6 Mar 2023 22:27:28 +0100
Message-Id: <643f0250f60db01b4d0df97e17892376bcc6fe3c.1678136717.git.heinzm@redhat.com>
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
 drivers/md/md.c          | 18 +++++++-----------
 drivers/md/md.h          |  9 +++++----
 drivers/md/raid1.c       |  5 ++---
 drivers/md/raid10.c      |  9 ++++-----
 drivers/md/raid5.c       |  2 +-
 include/linux/raid/xor.h |  6 +++---
 6 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 315b0810dbdd..f8d44832339e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -27,12 +27,11 @@
    Errors, Warnings, etc.
    Please use:
      pr_crit() for error conditions that risk data loss
-     pr_err() for error conditions that are unexpected, like an IO error
-         or internal inconsistency
+     pr_err()  for error conditions that are unexpected, like an IO error or internal inconsistency
      pr_warn() for error conditions that could have been predicated, like
-         adding a device to an array when it has incompatible metadata
+	       adding a device to an array when it has incompatible metadata
      pr_info() for every interesting, very rare events, like an array starting
-         or stopping, or resync starting or stopping
+	       for stopping, or resync starting or stopping
      pr_debug() for everything else.
 
 */
@@ -3249,9 +3248,8 @@ static ssize_t new_offset_store(struct md_rdev *rdev,
 		;
 	else if (new_offset > rdev->data_offset) {
 		/* must not push array size beyond rdev_sectors */
-		if (new_offset - rdev->data_offset
-		    + mddev->dev_sectors > rdev->sectors)
-				return -E2BIG;
+		if (new_offset - rdev->data_offset + mddev->dev_sectors > rdev->sectors)
+			return -E2BIG;
 	}
 	/* Metadata worries about other space details. */
 
@@ -5824,10 +5822,8 @@ int md_run(struct mddev *mddev)
 			/* Nothing to check */;
 		} else if (rdev->data_offset < rdev->sb_start) {
 			if (mddev->dev_sectors &&
-			    rdev->data_offset + mddev->dev_sectors
-			    > rdev->sb_start) {
-				pr_warn("md: %s: data overlaps metadata\n",
-					mdname(mddev));
+			    rdev->data_offset + mddev->dev_sectors > rdev->sb_start) {
+				pr_warn("md: %s: data overlaps metadata\n", mdname(mddev));
 				return -EINVAL;
 			}
 		} else {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 45f8ada8814e..9408cfbd92db 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1,9 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
-   md.h : kernel internal structure of the Linux MD driver
-          Copyright (C) 1996-98 Ingo Molnar, Gadi Oxman
-
-*/
+ * md.h : kernel internal structure of the Linux MD driver
+ *
+ *	Copyright (C) 1996-98 Ingo Molnar, Gadi Oxman
+ *
+ */
 
 #ifndef _MD_MD_H
 #define _MD_MD_H
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 415b1dd55baa..809a46dbbaef 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1324,12 +1324,11 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	read_bio->bi_opf = op | do_sync;
 	if (test_bit(FailFast, &mirror->rdev->flags) &&
 	    test_bit(R1BIO_FailFast, &r1_bio->state))
-	        read_bio->bi_opf |= MD_FAILFAST;
+		read_bio->bi_opf |= MD_FAILFAST;
 	read_bio->bi_private = r1_bio;
 
 	if (mddev->gendisk)
-	        trace_block_bio_remap(read_bio, disk_devt(mddev->gendisk),
-				      r1_bio->sector);
+		trace_block_bio_remap(read_bio, disk_devt(mddev->gendisk), r1_bio->sector);
 
 	submit_bio_noacct(read_bio);
 }
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index cdc2f2557966..a26a3764b234 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1257,12 +1257,11 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	read_bio->bi_opf = op | do_sync;
 	if (test_bit(FailFast, &rdev->flags) &&
 	    test_bit(R10BIO_FailFast, &r10_bio->state))
-	        read_bio->bi_opf |= MD_FAILFAST;
+		read_bio->bi_opf |= MD_FAILFAST;
 	read_bio->bi_private = r10_bio;
 
 	if (mddev->gendisk)
-	        trace_block_bio_remap(read_bio, disk_devt(mddev->gendisk),
-	                              r10_bio->sector);
+		trace_block_bio_remap(read_bio, disk_devt(mddev->gendisk), r10_bio->sector);
 	submit_bio_noacct(read_bio);
 	return;
 }
@@ -4448,8 +4447,8 @@ static int raid10_check_reshape(struct mddev *mddev)
 		return -EINVAL;
 
 	if (mddev->array_sectors & geo.chunk_mask)
-			/* not factor of array size */
-			return -EINVAL;
+		/* not factor of array size */
+		return -EINVAL;
 
 	if (!enough(conf, -1))
 		return -EINVAL;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 73060e4124b4..1d5db89acb8d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4145,7 +4145,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 			sh = list_first_entry(&sh->batch_list,
 					      struct stripe_head, batch_list);
 			if (sh != head_sh)
-					goto unhash;
+				goto unhash;
 		}
 		sh = head_sh;
 
diff --git a/include/linux/raid/xor.h b/include/linux/raid/xor.h
index 1827a54790d7..231f467935a9 100644
--- a/include/linux/raid/xor.h
+++ b/include/linux/raid/xor.h
@@ -8,9 +8,9 @@ extern void xor_blocks(unsigned int count, unsigned int bytes,
 	void *dest, void **srcs);
 
 struct xor_block_template {
-        struct xor_block_template *next;
-        const char *name;
-        int speed;
+	struct xor_block_template *next;
+	const char *name;
+	int speed;
 	void (*do_2)(unsigned long, unsigned long *__restrict,
 		     const unsigned long *__restrict);
 	void (*do_3)(unsigned long, unsigned long *__restrict,
-- 
2.39.2

