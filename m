Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795078864;
	b=2+v0FY8UF8QsKBl4FyWNW/BHoO/4D5VKZwM53ZGzirOUMpSg+rNTbn2Zvo6pRRCDqeHm
	 cUL4XcW5sGLp95YLVZbpMgCfkq8ongo0U7MlKxClAcT16EFq/zxSWUXd/kzNus0aq5Wz2
	 0+hXJgvC27hchH4O+bGWOJs7AQW6fF/FpDJAZC3Z8r7SzGC206QHduH7mKEbamZR0FOlw
	 LVh0qIcMJhrof5xbVjr3rNHezrCgbQFa7zChdzTMGcQJcf/mlctPyQ5j4soJc9h27bgGz
	 mBXVqXYKOV0JLOJbK7wuCcdLmPDpdQcCny8PPTNuYZtrFvBK1E1fY32DrzpysfIS3Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795078864;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Subject:From:To:Cc:Date:Message-Id:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=IaVGtrUtYv4HD8uCsAtcdorTy8sx9p1imeyyTVfExi4=;
	b=eabauYWlVBzD8ota46id8pYsuMZa2/JSjpXkgeiI6x9lClBdClMRWxnOhzwbqyRUov47
	 2JngdOZYBhAuwLMoNv+CEvNSqyVDgaGznrk+0oKRK/zz+YJA14xoyQsRCTKZA0mobyiVH
	 DMNhSVushDuRXxO0ntKBTKhTPBWixgbZdt6b1WBVk8blPH0izWw0KU5nvObwbETboqNBj
	 c7IJnWMhfsSqXyT19wsjuQBA0tWDSqvYIgJ9W5Uq9EdF5422tW/WrNFc+g4EW78zC++5f
	 uWHM9VI6ZJYALtage6xXHmZwrkeIsL/2PCg29pe69IQhFyepFejvxcWKKbNcFuvenPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=u3iFxgy4;
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53496606A33A
	for <linux-raid@vger.kernel.org>; Thu, 19 Nov 2026 09:01:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53496606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=u3iFxgy4
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3b3af93b85cso1108994a91.1
        for <linux-raid@vger.kernel.org>; Thu, 19 Nov 2026 01:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795078864; x=1795683664; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :cc:to:from:subject:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IaVGtrUtYv4HD8uCsAtcdorTy8sx9p1imeyyTVfExi4=;
        b=u3iFxgy4/WQ6Zr2QqEVtzcgj80ryUNlNB8MeD97B1DLEhJ7vBBeC6KTTmVFq2Ui4n0
         9pIGztm9nwN4K0gC71otRHuY2O96/ndHoif1/kcjlCzYeaxYnjuIh5yNEJyN0ehArKzl
         aDniIA+RTveUE9WiCgXpmakHDid6m9bLiVkCgT1RRaxS0qjm/D1resB0oc97BiP2CtV7
         5L0qddvW6KQv75sFZ+BgRxdGIbIxbzXdEYbq2LzclnK9/IaFAMmy7DxDQSF7X671/7rY
         bkD7FP0bfgOroUPoYOq/1j77T4L7zB1nfp0LoeqEC23H/Bgwm1mv5IWz/rLdY3mP6+zP
         PBmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795078864; x=1795683664;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :cc:to:from:subject:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IaVGtrUtYv4HD8uCsAtcdorTy8sx9p1imeyyTVfExi4=;
        b=Gm046eXyl5scF6KfIE7GovBVtSc91LMK3AUe6QFkvC3aG2y/8B8LQNpf5AykXGdlT+
         UgjmQM19yK/5oxoOa4vioKTsEWjjQQpfkVKQ8W0iPM5QoOmSJQUgwwe+W/NxHtQJ7X/8
         IIzFpRbH8gBS9Skh98zpIPDH2xBSDoFzkPY/f3KLPOkK5cjOWcy000I+xLbzndI7GYem
         xhYcuEzN44NJK+ABNqmn/lw8sl3p2sQELNaanAkUbe7hLyNvd1ADw6ZPj5gkcKp30FPU
         meShsOoqIIs++Kke5UWrogSd/963IH/+ux7Ym16CGAtYleHkQvioBWkU/icba5LkicXR
         btRA==
