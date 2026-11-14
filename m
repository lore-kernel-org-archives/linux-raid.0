Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794661736;
	b=ZcR55efVRm4O0/thW7jVEGaUu9ley3/Ql6UIXr9vb4xvtlNP/WB3KE6fqPIrmheN0/+G
	 APfwoue+Jjyj/dcyeo181PaL4FFnhAqkMy1eBiW+nn3eA37sYxuyAKMfWmOfp/cMI3tUi
	 OPKv1HMA9rAkCJXdd/dEZ+M8CToZ78vuos+3zLf3EfpJFuqgKy56OduKxTFBPBb4/dOum
	 bqiviBWrUpxQq0cEcmDNoW/8BPCXrKRaJVIzpG0frqeoZ0LQ9yr1YmA+luYxJlQKQeHZy
	 I1oah9F6aDtCuINCKT2yRr/5SohvGYxrPcUVJHWqc65m3XQwp90GN+yUzprPlMpj3Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794661736;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WGneNvPPoT5hw7XNPiHgwiALQWYWBlkRtdshIWpd4hA=;
	b=webFFQ2pKCu567JAG8c6lnxfifroQIihAOkw4WTOvqlW/s5guJBsta79APkI+s8oQCei
	 PW3I7k1X0mIw3FLJ/ArdNiqFuwgLYVLkM4SDXhzhEYcJq8Y6MtuTyZRnmET6GYa6+ZNIs
	 6yFzCHeFH1ESfgAWcIPqFTYJH/d/PH7WYDDZdlKyHqd5LipIlW0nPKu5vRcboxUkxflXl
	 7JbF9VNwQZDnrEP4iO4yJuFnrD7Ochg7Xppi8AWmye1wDGEDd57CB1pRpXVcQn2xh+Kcs
	 UL6Ij8mN77Jp8MGe+J3UlYu9akacu/D1v6PFHIpDsSIhqXTZRPVFlTIW7PGzcNbuAaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=euDFGkAw;
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E44A6073D7F
	for <linux-raid@vger.kernel.org>; Sat, 14 Nov 2026 13:08:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E44A6073D7F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=euDFGkAw
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e946155442so24305695ad.3
        for <linux-raid@vger.kernel.org>; Sat, 14 Nov 2026 05:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794661735; x=1795266535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WGneNvPPoT5hw7XNPiHgwiALQWYWBlkRtdshIWpd4hA=;
        b=euDFGkAwCxBRpI4ob1JgBCE+LaxTqRpEa9M1nl8tcPI1UndpTinP3qTXaNKHOfIO4k
         qbfwffYvDEeSXvvOvgRahlSDVTuBVswLUc2HCDsz5YG5YzZkP4oCQOlV/5QPCEZ8bCi5
         84eA1DWeIQGP2Hp0QxfNdt0Siius05aBZTqux9RYAOsxKbB/XW5FicsJ5ub2aK2uD7wT
         vb+iEU2hdd5zICVDLp7GuMjiR0lZXwItSvhTXAT0hzBb5rpiRrAponb0p4t6NE97Mhy9
         u99f3jLv89SMRHyhhx6t8iFfcx3vK5pNZHjxgvQOEqJFuMjbb0wZ2cYwHHusELqmddee
         URkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794661735; x=1795266535;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WGneNvPPoT5hw7XNPiHgwiALQWYWBlkRtdshIWpd4hA=;
        b=b6M+VtBJcaoDd49J0gfaUh+zhXRpYFwOCjvzGI6XhZioPuOVfeQF2+nmeQX32ZfLjO
         nD7u8QqRzuj/02WM1I1pK6/WI+euIWoOLrDzGxZ3Ah+BNjgoku8cLxavJA2zTvHkH1CN
         cTyHhHbNg9FXm7a6VvD6k7Ra1My8A74+O0lk4wUK5aLgrIlG0VPbrW5SPaFYzHVPaGeR
         tZA08QB5PVf+Cioqbk9fxhmEMRuipEDl0mKfFHH1zXCO9SUYAKSIaA6dMvODZ8AGkGm2
         yD0BK0FgHcz9NU5knALrZLTc26l+aG5cvTP/vgrWeRDf/yBcynkAgeqNI7rbKosU/W7y
         5P6g==
X-Forwarded-Encrypted: i=1; AL+hErHyGcJ9SAAGeT7Bgqw73QsY7YwnYIU4ZvMNZkh5m20r2Q4f3RbfJ3tRm77RTheO04EUD63MAl5VQw61@vger.kernel.org
X-Gm-Message-State: APuU4Z96ybfPj2X02x9Z0PpdxWK8lo9mY29sjoxOYL6UyfObxGiUtDN2
	W0H26K7duuafHWwo9bZUQD2uQ1qKoLrX40jKVQcNN/wiESYUu+rdIQNciKXMnw==
