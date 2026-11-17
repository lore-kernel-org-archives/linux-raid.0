Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794907288;
	b=OoZlm7jZMn9JcPpsIAoAjov1337SnCAQhk5jrsO1iY+pHctAtb2fb5yDusdiIsWT4P5k
	 Yg+t1BOu4TOYUpdnoD7NQezTBXEj/M8W8PpQcnMhdjmLsHC7X/HmFinAnmrUp2fBuGrgY
	 d8mMnlrEB/AGx3ruA+dq4Vq2zscLEOnC0yfk9SH8ScjYb8QSuwvnX/BiJToqpKxeN+slJ
	 vmRTMawIoUDLLu2Toc2nuVVu2txKMWqrfzPZN/dhLYiNiH64X6rXXktGbifN+FPbsxDdF
	 HE9GWp9VxlLVIG3FkBgHwSuyjrMt9oLX0gy9wkyfjpKNlzLtDZ3tGUZnKrE5d2oSzlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794907288;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WeFYOR/cWTH/jnpZ6ZgLyMhZDub8heVxegcNE8OIuKY=;
	b=JRrcuN+2PJ5Bw2k+bx1KJ2pjhFPn1JiXi374EKpF1tSwrh1/MRfm/EKoTvUvRUbH8p05
	 EE+FRqVfy5UH8A9H/zUxaqSb2CVl+DyVT9oKNFAXH8b6ZmKdnshv3Y87Tm1CcxrUe3aoD
	 ozUpFv84oa5SuQ/J4gMvLPVQzXDAjYm9OGis3NizlHDZXDTY9bQZ+N1zjnqzqWVAhptdZ
	 oCt6gGpefH/1DrNitMbnoFvdBMeids7iKhpRAd7j/DexdF7NVXYs/q2rluhnKeavqtroE
	 XSExP0SOzFlZD4s7g5Wjeotwhu4rHr1ToGKG1p99LnCY6T7CC6iAXm2s7q/dj4tTfoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Czyncu/5";
	arc=none smtp.remote-ip=209.85.210.174
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026F5606A334
	for <linux-raid@vger.kernel.org>; Tue, 17 Nov 2026 09:21:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 026F5606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Czyncu/5
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8a9f9473029so4108689b3a.2
        for <linux-raid@vger.kernel.org>; Tue, 17 Nov 2026 01:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794907287; x=1795512087; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WeFYOR/cWTH/jnpZ6ZgLyMhZDub8heVxegcNE8OIuKY=;
        b=Czyncu/5OMro3QMVvzH0a9UWnmQRCKbTP+YZRK0YG4PG8zYLIM+pZLpW5p4HpYyMyu
         sA/VRdQgoEKoq6tXcjf5AMKwJpRVtqXH0LfvIkrOQkWqEGAXja6pSuXu6fHLYMefTC/t
         B1AW4+CmKAkjNvfbVl+4A/207boa387ia1THm8/QkNKwkhtxBW7OC2F9LHX5Rr7Mjps7
         dqcFuz5IRUYZGQ4hnBRcZbt9dKEG2YZLgIcAEoMLUMDLHPwZuCXlvKOO0DP8x7WU8WBt
         tyfufAyR7KWxLgNjS1KuxQJJ1nHJq9mkUmyZS4IOOlUVPw/ynk4vGLlFqQoKPCHs2R4M
         3Uaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794907287; x=1795512087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WeFYOR/cWTH/jnpZ6ZgLyMhZDub8heVxegcNE8OIuKY=;
        b=zTc2JnDbrSkXMbAzXiGZWEUoPqRg25pyzOWd0HRW0nYFGK2yB0/05DpHm2BDewm18A
         l4DuWidYh9PmMdwAghNwyK21Lv2K2UnS+R6aG3feW/sTv7e9c6qlkq10n9TgkiKqAFvM
         PO22AOOlfyEjDldJ/xJ4YG/126/l5dTYqluGSNlRYSxOLPfFlZxj/7CqZWNmGC+zBYBr
         K8PKudLaS7QGOaDeVv7DWoIt0O2Vo2wBvrS9I/hTmEP8slVXviPxMhWlcxOl2ai1rFmh
         0fLr0WAje8iKg+Celh0gg3PS3STHT8RG5jylvxkjmN3s+qHgICHGdjZv6m08pldwdNhm
         zuMQ==
X-Forwarded-Encrypted: i=1; AL+hErGxbgtrzD+wJwJh4lB0fNwMEWJNqKyesKE+24YCFme5grD9EfTNFAr3uaVkSa5jB7bAn7xO452HFFYz@vger.kernel.org
X-Gm-Message-State: APuU4Z+SLdufUCVbzASroRlGTLnUEAxoqVXmnGB8zLwA96fQeSPu+var
	evfO5j2OeyY/8R8H58pAMK2ZQKZNjc/tXUK3YP/wRndpoaClylDuCPsO