X-Forwarded-Encrypted: i=1; AL+hErFS/WRVP7q7on8mkvvSuqvUBPkzcoJHaOb2Kd9PsLojdwa8OW4XFhMm4bHxabiD+V4GrwMv+VUZFBrO@vger.kernel.org
X-Gm-Message-State: APuU4Z/GqkYcLIc2QNQgVMP8HS5C6JOdMMoMsgFsIzcDBsjM319bkh5M
	EW/nKdIS/bqQVfJafbErCOiQFM0Y7JubEzboXqSrvgqLqfdu/SMGTjiO7SFj/5R3FuRfxg==
X-Gm-Gg: AZFdTZeKhDvPICDConD3RVMB8bVCShieYm3w2F7FTMQfJ6MGa5EPf+DPD4S6bR3F4Ms
	84/2jnbhVjvLWckNkgS5/ITvLB0L0A7koTA4PY9R26tgkR3Ysh0Dkpe1pRvEnYtZegIGxDA5eG7
	9YwzJ+As1d9o7YkuNNokwntVdOt9TPSOvrwWC8B92kNdXeiw2vbOWtN90EyJLI6NAcha0WddvfG
	L0is8sDQvRck9bskbfo3n+62xJnKFCDEuxIm46ShO7TohdGr/4BjL3a+Yfo1KTZXncJAwqjTyG6
	Y6bYEz1d2ntyn5l2haSGQAhO1BvjsIh8SAVrMeQG5unAytPZ/9TRoWbi99XW9c5xCHO0YM4H9G3
	0VZxAKCGPrWMiiRX1s441zUtkCWT4iPVubyf2p/IGBB72s28QtGNS2OCYgKQMsDKzukgWJwCgV4
	x8+KB1lC6ZYbD3eB++11JNKysSukGjgkwv25wQsRLEPrecVVEmCxmat2Y8PvGGo7v6mMen/JNts
	5hnubJsac7jNGw5k41NHVlsUL+UZjbAgWtvoE4sqc9Ogg8ceAdH2jrASVeKvcIJpHvK0gVhAoXB
	QIkPk7pr+w4A3odHwSXEIxhi1iyh2P9A8cbHntigQHKNH7f8jv9MEqumJKcCNHNbNj+fBqX8L4X
	Kpd9niixHiGtl1+VvL9iJH2uItFMowcKPjcjzLervQuU8KQvcb81WQnRMCWGBT65X0A==
X-Received: by 2002:a17:90b:39ad:b0:39e:4c81:6c5f with SMTP id 98e67ed59e1d1-3b3d0761543mr5312256a91.26.1795078863464;
        Thu, 19 Nov 2026 01:01:03 -0800 (PST)
Received: from ip-10-0-133-75.us-west-2.compute.internal (ec2-3-42-157-111.us-west-2.compute.amazonaws.com. [3.42.157.111])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ffa98esm1698021a91.17.2026.11.19.01.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 01:01:02 -0800 (PST)
Subject: [PATCH] md: bound raid_disks by max_disks for v0.90 metadata
From: Yang Luohan <ylh440104@gmail.com>
To: song@kernel.org
Cc:
 yukuai3@huawei.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 19 Nov 2026 09:01:02 +0000
Message-Id: <179507886219.2370.1301636898303569514@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

md: bound raid_disks by max_disks for v0.90 metadata

commit 1a33a379e6 ("md: reject v0.90 arrays with too many devices")
bounded sb->raid_disks in super_90_load(), so a crafted superblock can
no longer describe more devices than a v0.90 superblock is able to hold.
mddev->raid_disks however is not only loaded from the superblock.

Both the raid_disks sysfs attribute and MD_SET_ARRAY_INFO write it
directly while the array has no personality, and neither enforces any
upper bound.  super_90_sync() then lays out the in-superblock device
table using mddev->raid_disks and walks past the end of the 4 KiB
superblock page.

