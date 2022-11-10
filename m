Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD27C4332F
	for <linux-raid@archiver.kernel.org>; Thu, 10 Nov 2022 20:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiKJUpk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 10 Nov 2022 15:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiKJUpj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 10 Nov 2022 15:45:39 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0567E5F90
        for <linux-raid@vger.kernel.org>; Thu, 10 Nov 2022 12:45:38 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id z26so3098312pff.1
        for <linux-raid@vger.kernel.org>; Thu, 10 Nov 2022 12:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C3Q4FPfzmf/PRMx1x7722X0eZlOy1vQtrC/wcD0Jqsc=;
        b=Pcl8XSNKZErORcyS7BodkT7xXZtgDkPxHdSyfyE+5sMvqJu+mddFCqNH9OAWwhabu5
         dd72v5jVJ+leo4Aeg6qX4w1rZCHdvmsf4D6H8ZpuulWgcjGe8FZquQOd4DTtcQiaK+zL
         a9bro2I6bJpVBExW9tcoRWnSI8Vf0nd/BPRY1Rza0rG2AF/fE0dJxiVdyxsQj1J4xPKm
         d6oKDAZXlykhYLRxrHuu+ON1oooy2IgSaH4WZZU83l6hoEFSXSt0NUskBwRUnxiWGlWZ
         mqbjLlooounlJm5hTBrZUwsSTNl9kTKmPOOi9zLtW3eUBqqAAriwQNhwrXOMyucl3/2O
         s1LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C3Q4FPfzmf/PRMx1x7722X0eZlOy1vQtrC/wcD0Jqsc=;
        b=DQSElGsXhY3wPYL/GXqInb3D3nw0JBdGHOnfubDEuZiUke33ZTgiXdxMugMUe16fPS
         2pggaoFOxVY9A+fVNw5YThxkMXo+L/k51/VGBLwOfExBDxBrL6ahGfK9vFV4XjJndV5r
         rA1t85fOPeAdgDgzgwXj+M548FDl2vUF1Lo2cNz7wlMNeYNrvIUtcHP1MqbNDYq0TG16
         B2GxwZxB5CxCvcU55e0AefKzdlfHrYqaINbx1pYieEgImkDKC4wJQQtHnD6m6j0ynvqZ
         LwdjgrRI9PArdtUceaLUhnTe9HFIAtYVkhnWahQKc55y4tprfoJPHMJezqbte3LOfHSc
         o/XA==
X-Gm-Message-State: ACrzQf1QRTTQF5VO5cjUJ4sYXjdRlmWTwK3zu0TjxLgMNdiqeArG9jWz
        N0qZLnCLg3vZ+3K2RTgoBeB2nfdLrVY=
X-Google-Smtp-Source: AMsMyM6OmeKx654TM7f+NTRG7dydVN6aCuNgaXQm4VBfY4G8dBHE5Ie44aqkCAMJkwt/mGCraIpdVw==
X-Received: by 2002:a65:5206:0:b0:462:644c:87ff with SMTP id o6-20020a655206000000b00462644c87ffmr3268903pgp.552.1668113137161;
        Thu, 10 Nov 2022 12:45:37 -0800 (PST)
Received: from apollo.hsd1.ca.comcast.net ([2601:646:9181:1cf0::b779])
        by smtp.gmail.com with ESMTPSA id x3-20020aa78f03000000b0056c3a0dc65fsm83666pfr.71.2022.11.10.12.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 12:45:36 -0800 (PST)
From:   Khem Raj <raj.khem@gmail.com>
To:     linux-raid@vger.kernel.org
Cc:     Khem Raj <raj.khem@gmail.com>
Subject: [PATCH] restripe.c: Use _FILE_OFFSET_BITS to enable largefile support
Date:   Thu, 10 Nov 2022 12:45:33 -0800
Message-Id: <20221110204533.3834872-1-raj.khem@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Instead of using the lseek64 and friends, its better to enable it via
the feature macro _FILE_OFFSET_BITS = 64 and let the C library deal with
the width of types

Upstream-Status: Pending

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 restripe.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/restripe.c b/restripe.c
index a7a7229..1c03577 100644
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
 
@@ -581,7 +584,7 @@ int save_stripes(int *source, unsigned long long *offsets,
 				       raid_disks, level, layout);
 			if (dnum < 0) abort();
 			if (source[dnum] < 0 ||
-			    lseek64(source[dnum],
+			    lseek(source[dnum],
 				    offsets[dnum] + offset, 0) < 0 ||
 			    read(source[dnum], buf+disk * chunk_size,
 				 chunk_size) != chunk_size) {
@@ -754,8 +757,8 @@ int restore_stripes(int *dest, unsigned long long *offsets,
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
@@ -816,7 +819,7 @@ int restore_stripes(int *dest, unsigned long long *offsets,
 		}
 		for (i=0; i < raid_disks ; i++)
 			if (dest[i] >= 0) {
-				if (lseek64(dest[i],
+				if (lseek(dest[i],
 					 offsets[i]+offset, 0) < 0) {
 					rv = -1;
 					goto abort;
@@ -866,7 +869,7 @@ int test_stripes(int *source, unsigned long long *offsets,
 		int disk;
 
 		for (i = 0 ; i < raid_disks ; i++) {
-			if ((lseek64(source[i], offsets[i]+start, 0) < 0) ||
+			if ((lseek(source[i], offsets[i]+start, 0) < 0) ||
 			    (read(source[i], stripes[i], chunk_size) !=
 			     chunk_size)) {
 				free(q);
-- 
2.38.1