X-Gm-Gg: AYBFou0xz97uzDrq5H+6FaJklibD8GY3o0qzXexsi5YDEOQalrwdDo/0WoD+6H2Mske
	nHQuTiKPmTYPjsx/NpgvoleHfO8MXuvy1banN10Lz+g6AZr4XGoWNtvfFmM99KBlfUbf7ypzmCw
	AzNSkz+fidc9panOe1sDBnXqLKufTJE4u1vGy8wghzIGV7QP7bTknrJWrHih4YsiQUovp2qJ25r
	txpRZvmtGlw6SID0D99hsVWxUhRoySs91vsk6H82GmAE7lkZcN2BjFQLqKWx9Yds2dqfb2Xwf5l
	8E+bCI0X+Kc9lgiFWMkRT1Dxu1oI1WSGdsBZJVhFcETtLnGzZPk5RGIJGKsvW4Y9JRjcJCNCPv8
	Y0bOGsl/xNpWFq+kZvSPRb567VaT2N822ClUEk0Rk6o/hwlO7ECnJ0sduN31AYT5NtoGohvInQB
	3xzfA+dpSDPoZMf1/iZjaiyUt2y+kr9mFKoweQjSSWtih9UlaZzttDyv2DeH8hVpyLerj0hO6xu
	p2NkspqIpB1UOeaHnoY7dRjG6B9vX9/3MRBcjiw1qsiLyUdC504swq3o/VcF/hwAFW3SA/irwuh
	6CpGQY+ObO/fcwGpCrxUqKisRBUIdIqXCUmIdD7B
X-Received: by 2002:a05:6a00:2d2a:b0:89e:b291:89c1 with SMTP id d2e1a72fcca58-8beb7d17eabmr12615132b3a.53.1794907287251;
        Tue, 17 Nov 2026 01:21:27 -0800 (PST)
Received: from TheRealOne ([2409:40e1:499:722a:52aa:d755:8f06:9251])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed204f7d6sm5014996b3a.35.2026.11.17.01.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 01:21:27 -0800 (PST)
From: Chandradhar Kumar <chandradhar.2003@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: xiao@kernel.org,
	magiclinan@didiglobal.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com,
	Chandradhar Kumar <chandradhar.2003@gmail.com>
Subject: [PATCH v5 2/3] md: maintain max_disks for v0.90 arrays in metadata_store and ioctl
Date: Tue, 17 Nov 2026 14:50:52 +0530
Message-ID: <20261117092053.10884-3-chandradhar.2003@gmail.com>
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

When a v0.90 array is assembled from on-disk superblocks,
super_90_validate() sets mddev->max_disks = MD_SB_DISKS (27). However,
when an array is configured via sysfs (metadata_store) or the
SET_ARRAY_INFO ioctl (md_set_array_info), mddev->max_disks is not
consistently updated across metadata transitions, and existing or
requested disk counts are not validated against MD_SB_DISKS.

Fix both configuration paths:

1. In metadata_store(), when switching to v0.90 metadata (major == 0),
   verify that mddev->raid_disks and the pre-reshape disk count
   ((s64)mddev->raid_disks - mddev->delta_disks) are within
   [0, MD_SB_DISKS], and set mddev->max_disks = MD_SB_DISKS (or reset
   it to 0 for non-v0.90 / external / non-persistent metadata).
2. In md_set_array_info(), reject negative or > MD_SB_DISKS raid_disks
   values for persistent v0.90 arrays, validate existing raid_disks and
   pre-reshape counts in the info->raid_disks == 0 branch, and update
   mddev->max_disks across both persistent and non-persistent branches.

Fixes: 1a33a379e678 ("md: reject v0.90 arrays with too many devices")
Signed-off-by: Chandradhar Kumar <chandradhar.2003@gmail.com>
---
 drivers/md/md.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6baf209703c8..b09553078353 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5063,6 +5063,7 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->external = 0;
 		mddev->major_version = 0;
 		mddev->minor_version = 90;
+		mddev->max_disks = 0;
 		goto out_unlock;
 	}
 	if (strncmp(buf, "external:", 9) == 0) {
@@ -5077,6 +5078,7 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->external = 1;
 		mddev->major_version = 0;
 		mddev->minor_version = 90;
+		mddev->max_disks = 0;
 		goto out_unlock;
 	}
 	major = simple_strtoul(buf, &e, 10);
@@ -5090,10 +5092,17 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 	err = -ENOENT;
 	if (major >= ARRAY_SIZE(super_types) || super_types[major].name == NULL)
 		goto out_unlock;
+	err = -EINVAL;
+	if (major == 0 &&
+	    (mddev->raid_disks < 0 || mddev->raid_disks > MD_SB_DISKS ||
+	     (s64)mddev->raid_disks - mddev->delta_disks < 0 ||
+	     (s64)mddev->raid_disks - mddev->delta_disks > MD_SB_DISKS))
+		goto out_unlock;
 	mddev->major_version = major;
 	mddev->minor_version = minor;
 	mddev->persistent = 1;
 	mddev->external = 0;
+	mddev->max_disks = (major == 0) ? MD_SB_DISKS : 0;
 	err = 0;
 out_unlock:
 	mddev_unlock(mddev);
@@ -7975,16 +7984,33 @@ int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info)
 				info->major_version);
 			return -EINVAL;
 		}
+		if (!info->not_persistent && info->major_version == 0 &&
+		    (mddev->raid_disks < 0 ||
+		     mddev->raid_disks > MD_SB_DISKS ||
+		     (s64)mddev->raid_disks - mddev->delta_disks < 0 ||
+		     (s64)mddev->raid_disks - mddev->delta_disks > MD_SB_DISKS))
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
@@ -8014,6 +8040,8 @@ int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info)
 		mddev->max_disks = MD_SB_DISKS;
 		mddev->flags = 0;
 		mddev->sb_flags = 0;
+	} else {
+		mddev->max_disks = 0;
 	}
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 
-- 
2.56.1

