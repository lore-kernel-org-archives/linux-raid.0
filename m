Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149E951E43D
	for <linux-raid@vger.kernel.org>; Wed, 23 Sep 2026 12:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790167616; cv=none; b=ovXTCmJR5iYs08dkf46/aWRRcGDEYvHivTmvLP6HDUPCEXRPrvFiGTjE0b1ZlNp8YVMCXb39lgh7/ZaJyKYym4OXUZI3UwAsYmH49lUICUurCVaXcv9ser1Ad33HsUBflnwszg52Go9v44ESsX751pPX3MdagvkaopgmCSGmEbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790167616; c=relaxed/simple;
	bh=a54UnvJ4WRA71/CLDw9FTRein/31Yct3hSsjC2DoAWA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gMbLtYCT/2eNwizWjiIhWqdAafbn6MdLfUX0Fofa5lr0cOnlR8+waiDtKd8fWwoEz5fw3tmlWAxWPssjf3/v5dhnQE7aepDori4x1trOIbaARJ1aXZIMcxJtdtynVuGqoMwu0XWLEY2X9gwxENqUFFD8vsUQgWvj3v3VDt8/W7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UMWL3Fz8; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UMWL3Fz8"
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2d6ff2f2c4dso1435655ad.0
        for <linux-raid@vger.kernel.org>; Wed, 23 Sep 2026 05:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790167614; x=1790772414; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YFesqPi/1PZDFGMQSlSf/PmsODcjQS9Ne6R9pOoOH6U=;
        b=UMWL3Fz8A/vfzpQeT7mmwhjOTTReK/y21iems2lbaditmnjXTlXTDALChoXM2yXAhe
         J+pxLO1BxFkrm6agxe2K7QUx+ZZpPUz7vFyo+pMLbNqtTXlXhoEaGyKGHVe6LhRVuCjn
         Q0RuwWjfTlMrXhafUQYvy8NH5ExZk7x3/RMt1T4CMwrUgbtnQ1h+CY02LLpdU9nQDumy
         xJNa8JpOofv39CtOtaWSgfzCMz8pRtKviM0qu2SibqWafkMRRTFvb29HVEYR5159A5Tz
         avOqjqEAgZYghduEbe0QMO9hwSV6J0rp0VHzWFaThqGgYtbh1owuv5imipqPHLih6Smo
         ma0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790167614; x=1790772414;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YFesqPi/1PZDFGMQSlSf/PmsODcjQS9Ne6R9pOoOH6U=;
        b=kWGLM7x3P1JLN/TY5tJDfYuqbW7enMEC2lXLNFS5FrXadBca1l0Uc5FGEX99EW5CVU
         kcwqLUAQbJW9qf3L3d18w/hvkBAAzBWwki6ex3wW5NAuXUqnq+Cp3hRAkra8JgWZ6Xbg
         6alIkF2BIyVXBrx2wIxXYraIHwuxGqUZ6iXP3j5t1pr4lwVBcbcAW64yvCRP/VqbJjOh
         p/jl6WXN81Z3/aTMTDQBYI4570Dp7geEvvw9hytD2eHcBcrJdylpjgotvtJU3aoLtziJ
         3UQPGbvYbHFRSQwFuj65/Cn0bu29ZmCooubZCXeWEDb4sr/e2I2hjItIj+Fr2xuEjf17
         0sww==
X-Forwarded-Encrypted: i=1; AKwUvBwkpi2KOr6Rlkf58mFHXQNH4SOukEgQ4CS/10MK01ofz66b90+zZwuzCd/6mQkaL1hgA+li70aguXKC@vger.kernel.org
X-Gm-Message-State: AFuF++mgr6VUItHuj3ktN9k2og0+IROn+0KzwUhkEwwnCMDXOeJiDBaG
	DRyuuesWNKy428HxU8feFwbkvw7FACAw8JTyXapbXGJsXUPYbVwGuIIb
