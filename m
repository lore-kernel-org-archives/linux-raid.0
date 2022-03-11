Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 204CFC43219
	for <linux-raid@archiver.kernel.org>; Fri, 11 Mar 2022 17:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350770AbiCKRbw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Mar 2022 12:31:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350780AbiCKRbv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 11 Mar 2022 12:31:51 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7388C2E61
        for <linux-raid@vger.kernel.org>; Fri, 11 Mar 2022 09:30:47 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id b14so6452448ilf.6
        for <linux-raid@vger.kernel.org>; Fri, 11 Mar 2022 09:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0+lGCgm8YQ8+dIdxKhhw6hUQk2kg7X0gjyYtTJsiPzs=;
        b=WkmrzHbGXHHAq8OAz/zvD00E4LdgaBvLE/LBw9eaPu2DvRDn4HZwuJPJDicFmBhsMF
         nWgV5Aq0YVYYkyTg3mPgFHMoGTLEd/hs7EculEkmDwBDlmTNUwtxX0+jDXxrfAF/eNS9
         yVQvL6zSjSgx4m6x6K58tMyHVnDvqlOMfu60zW+T/O1x2+GoriYFWHagHVBhY5JtXmIN
         d6BzUozyUQ+aDJ0nBqkWIro7L5UaNsmjgLiAFPqtTQLMKd/ofQjKT1TD5h3Th4m8RDpU
         foGMt2U+gpe7eh95a9biqjho+qW7MVJZZQYvE4Y0Y2fSXiOvZ1+ePr4B9ZAsoTBf0GhH
         ZLng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0+lGCgm8YQ8+dIdxKhhw6hUQk2kg7X0gjyYtTJsiPzs=;
        b=WM6X7aW8YKuMl0stmfKOMjMrsCYp1vRUfKVltNMeXJhm2skJp77RQh7RhqXHVPLfBs
         MJtXs/1rIe2+CmrT22TmVO/+kn6SJcNkCV0bhdQeYkG1BdHpUm6oWzyyGBhqxJBGPZTG
         PJhwWFBdjLRO43Qni3kImdR24hmDY9wUYV/qCr7mCeb94Mo2W6uaFFHXB36aHUMF0xiL
         oUUc4xyKQcSbELWyn3vU4jZu/JPYRUdyXhXokn07I8pAZTBvk494fe/ofKKAsO2IpbE0
         NiK61+uRLbfBcgzn7ovUdIntvzKhpL1UP1jHBelxDAGvXYUAvSkIJIt/9kXmJ7gxFUMe
         IshQ==
X-Gm-Message-State: AOAM530mbvo/s8N5Ub8s/2z0f1j7bVvUP518KXtPlXmk/tmhIRu1IiRR
        clwHQ/WyqGQB+yPg3zYQ6iynTA==
X-Google-Smtp-Source: ABdhPJyld0EEoUxIZrrQF7gWk82Y/3EcT3Gc0bV4qtL4FPNOvVEkL+69QnJeMAuCNdIXyis79aWs8g==
X-Received: by 2002:a92:cdae:0:b0:2c2:c05d:ac36 with SMTP id g14-20020a92cdae000000b002c2c05dac36mr8474918ild.196.1647019846739;
        Fri, 11 Mar 2022 09:30:46 -0800 (PST)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r2-20020a92d442000000b002c62b540c85sm4622356ilm.5.2022.03.11.09.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 09:30:46 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        llowrey@nuclearwinter.com, i400sjon@gmail.com,
        rogerheflin@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] block: ensure plug merging checks the correct queue at least once
Date:   Fri, 11 Mar 2022 10:30:40 -0700
Message-Id: <20220311173041.165948-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220311173041.165948-1-axboe@kernel.dk>
References: <20220311173041.165948-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Song reports that a RAID rebuild workload runs much slower recently,
and it is seeing a lot less merging than it did previously. The reason
is that a previous commit reduced the amount of work we do for plug
merging. RAID rebuild interleaves requests between disks, so a last-entry
check in plug merging always misses a merge opportunity since we always
find a different disk than what we are looking for.

Modify the logic such that it's still a one-hit cache, but ensure that
we check enough to find the right target before giving up.

Fixes: d38a9c04c0d5 ("block: only check previous entry for plug merge attempt")
Reported-by: Song Liu <song@kernel.org>
Tested-by: Song Liu <song@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-merge.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index f5255991b773..8d8177f71ebd 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -1087,12 +1087,20 @@ bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
 	if (!plug || rq_list_empty(plug->mq_list))
 		return false;
 
-	/* check the previously added entry for a quick merge attempt */
-	rq = rq_list_peek(&plug->mq_list);
-	if (rq->q == q) {
-		if (blk_attempt_bio_merge(q, rq, bio, nr_segs, false) ==
-				BIO_MERGE_OK)
-			return true;
+	rq_list_for_each(&plug->mq_list, rq) {
+		if (rq->q == q) {
+			if (blk_attempt_bio_merge(q, rq, bio, nr_segs, false) ==
+			    BIO_MERGE_OK)
+				return true;
+			break;
+		}
+
+		/*
+		 * Only keep iterating plug list for merges if we have multiple
+		 * queues
+		 */
+		if (!plug->multiple_queues)
+			break;
 	}
 	return false;
 }
-- 
2.35.1

