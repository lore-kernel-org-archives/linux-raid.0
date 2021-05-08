Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B64DBC433B4
	for <linux-raid@archiver.kernel.org>; Sat,  8 May 2021 03:49:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96E2B61107
	for <linux-raid@archiver.kernel.org>; Sat,  8 May 2021 03:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhEHDt7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 7 May 2021 23:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbhEHDt7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 7 May 2021 23:49:59 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B51C061574;
        Fri,  7 May 2021 20:48:57 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id i5so4025463pgm.0;
        Fri, 07 May 2021 20:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B0X3rqhyNmx29/hjgf+W3ZlULuWwHF4lzKtT+tay8j4=;
        b=kFKMhmsJhDoh4jy6jC7BpLKa/2syJLB78tKxVCH+Sm5txEG9obtTBL77t4pgwk4bSb
         M7w8QusAOxtFcV34+kVNpS7+1GGHNdWxU3W8ZLPpBWjQG/moDw6eL/w5jwXqvMJxgWLd
         5iVzL1ZVPxjH4s+aTU2NN04VxiucNHZhYKQvZOzozHT9HwJlqt3pzv+H3/sqSlm0teWr
         HVH7LOsAHxiSZV33ScyA2VZSkfvDdaSh3I6qDitnAjiyV8Pg/kNoluScOyol7qbZDjtZ
         9P3fgwdjqs0fMhWYQlmbU0SMlXzwLkVRuRUVhvpgqhwh00+K3cUpt22CamyjYe+8bjPX
         PmPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B0X3rqhyNmx29/hjgf+W3ZlULuWwHF4lzKtT+tay8j4=;
        b=Kcm/qIYU/GaGcfMw6WcCCyR0iKSBhO/FcJ7LFUMGooTp3k1QVW/6hxmsQQjnZrG1Ny
         nV5ymbYtdGuTHpsjDcGr3l2wvdKPs1wr+I9oqz0OpwFOU47IdObfgYURSS7bBUI6UzE2
         9mkcJTd3FE0R5m8wwTqT4lADUIFwGqFAJuXWeT7CPpaapU1/+m1R42tvCQnoPnQZxpkE
         tjssVVCgaG5MZm25XrJp0CxPNKaOqFN1lHaEtnmG8pLv3QwoHpgae4VqACyXyb/jlNyn
         x26OZcjsxjbMsXpY4jphDWywUpRmhxvJWvujJ/HzDrKRy8TZjo7TLrK1xNrbH2lFrAm/
         dE5Q==
X-Gm-Message-State: AOAM531O9835yawAMfE8fiKFGpgYJ1UplKYtsgGcNAVcbTtd6XsHV2iZ
        b/NAxLJq8PvLYEoKobMS4ng=
X-Google-Smtp-Source: ABdhPJwV6b0nBVwp80hV8nH/UWz/D7qZnmczbCxuyilqkhFvTaY6nYKKm9wcOU6ju06L3F3UKMhD3A==
X-Received: by 2002:a63:4a4b:: with SMTP id j11mr13244596pgl.451.1620445737373;
        Fri, 07 May 2021 20:48:57 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id w1sm6201943pgh.26.2021.05.07.20.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 20:48:56 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        pawel.wiejacha@rtbhouse.com,
        Guoqing Jiang <jiangguoqing@kylinos.cn>
Subject: [PATCH] md: don't account io stat for split bio
Date:   Sat,  8 May 2021 11:48:15 +0800
Message-Id: <20210508034815.123565-1-jgq516@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Guoqing Jiang <jiangguoqing@kylinos.cn>

We have used generic io accounting functions to manage md io stats,
then for split bio, md also change it's bi_private and bi_end_io,
which could trigger double fault problem.

