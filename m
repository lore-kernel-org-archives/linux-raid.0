Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794629412;
	b=LZ+bqrcApt7nkRbtu9z9AFXZChZdfFbg+dgz+sFeL/cnummrXrnxKCQf7jojuCTPTfoj
	 w1MU8V2XAHbGU0BU0ymSYJhJZYOduNRd2Mm9moTnqf3Jukyh9AJGgTQeZMpAMfsvkX4mW
	 PwWXlEfm6Nj60HHpwjEzJ2cLacFrnGKeiu7uM/gDdlZYYndgzX8CCzj2488ra3ii9v4gb
	 4VA4tJuyvxCMGA66lilMzw/MjOMAMlHfiKGwIiuUlTZg9cHG8yrFcDPoM55UUQ84QUxsD
	 Dw9WodUeSJj7MGqYBYiQfFlJj1Kod1SZRd+SvP1Fr+sYcPj8VCsLytk5P73YWEr7Xzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794629412;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Aawsi9qU8N0F2jhvdO/AEEcrRUHzJjyBxw/ofl4l/RE=;
	b=BDAjAj+aJlyp765eea8xQPi07ClM7RineYXEMAxOsXoF1vbkiJbB4lBny6k5kc7knsBh
	 1PoTxv4AsogviSTyVbmHqIopbbZXP+92XpvfZbHCWlMKQBZkuQA2cz94bAyTXoasikB1C
	 6s3zbEDdU8TWECqFTJmYicZrr/3+63GjxnlzvVhFbP8ryE6+/GmVGq3EOPenBO2lJ4G0s
	 i4LWSVPdxK6qfumT9dB4wvYLMC0XY9UbLBxkW9Z+Q/qGBf3a8OaA1wR5rIPwIE1BKgGLd
	 huBhcTeyW6xwLHTgUITeHjucn0kS/84dU2GkgROtgkDyUogL0pRAYVlx1aJX7CxNjAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MxdTDwsz;
	arc=none smtp.remote-ip=209.85.214.173
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7858606A329
	for <linux-raid@vger.kernel.org>; Sat, 14 Nov 2026 04:10:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7858606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MxdTDwsz
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ee1b65fdbcso4298745ad.1
        for <linux-raid@vger.kernel.org>; Fri, 13 Nov 2026 20:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794629411; x=1795234211; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Aawsi9qU8N0F2jhvdO/AEEcrRUHzJjyBxw/ofl4l/RE=;
        b=MxdTDwszpHQAVrtbNNsDRKAQ/dgYDSiLWwLPbnU/4hyBnJpWWCvRjJyXW+H6Mis1Ep
         XCVjTOf5XGuoSro6vQ5OOnYWoKzrRYBtT9H7xOIYP3Gg/rHKhXxw1UItkqOfZrK+ICvu
         80wYlc6ERSVtPId7ceXKv4uBQErw7SwN5eFA1aHySLJ3oJD7jijq4+djFNRD0yWMlRJp
         PR7Y4X/oswLX7iVBXKb6tgvTndcYVN5Rpgre5AKIMX+G8J9zh/UiX4y7XHXP4ZvtDwKo
         X1/j5Nd5yqJFvcF6XmPtUPZjdQ+NnPCyuB0LBBqG6BRAa2kDaG1h4Humj64AVuJyj6lh
         oOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794629411; x=1795234211;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Aawsi9qU8N0F2jhvdO/AEEcrRUHzJjyBxw/ofl4l/RE=;
        b=UY5Sj07EWXK3dQxOB6Hz9bT5MwMgMBMi1uxbfXgJvuoX+Dc4g3G91X/UClm04iQggJ
         qQB68m4U5OLjUp2jnrVLXELI50rRthuRDeUhNqziF6FPwKcf0k5hSEx0OQ6dz/6ygptK
         vSCP3Vxq1CQYipxBgjf7rfvNcyLUIkN7Cc8UXRGjBYkW+kfmGuPt+mSTjD5EYtO8Ja6y
         noVPO3I9LmcGekRF6CBRkJdSFJs+vxnB4RPAUxX7tTOTkd9djQlOnn+fWsLnerjlkVk1
         SyzX+qc9vKYgIHGnFelAos2zouYWZ9K4/5z0uAjuKNkKwNxf8Aj2WcnFG5H879qH1YGM
         jqsA==
X-Forwarded-Encrypted: i=1; AL+hErH2u8+ZY/L1r1LeREXyAGNu65ZJsp6kYuR7iQmBr8JEMxdF99B5gd2j0GioPQHZg4qOyUnUSdTWa2P4@vger.kernel.org
X-Gm-Message-State: APuU4Z8A2zZf4ClnSa8n9t0CrChFbf3Imfh2umjxxPTrnb5stPq2u8H1
	sjqGnVhbHA67hcHEX2gQ+GaZNfShfFR4dlhwQVHD7rAnNh3agCn9AjGl
