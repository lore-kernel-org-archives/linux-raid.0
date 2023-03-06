Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 656BAC61DA4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjCFV3e (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjCFV3B (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAEC2E807
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VteZq37fhUy5+24F6OoVk0V2jlPvViM+dI94kv0BkY0=;
        b=L/lC6/uerVvNrtxMyJlg8OaoXAiuU1mLvqNG5bwnJVnlVEmgrVmi5BqaCDartNfQb1RRlG
        nNxC+q3SixATBFYiXtegv2s7yA6ch4j3Fm/YM7vfn4OmZpfu1A7KIGnkl65aaNbw95dTvO
        SzZn/dRyDP9rjPQZ6Vl8HBHBnmAirAk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-N4Vidc3iPnWlNe4DOuAuzg-1; Mon, 06 Mar 2023 16:28:08 -0500
X-MC-Unique: N4Vidc3iPnWlNe4DOuAuzg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C52463C1022E
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:07 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D28740C83B6;
        Mon,  6 Mar 2023 21:28:06 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 09/34] md: else should follow close curly brace [ERROR]
Date:   Mon,  6 Mar 2023 22:27:32 +0100
Message-Id: <79fbe388f2044498cc63bfdf3138318a6ceb5f5a.1678136717.git.heinzm@redhat.com>
In-Reply-To: <cover.1678136717.git.heinzm@redhat.com>
References: <cover.1678136717.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: heinzm <heinzm@redhat.com>
---
 drivers/md/md-cluster.c | 3 +--
 drivers/md/md.c         | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 9bcf816b80a1..760b3ba37854 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -548,8 +548,7 @@ static void process_remove_disk(struct mddev *mddev, struct cluster_msg *msg)
 		set_bit(ClusterRemove, &rdev->flags);
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		md_wakeup_thread(mddev->thread);
-	}
-	else
+	} else
 		pr_warn("%s: %d Could not find disk(%d) to REMOVE\n",
 			__func__, __LINE__, le32_to_cpu(msg->raid_slot));
 	rcu_read_unlock();
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9dc1df40c52d..ff4699babdd6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9694,8 +9694,7 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 					rdev2->bdev);
 				md_kick_rdev_from_array(rdev2);
 				continue;
-			}
-			else
+			} else
 				clear_bit(Candidate, &rdev2->flags);
 		}
 
-- 
2.39.2

