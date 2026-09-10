Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A58430CCA
	for <linux-raid@vger.kernel.org>; Thu, 10 Sep 2026 08:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027893; cv=none; b=SZ7tt+UVzQx9G/EsIEckU1UD/qPfl51UORWIRwLY4mGJiPF+2hyMIUS3n/wTjNQWZZpaD+1VWOYecarDO1GTnge5hNXip0gVj0gaVProMQVv0edYlHmyrwurv9s4FOaCjBU2Pdbhq/RmjLCUkpCqFn7MuORdknXOivB2FgbRY44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027893; c=relaxed/simple;
	bh=N4W4/1Nb4xxCQW/b/yh4LAIUt+gjMzmX7Ei/zLa6UWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gA/3FxIbMig3/XuPgBuXoYW9PlvdGTiJ0lNNkaAjaTeTq/BPeXNrEZKzCGU5i7iqmglA3SLKeondFOzA1DKYo2YmpyvyjoWTh7VhsvIEFO1TSBqkB/CummHNYRdr0C/fGgVjahbtOKotfs6ZN1P/eOnZdmsbu300F9EW+aqkvNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=T0cUXcFR; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="T0cUXcFR"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49d1ddd5d0aso1916455e9.3
        for <linux-raid@vger.kernel.org>; Thu, 10 Sep 2026 01:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1789027886; x=1789632686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+GHgzzQ8rfbRP2Put64Cq82EilqCh8jYa5rghgFsni8=;
        b=T0cUXcFRSTTCOZWzfmdw5HeKCYRLaYu12TxzP2/SIWE6PyPMHPyt89TkO5VQE+snSf
         tx9HUy0BVsGsBuWC1/WpnSEMPRS06BxJ/lEp+/+1cGEhmp9IoOus4x6O+MD7GvxOVJ+Q
         pdiZJpfEgsWdkODpzHVo4b9cj9pwbbrxAfGt5KNagkjAcD63Ri4Khqa40rVXueVjsNlt
         FI9x16Nzy7fhPNZsDYqef2jzxrrJb1oenLhvORzggAzha/aga88CuPzIoSdFQNAcK36K
         +NOjZZeR+vkm8H0MamnFkPIpW1svySdoLdnBcIN3lfkXS89CklcY9P06Oy/hNiu+Vtan
         ++vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789027886; x=1789632686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+GHgzzQ8rfbRP2Put64Cq82EilqCh8jYa5rghgFsni8=;
        b=VPjz4+qWjGXLMaoCpwFDKL6mcegWsrt2uqx8yut8U5bsah10T1qZyQ1mn2fl+nQ7w5
         RKNIpzfnih6jvH4P3vjJGVgVTupfGsrTLH+VZVumAFdQe7LOPyCLC677uT6Y6kThKUy9
         a4D49wbIONIMbhhdm9SmqHe8Oys1ndIolpHrMRoan2FnWdP7biQiDungDxpxq8vOCQNQ
         PZqEA7nC8xTDp75FCKv/XYoc2UZq7eRFsAhX/YWA1q0CIfUMhJGTEFSz+sdvG+CidB2v
         MLTmksVgriCmeE9iJhA/hQ83Kka4LaTMTmkTB7/hGV1C9IhudUtlUuoXTVQouDCCA3wd
         LtgQ==
X-Forwarded-Encrypted: i=1; AKwUvBy3Q40RUyXb8gMG97Ggtt1lWU7tM8fPmRo05WVNL44sk9epd1Ageqjv/q8rx1LwGGPAQneG66sA7al4@vger.kernel.org
X-Gm-Message-State: AFuF++lhAgw7mOh54/cye5N6OtfumdmSfkK/mplQSEuGy3J0trnZSemj
	ATleTuNv1rZOdIhdbtDH7ulQpUG8M65vHfRdxKkYq0kZIhTSNOzdVnKwvkSSNtbeWCw=
