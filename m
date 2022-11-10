Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C097C4332F
	for <linux-raid@archiver.kernel.org>; Thu, 10 Nov 2022 22:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiKJWzw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 10 Nov 2022 17:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiKJWzv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 10 Nov 2022 17:55:51 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F04C51C3F
        for <linux-raid@vger.kernel.org>; Thu, 10 Nov 2022 14:55:50 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id i3so3328969pfc.11
        for <linux-raid@vger.kernel.org>; Thu, 10 Nov 2022 14:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bxwRAQ6H5qag2XAXmi8U7PmzsBqq1xYv2z1Fhs1fx48=;
        b=I2X0wl6IDJWyw63qbCi6Wu3N5KD4Mml8QqYH57svcNByjBN6Ujgor3Ehl99CfuUXj9
         uaS3ZPz7LXgySWaEtuif8pFUNMuZuX+NMvKHiSzXvhrW1eBVSj4HV1L+fq6kriENLCkC
         0126M6OiELHHJaJgtkGILiLi1HqdEF3kdbmTCWEO3qF+ZLlupeQdr7QHaSDB2PEh3u6p
         TUuSrbDtE9c9qKMiguoXdBKxMXmGxnOssn0ucZIvkpcUksLEw8BibYlblyjkyAaTVb6D
         XG/9BAa03GWXonRQZlsujlciE9JjSKG9FvJfGgeBGCY8Y6I4pjlN9UAqdq5qiW/Zj/Fu
         rCjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bxwRAQ6H5qag2XAXmi8U7PmzsBqq1xYv2z1Fhs1fx48=;
        b=xVzv/n+E+qRU0nLKLPyy2hiljJGGe6aQuFczV0AI6iu++eecu0BOVVRLX+WV4v67TI
         Kb318xRO/h12Iu5hatlIvQWPici5sZD1M6tSy12Nzhf0ak0BNJAgOASj+4dgDOh282vY
         sQAmw9z0DtVUFHpVW6v9UR+KknrFFr4Rp6y8u1Ek/rY5HwCqf04MCMF6Ve3549CiPBFv
         UN+XFwX+9AHlQheji4g/J6AaKm89yqgMNOZRAER7DNjnsNCx0CyEHBI4WVfxKqkX2+9f
         7AfNUF4pOLp/PmpRGE8ZSi+E+2fNQZA7AyMX7m+6ioISu8IXaBjqmxhrsZeOuTXB4x4W
         klhg==
X-Gm-Message-State: ACrzQf0ME3CA9moUTdvhwCdNJ+iRpupZc6Lf51RWHsXl4QueRksWHSD2
        GdbT6a47c1MoswxcanvB/G7kAxQ4rRQ=
X-Google-Smtp-Source: AMsMyM7GGAZ34hCMaUPEyLsxDEi3mbXpEWC1dxBX/a2uVeJGc9fPQM46QUx+z85B3Sdbw5bwhM+Lwg==
X-Received: by 2002:a63:5513:0:b0:46f:b44b:3522 with SMTP id j19-20020a635513000000b0046fb44b3522mr3589954pgb.288.1668120949389;
        Thu, 10 Nov 2022 14:55:49 -0800 (PST)
Received: from apollo.hsd1.ca.comcast.net ([2601:646:9181:1cf0::b779])
        by smtp.gmail.com with ESMTPSA id q18-20020a17090311d200b00176b84eb29asm175208plh.301.2022.11.10.14.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 14:55:49 -0800 (PST)
From:   Khem Raj <raj.khem@gmail.com>
To:     linux-raid@vger.kernel.org
Cc:     Khem Raj <raj.khem@gmail.com>
Subject: [PATCH] restripe.c: Use _FILE_OFFSET_BITS to enable largefile support
Date:   Thu, 10 Nov 2022 14:55:46 -0800
Message-Id: <20221110225546.337164-1-raj.khem@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Instead of using the lseek64 and friends, its better to enable it via
the feature macro _FILE_OFFSET_BITS = 64 and let the C library deal with
the width of types

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 restripe.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/restripe.c
+++ b/restripe.c
@@ -22,6 +22,9 @@
  *    Email: <neilb@suse.de>
  */
 
+/* Enable largefile support */
+#define _FILE_OFFSET_BITS 64
+
 #include "mdadm.h"
 #include <stdint.h>
 
