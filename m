Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C98C288529;
	Sun, 17 Aug 2025 17:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755451681; cv=none; b=uq/SLnp6rY6ryAuYfUHFXHGagvYKLHSGyl3YneLlJ8G3WpdXcyTKvsvD2VWWfyytW2g+1mYRpSTP4FQDL6aq2FjHqywPWwQnheosLNYCIhsrYJZSK/eGGY++bHtbHTdC+kugDRqOW2qAJGryilA0cgFIFCmzw4I1kC6Va7LE+ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755451681; c=relaxed/simple;
	bh=uoYhrh+m612yzI8ZFfZPJTHL7CBMw2GuwTCMBpz5gzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSbtEKIdU6aPtyKkWeS05ItGdtRqD+1MLMJ7cWKnZ59gXHkl8Cr+26QNn325oG48XNlicucmsm6PIfS4Tg8OZIuh8nOWIish/67o13OSxaOPExJYPZhs+2cseQ6nWGz9Pt9FfLLeeywAqUY5KOdKJ6O6A39iJEpVEp7Nygi2heM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=FKOrxjZZ; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="FKOrxjZZ"
Received: from fedora (p3174069-ipxg00b01tokaisakaetozai.aichi.ocn.ne.jp [122.23.47.69])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 57HHRM9c012978
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 18 Aug 2025 02:27:26 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=MH9vy6rYe7vGbhOVsU6TyfbGDjZsv4N720IoAuYTSDA=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1755451646; v=1;
        b=FKOrxjZZhCKap2D3O7j2e3FcIgToSnC5oj+zqvnb3my5DdyW1lSB1GEmrHx16ufg
         bwpxkr9oEO1b+DLvB73iW3C7ZVCJq9O/CODuhuoTRFWKhggbeTsa0lF8+QmhjzUj
         pPyyW9opJOFMyG96SfkeJsAqFdJc8lns6feAlPoV0AsPM456B/jXd0ZufKvZASZY
         zHBM1i2bBUVICKo02rOjfyHFQQnpj9XEan2Jjza1T/i7Rem8Pzl5a+pCONiVEY2p
         X1DQUqVP490eIvYD+FHaVlMFLK0gYCd/L6Yj8F2IzYoiY5qtfi6PDFhSKMvr/Mp7
         xVzUqMg/9cB26V/Rrfn7Ew==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v2 3/3] md/raid1,raid10: Fix: Operation continuing on 0 devices.
Date: Mon, 18 Aug 2025 02:27:10 +0900
Message-ID: <20250817172710.4892-4-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250817172710.4892-1-k@mgml.me>
References: <20250817172710.4892-1-k@mgml.me>
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
index 007e825c2e07..095a0dbb5167 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1783,6 +1783,11 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
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
@@ -1790,10 +1795,6 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
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
index 07248142ac52..407edf1b9708 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2034,11 +2034,12 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
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

