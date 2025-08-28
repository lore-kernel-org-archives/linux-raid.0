Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0BF326D74;
	Thu, 28 Aug 2025 16:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756399096; cv=none; b=YTDvjdLFvw02PtecpoMeQI707GpkK9OQVNOU/EvxnBXONyxoYEA7w0oe0jUvmhqIFTJhwZOJA2bLrLXUeZNWHtDPvzL/8qozOxtTCE0xePmTMOB17/lKjcVdJB2FMdYzjAVXtRenCqYmAD5Ds1uQ1OqUp7oMWBQu9QdseQT4A2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756399096; c=relaxed/simple;
	bh=02yu/ACI0hvxnqj60VFXeYnZL1Z8no4N8p1Q4V+fyTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRcEClBf6nquK/WmzP5P6y4FKRfA02mn8YBoJ1biMV3SqS9qT8ViJLIywUD3e26JYlHH1MLMmdZQ31vKg00PzNhXE5DpZdV6T3iFNOXR60TG2GAQkmIgddhsWFrGnxHO2fWTF+BsCe2JPw2fq+SydKYPEXHsq5pmjz46gNC0F2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=q9+iTTGA; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="q9+iTTGA"
Received: from fedora (p4276017-ipxg00p01tokaisakaetozai.aichi.ocn.ne.jp [153.201.109.17])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 57SGWlxP041448
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 29 Aug 2025 01:32:52 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=/8pYPCC/j39B+G6vM1jEyw8y/KJNAHXUSpAyn3a8xm8=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1756398772; v=1;
        b=q9+iTTGAHxnTxKrkYs7WyDdttrQe6QWf4ltyRMLN1gyfBgoEwiKcZUhQQ1wssHdg
         X6LxpcVeyjXfSSzveiOZHKy1zTGxr9TUHus0fqBRkaXKYpOo4tkmO2z1CPgN6yjV
         Smxd7dM7iV/EILUD3JBRX3b3CuxJKnL8/eb4lvjjvhvMhjb3xv8RHVpOtOTP0cog
         vaS1AHRG9pHQGMruPMGKKz3M4B3p+oI+WMi/cwEp+nKcnOFNJA1Mh0gGvYNvW2G0
         Yv8aDAGPDsgmG3nxqdGrtnj/lv6Ivd5Js8+HT6mxWCcyHNjm3KRmWhN6sWjiEY/V
         vl3WS3vynxJiZGWTO9Qs6Q==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v3 3/3] md/raid1,raid10: Fix: Operation continuing on 0 devices.
Date: Fri, 29 Aug 2025 01:32:16 +0900
Message-ID: <20250828163216.4225-4-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250828163216.4225-1-k@mgml.me>
References: <20250828163216.4225-1-k@mgml.me>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 9a567843f7ce ("md: allow last device to be forcibly
removed from RAID1/RAID10."), RAID1/10 arrays can now lose all rdevs.

Before that commit, losing the array last rdev or reaching the end of
the function without early return in raid{1,10}_error never occurred.
However, both situations can occur in the current implementation.

As a result, when mddev->fail_last_dev is set, a spurious pr_crit
message can be printed.

This patch prevents "Operation continuing" printed if the array
is not operational.

root@fedora:~# mdadm --create --verbose /dev/md0 --level=1 \
--raid-devices=2  /dev/loop0 /dev/loop1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 1046528K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
root@fedora:~# echo 1 > /sys/block/md0/md/fail_last_dev
root@fedora:~# mdadm --fail /dev/md0 loop0
mdadm: set loop0 faulty in /dev/md0
root@fedora:~# mdadm --fail /dev/md0 loop1
mdadm: set device faulty failed for loop1:  Device or resource busy
root@fedora:~# dmesg | tail -n 4
[ 1314.359674] md/raid1:md0: Disk failure on loop0, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
[ 1315.506633] md/raid1:md0: Disk failure on loop1, disabling device.
               md/raid1:md0: Operation continuing on 0 devices.
root@fedora:~#

Fixes: 9a567843f7ce ("md: allow last device to be forcibly removed from RAID1/RAID10.")
Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/raid1.c  | 9 +++++----
 drivers/md/raid10.c | 9 +++++----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 547635bcfdb9..e774c207eb70 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1787,6 +1787,11 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 	if (test_and_clear_bit(In_sync, &rdev->flags))
 		mddev->degraded++;
 	set_bit(Faulty, &rdev->flags);
+	if ((conf->raid_disks - mddev->degraded) > 0)
+		pr_crit("md/raid1:%s: Disk failure on %pg, disabling device.\n"
+			"md/raid1:%s: Operation continuing on %d devices.\n",
+			mdname(mddev), rdev->bdev,
+			mdname(mddev), conf->raid_disks - mddev->degraded);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 	/*
 	 * if recovery is running, make sure it aborts.
@@ -1794,10 +1799,6 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_mask_bits(&mddev->sb_flags, 0,
 		      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
-	pr_crit("md/raid1:%s: Disk failure on %pg, disabling device.\n"
-		"md/raid1:%s: Operation continuing on %d devices.\n",
-		mdname(mddev), rdev->bdev,
-		mdname(mddev), conf->raid_disks - mddev->degraded);
 }
 
 static void print_conf(struct r1conf *conf)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b940ab4f6618..3c9b2173a8a8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2038,11 +2038,12 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 	set_bit(Faulty, &rdev->flags);
 	set_mask_bits(&mddev->sb_flags, 0,
 		      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
+	if (enough(conf, -1))
+		pr_crit("md/raid10:%s: Disk failure on %pg, disabling device.\n"
+			"md/raid10:%s: Operation continuing on %d devices.\n",
+			mdname(mddev), rdev->bdev,
+			mdname(mddev), conf->geo.raid_disks - mddev->degraded);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
-	pr_crit("md/raid10:%s: Disk failure on %pg, disabling device.\n"
-		"md/raid10:%s: Operation continuing on %d devices.\n",
-		mdname(mddev), rdev->bdev,
-		mdname(mddev), conf->geo.raid_disks - mddev->degraded);
 }
 
 static void print_conf(struct r10conf *conf)
-- 
2.50.1

