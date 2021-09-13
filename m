Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0194C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 13 Sep 2021 16:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB65E60E76
	for <linux-raid@archiver.kernel.org>; Mon, 13 Sep 2021 16:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238043AbhIMQcg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Sep 2021 12:32:36 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:45238 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238062AbhIMQc1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Sep 2021 12:32:27 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4A20F2202D;
        Mon, 13 Sep 2021 16:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631550670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=btMMBaQlFYuha2pg2ZY1EYYQxLXvNESPTyPbWA1UwiA=;
        b=gU2oRbiqcjE3oM6mHr/WL7oWa4baxVDsx4EYbHIsB/+oeZ0YHVRUAOtA2br5zpnX9T0C1u
        y66L9wMOnpzdEAYOwjVsymA6lJyLkLBEzVWkVXr5nc+z1C32xlHxLfW84C/laGMiuCyNJe
        GQiGTzQJWftdoous/eNmZcjTBWSqGvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631550670;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=btMMBaQlFYuha2pg2ZY1EYYQxLXvNESPTyPbWA1UwiA=;
        b=pop2Uq8INMuXTn1ZXANHg44szTrJmeLBj633AHPcI1I2zwEp+cUdzgoJDYYDXC8TDoqIKQ
        ve3CK6G0oazCHwCQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 24700A3BA4;
        Mon, 13 Sep 2021 16:31:03 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, nvdimm@lists.linux.dev
Cc:     antlists@youngman.org.uk, Coly Li <colyli@suse.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>,
        Vishal L Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 5/6] badblocks: improve badblocks_check() for multiple ranges handling
Date:   Tue, 14 Sep 2021 00:30:14 +0800
Message-Id: <20210913163016.10088-6-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913163016.10088-1-colyli@suse.de>
References: <20210913163016.10088-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This patch rewrites badblocks_check() with similar coding style as
_badblocks_set() and _badblocks_clear(). The only difference is bad
blocks checking may handle multiple ranges in bad tables now.

If a checking range covers multiple bad blocks range in bad block table,
like the following condition (C is the checking range, E1, E2, E3 are
three bad block ranges in bad block table),
  +------------------------------------+
  |                C                   |
  +------------------------------------+
    +----+      +----+      +----+
    | E1 |      | E2 |      | E3 |
    +----+      +----+      +----+
The improved badblocks_check() algorithm will divid checking range C
into multiple parts, and handle them in 7 runs of a while-loop,
  +--+ +----+ +----+ +----+ +----+ +----+ +----+
  |C1| | C2 | | C3 | | C4 | | C5 | | C6 | | C7 |
  +--+ +----+ +----+ +----+ +----+ +----+ +----+
       +----+        +----+        +----+
       | E1 |        | E2 |        | E3 |
       +----+        +----+        +----+
And the start LBA and length of range E1 will be set as first_bad and
bad_sectors for the caller.

The return value rule is consistent for multiple ranges. For example if
there are following bad block ranges in bad block table,
   Index No.     Start        Len         Ack
       0          400          20          1
       1          500          50          1
       2          650          20          0
the return value, first_bad, bad_sectors by calling badblocks_set() with
different checking range can be the following values,
    Checking Start, Len     Return Value   first_bad    bad_sectors
               100, 100          0           N/A           N/A
               100, 310          1           400           10
               100, 440          1           400           10
               100, 540          1           400           10
               100, 600         -1           400           10
               100, 800         -1           400           10

In order to make code review easier, this patch names the improved bad
block range checking routine as _badblocks_check() and does not change
existing badblock_check() code yet. Later patch will delete old code of
badblocks_check() and make it as a wrapper to call _badblocks_check().
Then the new added code won't mess up with the old deleted code, it will
be more clear and easier for code review.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: NeilBrown <neilb@suse.de>
Cc: Vishal L Verma <vishal.l.verma@intel.com>
---
 block/badblocks.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/block/badblocks.c b/block/badblocks.c
index b8d466e835da..93d29276ffc2 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -1257,6 +1257,105 @@ static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 	return rv;
 }
 
+/* Do the exact work to check bad blocks range from the bad block table */
+static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
+			    sector_t *first_bad, int *bad_sectors)
+{
+	u64 *p;
+	struct badblocks_context bad;
+	int prev = -1, hint = -1, set = 0;
+	int unacked_badblocks, acked_badblocks;
+	int len, rv;
+	unsigned int seq;
+
+	WARN_ON(bb->shift < 0 || sectors == 0);
+
+	if (bb->shift > 0) {
+		sector_t target;
+
+		/* round the start down, and the end up */
+		target = s + sectors;
+		rounddown(s, bb->shift);
+		roundup(target, bb->shift);
+		sectors = target - s;
+	}
+
+retry:
+	seq = read_seqbegin(&bb->lock);
+
+	bad.orig_start = s;
+	bad.orig_len = sectors;
+	p = bb->page;
+	unacked_badblocks = 0;
+	acked_badblocks = 0;
+
+re_check:
+	bad.start = s;
+	bad.len = sectors;
+
+	if (badblocks_empty(bb)) {
+		len = sectors;
+		goto update_sectors;
+	}
+
+	prev = prev_badblocks(bb, &bad, hint);
+
+	/* start after all badblocks */
+	if ((prev + 1) >= bb->count && !overlap_front(bb, prev, &bad)) {
+		len = sectors;
+		goto update_sectors;
+	}
+
+	if (overlap_front(bb, prev, &bad)) {
+		if (BB_ACK(p[prev]))
+			acked_badblocks++;
+		else
+			unacked_badblocks++;
+
+		if (BB_END(p[prev]) >= (s + sectors))
+			len = sectors;
+		else
+			len = BB_END(p[prev]) - s;
+
+		if (set == 0) {
+			*first_bad = BB_OFFSET(p[prev]);
+			*bad_sectors = BB_LEN(p[prev]);
+			set = 1;
+		}
+		goto update_sectors;
+	}
+
+	/* Not front overlap, but behind overlap */
+	if ((prev + 1) < bb->count && overlap_behind(bb, &bad, prev + 1)) {
+		len = BB_OFFSET(p[prev + 1]) - bad.start;
+		hint = prev + 1;
+		goto update_sectors;
+	}
+
+	/* not cover any badblocks range in the table */
+	len = sectors;
+
+update_sectors:
+	s += len;
+	sectors -= len;
+
+	if (sectors > 0)
+		goto re_check;
+
+	WARN_ON(sectors < 0);
+
+	if (unacked_badblocks > 0)
+		rv = -1;
+	else if (acked_badblocks > 0)
+		rv = 1;
+	else
+		rv = 0;
+
+	if (read_seqretry(&bb->lock, seq))
+		goto retry;
+
+	return rv;
+}
 
 /**
  * badblocks_check() - check a given range for bad sectors
-- 
2.31.1

