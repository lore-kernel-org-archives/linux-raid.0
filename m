Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596EF42A160
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783689816; cv=none; b=VAQIKYhekhmb5GD+3A45docl2h+uzVsUEeRtPRfeF5F391uk2S8JPzwxEnQh5hwGn+q3+QKxP0cVX1nYOlh3LM/slvC2zD3zWSLRc0ryTGMjHs7MPF88FU9D2Fp2W1bvAhrcdHixNfP3PeqH7N3gPXmT7i3vEXJLinK6nQAnHyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783689816; c=relaxed/simple;
	bh=xEqm1sE+jecmYRzxFL0kVtctc8RRLUIkKaR4sm4M9+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qirwo85fj9uWY9T4ysvF4m2YHhrzcGfoG+pkLHAuiRxrF2m6Z5C0OvtgCD1ThLtgBZmol0RncNeav4/5+S9mHdZoBSgscHHuTn5o1aGZH8FCAvhaJPDW9w1cwYFQBDeckhMdmjABT4APX3xavO6DOMhL0EFlCbhEuOMbsAYveaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lI6vKF10; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lI6vKF10"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-384c94c9414so943652a91.3
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 06:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783689815; x=1784294615; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cf1/ee0X2dG0osYkEkKZ86BVwwMjnHRyKzh5WNrSIzY=;
        b=lI6vKF101EPCYucEQSgKErDVmTEL25myfv4z9bZnhQE8Tdnrrodbzs/LfCu+FmYkOs
         MRNo6EUMeFLrYfQr+mHa8AHsYWnrOw3D5xpdHfFq3jYHVFU3y4Nk9TbGTUUXHRksg7uJ
         XHfZnnTT9lgKUAOHrY8u05VTK6kj9c64BtFhmlzrTO0/6yhwYn5G1FxCKqJFQg8CkJmE
         n2z7jnNx0KwBbljVCecSgiXmythBe0LYN1IJ3wa2AweW2rqLtmgKnXXLH5Psftn/7x86
         o10ltw0Czmb/hoMlR/kunQ9zHuTTA2rFkg9kxie2IWOGh3zp4Jr24YnQLrm1TWt20zXS
         /e3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783689815; x=1784294615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cf1/ee0X2dG0osYkEkKZ86BVwwMjnHRyKzh5WNrSIzY=;
        b=j5GEg86XnaWCxxCdKCTxfOGxVc0ZD3c6bOzj8j4Y14MYp0lrG2noB4DMkopIkgqzOf
         HaoJPyGNDk4RdoyrsFCLvJUj1FkHV6TfiyzNJJwrqKnoifIogI74f+fUlu2TR4SFtv5q
         C3KDuZF2Aufnmh/7+asdy97lYaThx50zrSnOQgRCiGv2tNrgtvHl/k1Loch4QgELrvMS
         rD8QTuoQTTre188a4eypBHz6mXv5lbItwYZ3lsMi2Ve4XzGpkyxExQt+L3tyaKDBKRuO
         dyv1AGu5e4KJF0BkmmhP8ea7aRbMQDz/5HNSCXJdoyNgh9ZzGLmMZPmmTB/bv+yWJT6c
         LtrQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp0kk/gWP+FwcQlR7HJ4+n20i2zRvajkf9bF2AhcnGd2n9+6IjNGIXRp6d1ulhprzkDqocYBNladaJy@vger.kernel.org
X-Gm-Message-State: AOJu0YwMGGTRGEUv6Y9ATx8A+LoNr554TtDFu0FeIPd82rFGShBEvVxB
	CSDe2vf/HTeT8j2NqpHAvkbXDLEd3aj3+qJDQjoaUQLcJYN34DUipnTJ
