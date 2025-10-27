Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BA23090E6
	for <linux-raid@vger.kernel.org>; Mon, 27 Oct 2025 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577518; cv=none; b=ee+BLxcuJyyDiEp8co3xlExMYMQD+X7ne76DZyHHMiL3TPU+13WWEvPwaHg7Ggoga3a4BJhL+Xz9OA6OtkSJBCrlaPzFvSRr0ecS8dgXfmSyPowpu3K2PnBfDmIIlhbHDkHrVFvNHpVrjuv3BE2wtAfCAto/+7rDoqF1xpCFG2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577518; c=relaxed/simple;
	bh=5MA3ZBCVJJ5e4pS05xjKTX4sHoI6tdxVpG1jhKcLKCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EygFdqwu7bjU0AMSNegc/JNDVcwjuaC0e7EZiiDWKfJo9KkpcaAd/X+w+CkbZy0i8f4ztEuGPHBUaQfq7iXFS20c7I714sKPpXvawvv0CwjgaSb9IPMaUKZEAIjEMa24q95QDQ7aim+v7wFZEsOJOEr4i+bEROfYlKFGWcvQHK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=qrU32495; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="qrU32495"
Received: from fedora (p3796170-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [180.53.173.170])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 59RF4hAk090988
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 28 Oct 2025 00:04:46 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=wIhDgBY9Enp3YXKyeTsXx8BAoA1MnZsmwspGz/LyDDM=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1761577486; v=1;
        b=qrU32495ZL9y5M/JvDEK5Rhyl/PlrnA1MRjYBi/NSUZcR+xsKGrC/RfU4vE5bblF
         4JU4wruCzCkxSTm2Tte6vSyUhV5CHR5oy68OSMvtRUlAgrTTE2e8bB8BLXqmyq5i
         H6R3FFxENzF/E41iYMWsIkOBtS6Mbp4q2DbpRS+CW+/4t6T30scevZc3ffDySK9U
         5Pv4mi0t3NqcyZzTrJUOpzveUCx8srz+O6jImeaUv2/epKQ6vFLLyCdSTLc5lQMu
         nma+CUk5sfbzytvk9zPLpnm0qMDMX367ch/LrpK2Luj1v0zoSh+qS0CnnJprmzZG
         ymXNKNfAGBlLL3s4g6+nsA==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
        Shaohua Li <shli@fb.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v5 10/16] md: prevent set MD_BROKEN on super_write failure with failfast
Date: Tue, 28 Oct 2025 00:04:27 +0900
Message-ID: <20251027150433.18193-11-k@mgml.me>
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
with the introduction of MD_BROKEN in RAID1/RAID10 in commit 9631abdbf406
("md: Set MD_BROKEN for RAID1 and RAID10"), calling md_error for the last
rdev now prevents further writes to the array. Despite this, the current
failfast error handler still assumes that calling md_error will not break
the array.

Normally, this is not an issue because MD_FAILFAST is not set when a bio
is issued to the last rdev. However, if the array is not degraded and a
bio with MD_FAILFAST has been issued, simultaneous failures could
potentially break the array. This is unusual but can happen; for example,
this can occur when using NVMe over TCP if all rdevs depend on a single
Ethernet link.

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

This commit fixes a second of read cases. Ensure that a failfast metadata
write does not mark the last rdev as faulty or set MD_BROKEN on the
array.

Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
Fixes: 9a567843f7ce ("md: allow last device to be forcibly removed from RAID1/RAID10.")
Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/md.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e33ab564f26b..3c3f5703531b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1060,8 +1060,7 @@ static void super_written(struct bio *bio)
 	if (bio->bi_status) {
 		pr_err("md: %s gets error=%d\n", __func__,
 		       blk_status_to_errno(bio->bi_status));
-		md_error(mddev, rdev);
-		if (!test_bit(Faulty, &rdev->flags)
+		if (!md_cond_error(mddev, rdev, bio)
 		    && (bio->bi_opf & MD_FAILFAST)) {
 			set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
 			set_bit(LastDev, &rdev->flags);
-- 
2.50.1

