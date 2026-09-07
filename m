Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486FC4CA29E
	for <linux-raid@vger.kernel.org>; Mon,  7 Sep 2026 13:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788788378; cv=none; b=M9xy/mQPG1KjSgP2VwKewl51V242FJbGxepr6R/ffQ9JW4zXDF17LX0X3t7X9KlOkQPoACV0dISm7l3CrAoXmUb0QiPTJSB8Alj1w/VGOweXc3tI1RdPFAwjBAW13ZYPNzao5DAxmA0mqwBCVlodex91fpghejQI+CelfFfVfBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788788378; c=relaxed/simple;
	bh=hD/Ag5mHGnb/+Q6knSZLrEWDJiU4f9Bj33/1WM3/LXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZafPwVH1W+vd5pw1izX+ntMYDR2PMnWLAcxRF6baG8Loujv6xcBPvnAVyNPIGBB7GPOq6GM+QOSdQ17+IpIMjydEM6Q/GRk06ROWLENz4JY4aBezI/ACo1xE5LUS6DUYDsMqFtszNKpDouQcDLt4NB21VVJirw/2WE7lOLXeATY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=GHWh4IM2; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="GHWh4IM2"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c255a6e63c0so41612366b.3
        for <linux-raid@vger.kernel.org>; Mon, 07 Sep 2026 06:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1788788374; x=1789393174; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E3LHKOhRHO633fHElMtM+oKayOtlnDDwdzgZYZQwQYo=;
        b=GHWh4IM2pqHGd1IIba3F1sPYrYi20Z+9MOwBdyjahoezgBUZ6ooqGNPSQdog6EiwHP
         6KDUCcaeKlY76QG1AuQ9Wal3Zshf83AfETubekoMuv8Mt+cLdT+G6OWbaMcdxxFzm/zS
         t28uMJIlmIAwv++F0hlKjzKzUcjhIeIBftFokSQDL2y6Iqmb07r/GlpJthH9sJN9W+ua
         bAo0S4i3s3wLRGmsmlDItLS4Oirao79eO0Bwnp3xcSGbxu+YpRndWwg8xTA+i95bN21B
         vkAuuQwNkg5AwqCO16QiOMDnNq0dW8RpFuqdp4WvhEmD08kWacLWwHDtHThAQfjzNc0M
         OHHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788788374; x=1789393174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=E3LHKOhRHO633fHElMtM+oKayOtlnDDwdzgZYZQwQYo=;
        b=a771+xXKgKqwkGXpud9pKJOakRsVrG0tFwCwfE8uztxKXg+Lxvolv6a/egUWw3h3/+
         zS0f49lGQfU6Usl0IY2+etv67cMxcDk7WlmVotNI8fUA8WmdZbHekY1Z6M3WsnF3vItM
         bWKfkh2bhnL+AMopqapd5QWayBVLCksvUkFRSm/v8FLlVttLJc6eSTyiEMCHpcz6DjT4
         5fKxQDDEVmYoZgkdjV3iNGU5jqirOifip3abBwloy02nlOwrH+X9TH5PSPlGUeMb6gLj
         0MnTQi0fPgEbmeIQhF60oztzTgbAXkulUn4Z5EdtQAYCDg7kbUHrJnTBDnWwucW62nzJ
         rELA==
X-Gm-Message-State: AFuF++meraCOkRgZahk2aZwhXfJB2h/RuOgAqrqk0u57ZEXZrYn1DCPl
	+vs8s9JzcpJn+kwvW6D+kqHiXDAWZ9BgmapVZDIB0BvickTm5zs02+TEIroLfQqUFME=
X-Gm-Gg: AYBFou3bwt+NCiVCQrTzSW5JX0cc6HwaYZ+Nvaoboil1GrQud6gTg4t6SQOevxKtFZp
	1NgFpXaqobIyDz5SX0oW+1OmzEsSgGNo5Dy/tc6Qw+eqLBXmNKyG06RemVe5BAeCtabQ1KCiqes
	Sm5YYDEBFzxSJluqxsj0JTktuLIVYEAXr+RWqH2cRwhh9yr563DdE4AD97Jbd4sDVRpBPWMGE8d
	NNm7n6rWFsaL3LXKRHF+C2Qy9aBSXsG7RHz6bErTKS/EGRh08Rs1CJ9GGrG9W7kPVf/+PBGzbVJ
	CSOrB1g+gspp7Y6gzRVyD2cUmtQlJYBC2GJwpHIqwnzoZFwwlUn9IiQKv354+1jYQu1es3+fGe+
	ylcvwVXKr6bGjSGsMtNQE6sE0nMD9Md+85UIPgUApkz36C2TKtT7Ki2IT0umxMJJ/nl5wWWjx31
	yQRsnVlzb4hcL8WhZpjNRAf1eIEDY1ikhZOyFfP1wtlHLNYeC1IXSH5e6YQtX/65nZj0Mlox0j1
	Q2nd5fpJl879JQr1TOaf7qn7K6EjcXwbw==
