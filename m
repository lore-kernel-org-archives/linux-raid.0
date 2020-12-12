Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252CCC433FE
	for <linux-raid@archiver.kernel.org>; Sat, 12 Dec 2020 16:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDD02229C4
	for <linux-raid@archiver.kernel.org>; Sat, 12 Dec 2020 16:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436597AbgLLQ4c (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 12 Dec 2020 11:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395531AbgLLQ4V (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 12 Dec 2020 11:56:21 -0500
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ED7C0613CF
        for <linux-raid@vger.kernel.org>; Sat, 12 Dec 2020 08:55:41 -0800 (PST)
Received: by mail-qv1-xf44.google.com with SMTP id bd6so5777632qvb.9
        for <linux-raid@vger.kernel.org>; Sat, 12 Dec 2020 08:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=C9dAR8KUaTQSVqBHY7IZtL3YZt1kyupy3xu4GVLhIsQ=;
        b=vVcuG1rawuwE/Lrh7iVCZs1buv4+Svfj/zpMcXOk8CyVlB6b5Y5u6/Jvv4Bt8CT/UH
         nLpygWyoA/k/xN8NklM6BqIfc1k8bm2sBrAngil19pfgvpT37TKHZHvsQo12x9KDDtW9
         I3XLUUa2uQTN24+/dvrs6yedJr9D8BkoUCsf3PpXEuwwcmB8RdX112naHP39pq7I4pbw
         IMl5YV4F4o6EeYROJkwNc5D+s4K8WzbhhFhaoy7mSCG4QbfB2A3kD9vevu8UTqtUTRfB
         Xoyfgm77/vpIssCFHtJhlQOad1cttcxHLij8O5f/bV4k3wgVfPwIy4E+J54ysQkQiHrl
         RF5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=C9dAR8KUaTQSVqBHY7IZtL3YZt1kyupy3xu4GVLhIsQ=;
        b=cSYuZcTG3R9YKrEDvBNH3ULMOXfoCe3jH5i3MrxhgOIRN2eNLpCnF/MxXSJcKxgg4b
         Pd4CVCfxrBbgsd9hk+TpUall/42kFeCHIqaysJAw2zF455Wve4RDcjYOYhrGfuwFQiPG
         aI+qHl9OfuiaOvEHhIfQha4ov7f33z56d5mRcTEldKgkUkUzPGafTtL1K6eA3CE0yqDb
         RlOmfh4TeEm29jQxOTdYkcSA7oYJ46SErAldyTHFku3Ri8M4VAuZEGCGcms0oUI9/4dU
         Trlrhr+HI0mhP5teSkdbrCqSC2vHxD0m/D3dsVXeU6IorU8UVAHckcitFCJhU8Mz6CkL
         s64w==
X-Gm-Message-State: AOAM532CRZYyrJ2+KGICr+TFIepISo0uwsXJRQ7VdKFTW8O5obgElrDz
        tg11uXpSkRMnMISeYxVWlO8=
X-Google-Smtp-Source: ABdhPJy5Tf31U0TmRDuFcmrY39Oaz9HNM6YTb8IpRm2RT7xOo5eHY/xIxf/1qp79bXmj79ssJ/gdXA==
X-Received: by 2002:ad4:580f:: with SMTP id dd15mr19779126qvb.40.1607792140121;
        Sat, 12 Dec 2020 08:55:40 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id u5sm10599317qka.106.2020.12.12.08.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Dec 2020 08:55:38 -0800 (PST)
Sender: Mike Snitzer <snitzer@gmail.com>
Date:   Sat, 12 Dec 2020 11:55:37 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Matthew Ruffell <matthew.ruffell@canonical.com>,
        Xiao Ni <xni@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
Subject: [PATCH] md: change mddev 'chunk_sectors' from int to unsigned
Message-ID: <20201212165537.GA53870@lobo>
References: <D6749568-4ED2-49A7-B0D3-F0969B934BF6@fb.com>
 <20201212144229.GB21863@redhat.com>
 <2799b859-c451-c3f6-7753-fe08e35f4a7c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2799b859-c451-c3f6-7753-fe08e35f4a7c@kernel.dk>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Commit e2782f560c29 ("Revert "dm raid: remove unnecessary discard
limits for raid10"") exposed compiler warnings introduced by commit
e0910c8e4f87 ("dm raid: fix discard limits for raid1 and raid10"):

In file included from ./include/linux/kernel.h:14,
                 from ./include/asm-generic/bug.h:20,
                 from ./arch/x86/include/asm/bug.h:93,
                 from ./include/linux/bug.h:5,
                 from ./include/linux/mmdebug.h:5,
                 from ./include/linux/gfp.h:5,
                 from ./include/linux/slab.h:15,
                 from drivers/md/dm-raid.c:8:
drivers/md/dm-raid.c: In function ‘raid_io_hints’:
./include/linux/minmax.h:18:28: warning: comparison of distinct pointer types lacks a cast
  (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
                            ^~
./include/linux/minmax.h:32:4: note: in expansion of macro ‘__typecheck’
   (__typecheck(x, y) && __no_side_effects(x, y))
    ^~~~~~~~~~~
./include/linux/minmax.h:42:24: note: in expansion of macro ‘__safe_cmp’
  __builtin_choose_expr(__safe_cmp(x, y), \
                        ^~~~~~~~~~
./include/linux/minmax.h:51:19: note: in expansion of macro ‘__careful_cmp’
 #define min(x, y) __careful_cmp(x, y, <)
                   ^~~~~~~~~~~~~
./include/linux/minmax.h:84:39: note: in expansion of macro ‘min’
  __x == 0 ? __y : ((__y == 0) ? __x : min(__x, __y)); })
                                       ^~~
drivers/md/dm-raid.c:3739:33: note: in expansion of macro ‘min_not_zero’
   limits->max_discard_sectors = min_not_zero(rs->md.chunk_sectors,
                                 ^~~~~~~~~~~~

Fix this by changing the chunk_sectors member of 'struct mddev' from
int to 'unsigned int' to match the type used for the 'chunk_sectors'
member of 'struct queue_limits'.  Various MD code still uses 'int' but
none of it appears to ever make use of signed int; and storing
positive signed int in unsigned is perfectly safe.

Reported-by: Song Liu <songliubraving@fb.com>
Fixes: e2782f560c29 ("Revert "dm raid: remove unnecessary discard limits for raid10"")
Fixes: e0910c8e4f87 ("dm raid: fix discard limits for raid1 and raid10")
Cc: stable@vger,kernel.org # e0910c8e4f87 was marked for stable@
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/md.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 2175a5ac4f7c..bb645bc3ba6d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -311,7 +311,7 @@ struct mddev {
 	int				external;	/* metadata is
 							 * managed externally */
 	char				metadata_type[17]; /* externally set*/
-	int				chunk_sectors;
+	unsigned int			chunk_sectors;
 	time64_t			ctime, utime;
 	int				level, layout;
 	char				clevel[16];
@@ -339,7 +339,7 @@ struct mddev {
 	 */
 	sector_t			reshape_position;
 	int				delta_disks, new_level, new_layout;
-	int				new_chunk_sectors;
+	unsigned int			new_chunk_sectors;
 	int				reshape_backwards;
 
 	struct md_thread		*thread;	/* management thread */
-- 
2.15.0

