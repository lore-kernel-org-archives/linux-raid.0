Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E31B4C433FE
	for <linux-raid@archiver.kernel.org>; Mon, 13 Sep 2021 16:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8C82604E9
	for <linux-raid@archiver.kernel.org>; Mon, 13 Sep 2021 16:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237987AbhIMQcK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Sep 2021 12:32:10 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:55508 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237878AbhIMQcF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Sep 2021 12:32:05 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id DF22A1FD9B;
        Mon, 13 Sep 2021 16:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631550647; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1cLnNgahnRqZc9jVnTIqodTE0s49FfRLlP6thBPVEdE=;
        b=G4B0dKcceWAc3dPBA9v/gt34/Gyd09ih7imvIkZc6JUfO4WkjMAYL3V0yukTYjsfdOaS1f
        l0JJMfWTM4PknivRzLiSZPAd/pzromG8sG/RmXHsy0mHAgPe1mfLEDd8XwvZ6c0/UG5ZLp
        JEHFuuryx0xrDTHIqWFLyTq6GO6atOA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631550647;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1cLnNgahnRqZc9jVnTIqodTE0s49FfRLlP6thBPVEdE=;
        b=i46mclSR4SG/t74dq02Fjnwcq2Z/bP7MzTKIp9C1ZOgDzRiz2UK2usQSGwywbygQWpPuOw
        sQU+3oQ+Rr/4kfDQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 20EBAA3B92;
        Mon, 13 Sep 2021 16:30:42 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, nvdimm@lists.linux.dev
Cc:     antlists@youngman.org.uk, Coly Li <colyli@suse.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>,
        Vishal L Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 1/6] badblocks: add more helper structure and routines in badblocks.h
Date:   Tue, 14 Sep 2021 00:30:10 +0800
Message-Id: <20210913163016.10088-2-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913163016.10088-1-colyli@suse.de>
References: <20210913163016.10088-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This patch adds the following helper structure and routines into
badblocks.h,
- struct badblocks_context
  This structure is used in improved badblocks code for bad table
  iteration.
- BB_END()
  The macro to culculate end LBA of a bad range record from bad
  table.
- badblocks_full() and badblocks_empty()
  The inline routines to check whether bad table is full or empty.
- set_changed() and clear_changed()
  The inline routines to set and clear 'changed' tag from struct
  badblocks.

These new helper structure and routines can help to make the code more
clear, they will be used in the improved badblocks code in following
patches.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: NeilBrown <neilb@suse.de>
Cc: Vishal L Verma <vishal.l.verma@intel.com>
---
 include/linux/badblocks.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/include/linux/badblocks.h b/include/linux/badblocks.h
index 2426276b9bd3..166161842d1f 100644
--- a/include/linux/badblocks.h
+++ b/include/linux/badblocks.h
@@ -15,6 +15,7 @@
 #define BB_OFFSET(x)	(((x) & BB_OFFSET_MASK) >> 9)
 #define BB_LEN(x)	(((x) & BB_LEN_MASK) + 1)
 #define BB_ACK(x)	(!!((x) & BB_ACK_MASK))
+#define BB_END(x)	(BB_OFFSET(x) + BB_LEN(x))
 #define BB_MAKE(a, l, ack) (((a)<<9) | ((l)-1) | ((u64)(!!(ack)) << 63))
 
 /* Bad block numbers are stored sorted in a single page.
@@ -41,6 +42,14 @@ struct badblocks {
 	sector_t size;		/* in sectors */
 };
 
+struct badblocks_context {
+	sector_t	start;
+	sector_t	len;
+	int		ack;
+	sector_t	orig_start;
+	sector_t	orig_len;
+};
+
 int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
 		   sector_t *first_bad, int *bad_sectors);
 int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
@@ -63,4 +72,27 @@ static inline void devm_exit_badblocks(struct device *dev, struct badblocks *bb)
 	}
 	badblocks_exit(bb);
 }
+
+static inline int badblocks_full(struct badblocks *bb)
+{
+	return (bb->count >= MAX_BADBLOCKS);
+}
+
+static inline int badblocks_empty(struct badblocks *bb)
+{
+	return (bb->count == 0);
+}
+
+static inline void set_changed(struct badblocks *bb)
+{
+	if (bb->changed != 1)
+		bb->changed = 1;
+}
+
+static inline void clear_changed(struct badblocks *bb)
+{
+	if (bb->changed != 0)
+		bb->changed = 0;
+}
+
 #endif
-- 
2.31.1

