Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9097C001E0
	for <linux-raid@archiver.kernel.org>; Mon, 24 Jul 2023 09:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbjGXJyP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Jul 2023 05:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbjGXJxR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Jul 2023 05:53:17 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10E61BCB
        for <linux-raid@vger.kernel.org>; Mon, 24 Jul 2023 02:49:17 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1bb85ed352bso2236075ad.0
        for <linux-raid@vger.kernel.org>; Mon, 24 Jul 2023 02:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690192122; x=1690796922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SZ4CyloeMnj8DJaX3jH++Kh0s8L9fcE8HheaL79+C9E=;
        b=J/Bt6a5BMqhvdU/1SLuQX4nGlsOFwUStDgY9eH2v8f3RVdFq/sd3J4KWhio/dC9+p1
         I7x8MAszW6LDKxiafO3ijuVZWlwLloveljXquKUGhfhkI+gBmVZ+aRdkRgZMuHOMA0H0
         yKIvOrvLzQBJ0AtrK9ni37EuWpbTH6Gi1xp5mvGIU09YEhbSx5XeAtmIIM3L0YDCA4IY
         cOQImgDx6CerfFdixsFA7q/WRBoRbwfsUuvzftsn9rBMTfKTu+7IX9QKeDCcJjiigyeD
         MRXtrE3UPxmcDS5U+FzEfuL+bhB6TGOFiKBVZLyyImDcoC0jgqbvAUMVzKpuo72Ccxdg
         yqhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690192122; x=1690796922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SZ4CyloeMnj8DJaX3jH++Kh0s8L9fcE8HheaL79+C9E=;
        b=GR2O6xVk/36D2YzFTFY2tg2BAVXG08xPxSXBqfwGGMaYr356kSagAcQVtwqMRto5QE
         EGMYBzjUIUTqatrOk72vk7eaByN7JQtvsOqEd+FY5b1qq+rf4By69u3U0Bw+mFBB1YAH
         LV03NworLcPipy2MlYHx40CSEJfut/b0liw1+9ssIAZ3+cMIyQiAjW1uHY/ozlRIwhvL
         r28vrfto76RYXMvOAlromITrGvS0ogRzYvwCaQbdZPtF6U92gSf/Lz0SDNlZJKolFkJj
         HOkedotpWE/AntNfgpOp9gZg89ewBFOp+8yhQgSkAzEGU6Y9gFAqnyEF/S37CxDU4J6T
         qbZg==
X-Gm-Message-State: ABy/qLbjnKWm3enr3Ju5/+gOiWnTWKuq3Jp5z2hWavA2oHpUmGxojw7Z
        m6Zhh5VssE+ce1DSLROC5Sd6Kw==
X-Google-Smtp-Source: APBJJlGdl4zR2tT8oeBRlnNa82kteJScCMEv7aXbUuimbAqUFJ617TPjzQL08XTMcGzg+wanNIE0AA==
X-Received: by 2002:a17:902:ecce:b0:1b8:b55d:4cff with SMTP id a14-20020a170902ecce00b001b8b55d4cffmr12423850plh.2.1690192122325;
        Mon, 24 Jul 2023 02:48:42 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001bb20380bf2sm8467233pld.13.2023.07.24.02.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 02:48:41 -0700 (PDT)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        muchun.song@linux.dev
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-erofs@lists.ozlabs.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-nfs@vger.kernel.org, linux-mtd@lists.infradead.org,
        rcu@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 18/47] rcu: dynamically allocate the rcu-kfree shrinker
Date:   Mon, 24 Jul 2023 17:43:25 +0800
Message-Id: <20230724094354.90817-19-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Use new APIs to dynamically allocate the rcu-kfree shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 kernel/rcu/tree.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 1449cb69a0e0..d068ce3567fc 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3445,12 +3445,7 @@ kfree_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 	return freed == 0 ? SHRINK_STOP : freed;
 }
 
-static struct shrinker kfree_rcu_shrinker = {
-	.count_objects = kfree_rcu_shrink_count,
-	.scan_objects = kfree_rcu_shrink_scan,
-	.batch = 0,
-	.seeks = DEFAULT_SEEKS,
-};
+static struct shrinker *kfree_rcu_shrinker;
 
 void __init kfree_rcu_scheduler_running(void)
 {
@@ -4958,8 +4953,18 @@ static void __init kfree_rcu_batch_init(void)
 		INIT_DELAYED_WORK(&krcp->page_cache_work, fill_page_cache_func);
 		krcp->initialized = true;
 	}
-	if (register_shrinker(&kfree_rcu_shrinker, "rcu-kfree"))
-		pr_err("Failed to register kfree_rcu() shrinker!\n");
+
+	kfree_rcu_shrinker = shrinker_alloc(0, "rcu-kfree");
+	if (!kfree_rcu_shrinker) {
+		pr_err("Failed to allocate kfree_rcu() shrinker!\n");
+		return;
+	}
+
+	kfree_rcu_shrinker->count_objects = kfree_rcu_shrink_count;
+	kfree_rcu_shrinker->scan_objects = kfree_rcu_shrink_scan;
+	kfree_rcu_shrinker->seeks = DEFAULT_SEEKS;
+
+	shrinker_register(kfree_rcu_shrinker);
 }
 
 void __init rcu_init(void)
-- 
2.30.2

