Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2FB3090C2
	for <linux-raid@vger.kernel.org>; Mon, 27 Oct 2025 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577517; cv=none; b=kPRFaWMKeodcNdsldcOWrujNtJXm2vZx5qt6qZmDXZ5ByWpJEaao6OS+c1vqOcrr6zBtakBc0iMY8EMtDYDf23JnFhSGoys8s6nWzbtbGaCuHU8ueRBX7Pa4VEUZELH0fnZ//mb014fXC4Hoqg7JjZ2Q0ePGqfwaDzg5zJ/Zj7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577517; c=relaxed/simple;
	bh=JftAzuJvItUdTzJGOjax1orfbl6WY88s1ki2ITRQhm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ti4jAgEcacz5bLPVNzTRneQB9M6mofU4DeMpW2r08L66sLQ1HlRXc+VQg5zCOyENTLHCi6f7zL/B7SMidnvfoFscNZdCzimmDT5TK0YiBNI8pRz13t8HamaB32WsBkvcR77Qwb6ZXC4UhnAXklmWIhrhkC6bqyYSTvOpVwL/q/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=KvCLLbTt; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="KvCLLbTt"
Received: from fedora (p3796170-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [180.53.173.170])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 59RF4hAe090988
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 28 Oct 2025 00:04:45 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=J14c/B9Favd/mX6dP+sPNqMYNuSw3DFvUvW1zTATqCA=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1761577485; v=1;
        b=KvCLLbTtt1cVehdqV5PiQPPTHsAXF6EA44jHDd1nQ+3dtCVk45xZ/rMfAjjrfwFd
         MvKLh147T8yyWamY74/Ii4onnT/CagE6UpUIHJXqpKiZwppvZgP0CLtkoO7G0xvo
         CsuNnKF2egiuNWMwoVbnJTeAEffjRlZYpWT5BVuHm57qY2FqzMl9ziY6IXRL+mhT
         zN15RqIRJhZ/bCPcnMYUWQbOMaDGGN5KjNaycjmlKLEK9EEIw+9FXA/BAtUproK4
         FY+nP1egM7N4zeCLn39cnvVrghoAxKZo39/bsYAKeJ5yJffn39P6bRxI6Tx55VeI
         BNX5c2d55yETg9s+EYoUFA==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
        Shaohua Li <shli@fb.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v5 04/16] md: introduce md_cond_error()
Date: Tue, 28 Oct 2025 00:04:21 +0900
Message-ID: <20251027150433.18193-5-k@mgml.me>
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

The failfast feature in RAID1 and RAID10 assumes that when md_error() is
called, the array remains functional because the last rdev neither fails
nor sets MD_BROKEN.

However, the current implementation can cause the array to lose
its last in-sync device or be marked as MD_BROKEN, which breaks the
assumption and can lead to array failure.

To address this issue, introduce md_cond_error() that handles failfast
bio errors without stopped the array. This function checks whether the
array will become inoperable if a rdev fails, and if so, it skips
error handling to ensure the array remains in an operational state.

Callers of md_error() will be updated to use this new function in
subsequent commits to properly handle failfast scenarios.

Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/md.c | 33 +++++++++++++++++++++++++++++++++
 drivers/md/md.h |  1 +
 2 files changed, 34 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4ad9cb0ac98c..e33ab564f26b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8479,6 +8479,39 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 }
 EXPORT_SYMBOL(md_error);
 
+/** md_cond_error() - conditionally md_error()
+ * @mddev: affected md device
+ * @rdev: member device to fail
+ * @bio: bio whose triggered device failure
+ *
+ * Check if the personality wants to fail this rdev for this bio,
+ * and if so, call _md_error().
+ * This function has no different behavior from md_error except
+ * for the raid1/10 with failfast enabled rdevs.
+ *
+ * Returns: %true if rdev already or become Faulty, %false if not.
+ */
+bool md_cond_error(struct mddev *mddev, struct md_rdev *rdev, struct bio *bio)
+{
+	if (WARN_ON_ONCE(!mddev->pers))
+		/* return true because we don't want caller to retry */
+		return true;
+
+	spin_lock(&mddev->device_lock);
+
+	if (mddev->pers->should_error &&
+	    !mddev->pers->should_error(mddev, rdev, bio)) {
+		spin_unlock(&mddev->device_lock);
+		return test_bit(Faulty, &rdev->flags);
+	}
+
+	_md_error(mddev, rdev);
+	spin_unlock(&mddev->device_lock);
+
+	return !WARN_ON_ONCE(!test_bit(Faulty, &rdev->flags));
+}
+EXPORT_SYMBOL(md_cond_error);
+
 /* seq_file implementation /proc/mdstat */
 
 static void status_unused(struct seq_file *seq)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 01c8182431d1..38f9874538a6 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -916,6 +916,7 @@ extern void md_write_end(struct mddev *mddev);
 extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
 void _md_error(struct mddev *mddev, struct md_rdev *rdev);
 extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
+extern bool md_cond_error(struct mddev *mddev, struct md_rdev *rdev, struct bio *bio);
 extern void md_finish_reshape(struct mddev *mddev);
 void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 			struct bio *bio, sector_t start, sector_t size);
-- 
2.50.1

