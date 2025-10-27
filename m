Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CDD2D239B
	for <linux-raid@vger.kernel.org>; Mon, 27 Oct 2025 15:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577515; cv=none; b=ReZ+V6roPwH8P9hSwBTfgRQmL9qLLWfKHwvARc2rFz/vsdtZvn9bGgMrGMoQHOyL8PwtsMOSOVyslnL/YtD7LYOUIGfC4tx8JfmEhA1JubZCJEsjnRaEyn3CCVRjnSAp/E8QO3HSXO+7smyK/ZqTD2ap0AYH0bpvf0nf5sdiHGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577515; c=relaxed/simple;
	bh=OH15Aq+Clj5xSexBAO1h+CHcIuQr2ufEWKDyJyyneYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMLrKdRFZlO9qmdkmHJaKyn+iFwdQH9hFGlVuE8CLVdH+MD2PIm+Oec0p38HTxpmj4J+EvH/dAIN5jjeQnvAkaTKoRmWy+lxojxhmED4EPxjGYAeagOnnMaGJlGjOjhOnbxGYnhsPTarIunfoXTjzZH1Uxn+4hYFBwr8zK/OUFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=RFaogUd+; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="RFaogUd+"
Received: from fedora (p3796170-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [180.53.173.170])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 59RF4hAm090988
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 28 Oct 2025 00:04:46 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=sjnrPdwTQvOQOWTy7vKYqQILbsOONjoFMJ39ZWT0xhI=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1761577486; v=1;
        b=RFaogUd+fZM4Sn/bLWPJd/YtyKeu6pDdVB9qfvbQWGVgYeS2Gy7f6yNcbRcZoujb
         /dfA3nuhuj/kv1cBy6O0IAX14AuFRr27IYLB18f5z3tbtjx0Juvv6fvisZoWV62P
         2GJJuUfb6yPdviUAujSLQlzKHlrlc8GV1sAIoW1RwDiJvPKk0C9EXRV2hVdx1bW4
         CnD4wFwz/eMUkTHYFOvomllPnQ/8lRAn9p+bpI4tyXalYue68Ttf5nFXDBOXpPsO
         PwMqKgfSA7kJZjH7yleTXMNPAKjCRhJaASuj7BjBkHpjWhK4H93ApPYaXKqHcdJ4
         kXzyjl37xbQ9R61rpteUvA==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
        Shaohua Li <shli@fb.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v5 12/16] md/raid10: Prevent set MD_BROKEN on failfast bio failure
Date: Tue, 28 Oct 2025 00:04:29 +0900
Message-ID: <20251027150433.18193-13-k@mgml.me>
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
 drivers/md/raid10.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1dd27b9ef48e..aa9d328fe875 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -497,7 +497,7 @@ static void raid10_end_write_request(struct bio *bio)
 			dec_rdev = 0;
 			if (test_bit(FailFast, &rdev->flags) &&
 			    (bio->bi_opf & MD_FAILFAST)) {
-				md_error(rdev->mddev, rdev);
+				md_cond_error(rdev->mddev, rdev, bio);
 			}
 
 			/*
@@ -2434,7 +2434,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 				continue;
 		} else if (test_bit(FailFast, &rdev->flags)) {
 			/* Just give up on this device */
-			md_error(rdev->mddev, rdev);
+			md_cond_error(rdev->mddev, rdev, r10_bio->devs[i].bio);
 			continue;
 		}
 		/* Ok, we need to write this bio, either to correct an
@@ -2877,19 +2877,19 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	 * frozen.
 	 */
 	bio = r10_bio->devs[slot].bio;
-	bio_put(bio);
 	r10_bio->devs[slot].bio = NULL;
 
 	if (mddev->ro) {
 		r10_bio->devs[slot].bio = IO_BLOCKED;
 	} else if (test_bit(FailFast, &rdev->flags)) {
-		md_error(mddev, rdev);
+		md_cond_error(mddev, rdev, bio);
 	} else {
 		freeze_array(conf, 1);
 		fix_read_error(conf, mddev, r10_bio);
 		unfreeze_array(conf);
 	}
 
+	bio_put(bio);
 	rdev_dec_pending(rdev, mddev);
 	r10_bio->state = 0;
 	raid10_read_request(mddev, r10_bio->master_bio, r10_bio, false);
-- 
2.50.1