X-Received: by 2002:a17:907:c1b:b0:c15:ccda:26d5 with SMTP id a640c23a62f3a-c2612b8e83fmr883905666b.4.1788788374271;
        Mon, 07 Sep 2026 06:39:34 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c262c770678sm314301866b.53.2026.09.07.06.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 06:39:33 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Nilay Shroff <nilay@linux.ibm.com>,
	abd.masalkhi@gmail.com
Cc: linux-raid <linux-raid@vger.kernel.org>,
	linux-block <linux-block@vger.kernel.org>,
	Song Liu <song@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	tom.leiming@gmail.com,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 2/6] md: pass a queue_limits down to ->hot_add_disk()
Date: Mon,  7 Sep 2026 15:39:25 +0200
Message-ID: <20260907133929.1081540-3-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907133929.1081540-1-jinpu.wang@ionos.com>
References: <20260907133929.1081540-1-jinpu.wang@ionos.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Wang <jinpu.wang@cloud.ionos.com>

Adding a leg stacks its queue limits, which mddev_stack_new_rdev() does
by taking q->limits_lock itself.  Callers that hold reconfig_mutex, or
have the array suspended, must not do that: the lock's holder waits for
I/O they are blocking.  They need to own the update instead.

Give ->hot_add_disk(), remove_and_add_spares() and
md_choose_sync_action() a queue_limits argument, and add
mddev_stack_rdev_into() to stack into a caller-owned update.  Every
caller passes NULL, so no functional change; the users follow.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/md/dm-raid.c   |  2 +-
 drivers/md/md-linear.c |  3 +-
 drivers/md/md.c        | 66 ++++++++++++++++++++++++++++++++----------
 drivers/md/md.h        |  5 +++-
 drivers/md/raid1.c     |  8 +++--
 drivers/md/raid10.c    | 15 +++++++---
 drivers/md/raid5.c     |  5 ++--
 7 files changed, 78 insertions(+), 26 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8f5a5e1342a9..21a1922bee4f 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3923,7 +3923,7 @@ static void attempt_restore_of_faulty_devices(struct raid_set *rs)
 			clear_bit(Faulty, &r->flags);
 			clear_bit(WriteErrorSeen, &r->flags);
 