@@ -581,7 +584,7 @@ int save_stripes(int *source, unsigned l
 				       raid_disks, level, layout);
 			if (dnum < 0) abort();
 			if (source[dnum] < 0 ||
-			    lseek64(source[dnum],
+			    lseek(source[dnum],
 				    offsets[dnum] + offset, 0) < 0 ||
 			    read(source[dnum], buf+disk * chunk_size,
 				 chunk_size) != chunk_size) {
@@ -754,8 +757,8 @@ int restore_stripes(int *dest, unsigned
 					   raid_disks, level, layout);
 			if (src_buf == NULL) {
 				/* read from file */
-				if (lseek64(source, read_offset, 0) !=
-					 (off64_t)read_offset) {
+				if (lseek(source, read_offset, 0) !=
+					 (off_t)read_offset) {
 					rv = -1;
 					goto abort;
 				}
@@ -816,7 +819,7 @@ int restore_stripes(int *dest, unsigned
 		}
 		for (i=0; i < raid_disks ; i++)
 			if (dest[i] >= 0) {
-				if (lseek64(dest[i],
+				if (lseek(dest[i],
 					 offsets[i]+offset, 0) < 0) {
 					rv = -1;
 					goto abort;
@@ -866,7 +869,7 @@ int test_stripes(int *source, unsigned l
 		int disk;
 
 		for (i = 0 ; i < raid_disks ; i++) {
-			if ((lseek64(source[i], offsets[i]+start, 0) < 0) ||
+			if ((lseek(source[i], offsets[i]+start, 0) < 0) ||
 			    (read(source[i], stripes[i], chunk_size) !=
 			     chunk_size)) {
 				free(q);
--- a/raid6check.c
+++ b/raid6check.c
@@ -22,6 +22,9 @@
  *    Based on "restripe.c" from "mdadm" codebase
  */
 
+/* Enable largefile support */
+#define _FILE_OFFSET_BITS 64
+
 #include "mdadm.h"
 #include <stdint.h>
 #include <signal.h>
@@ -279,9 +282,9 @@ int manual_repair(int chunk_size, int sy
 	}
 
 	int write_res1, write_res2;
-	off64_t seek_res;
+	off_t seek_res;
 
-	seek_res = lseek64(source[fd1],
+	seek_res = lseek(source[fd1],
 			   offsets[fd1] + start * chunk_size, SEEK_SET);
 	if (seek_res < 0) {
 		fprintf(stderr, "lseek failed for failed_disk1\n");
@@ -289,7 +292,7 @@ int manual_repair(int chunk_size, int sy
 	}
 	write_res1 = write(source[fd1], blocks[failed_slot1], chunk_size);
 
-	seek_res = lseek64(source[fd2],
+	seek_res = lseek(source[fd2],
 			   offsets[fd2] + start * chunk_size, SEEK_SET);
 	if (seek_res < 0) {
 		fprintf(stderr, "lseek failed for failed_disk2\n");
@@ -374,7 +377,7 @@ int check_stripes(struct mdinfo *info, i
 			goto exitCheck;
 		}
 		for (i = 0 ; i < raid_disks ; i++) {
-			off64_t seek_res = lseek64(source[i], offsets[i] + start * chunk_size,
+			off_t seek_res = lseek(source[i], offsets[i] + start * chunk_size,
 						   SEEK_SET);
 			if (seek_res < 0) {
 				fprintf(stderr, "lseek to source %d failed\n", i);
--- a/swap_super.c
+++ b/swap_super.c
@@ -1,3 +1,6 @@
+/* Enable largefile support */
+#define _FILE_OFFSET_BITS 64
+
 #include <unistd.h>
 #include <stdlib.h>
 #include <fcntl.h>
@@ -16,8 +19,6 @@
 
 #define MD_NEW_SIZE_SECTORS(x)		((x & ~(MD_RESERVED_SECTORS - 1)) - MD_RESERVED_SECTORS)
 
-extern long long lseek64(int, long long, int);
-
 int main(int argc, char *argv[])
 {
 	int fd, i;
@@ -38,8 +39,8 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 	offset = MD_NEW_SIZE_SECTORS(size) * 512LL;
-	if (lseek64(fd, offset, 0) < 0LL) {
-		perror("lseek64");
+	if (lseek(fd, offset, 0) < 0LL) {
+		perror("lseek");
 		exit(1);
 	}
 	if (read(fd, super, 4096) != 4096) {
@@ -68,8 +69,8 @@ int main(int argc, char *argv[])
 		super[32*4+10*4 +i] = t;
 	}
 
-	if (lseek64(fd, offset, 0) < 0LL) {
-		perror("lseek64");
+	if (lseek(fd, offset, 0) < 0LL) {
+		perror("lseek");
 		exit(1);
 	}
 	if (write(fd, super, 4096) != 4096) {
