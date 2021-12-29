Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C84C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 29 Dec 2021 22:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbhL2WgN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Dec 2021 17:36:13 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:51456 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbhL2WgN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Dec 2021 17:36:13 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6BDEC1F37F;
        Wed, 29 Dec 2021 22:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1640817372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=nDAPWMEnuQXe9GldGZJPH8iD3QPwfp0TH1ywh8bgN+M=;
        b=RXSnTd3faGUuS7fQcV8wogoB7sa9WNmTJCXcf3f6O/6W3bfHN+WvDl5xYRzba5zc71UfjN
        hZj1BHsioPBTupTmN5KikR+c0APXaNKFbrJTlDHf0SItiv9hW0vjfRGZan0/bAJiOdRfZu
        pNIwAXn3f7BXjCIEsB+MnrIl4kggdz8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1640817372;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=nDAPWMEnuQXe9GldGZJPH8iD3QPwfp0TH1ywh8bgN+M=;
        b=dnxFBIDnfcxG74i8NFR2DTEkjC3Sj0k1K3xBR8GmfbN27va9G1F4V89w+5W7IgaaYILHJI
        1UkCslPjt6O5txAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 56E0A13C0F;
        Wed, 29 Dec 2021 22:36:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id usxKFNzizGH9XgAAMHmgww
        (envelope-from <dmueller@suse.de>); Wed, 29 Dec 2021 22:36:12 +0000
From:   =?UTF-8?q?Dirk=20M=C3=BCller?= <dmueller@suse.de>
To:     linux-raid@vger.kernel.org
Cc:     =?UTF-8?q?Dirk=20M=C3=BCller?= <dmueller@suse.de>
Subject: [PATCH] Use strict priority ranking for pq gen() benchmarking
Date:   Wed, 29 Dec 2021 23:36:00 +0100
Message-Id: <20211229223600.29346-1-dmueller@suse.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On x86_64, currently 3 variants of AVX512, 3 variants of AVX2
and 3 variants of SSE2 are benchmarked on initialization, taking
between 144-153 jiffies. Over a hardware pool of various generations
of intel cpus I could not find a single case where SSE2 won over
AVX2 or AVX512. There are cases where AVX2 wins over AVX512.

By giving AVXx variants higher priority over SSE, we can generally
skip 3 benchmarks which speeds this up by 33% - 50%, depending on
whether AVX512 is available.

Signed-off-by: Dirk Müller <dmueller@suse.de>
---
 include/linux/raid/pq.h | 2 +-
 lib/raid6/algos.c       | 2 +-
 lib/raid6/avx2.c        | 6 +++---
 lib/raid6/avx512.c      | 6 +++---
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 154e954b711d..d6e5a1feb947 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -81,7 +81,7 @@ struct raid6_calls {
 	void (*xor_syndrome)(int, int, int, size_t, void **);
 	int  (*valid)(void);	/* Returns 1 if this routine set is usable */
 	const char *name;	/* Name of this routine set */
-	int prefer;		/* Has special performance attribute */
+	int priority;		/* Relative priority ranking if non-zero */
 };
 
 /* Selected algorithm */
diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 889033b7fc0d..d1e8ff837a32 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -151,7 +151,7 @@ static inline const struct raid6_calls *raid6_choose_gen(
 	const struct raid6_calls *best;
 
 	for (bestgenperf = 0, best = NULL, algo = raid6_algos; *algo; algo++) {
-		if (!best || (*algo)->prefer >= best->prefer) {
+		if (!best || (*algo)->priority >= best->priority) {
 			if ((*algo)->valid && !(*algo)->valid())
 				continue;
 
diff --git a/lib/raid6/avx2.c b/lib/raid6/avx2.c
index f299476e1d76..31be496b8c81 100644
--- a/lib/raid6/avx2.c
+++ b/lib/raid6/avx2.c
@@ -132,7 +132,7 @@ const struct raid6_calls raid6_avx2x1 = {
 	raid6_avx21_xor_syndrome,
 	raid6_have_avx2,
 	"avx2x1",
-	1			/* Has cache hints */
+	.priority = 2
 };
 
 /*
@@ -262,7 +262,7 @@ const struct raid6_calls raid6_avx2x2 = {
 	raid6_avx22_xor_syndrome,
 	raid6_have_avx2,
 	"avx2x2",
-	1			/* Has cache hints */
+	.priority = 2
 };
 
 #ifdef CONFIG_X86_64
@@ -465,6 +465,6 @@ const struct raid6_calls raid6_avx2x4 = {
 	raid6_avx24_xor_syndrome,
 	raid6_have_avx2,
 	"avx2x4",
-	1			/* Has cache hints */
+	.priority = 2
 };
 #endif
diff --git a/lib/raid6/avx512.c b/lib/raid6/avx512.c
index bb684d144ee2..63ae197c3294 100644
--- a/lib/raid6/avx512.c
+++ b/lib/raid6/avx512.c
@@ -162,7 +162,7 @@ const struct raid6_calls raid6_avx512x1 = {
 	raid6_avx5121_xor_syndrome,
 	raid6_have_avx512,
 	"avx512x1",
-	1                       /* Has cache hints */
+	.priority = 2
 };
 
 /*
@@ -319,7 +319,7 @@ const struct raid6_calls raid6_avx512x2 = {
 	raid6_avx5122_xor_syndrome,
 	raid6_have_avx512,
 	"avx512x2",
-	1                       /* Has cache hints */
+	.priority = 2
 };
 
 #ifdef CONFIG_X86_64
@@ -557,7 +557,7 @@ const struct raid6_calls raid6_avx512x4 = {
 	raid6_avx5124_xor_syndrome,
 	raid6_have_avx512,
 	"avx512x4",
-	1                       /* Has cache hints */
+	.priority = 2
 };
 #endif
 
-- 
2.34.1

