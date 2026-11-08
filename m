Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794110557;
	b=nKHrzuG4KL3uvo1Sht/AAbFZqYHBsIzRBo+/AxWNxJq6b3c8jH5Zt+ihAFsXkO++dhOB
	 b5l9xhc/HxTZEaz/wlFSMFV0OaGvTSLCTh8pOIpblzPtzGkAEpqCkUs8FJ+33YJZPbSlW
	 j5lRB1Bf/NT+VZBqQdK0JYOWzHwlMxskfWTLd69cwG1iTcxS1w/BzMEF2Tpn8chRO0lS1
	 nXQLJKVzgPSansUzcMc00sjynTHKsWi/4DYLzBDE8/jXFe5+iySr3jPVSG+03rgj2OvZt
	 HqncrC8swra14EwbtLR4e/oUSqMiwuq1myGyqyfLOjchJEuzmfyqxZtVPArTo2GphhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794110557;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=e0N7bDNBnjqR8M4GFFj2K3/PwmzbihKT+GB9kbAlZp4=;
	b=xZJEuzEvahNtnoKuHICiMpQ73Jqpx2tw3D+zkjQr9WtM6AdutGWRpHSZAS9HsUv22O7n
	 8GX/KiCMoZwRwXDb4185gy190qNanOhfM3XQGj8QolLMA0QGrFpVe25pi4x2zfPSX19G/
	 zjeE9zgkmoPUzNwOlqExOkGyw9wZU0mUs24GnLwL5j2iXgcuBOQ2jYh9rC2AJ9kVD0VDX
	 mlJrqBVk6A86B8WUzE0+ZNYd+St+AXI/AeJ4a3CFjWcUFO1eW2rs10iG5D+X4EPV+tZnH
	 dL7T/JRmrIZBIXbsRTX7XM5ohiWlJtzDuBMwMWnwDrgCN0J4NkXvVUUhkZTjG7l1ZNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="R/A11VeQ";
	arc=none smtp.remote-ip=209.85.215.172
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A931606A31A
	for <linux-raid@vger.kernel.org>; Sun,  8 Nov 2026 04:02:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A931606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=R/A11VeQ
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc758830601so88420a12.2
        for <linux-raid@vger.kernel.org>; Sat, 07 Nov 2026 20:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794110557; x=1794715357; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e0N7bDNBnjqR8M4GFFj2K3/PwmzbihKT+GB9kbAlZp4=;
        b=R/A11VeQmxpu+8xWracH1Bgz6odPsP7JVYaH2zLTe3hxDh6maT4GQr+yrEq3xHdH1g
         USPwhFyE4qUJD1/PgblFfe1ESmYqQVMyAF14nBrUPurtzhaGIsEs5YKpRqpXV/S9Ofxr
         /D8zdHmczgFDQiIZ9sK9Uft7NYG1O+K5Nl830KZavsSqtoFTk9UesADYyGexzb7Twfyl
         SsLNyVDt1DHbdrfL8zFF1QwBQWTYyvqZoQDxxWzU0mWTA7dOBPmqyJlj6/g5scSKj0Kb
         hYjl4g7Qj6SBFn6I5c/bP/WtItJRJxA7Gekfb+9B4zQLdfexUfEfA7Rc+nGSbB9R4mNd
         v5Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794110557; x=1794715357;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e0N7bDNBnjqR8M4GFFj2K3/PwmzbihKT+GB9kbAlZp4=;
        b=QzQbFHD/79wgS9DX8H+ozuAOre5ovrCDhj+0aswvojC4Y7cLMFncZN235VORj1mP6M
         e3zIj62HAYBGdXVCSdJUNqamR3GgJmpW5Ok/lYZVAZGzsl6XxJBcC3D9aAY7p9DF1nH6
         hqIYwyDHhH96LjLO6watSI2qFCZaiURBwc4m5SaATp8Cfx0GtHA5a8FNpKnaoNOGTP5T
         vNSKWTQ5MCmQD33hkBa+DpRNBVUk0vrkd0L8V8jNELb85LccO1w843RyC0LRHlXX9lw1
         VyaerWr9FITdvj9BaF9PWay5YffnMGHeB6X04BR9JNe2QW950Gu7mo4GSA1sUGCwaIF0
         ftlg==
X-Forwarded-Encrypted: i=1; AL+hErHnmmn3CmrEi10s8gSXUN2m+1/RQcrCXi8AGRU7CNlROlKJJqW7pbQNFCPNlNqSmMjzxZLbjIRn/vdG@vger.kernel.org
X-Gm-Message-State: APuU4Z/jjyAiexg9aLah7MvIRrHHk6WwTPBbC3zG6tpseZNOSUrypw/A
	GKyFOg6cPo5zatH49YK7GfiEoO8feQqQIOJPrPIXR5ZKoKhO3NL1eRc1
