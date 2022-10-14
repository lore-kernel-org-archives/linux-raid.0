Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 493BFC433FE
	for <linux-raid@archiver.kernel.org>; Fri, 14 Oct 2022 12:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiJNMWP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 14 Oct 2022 08:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiJNMWO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 14 Oct 2022 08:22:14 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA93E1CBA95
        for <linux-raid@vger.kernel.org>; Fri, 14 Oct 2022 05:22:12 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id 13so10126422ejn.3
        for <linux-raid@vger.kernel.org>; Fri, 14 Oct 2022 05:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tnx6lmDua4XmNHVqO+CrqdndoN24OK03vbRBCYwLNvo=;
        b=Ytuu/zCk0YAGBdRKNzpm65r3DuyIA3exTTtAl+L7WbQlmiyqXVMCJ/Nq3gUB0qt/PR
         grXQgfSumfKG7mqp6lB0Wt1lCsloxolFJ3A9/GpScc9A5q9v9PKUYYlykQMsCdMUTTef
         1lHRv7hewAuhS5KNxQITyelLu3yNJQO2fpp4ojldGORYhAjTQ/5No7eKZGI261aWValj
         K2uu7ePBRzhYBG1eTdFsf6DxMj0y4H8VYcEiGkFOzWkwI+dpHeKwSih48b1jHpZN6sVi
         K5xqnq5AM0y6+lTXEFng/3UHPPo5hVgCJCmylJh3/qJ/EoDp/fILFFXSFTxt0Gj/1tkB
         jE2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tnx6lmDua4XmNHVqO+CrqdndoN24OK03vbRBCYwLNvo=;
        b=zx/T9AY0CIVtYSgrRwLbSK1HF4aF8W5s4WqKSUemj0VX/nUSmO7bLJHA4v63XXXAx5
         hxuCWEu1YkWiT6E3xsZpdHf21l8hYvfVKdXJYZRDxnEp+KUXhY/mPwEyFJe7CHsz4rGf
         kACRsH5zddKg0qwhxvwDo9fHK2bKE9nWRGAgQCjPehDExDyzQsnEkdz6Ld2YoFnQ6YlB
         n/27b9ktkVlw2NMMPgsPps/bUo2N79NzuRPQebQzrjHMrRn6qrJCMKwCQpPJN2WrM8mf
         DjncXLyMf7m1h6BQ+E4Hwsjq7ALx4p8bJ0NTBX++ygBFIaiV3hS+U6S9wQOSNCiqFwru
         vzgg==
X-Gm-Message-State: ACrzQf3WSIy6GhhqAYa8r9CODg8hojz/kBsUVjFJl+ypd4AkEslwiNl4
        S21PiwI1cxlMLxwJk9LYv/qlK7Z0ySn/7Q==
X-Google-Smtp-Source: AMsMyM4k7ZY6uEFtiPhEdH4F/SS2iKWovgh3hDKZhu1B8MOBylvOgto+xt3Yrbvbgux2LPKoHwvQhg==
X-Received: by 2002:a17:906:8a55:b0:78d:b6db:a2d4 with SMTP id gx21-20020a1709068a5500b0078db6dba2d4mr3391903ejc.82.1665750131101;
        Fri, 14 Oct 2022 05:22:11 -0700 (PDT)
Received: from lb02065.fritz.box ([2001:9e8:141a:3e00:b256:9dae:b5ab:8180])
        by smtp.gmail.com with ESMTPSA id p22-20020a056402045600b0044e01e2533asm1741132edw.43.2022.10.14.05.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 05:22:10 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     linux-raid@vger.kernel.org
Cc:     song@kernel.org,
        Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
Subject: [RFC PATCH] md-bitmap: reuse former bitmap chunk size on resizing.
Date:   Fri, 14 Oct 2022 14:22:10 +0200
Message-Id: <20221014122210.47888-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>

On bitmap resizing, attempt to reuse the former chunk size (if any)
in order to preserve the, ev. on purpose set, chunk size resolution.

Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/md/md-cluster.c |  3 ++-
 drivers/md/raid1.c      |  3 ++-
 drivers/md/raid10.c     | 12 ++++++++----
 drivers/md/raid5.c      |  3 ++-
 4 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 10e0c5381d01..9929631bdc94 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -604,7 +604,8 @@ static int process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 	case BITMAP_RESIZE:
 		if (le64_to_cpu(msg->high) != mddev->pers->size(mddev, 0, 0))
 			ret = md_bitmap_resize(mddev->bitmap,
-					    le64_to_cpu(msg->high), 0, 0);
+					    le64_to_cpu(msg->high),
+					    mddev->bitmap_info.chunksize, 0);
 		break;
 	default:
 		ret = -1;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 05d8438cfec8..8f1d25064a53 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3225,7 +3225,8 @@ static int raid1_resize(struct mddev *mddev, sector_t sectors)
 	    mddev->array_sectors > newsize)
 		return -EINVAL;
 	if (mddev->bitmap) {
-		int ret = md_bitmap_resize(mddev->bitmap, newsize, 0, 0);
+		int ret = md_bitmap_resize(mddev->bitmap, newsize,
+				mddev->bitmap_info.chunksize, 0);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3aa8b6e11d58..8f0453b6e0c6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4346,7 +4346,8 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
 	    mddev->array_sectors > size)
 		return -EINVAL;
 	if (mddev->bitmap) {
-		int ret = md_bitmap_resize(mddev->bitmap, size, 0, 0);
+		int ret = md_bitmap_resize(mddev->bitmap, size,
+				mddev->bitmap_info.chunksize, 0);
 		if (ret)
 			return ret;
 	}
@@ -4618,7 +4619,8 @@ static int raid10_start_reshape(struct mddev *mddev)
 		newsize = raid10_size(mddev, 0, conf->geo.raid_disks);
 
 		if (!mddev_is_clustered(mddev)) {
-			ret = md_bitmap_resize(mddev->bitmap, newsize, 0, 0);
+			ret = md_bitmap_resize(mddev->bitmap, newsize,
+					mddev->bitmap_info.chunksize, 0);
 			if (ret)
 				goto abort;
 			else
@@ -4640,13 +4642,15 @@ static int raid10_start_reshape(struct mddev *mddev)
 			    MD_FEATURE_RESHAPE_ACTIVE)) || (oldsize == newsize))
 			goto out;
 
-		ret = md_bitmap_resize(mddev->bitmap, newsize, 0, 0);
+		ret = md_bitmap_resize(mddev->bitmap, newsize,
+				mddev->bitmap_info.chunksize, 0);
 		if (ret)
 			goto abort;
 
 		ret = md_cluster_ops->resize_bitmaps(mddev, newsize, oldsize);
 		if (ret) {
-			md_bitmap_resize(mddev->bitmap, oldsize, 0, 0);
+			md_bitmap_resize(mddev->bitmap, oldsize,
+					mddev->bitmap_info.chunksize, 0);
 			goto abort;
 		}
 	}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7b820b81d8c2..bff7d3d779ae 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8372,7 +8372,8 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
 	    mddev->array_sectors > newsize)
 		return -EINVAL;
 	if (mddev->bitmap) {
-		int ret = md_bitmap_resize(mddev->bitmap, sectors, 0, 0);
+		int ret = md_bitmap_resize(mddev->bitmap, sectors,
+				mddev->bitmap_info.chunksize, 0);
 		if (ret)
 			return ret;
 	}
-- 
2.34.1