mddev->max_disks already carries the limit that the selected metadata
format can represent, and update_raid_disks() already enforces it, but
it is only initialized when a superblock is read from a member device.
An array that has just been created through sysfs or
MD_SET_ARRAY_INFO has max_disks cleared, so the check is skipped.

Set max_disks when v0.90 metadata is selected in metadata_store(), and
reject values the selected format cannot represent in
raid_disks_store().  Both orderings are then covered: the limit is
installed either before the value is written or together with the
metadata choice.  Clamp super_90_sync() as well, so an array which
already carries a larger value cannot walk past sb->disks[].

v1.x metadata sets max_disks to (4096-256)/2 and is therefore not
affected by the v0.90 limit.

Fixes: 1a33a379e6 ("md: reject v0.90 arrays with too many devices")
Signed-off-by: Yang Luohan <ylh440104@gmail.com>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d1465bcd8..769ed1f09 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1610,7 +1610,7 @@ static void super_90_sync(struct mddev *mddev, struct m=
d_rdev *rdev)
 {
 	mdp_super_t *sb;
 	struct md_rdev *rdev2;
-	int next_spare =3D mddev->raid_disks;
+	int next_spare =3D min_t(int, mddev->raid_disks, MD_SB_DISKS);
=20
 	/* make rdev->sb match mddev data..
 	 *
@@ -1643,7 +1643,7 @@ static void super_90_sync(struct mddev *mddev, struct m=
d_rdev *rdev)
 	sb->ctime =3D clamp_t(time64_t, mddev->ctime, 0, U32_MAX);
 	sb->level =3D mddev->level;
 	sb->size =3D mddev->dev_sectors / 2;
-	sb->raid_disks =3D mddev->raid_disks;
+	sb->raid_disks =3D min_t(int, mddev->raid_disks, MD_SB_DISKS);
 	sb->md_minor =3D mddev->md_minor;
 	sb->not_persistent =3D 0;
 	sb->utime =3D clamp_t(time64_t, mddev->utime, 0, U32_MAX);
@@ -1727,7 +1727,7 @@ static void super_90_sync(struct mddev *mddev, struct m=
d_rdev *rdev)
 			d->state |=3D (1<<MD_DISK_FAILFAST);
 	}
 	/* now set the "removed" and "faulty" bits on any missing devices */
-	for (i=3D0 ; i < mddev->raid_disks ; i++) {
+	for (i=3D0 ; i < min_t(int, mddev->raid_disks, MD_SB_DISKS) ; i++) {
 		mdp_disk_t *d =3D &sb->disks[i];
 		if (d->state =3D=3D 0 && d->number =3D=3D 0) {
 			d->number =3D i;
@@ -4441,6 +4441,8 @@ raid_disks_store(struct mddev *mddev, const char *buf, =
size_t len)
 		mddev->delta_disks =3D n - olddisks;
 		mddev->raid_disks =3D n;
 		mddev->reshape_backwards =3D (mddev->delta_disks < 0);
+	} else if (mddev->max_disks && n >=3D mddev->max_disks) {
+		err =3D -EINVAL;
 	} else
 		mddev->raid_disks =3D n;
 out_unlock:
@@ -5029,6 +5031,13 @@ metadata_store(struct mddev *mddev, const char *buf, s=
ize_t len)
 	err =3D -ENOENT;
 	if (major >=3D ARRAY_SIZE(super_types) || super_types[major].name =3D=3D NU=
LL)
 		goto out_unlock;
+	err =3D -EINVAL;
+	if (major =3D=3D 0 && mddev->raid_disks >=3D MD_SB_DISKS)
+		goto out_unlock;
+	if (major =3D=3D 0)
+		mddev->max_disks =3D MD_SB_DISKS;
+	else
+		mddev->max_disks =3D (4096 - 256) / 2;
 	mddev->major_version =3D major;
 	mddev->minor_version =3D minor;
 	mddev->persistent =3D 1;