X-Gm-Gg: AYBFou1b22YZPzBFnUKrobS6Cflpb4JgRwg+jZmLhI5sNGR3l/5rVk5ezcSSVtHbJg8
	VzWQ2YZT0GSOT1RP2B1l6TUCroHaSeNDckO66AXgRkT4AU0zAt/0TukBuaEKo010B/ZniK9+BVE
	pwS+9yh6lfbfv3i97O0MWFWf7Y72B4MCDLgNWOZhq5fGyli67YM5LhrZ22aJrpbIKWeAAar8v2x
	LRpuFlDyV7pXM5ashCnZ++ig8dQ6RvC9ntuAoLW2y9CBzfv9X0PdzshT/bP/xNnTsqcycBGCMPH
	xfcD1Oq27Fo3WX1mHq3M41j9fl10Ak3WPQHG2rIx9kJ2k+IiCh58mcvkp6ro7WUCcyKwFXP+4f4
	efdWianuR175SAqDWPM4q7R8OhNvE86z939IQt+c7N8lcK9U0La+X5D+mdz7JVIn2ldFi539u1u
	HCiLQye3aDJxFQhRjgx479+XH9JUlLLFiQ7b7ff2LWIFSU7x4vNnacNysQeep+8o4DmLiLinjEn
	/6cNw6J9yFpVXvmxmFG0H9dplxx6spM25hp2KxuOJ9v
X-Received: by 2002:a05:600c:c48f:b0:49b:9241:7ff0 with SMTP id 5b1f17b1804b1-49d010c4f64mr288757255e9.0.1789027885618;
        Thu, 10 Sep 2026 01:11:25 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d20fc1be3sm55261135e9.4.2026.09.10.01.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:11:25 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	Nilay Shroff <nilay@linux.ibm.com>,
	abd.masalkhi@gmail.com
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <tom.leiming@gmail.com>,
	Xiao Ni <xiao@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 7/8] md: open new legs before locking the array
Date: Thu, 10 Sep 2026 10:11:12 +0200
Message-ID: <20260910081114.1605746-8-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910081114.1605746-1-jinpu.wang@ionos.com>
References: <20260910081114.1605746-1-jinpu.wang@ionos.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Wang <jinpu.wang@cloud.ionos.com>

Opening a leg takes disk->open_mutex, and the scsi disk probe path nests
q->limits_lock inside it (sd_open() -> sd_revalidate_disk()).  md opens
legs under reconfig_mutex, which this series makes q->limits_lock nest
outside, closing a cycle.  Booting with lockdep on an md root reports it
during assembly:

  -> #2 (&q->limits_lock):        sd_revalidate_disk / sd_open
  -> #1 (&disk->open_mutex):      md_import_device
                                  md_add_new_disk
                                  md_ioctl        <- ADD_NEW_DISK
  -> #0 (&mddev->reconfig_mutex): md_ioctl        <- RUN_ARRAY

Move every open out from under the lock.  md_import_new_disk() mirrors
md_add_new_disk()'s branch selection so all three of its branches take a
pre-opened leg, and hot_add_disk(), new_dev_store() and md_setup_drive()
open before they lock as well.

The mddev fields the open depends on are read without reconfig_mutex, so
each caller rechecks them once the array is locked and rejects the add
with -EBUSY if the branch or the superblock format would have changed.

md_autostart_arrays() needs no change: it opens under
detected_devices_mutex.

Assisted-by: LLM
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/md/md-autodetect.c |  17 ++-
 drivers/md/md.c            | 238 ++++++++++++++++++++++++++-----------
 drivers/md/md.h            |  21 +++-
 3 files changed, 203 insertions(+), 73 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index e15ae2fb58a2..e592577356ad 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -208,6 +208,7 @@ static void __init md_setup_drive(struct md_setup_args *args)
 			.major	= MAJOR(devices[i]),
 			.minor	= MINOR(devices[i]),
 		};
