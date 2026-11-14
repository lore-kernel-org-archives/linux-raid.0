Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794618414;
	b=XFidty64G7FtFCr8o/e/HA6pKTcVKpKgrb91Xgfz1cmyjDGl3M7GYFM7+y9eocZ0mUE6
	 83FI2+4+ypvpiGB1rPciwB9/l72NpdBfehI2TcBEIJ7H3iavTP4w0RdNWinXOkEDlF9eE
	 jokROFRKWWevi07oHu5Kxr9RsHjuVxLJrHL+1yaQuDzY9RsKgM+wiS4QXlaebDM44gxCd
	 +zrJhy/c+s7u63jUOq3m8lSy/h2Hk6JIZDKV03m6nDb1REKHOXsj4ZL6s7bHDVEae+P7n
	 QVGc0oKt5Ur2piYwzjIVvMZEBjKbP/RXdWldtrth7NvpSPV+ZCQr8Jvc6KAgiCBpVHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794618414;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=B2e76bhPXFe3TTOBltWF8laVYOhrcZJqYieGLm3qKQQ=;
	b=JgLhCxc9C5ecOKIAXSpI6VzgJdELK60ym4GcC63h9GSsIN5vgLMOPBfGcKBfhfKUTc10
	 sWslS6pnosU64ypRH7BCRM5pNTTNmJlpZK62wJgDLD8yjemyzeu9bbZzw+m022ZfSTLnH
	 Ad9BW8oRNtnzRueSxztgSE4+pLHl/xV7mr/CWA+chcMScjOdHe0VeZYfg4eTMWrl0TWM0
	 KBPi0uMxpCuCSmS5te84pYX5EUCVKFuzr8dL9YLyTeE9WDs3uOxVNYxXzvJuzvKGtyTZx
	 7JMvvL0LolT7ZFF9R4cJYEYmtF8xAp9GXirnV0rs//+SqHTWkz8vftr7kfTPSeaHg5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c2g78JQ9;
	arc=none smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AC9606A881
	for <linux-raid@vger.kernel.org>; Sat, 14 Nov 2026 01:06:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51AC9606A881
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c2g78JQ9
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2edd50e36f2so9528235ad.3
        for <linux-raid@vger.kernel.org>; Fri, 13 Nov 2026 17:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794618413; x=1795223213; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=B2e76bhPXFe3TTOBltWF8laVYOhrcZJqYieGLm3qKQQ=;
        b=c2g78JQ9ITc/EFcuKhARjltX2dU7rNuSdGyE+qt6IpQzAD9RZb5kEOFlh5bK58LWYJ
         67s3CmZPE8ivdvnHmp1/mDx+3j2uNuC0ijJM6kB6OjAN7wfBYROODrc6wFuggVvNLE70
         Gbu+hUxtF0m39Y9IFcGhmmaKfi6S1YQABFj4d3r8n/3UH03SqPeMceJqOpZFDFDPwQRv
         2lL8K2V6N+tvdG+ZyoG+PILEDag3fOC2JhcOjZua/HiZ/Z5TVlYDQAMPBjm+IjgoTTLh
         BEfnLpeNjx0zpKnDlHX8diHWRt7HCd9RBND2UgWeTb1fXDKx39PPFSM3GV2EsPGUitja
         U8gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794618413; x=1795223213;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B2e76bhPXFe3TTOBltWF8laVYOhrcZJqYieGLm3qKQQ=;
        b=jHrfo09VAjntgNO8ucPpYGPHE9x1pNdbCot01+0yOT3zXS1GVm1MJuE90SWlFVwJzs
         mStfbe4rQQ/r4eVq3vakoD1xFX1+3ezrcPSdv1L2UbQOSnSKOP5JPIy9BcQWRACo5PjZ
         Z9GBLePvK5ZkGsj6/wJ1EM7PXtXSjyraTaIpGsLqD2SKWTqgTq7eXG8Nf8NYUEeW46TY
         JCRhHrdKvjNkYoULcn5wU1bgn/2mTKjFwmIcQtAYwMN1+kwWhJ/f9ZW1sg36x6d77Y9Q
         qgdPloFIE51NeXy617jbkHJYAZSn040oHStB+KMPI44qRfSh14FbIp9zfOwIer7iFfZ/
         CnCw==
X-Forwarded-Encrypted: i=1; AL+hErGHDcgAfp9jpiskPq4SYWH246vLCXWjS5UC+Pk24dNRyZM78Q/3L+m0wkwAyTJMz6CnB0fNSTQyGhFd@vger.kernel.org
X-Gm-Message-State: APuU4Z/yK5zLDUT80O1x7TIvCKBew9cz91Wtx8avvLVY7AP7HSIPzSFU
	Pqpx49a5cCRUitlQcrEPt1r+Q+DZDmEu6JD2Vh+S5Uxqz46sY0VIg8qP
