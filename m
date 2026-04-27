Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EC330DD3C
	for <linux-raid@vger.kernel.org>; Mon, 27 Apr 2026 10:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777286094; cv=none; b=nFwpNI/lgiNJz7onyVLzpAT+HXy8ETTP8xDJKleoZRgZ9FUzJV1QrIJUV3sd+hdMxE6D02bqKCuPC3idqNTvSmVVNBNRdzA5NLD+CNkV5sMQbLSs1/y6pADaxqb6Zgzp7xUSVIRysGUPQ/xy06asTGAdMBLm6Afommt3mIb/+LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777286094; c=relaxed/simple;
	bh=k1i609xj9ohhIhCKIQmofuwEJyI090DoKIu/CzIHhWs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QeEGEuwwYxaLM+80KF9AxZ2ABly+x8KGEoPTsAizYDhoLvVgQSzCZdUWWmdx0OCTBd+f+/O7u0I3Ags0RSml4pgkfYHxu3ABqlFGBpikj+JxWJYgJbUeS9gL+x8RNpizt5RlbPwaBibVft9sFt7OHiFvk+6/IYv4ySyq3vfLXb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UMS3nrVd; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UMS3nrVd"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4891b0786beso71721595e9.1
        for <linux-raid@vger.kernel.org>; Mon, 27 Apr 2026 03:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777286090; x=1777890890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=c7AY+72TzzzpNCiwKXSGr1RbYy7YM87b7p1cJKp7RRY=;
        b=UMS3nrVdImbS8T6wl5uRxrqDTI6v6TxxstKssozENk0BfSp8UtXT8Fh7NagmtTgslD
         8fXKX5Sp4wK/C6w3rbQ3SWwbLG9uIAqHvDtE31DjQctBDdB2I06buJrWNLZbFtAv4wzJ
         kZgFYedirbvu5JIcN2h8TmK/eJ4SU7fFYdmeFWxP8OHaCc44n0N9dtq5Jqm5P/WZTOr5
         oUDxw9f7pyfD9wZIe3X3RBnefnRimLSKdGF43HU2TnPMowXNvl0ezhFqkbX5hzXK7h8n
         ECX8AqDZO7HwHVI2LmF9sddRwPXQ2mX4WfP0kSOvYJBcbcEVLq+T545NwSMP4Op/NtZd
         SiMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777286090; x=1777890890;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c7AY+72TzzzpNCiwKXSGr1RbYy7YM87b7p1cJKp7RRY=;
        b=qsIBYqAdPVDCSoEPK6QqpbLMfsDwblHyk3D2FyW9N1SOw8pS+o/UHqh+77iKXyCmok
         cbVMGf3T5efMC6E6r1HTrc0nn7gRKomq8dcXOYMe2h0EbUkFShlfeeXfRAD4yUazu7Xo
         zg9VHsCQ309UD4JCTB7gOPpz15PE57XjyjgE04MD6jA6Y0/SL9xc/TVdzyd5LnRF6+eC
         oKy1iPbTjPfREv92U5VKxNjenbCygu32D052hF/7qjkHyP2ZnCpxpcf8NKaDaxW2hdyu
         5+3DjvzxGuxageE111BKJUyrICRIJM7z5kDCqT86fWDZQ/dICcw6PTBcnyjBVFDALP8Y
         ltGA==
X-Forwarded-Encrypted: i=1; AFNElJ+qYKCWHeGIpCUq3RFcV34/rCTZmXDv+eluMMzzhFQLMujFx79x1KDonz0lqX0PgIYW3wY958DbCsFY@vger.kernel.org
X-Gm-Message-State: AOJu0YzuPIy1KNVeWULYSSRHUhFNtyCgyGrVAXWg4kfQ6ktSazohO0hq
	kENzfMNzIiiEK3YbQDB07sGR8rWs5nqoPq37GFykPpaVsQjtuX76qS+wT3WcPA==
X-Gm-Gg: AeBDiet5/EW/7qd9lxd9HzKOLamKrB7vJ7c3zinugbOVJXHaoOZ0SehVyTHsjA41ZmT
	V+GEB+a5LEQq/NpFY4oVvWwb2YW9DtvcEmPKyFHWyFV1dG31+Q/7KCvHvLnHURYm7rpyUEcHXDN
	+qlQbycV5t/FqejpZS58mHEHNxA3VjNknPpmh91uzV5/rXV8joJG1pTWhrJc+fb+7syIWl5Ec/0
	MSQCYiQFYYcF6OxPe/m42fVbamwcl9S1P+ngidTuuhPr9XXO6aoEsFx8ksEPgOKBmtI3LkC0FfR
	psiu+3ke0oHWNsDHydfYO4reyoQsgD8k+DVkZGyIl8Ue0Cwsr26OCROWZE4P1OrNUIBgWB75fjp
	eFwrnRGPtMasQbfhHoLWfC5hOMTfE7shwywpEYVGK4+AFNIR7s4b/E8fzPXyeIP0BGHMJV58sjf
	/c7sKN5pTTHpD71EMqa4fT3Dvwgi5Q3bKMPaxbD+cyea7x
