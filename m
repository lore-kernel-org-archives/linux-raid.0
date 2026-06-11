Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D91370AF6
	for <linux-raid@vger.kernel.org>; Thu, 11 Jun 2026 08:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781166933; cv=none; b=NjlYHItrCgORLAX+u36YstNUpAKfp3ji7UNpaXRNNKuNCaLyBvl/vktsx22l17Eaa/P83rP84sheyUrRUHiK/l8Q6SQtzWWVCOr9on5igBs3sx5u7OHbd+rRBiCVY6xQ+P/kqHM0ZzUnOgsxGdbSmIfl1bAQ1CL9WVTc/ttbOMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781166933; c=relaxed/simple;
	bh=adrzxXaPLJGP7roNgSQZ5MepEJ3NFhQuSaSwV81bBII=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OJXqWgDmkv5AYJ9ZuY2vBbJeu6EdOHRUwCNbqXiJBnXkDTl/t7pZpWb0cYBn4ViC01J0H7tdtLOfxiSHylec9Z5IWxvRVyCzJVAbb+xEeHTaDZCdEHwoJYZpslgh9tDoBVUT+QDZ2DKNw4xH4DzkJoxEoFZxGKBstxTtflDxejs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OJaQgBI/; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OJaQgBI/"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51778077b28so85473681cf.1
        for <linux-raid@vger.kernel.org>; Thu, 11 Jun 2026 01:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781166931; x=1781771731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IWa6r+6TmQG8v9LMqLWqXodbxfzDu8ypmi09vJ5cWrI=;
        b=OJaQgBI/b9K/6iVRWDI85qD8VbWUkX/uX4Nj/LWhx/C2J2IsHpPVi+vYTFw5SrwG2j
         vNqmvwggnlgLZo9qKiRkbtHnPvZC4PbhUqn0YePb06eVOLdIntDzhgb1/Ann4N5V2dFa
         NM8L9W56ly3zeqjY9Focu8bF7mhFtsZwNaJbUflf/cU4XVJ3T6FwspBC0/t1IDwg61Ua
         gF3Cl/j5w7IimXfxDO/ZzHri9tNGZilr90mOnxv15sHmzmj92V4DSRwbp6REuFJcmuhv
         5OALz8Rd/JoETip4BkxLilLVUAeA9ObB+bgm1OOql7ZuaIX2oc0Mmh2AvS7iBAoToogq
         ouKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781166931; x=1781771731;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IWa6r+6TmQG8v9LMqLWqXodbxfzDu8ypmi09vJ5cWrI=;
        b=UGzFwgrlTj3e/ZjJ7Sxu2J52Zf9AUtoy3YQD0RdI7m16d+qJCOYfF+A+G5hiErGSpN
         s69m6xEdRIjVCWi/Kv+DDrRgknRbUegsx0109kvUVhqxrWXH2zHNCyi77glEsX6Rca7y
         mh8y9XJBkhI3vRPebSwWY2hi+PvASTOXBF3V54bdOu/ZP1PzUgaMy8zEX70Dv4YlIr9c
         uViu9loOzeyDGyissnY4XnGKUIvCL3lrMIRtOF/8dGTegANLSY6CpDXFGjq8Ws2UBvZq
         tOplNgh/4/KdXSuYiBwV2Xa5wcTiR5JMndWiHf/k+y+8Nni+cAfpvlLKsBxBVziFAvBr
         WGJA==
X-Gm-Message-State: AOJu0Yz53exH16D4HEJzrwqVkBDB7dWypCa1jRYERJ8iBZsnmwi4rXvd
	kN8FOTdWV057VEnlncYsJIPVnmUIzwCgsID5H56Kc5JqBE+dH7JL9c0Q
X-Gm-Gg: Acq92OGhTk4BgLy81QGOZvM8scm7dmm7s1K5+7OQaJsfPsyieoT1vCfuKQ+1/zCeyZR
	9j4cdL486F5tf37eXSDT8uQwe6jsagdpuF8I4d/g58b0VUe6xIzIwI5YjIIjPgR36mNJw7xlWJ7
	OucuMi2SqRxrEJzglfC9ZDmFmaDeBMVP3ZTjwF+6/9U9GsJ6wmlnanpb9U2N2HW7jxs2zJUMZVu
	SXzyDuGSz5fucAFTQW9RqMiltfcDnZ+kdkIDEsadWSSg9GKNQs3k9TTdKiTV0fc/w60n7XGrTR1
	Y17HDl+Wl/v9X5ZNREMdaEI2G/5Cazm2EhKeDOBPV/AlKodGsvZqoyO/KHoZycSjDqHVFdJTaKp
	e9bfaOvJ8REfYXcSZ0PBl34yzcxgrmFoUFXZJ851P5iKMYDxqvZVT8jMTAC+OFvdN6OGwqJ9yoD
	8cFU7aEqa67gywTKG9o+h0IDG87Q1ffrspvROGymOl+osLuxzC6HPyPg==
X-Received: by 2002:a05:622a:99a:b0:516:d4b1:48cd with SMTP id d75a77b69052e-517edd0ce26mr26786061cf.2.1781166930798;
        Thu, 11 Jun 2026 01:35:30 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de ([141.2.113.162])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517ef40db7bsm11797141cf.7.2026.06.11.01.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 01:35:29 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	vverma@digitalocean.com,
	axboe@kernel.dk
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH] md/raid1: honor REQ_NOWAIT when waiting for behind writes
Date: Thu, 11 Jun 2026 08:35:14 +0000
Message-ID: <20260611083514.754922-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