X-Gm-Gg: AYBFou3agSjZRR6DNRqoX9iV4/xZ+sdIjYDrWD5g686HQXgSJ9V+td5DfOZobNuvyL0
	4wkNof1KwRBDDFRbysQYE/w15WopZPudJf6wsDTmfoRh+gmw62CSl+612mFem7f31dInnZzy6S0
	uSElxHE7FX4FOVOi6lPIkZiNOr+rWIxTWIfzE2Y9qEHGqdnA5QDxdhdAtl4hyDY7DawoGYdrIbT
	d0YnOtckGQyyj01HLjoE/oxpz7LHkSyc4u/qxIEDms52RBBJykMWm2I3nMDW+vCwfWApW6pIlZ6
	hJuWCYmyy9PQP2vhFEScdOOvehPcXHrxcO0oDc+xRmejUF4JEzpPJ9wl9zjN3E4otocesGPs85r
	ngYmQKB/T5on1aBcQh5FbVJJ5rA1K97jFgGkqvyK7/WXBEZy5G+s+i8WxYcaFdHpTXJuqMMifnz
	AUW5702T0V9HwsS18R3meqgkjt5c+XtgYq5kt9KfsG/RfKU11662bK6rFlVtlSBsvqeDYxZdAko
	AU3T1NnkceaWtPwss4FyDDE19VzKgzuxuMPQohvJ091z6R20p+Lx4jwcHEoe7ezKJYv9U3w/9zW
	ckXhefOrz8DiZkwtu0IvG5F7iVFWV/UXyEZ6H1Lr
X-Received: by 2002:a17:903:3843:b0:2ed:18cc:d3ac with SMTP id d9443c01a7336-2ee0de41dd4mr36568865ad.16.1794618412485;
        Fri, 13 Nov 2026 17:06:52 -0800 (PST)
Received: from TheRealOne ([2409:40e1:1d:6fc6:f687:5d72:dcf5:c0a5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f7d99fasm16531025ad.35.2026.11.13.17.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 17:06:52 -0800 (PST)
From: Chandradhar Kumar <chandradhar.2003@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Chandradhar Kumar <chandradhar.2003@gmail.com>,
	syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com
Subject: [PATCH v2] md: enforce MD_SB_DISKS bounds across v0.90 superblock paths
Date: Sat, 14 Nov 2026 06:36:23 +0530
Message-ID: <20261114010635.6048-1-chandradhar.2003@gmail.com>
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

1. In super_90_load(), reject superblocks with sb->raid_disks >
   MD_SB_DISKS or sb->this_disk.number >= MD_SB_DISKS, and guard
   rdev->desc_nr in super_90_validate() before indexing sb->disks[].
2. In metadata_store(), validate existing mddev->raid_disks against
   MD_SB_DISKS when major == 0 and initialize mddev->max_disks so
   sysfs-configured v0.90 arrays enforce the 27-disk limit regardless
   of the order in which raid_disks and metadata_version are written.
3. In raid_disks_store(), slot_store(), and md_set_array_info(),
   reject disk counts or slot indices that exceed MD_SB_DISKS or
   mddev->max_disks across all configuration and reshape branches.
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
Changes in v2:
- Drop early return in super_90_sync() so rdev->sb_size and sb_page are
  properly initialized before sync_sbs() sets rdev->sb_loaded = 1.
- Do not reset rdev2->desc_nr = -1 or zero sb->this_disk on skip; instead
  populate sb->this_disk as faulty/removed with rdev->desc_nr so a skipped
  device cannot alias slot 0 on reassembly.
- Validate mddev->raid_disks and set mddev->max_disks = MD_SB_DISKS in
  metadata_store() when major == 0, and move the raid_disks_store() check
  above the reshape/active branches to cover all sysfs paths.
- Remove the info->major_version == 0 condition in md_set_array_info().
- Drop redundant unsigned < 0 check on sb->this_disk.number in
  super_90_load() and guard rdev->desc_nr in super_90_validate().

 drivers/md/md.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 55 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a802..71f536d6257c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1407,7 +1407,8 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 		goto abort;
 	}
 
-	if (sb->raid_disks <= 0 || sb->raid_disks > MD_SB_DISKS)
+	if (sb->raid_disks <= 0 || sb->raid_disks > MD_SB_DISKS ||
+	    sb->this_disk.number >= MD_SB_DISKS)
 		goto abort;
 
 	if (md_csum_fold(calc_sb_csum(sb)) != md_csum_fold(sb->sb_csum)) {
@@ -1587,6 +1588,8 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *freshest, stru
 			return 0;
 	}
 
+	if (rdev->desc_nr < 0 || rdev->desc_nr >= MD_SB_DISKS)
+		return -EINVAL;
 	desc = sb->disks + rdev->desc_nr;
 
 	if (desc->state & (1<<MD_DISK_FAULTY))
@@ -1708,6 +1711,12 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
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
@@ -1736,7 +1745,7 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 			d->state |= (1<<MD_DISK_FAILFAST);
 	}
 	/* now set the "removed" and "faulty" bits on any missing devices */
-	for (i=0 ; i < mddev->raid_disks ; i++) {
+	for (i = 0 ; i < mddev->raid_disks && i < MD_SB_DISKS; i++) {
 		mdp_disk_t *d = &sb->disks[i];
 		if (d->state == 0 && d->number == 0) {
 			d->number = i;
@@ -1752,7 +1761,17 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
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
 
@@ -3353,6 +3372,12 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
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
@@ -3374,6 +3399,12 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
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
@@ -4442,6 +4473,13 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
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
@@ -5029,6 +5067,7 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->external = 0;
 		mddev->major_version = 0;
 		mddev->minor_version = 90;
+		mddev->max_disks = 0;
 		goto out_unlock;
 	}
 	if (strncmp(buf, "external:", 9) == 0) {
@@ -5043,6 +5082,7 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->external = 1;
 		mddev->major_version = 0;
 		mddev->minor_version = 90;
+		mddev->max_disks = 0;
 		goto out_unlock;
 	}
 	major = simple_strtoul(buf, &e, 10);
@@ -5056,10 +5096,14 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
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
@@ -7951,6 +7995,14 @@ int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info)
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
-- 
2.56.0