X-Gm-Gg: AYBFou1ptcEouEJ3yt8VmC4vx8/w/IOXKpTzTkLT02ouqbPKSScOPFKqFrOJAT3Gbra
	dKZzyngW757kcxrM7gpUYeRzb/0uKQmkgbK3C/EpDHUwZ3GswPP3XxAROOXyvwP4dGfFipSs5vq
	5JGYVTpD1CUTesPSAs1wLfeAujbvXgOEPOSmYgsgSdCY/d5V0IreA//Ghp36GnnBVTLcfEOT24T
	b+LyQGRuMbi5dI81as2B9BXRX7h7CIqsTCJtEWTLj7zHHlYuMd8Bm0Qw7NYpKe0mq/Yj7s8ZYFQ
	Weao3IlcWrTFf9W9tu8mWoC7BQyuyu9BowWog+yYQaZnKG40Q0J36UJ82zWUfB0ZJ1VPzEba3o7
	I2KT+l//CJSk1IOJZZHIStQhomIBgvDy8BaPusyyE3YcmgRJe3wbGJvRS4l1pm/FiQnjdRzPzbx
	Yne8jrTHdKQAzFObyuKWBTcrzNbOeID7W4i3QB/3N6Q2IT9FPzvDB32qY9g20MSH1fmCo4N21S8
	Q4Pt+m8pW0KzNQYZxVhfSBfY3FH9nU0rBB6zTynzU6QEy82ZXykQ8o/vOXINTc8gp66yAHnjlEf
	+c4b9eWCapDSaJLVom5gMTXeckXK
X-Received: by 2002:a05:6a21:498e:b0:3e2:1160:6d20 with SMTP id adf61e73a8af0-3eecf97ebf0mr699131637.3.1794110556714;
        Sat, 07 Nov 2026 20:02:36 -0800 (PST)
Received: from thangnn-ASUS.. ([2a09:bac1:7aa0:50::498:71])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb969314a5sm295406a12.17.2026.11.07.20.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 20:02:36 -0800 (PST)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+0a8119ab801b078213ea@syzkaller.appspotmail.com
Subject: [PATCH] md: don't ignore bd_link_disk_holder() failure in bind_rdev_to_array()
Date: Sun,  8 Nov 2026 11:02:32 +0700
Message-ID: <20261108040232.43694-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
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

bind_rdev_to_array() adds the rdev to mddev->disks and then calls
bd_link_disk_holder() without checking the result. If the link fails
(e.g. an allocation failure in the holder or symlink setup), no
bd_holder_disk is recorded for the member, but the rdev stays bound.

Stopping the array later calls bd_unlink_disk_holder() for every
member, which finds no holder and warns:

  WARNING: block/holder.c:147 at bd_unlink_disk_holder+0xd8/0x2d4
  Call trace:
   bd_unlink_disk_holder+0xd8/0x2d4 block/holder.c:146
   md_kick_rdev_from_array+0x8c/0x324 drivers/md/md.c:2683
   export_array drivers/md/md.c:2714 [inline]
   do_md_stop+0x708/0xe6c drivers/md/md.c:7252
   md_ioctl+0x14ec/0x23e4 drivers/md/md.c:8462

Link the holder before registering the rdev kobject, fail the bind
if it cannot be created, and drop it again if kobject_add() fails.
All callers already export the rdev when binding fails.

Fixes: e09b457bdb7e ("block: simplify holder symlink handling")
Reported-by: syzbot+0a8119ab801b078213ea@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0a8119ab801b078213ea
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
---
Tested in QEMU (x86_64, KASAN + lockdep + failslab) with a reproducer
that sweeps fail-nth over ADD_NEW_DISK on a RAID1 /dev/md0 backed by
/dev/ram0 and stops the array after each attempt:

  before: ADD_NEW_DISK returns 0 after the holder link fails, and the
          next STOP_ARRAY hits WARNING at block/holder.c:147
  after:  ADD_NEW_DISK fails with -ENOMEM instead, no warning, and
          no KASAN or lockdep reports

 drivers/md/md.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5b2add94631b..0ad8f298aa78 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2618,9 +2618,14 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 	if (mddev->raid_disks)
 		mddev_create_serial_pool(mddev, rdev);
 
-	if ((err = kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b)))
+	err = bd_link_disk_holder(rdev->bdev, mddev->gendisk);
+	if (err)
 		goto fail;
 
+	err = kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b);
+	if (err)
+		goto fail_unlink;
+
 	/* failure here is OK */
 	err = sysfs_create_link(&rdev->kobj, bdev_kobj(rdev->bdev), "block");
 	rdev->sysfs_state = sysfs_get_dirent_safe(rdev->kobj.sd, "state");
@@ -2630,10 +2635,10 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 		sysfs_get_dirent_safe(rdev->kobj.sd, "bad_blocks");
 
 	list_add_rcu(&rdev->same_set, &mddev->disks);
-	bd_link_disk_holder(rdev->bdev, mddev->gendisk);
-
 	return 0;
 
+ fail_unlink:
+	bd_unlink_disk_holder(rdev->bdev, mddev->gendisk);
  fail:
 	pr_warn("md: failed to register dev-%s for %s\n",
 		b, mdname(mddev));
-- 
2.43.0

