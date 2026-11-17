Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794907283;
	b=S9/37J0SJ3MeYy/BKxg/ZeJeJTTbE/Tg2+rnDwtu6fmZD76CShFjRSgUue67ARaVnK6S
	 FRLT0WAzLXKWgmq/EhsJjZibwGzyoQtpE0h9lVPubGpwicxgkUrfe5MYiE1TT/NLsrq/p
	 hgpnO2usKm294xJC1nhphkDVjE59DRXzFmcORIBDciIR/eYtqjXCif4WlR2KiYQ9cvjCc
	 OEfCtTTH5xT2IycySA/VDBZHUMwnKzUSwC3OKxYV6x1NfnRyM0FYZ6JimgoQDA+bx9ilU
	 yoUCAIRapk38aBvNsAlo+BHy9a4mXYbFnN8fBHVJE9rzX7CZbQenK4uu0G2CKExYkSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794907283;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SsxJs5rxvbYcOOTpD2Ws2cO+0FV9OQPQVwmjhOACjLw=;
	b=5s76FQl2XqDDQII9TEP+afgrksXUChSzp6S99QbWOZR3DF6tQwWckbXfLdKmfmsADwnL
	 Zi/szjYHTBWFnOvhRxv3Lix527ynzqJPgbkdjjw7yofCFA2ZU1E6NZZfliwGx1/3sBNfS
	 ZPdtCMz7JrwbgiJSXrCsS36U5KXcxVCTDqbMqMQefLOLfguHasViSOLTAMPJqu+pBnrkQ
	 90hPPhrQVL8dyHRTgfouW+eGfEw4LR9HSfWAsiuQmJZ+zwH8rj/GJ2o7z0sxy8CShH80n
	 ttx3BwS4AYfptyDjipmXCI4X299/qurs/M2pspQEVGVWQwcNDMaGfYCJQkkWMh+YtxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZEi1P7SW;
	arc=none smtp.remote-ip=209.85.210.170
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4619B606A32A
	for <linux-raid@vger.kernel.org>; Tue, 17 Nov 2026 09:21:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4619B606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZEi1P7SW
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8b68e59ab33so4123379b3a.2
        for <linux-raid@vger.kernel.org>; Tue, 17 Nov 2026 01:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794907282; x=1795512082; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SsxJs5rxvbYcOOTpD2Ws2cO+0FV9OQPQVwmjhOACjLw=;
        b=ZEi1P7SWnv1RREfr8r2ijdm+FEr4uyQDzdUC3bCJAzm7mW/vZfD4ir3n9eeu4dBDtO
         39mw6Dvk4eMR1GOeg65dkNpfM6UISYrOanD8KDPTC5z9/qlI1h8aw8prTkhdR80T5FIE
         62saeKTQBtgMZPRCcgckVXCVp8qw7MWj3np257UejsCRv2cki2NRj7QC+cpVh826dnHn
         bKtsV+T/dmiVUyvztD2cmM8tgtbcZYVoovEar1Yhc8BeirOD4fCsqN8/NcCGGmd3Jy8K
         5JbOQiKVje3fuxKY6OZ+OEG/n7mtqTjIXQYzXME4Au5+ITHjXaTgwhjxeIuqtW7vv6Nh
         y5Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794907282; x=1795512082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SsxJs5rxvbYcOOTpD2Ws2cO+0FV9OQPQVwmjhOACjLw=;
        b=y2jaDlsETQcFDZEEwyFY/SjRH4ZmzSU4KbHzxVada1PSRg8xThwB1aSX7Vce9ePAwD
         Lwyh0yDGKWP19mK3vLECAysTIz8UfZhoSacT8Y49SO0AfYakQSrX25uklCHE1/p75w0u
         VcFIo791rtUUjGA/HfCzsDF/cHP0logxL4BFpCzZyWYNHGP2VcJ9lqo0xsauaCVoCfVW
         fAaJVHB2jsvZ2z+wBA/pJX/Cetqejo66FsoaHA1T9+rEyt+WbzE+3TDH0gPxlq4axsvz
         I/ALDN5g9jwedPcrH8F8T9HT2n7x26xtCLwB3f4kv0zXOkLwlgH5Y+YVC/kQ4excM1Li
         +Ufw==
X-Forwarded-Encrypted: i=1; AL+hErGXc8f90eJSijWh27W3yH25+58gMeI9mDo8GF0Fx/oPXST3Zd2CKbPdOiSt6+REPZ/s2yWFeEBFMtXL@vger.kernel.org
X-Gm-Message-State: APuU4Z8gX1GBzGTD9tlgmx7oUDM6N5KE9yMxSQwK4CE0fV7a47igwlOx
	Yzsel7jfU6smI5Kx8xzdh9KtjYmGEyb54dSLO5Gbq39Zu4vLvTjLD1bs
