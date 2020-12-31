Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F6A4C433E0
	for <linux-raid@archiver.kernel.org>; Thu, 31 Dec 2020 17:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEAFE2158C
	for <linux-raid@archiver.kernel.org>; Thu, 31 Dec 2020 17:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgLaRb4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 31 Dec 2020 12:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbgLaRbz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 31 Dec 2020 12:31:55 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EE3C061573
        for <linux-raid@vger.kernel.org>; Thu, 31 Dec 2020 09:31:15 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id h186so11529380pfe.0
        for <linux-raid@vger.kernel.org>; Thu, 31 Dec 2020 09:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e5dHpdyY7vw+Yzy7cLuMeXm3Y8xuQIIoE2ioisVtyqg=;
        b=H4OUEaLzlKolB7hVtv+4vM8434SiX/tSzhqcrRyt3IgJiY0y69sxX2xfcRbP4EJBr/
         j84S7ySxwf/1Hz0jxroHlPVC8J5vtA6rcd4+RfJeE1HNw5SUlK7r0BIJ+QUgFMdHu9NW
         tje4Ac2+0ME5XSVQ32pOIx4lt86eZPW1df7PoSB8TiDjiA58O/UlgJtQ/SgwQ62qH81F
         Qzj1MdjH0jd322n7JYwgYYiL401oXCVvZfOP2v5YC0kSR0e4WoPvzpq8NKwMQruTk7hr
         qVbhr/KOIAfc175JvyXNbOZIxnA6Gx+Yf/AFTog4CQ47IboTt1Hm26+Bn3jaFZN3nxEU
         b1CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e5dHpdyY7vw+Yzy7cLuMeXm3Y8xuQIIoE2ioisVtyqg=;
        b=O8xeDhFeALmDLq9GGo47e3GZ5EUO8aCwEj+wxL0gCmYw0IxrHotEUMKbZ3IuAuKzqK
         M03H85miAzW1W4EA9OsWVO0WGL94JrcjIAJmpNPULj/N87o+K6GhYxk0bevg+5hVYAIN
         zvH9S868JEqbO0UMfj+p4jryFDCFQ53hcMg81NgLsEgOxhJu3UiVGHuRuPCQ9rv1CLlF
         /DQatnZJ29LcyPm/HJezSKcO3PLoVqVgjpHg+LV3zvXI24JqEcNHATpWZr0bf5i87CaA
         MATMdyqTsIXRSdL1UmmLJyPTirPsXnqZDIgJUOtD9muhog8lnTRh6ykWGO2So/BLv+5Y
         nboQ==
X-Gm-Message-State: AOAM533KTeZU8wXwE5oE0bAl7ndkA/a1Cc4idgG53kDa7sWa61/Cpycb
        CN6pkLFO2mi/Qejl+fnApVa2oEJec3qUXw==
X-Google-Smtp-Source: ABdhPJxwSaKY/Rzq9mglPo7syqIv41U8RoSV0i0vOqiJU1s+IVZRgEs2TKg+0CMNXX/trCMpHGi5hQ==
X-Received: by 2002:a63:101e:: with SMTP id f30mr58532002pgl.95.1609435875069;
        Thu, 31 Dec 2020 09:31:15 -0800 (PST)
Received: from kvigor-fedora-R90RRLH2.thefacebook.com ([2620:10d:c090:400::5:7c6c])
        by smtp.gmail.com with ESMTPSA id v6sm47105163pfi.31.2020.12.31.09.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Dec 2020 09:31:14 -0800 (PST)
From:   Kevin Vigor <kvigor@gmail.com>
To:     linux-raid@vger.kernel.org
Cc:     Kevin Vigor <kvigor@gmail.com>
Subject: [PATCH 1/2] md/raid10: wake pending freeze in raid10d()
Date:   Thu, 31 Dec 2020 09:30:00 -0800
Message-Id: <20201231173000.3596606-1-kvigor@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The freeze_array() function waits for changes to nr_queued,
but the raid10d() function alters it without sending a wake.

This can lead to freeze_array() never being woken.

Signed-off-by: Kevin Vigor <kvigor@gmail.com>
---
 drivers/md/raid10.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c5d88ef6a45c..f98df9f084c2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2698,6 +2698,7 @@ static void raid10d(struct md_thread *thread)
 	struct r10conf *conf = mddev->private;
 	struct list_head *head = &conf->retry_list;
 	struct blk_plug plug;
+	int dequeued = 0;
 
 	md_check_recovery(mddev);
 
@@ -2709,6 +2710,7 @@ static void raid10d(struct md_thread *thread)
 			while (!list_empty(&conf->bio_end_io_list)) {
 				list_move(conf->bio_end_io_list.prev, &tmp);
 				conf->nr_queued--;
+				dequeued++;
 			}
 		}
 		spin_unlock_irqrestore(&conf->device_lock, flags);
@@ -2739,6 +2741,7 @@ static void raid10d(struct md_thread *thread)
 		r10_bio = list_entry(head->prev, struct r10bio, retry_list);
 		list_del(head->prev);
 		conf->nr_queued--;
+		dequeued++;
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 
 		mddev = r10_bio->mddev;
@@ -2762,6 +2765,10 @@ static void raid10d(struct md_thread *thread)
 			md_check_recovery(mddev);
 	}
 	blk_finish_plug(&plug);
+
+	/* in case freeze_array is waiting for changes to nr_queued. */
+	if (conf->array_freeze_pending && dequeued)
+		wake_up(&conf->wait_barrier);
 }
 
 static int init_resync(struct r10conf *conf)
-- 
2.26.2