-			if (mddev->pers->hot_add_disk(mddev, r)) {
+			if (mddev->pers->hot_add_disk(mddev, r, NULL)) {
 				/* Failed to revive this device, try next */
 				r->raid_disk = r->saved_raid_disk = -1;
 				r->flags = flags;
diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 73b367b61b87..1f44c2d7db93 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -186,7 +186,8 @@ static int linear_run(struct mddev *mddev)
 	return ret;
 }
 
-static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
+static int linear_add(struct mddev *mddev, struct md_rdev *rdev,
+		      struct queue_limits *lim)
 {
 	/* Adding a drive to a linear array allows the array to grow.
 	 * It is permitted if the new drive has a matching superblock
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..28fc903ffeea 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -94,8 +94,8 @@ static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
  */
 static struct workqueue_struct *md_misc_wq;
 
-static int remove_and_add_spares(struct mddev *mddev,
-				 struct md_rdev *this);
+static int remove_and_add_spares(struct mddev *mddev, struct md_rdev *this,
+				 struct queue_limits *lim);
 static void mddev_detach(struct mddev *mddev);
 static void export_rdev(struct md_rdev *rdev);
 static void md_wakeup_thread_directly(struct md_thread __rcu **thread);
@@ -2994,7 +2994,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
 		 */
 		super_types[mddev->major_version].
 			validate_super(mddev, NULL/*freshest*/, rdev);
-		err = mddev->pers->hot_add_disk(mddev, rdev);
+		err = mddev->pers->hot_add_disk(mddev, rdev, NULL);
 		if (err) {
 			md_kick_rdev_from_array(rdev);
 			return err;
@@ -3110,7 +3110,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 	} else if (cmd_match(buf, "remove")) {
 		if (rdev->mddev->pers) {
 			clear_bit(Blocked, &rdev->flags);
-			remove_and_add_spares(rdev->mddev, rdev);
+			remove_and_add_spares(rdev->mddev, rdev, NULL);
 		}
 		if (rdev->raid_disk >= 0)
 			err = -EBUSY;
@@ -3314,7 +3314,7 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		if (rdev->mddev->pers->hot_remove_disk == NULL)
 			return -EINVAL;
 		clear_bit(Blocked, &rdev->flags);
-		remove_and_add_spares(rdev->mddev, rdev);
+		remove_and_add_spares(rdev->mddev, rdev, NULL);
 		if (rdev->raid_disk >= 0)
 			return -EBUSY;
 		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
@@ -3344,7 +3344,8 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 			rdev->saved_raid_disk = -1;
 		clear_bit(In_sync, &rdev->flags);
 		clear_bit(Bitmap_sync, &rdev->flags);
-		err = rdev->mddev->pers->hot_add_disk(rdev->mddev, rdev);
+		err = rdev->mddev->pers->hot_add_disk(rdev->mddev, rdev,
+						     NULL);
 		if (err) {
 			rdev->raid_disk = -1;
 			return err;
@@ -6275,6 +6276,40 @@ int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
 }
 EXPORT_SYMBOL_GPL(mddev_stack_new_rdev);
 
+/*
+ * Stack a new rdev into limits the caller already holds limits_lock for and
+ * will commit itself.  Used from paths that must take limits_lock before
+ * quiescing the array, see md_start_sync().
+ */
+int mddev_stack_rdev_into(struct mddev *mddev, struct md_rdev *rdev,
+			  struct queue_limits *lim)
+{
+	struct queue_limits tmp = *lim;
+
+	if (mddev_is_dm(mddev))
+		return 0;
+
+	if (queue_logical_block_size(rdev->bdev->bd_disk->queue) >
+	    queue_logical_block_size(mddev->gendisk->queue)) {
+		pr_err("%s: incompatible logical_block_size, can not add\n",
+		       mdname(mddev));
+		return -EINVAL;
+	}
+
+	queue_limits_stack_bdev(&tmp, rdev->bdev, rdev->data_offset,
+				mddev->gendisk->disk_name);
+
+	if (!queue_limits_stack_integrity_bdev(&tmp, rdev->bdev)) {
+		pr_err("%s: incompatible integrity profile for %pg\n",
+		       mdname(mddev), rdev->bdev);
+		return -ENXIO;
+	}
+
+	*lim = tmp;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mddev_stack_rdev_into);
+
 /* update the optimal I/O size after a reshape */
 void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes)
 {
@@ -7706,7 +7741,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 		goto kick_rdev;
 
 	clear_bit(Blocked, &rdev->flags);
-	remove_and_add_spares(mddev, rdev);
+	remove_and_add_spares(mddev, rdev, NULL);
 
 	if (rdev->raid_disk >= 0)
 		goto busy;
@@ -10167,8 +10202,8 @@ static int remove_spares(struct mddev *mddev, struct md_rdev *this)
 	return removed;
 }
 
-static int remove_and_add_spares(struct mddev *mddev,
-				 struct md_rdev *this)
+static int remove_and_add_spares(struct mddev *mddev, struct md_rdev *this,
+				 struct queue_limits *lim)
 {
 	struct md_rdev *rdev;
 	int spares = 0;
@@ -10191,7 +10226,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 			continue;
 		if (!test_bit(Journal, &rdev->flags))
 			rdev->recovery_offset = 0;
-		if (mddev->pers->hot_add_disk(mddev, rdev) == 0) {
+		if (mddev->pers->hot_add_disk(mddev, rdev, lim) == 0) {
 			/* failure here is OK */
 			sysfs_link_rdev(mddev, rdev);
 			if (!test_bit(Journal, &rdev->flags))
@@ -10206,7 +10241,8 @@ static int remove_and_add_spares(struct mddev *mddev,
 	return spares;
 }
 
-static bool md_choose_sync_action(struct mddev *mddev, int *spares)
+static bool md_choose_sync_action(struct mddev *mddev, int *spares,
+				  struct queue_limits *lim)
 {
 	/* Check if reshape is in progress first. */
 	if (mddev->reshape_position != MaxSector) {
@@ -10234,7 +10270,7 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 	 * also removed and re-added, to allow the personality to fail the
 	 * re-add.
 	 */
-	*spares = remove_and_add_spares(mddev, NULL);
+	*spares = remove_and_add_spares(mddev, NULL, lim);
 	if (*spares || test_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery)) {
 		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
@@ -10294,11 +10330,11 @@ static void md_start_sync(struct work_struct *ws)
 		 * As we only add devices that are already in-sync, we can
 		 * activate the spares immediately.
 		 */
-		remove_and_add_spares(mddev, NULL);
+		remove_and_add_spares(mddev, NULL, NULL);
 		goto not_running;
 	}
 
-	if (!md_choose_sync_action(mddev, &spares))
+	if (!md_choose_sync_action(mddev, &spares, NULL))
 		goto not_running;
 
 	if (!mddev->pers->sync_request)
@@ -10849,7 +10885,7 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 					rdev2->saved_raid_disk = -1;
 				else
 					rdev2->saved_raid_disk = role;
-				ret = remove_and_add_spares(mddev, rdev2);
+				ret = remove_and_add_spares(mddev, rdev2, NULL);
 				pr_info("Activated spare: %pg\n",
 					rdev2->bdev);
 				/* wakeup mddev->thread here, so array could
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b6d2e8929a0f..39b95951cc17 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -765,7 +765,8 @@ struct md_personality
 	 * if appropriate, and should abort recovery if needed
 	 */
 	void (*error_handler)(struct mddev *mddev, struct md_rdev *rdev);
-	int (*hot_add_disk) (struct mddev *mddev, struct md_rdev *rdev);
+	int (*hot_add_disk)(struct mddev *mddev, struct md_rdev *rdev,
+			    struct queue_limits *lim);
 	int (*hot_remove_disk) (struct mddev *mddev, struct md_rdev *rdev);
 	int (*spare_active) (struct mddev *mddev);
 	sector_t (*sync_request)(struct mddev *mddev, sector_t sector_nr,
@@ -1047,6 +1048,8 @@ int do_md_run(struct mddev *mddev);
 int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
 		unsigned int flags);
 int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev);
+int mddev_stack_rdev_into(struct mddev *mddev, struct md_rdev *rdev,
+			  struct queue_limits *lim);
 void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes);
 
 extern const struct block_device_operations md_fops;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f0646fb24371..dd348b5695d0 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1898,7 +1898,8 @@ static bool raid1_remove_conf(struct r1conf *conf, int disk)
 	return true;
 }
 
-static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
+static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev,
+			  struct queue_limits *lim)
 {
 	struct r1conf *conf = mddev->private;
 	int err = -EEXIST;
@@ -1923,7 +1924,10 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	for (mirror = first; mirror <= last; mirror++) {
 		p = conf->mirrors + mirror;
 		if (!p->rdev) {
-			err = mddev_stack_new_rdev(mddev, rdev);
+			if (lim)
+				err = mddev_stack_rdev_into(mddev, rdev, lim);
+			else
+				err = mddev_stack_new_rdev(mddev, rdev);
 			if (err)
 				return err;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1093c798d9dd..a5b65f377d04 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2095,7 +2095,8 @@ static int raid10_spare_active(struct mddev *mddev)
 	return count;
 }
 
-static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
+static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev,
+			   struct queue_limits *lim)
 {
 	struct r10conf *conf = mddev->private;
 	int err = -EEXIST;
@@ -2130,7 +2131,10 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			continue;
 		}
 
-		err = mddev_stack_new_rdev(mddev, rdev);
+		if (lim)
+			err = mddev_stack_rdev_into(mddev, rdev, lim);
+		else
+			err = mddev_stack_new_rdev(mddev, rdev);
 		if (err)
 			return err;
 		p->head_position = 0;
@@ -2147,7 +2151,10 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		clear_bit(In_sync, &rdev->flags);
 		set_bit(Replacement, &rdev->flags);
 		rdev->raid_disk = repl_slot;
-		err = mddev_stack_new_rdev(mddev, rdev);
+		if (lim)
+			err = mddev_stack_rdev_into(mddev, rdev, lim);
+		else
+			err = mddev_stack_new_rdev(mddev, rdev);
 		if (err)
 			return err;
 		conf->fullsync = 1;
@@ -4484,7 +4491,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 		rdev_for_each(rdev, mddev)
 			if (rdev->raid_disk < 0 &&
 			    !test_bit(Faulty, &rdev->flags)) {
-				if (raid10_add_disk(mddev, rdev) == 0) {
+				if (raid10_add_disk(mddev, rdev, NULL) == 0) {
 					if (rdev->raid_disk >=
 					    conf->prev.raid_disks)
 						set_bit(In_sync, &rdev->flags);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b91545ce090d..0ec555ada64a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8441,7 +8441,8 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	return err;
 }
 
-static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
+static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev,
+			  struct queue_limits *lim)
 {
 	struct r5conf *conf = mddev->private;
 	int ret, err = -EEXIST;
@@ -8728,7 +8729,7 @@ static int raid5_start_reshape(struct mddev *mddev)
 		rdev_for_each(rdev, mddev)
 			if (rdev->raid_disk < 0 &&
 			    !test_bit(Faulty, &rdev->flags)) {
-				if (raid5_add_disk(mddev, rdev) == 0) {
+				if (raid5_add_disk(mddev, rdev, NULL) == 0) {
 					if (rdev->raid_disk
 					    >= conf->previous_raid_disks)
 						set_bit(In_sync, &rdev->flags);
-- 
2.43.0

