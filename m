Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C19C001E0
	for <linux-raid@archiver.kernel.org>; Mon, 24 Jul 2023 10:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjGXKQW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Jul 2023 06:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbjGXKQF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Jul 2023 06:16:05 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D86CE5C
        for <linux-raid@vger.kernel.org>; Mon, 24 Jul 2023 03:07:57 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 3f1490d57ef6-d0602c6cd05so218899276.0
        for <linux-raid@vger.kernel.org>; Mon, 24 Jul 2023 03:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690193276; x=1690798076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oVZBD26n61nILm1319d0FZlD/fP50Fwp7YtrZB2yUEw=;
        b=J0a15k71gFIS+cZ5I0I1DW5FDMv+knbulPcaZsSWjAYWfsvWQWQJSjiebuAC8tO1CC
         FLbitJKAliofhtZkRIv2/bNMORY7J8IfoTHEes2dq7jBJFUi+4xYJvxx9zV5IXNsW3+i
         UNtCIaUiLPLZ9fLVmmFDriYJ1qsjpLW8sKbnlbxCFHYX3qnFye6DqfYykkFbpNpAIFOt
         xoFo1z43wlLwrcD8hORIMElWR7TzeqDuokpojq7iTFvq1TKFijBycY5FoeXrCVVr9nhI
         78Nf2DpwewsoIHO4l+EekkZiHI6Oxy4m5VtSaKyb7d6xXYzxuJl7RediVqlFYlP8/OFb
         40Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690193276; x=1690798076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oVZBD26n61nILm1319d0FZlD/fP50Fwp7YtrZB2yUEw=;
        b=RbwX8MQBW2Nv+q96cEFQO0N8vxUvEfdFnXuYrkqcFOglpIIgZltfEhmNB2Da9XUxbF
         jmnJaVUCjH8B8263CW4jih2GcHW0GekQ3c1yDeA2P3S6alU/XISVv3douB+6HPjUCOdH
         nxjXn9jktM5iF3MRvgisohWowpLnTyCgPOyX2RgIgZUrnfUB3sqkFCGHltQbE4SJwTJf
         +f8kc6tx7P+IPeDZyLjlMscaksGPyUxk2cpKzzlGCtge4Z0XAhk1tTwALVqHIufOYtPn
         oTAZAK/bsH1lxWXHiPtrLpruNyJN01ANjxsy+tF44PVIvsZyaXxa5HNYoDc7gytu1QPS
         GIgw==
X-Gm-Message-State: ABy/qLYbuhaDiT8AysoHn8N2ll4ZuiSdprgMsvhQVtajSqbi3MHg/0Wi
        7LlSbNecGo77jz8pBkCD3jBWSplJzimKR/Yq3vU=
X-Google-Smtp-Source: APBJJlFQ+sAFI6LIZ7PgU9puTnlNzbjLYXvmJ0kfMmGkS9XBnuUvcLZ7El1l1GYgUvVEvdh+XgkfrQ==
X-Received: by 2002:a17:902:e74d:b0:1bb:ac37:384b with SMTP id p13-20020a170902e74d00b001bbac37384bmr1242952plf.6.1690192266338;
        Mon, 24 Jul 2023 02:51:06 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001bb20380bf2sm8467233pld.13.2023.07.24.02.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 02:51:06 -0700 (PDT)
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
Subject: [PATCH v2 30/47] virtio_balloon: dynamically allocate the virtio-balloon shrinker
Date:   Mon, 24 Jul 2023 17:43:37 +0800
Message-Id: <20230724094354.90817-31-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

In preparation for implementing lockless slab shrink, use new APIs to
dynamically allocate the virtio-balloon shrinker, so that it can be freed
asynchronously using kfree_rcu(). Then it doesn't need to wait for RCU
read-side critical section when releasing the struct virtio_balloon.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 drivers/virtio/virtio_balloon.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 5b15936a5214..d773860c3b18 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -111,7 +111,7 @@ struct virtio_balloon {
 	struct virtio_balloon_stat stats[VIRTIO_BALLOON_S_NR];
 
 	/* Shrinker to return free pages - VIRTIO_BALLOON_F_FREE_PAGE_HINT */
-	struct shrinker shrinker;
+	struct shrinker *shrinker;
 
 	/* OOM notifier to deflate on OOM - VIRTIO_BALLOON_F_DEFLATE_ON_OOM */
 	struct notifier_block oom_nb;
@@ -816,8 +816,7 @@ static unsigned long shrink_free_pages(struct virtio_balloon *vb,
 static unsigned long virtio_balloon_shrinker_scan(struct shrinker *shrinker,
 						  struct shrink_control *sc)
 {
-	struct virtio_balloon *vb = container_of(shrinker,
-					struct virtio_balloon, shrinker);
+	struct virtio_balloon *vb = shrinker->private_data;
 
 	return shrink_free_pages(vb, sc->nr_to_scan);
 }
@@ -825,8 +824,7 @@ static unsigned long virtio_balloon_shrinker_scan(struct shrinker *shrinker,
 static unsigned long virtio_balloon_shrinker_count(struct shrinker *shrinker,
 						   struct shrink_control *sc)
 {
-	struct virtio_balloon *vb = container_of(shrinker,
-					struct virtio_balloon, shrinker);
+	struct virtio_balloon *vb = shrinker->private_data;
 
 	return vb->num_free_page_blocks * VIRTIO_BALLOON_HINT_BLOCK_PAGES;
 }
@@ -847,16 +845,23 @@ static int virtio_balloon_oom_notify(struct notifier_block *nb,
 
 static void virtio_balloon_unregister_shrinker(struct virtio_balloon *vb)
 {
-	unregister_shrinker(&vb->shrinker);
+	shrinker_unregister(vb->shrinker);
 }
 
 static int virtio_balloon_register_shrinker(struct virtio_balloon *vb)
 {
-	vb->shrinker.scan_objects = virtio_balloon_shrinker_scan;
-	vb->shrinker.count_objects = virtio_balloon_shrinker_count;
-	vb->shrinker.seeks = DEFAULT_SEEKS;
+	vb->shrinker = shrinker_alloc(0, "virtio-balloon");
+	if (!vb->shrinker)
+		return -ENOMEM;
 
-	return register_shrinker(&vb->shrinker, "virtio-balloon");
+	vb->shrinker->scan_objects = virtio_balloon_shrinker_scan;
+	vb->shrinker->count_objects = virtio_balloon_shrinker_count;
+	vb->shrinker->seeks = DEFAULT_SEEKS;
+	vb->shrinker->private_data = vb;
+
+	shrinker_register(vb->shrinker);
+
+	return 0;
 }
 
 static int virtballoon_probe(struct virtio_device *vdev)
-- 
2.30.2

