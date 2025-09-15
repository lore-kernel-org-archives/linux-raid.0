Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B6320A5DD
	for <linux-raid@vger.kernel.org>; Mon, 15 Sep 2025 03:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757908121; cv=none; b=Wevzho6UOebjKWcqQCLcLY3YREhH+kgh3QWaAnbExrVgG/ezUFqVOu1vT72ZD9eZJpvL/kLCeQoVxJ8dcI9W20SPJMmhIwp5coGc+Vo9xKMdOsQ9Tq7Q24NaOf0drhaaDsU+V5LNauqFfZ5hh1t45F/4xkxn783GEr4zD5I9Bcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757908121; c=relaxed/simple;
	bh=0BuXaIhXy4G65WMnbZc0qJEgqyZFyu+URXPBWPnUEgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrvLuodBtrA6PDlvS2msK1h+3Mwsdu6e9FpatwJZHCnGeoVfjaCtDWhluCw4TFDF5udzrncgIpqzl5ZJv5IaIcJqiwmz4TAiW9YH7TLF2HSgXpnydzozI6k8uvpbZQBSSFlrYxf7Wf7Q+RYUW5gymzPUfCM8TNtD/Dt3Wb7JEn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=hCN3+R70; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="hCN3+R70"
Received: from fedora (p4504123-ipxg00s01tokaisakaetozai.aichi.ocn.ne.jp [114.172.113.123])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58F3gpZq004256
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 15 Sep 2025 12:43:17 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=LpQfTwt0Pqfiz1reZkxCSBjCcgZybFuCZ+NkVasMgPc=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1757907797; v=1;
        b=hCN3+R70BIWFFdxoEL3msRz4tEwvZSXjC3+akKIzMekeaExya/c0CC2jnyGAjwf+
         K6z7nFn8vAOSKLKhBTFJM8ej1C05EpsfvrnDxmC1XORT6z5QgA3SiykZ+yJehqx8
         tKylEWYVPb914sfcbS0LVtX0PoWxvDIa0pYowhC+OUt+M7B9KWgSXr8fUC1yE5mA
         nnIYEzJiD84EQcJN3J61+rZqdSvGgqChknYCgzNw1Y+rPdO3uHouc3N5Pn0qNhQU
         FepFusttzkNKFzdUax5cU55Fs8YphfNbEJxZPLo8RlcL+QKP2H8h0cg40eBdMhdl
         B6aMosimTHg7SWbbOkEfBw==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>, Shaohua Li <shli@fb.com>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v4 9/9] md/raid1,raid10: Fix: Operation continuing on 0 devices.
Date: Mon, 15 Sep 2025 12:42:10 +0900
Message-ID: <20250915034210.8533-10-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250915034210.8533-1-k@mgml.me>
References: <20250915034210.8533-1-k@mgml.me>
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
index febe2849a71a..b3c845855841 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1803,6 +1803,11 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 		update_lastdev(conf);
 	}
 	set_bit(Faulty, &rdev->flags);
+	if ((conf->raid_disks - mddev->degraded) > 0)
+		pr_crit("md/raid1:%s: Disk failure on %pg, disabling device.\n"
+			"md/raid1:%s: Operation continuing on %d devices.\n",
+			mdname(mddev), rdev->bdev,
+			mdname(mddev), conf->raid_disks - mddev->degraded);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 	/*
 	 * if recovery is running, make sure it aborts.
@@ -1810,10 +1815,6 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
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
index be5fd77da3e1..4f3ef43ebd2a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2059,11 +2059,12 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
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