raid1 supports REQ_NOWAIT reads by avoiding waits in the barrier path
through wait_read_barrier(). However, a read can still block on a
WriteMostly device when the array uses a bitmap and there are
outstanding behind writes.

In that case raid1 unconditionally calls wait_behind_writes(), which
may sleep until all behind writes complete. As a result, a REQ_NOWAIT
read can block despite the caller explicitly requesting non-blocking
behavior.

This ensures that raid1 consistently honors REQ_NOWAIT reads across all
paths that may otherwise wait for behind writes.

Fixes: 5aa705039c4f ("md: raid1 add nowait support")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/md-bitmap.c   |  9 +++++++--
 drivers/md/md-bitmap.h   |  2 +-
 drivers/md/md-llbitmap.c | 13 ++++++++-----
 drivers/md/md.c          |  2 +-
 drivers/md/raid1.c       | 10 +++++++---
 5 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 028b9ca8ce52..1206e31f323a 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2063,18 +2063,23 @@ static void bitmap_end_behind_write(struct mddev *mddev)
 		 bitmap->mddev->bitmap_info.max_write_behind);
 }
 
-static void bitmap_wait_behind_writes(struct mddev *mddev)
+static bool bitmap_wait_behind_writes(struct mddev *mddev, bool nowait)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
 	/* wait for behind writes to complete */
 	if (bitmap && atomic_read(&bitmap->behind_writes) > 0) {
+		if (nowait)
+			return false;
+
 		pr_debug("md:%s: behind writes in progress - waiting to stop.\n",
 			 mdname(mddev));
 		/* need to kick something here to make sure I/O goes? */
 		wait_event(bitmap->behind_wait,
 			   atomic_read(&bitmap->behind_writes) == 0);
 	}
+
+	return true;
 }
 
 static void bitmap_destroy(struct mddev *mddev)
@@ -2084,7 +2089,7 @@ static void bitmap_destroy(struct mddev *mddev)
 	if (!bitmap) /* there was no bitmap */
 		return;
 
-	bitmap_wait_behind_writes(mddev);
+	bitmap_wait_behind_writes(mddev, false);
 	if (!test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
 		mddev_destroy_serial_pool(mddev, NULL);
 
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 214f623c7e79..f46674bdfeb9 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -98,7 +98,7 @@ struct bitmap_operations {
 
 	void (*start_behind_write)(struct mddev *mddev);
 	void (*end_behind_write)(struct mddev *mddev);
-	void (*wait_behind_writes)(struct mddev *mddev);
+	bool (*wait_behind_writes)(struct mddev *mddev, bool nowait);
 
 	md_bitmap_fn *start_write;
 	md_bitmap_fn *end_write;
diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 1adc5b117821..5a4e2abaa757 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1574,16 +1574,19 @@ static void llbitmap_end_behind_write(struct mddev *mddev)
 		wake_up(&llbitmap->behind_wait);
 }
 
-static void llbitmap_wait_behind_writes(struct mddev *mddev)
+static bool llbitmap_wait_behind_writes(struct mddev *mddev, bool nowait)
 {
 	struct llbitmap *llbitmap = mddev->bitmap;
 
-	if (!llbitmap)
-		return;
+	if (llbitmap && atomic_read(&llbitmap->behind_writes) > 0) {
+		if (nowait)
+			return false;
 
-	wait_event(llbitmap->behind_wait,
-		   atomic_read(&llbitmap->behind_writes) == 0);
+		wait_event(llbitmap->behind_wait,
+			   atomic_read(&llbitmap->behind_writes) == 0);
+	}
 
+	return true;
 }
 
 static ssize_t bits_show(struct mddev *mddev, char *page)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 096bb64e87bd..d1465bcd86c8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7050,7 +7050,7 @@ EXPORT_SYMBOL_GPL(md_stop_writes);
 static void mddev_detach(struct mddev *mddev)
 {
 	if (md_bitmap_enabled(mddev, false))
-		mddev->bitmap_ops->wait_behind_writes(mddev);
+		mddev->bitmap_ops->wait_behind_writes(mddev, false);
 	if (mddev->pers && mddev->pers->quiesce && !is_md_suspended(mddev)) {
 		mddev->pers->quiesce(mddev, 1);
 		mddev->pers->quiesce(mddev, 0);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index b1ed4cc6ade4..b2d7c13b64bd 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1341,6 +1341,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	int max_sectors;
 	int rdisk;
 	bool r1bio_existed = !!r1_bio;
+	bool nowait = bio->bi_opf & REQ_NOWAIT;
 
 	/*
 	 * An md cloned bio indicates we are in the error path.
@@ -1360,8 +1361,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	 * Still need barrier for READ in case that whole
 	 * array is frozen.
 	 */
-	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,
-				bio->bi_opf & REQ_NOWAIT)) {
+	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector, nowait)) {
 		bio_wouldblock_error(bio);
 		return;
 	}
@@ -1402,7 +1402,11 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 		 * over-take any writes that are 'behind'
 		 */
 		mddev_add_trace_msg(mddev, "raid1 wait behind writes");
-		mddev->bitmap_ops->wait_behind_writes(mddev);
+		if (!mddev->bitmap_ops->wait_behind_writes(mddev, nowait)) {
+			bio_wouldblock_error(bio);
+			set_bit(R1BIO_Returned, &r1_bio->state);
+			goto err_handle;
+		}
 	}
 
 	if (max_sectors < bio_sectors(bio)) {
-- 
2.43.0