1146  <0>[33685.629591] traps: PANIC: double fault, error_code: 0x0
1147  <4>[33685.629593] double fault: 0000 [#1] SMP NOPTI
1148  <4>[33685.629594] CPU: 10 PID: 2118287 Comm: kworker/10:0
Tainted: P           OE     5.11.8-051108-generic #202103200636
1149  <4>[33685.629595] Hardware name: ASUSTeK COMPUTER INC. KRPG-U8
Series/KRPG-U8 Series, BIOS 4201 09/25/2020
1150  <4>[33685.629595] Workqueue: xfs-conv/md12 xfs_end_io [xfs]
1151  <4>[33685.629596] RIP: 0010:__slab_free+0x23/0x340
1152  <4>[33685.629597] Code: 4c fe ff ff 0f 1f 00 0f 1f 44 00 00 55
48 89 e5 41 57 49 89 cf 41 56 49 89 fe 41 55 41 54 49 89 f4 53 48 83
e4 f0 48 83 ec 70 <48> 89 54 24 28 0f 1f 44 00 00 41 8b 46 28 4d 8b 6c
24 20 49 8b 5c
1153  <4>[33685.629598] RSP: 0018:ffffa9bc00848fa0 EFLAGS: 00010086
1154  <4>[33685.629599] RAX: ffff94c04d8b10a0 RBX: ffff94437a34a880
RCX: ffff94437a34a880
1155  <4>[33685.629599] RDX: ffff94437a34a880 RSI: ffffcec745e8d280
RDI: ffff944300043b00
1156  <4>[33685.629599] RBP: ffffa9bc00849040 R08: 0000000000000001
R09: ffffffff82a5d6de
1157  <4>[33685.629600] R10: 0000000000000001 R11: 000000009c109000
R12: ffffcec745e8d280
1158  <4>[33685.629600] R13: ffff944300043b00 R14: ffff944300043b00
R15: ffff94437a34a880
1159  <4>[33685.629601] FS:  0000000000000000(0000)
GS:ffff94c04d880000(0000) knlGS:0000000000000000
1160  <4>[33685.629601] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1161  <4>[33685.629602] CR2: ffffa9bc00848f98 CR3: 000000014d04e000
CR4: 0000000000350ee0
1162  <4>[33685.629602] Call Trace:
1163  <4>[33685.629603]  <IRQ>
1164  <4>[33685.629603]  ? kfree+0x3bc/0x3e0
1165  <4>[33685.629603]  ? mempool_kfree+0xe/0x10
1166  <4>[33685.629603]  ? mempool_kfree+0xe/0x10
1167  <4>[33685.629604]  ? mempool_free+0x2f/0x80
1168  <4>[33685.629604]  ? md_end_io+0x4a/0x70
1169  <4>[33685.629604]  ? bio_endio+0xdc/0x130
1170  <4>[33685.629605]  ? bio_chain_endio+0x2d/0x40
1171  <4>[33685.629605]  ? md_end_io+0x5c/0x70
1172  <4>[33685.629605]  ? bio_endio+0xdc/0x130
1173  <4>[33685.629605]  ? bio_chain_endio+0x2d/0x40
1174  <4>[33685.629606]  ? md_end_io+0x5c/0x70
1175  <4>[33685.629606]  ? bio_endio+0xdc/0x130
1176  <4>[33685.629606]  ? bio_chain_endio+0x2d/0x40
1177  <4>[33685.629607]  ? md_end_io+0x5c/0x70
... repeated ...
1436  <4>[33685.629677]  ? bio_endio+0xdc/0x130
1437  <4>[33685.629677]  ? bio_chain_endio+0x2d/0x40
1438  <4>[33685.629677]  ? md_end_io+0x5c/0x70
1439  <4>[33685.629677]  ? bio_endio+0xdc/0x130
1440  <4>[33685.629678]  ? bio_chain_endio+0x2d/0x40
1441  <4>[33685.629678]  ? md_
1442  <4>[33685.629679] Lost 357 message(s)!

It looks like stack overflow happened for split bio, to fix this,
let's keep split bio untouched in md_submit_bio.

As a side effect, we need to export bio_chain_endio.

[1]. https://lore.kernel.org/linux-raid/3bf04253-3fad-434a-63a7-20214e38cf26@gmail.com/T/#t

Reported-by: Paweł Wiejacha <pawel.wiejacha@rtbhouse.com>
Tested-by: Paweł Wiejacha <pawel.wiejacha@rtbhouse.com>
Fixes: 41d2d848e5c0 ("md: improve io stats accounting")
Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
---
 block/bio.c         | 3 ++-
 drivers/md/md.c     | 2 +-
 include/linux/bio.h | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 44205dfb6b60..759da1f6ab61 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -283,10 +283,11 @@ static struct bio *__bio_chain_endio(struct bio *bio)
 	return parent;
 }
 
-static void bio_chain_endio(struct bio *bio)
+void bio_chain_endio(struct bio *bio)
 {
 	bio_endio(__bio_chain_endio(bio));
 }
+EXPORT_SYMBOL(bio_chain_endio);
 
 /**
  * bio_chain - chain bio completions
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 49f897fbb89b..02fd272ff6f7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -489,7 +489,7 @@ static blk_qc_t md_submit_bio(struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
-	if (bio->bi_end_io != md_end_io) {
+	if (bio->bi_end_io != md_end_io && bio->bi_end_io != bio_chain_endio) {
 		struct md_io *md_io;
 
 		md_io = mempool_alloc(&mddev->md_io_pool, GFP_NOIO);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index a0b4cfdf62a4..6ea48fa1ad64 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -465,6 +465,7 @@ extern void bio_init(struct bio *bio, struct bio_vec *table,
 extern void bio_uninit(struct bio *);
 extern void bio_reset(struct bio *);
 void bio_chain(struct bio *, struct bio *);
+extern void bio_chain_endio(struct bio *bio);
 
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
-- 
2.25.1

