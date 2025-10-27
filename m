Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440A02EDD76
	for <linux-raid@vger.kernel.org>; Mon, 27 Oct 2025 15:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577517; cv=none; b=j2gh9uT8GdWgqyrpN52q5MbcsZiA+ZsDjhm8q4BUxn1ri1qiNrJ8rAAJTmB2Rt1vDzTqCWB6CVtJeeVrBwMpCEmVSo61mH2yx5LmF2W4f5ypHfTL0B5g3FnTKAhBJf0p6PDZFItLvgls06xfns2gweAwIB7EVEIiyAWJWSqxHN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577517; c=relaxed/simple;
	bh=GiJM0j7XIJSrgiGU1nODsCDYyTYNrdzvNSTEM+cNYuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfxcfbJ9eJ0w1LXD6oHT7tYJGEQC5P6xtv48V3EcQP/4AHAr8t/ZW+Y395tWoEMPOUwcse1dj3OlSgu9360FcvIgJkHt+XTsFHEUil9HdUqtChAmAEoENZfzYiu9MUOLHuEcUOQVxFYt/Ksewd9F+Hy/PNrXe/nOgj3A2LqkbSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=cj8u3Riv; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="cj8u3Riv"
Received: from fedora (p3796170-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [180.53.173.170])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 59RF4hAd090988
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 28 Oct 2025 00:04:45 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=uy9KH+7/iFBaIvHnHGGLWrehk7S8042ac77AEgzmD8M=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1761577485; v=1;
        b=cj8u3RivypG8IY8lsq8zpbl2E0PkY+x+0CBtfHuILaIVWQ9v7oGhJHpxmfqmXk2E
         w0k0ICQWBw5piRtGWhYj0RJJU+zMNktNurrmbXAQMeVHlXH9E+8eUa/3LgsdJgZP
         0XrOatl7b2nFGJgTvnkeRfsh/XZU8YvoZE742AySo2ouQYoC9ady2hkfSoxLiqrJ
         qMN8Snkhvg3wDm0Hl30F0Dk3yPgrG7zD4HjuMdHfTr52k9KhmbbygKyGrMq7ZQlZ
         atfVa4fo5mmP92M1ch/ioBofZsAJgIjxz3PlxqLEKIkCqykxYb6v/zj60lSBcWG3
         i7HRCMi+xjqd23WZvy8njQ==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
        Shaohua Li <shli@fb.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v5 03/16] md: add pers->should_error() callback
Date: Tue, 28 Oct 2025 00:04:20 +0900
Message-ID: <20251027150433.18193-4-k@mgml.me>
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

To address this issue, a new handler md_cond_error() will be introduced
to ensure that failfast I/O does not mark the array as broken.

As preparation, this commit adds a helper pers->should_error() to determine
from outside the personality whether an rdev can fail safely, which is
needed by md_cond_error().

Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/md.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index c982598cbf97..01c8182431d1 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -763,6 +763,7 @@ struct md_personality
 	 * if appropriate, and should abort recovery if needed
 	 */
 	void (*error_handler)(struct mddev *mddev, struct md_rdev *rdev);
+	bool (*should_error)(struct mddev *mddev, struct md_rdev *rdev, struct bio *bio);
 	int (*hot_add_disk) (struct mddev *mddev, struct md_rdev *rdev);
 	int (*hot_remove_disk) (struct mddev *mddev, struct md_rdev *rdev);
 	int (*spare_active) (struct mddev *mddev);
-- 
2.50.1