X-Gm-Gg: AYBFou2FE9AHRxqM1Z2g4xo2eHV2D2okx8cJNUxy6+CogknDihM9cBErp6S1xam03To
	tf+1LVTQcWDhfCkjrJu90Yt3jH8AGEG8Nlr33eCGgV5m9o8VmdSAekNZAwUe/UF2itGiEIh263O
	4O5cenemZiZTy+svUNpMcTF09ByhUdng+q3ZJd0kncBTlvH3fJh4UUA1OQKw1yZc8OTAnTI+OSI
	+tpq2wvQkgQG5wVpl0SFxJQ0gmrsMfyHXJo+6Y9PYJOjUH0HkRp4z9p9zfTpzWu9J/vgjHXiJP0
	3mdH2WCG9RP64ii6x+TRiq+0/P19o7Fk2acWOod/jhsNTzHDR5NZPpfx240ODtRIDuAYhOaX2f8
	5kRADmYzyDu8ykDf2InpYOZD0KAoSOqmqv1NOKB/6gza9rEhmUWM0jObQ/UWs8/Q9x3JHtPpNhR
	d1/QV090Hlq9vGQNWRuDerUIEazQc4qFIOKcYtvpOseFjtc+3xMNV786HxfVbq1v+tuO/qd7k9J
	8t6KH5zOsh3ZWYOQHBRdtfM8lFg5oAGN9tQ3TxJslO86XyGDGbw9KxiAMYTBfUIzJ9T0vIm25h+
	dqPeZNyDTO9hvnx1Tdp9fEqQK36xj2zWeqMZt3uY0fU1/oMNX6qsKkm2+nRjrsEIe/l/
X-Received: by 2002:a17:902:e801:b0:2ed:1ca2:ea5a with SMTP id d9443c01a7336-2ee0dca839cmr49377635ad.51.1794629410847;
        Fri, 13 Nov 2026 20:10:10 -0800 (PST)
