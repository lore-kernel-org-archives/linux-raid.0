Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3E6C28CFA
	for <linux-raid@archiver.kernel.org>; Wed,  3 Mar 2021 01:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEF5A64FA6
	for <linux-raid@archiver.kernel.org>; Wed,  3 Mar 2021 01:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237737AbhCCBMx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Mar 2021 20:12:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:44910 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1576188AbhCBEZ7 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 1 Mar 2021 23:25:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3F926ABF4;
        Tue,  2 Mar 2021 04:03:04 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-block@vger.kernel.org, axboe@kernel.dk,
        dan.j.williams@intel.com, vishal.l.verma@intel.com, neilb@suse.de
Cc:     antlists@youngman.org.uk, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org,
        Coly Li <colyli@suse.de>
Subject: [RFC PATCH v1 1/6] badblocks: add more helper structure and routines in badblocks.h
Date:   Tue,  2 Mar 2021 12:02:47 +0800
Message-Id: <20210302040252.103720-2-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210302040252.103720-1-colyli@suse.de>
References: <20210302040252.103720-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This patch adds the following helper structure and routines into
badblocks.h,
- struct bad_context
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
 
+struct bad_context {
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
2.26.2