X-Gm-Gg: AYBFou0aYP/r2jtpQ7KqNF+sjCGdMc9fyKqKkqxdlxeh3wvF45uRUxsYU6MywXAPqaT
	a4LNqLAzFTMG+4OC+M9LEsl2pyVWk3VwicTTfeBbgRCayjw9XKn2KEMGcTOzmapz43X977ob3BX
	qvUpeeZ7tl0tGcAeXz+GKMmppqsYq81KxIl2ZpWtUmW5F6mwSWQvUQKi7d2LkQBVsfemp6Lq+2c
	lzZMNjv11BVoeEnJJZM7uriSHie/JIOXEkSk9K0MPk5yA0i9/pcNP1eApF9WHGaET/Ot+wgUo3a
	hf2Pq0yDe9Q0dSUJeOQI/6ATAKV0KC363Opx5BaB6866ZSfY4UqWqbvEioK2ez0Y50dsO2hooCL
	4wWSB7Z3i9uMjfPGttv7wgVfViudl7mLOW/MRemKAGjyqDKWDLHJyLFreAd3zV7bkDRbe7w/HKq
	aCER3knNomw5Y1xSnMTfYSCHAazKwOs2yqMYWzbq/zTjuDAEwa0HAIeC3ZBcnxJt8Kfp1jVlRvF
	+YS2gXc65hJXuPg9DOXLUheGwaXLg==
X-Received: by 2002:a17:902:d98b:b0:2da:dd0a:99e0 with SMTP id d9443c01a7336-2df69dc0e9emr39302895ad.2.1790167613462;
        Wed, 23 Sep 2026 05:46:53 -0700 (PDT)
Received: from morax ([49.36.137.12])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a516d58sm9764925ad.11.2026.09.23.05.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 05:46:53 -0700 (PDT)
From: Aaditya Kansal <aadityakansal390@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	Aaditya Kansal <aadityakansal390@gmail.com>,
	syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com
Subject: [PATCH v2] md: fix out-of-bound by adding checks at store
Date: Wed, 23 Sep 2026 18:16:32 +0530
Message-ID: <20260923124634.5497-1-aadityakansal390@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
maximum disks (MD_SB_DISKS). This function doesn't contain any bound checks
for raid disks. The repro wrote higher value (124) in raid_disks sysfs
attribute to trigger this bug.

The repro is one configuration that triggers this bug, which is caused by
the lack of proper checks at sysfs stores. Store is one path to reach
OOB.

Add helper function md_check_disks_fit_metadata() and call it at
raid_disks_store() and metadata_store() to reject the write for
mismatched configuration (raid_disks > MD_SB_DISKS for major == 0). This
prevents invalid configuration via stores from reaching the super_90_sync
function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9e3014263a35700ab49b
Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
---
v2:
- moved the fix from super_90_sync() to a level above at store functions
- add checks at stores themselves to prevent wrong configuration from
  reaching the target function
- add helper function to be called at all the sites where check is
  required

 drivers/md/md.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..f0f693f6bf7c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1354,6 +1354,13 @@ int md_check_no_bitmap(struct mddev *mddev)
 }
 EXPORT_SYMBOL(md_check_no_bitmap);

+static int md_check_disks_fit_metadata(int major, int raid_disks)
+{
+	if (major == 0 && raid_disks > MD_SB_DISKS)
+		return -EINVAL;
+	return 0;
+}
+
 /*
  * load_super for 0.90.0
  */
@@ -4448,8 +4455,15 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->delta_disks = n - olddisks;
 		mddev->raid_disks = n;
 		mddev->reshape_backwards = (mddev->delta_disks < 0);
-	} else
+	} else {
+		err = md_check_disks_fit_metadata(mddev->major_version, n);
+		if (err) {
+			pr_warn("md: raid disks (%d) exceeds max disks (%d) for metadata version 0.90",
+					n, MD_SB_DISKS);
+			goto out_unlock;
+		}
 		mddev->raid_disks = n;
+	}
 out_unlock:
 	memalloc_noio_restore(noio_flags);
 	mddev_unlock_and_resume(mddev);
@@ -5041,6 +5055,13 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 	err = -ENOENT;
 	if (major >= ARRAY_SIZE(super_types) || super_types[major].name == NULL)
 		goto out_unlock;
+
+	err = md_check_disks_fit_metadata(major, mddev->raid_disks);
+	if (err) {
+		pr_warn("md: metadata version 0.90 doesn't support raid disks count higher than %d",
+				MD_SB_DISKS);
+		goto out_unlock;
+	}
 	mddev->major_version = major;
 	mddev->minor_version = minor;
 	mddev->persistent = 1;
--
2.55.0

