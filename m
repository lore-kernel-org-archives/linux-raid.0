Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C47C433FE
	for <linux-raid@archiver.kernel.org>; Wed,  5 Jan 2022 16:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiAEQjH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 5 Jan 2022 11:39:07 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:57870 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiAEQjG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 5 Jan 2022 11:39:06 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 33F74210ED;
        Wed,  5 Jan 2022 16:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1641400745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KEPShoM6SmcTZiekj7AQ9ndqIL0GXTb/ovKeKaOLqHI=;
        b=xegVAMAktNepTkDU8iEQyG7/3bdCyGtTLhF/ttjRLo9uG50C5EVK5MuvdQk/trQpDF9MfI
        tL06W/9p4WX7qfKw+e+hOSY+kARXXyMQaEtHqfns94FiKzDxsJs3t6Qo8kIy/nIPn4kMbM
        EEktoGlEP538NZBDH8TuC4r1v3q+RU0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1641400745;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KEPShoM6SmcTZiekj7AQ9ndqIL0GXTb/ovKeKaOLqHI=;
        b=2I8lFCJW95UU6l/YW0mitkCCMOJz/qxbupPOOtxFLEPiSEncFSbWU9Y22gqlNUTc41KYHQ
        cfHB+iVhjeNL1rBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1B9AE13EE9;
        Wed,  5 Jan 2022 16:39:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gCbgBanJ1WGOEAAAMHmgww
        (envelope-from <dmueller@suse.de>); Wed, 05 Jan 2022 16:39:05 +0000
From:   =?UTF-8?q?Dirk=20M=C3=BCller?= <dmueller@suse.de>
To:     linux-raid@vger.kernel.org
Cc:     =?UTF-8?q?Dirk=20M=C3=BCller?= <dmueller@suse.de>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH v2 2/2] lib/raid6: Use strict priority ranking for pq gen() benchmarking
Date:   Wed,  5 Jan 2022 17:38:47 +0100
Message-Id: <20220105163847.18592-2-dmueller@suse.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220105163847.18592-1-dmueller@suse.de>
References: <20220105163847.18592-1-dmueller@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On x86_64, currently 3 variants of AVX512, 3 variants of AVX2
and 3 variants of SSE2 are benchmarked on initialization, taking
between 144-153 jiffies. Testing across a hardware pool of
various generations of intel cpus I could not find a single
case where SSE2 won over AVX2 or AVX512. There are cases where
AVX2 wins over AVX512 however.

Change "prefer" into an integer priority field (similar to
how recov selection works) to have more than one ranking level
available, which is backwards compatible with existing behavior.

Give AVX2/512 variants higher priority over SSE2 in order to skip
SSE testing when AVX is available. in a AVX2/x86_64/HZ=250 case this
saves in the order of 200ms of initialization time.

Signed-off-by: Dirk Müller <dmueller@suse.de>
Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 include/linux/raid/pq.h | 2 +-
 lib/raid6/algos.c       | 2 +-
 lib/raid6/avx2.c        | 8 ++++----
 lib/raid6/avx512.c      | 6 +++---
 4 files changed, 9 insertions(+), 9 deletions(-)

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
index 9b7e8a837b27..39b74221f4a7 100644
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
index f299476e1d76..059024234dce 100644
--- a/lib/raid6/avx2.c
+++ b/lib/raid6/avx2.c
@@ -132,7 +132,7 @@ const struct raid6_calls raid6_avx2x1 = {
 	raid6_avx21_xor_syndrome,
 	raid6_have_avx2,
 	"avx2x1",
-	1			/* Has cache hints */
+	.priority = 2		/* Prefer AVX2 over priority 1 (SSE2 and others) */
 };
 
 /*
@@ -262,7 +262,7 @@ const struct raid6_calls raid6_avx2x2 = {
 	raid6_avx22_xor_syndrome,
 	raid6_have_avx2,
 	"avx2x2",
-	1			/* Has cache hints */
+	.priority = 2		/* Prefer AVX2 over priority 1 (SSE2 and others) */
 };
 
 #ifdef CONFIG_X86_64
@@ -465,6 +465,6 @@ const struct raid6_calls raid6_avx2x4 = {
 	raid6_avx24_xor_syndrome,
 	raid6_have_avx2,
 	"avx2x4",
-	1			/* Has cache hints */
+	.priority = 2		/* Prefer AVX2 over priority 1 (SSE2 and others) */
 };
-#endif
+#endif /* CONFIG_X86_64 */
diff --git a/lib/raid6/avx512.c b/lib/raid6/avx512.c
index bb684d144ee2..9c3e822e1adf 100644
--- a/lib/raid6/avx512.c
+++ b/lib/raid6/avx512.c
@@ -162,7 +162,7 @@ const struct raid6_calls raid6_avx512x1 = {
 	raid6_avx5121_xor_syndrome,
 	raid6_have_avx512,
 	"avx512x1",
-	1                       /* Has cache hints */
+	.priority = 2		/* Prefer AVX512 over priority 1 (SSE2 and others) */
 };
 
 /*
@@ -319,7 +319,7 @@ const struct raid6_calls raid6_avx512x2 = {
 	raid6_avx5122_xor_syndrome,
 	raid6_have_avx512,
 	"avx512x2",
-	1                       /* Has cache hints */
+	.priority = 2		/* Prefer AVX512 over priority 1 (SSE2 and others) */
 };
 
 #ifdef CONFIG_X86_64
@@ -557,7 +557,7 @@ const struct raid6_calls raid6_avx512x4 = {
 	raid6_avx5124_xor_syndrome,
 	raid6_have_avx512,
 	"avx512x4",
-	1                       /* Has cache hints */
+	.priority = 2		/* Prefer AVX512 over priority 1 (SSE2 and others) */
 };
 #endif
 
-- 
2.34.1

