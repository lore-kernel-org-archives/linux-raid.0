Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFAD35C69A
	for <linux-raid@vger.kernel.org>; Thu, 10 Sep 2026 13:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789045885; cv=none; b=jdlLA66aXcW/38jKiYMDQxzZGLyzx5AxgVJRSfpFGYZHMQra8YpzIjb5DfQEoNVaVzNX5KOdD3x9kWFz5N77oiqFtkOsgQI2IkvZhrbd0aOMmsZz4NznHQqchExnPgG28+HKH1qYWhaSKi6AyzTXnzSE82eF6OtNG+M8V8FiG4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789045885; c=relaxed/simple;
	bh=IasFbIhvEWdxx3Mayak5dNwTr943NOuE+pZeN4b7SfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XlbHsE4YUX4YWm7a34vho/lWUR3dMuhmWRZ9X0ANx3JwAX62U84NJuvjUAa1Zt+vBJl67vRYicFdZtf1ZEw/5/cPRDyllhRKyDrOh/Eh3QIsBU7HsT+lfXwYJYNAhZ2GhqFuufLmTyScJzaYg4rBbav1wuiHzc5X/n7+Nt5H4Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HEgnS2sw; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HEgnS2sw"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cbee846deecso999043a12.1
        for <linux-raid@vger.kernel.org>; Thu, 10 Sep 2026 06:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789045884; x=1789650684; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MXrl1WeDEyODhGv9M/Bbf3QLYXjOYW/oTcQCSReevjE=;
        b=HEgnS2swIIVL8OSy+vtGsJrQ1lr2sd3i3sdjJVrza4DCvco2Tzv+QQUFiOW/amMsz3
         C1U3PsFfYWv8Quli2tzlghd7hfiJKWkuqZW3E1n/r1q4cPVQJDthNkwInJsrTeyumxEa
         NNO+zjVzhpp6L4ObGjazyZTBIcVul6VwycJG1MJLhvLBh1MJN8GCvov8HPHby8ceZztk
         FFL2yeUP3KlRqyL6nrEUOswXnmCHOEyYdqQ7St3G5UWcY6eV8Rg1koYZjDoXLWF2W8V3
         wE/hkp/uEOBM8ud8aByUtzjGnujYyI3w2XCflYguddeulg6yCEuNqUAIib2etqUNMcd9
         zNWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789045884; x=1789650684;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MXrl1WeDEyODhGv9M/Bbf3QLYXjOYW/oTcQCSReevjE=;
        b=PzoQLQp8T2DBRUzBrb1/UVRJa7BxiG1rZt2NZAo49KoTTKWzuKh4u9AiGo/DGbLFqE
         05f+riD//P/492rbA7rojICBYg0KaovP6Rx/oWIa+hymuxYN7OHvlPDhh7qkeo4j1hDn
         abgdwiH61sO2c/PJi5hEtVPxgZf8ZfDhAROmBir244AcAbtjlPqCSIi5ejfI4Knl9nyI
         GZaX/vo7w03P+QrEKGbDQEaFhn3dn054aPYrk+4q5cZ3pgCo85P0AjGJJ+XK6wA8D5Ez
         Viv2CXi26yr3voLjjxb+yeNjgqHIrzmbzlKonn3slFJBzOfRK7b7fGBHjgY3q83oQm17
         owOg==
X-Forwarded-Encrypted: i=1; AKwUvBwWpks7dZ2MjMaF/K05yVQAjlh8HtNL4skPXC0UgWGmDKjp4qG81567/Ukji7A9/KnCbRtErQlN6LY9@vger.kernel.org
X-Gm-Message-State: AFuF++ks+EU85Pz91rb1MpKoPUcX0zN7hrTyjhV+GI6Vggh5dVMsGKhk
	oq6GVpuLn0PYy+Oc/d83eTbxPQXgTAnYzfiw8q9eGC+EW3PpaT5y+BZt
X-Gm-Gg: AYBFou3513sDl/6j25YkUNGQgcLVQ59vY7TvVIJi5VF2OfqgBmwRM6r9nr0x8Zq8CKk
	wQFrqXArl782FOZlJ9bHImhInW9AhD/O78MpJP/NLIoeaURKsHKOISnwuIeqQY+HyY18PIaT9qm
	1xMNsdvWjoLaQYw0eez0GX+85I9edDEvfx5IRnqy+5fkv03mxMvskzYciB8MvpkR570uymO1Y3h
	zwu6Zny53e+cjODMYS9E3rVk8jMPbg1ralBSWr7orGH1g4OIhuwecDyNRqD1J9z91TT+84DKFea
	qcFsp8Mqv5MpVXYzRR0rwJnVRfjAnjLAh+vcYC5YDTip2wEg63XWu4scsdaIKHLFI+SwBHI3WPs
	IXKuavknof69gorrpl5RWsOrgxfCvx5xHe6kdXOQfDNYmqzjO4Iiu6dKxap4ce422PaDcwYNazW
	sx6tkc5VOyXKOHU2aFoQUqupoEvSWJzcI+Tspi1dqMOPbirvlIkoVjg2jYxsWTG97XMDR5IC1AA
	+S4aVd9yqe14vAVbXK3nSVmByhTLJ5SUB8=
