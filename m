Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17453DB32A
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 15:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316509; cv=none; b=FBqjA8xGtTIrVyYnYKJyNJlNMspgpSxI6DAz531bLf2qcJs4fwbA1lK6qF6TSJlZA3yrpIJs2nff+QjD7kwivNA+ATp8X98q/3rTyDLS19yKjygDWxGIema2Zp8zcPzoMg5iumXVLNpXz650U+p15sxCSQIMlEbzugywmp/r9a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316509; c=relaxed/simple;
	bh=YS8xDKdOGZugVWx7X76/CxgsVfUOkjyBKsYOh0rttjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOnvbEb9c/sIvCqO7ZMpNzD53+bAYPeKjahk3kmEmf/IlMdW84R0yKcuLfzxGygBU2DMcE5x9WnXojTBfY6XzVEvHEJk40uxk7tJalb5ut/RfR6tAV3LLVpTFlz/bb+GkhKJwd2G2qy8BTEcYejtibYwTwVgakPAMwOYveYvWoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZLwGz6Q1; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZLwGz6Q1"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8424b00710aso938954b3a.0
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 08:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782316507; x=1782921307; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=06JlYwWjWSJ0BndL7HkVgC/xsphP8YEMCJ+nGwTMvD4=;
        b=ZLwGz6Q1TUCRWa9E4kG+Hkf4YOxQLupSdVrraWIFj1xviCCp61YJxk59IblCmKUKyP
         DL3M8iUrS0l7bSGeXZ0Qfj7ogE96Jq6sw7eM1AUXSJ2rcpOdK1MdWLcFT5yOaseIWBHw
         ibDZDzlptJLkq5yhuiyJqJ8GHDCkeFuK1idNYt3seD/pNUhFx/2xR9QYDUmGqlFyXvTd
         5BuLsw2v8k/sfq/ZdBmKYtunHcWm+jkcKmBqgz8cs24PQZV/zTQh5AFF5kdOER0qZSha
         YK0JFsfEWvKFgmJGcjvBpbLGWKmJQrwyc18iEfCaeppltzTVsL00RnOOfgZEdsUHL49P
         MB2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782316507; x=1782921307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=06JlYwWjWSJ0BndL7HkVgC/xsphP8YEMCJ+nGwTMvD4=;
        b=JxxU5YUSwJxwhwXD4bRYD+0WTZ0ExxqpgIxr6uZiq2BUL9JZxm3aeN4ZiqWOBtS+vq
         0OVdNvnVxH3gwG4dqfDjqTjuoI6fFeTqfafnX6w079OAAqmRpexi+m2aC/hAh2bft6YT
         gAuIIY8JJG/rB81qFhuG/1q/S/cCY+qEM66bj7mjRpCyqtABz+naMUAmAOrv2bj3kkA8
         egTx1YHptHddV5vBI2aoGIj11GscB0Ymap+JKJDal1f9Aw9kRt4Amzo2jtJbSmj63cnx
         v+1DIblb2go+L85Po1Oy77Qhc8V4i5lSDoxHGVjY5nDzfnVnGbJtyS2Y5Tclyw8Bzrz8
         +b4A==
X-Forwarded-Encrypted: i=1; AFNElJ8pA8otrD1srGae+oVu2jujbDWetQMLXQefaf1ZlartnI/AhHuP/alB3RCcmDx4Usk0eHjMEJG/Nt3M@vger.kernel.org
X-Gm-Message-State: AOJu0YxG2QAtkw/NHPhI+eeL4dFd12enk4EDtmxxrVO21EJ0QdAiBSB/
	/URxpdLgyIlFVAM7pLo1Piwn+qZqPsEgaqQci5znr/2XmINcWndIwepK
X-Gm-Gg: AfdE7cnMFUnGW/33VT7ceHph+rxzG8XhiBBXjd0rVUR1tIn4iY3BBguLPQAYPbx0oPa
	xfzNVq6GfXdzliqfOwQRmUmGFkbwebjV5pzlYFTxiQJ5b/GNaKac3uu0pfhXcadl0kfnmn3qASW
	rIISdj9pan8p9Z3urIPnivuEL1G9hkJgYgF0ZIi24oyznTqeKqJXKZmSzAGE5f/eZq4gFwLv6XY
	eJoYOOBtcYXY5B4w+svpRL92t+JSnIsBW7hOOCC7zXFDgMSlml/RzNyQNA4ys1rSLcGLV7+Ij/r
	g5eJztDMWcL/VR08RZQiqBo2zeDqfZIg2yfERAXpleEw36HRh1TWZPXMwQ6KdLXm++w8tOaDMvj
	L9W1ixr1QLkQczFAJpsVO0jfGNSTplH/taNvjs2TNoDPPziKTk4pjkn+oZgR9C75f1ieu0a+MAs
	giCjj61ENFAXt3B5mtQjyBXApaFO7r0ILx90yQ/xQlDkF7ibG4YnglJ2R4tBURL4kwnz4CUT2ff
	SRD5/g=
X-Received: by 2002:a05:6a00:430e:b0:845:3d4b:8f8a with SMTP id d2e1a72fcca58-845a2cad1aemr5297125b3a.35.1782316507235;
        Wed, 24 Jun 2026 08:55:07 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a40f55cesm2658387b3a.44.2026.06.24.08.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 08:55:07 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 1/8] md: change chunk_sectors and stripe cache counts to unsigned int
Date: Wed, 24 Jun 2026 08:54:45 -0700
Message-ID: <20260624155452.211646-2-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260624155452.211646-1-nishidafmly@gmail.com>
References: <20260624155452.211646-1-nishidafmly@gmail.com>
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

Assisted-by: Claude:claude-opus-4-8 [Claude Code]
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