X-Gm-Gg: AYBFou0h9sdWNG8gjXAh8RgUhWIbm4gmAKIUi4GAf5bq+waXYmHwOCbbatspY3QizXM
	tX+qoNuKMNFDJSJj4OowaFOg0LvPMV/D3sux34vK9PF9WU37AlrViWlk7TmiFOBG5tx7afNObEo
	E/PgqD2EJlvsZyakmxbhEt5/brooWDUZ5HjT9AhuDxg9fySKziyH0Kgv0b72Ft2z5RQAQC7Eg05
	dILXPbcbdkEruMP/FgJAvpMCqujyz4Ynmtm8e4uebBnjpi8KDV/a8XfzK2movSuBayNxYaDz264
	6cKZm34sv1iTELb8J4LxB2IhFIQhUqoFD8I8ZjUz4oHlSoMySa/rvKl/v0xtjsVF4zGIGKviF3E
	Ppodbvsx/IsNIuJDVHDUudhtSyA0u5Kwqefd5Yo14pSpOGPL5Qf9sDQVd7L6qPcxzAJBfX35tgI
	8IrcQdgCT0fuuJ//jDlPmOUTKAF8KrAU0HZz5ZTiTuzQzykC+GRl4WEbaMWFYOLctVjpFgdNKD+
	yPc/02M32vcpQdjbCHnRMDDWBt/SD0JUm57wNcshpf1GTIUn0lgLDasNqJUl5CueECDBuU6h+0U
	yS8i3rgy5Za4RF6vmMc3LCQJ+RyX0jyfqxF5dlMM
X-Received: by 2002:a17:902:db02:b0:2dd:c053:a6ee with SMTP id d9443c01a7336-2ee0dadc350mr49527695ad.32.1794661735105;
        Sat, 14 Nov 2026 05:08:55 -0800 (PST)
Received: from TheRealOne ([2409:40e1:19:e52d:23f4:fc0c:5126:f242])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f85b962sm21404325ad.47.2026.11.14.05.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 05:08:54 -0800 (PST)
From: Chandradhar Kumar <chandradhar.2003@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Chandradhar Kumar <chandradhar.2003@gmail.com>,
	syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com
Subject: [PATCH v4] md: enforce MD_SB_DISKS bounds across v0.90 superblock paths
Date: Sat, 14 Nov 2026 18:38:31 +0530
Message-ID: <20261114130833.9039-1-chandradhar.2003@gmail.com>
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

Fixes: 1a33a379e678 ("md: reject v0.90 arrays with too many devices")
Reported-by: syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9e3014263a35700ab49b
Signed-off-by: Chandradhar Kumar <chandradhar.2003@gmail.com>
---
Changes in v4:
- Cast sb->delta_disks to s32 before subtracting in super_90_load() so
  shrinking reshapes do not zero-extend negative deltas.
- Check pre-reshape disk count (mddev->raid_disks - mddev->delta_disks)
  against MD_SB_DISKS in metadata_store() and md_set_array_info().
- Update Fixes tag to 1a33a379e678 ("md: reject v0.90 arrays with too
  many devices").

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

 drivers/md/md.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 84 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a802..14e8f9347176 100644
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
+	    ((s64)sb->raid_disks - (s32)sb->delta_disks <= 0 ||
+	     (s64)sb->raid_disks - (s32)sb->delta_disks > MD_SB_DISKS))
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
@@ -5056,10 +5113,16 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 	err = -ENOENT;
 	if (major >= ARRAY_SIZE(super_types) || super_types[major].name == NULL)
 		goto out_unlock;
+	err = -EINVAL;
+	if (major == 0 &&
+	    (mddev->raid_disks > MD_SB_DISKS ||
+	     mddev->raid_disks - mddev->delta_disks > MD_SB_DISKS))
+		goto out_unlock;
 	mddev->major_version = major;
 	mddev->minor_version = minor;
 	mddev->persistent = 1;
 	mddev->external = 0;
+	mddev->max_disks = (major == 0) ? MD_SB_DISKS : 0;
 	err = 0;
 out_unlock:
 	mddev_unlock(mddev);
@@ -7941,16 +8004,32 @@ int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info)
 				info->major_version);
 			return -EINVAL;
 		}
+		if (!info->not_persistent && info->major_version == 0 &&
+		    (mddev->raid_disks < 0 ||
+		     mddev->raid_disks > MD_SB_DISKS ||
+		     mddev->raid_disks - mddev->delta_disks > MD_SB_DISKS))
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
@@ -7980,6 +8059,8 @@ int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info)
 		mddev->max_disks = MD_SB_DISKS;
 		mddev->flags = 0;
 		mddev->sb_flags = 0;
+	} else {
+		mddev->max_disks = 0;
 	}
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 
-- 
2.56.0