X-Received: by 2002:a17:90b:2e0e:b0:398:9be5:b419 with SMTP id 98e67ed59e1d1-39b2622bfecmr60777094a91.20.1789045883692;
        Thu, 10 Sep 2026 06:11:23 -0700 (PDT)
Received: from LAPTOP-450UDG4J ([223.185.135.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db14959954sm87252765ad.27.2026.09.10.06.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 06:11:23 -0700 (PDT)
From: Yogesh Gaur <yogeshgaur.83@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	syzbot+1f5a7de91d547763f4c8@syzkaller.appspotmail.com
Subject: [PATCH] md/raid5: don't BUG() on an inconsistent reshape state from
 the superblock
Date: Thu, 10 Sep 2026 18:41:03 +0530
Message-ID: <20260910131103.988-1-yogeshgaur.83@gmail.com>
X-Mailer: git-send-email 2.55.0.windows.5
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

raid5_run() branches on mddev->reshape_position. When it is MaxSector --=0D
no reshape in progress -- the else branch asserts that nothing else=0D
describes one:=0D
=0D
	BUG_ON(mddev->level !=3D mddev->new_level);=0D
	BUG_ON(mddev->layout !=3D mddev->new_layout);=0D
	BUG_ON(mddev->chunk_sectors !=3D mddev->new_chunk_sectors);=0D
	BUG_ON(mddev->delta_disks !=3D 0);=0D
=0D
Nothing enforces that invariant. Both superblock validators copy the=0D
reshape fields straight off disk without cross-checking them against=0D
each other: super_1_validate() takes reshape_position, delta_disks,=0D
new_level, new_layout and new_chunk from the superblock whenever=0D
MD_FEATURE_RESHAPE_ACTIVE is set, and super_90_validate() does the same=0D
for minor version 91. A superblock that sets the reshape feature while=0D
leaving reshape_position at the MaxSector sentinel therefore reaches the=0D
else branch with a non-zero delta_disks, and assembling the array takes=0D
the machine down:=0D
=0D
  kernel BUG at drivers/md/raid5.c:8117!=0D
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI=0D
  RIP: 0010:raid5_run+0x11a7/0x1670 drivers/md/raid5.c:8117=0D
  Call Trace:=0D
   md_run+0xc2f/0x2510 drivers/md/md.c:6779=0D
   do_md_run+0x36/0x660 drivers/md/md.c:6880=0D
   array_state_store+0x9c5/0xcf0 drivers/md/md.c:4765=0D
   md_attr_store+0x1c5/0x330 drivers/md/md.c:6158=0D
   sysfs_kf_write+0xf2/0x150 fs/sysfs/file.c:145=0D
   kernfs_fop_write_iter+0x3e0/0x5f0 fs/kernfs/file.c:345=0D
=0D
This is reachable by anyone who can present an md superblock, so BUG()=0D
is the wrong response. Refuse to start the array instead, the way the=0D
reshape_position !=3D MaxSector branch a few lines above already refuses a=
=0D
reshape it cannot resume. Nothing has been allocated at this point --=0D
the journal-and-bitmap check just above returns -EINVAL the same way --=0D
so there is nothing to unwind.=0D
=0D
Reported-by: syzbot+1f5a7de91d547763f4c8@syzkaller.appspotmail.com=0D
Closes: https://syzkaller.appspot.com/bug?extid=3D1f5a7de91d547763f4c8=0D
Fixes: 91adb56473fe ("md/raid5: refactor raid5 "run"")=0D
Assisted-by: LLM=0D
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>=0D
---=0D
 drivers/md/raid5.c | 16 +++++++++++-----=0D
 1 file changed, 11 insertions(+), 5 deletions(-)=0D
=0D
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c=0D
index b91545ce090d..682812277ce5 100644=0D
--- a/drivers/md/raid5.c=0D
+++ b/drivers/md/raid5.c=0D
@@ -8110,11 +8110,17 @@ static int raid5_run(struct mddev *mddev)=0D
 		}=0D
 		pr_debug("md/raid:%s: reshape will continue\n", mdname(mddev));=0D
 		/* OK, we should be able to continue; */=0D
-	} else {=0D
-		BUG_ON(mddev->level !=3D mddev->new_level);=0D
-		BUG_ON(mddev->layout !=3D mddev->new_layout);=0D
-		BUG_ON(mddev->chunk_sectors !=3D mddev->new_chunk_sectors);=0D
-		BUG_ON(mddev->delta_disks !=3D 0);=0D
+	} else if (mddev->level !=3D mddev->new_level ||=0D
+		   mddev->layout !=3D mddev->new_layout ||=0D
+		   mddev->chunk_sectors !=3D mddev->new_chunk_sectors ||=0D
+		   mddev->delta_disks !=3D 0) {=0D
+		/* No reshape is in progress, but the array describes one.=0D
+		 * The superblock validators do not cross-check these against=0D
+		 * reshape_position, so this is reachable from disk.=0D
+		 */=0D
+		pr_warn("md/raid:%s: inconsistent reshape state - aborting.\n",=0D
+			mdname(mddev));=0D
+		return -EINVAL;=0D
 	}=0D
 =0D
 	if (test_bit(MD_HAS_JOURNAL, &mddev->flags) &&=0D
-- =0D
2.34.1=0D
=0D
