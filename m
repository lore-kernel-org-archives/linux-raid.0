Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3A02E7645
	for <linux-raid@vger.kernel.org>; Mon, 27 Oct 2025 15:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577516; cv=none; b=RKt4TVKga2S0Ipz0HH5ftVI2qFG7U0oMtqF7a7iDK94SBaF6JbFkSTFz8NYFpN0Y2P3/EtUryzAckY3Q1mKhVMlS/JlKRaxsmD11DAeQHGHTS9dIsMDbNVgAQ2OYMd/5q3bRXGzpUdz3SYfvJ0nSrCBYJFkwhykfC+UcZgOn9qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577516; c=relaxed/simple;
	bh=NCSVD5pdhokkZMeJ2d4TLtTyzKAOCn9PZfnvyBmp+ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akoBjEYGQpWoUg+A1GBdiKBVVqdUCQCksjyxrIt7xROCjvCJqE1EKK5bBJRjjPJ0HWqamUTn2yWB1CNfJu3m5rWNmXJ7xGLM3bMbv7olWLkjjRMnVDB1wogkXFcDA6gPJ+jm8ytEee68HTBN6cL+mEiGdCAg1oWU6c2AvW9yu8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=qwVN65Pq; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="qwVN65Pq"
Received: from fedora (p3796170-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [180.53.173.170])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 59RF4hAg090988
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 28 Oct 2025 00:04:46 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=rED3C2j/XTprLxpQLKH9JWsM1LFO3rk8cgg9si00nUA=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1761577486; v=1;
        b=qwVN65PqpPXLDS0qjHoEUdm5pwL18bjIcsoUcDYRSgJHoS917MvYumn5X7yoeFA4
         HurXMQTfH80ebiW23EhCVUGI7ohCuETYWIL+0r43CzQEazxAVEuchK6EqBGeETAA
         VuSG82PjR1AsoVAHK/+/WaNyXHtu3hmVQeiYHgqtHzRJM22snQbWcpvYxqAsoqKG
         PfHadLJVm77JyWesaY4V3fzfpJqkY61vqRJnbY4sGTAL50zwbaE0+tdDz2tr5sgb
         5lqNpBTLGi3PtEiGwRn31OfZxGwZol09UAyQM6bjFn80Zdt6v4bspDT2Rc8VJdF4
         S2dQotExAoHlzWQMsTU42A==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
        Shaohua Li <shli@fb.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v5 06/16] md/raid10: implement pers->should_error()
Date: Tue, 28 Oct 2025 00:04:23 +0900
Message-ID: <20251027150433.18193-7-k@mgml.me>
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

However, the current implementation can cause the array to lose its last
in-sync device or be marked as MD_BROKEN, which breaks the assumption
and can lead to array failure.

To address this issue, introduce a new handler, md_cond_error(), to
ensure that failfast I/O does not mark the array as broken.

md_cond_error() checks whether a device should be faulted based on
pers->should_error(). This commit implements should_error() callback for
raid10 personality, which returns true if faulting the specified rdev
would cause the mddev to become non-functional.

Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/raid10.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 25c0ab09807b..68dbab7b360b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1977,6 +1977,31 @@ static int enough(struct r10conf *conf, int ignore)
 		_enough(conf, 1, ignore);
 }
 
+/**
+ * raid10_should_error() - Determine if this rdev should be failed
+ * @mddev: affected md device
+ * @rdev: member device to check
+ * @bio: the bio that caused the failure
+ *
+ * When failfast bios failure, rdev can fail, but the mddev must not fail.
+ * This function tells md_cond_error() not to fail rdev if bio is failfast
+ * and last rdev.
+ *
+ * Returns: %false if bio is failfast and rdev is the last in-sync device.
+ *	     Otherwise %true - should fail this rdev.
+ */
+static bool raid10_should_error(struct mddev *mddev, struct md_rdev *rdev, struct bio *bio)
+{
+	struct r10conf *conf = mddev->private;
+
+	if (!(bio->bi_opf & MD_FAILFAST) ||
+	    !test_bit(FailFast, &rdev->flags) ||
+	    test_bit(Faulty, &rdev->flags))
+		return true;
+
+	return enough(conf, rdev->raid_disk);
+}
+
 /**
  * raid10_error() - RAID10 error handler.
  * @mddev: affected md device.
@@ -5116,6 +5141,7 @@ static struct md_personality raid10_personality =
 	.free		= raid10_free,
 	.status		= raid10_status,
 	.error_handler	= raid10_error,
+	.should_error	= raid10_should_error,
 	.hot_add_disk	= raid10_add_disk,
 	.hot_remove_disk= raid10_remove_disk,
 	.spare_active	= raid10_spare_active,
-- 
2.50.1

