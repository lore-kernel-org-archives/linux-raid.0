Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248B139D6D9
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 14:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784472173; cv=none; b=UluGndVEu858b1xC9DpGSxFFrAbWnBDrI7ShjOVBjJj3SIpLoIa+6KYYhLljaRMK3cJtetENhwl2WkBWDQ674iGumAdfa6CiSP/bKwEFRiNNA0w0x9deMzyvK7QB4IhZNsK2yZCRlNpd/jAPb4dhywG2YgbjJHLTQ3OIkCIaeRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784472173; c=relaxed/simple;
	bh=o8yK1BIABrv2zPcdOZVgFZY711CWX+q3hnyZiP1Aeyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uu3AFGAI8DF6IVZUjxgS7wYBxab21YtPFw9EJeICdaaidA/pbVjm2K36k04p+CzPm9SwJsemlMvtixVweywlKPWVbVRnV/W30qNEOVg2BmzLCr0SK1fkYtvy99V/XDLvV3KiVAK587cFCcue/mJGFGOTXjqLruPsjx0BdtN/9Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=pNjDvta3; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="pNjDvta3"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47ddf7b09e5so5459434f8f.1
        for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 07:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784472170; x=1785076970; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ifPOK1LZi5TyJ6an+wjdH7bzo7jEagkKF5FxRxrk+U0=;
        b=pNjDvta3t30cRWwCH0EAewj9snn0+b6xF8Pj9AMfhDD7SaxDbNpjXEDH3t27jx+S8Q
         yfMuq6dixz4Vax8feZ5mgxrYcy5qHHr5BSNLQDVsg7z8K2YixVwGzKBmXxEC/HDllS4K
         99mVxf+u2CrTD8tcoPu5RgGtejDyV/Rny2E/MoWgb5Dh706yXBc2bGvBcG/4HHiCOchp
         htt3XdEPFM8KfccR4yDALd65JeNnqZLUqS4NZuw+h3ZMRbzzdZqwwBElbetvEAFPVIA1
         cp9Xj/wn2qs6KUmjHRwz4UWFKx+J4CHO0fh3anUq7Sz7OXrfQ8JpEmcRJPKg/+fMBkrZ
         x89A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784472170; x=1785076970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ifPOK1LZi5TyJ6an+wjdH7bzo7jEagkKF5FxRxrk+U0=;
        b=JDJ8+nNQlqQw7Af3iQTQJfwIhkw10pa9Z+ujGKw8bktaWSJCASPJB5reoF/sDXNedI
         NKmMNZAafDEArH3UbyC1W64eMxTzTFLSbLUhdxAiDp09Qu9Z4MleS6eOu27wT9aYva63
         yStBzLVricIcIjK53ZnsYRu9RJht61WhC5PRWTXcn1N5MICFnhGlyKRA0/dJDJidQFsl
         wQocbLwWyc9IhBPf5NidFMMZ2jEm4qSW6eCNK0JtSJZgc/VpPuBaniXxsKQqQyHWr5wG
         C5Ylvlg6C+MMZtFTDbRHt73szehR2lGijSagC9SuFGi1xDcdgHn4CgtZ+fst8oY9JA99
         h3DA==
X-Forwarded-Encrypted: i=1; AHgh+RoZhhCwQ24j6qU7ueLlbnhEh4zZ5cJLX5mJJ+rGQP6rx1k+MksL7iKHcYP3ayII9mUOA84nPT17BfwU@vger.kernel.org
X-Gm-Message-State: AOJu0YxIFJIdDCnNC6lJLmnahWGXc14yhGODsDCJ/AqeL4ZjqEX1WBYs
	6rLj/FCnt8q+vizT5j3870BBtYJbeyNI34cF1+N2A2CK3tvVW6fUpwodFtQO7J/r5Q==
X-Gm-Gg: AfdE7ck1Zh1EzBdkAobTngLY/ZJuucSARDkAa6hIu8ss/4aC3P2W9J83p0J5PvBZ2JR
	WJ5STqsjnJo+5/T8girYVyqXIEHNTEaUOB09FYbQN4clxLBO5SgDSzDj+N3Ljf+K47+2fPEUkIM
	22Gd+P9N6TgMprvT7xUTBLeAIuBTyXq/okZUIvJgRAKt2eeqPaz2h4D/TmRz7NXnzHgvqY/n2Z6
	dWn5vMC0rM+PsGLqFLDHvurpDt3ZZ/aSNzl6BZh5AgT2IguvYOoCY0gOQ6f4hc378wctcM7ZAQB
	dSSpQ7atOLCjeT1U5P64GcE1MR3YnbHwOjzOxN/L200amz+GZx+Mt/vYGdj6JvnJPRfkRorum7A
	9esdNCqowb4oEYrycv+Vqf0DQyonnrGwIb1stetL0O38g/2WF1grFnkrfXgXdtA==
X-Received: by 2002:a5d:5885:0:b0:46e:1815:6a83 with SMTP id ffacd0b85a97d-47f62318f12mr11444557f8f.29.1784472170320;
        Sun, 19 Jul 2026 07:42:50 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63ec7c69sm22668895f8f.17.2026.07.19.07.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 07:42:49 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] md: only consult skip_sync_blocks when 'j' is in the bitmap's domain
Date: Sun, 19 Jul 2026 14:42:26 +0000
Message-ID: <20260719144227.940444-3-mykola@meshstor.io>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260719144227.940444-1-mykola@meshstor.io>
References: <20260719144227.940444-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rebuilding a raid10 member with llbitmap can complete in a few
hundred milliseconds having copied nothing: md_do_sync() offers
every position 'j' to bitmap_ops->skip_sync_blocks(), the bitmap
answers for the wrong chunks, the whole rebuild is skipped as
"unwritten", and the array reports optimal with a stale member.  The
staleness is typically noticed only when the mirror partner fails;
writes made while the array was degraded vanish.

