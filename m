Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC533093B5
	for <linux-raid@vger.kernel.org>; Mon,  5 Jan 2026 14:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767624099; cv=none; b=X19XZlVHjjl/XELPbCBk7FYtsdmzsI14k7D/R4nPPRrJAZM00ptGrRTmh/TMDSOzfnQ2qu+4qSQ9vHIVUAvTMK744ZKfM0Elxqu7QbwhIjasjQZh26YVdmvVdGZ9nMo0QD1moLX+l0vR5MkHnLy4UD0M46uPpiKiQfh7gB9pSWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767624099; c=relaxed/simple;
	bh=F06hzjZQ0WEGVhwTlRepJ4dPvS5CTlGogzKYVE4LWl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iV8rMJ1kqZb3BUn3Cjtpqebp/Qex9iPdMLPDJYRxQrZtm2JYrPIOv4a7eYRupekmnotfGhoicwrqWLJRPt2ZCHgTBKwNSv130pBlGw+yeYuZv/qMRRb2eagmYJ/br5BfQQ8RvYW9F6z+TQcHU+fsey1Ti9uwdk9/gCDSMiGB+RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=PpjVmug4; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="PpjVmug4"
Received: from fedora (p3411048-ipxg00d01tokaisakaetozai.aichi.ocn.ne.jp [114.157.12.48])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 605Eenob052549
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 5 Jan 2026 23:41:02 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=MB9AIP0t2LUP+IzYF+5HmygSlbCHSoUfxVscAlh0aGU=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1767624062; v=1;
        b=PpjVmug46PMuZjlnbkNpicZfZGK0RFUgHxSZpQSPZq+MgSw8HQYI/Zz2PGEcC714
         C154yANXxUG4tHlDozwgcSQqkDr4ddQlLgf6rx9tRtjp+NRxVUuL9iIOlS/e/9tl
         WcUkOtdVJuR7vCq6YwcSCwo1+6OomhFMCd5MbgCA3v5lX14vzA1fGTEBMe/C4Vyr
         mlCh1EoU3hyf2v+s99BfItX1C82Xlbhd0XgsNujzZNuFRTv1ObHTNj8d4wS0ALPr
         C8+P0SGOLjOeT15mhE0XslxPuyAIWc4xBtJyT/Vjnw8R4iDBglSi8TrPdSCPEKWG
         4hTrX4zAw68EExqT2lzSmQ==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
        Shaohua Li <shli@fb.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v6 1/2] md: Don't set MD_BROKEN for RAID1 and RAID10 when using FailFast
Date: Mon,  5 Jan 2026 23:40:24 +0900
Message-ID: <20260105144025.12478-2-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260105144025.12478-1-k@mgml.me>
References: <20260105144025.12478-1-k@mgml.me>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
if the error handler is called on the last rdev in RAID1 or RAID10,
the MD_BROKEN flag will be set on that mddev.
When MD_BROKEN is set, write bios to the md will result in an I/O error.

This causes a problem when using FailFast.
The current implementation of FailFast expects the array to continue
functioning without issues even after calling md_error for the last
rdev.  Furthermore, due to the nature of its functionality, FailFast may
call md_error on all rdevs of the md. Even if retrying I/O on an rdev
would succeed, it first calls md_error before retrying.

To fix this issue, this commit ensures that for RAID1 and RAID10, if the
last In_sync rdev has the FailFast flag set and the mddev's fail_last_dev
is off, the MD_BROKEN flag will not be set on that mddev.

This change impacts userspace. After this commit, If the rdev has the
FailFast flag, the mddev never broken even if the failing bio is not
FailFast. However, it's unlikely that any setup using FailFast expects
the array to halt when md_error is called on the last rdev.

Since FailFast is only implemented for RAID1 and RAID10, no changes are
needed for other personalities.

Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
Suggested-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/md.c     | 6 ++++--
 drivers/md/raid1.c  | 8 +++++++-
 drivers/md/raid10.c | 8 +++++++-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6062e0deb616..f1745f8921fc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3050,7 +3050,8 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 	if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
 		md_error(rdev->mddev, rdev);
 
-		if (test_bit(MD_BROKEN, &rdev->mddev->flags))
+		if (test_bit(MD_BROKEN, &rdev->mddev->flags) ||
+		    !test_bit(Faulty, &rdev->flags))
 			err = -EBUSY;
 		else
 			err = 0;
@@ -7915,7 +7916,8 @@ static int set_disk_faulty(struct mddev *mddev, dev_t dev)
 		err =  -ENODEV;
 	else {
 		md_error(mddev, rdev);
-		if (test_bit(MD_BROKEN, &mddev->flags))
+		if (test_bit(MD_BROKEN, &mddev->flags) ||
+		    !test_bit(Faulty, &rdev->flags))
 			err = -EBUSY;
 	}
 	rcu_read_unlock();
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 592a40233004..459b34cd358b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1745,6 +1745,10 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
  *	- recovery is interrupted.
  *	- &mddev->degraded is bumped.
  *
+ * If the following conditions are met, @mddev never fails:
+ *	- The last In_sync @rdev has the &FailFast flag set.
+ *	- &mddev->fail_last_dev is off.
+ *
  * @rdev is marked as &Faulty excluding case when array is failed and
  * &mddev->fail_last_dev is off.
  */
@@ -1757,7 +1761,9 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 
 	if (test_bit(In_sync, &rdev->flags) &&
 	    (conf->raid_disks - mddev->degraded) == 1) {
-		set_bit(MD_BROKEN, &mddev->flags);
+		if (!test_bit(FailFast, &rdev->flags) ||
+		    mddev->fail_last_dev)
+			set_bit(MD_BROKEN, &mddev->flags);
 
 		if (!mddev->fail_last_dev) {
 			conf->recovery_disabled = mddev->recovery_disabled;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 14dcd5142eb4..b33149aa5b29 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1989,6 +1989,10 @@ static int enough(struct r10conf *conf, int ignore)
  *	- recovery is interrupted.
  *	- &mddev->degraded is bumped.
  *
+ * If the following conditions are met, @mddev never fails:
+ *	- The last In_sync @rdev has the &FailFast flag set.
+ *	- &mddev->fail_last_dev is off.
+ *
  * @rdev is marked as &Faulty excluding case when array is failed and
  * &mddev->fail_last_dev is off.
  */
@@ -2000,7 +2004,9 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 	spin_lock_irqsave(&conf->device_lock, flags);
 
 	if (test_bit(In_sync, &rdev->flags) && !enough(conf, rdev->raid_disk)) {
-		set_bit(MD_BROKEN, &mddev->flags);
+		if (!test_bit(FailFast, &rdev->flags) ||
+		    mddev->fail_last_dev)
+			set_bit(MD_BROKEN, &mddev->flags);
 
 		if (!mddev->fail_last_dev) {
 			spin_unlock_irqrestore(&conf->device_lock, flags);
-- 
2.50.1

