Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2111BC04FE0
	for <linux-raid@archiver.kernel.org>; Mon, 14 Aug 2023 08:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbjHNIwE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 04:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjHNIvb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 04:51:31 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4D791
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 01:51:31 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-687ca37628eso3950705b3a.1
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 01:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1692003090; x=1692607890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CWWBCzOt57+qvyHkw3KX99OkaI9d/CMtTn9A66pF5gI=;
        b=mejzojIkIqugIpRepLf04mfYDF9dICV+jihyazhmfuNWTFgqoBNxuTrdmMhIDGrwRb
         2WKpadrJQJ6ZW0z8GrlhlNHbQP5vhYpfqcUTfBMD4iwAUaNlSSTpQg4XCI6MV5IIDs8j
         HDpf2dg5fw8vHjkL1swaV6h6VpNJ9UKA3RkOyiJeLOXS+V3WWfAA3sYkWja4cftgFi58
         WX0Tj5BPkX3eKNpDCJBr+Cz0TLl7IXjOCt5JdR528qBwLllra+DMC0oq61N8pg5E3zg0
         2d04B5812Fn51nMku/euwQXDXilj+WsFPI45Pf2fWm6SPfLuCqTejE5LZoKuTjYaryqi
         ohyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692003090; x=1692607890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CWWBCzOt57+qvyHkw3KX99OkaI9d/CMtTn9A66pF5gI=;
        b=CoUzxRFo0ukTsP/vkwX5Zp75iWaemrj98Oxh0r+71o2jbLQxXEVEvgOsDS/Vg70C8P
         anY1/PyAjZ/yFJ6qjdHEgIvHwVW1Ac2Y8glHYk+1U8mQvht6Wi+FKGoEojNRQn2iD6CH
         dUYJBUyqifLjttnWP5K2PtVJq0Lxa6cYG7O8ofAzwqSpSl8BwE4UW6GvGddaBVbQxgBo
         b8XrO8R0YRXBcqAuOYfMMoZB7gKgooS9rvZwre0KhWp8AFsF68wWiqTFdQBAbiWfzYgj
         foJx/FLA90aRoBZwzOtUW067HR50Z1oE1NjUfgvh3pUzHMLZY1tBQbeuD1NIk7LUSpUY
         z8vA==
X-Gm-Message-State: AOJu0YzVasxJRrqIdhH2XBk3E5Ra6XyksTuk+0siO3m+QhfABL18BwZT
        yIqU0ZKVh+ZDu10+hSMG9C9Wag==
X-Google-Smtp-Source: AGHT+IH7woDi33QaVWN03ikKJs4yTs6CqRRl+gJUknPZ0PQEYbDodRnzDK9Yj9n6uUL3IsDWkLJbWA==
X-Received: by 2002:a05:6a20:938c:b0:13a:6bca:7a84 with SMTP id x12-20020a056a20938c00b0013a6bca7a84mr14198342pzh.44.1692003090509;
        Mon, 14 Aug 2023 01:51:30 -0700 (PDT)
Received: from nixos.tailf4e9e.ts.net ([47.75.78.161])
        by smtp.googlemail.com with ESMTPSA id fk1-20020a056a003a8100b006765cb3255asm7439668pfb.68.2023.08.14.01.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 01:51:30 -0700 (PDT)
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     song@kernel.org, djeffery@redhat.com, dan.j.williams@intel.com,
        neilb@suse.de, akpm@linux-foundation.org, neilb@suse.com
Cc:     linux-raid@vger.kernel.org, Xueshi Hu <xueshi.hu@smartx.com>
Subject: [PATCH v5 2/3] md/raid1: free the r1bio firstly before waiting for blocked rdev
Date:   Mon, 14 Aug 2023 16:51:07 +0800
Message-Id: <20230814085108.991040-3-xueshi.hu@smartx.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230814085108.991040-1-xueshi.hu@smartx.com>
References: <20230814085108.991040-1-xueshi.hu@smartx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Raid1 reshape will change mempool and r1conf::raid_disks which are 
necessary when freeing r1bio. allow_barrier() make an concurrent 
raid1_reshape() possible. So, free the in-flight r1bio firstly before
waiting blocked rdev. 

Fixes: 6bfe0b499082 ("md: support blocking writes to an array on device failure")
Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
---
 drivers/md/raid1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index dbbee0c14a5b..5f17f30a00a9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1374,6 +1374,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		return;
 	}
 
+ retry_write:
 	r1_bio = alloc_r1bio(mddev, bio);
 	r1_bio->sectors = max_write_sectors;
 
@@ -1389,7 +1390,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	 */
 
 	disks = conf->raid_disks * 2;
- retry_write:
 	blocked_rdev = NULL;
 	rcu_read_lock();
 	max_sectors = r1_bio->sectors;
@@ -1469,7 +1469,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		for (j = 0; j < i; j++)
 			if (r1_bio->bios[j])
 				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
-		r1_bio->state = 0;
+		free_r1bio(r1_bio);
 		allow_barrier(conf, bio->bi_iter.bi_sector);
 
 		if (bio->bi_opf & REQ_NOWAIT) {
-- 
2.40.1