+		struct md_new_disk nd;
 
 		if (args->level != LEVEL_NONE) {
 			dinfo.number = i;
@@ -216,7 +217,21 @@ static void __init md_setup_drive(struct md_setup_args *args)
 				(1 << MD_DISK_ACTIVE) | (1 << MD_DISK_SYNC);
 		}
 
-		md_add_new_disk(mddev, &dinfo, NULL);
+		/*
+		 * Opening a leg takes disk->open_mutex, which must not nest
+		 * inside reconfig_mutex, see md_import_new_disk().  Drop the
+		 * array lock around it; this is __init and the array is not
+		 * reachable yet, so nothing else can touch it in between.
+		 */
+		mddev_unlock(mddev);
+		if (md_import_new_disk(mddev, &dinfo, &nd)) {
+			mddev_lock_nointr(mddev);
+			continue;
+		}
+		mddev_lock_nointr(mddev);
+
+		md_add_new_disk(mddev, &dinfo, &nd, NULL);
+		md_put_new_disk(&nd);
 	}
 
 	/*
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5be956e80563..fa033d7d3831 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4942,6 +4942,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 	struct md_rdev *rdev;
 	unsigned int noio_flags;
 	int err;
+	int persistent, external, major_version, minor_version;
 
 	if (!*buf || *e != ':' || !e[1] || e[1] == '\n')
 		return -EINVAL;
@@ -4953,32 +4954,52 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 	    minor != MINOR(dev))
 		return -EOVERFLOW;
 
-	err = mddev_suspend_and_lock(mddev);
-	if (err)
-		return err;
-	noio_flags = memalloc_noio_save();
-	if (mddev->persistent) {
-		rdev = md_import_device(dev, mddev->major_version,
-					mddev->minor_version);
-		if (!IS_ERR(rdev) && !list_empty(&mddev->disks)) {
-			struct md_rdev *rdev0
-				= list_entry(mddev->disks.next,
-					     struct md_rdev, same_set);
-			err = super_types[mddev->major_version]
-				.load_super(rdev, rdev0, mddev->minor_version);
-			if (err < 0)
-				goto out;
-		}
-	} else if (mddev->external)
+	/*
+	 * Open before locking the array: bdev_open() takes disk->open_mutex,
+	 * which must not nest inside reconfig_mutex, see md_import_new_disk().
+	 * The fields below are read without the lock and rechecked under it.
+	 */
+	persistent = READ_ONCE(mddev->persistent);
+	external = READ_ONCE(mddev->external);
+	major_version = READ_ONCE(mddev->major_version);
+	minor_version = READ_ONCE(mddev->minor_version);
+
+	if (persistent)
+		rdev = md_import_device(dev, major_version, minor_version);
+	else if (external)
 		rdev = md_import_device(dev, -2, -1);
 	else
 		rdev = md_import_device(dev, -1, -1);
 
-	if (IS_ERR(rdev)) {
-		memalloc_noio_restore(noio_flags);
-		mddev_unlock_and_resume(mddev);
+	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
+
+	err = mddev_suspend_and_lock(mddev);
+	if (err) {
+		export_rdev(rdev);
+		return err;
 	}
+	noio_flags = memalloc_noio_save();
+
+	if (persistent != mddev->persistent || external != mddev->external ||
+	    major_version != mddev->major_version ||
+	    minor_version != mddev->minor_version) {
+		pr_warn("%s: array reconfigured while opening %pg\n",
+			mdname(mddev), rdev->bdev);
+		err = -EBUSY;
+		goto out;
+	}
+
+	if (mddev->persistent && !list_empty(&mddev->disks)) {
+		struct md_rdev *rdev0
+			= list_entry(mddev->disks.next,
+				     struct md_rdev, same_set);
+		err = super_types[mddev->major_version]
+			.load_super(rdev, rdev0, mddev->minor_version);
+		if (err < 0)
+			goto out;
+	}
+
 	err = bind_rdev_to_array(rdev, mddev);
  out:
 	if (err)
@@ -7685,12 +7706,35 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
 	return 0;
 }
 