X-Gm-Gg: AfdE7cmx4dDaAWPrY/n2jIKsyDlmmHrULS5mfUxFKr+CLbGpDDahhMvQgin4Ossf7kL
	ku1bW2thps/NZ+xDGJyx10Rv2qQUtSbcwN70PR6F5LNWSzLs6oXokTh2frtwVprXcUCURrPeGZy
	kehjF95b1B8+3L4jhsnKfix9k+NViLD67i/WvktPzXpFljn5dH2+zhOlInTh6GtIpGxMZVjiF2v
	S2Ev7tUmEVA8BwxtG2g81+E0JWxBFUwVE5IqA+2cSNQHLob5SJ6ktc+Zl4gyHvwrfDVk+Am2Dja
	AOeLV8LERlLlDGppDlDklimyJs9N3IwpgS42u3La2IG99xR+sYSt4Spos+XW94+IkdCK8pA5oLJ
	Gf/YOH2EBbnA0I6WCzK7PUNQ3HA731se8aiJy/mjcT/dq0rHRHU7S6RG27G8k34GVOtthCHsa5p
	/5JozZj2bt9WhKwwLcbujq5WwcHt+Lz2mMfWQy9FolMqLiaIkq9pEyb85iMinlbF7u6auraJ4qI
	vCMSlw=
X-Received: by 2002:a17:90a:e70d:b0:37f:9ce1:7360 with SMTP id 98e67ed59e1d1-38941fb72e4mr10844548a91.33.1783689814475;
        Fri, 10 Jul 2026 06:23:34 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38a55b413e6sm2710798a91.8.2026.07.10.06.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 06:23:34 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 1/2] md: change chunk_sectors and stripe cache counts to unsigned int
Date: Fri, 10 Jul 2026 06:23:28 -0700
Message-ID: <20260710132329.7273-2-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710132329.7273-1-nishidafmly@gmail.com>
References: <20260710132329.7273-1-nishidafmly@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

chunk_sectors, new_chunk_sectors, prev_chunk_sectors, max_nr_stripes,
and min_nr_stripes are never negative. Using signed int is semantically
wrong and prevents the compiler from optimizing division/modulo by
power-of-two chunk sizes to right shifts in the hot I/O path.

Change all struct fields and derived local variables to unsigned int:
  mddev->chunk_sectors
  mddev->new_chunk_sectors
  r5conf->chunk_sectors
  r5conf->prev_chunk_sectors
  r5conf->max_nr_stripes
  r5conf->min_nr_stripes
  Local: sectors_per_chunk, new_chunk, chunk_sectors

