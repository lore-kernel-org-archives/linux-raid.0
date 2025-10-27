Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCAF3090CE
	for <linux-raid@vger.kernel.org>; Mon, 27 Oct 2025 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577518; cv=none; b=H99+ipcd/0IbmgihEE2iifR22dqPmAFxYWxkcHmEEqddOOHOpytpQtuYvQgyXglaKJ7QMhPblNve5qG1h7qCVCuBBTbKGi7mdxMetymocGZYLGeVTWeqLx3qDJ3tIYN95EzjP9nGUzYcoQUCTEW25if78dH0WmaBMMMp0o2o68c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577518; c=relaxed/simple;
	bh=oMLUyHl2uZUJ8iKbejsBHgq428Z/NETxc5vWqBZWsbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIa/IgBnTYKRfBZWjzvUUM3did7SvNTk40Fj8pTCnUbkp8/tif6KXKH5WARux2uSWnJY3WwFW65bWDI1WGfXOi97TkHTlnz+fuqKGH/kuYTqPD6S/ZjPl0fCXfDHcZDHklRtRqdEXrwhGnJizo/0OBPCR8GM8ZLzhspP6+FxQHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=CqJzhg7V; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="CqJzhg7V"
Received: from fedora (p3796170-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [180.53.173.170])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 59RF4hAq090988
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 28 Oct 2025 00:04:47 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=mKOpuXkFl04B6nJz7GlXTCVis5sGgEKZn5b7ybDr4b8=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1761577487; v=1;
        b=CqJzhg7VLz45NOm+u5Bv3EQob29i3Qj/hprXVy1c6Tj9igyl3NxMK3XaQXOXSAGV
         EN01X0o3g+ZTUR9SKsM/W8kxf2yVYS27IoercU8HXvCuFcYc/Qay88V43EZTM06d
         ZsiDSJuugOdIM3Oqijy0nz4P7nOgPVgcgv3sWNjJ/PsulvABms/ENfygIkY1KpWH
         HFCCm8CF+sDIUJy6U9Nskok1cW+CLOv2DkSPi/3nz0UWe/8OQDLQwHAxBoBj9sxA
         rlX1iM/rzCw+mbmKrujahifATvaca8b+6vMH+iZNJKV9V6lzYT8exraU2cPvHzYn
         d5D3/sXKLHAkiekTWL1rzw==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
        Shaohua Li <shli@fb.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v5 16/16] md: Improve super_written() error logging
Date: Tue, 28 Oct 2025 00:04:33 +0900
Message-ID: <20251027150433.18193-17-k@mgml.me>
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

In the current implementation, when super_write fails, the output log
will be like this:
 md: super_written gets error=-5

It is unless combined with other logs - e.g. I/O error message from blk,
it's impossible to determine which md and rdev are causing the problem,
and if the problem occurs on multiple devices, it becomes completely
impossible to determine from the logs where the super_write failed.

Also, currently super_written does not output logs when retrying
metadata write.  If the metadata write fails, the array may be
corrupted, but if it is retried and successful, then it is not.
The user should be informed if a retry was attempted.

This commit adds output to see which array and which device had the
problem, and adds a message to indicate when a metadata write retry is
scheduled.

Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/md.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1cbb4fd8bbc0..4cbb31552486 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1058,10 +1058,13 @@ static void super_written(struct bio *bio)
 	struct mddev *mddev = rdev->mddev;
 
 	if (bio->bi_status) {
-		pr_err("md: %s gets error=%d\n", __func__,
+		pr_err("md: %s: %pg: %s gets error=%d\n",
+		       mdname(mddev), rdev->bdev, __func__,
 		       blk_status_to_errno(bio->bi_status));
 		if (!md_cond_error(mddev, rdev, bio)
 		    && (bio->bi_opf & MD_FAILFAST)) {
+			pr_warn("md: %s: %pg: retrying metadata write\n",
+				mdname(mddev), rdev->bdev);
 			set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
 			set_bit(RetryingSBWrite, &rdev->flags);
 		}
-- 
2.50.1