X-Gm-Gg: AYBFou34D+8iMXrPHbiucS3BIUD0I1yBeef1SHVEzPGgQi19URY5JvZ1tqvPcXcmfCf
	mzsA9fvcGRB1AvqavlPOqaer8YQvT0QHUqL1JTtZBbeaC02f9+976MwIqqQBQYcGWWrYAHzoFUr
	bO3kegM4yaUvznqHIyKki0Sr5WdVwK8uuORXYZP3ZapjUHe10BZtgsSHbNynDH3kTN9RUniY+ao
	60oxlBVtfsdtfVPDHzKwMlk2XWFqfM/6yEboFsy1w8KALqXsj7iip6bIik9KFVDOFgfWv5v4kAs
	tTBs/og4b+/4Iwv7kVLBKw6d9T26S17Pl1ycGMH9r9QaAoRBoDBFgVFfN0qEAvS59lp5KHNqcuV
	n0cGO/B/hSoiYmBvHzPWze/RLU+nWz24oUu9xCG/dIRpbKfnErUzmUy3KUopXy0qXqM+NqzGTHD
	R1tQfYY6CTtlyrh3YX7WqtZeb5atPQ/hN186DLnmMw6lCooQ+O2XKDorJo6Ubc2rL8mioXCSbMp
	42gfMI2JeH9fB25imuuBcxPRg8LGPxsfPUErzjFYMU4CTOrVMaN1whkmD7pRfVokuEOTtmOutZf
	HQrxSZwXvF56Nx+rGL7omNKczN9lRc/apBmnH7A=
X-Received: by 2002:a05:6a00:6e81:b0:8b3:ce6d:8481 with SMTP id d2e1a72fcca58-8c423ef05d6mr1849031b3a.16.1794907281532;
        Tue, 17 Nov 2026 01:21:21 -0800 (PST)
Received: from TheRealOne ([2409:40e1:499:722a:52aa:d755:8f06:9251])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed204f7d6sm5014996b3a.35.2026.11.17.01.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 01:21:21 -0800 (PST)
From: Chandradhar Kumar <chandradhar.2003@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: xiao@kernel.org,
	magiclinan@didiglobal.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com,
	Chandradhar Kumar <chandradhar.2003@gmail.com>
Subject: [PATCH v5 1/3] md: validate v0.90 superblock disk bounds on load and sync
Date: Tue, 17 Nov 2026 14:50:51 +0530
Message-ID: <20261117092053.10884-2-chandradhar.2003@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117092053.10884-1-chandradhar.2003@gmail.com>
References: <20261117092053.10884-1-chandradhar.2003@gmail.com>
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

The legacy v0.90 superblock format (mdp_super_t) only holds MD_SB_DISKS
(27) disk descriptors in sb->disks[]. Unvalidated disk indices or an
out-of-range desc_nr can cause super_90_sync() to index past the end of
sb->disks[]:

  UBSAN: array-index-out-of-bounds in drivers/md/md.c:1740:29
  index 124 is out of range for type 'mdp_disk_t [27]'

Harden on-disk v0.90 metadata loading, validation, and superblock
synchronization against out-of-bounds indices:

1. In super_90_load(), reject superblocks where sb->this_disk.number >=
   MD_SB_DISKS, where a v0.91+ reshape has a pre-reshape disk count
   outside [1, MD_SB_DISKS], or where an active/sync descriptor has
   raid_disk >= MD_SB_DISKS.
2. In super_90_validate(), check rdev->desc_nr at the start of the
   function before any sb->disks[] dereference, and verify
   desc->raid_disk < MD_SB_DISKS before assigning rdev->raid_disk.
3. In super_90_sync(), bounds-check desc_nr and mddev->raid_disks
   before indexing sb->disks[]. If rdev->desc_nr is out of range (such
   as an excess spare or failed slot on a full 27-disk array),
   synthesize a faulty/removed this_disk descriptor with rdev->desc_nr
   rather than indexing out-of-bounds or zeroing this_disk (which would
   alias active slot 0 on subsequent assembly).

Fixes: 1a33a379e678 ("md: reject v0.90 arrays with too many devices")
Reported-by: syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9e3014263a35700ab49b
Signed-off-by: Chandradhar Kumar <chandradhar.2003@gmail.com>
---
 drivers/md/md.c | 40 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a802..6baf209703c8 100644
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
 
-- 
2.56.1

