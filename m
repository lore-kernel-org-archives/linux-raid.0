Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD8CEC6FD1A
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjCFVaf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjCFV3g (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3A738EB1
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t4WqynCJjlCiRmR0zL1+ETd1BYBMe73ChaAfsr8pRv4=;
        b=Hc2zSI00L/6cxH23eXKtp1F853CEZwF0/3NDhTicrp/rpgylcBcHlPSWlrtykG6w8skhRi
        RN4I4wHECKO0L612UPCLDi2TfCBbOFjCcVcLvryJe+36qeQeYvqSgUTQ2naEi9lGxO0URQ
        Gatfk0ehVIF3umr2vC+Ivvyclh8OMDo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-NPXnHXjOMFOiTjEFlP04AA-1; Mon, 06 Mar 2023 16:28:28 -0500
X-MC-Unique: NPXnHXjOMFOiTjEFlP04AA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EC03802D2F
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:28 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABE9340CF8F0;
        Mon,  6 Mar 2023 21:28:27 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 29/34] md: prefer 'unsigned int' [WARNING]
Date:   Mon,  6 Mar 2023 22:27:52 +0100
Message-Id: <155adb16b44cb756033a67455a0300a0c790aa68.1678136717.git.heinzm@redhat.com>
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
 drivers/md/md.c       | 3 +--
 drivers/md/raid0.c    | 6 +++---
 drivers/md/raid1-10.c | 3 +--
 drivers/md/raid1.c    | 2 +-
 drivers/md/raid5.c    | 4 ++--
 5 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6a4d01efaca5..9b734720b9c1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2064,8 +2064,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 
 		sb->feature_map |= cpu_to_le32(MD_FEATURE_BAD_BLOCKS);
 		if (bb->changed) {
-			unsigned seq;
-
+			unsigned int seq;
 retry:
 			seq = read_seqbegin(&bb->lock);
 
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index b4c372c6861b..cedb91f84b69 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -70,7 +70,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	struct strip_zone *zone;
 	int cnt;
 	struct r0conf *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
-	unsigned blksize = 512;
+	unsigned int blksize = 512;
 
 	*private_conf = ERR_PTR(-ENOMEM);
 	if (!conf)
@@ -519,8 +519,8 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 	sector_t bio_sector;
 	sector_t sector;
 	sector_t orig_sector;
-	unsigned chunk_sects;
-	unsigned sectors;
+	unsigned int chunk_sects;
+	unsigned int sectors;
 
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
 	    && md_flush_request(mddev, bio))
diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index e61f6cad4e08..8658f474bf2e 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -73,8 +73,7 @@ static inline void resync_get_all_pages(struct resync_pages *rp)
 		get_page(rp->pages[i]);
 }
 
-static inline struct page *resync_fetch_page(struct resync_pages *rp,
-					     unsigned idx)
+static inline struct page *resync_fetch_page(struct resync_pages *rp, unsigned int idx)
 {
 	if (WARN_ON_ONCE(idx >= RESYNC_PAGES))
 		return NULL;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index bd245f41393a..8097e01cd63b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1128,7 +1128,7 @@ static void alloc_behind_master_bio(struct r1bio *r1_bio,
 					   struct bio *bio)
 {
 	int size = bio->bi_iter.bi_size;
-	unsigned vcnt = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	unsigned int vcnt = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	int i = 0;
 	struct bio *behind_bio = NULL;
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 84e4eaa937cf..557398bf4c72 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5632,8 +5632,8 @@ static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
 {
 	struct bio *split;
 	sector_t sector = raid_bio->bi_iter.bi_sector;
-	unsigned chunk_sects = mddev->chunk_sectors;
-	unsigned sectors = chunk_sects - (sector & (chunk_sects-1));
+	unsigned int chunk_sects = mddev->chunk_sectors;
+	unsigned int sectors = chunk_sects - (sector & (chunk_sects-1));
 
 	if (sectors < bio_sectors(raid_bio)) {
 		struct r5conf *conf = mddev->private;
-- 
2.39.2

