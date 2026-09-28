Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7353B4F85B2
	for <linux-raid@vger.kernel.org>; Mon, 28 Sep 2026 20:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626379; cv=none; b=pLvfcUOSoHbm7xJMmLXJPsd80O0vZuN5ZPUfUq4PQjR0urhGSJ6Z7FiRAe9Tf/7iJj+8gCRYXbvaH2kFFN43YqaT/TWz+Ez0r8s1cXnZxVSnZqUc8g3ZsVciHmtO0PT+t4rKejKC1+SyEVq0awgXBrmcYDEsbKUeScBEFzzRtt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626379; c=relaxed/simple;
	bh=hkFas3mZaox8RRokWKn/qKR6LDkDCnnmsggr842lS18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/+PfyjAkXL65dveCGmE7eFWRgCkojbY5eoLZag2qAigwGIiwc2Al8Y6cAbQBSRuyMUF+RRiJuZVZTJdT95IzG+EpWKUe4/PFXdmRJGeT+4It0qrzWSUlyMzgnIzkt7xk3PXA69g1KnaW/viqMPf3UGoxFQJ5TqPx4/7QeLjf50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WRGOlCyw; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WRGOlCyw"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e66390995so19408285e9.2
        for <linux-raid@vger.kernel.org>; Mon, 28 Sep 2026 13:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790626373; x=1791231173; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FHrR5kgcHvLjH9hD8wdXc7t8x0CJmGRPaHyyxceDiaM=;
        b=WRGOlCywfqX9s2nGO4sY0NlTuu61x22RvCACOKaO8LbMRIx2pOp7GfBNKu5m90KOKW
         20QPGEHbjKHNsaOl2vIgcyqZEmd/Fc/BUBqNNJPi7/YAf5nvsX0s/Y89T+r334uHa+fM
         S7aUpzzSEIvd36Y6n5LQ/t4cPOsPw/nLIdnRsS7pxJ9Em2g/BuVDk2xTB5ahas93qLA/
         V7qJq4f/jaj0h9IX7kEAIPMmNZZMICJ4AFpdrPx5oyn+Z+W7BiyRMZoNUvwLLHLAFwTn
         wQUdQM6qb51rZYyqkk5vKqeoFnXpWLlc4uNWdYvkjtrevddTzkvU0I+3OvNr8+uE6Ikk
         j4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790626373; x=1791231173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FHrR5kgcHvLjH9hD8wdXc7t8x0CJmGRPaHyyxceDiaM=;
        b=gsgZHwylCs3GspDGlikB1EY/zgrqCdU7DFd0if0yP4e+bcoB4Ypx56T4jCMi/XAYXc
         M1xEYObTGH7xELpE+GJqDoHr3N2SetJ9NJ5RZ1MkRU08HRiCVpsuTNoAzosz2DdYzkZP
         uoZwsSDAeUc+DaOnbOrEFURhr/v5AIj8pces2uP+HCbpvOPX7Z7V/mCameVlv+Iz8oo1
         H95SP2PL+DPFi2K4VP3ZxHKO1rrMDDIWqO7x8Ly7ewnqaGBBDmnaymVdYKqd1mv2/wPD
         VSwtHYnAMmEApr7/fHcyAV9bC960dIZf1jyPiuHEmKLUZBPrQ3vchgcTF7Zk6XrijISm
         JA4A==
X-Forwarded-Encrypted: i=1; AKwUvBxreLgfue0Nxwaj11Oprxkv2BI5NEI2NvaIEoU0AZh+rqgeeGFjSBqowhjfkTyxgkiebFNb6j9ItZCI@vger.kernel.org
X-Gm-Message-State: AFuF++m5U3Do0Pw9PHuQg4Ot7iMK9HeHY7yMi6JX77DNmXRBak2JomC6
	e85kE8yCVcbNQnMMPpfQ7YEfTiqaVUZBv/nf+LMVecykZHhWvGEScmND
