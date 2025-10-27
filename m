Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AE43090DE
	for <linux-raid@vger.kernel.org>; Mon, 27 Oct 2025 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577518; cv=none; b=j97pXUepZjBl2cEz6VmUn9u63gzZFxmvHY0T93lsth3vnBkcs4pzwPNVm9Ix+kCBfnViaTM+YXg4FmuCstt4K96aDcJD9t0V6vg3dUiS+me4IeItun3VQPXZ6nOAraqItKC2oRX5ecqHwO0TwGMEnY+V/Fdp16v/GVY3fKfTqqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577518; c=relaxed/simple;
	bh=dSny0q8Vpr/7wchAfKqnsLC1CPOwBAyvKvG9yt4alcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0u4BWMBZj3+1jQ2QjuGWC1EGm1F1LSsuxlmBVsxDMZWu0aGKwLISDTu7A7N4C7piETecWcS4B1f7DUJdN7JPJ6y0Ov0Sw/MoXjHlotW1Uw2edIcCwRxUZKJOc48vw2JyTb0nqEToRdW8XDVT3wQiu7MnVmVmC7Tl4cT3wCC6es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=EVRfl0WY; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="EVRfl0WY"
Received: from fedora (p3796170-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [180.53.173.170])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 59RF4hAl090988
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 28 Oct 2025 00:04:46 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=FgA+SMwL9yI/ePad9bDVhfEqymOfjz+gNzLHUmDWcLo=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1761577486; v=1;
        b=EVRfl0WYA1819y3N75Clc+TFE9hCot/EwuHA/qRGKz+NEMRVRipIh3IARExWJfjb
         25ouHdK4orElRc+eYFgDkt24xTOAuVmu9F92olaN3I6wRLej/AaL1hEfAO7JCuYX
         pSff+zdvkx8T/V9x7YPsdQv7CO5r83NBySZtOKVyl6zMpesxq+XhQk7apvXyczyG
         uILDneeDmMBrSzZ+WAbvxWxNN0wCZ5JOF02tSt07sCP62OxhD4A3g01nAxihJsv3
         AGgJLpYYolrMb48CFCV+kstYZU9W4FFpjORpnVZkYNQaW2hyHIJCAWI4xgZWRDPy
         BX9lp5CE+iGLW0j34y9z8Q==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
        Shaohua Li <shli@fb.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v5 11/16] md/raid1: Prevent set MD_BROKEN on failfast bio failure
Date: Tue, 28 Oct 2025 00:04:28 +0900
Message-ID: <20251027150433.18193-12-k@mgml.me>
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

Failfast is a feature implemented only for RAID1 and RAID10. It instructs
the block device providing the rdev to immediately return a bio error
without retrying if any issue occurs. This allows quickly detaching a
problematic rdev and minimizes IO latency.

Due to its nature, failfast bios can fail easily, and md must not mark
an essential rdev as Faulty or set MD_BROKEN on the array just because
a failfast bio failed.

When failfast was introduced, RAID1 and RAID10 were designed to continue
operating normally even if md_error was called for the last rdev. However,
with the introduction of MD_BROKEN in RAID1/RAID10
in commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"), calling
md_error for the last rdev now prevents further writes to the array.
Despite this, the current failfast error handler still assumes that
calling md_error will not break the array.

Normally, this is not an issue because MD_FAILFAST is not set when a bio
is issued to the last rdev. However, if the array is not degraded and a
bio with MD_FAILFAST has been issued, simultaneous failures could
potentially break the array. This is unusual but can happen; for example,
this can occur when using NVMe over TCP if all rdevs depend on
a single Ethernet link.

In other words, this becomes a problem under the following conditions:
Preconditions:
* Failfast is enabled on all rdevs.
* All rdevs are In_sync - This is a requirement for bio to be submit
  with MD_FAILFAST.
* At least one bio has been submitted but has not yet completed.

Trigger condition:
* All underlying devices of the rdevs return an error for their failfast
  bios.

Whether the bio is read or write, eventually both rdevs will be lost.
In the write case, md_error is invoked on each rdev through its
bi_end_io handler. In the read case, if bio has been issued to multiple
rdevs via read_balance, it will be the same as write. Even in the read
case where only a single rdev has bio issued, both rdevs will be lost in
the following sequence:
1. losing the first rdev triggers a metadata update
2. md_super_write issues the bio with MD_FAILFAST, causing the bio to
   fail immediately. md_super_write always issues MD_FAILFAST bio if
rdev has FailFast, regardless of whether there are other rdevs or not.
3. md_super_write issued bio failed, so super_written calls md_error on
   the remaining rdev.

This commit fixes the write case and first of read cases. Ensure that a
failfast bio failure will not cause the last rdev to become faulty or
the array to be marked MD_BROKEN.

The second of read, i.e., failure of metadata update, has already been
fixed in the previous commit.

Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/raid1.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a70ca6bc28f3..bf96ae78a8b1 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -470,7 +470,7 @@ static void raid1_end_write_request(struct bio *bio)
 		    (bio->bi_opf & MD_FAILFAST) &&
 		    /* We never try FailFast to WriteMostly devices */
 		    !test_bit(WriteMostly, &rdev->flags)) {
-			md_error(r1_bio->mddev, rdev);
+			md_cond_error(r1_bio->mddev, rdev, bio);
 		}
 
 		/*
@@ -2177,8 +2177,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 	if (test_bit(FailFast, &rdev->flags)) {
 		/* Don't try recovering from here - just fail it
 		 * ... unless it is the last working device of course */
-		md_error(mddev, rdev);
-		if (test_bit(Faulty, &rdev->flags))
+		if (md_cond_error(mddev, rdev, bio))
 			/* Don't try to read from here, but make sure
 			 * put_buf does it's thing
 			 */
@@ -2671,20 +2670,20 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	 */
 
 	bio = r1_bio->bios[r1_bio->read_disk];
-	bio_put(bio);
 	r1_bio->bios[r1_bio->read_disk] = NULL;
 
 	rdev = conf->mirrors[r1_bio->read_disk].rdev;
 	if (mddev->ro) {
 		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
 	} else if (test_bit(FailFast, &rdev->flags)) {
-		md_error(mddev, rdev);
+		md_cond_error(mddev, rdev, bio);
 	} else {
 		freeze_array(conf, 1);
 		fix_read_error(conf, r1_bio);
 		unfreeze_array(conf);
 	}
 
+	bio_put(bio);
 	rdev_dec_pending(rdev, conf->mddev);
 	sector = r1_bio->sector;
 
-- 
2.50.1