+/*
+ * @nd carries an rdev the caller opened before locking the array, for the
+ * branch its snapshot selected.  Every caller must open first; doing it
+ * here would nest disk->open_mutex inside reconfig_mutex.
+ */
 int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
-		    struct queue_limits *lim)
+		    struct md_new_disk *nd, struct queue_limits *lim)
 {
 	struct md_rdev *rdev;
 	dev_t dev = MKDEV(info->major,info->minor);
 
+	/*
+	 * The open ran unlocked, so anything that selects a different branch
+	 * below, or a different superblock format, means it was done against
+	 * an array that no longer looks like this one.
+	 */
+	if (nd && nd->rdev &&
+	    (nd->have_raid_disks != (mddev->raid_disks != 0) ||
+	     nd->have_pers != !!mddev->pers ||
+	     nd->persistent != mddev->persistent ||
+	     nd->major_version != mddev->major_version ||
+	     nd->minor_version != mddev->minor_version)) {
+		pr_warn("%s: array reconfigured while opening %pg\n",
+			mdname(mddev), nd->rdev->bdev);
+		export_rdev(nd->rdev);
+		nd->rdev = NULL;
+		return -EBUSY;
+	}
+
 	if (mddev_is_clustered(mddev) &&
 		!(info->state & ((1 << MD_DISK_CLUSTER_ADD) | (1 << MD_DISK_CANDIDATE)))) {
 		pr_warn("%s: Cannot add to clustered mddev.\n",
@@ -7703,13 +7747,12 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
 
 	if (!mddev->raid_disks) {
 		int err;
+
 		/* expecting a device which has a superblock */
-		rdev = md_import_device(dev, mddev->major_version, mddev->minor_version);
-		if (IS_ERR(rdev)) {
-			pr_warn("md: md_import_device returned %ld\n",
-				PTR_ERR(rdev));
-			return PTR_ERR(rdev);
-		}
+		if (WARN_ON_ONCE(!nd || !nd->rdev))
+			return -EINVAL;
+		rdev = nd->rdev;
+		nd->rdev = NULL;
 		if (!list_empty(&mddev->disks)) {
 			struct md_rdev *rdev0
 				= list_entry(mddev->disks.next,
@@ -7742,16 +7785,10 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
 				mdname(mddev));
 			return -EINVAL;
 		}
-		if (mddev->persistent)
-			rdev = md_import_device(dev, mddev->major_version,
-						mddev->minor_version);
-		else
-			rdev = md_import_device(dev, -1, -1);
-		if (IS_ERR(rdev)) {
-			pr_warn("md: md_import_device returned %ld\n",
-				PTR_ERR(rdev));
-			return PTR_ERR(rdev);
-		}
+		if (WARN_ON_ONCE(!nd || !nd->rdev))
+			return -EINVAL;
+		rdev = nd->rdev;
+		nd->rdev = NULL;
 		/* set saved_raid_disk if appropriate */
 		if (!mddev->persistent) {
 			if (info->state & (1<<MD_DISK_SYNC)  &&
@@ -7853,12 +7890,11 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
 
 	if (!(info->state & (1<<MD_DISK_FAULTY))) {
 		int err;
-		rdev = md_import_device(dev, -1, 0);
-		if (IS_ERR(rdev)) {
-			pr_warn("md: error, md_import_device() returned %ld\n",
-				PTR_ERR(rdev));
-			return PTR_ERR(rdev);
-		}
+
+		if (WARN_ON_ONCE(!nd || !nd->rdev))
+			return -EINVAL;
+		rdev = nd->rdev;
+		nd->rdev = NULL;
 		rdev->desc_nr = info->number;
 		if (info->raid_disk < mddev->raid_disks)
 			rdev->raid_disk = info->raid_disk;
@@ -7930,7 +7966,8 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev,
 	return -EBUSY;
 }
 
-static int hot_add_disk(struct mddev *mddev, dev_t dev)
+/* @nd carries a leg the caller opened before the array was locked */
+static int hot_add_disk(struct mddev *mddev, struct md_new_disk *nd)
 {
 	int err;
 	struct md_rdev *rdev;
@@ -7949,12 +7986,10 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 		return -EINVAL;
 	}
 
-	rdev = md_import_device(dev, -1, 0);
-	if (IS_ERR(rdev)) {
-		pr_warn("md: error, md_import_device() returned %ld\n",
-			PTR_ERR(rdev));
+	if (WARN_ON_ONCE(!nd->rdev))
 		return -EINVAL;
-	}
+	rdev = nd->rdev;
+	nd->rdev = NULL;
 
 	if (mddev->persistent)
 		rdev->sb_start = calc_dev_sboffset(rdev);
@@ -8497,14 +8532,61 @@ static inline int md_ioctl_valid(unsigned int cmd)
  * journal device or a personality without ->hot_remove_disk, but that depends
  * on disk info still in user memory here, so it is included as a whole.
  */
-static bool md_ioctl_may_add_disk(unsigned int cmd)
+
+/*
+ * Open the leg before the array is locked; bdev_open() takes
+ * disk->open_mutex, which must not nest inside reconfig_mutex.  mddev is
+ * read unlocked on purpose, and md_add_new_disk() rechecks the snapshot.
+ */
+int md_import_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
+		       struct md_new_disk *nd)
 {
-	switch (cmd) {
-	case ADD_NEW_DISK:
-	case HOT_REMOVE_DISK:
-		return true;
-	default:
-		return false;
+	dev_t dev = MKDEV(info->major, info->minor);
+	struct md_rdev *rdev;
+
+	memset(nd, 0, sizeof(*nd));
+	nd->have_raid_disks = READ_ONCE(mddev->raid_disks) != 0;
+	nd->have_pers = !!READ_ONCE(mddev->pers);
+	nd->persistent = READ_ONCE(mddev->persistent);
+	nd->major_version = READ_ONCE(mddev->major_version);
+	nd->minor_version = READ_ONCE(mddev->minor_version);
+
+	if (!nd->have_raid_disks) {
+		/* a device with a superblock, for an array being assembled */
+		rdev = md_import_device(dev, nd->major_version,
+					nd->minor_version);
+	} else if (nd->have_pers) {
+		/* a hot spare; this is the branch that stacks limits */
+		nd->stacks = true;
+		if (nd->persistent)
+			rdev = md_import_device(dev, nd->major_version,
+						nd->minor_version);
+		else
+			rdev = md_import_device(dev, -1, -1);
+	} else if (nd->major_version == 0) {
+		rdev = md_import_device(dev, -1, 0);
+	} else {
+		/* md_add_new_disk() rejects this, nothing to open */
+		return 0;
+	}
+
+	if (IS_ERR(rdev)) {
+		int err = PTR_ERR(rdev);
+
+		pr_warn("md: md_import_device returned %d\n", err);
+		return err;
+	}
+
+	nd->rdev = rdev;
+	return 0;
+}
+
+/* release a leg md_add_new_disk() did not take ownership of */
+void md_put_new_disk(struct md_new_disk *nd)
+{
+	if (nd->rdev) {
+		export_rdev(nd->rdev);
+		nd->rdev = NULL;
 	}
 }
 
@@ -8566,6 +8648,8 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 	struct request_queue *q = NULL;
 	struct queue_limits lim;
 	struct queue_limits *limp = NULL;
+	struct md_new_disk nd = { };
+	mdu_disk_info_t info;
 	bool suspend;
 
 	err = md_ioctl_valid(cmd);
@@ -8616,8 +8700,27 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 	if (!md_is_rdwr(mddev))
 		flush_work(&mddev->sync_work);
 
+	if (cmd == ADD_NEW_DISK) {
+		if (copy_from_user(&info, argp, sizeof(info))) {
+			err = -EFAULT;
+			goto out;
+		}
+		err = md_import_new_disk(mddev, &info, &nd);
+		if (err)
+			goto out;
+	} else if (cmd == HOT_ADD_DISK) {
+		nd.rdev = md_import_device(new_decode_dev(arg), -1, 0);
+		if (IS_ERR(nd.rdev)) {
+			pr_warn("md: error, md_import_device() returned %ld\n",
+				PTR_ERR(nd.rdev));
+			nd.rdev = NULL;
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
 	/* q->limits_lock nests outside both, see md_start_sync() */
-	if ((md_ioctl_may_add_disk(cmd) || cmd == RUN_ARRAY) &&
+	if ((nd.stacks || cmd == HOT_REMOVE_DISK || cmd == RUN_ARRAY) &&
 	    !mddev_is_dm(mddev)) {
 		q = mddev->gendisk->queue;
 		lim = queue_limits_start_update(q);
@@ -8681,14 +8784,10 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 		 * So require mddev->pers and MD_DISK_SYNC.
 		 */
 		if (mddev->pers) {
-			mdu_disk_info_t info;
-			if (copy_from_user(&info, argp, sizeof(info)))
-				err = -EFAULT;
-			else if (!(info.state & (1<<MD_DISK_SYNC)))
+			if (!(info.state & (1<<MD_DISK_SYNC)))
 				/* Need to clear read-only for this */
 				break;
-			else
-				err = md_add_new_disk(mddev, &info, limp);
+			err = md_add_new_disk(mddev, &info, &nd, limp);
 			goto unlock;
 		}
 		break;
@@ -8721,14 +8820,8 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 
 	switch (cmd) {
 	case ADD_NEW_DISK:
-	{
-		mdu_disk_info_t info;
-		if (copy_from_user(&info, argp, sizeof(info)))
-			err = -EFAULT;
-		else
-			err = md_add_new_disk(mddev, &info, limp);
+		err = md_add_new_disk(mddev, &info, &nd, limp);
 		goto unlock;
-	}
 
 	case CLUSTERED_DISK_NACK:
 		if (mddev_is_clustered(mddev))
@@ -8738,7 +8831,7 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 		goto unlock;
 
 	case HOT_ADD_DISK:
-		err = hot_add_disk(mddev, new_decode_dev(arg));
+		err = hot_add_disk(mddev, &nd);
 		goto unlock;
 
 	case RUN_ARRAY:
@@ -8770,6 +8863,9 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 	}
 
 out:
+	/* a leg we opened but nothing took ownership of */
+	md_put_new_disk(&nd);
+
 	if (cmd == STOP_ARRAY_RO || (err && cmd == STOP_ARRAY))
 		clear_bit(MD_CLOSING, &mddev->flags);
 	return err;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 73f6ef20f266..73a27d83d65a 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1051,8 +1051,27 @@ struct mdu_disk_info_s;
 extern int mdp_major;
 void md_autostart_arrays(int part);
 int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
+/*
+ * A leg opened before the array was locked, with the mddev fields that
+ * selected the branch and the superblock format.  Opening takes
+ * disk->open_mutex, which must not nest inside reconfig_mutex; the fields
+ * are read unlocked and md_add_new_disk() rechecks them.
+ */
+struct md_new_disk {
+	struct md_rdev *rdev;
+	bool stacks;		/* the add can reach ->hot_add_disk() */
+	bool have_pers;
+	bool have_raid_disks;
+	int persistent;
+	int major_version;
+	int minor_version;
+};
+
+int md_import_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
+		       struct md_new_disk *nd);
+void md_put_new_disk(struct md_new_disk *nd);
 int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
-		    struct queue_limits *lim);
+		    struct md_new_disk *nd, struct queue_limits *lim);
 int do_md_run(struct mddev *mddev, struct queue_limits *lim);
 #define MDDEV_STACK_INTEGRITY	(1u << 0)
 int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
-- 
2.43.0