The bitmap spans [0, resync_max_sectors) in the personality's
sync-cursor space.  Resync walks exactly that range for every
personality and may always consult the bitmap.  Recovery walks
per-device offsets, which match the bitmap's space only for raid1
(device space is array space) and raid456 (the bitmap is indexed by
the per-device sync cursor; bitmap_sector() translates array IO
into it).  raid10's bitmap is in array space -- near-2 on four
disks spans twice a member's size; far-2 on two disks puts array
chunk 2c+d at device chunk c of disk d -- so
llbitmap_skip_sync_blocks() was consulted with offsets it cannot
interpret.

Only call the hook when the offsets match what the bitmap expects.
Reshape must visit every stripe regardless of bitmap state --
skipping would desync reshape_position from 'j' -- so never skip
there.  For recovery, add an md_personality capability,
recovery_in_bitmap_space, set by raid1 and raid456.  raid10 leaves
it unset (raid10_find_virt() needs the disk number, which
md_do_sync() does not have); raid0 and linear too, but no recovery
path of theirs reaches the hook.  No performance is lost against any
released kernel: the hook is llbitmap-only and new in v6.18, so
raid10 recovery returns to its earlier path -- walk every stripe,
skip clean chunks inside raid10_sync_request().

A capability rather than a geometry test: for raid10 layouts with
raid_disks == near_copies * far_copies, resync_max_sectors equals
dev_sectors while the spaces can still differ (far and offset
variants), so an arithmetic proxy reopens the same hole on those
layouts.  Disabling the hook for all recovery instead would
forfeit llbitmap's fast-forward over unwritten chunks for raid1 and
raid456 rebuilds.  Opt-in is also the safe default: a new
personality gets no bitmap consultation during recovery until it
declares otherwise.

Verified for near-2 and far-2 layouts: a rebuild onto an added spare
copies the writes made while the array was degraded.

Fixes: f196d7288864 ("md/md-bitmap: add a new method skip_sync_blocks() in bitmap_operations")
Cc: stable@vger.kernel.org # v6.18+
Assisted-by: Claude-Code:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/md.c    | 13 ++++++++++++-
 drivers/md/md.h    | 11 +++++++++++
 drivers/md/raid1.c |  1 +
 drivers/md/raid5.c |  3 +++
 4 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d1465bcd86c8..d60ea7aaca3a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9846,7 +9846,18 @@ void md_do_sync(struct md_thread *thread)
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			break;
 
-		if (mddev->bitmap_ops && mddev->bitmap_ops->skip_sync_blocks) {
+		/*
+		 * The bitmap may be consulted with 'j' for a plain resync,
+		 * but for recovery only when the personality declares that
+		 * its recovery cursor addresses the bitmap's space; raid10
+		 * recovery walks per-device offsets the bitmap cannot
+		 * interpret.  Reshape must relocate every stripe regardless
+		 * of bitmap state, so never skip there either.
+		 */
+		if (mddev->bitmap_ops && mddev->bitmap_ops->skip_sync_blocks &&
+		    !test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
+		    (!test_bit(MD_RECOVERY_RECOVER, &mddev->recovery) ||
+		     mddev->pers->recovery_in_bitmap_space)) {
 			sectors = mddev->bitmap_ops->skip_sync_blocks(mddev, j);
 			if (sectors)
 				goto update;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index d8daf0f75cbb..a490a47736b0 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -798,6 +798,17 @@ struct md_personality
 	/* convert io ranges from array to bitmap */
 	void (*bitmap_sector)(struct mddev *mddev, sector_t *offset,
 			      unsigned long *sectors);
+	/*
+	 * The position md_do_sync() walks during MD_RECOVERY_RECOVER
+	 * addresses the space the write-intent bitmap is indexed by, so
+	 * recovery may consult bitmap_ops->skip_sync_blocks() directly.
+	 * True for raid1 (device space is array space) and raid456 (the
+	 * bitmap is indexed by the per-device sync cursor).  raid10 must
+	 * leave this unset: its recovery walks per-device offsets while
+	 * its bitmap is indexed by array sectors, and translating needs
+	 * the disk number, which md_do_sync() does not have.
+	 */
+	bool recovery_in_bitmap_space;
 };
 
 struct md_sysfs_entry {
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index afe2ca96ad8c..1222c0470ab6 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3518,6 +3518,7 @@ static struct md_personality raid1_personality =
 	.check_reshape	= raid1_reshape,
 	.quiesce	= raid1_quiesce,
 	.takeover	= raid1_takeover,
+	.recovery_in_bitmap_space = true,
 };
 
 static int __init raid1_init(void)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ffb5fcde54a9..25f8d829a986 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -9078,6 +9078,7 @@ static struct md_personality raid6_personality =
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
 	.bitmap_sector	= raid5_bitmap_sector,
+	.recovery_in_bitmap_space = true,
 };
 static struct md_personality raid5_personality =
 {
@@ -9108,6 +9109,7 @@ static struct md_personality raid5_personality =
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
 	.bitmap_sector	= raid5_bitmap_sector,
+	.recovery_in_bitmap_space = true,
 };
 
 static struct md_personality raid4_personality =
@@ -9139,6 +9141,7 @@ static struct md_personality raid4_personality =
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
 	.bitmap_sector	= raid5_bitmap_sector,
+	.recovery_in_bitmap_space = true,
 };
 
 static int __init raid5_init(void)
-- 
2.43.0

