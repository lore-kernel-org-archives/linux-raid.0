Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380B3339363
	for <linux-raid@vger.kernel.org>; Sun, 13 Sep 2026 23:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789342646; cv=none; b=YauLJ9cti/AoZ1UVcUqFcTgoxLXIyVrYFnZwQNlmLCS6oXXXQcPUc8XEcIfJ4nvbonvdp/R10rs3bboWxJxOgRh3FoTlOkXiq+kzykciuH3X3YIq5aY+QwUlsUb36FIofcc6oxSzBEGKGKdnDt1FCVImEJGYVLMxCPao//dvoOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789342646; c=relaxed/simple;
	bh=mkuyK4WofdxX8EPtyS+3igt4OXINSncGQlihPXKD4VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROMtLumFbtEiLZGpCOJFAhvYjaK62QEDtzniIX3R7TIk+2UzuDUoYoZfVuDTGWJfHIYggjGn/efcdp/MfPzVj5ghAzim7Dk5H0VL6RIfL6jkNbhwydeDoi5imFPuQK3cH4mPly2N45KvDDxz09jINBLZR8Y0wy4y4M7LodqRudI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hw0TVlT6; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hw0TVlT6"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396673bd283so446916a91.0
        for <linux-raid@vger.kernel.org>; Sun, 13 Sep 2026 16:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789342644; x=1789947444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dgNMJr8jplv2KFXSlBLfF/98G5CpdQ58SzxBGw0u5iU=;
        b=hw0TVlT6gqXokVCujFNm0N2jjlSVlOiHcHMDNZgfKEgsy+d3013sufDQzXPQflqyhL
         QA558sEDcSJOGC4Z+/ZhP29ZbPLWZhCYjdgN1ZNM5CVTdmwgZi6EwsbLVNc34u7ds+Kl
         dmTUS1E9eIFejseZVdufjI9jptTEoYLzXFUJeSytugCzpBZVOTDt9R6U8P2DpPN9+811
         GbXlq4wo/6ez2M5aHNpyrXflnKwk3v+rem74EeCA2oZdosTsVjGsfaIOMW5VljV6Jy/F
         x3Dtc6d/G9cv+RZ7TRs405rgIB2jpP9MIO1pVZgF1HlN6+pilj1rvyvbsNfEIrMcFggB
         qNWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789342644; x=1789947444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dgNMJr8jplv2KFXSlBLfF/98G5CpdQ58SzxBGw0u5iU=;
        b=qWEe+7XM2c3sFVE4fph8Va5wXFf1h4y1Yc24NnakfrG7mIt9RCt6CfqOXV8xtdu0ei
         MX1Plgy4qz3GpwGwZ1P8ugr5KKF0xxYxMbmavSqOyQxru7uvDlACd954rRKWfrReWs/2
         WDkgq3Pfh0l02I2C8cfMN8SpzaviaYuLdsm6Px3ODTugELDyO9gzOSH37RV8U1NOAcZ5
         Qof4XeYAVM9dUIqBQ8gvbQt1lILFxKapXodwo3XGlXCN2Vm8VFEWA4IXo7TH42Fe7pAK
         WQqQqHJYHHusw/o23akYoSA8lczoT+KOLBS+jmbCE/oxPDc6aE4z+hE7+OH9+YYQY+JJ
         7dog==
X-Gm-Message-State: AFuF++k7q4GEBmcmOHnBzmo6MHclmiTl8jNeJ6momxaa+VjesgKKM7vh
	VPCGso6i252INPvz0INUJtH7rf1H3YxVLBR9H1Tchhsc76dV1Ow+UUjItzbgWRX7
