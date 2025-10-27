Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F223019A3
	for <linux-raid@vger.kernel.org>; Mon, 27 Oct 2025 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577518; cv=none; b=ZgdOVzyYRV1zlCt/DSI4+KtzEwOp+ZhChbAjoT7wqjYstJK4bnighzoxvR9N+u0xzDb3gYizbcFizplVMYKWdflMBu/ihvvBHEwGd6rFBL0/BwEofQ5DAcutuZQrkBW4EfWbN1b2jua352KdDXJOU1j/8M5Vc5Zqn6ZsnFSi+18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577518; c=relaxed/simple;
	bh=DWXAcebOnNsq25q914zeSgdReXvvjkAY4JV6otpWaE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2t7w3uP4h4XvX9Sq8XJcHdCkXnBrQ6GbwU0rTCtOp6Y7iRm29UuOY38S4rCxm7toXfcPNfkJ/KONIa+Arl99+Dye1fKbBewody8j6FuT0sHRwS3RXSQXOCK1vS4MZWd9NVb9Xax2xOpQpkpQFP1Lf63uCtIZ5R01R1hsS86ZRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=hcK4ocpK; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="hcK4ocpK"
Received: from fedora (p3796170-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [180.53.173.170])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 59RF4hAh090988
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 28 Oct 2025 00:04:46 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=8Q0DS9pACMqRNvuXPGJkIpcAMLX9xqEbDvafPHKZnJ0=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1761577486; v=1;
        b=hcK4ocpKIVCPUr+euDKYvuXpDRYlDLtKeGRQFPrhsUDNOje9B5J13d1GkjVfH+cN
         Zzn9Igx4E7JtYQGMnpIInQdsPfN+zghXLGBoeb37urZ18jukczdTNWp1teArjP47
         TiouQFQYQFOHrQFEh55vsLqIKuSZuPIQ0SGzGp6vKSo+YxrkyFe2OQ/JqiWmZPJJ
         KWQDTGekbXrkTZE705w3C7uB097wm+lKcC6Kh6c8UJl11O4SIZIlX2TL19i2EJ8C
         tzgEgEc1Vl7Ns+aJCN4Q1ZEsbvRWPnWEIEn3AXVwLc2WE9+bG4EtcpvzXzCC0HcR
         icNxYJkh4ZcOPLPcLko57Q==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
        Shaohua Li <shli@fb.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v5 07/16] md/raid1: refactor handle_read_error()
Date: Tue, 28 Oct 2025 00:04:24 +0900
Message-ID: <20251027150433.18193-8-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251027150433.18193-1-k@mgml.me>
References: <20251027150433.18193-1-k@mgml.me>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the failfast bio feature, the behavior of handle_read_error() will
be changed in a subsequent commit, but refactor it first.

This commit only refactors the code without functional changes. A
subsequent commit will replace md_error() with md_cond_error()
to implement proper failfast error handling.

Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/raid1.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 69b7730f3875..a70ca6bc28f3 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2675,24 +2675,22 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	r1_bio->bios[r1_bio->read_disk] = NULL;
 
 	rdev = conf->mirrors[r1_bio->read_disk].rdev;
-	if (mddev->ro == 0
-	    && !test_bit(FailFast, &rdev->flags)) {
+	if (mddev->ro) {
+		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
+	} else if (test_bit(FailFast, &rdev->flags)) {
+		md_error(mddev, rdev);
+	} else {
 		freeze_array(conf, 1);
 		fix_read_error(conf, r1_bio);
 		unfreeze_array(conf);
-	} else if (mddev->ro == 0 && test_bit(FailFast, &rdev->flags)) {
-		md_error(mddev, rdev);
-	} else {
-		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
 	}
 
 	rdev_dec_pending(rdev, conf->mddev);
 	sector = r1_bio->sector;
-	bio = r1_bio->master_bio;
 
 	/* Reuse the old r1_bio so that the IO_BLOCKED settings are preserved */
 	r1_bio->state = 0;
-	raid1_read_request(mddev, bio, r1_bio->sectors, r1_bio);
+	raid1_read_request(mddev, r1_bio->master_bio, r1_bio->sectors, r1_bio);
 	allow_barrier(conf, sector);
 }
 
-- 
2.50.1