Received: from TheRealOne ([2409:40e1:45d:fe42:3372:604f:8d11:1b5a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f224370sm17415915ad.0.2026.11.13.20.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 20:10:10 -0800 (PST)
From: Chandradhar Kumar <chandradhar.2003@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Chandradhar Kumar <chandradhar.2003@gmail.com>,
	syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com
Subject: [PATCH v3] md: enforce MD_SB_DISKS bounds across v0.90 superblock paths
Date: Sat, 14 Nov 2026 09:39:47 +0530
Message-ID: <20261114040959.18009-1-chandradhar.2003@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The legacy v0.90 superblock format (mdp_super_t) embeds a fixed-size
array of MD_SB_DISKS (27) disk descriptors (sb->disks[27]). Currently,
several configuration and metadata load paths fail to enforce this
upper bound, allowing mddev->raid_disks, rdev->raid_disk, or
rdev->desc_nr to exceed MD_SB_DISKS - 1 and trigger an out-of-bounds
array access in super_90_sync():

  UBSAN: array-index-out-of-bounds in drivers/md/md.c:1740:29
  index 124 is out of range for type 'mdp_disk_t [27]'

Fix this across all entry points and harden super_90_sync():

1. In super_90_load(), validate sb->this_disk.number, sb->delta_disks
   (for v0.91+), and active/sync raid_disk indices against MD_SB_DISKS.
   In super_90_validate(), check rdev->desc_nr at the start of the
   function before any sb->disks[] dereference and guard desc->raid_disk
   assignments.
2. In metadata_store() and md_set_array_info(), validate existing
   mddev->raid_disks against MD_SB_DISKS for persistent v0.90 arrays
   and maintain mddev->max_disks across both persistent and
   non-persistent transitions.
3. In raid_disks_store() and slot_store(), reject values overflowing
   INT_MAX or exceeding MD_SB_DISKS / mddev->max_disks across all
   configuration and reshape branches.
4. In super_90_sync(), bounds-check desc_nr and mddev->raid_disks
   before indexing sb->disks[], and synthesize a faulty/removed
   this_disk descriptor if rdev->desc_nr is out of range rather than
   indexing out-of-bounds or zeroing this_disk (which would alias
   slot 0).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9e3014263a35700ab49b
Signed-off-by: Chandradhar Kumar <chandradhar.2003@gmail.com>
---
Changes in v3:
- In super_90_load(), also validate sb->delta_disks (for minor >= 91)
  and active/sync disk raid_disk indices against MD_SB_DISKS.
- Move the rdev->desc_nr bounds check to the top of super_90_validate()
  before the mddev->pers == NULL branch indexes sb->disks[], and check
  desc->raid_disk < MD_SB_DISKS before assigning rdev->raid_disk.
- Reject n > INT_MAX in raid_disks_store() to prevent signed overflow of
  mddev->raid_disks prior to metadata_store().
- Update mddev->max_disks in the info->raid_disks == 0 branch and the
  non-persistent branch of md_set_array_info().

Changes in v2:
- Drop early return in super_90_sync() so rdev->sb_size and sb_page are
  initialized before sync_sbs() sets rdev->sb_loaded = 1.
- Do not reset rdev2->desc_nr = -1 or zero sb->this_disk on skip; instead
  populate sb->this_disk as faulty/removed with rdev->desc_nr.
- Validate mddev->raid_disks and set mddev->max_disks in metadata_store(),
  and move the raid_disks_store() check above the reshape/active branches.

 drivers/md/md.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a802..e733dcdd13a5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1407,7 +1407,18 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 		goto abort;
 	}
 
-	if (sb->raid_disks <= 0 || sb->raid_disks > MD_SB_DISKS)
+	if (sb->raid_disks <= 0 || sb->raid_disks > MD_SB_DISKS ||
+	    sb->this_disk.number >= MD_SB_DISKS)
+		goto abort;
+
+	if (sb->minor_version >= 91 &&
+	    ((s64)sb->raid_disks - sb->delta_disks <= 0 ||
+	     (s64)sb->raid_disks - sb->delta_disks > MD_SB_DISKS))
+		goto abort;
+
+	if ((sb->disks[sb->this_disk.number].state &
+	     ((1 << MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE))) &&
+	    sb->disks[sb->this_disk.number].raid_disk >= MD_SB_DISKS)
 		goto abort;
 
 	if (md_csum_fold(calc_sb_csum(sb)) != md_csum_fold(sb->sb_csum)) {
@@ -1501,6 +1512,9 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *freshest, stru
 	clear_bit(Bitmap_sync, &rdev->flags);
 	clear_bit(WriteMostly, &rdev->flags);
 
+	if (rdev->desc_nr < 0 || rdev->desc_nr >= MD_SB_DISKS)
+		return -EINVAL;
+
 	if (mddev->raid_disks == 0) {
 		mddev->major_version = 0;
 		mddev->minor_version = sb->minor_version;
@@ -1592,6 +1606,8 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *freshest, stru
 	if (desc->state & (1<<MD_DISK_FAULTY))
 		set_bit(Faulty, &rdev->flags);
 	else if (desc->state & (1<<MD_DISK_SYNC)) {
+		if (desc->raid_disk >= MD_SB_DISKS)
+			return -EINVAL;
 		set_bit(In_sync, &rdev->flags);
 		rdev->raid_disk = desc->raid_disk;
 		rdev->saved_raid_disk = desc->raid_disk;
@@ -1601,6 +1617,8 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *freshest, stru
 		 * that is, so set to zero for now
 		 */
 		if (mddev->minor_version >= 91) {
+			if (desc->raid_disk >= MD_SB_DISKS)
+				return -EINVAL;
 			rdev->recovery_offset = 0;
 			rdev->raid_disk = desc->raid_disk;
 		}
@@ -1708,6 +1726,12 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 		else
 			desc_nr = next_spare++;
 		rdev2->desc_nr = desc_nr;
+
+		if (desc_nr < 0 || desc_nr >= MD_SB_DISKS) {
+			pr_warn("md: %s: desc_nr %d out of range for rdev %pg, skipping\n",
+				mdname(mddev), desc_nr, rdev2->bdev);
+			continue;
+		}
 		d = &sb->disks[rdev2->desc_nr];
 		nr_disks++;
 		d->number = rdev2->desc_nr;
@@ -1736,7 +1760,7 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 			d->state |= (1<<MD_DISK_FAILFAST);
 	}
 	/* now set the "removed" and "faulty" bits on any missing devices */
-	for (i=0 ; i < mddev->raid_disks ; i++) {
+	for (i = 0 ; i < mddev->raid_disks && i < MD_SB_DISKS; i++) {
 		mdp_disk_t *d = &sb->disks[i];
 		if (d->state == 0 && d->number == 0) {
 			d->number = i;
@@ -1752,7 +1776,17 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 	sb->failed_disks = failed;
 	sb->spare_disks = spare;
 
-	sb->this_disk = sb->disks[rdev->desc_nr];
+	if (rdev->desc_nr >= 0 && rdev->desc_nr < MD_SB_DISKS) {
+		sb->this_disk = sb->disks[rdev->desc_nr];
+	} else {
+		sb->this_disk.number = rdev->desc_nr;
+		sb->this_disk.major = MAJOR(rdev->bdev->bd_dev);
+		sb->this_disk.minor = MINOR(rdev->bdev->bd_dev);
+		sb->this_disk.raid_disk = rdev->desc_nr;
+		sb->this_disk.state = (1 << MD_DISK_FAULTY) |
+				      (1 << MD_DISK_REMOVED);
+	}
+
 	sb->sb_csum = calc_sb_csum(sb);
 }
 
@@ -3353,6 +3387,12 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		if (slot >= rdev->mddev->raid_disks &&
 		    slot >= rdev->mddev->raid_disks + rdev->mddev->delta_disks)
 			return -ENOSPC;
+		if ((rdev->mddev->max_disks &&
+		     slot >= rdev->mddev->max_disks) ||
+		    (rdev->mddev->persistent &&
+		     rdev->mddev->major_version == 0 &&
+		     slot >= MD_SB_DISKS))
+			return -ENOSPC;
 
 		rdev->raid_disk = slot;
 		if (test_bit(In_sync, &rdev->flags))
@@ -3374,6 +3414,12 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		if (slot >= rdev->mddev->raid_disks &&
 		    slot >= rdev->mddev->raid_disks + rdev->mddev->delta_disks)
 			return -ENOSPC;
+		if ((rdev->mddev->max_disks &&
+		     slot >= rdev->mddev->max_disks) ||
+		    (rdev->mddev->persistent &&
+		     rdev->mddev->major_version == 0 &&
+		     slot >= MD_SB_DISKS))
+			return -ENOSPC;
 		rdev->raid_disk = slot;
 		/* assume it is working */
 		clear_bit(Faulty, &rdev->flags);
@@ -4437,11 +4483,20 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 	err = kstrtouint(buf, 10, &n);
 	if (err < 0)
 		return err;
+	if (n > INT_MAX)
+		return -EINVAL;
 
 	err = mddev_suspend_and_lock(mddev);
 	if (err)
 		return err;
 	noio_flags = memalloc_noio_save();
+	if ((mddev->max_disks && n > mddev->max_disks) ||
+	    (mddev->persistent && mddev->major_version == 0 &&
+	     n > MD_SB_DISKS)) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
 	if (mddev->pers) {
 		if (n != mddev->raid_disks)
 			err = update_raid_disks(mddev, n);
@@ -5029,6 +5084,7 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->external = 0;
 		mddev->major_version = 0;
 		mddev->minor_version = 90;
+		mddev->max_disks = 0;
 		goto out_unlock;
 	}
 	if (strncmp(buf, "external:", 9) == 0) {
@@ -5043,6 +5099,7 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->external = 1;
 		mddev->major_version = 0;
 		mddev->minor_version = 90;
+		mddev->max_disks = 0;
 		goto out_unlock;
 	}
 	major = simple_strtoul(buf, &e, 10);
@@ -5056,10 +5113,14 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 	err = -ENOENT;
 	if (major >= ARRAY_SIZE(super_types) || super_types[major].name == NULL)
 		goto out_unlock;
+	err = -EINVAL;
+	if (major == 0 && mddev->raid_disks > MD_SB_DISKS)
+		goto out_unlock;
 	mddev->major_version = major;
 	mddev->minor_version = minor;
 	mddev->persistent = 1;
 	mddev->external = 0;
+	mddev->max_disks = (major == 0) ? MD_SB_DISKS : 0;
 	err = 0;
 out_unlock:
 	mddev_unlock(mddev);
@@ -7941,16 +8002,30 @@ int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info)
 				info->major_version);
 			return -EINVAL;
 		}
+		if (!info->not_persistent && info->major_version == 0 &&
+		    (mddev->raid_disks < 0 || mddev->raid_disks > MD_SB_DISKS))
+			return -EINVAL;
 		mddev->major_version = info->major_version;
 		mddev->minor_version = info->minor_version;
 		mddev->patch_version = info->patch_version;
 		mddev->persistent = !info->not_persistent;
+		mddev->max_disks = (mddev->persistent &&
+				    info->major_version == 0) ?
+				   MD_SB_DISKS : 0;
 		/* ensure mddev_put doesn't delete this now that there
 		 * is some minimal configuration.
 		 */
 		mddev->ctime         = ktime_get_real_seconds();
 		return 0;
 	}
+
+	if (info->raid_disks < 0 ||
+	    (!info->not_persistent && info->raid_disks > MD_SB_DISKS)) {
+		pr_warn("md: %s: invalid raid_disks %d for v0.90 superblock\n",
+			mdname(mddev), info->raid_disks);
+		return -EINVAL;
+	}
+
 	mddev->major_version = MD_MAJOR_VERSION;
 	mddev->minor_version = MD_MINOR_VERSION;
 	mddev->patch_version = MD_PATCHLEVEL_VERSION;
@@ -7980,6 +8055,8 @@ int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info)
 		mddev->max_disks = MD_SB_DISKS;
 		mddev->flags = 0;
 		mddev->sb_flags = 0;
+	} else {
+		mddev->max_disks = 0;
 	}
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 
-- 
2.56.0