X-Gm-Gg: AYBFou2DEWLGDR5NUyyfO4o1VALdY7ef55UAovLP0QSlOThmC5OomvsD5jnCWsdjX6P
	XfKlkkzxG1JmIyEqzCzuyQvareDobyBij9febXRMLK75/AjZ9vQcoiTAUqAXPobIly2YuUKz7IF
	Ad7vqJObAOMV2Y9FgWaANX9IZokBxDvweScnhQX2Yv8JiCB3YEDFha6/RP3Ca+5UaQ2s0u5cnby
	4FPKHm3j84WRoBJPM3mN+QD8KwTbwTgeVmHS98h17B5nmcHKuPCiAIGWp778DZVsZ+zp61aZUz6
	0Cis1nOarqzB9a0g54IN8eEMlWGJK8ZAl/HHJPvb0dEnaU0Hlg1f9FFW6BNn4RUBSfn79yVqmLd
	aqrD/KZYY/B6MOWKu7jhG6VayOfmqIKw0Wsdt3oz8GJLfRB04DqfKW6xZTPSnbpov5/Zh9KoPMC
	FyjXO8t8gk4OqYcEYlQaFlzGPycx0iWo5Ds0EJq8339+JF7n17yglkn42Ej28pO5GP5+zY5ogoe
	FC18+HB1NKZLhkTOe/NgNgdlvkKGl8=
X-Received: by 2002:a17:903:32c8:b0:2db:7799:d2f2 with SMTP id d9443c01a7336-2dd6c6d26dbmr1589295ad.2.1789342644504;
        Sun, 13 Sep 2026 16:37:24 -0700 (PDT)
Received: from morax ([49.36.138.18])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2cffb5c5sm37807715ad.80.2026.09.13.16.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 16:37:24 -0700 (PDT)
From: Aaditya Kansal <aadityakansal390@gmail.com>
To: syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com
Cc: linux-raid@vger.kernel.org,
	Aaditya Kansal <aadityakansal390@gmail.com>
Subject: [PATCH] md: add max_disks bound check in older version
Date: Mon, 14 Sep 2026 05:07:15 +0530
Message-ID: <20260913233717.464321-1-aadityakansal390@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <6aa6deac.f670cee1.72fc4.0013.GAE@google.com>
References: <6aa6deac.f670cee1.72fc4.0013.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test

syzbot reported array-index-out-of-bounds in super_90_sync()
    UBSAN: array-index-out-of-bounds in drivers/md/md.c:1697:17
    index 124 is out of range for type 'mdp_disk_t [27]'
    CPU: 1 UID: 0 PID: 10197 Comm: syz.3.1362 Tainted: G    L
    syzkaller #0 PREEMPT(full)
    Tainted: [L]=SOFTLOCKUP
    Hardware name: Google Google Compute Engine/Google Compute Engine,
    BIOS Google 08/05/2026
    Call Trace:
     <TASK>
     __dump_stack lib/dump_stack.c:94 [inline]
     dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
     ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
     __ubsan_handle_out_of_bounds+0xcc/0xf0 lib/ubsan.c:455
     super_90_sync+0x1eed/0x1ff0 drivers/md/md.c:1697
 ...

super_90_sync() exists for older version 0.90, which supports up to 27
maximum disks (MD_SB_DISKS). This function doesn't contain any bound checks for
raid disks. The repro wrote higher value (124) in raid_disks sysfs attribute
to trigger this bug.

Add bound checks in super_90_sync() to prevent index-out-of-bounds error. This
bound check hardens super_90_sync() function, such that it can catch max disk
index-out-of-bounds coming from any path, including raid_disks
attribute.

Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
---
 drivers/md/md.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..f5fce41637f1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1693,6 +1693,12 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 			desc_nr = rdev2->raid_disk;
 		else
 			desc_nr = next_spare++;
+
+		if (desc_nr >= MD_SB_DISKS) {
+			pr_warn("md: raid_disks = %d exceeds max_disks = %d for version 0.90\n",
+					desc_nr, MD_SB_DISKS);
+			continue;
+		}
 		rdev2->desc_nr = desc_nr;
 		d = &sb->disks[rdev2->desc_nr];
 		nr_disks++;
@@ -1722,7 +1728,7 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 			d->state |= (1<<MD_DISK_FAILFAST);
 	}
 	/* now set the "removed" and "faulty" bits on any missing devices */
-	for (i=0 ; i < mddev->raid_disks ; i++) {
+	for (i = 0; i < mddev->raid_disks && i < MD_SB_DISKS; i++) {
 		mdp_disk_t *d = &sb->disks[i];
 		if (d->state == 0 && d->number == 0) {
 			d->number = i;
--
2.55.0