X-Gm-Gg: AYBFou1UwYOnkYfkU8BGvvkIQJlo18M6Y3yRsTJL31XZfd8s4TcLur+IUJjCv358KcK
	iNVfLzlmkbnzFW/U80Hfc3POoFEQdeQxaaQXzqtcMH2YVbgUBkjt0va/jLF9OZgEv+DC9CXnBun
	KdFeGfrpvvpG2Hkrybj+W+4ve1jn0ryslDNKXP9zF7p+frZOFyc0iwcbxLwQQu6rzuvrLYVgq8x
	qB6hIs6KMMzedHRBSmNcuwcIBvFPHFLMov55ibDSoYXUblsUYndyFapAZy33bkdvwlf1OE+Zvxo
	MzFW3L2cJjJoBItYaUcEZO8HvKotXoA2TXTASL+R+rnnTPF5acjW2mpHMSmspPdMRCpYEd3Bwk1
	aCb6W7GXMX0hbg8lfpqqYqB7uZdhi6NSccD3gcTP6Euhld+GF2hrSL5BPEviRr09kLJKZcgCI6+
	eZIhIHOXSf1PA2+2dqQHVjSzQWKILjakcbFKqVRMSdHi0A07LUEPk+8SiYU/V38wyIWa+9Q8AcM
	XyScI7B8vhV9lXpokY9odOxu4tXewj3DhcoqjgPrrhBncuZ3nbVuh/QNw==
X-Received: by 2002:a05:600c:3550:b0:49f:fd40:80fa with SMTP id 5b1f17b1804b1-49ffd408357mr111818575e9.34.1790626373146;
        Mon, 28 Sep 2026 13:12:53 -0700 (PDT)
Received: from env.. (dynamic-176-003-100-011.176.3.pool.telefonica.de. [176.3.100.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00c11a9d2sm30457755e9.3.2026.09.28.13.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 13:12:52 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	chengzhihao1@huawei.com,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	arnd@arndb.de,
	gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH 1/2] md: make mddev lookup and ioctl helpers non-static
Date: Mon, 28 Sep 2026 20:12:23 +0000
Message-ID: <20260928201224.3602262-2-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260928201224.3602262-1-abd.masalkhi@gmail.com>
References: <20260928201224.3602262-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A following patch adds an md misc control device, so that arrays can
be managed without opening the md block device. Its code lives in a
separate file and needs to look up arrays and reuse existing ioctl
helpers.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/md.c | 10 +++++-----
 drivers/md/md.h |  5 +++++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..b5027d65c6d8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -364,8 +364,8 @@ EXPORT_SYMBOL_GPL(md_new_event);
  * Enables to iterate over all existing md arrays
  * all_mddevs_lock protects this list.
  */
-static LIST_HEAD(all_mddevs);
-static DEFINE_SPINLOCK(all_mddevs_lock);
+LIST_HEAD(all_mddevs);
+DEFINE_SPINLOCK(all_mddevs_lock);
 
 static bool is_md_suspended(struct mddev *mddev)
 {
@@ -623,7 +623,7 @@ bool md_flush_request(struct mddev *mddev, struct bio *bio)
 }
 EXPORT_SYMBOL(md_flush_request);
 
-static inline struct mddev *mddev_get(struct mddev *mddev)
+struct mddev *mddev_get(struct mddev *mddev)
 {
 	lockdep_assert_held(&all_mddevs_lock);
 
@@ -8101,7 +8101,7 @@ static void put_cluster_ops(struct mddev *mddev)
  * Any differences that cannot be handled will cause an error.
  * Normally, only one change can be managed at a time.
  */
-static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
+int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 {
 	int rv = 0;
 	int cnt = 0;
@@ -8227,7 +8227,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 	return rv;
 }
 
-static int set_disk_faulty(struct mddev *mddev, dev_t dev)
+int set_disk_faulty(struct mddev *mddev, dev_t dev)
 {
 	struct md_rdev *rdev;
 	int err = 0;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b6d2e8929a0f..cb8760521764 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -953,6 +953,7 @@ extern int mddev_init(struct mddev *mddev);
 extern void mddev_destroy(struct mddev *mddev);
 void md_init_stacking_limits(struct queue_limits *lim);
 struct mddev *md_alloc(dev_t dev, char *name);
+extern struct mddev *mddev_get(struct mddev *mddev);
 void mddev_put(struct mddev *mddev);
 extern int md_run(struct mddev *mddev);
 extern int md_start(struct mddev *mddev);
@@ -974,6 +975,10 @@ extern void mddev_destroy_serial_pool(struct mddev *mddev,
 				      struct md_rdev *rdev);
 struct md_rdev *md_find_rdev_nr_rcu(struct mddev *mddev, int nr);
 struct md_rdev *md_find_rdev_rcu(struct mddev *mddev, dev_t dev);
+int update_array_info(struct mddev *mddev, mdu_array_info_t *info);
+
+extern struct list_head all_mddevs;
+extern spinlock_t all_mddevs_lock;
 
 static inline bool is_rdev_broken(struct md_rdev *rdev)
 {
-- 
2.43.0