The min() in r5c_check_cached_full_stripe() required both operands to
match signedness; this is now satisfied with max_nr_stripes unsigned.

Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/md.h    |  4 ++--
 drivers/md/raid5.c | 14 +++++++-------
 drivers/md/raid5.h |  8 ++++----
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index d8daf0f75cbb..b9ad26844799 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -437,7 +437,7 @@ struct mddev {
 	int				external;	/* metadata is
 							 * managed externally */
 	char				metadata_type[17]; /* externally set*/
-	int				chunk_sectors;
+	unsigned int			chunk_sectors;
 	time64_t			ctime, utime;
 	int				level, layout;
 	char				clevel[16];
@@ -466,7 +466,7 @@ struct mddev {
 	 */
 	sector_t			reshape_position;
 	int				delta_disks, new_level, new_layout;
-	int				new_chunk_sectors;
+	unsigned int			new_chunk_sectors;
 	int				reshape_backwards;
 
 	struct md_thread __rcu		*thread;	/* management thread */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0c5c9fb0606e..28828e083c2b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2970,7 +2970,7 @@ sector_t raid5_compute_sector(struct r5conf *conf, sector_t r_sector,
 	sector_t new_sector;
 	int algorithm = previous ? conf->prev_algo
 				 : conf->algorithm;
-	int sectors_per_chunk = previous ? conf->prev_chunk_sectors
+	unsigned int sectors_per_chunk = previous ? conf->prev_chunk_sectors
 					 : conf->chunk_sectors;
 	int raid_disks = previous ? conf->previous_raid_disks
 				  : conf->raid_disks;
@@ -3166,7 +3166,7 @@ sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous)
 	int raid_disks = sh->disks;
 	int data_disks = raid_disks - conf->max_degraded;
 	sector_t new_sector = sh->sector, check;
-	int sectors_per_chunk = previous ? conf->prev_chunk_sectors
+	unsigned int sectors_per_chunk = previous ? conf->prev_chunk_sectors
 					 : conf->chunk_sectors;
 	int algorithm = previous ? conf->prev_algo
 				 : conf->algorithm;
@@ -3584,7 +3584,7 @@ static void end_reshape(struct r5conf *conf);
 static void stripe_set_idx(sector_t stripe, struct r5conf *conf, int previous,
 			    struct stripe_head *sh)
 {
-	int sectors_per_chunk =
+	unsigned int sectors_per_chunk =
 		previous ? conf->prev_chunk_sectors : conf->chunk_sectors;
 	int dd_idx;
 	int chunk_offset = sector_div(stripe, sectors_per_chunk);
@@ -6103,7 +6103,7 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
 static sector_t raid5_bio_lowest_chunk_sector(struct r5conf *conf,
 					      struct bio *bi)
 {
-	int sectors_per_chunk = conf->chunk_sectors;
+	unsigned int sectors_per_chunk = conf->chunk_sectors;
 	int raid_disks = conf->raid_disks;
 	int dd_idx;
 	struct stripe_head sh;
@@ -7930,7 +7930,7 @@ static int raid5_run(struct mddev *mddev)
 		sector_t here_new, here_old;
 		int old_disks;
 		int max_degraded = (mddev->level == 6 ? 2 : 1);
-		int chunk_sectors;
+		unsigned int chunk_sectors;
 		int new_data_disks;
 
 		if (journal_dev) {
@@ -8832,7 +8832,7 @@ static int raid5_check_reshape(struct mddev *mddev)
 	 * to be used by a reshape pass.
 	 */
 	struct r5conf *conf = mddev->private;
-	int new_chunk = mddev->new_chunk_sectors;
+	unsigned int new_chunk = mddev->new_chunk_sectors;
 
 	if (mddev->new_layout >= 0 && !algorithm_valid_raid5(mddev->new_layout))
 		return -EINVAL;
@@ -8866,7 +8866,7 @@ static int raid5_check_reshape(struct mddev *mddev)
 
 static int raid6_check_reshape(struct mddev *mddev)
 {
-	int new_chunk = mddev->new_chunk_sectors;
+	unsigned int new_chunk = mddev->new_chunk_sectors;
 
 	if (mddev->new_layout >= 0 && !algorithm_valid_raid6(mddev->new_layout))
 		return -EINVAL;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index cb5feae04db2..5cd9d0f36b6e 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -572,12 +572,12 @@ struct r5conf {
 	/* only protect corresponding hash list and inactive_list */
 	spinlock_t		hash_locks[NR_STRIPE_HASH_LOCKS];
 	struct mddev		*mddev;
-	int			chunk_sectors;
+	unsigned int		chunk_sectors;
 	int			level, algorithm, rmw_level;
 	int			max_degraded;
 	int			raid_disks;
-	int			max_nr_stripes;
-	int			min_nr_stripes;
+	unsigned int		max_nr_stripes;
+	unsigned int		min_nr_stripes;
 #if PAGE_SIZE != DEFAULT_STRIPE_SIZE
 	unsigned long	stripe_size;
 	unsigned int	stripe_shift;
@@ -595,7 +595,7 @@ struct r5conf {
 	 */
 	sector_t		reshape_safe;
 	int			previous_raid_disks;
-	int			prev_chunk_sectors;
+	unsigned int		prev_chunk_sectors;
 	int			prev_algo;
 	short			generation; /* increments with every reshape */
 	seqcount_spinlock_t	gen_lock;	/* lock against generation changes */
-- 
2.43.0