X-Received: by 2002:a05:600c:c4a1:b0:488:c014:34da with SMTP id 5b1f17b1804b1-488fb77ed1bmr576460915e9.26.1777286090132;
        Mon, 27 Apr 2026 03:34:50 -0700 (PDT)
Received: from yocto.. ([2a02:3037:61f:b195:81a0:60b2:15ab:dac9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a52583fe7sm455383905e9.13.2026.04.27.03.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 03:34:49 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com,
	shli@fb.com,
	neilb@suse.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH] md/raid1: fix bio splitting in raid1 thread to avoid recursion and deadlock
Date: Mon, 27 Apr 2026 12:34:46 +0200
Message-ID: <20260427103446.300378-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Splitting a bio while executing in the raid1 thread can lead to
recursion, as task->bio_list is NULL in this context.

In addition, resubmitting an md_cloned_bio after splitting may lead to
a deadlock if the array is suspended before the md driver calls
percpu_ref_tryget_live(&mddev->active_io) on it's path to
pers->make_request().

Avoid splitting the bio in this context and require that it is either
read in full or not at all.

This prevents recursion and avoids potential deadlocks during array
suspension.

Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
I sent an email about this issue two days ago, but at the time I was not
sure whether it was a real problem or a misunderstanding on my part.

After further analysis, it appears that this issue can occur.

Apologies for the earlier confusion, and thank you for your time.

Abd-Alrhman
---
 drivers/md/raid1.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cc9914bd15c1..14f6d6625811 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -607,7 +607,7 @@ static int choose_first_rdev(struct r1conf *conf, struct r1bio *r1_bio,
 
 		/* choose the first disk even if it has some bad blocks. */
 		read_len = raid1_check_read_range(rdev, this_sector, &len);
-		if (read_len > 0) {
+		if (read_len > 0 && (!*max_sectors || read_len == r1_bio->sectors)) {
 			update_read_sectors(conf, disk, this_sector, read_len);
 			*max_sectors = read_len;
 			return disk;
@@ -704,8 +704,13 @@ static int choose_slow_rdev(struct r1conf *conf, struct r1bio *r1_bio,
 	}
 
 	if (bb_disk != -1) {
-		*max_sectors = bb_read_len;
-		update_read_sectors(conf, bb_disk, this_sector, bb_read_len);
+		if (!*max_sectors || bb_read_len == r1_bio->sectors) {
+			*max_sectors = bb_read_len;
+			update_read_sectors(conf, bb_disk, this_sector,
+					    bb_read_len);
+		} else {
+			bb_disk = -1;
+		}
 	}
 
 	return bb_disk;
@@ -852,8 +857,9 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
  * disks and disks with bad blocks for now. Only pay attention to key disk
  * choice.
  *
- * 3) If we've made it this far, now look for disks with bad blocks and choose
- * the one with most number of sectors.
+ * 3) If we've made it this far and *max_sectors is 0 (i.e., we are tolerant
+ * of bad blocks), look for disks with bad blocks and choose the one with
+ * the most sectors.
  *
  * 4) If we are all the way at the end, we have no choice but to use a disk even
  * if it is write mostly.
@@ -882,11 +888,13 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio,
 	/*
 	 * If we are here it means we didn't find a perfectly good disk so
 	 * now spend a bit more time trying to find one with the most good
-	 * sectors.
+	 * sectors. but only if we are tolerant of bad blocks.
 	 */
-	disk = choose_bb_rdev(conf, r1_bio, max_sectors);
-	if (disk >= 0)
-		return disk;
+	if (!*max_sectors) {
+		disk = choose_bb_rdev(conf, r1_bio, max_sectors);
+		if (disk >= 0)
+			return disk;
+	}
 
 	return choose_slow_rdev(conf, r1_bio, max_sectors);
 }
@@ -1346,7 +1354,14 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	/*
 	 * make_request() can abort the operation when read-ahead is being
 	 * used and no empty request is available.
+	 *
+	 * If we allow splitting the bio while executing in the raid1 thread,
+	 * we may end up recursing (current->bio_list is NULL), and we might
+	 * also deadlock if we try to suspend the array, since we are
+	 * resubmitting an md_cloned_bio. Therefore, we must be read either
+	 * all the sectors or none.
 	 */
+	max_sectors = r1bio_existed;
 	rdisk = read_balance(conf, r1_bio, &max_sectors);
 	if (rdisk < 0) {
 		/* couldn't find anywhere to read from */
-- 
2.43.0

