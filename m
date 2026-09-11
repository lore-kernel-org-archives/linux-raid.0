Received: from va-2-40.ptr.blmpb.com (va-2-40.ptr.blmpb.com [209.127.231.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9253839AC
	for <linux-raid@vger.kernel.org>; Fri, 11 Sep 2026 04:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789100265; cv=none; b=RwaSf8CN0uz7Lq1Jp5GQKRBd2CMN7BC6c4BoaTPaRKF8jMQ6ahb6tKZw5Jmk29K6BAg+83epHVLw9MZVFsUAVKIJogx+6N4i4tNUBcvZEfes02IatXw9lQWvF46hKRjXRert90a+aX0imMOgTpXdQu/OtNzpSPuhLz4DoEiTnX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789100265; c=relaxed/simple;
	bh=O//23mptPXnLU2BwF3aUzAmv/+0bnVC1d9toDxt71iE=;
	h=Message-Id:Subject:Date:Cc:From:To:Content-Type:Mime-Version; b=SxxOILVakiMugeh9QiDO6DJg5BM3pb+PwRQj8STTdBq/DHImRnVUAnDvVTvv5mAwfrmNHfUKpHqqAcBfpISNip3L5wX4OzU9QtKvqBtgsjpo+za6vg24ZdjUN9JnJ59//zO+UMeR0qbYOFQSzv1+h43hvjIcJNQar4daYp0QKi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=VpjnRIRe; arc=none smtp.client-ip=209.127.231.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="VpjnRIRe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1789100134;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Aaf95Sia1XUwL9cmx/hcNMrhvi/5eFl5xpwPxhuGTjo=;
 b=VpjnRIRexyefaB2V9p5Xj2aanGf4E/+rtkSF5lh17T4VOIv0eS0gvLtBgyxIQ9B+Y6zlhm
 gGzDVgAbon36rvQtoqN5gMR2GHDIIHHHILDxzyRL/sS+pplb8z2+UR/4Rm7qJCBNCb3e1e
 Z0QMbiYnKP4ueOiSIGXNgG8suMYu386KT+pu58CkLMbC5eZzSqV5yGghZtmJ0pgJkyObLX
 uly7RTKkfmAAZ3C/nncD3oZBy3aWWBTzKAs9F345sHU9jInBAYCE2sJNyE/+EPoHfCo9KZ
 s8q+jaXgG5qlGAcizhulhF1gcqkEc/et0ZL1frANAMo2yx/Xvka/FrjTedUypw==
Message-Id: <20260911041521.2433222-1-chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com
Subject: [PATCH v3] md/raid5: reject raid4/5 arrays with too few disks
Date: Fri, 11 Sep 2026 12:15:21 +0800
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 7bit
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>, 
	<syzbot+de94ddbfff0c9e6fe030@syzkaller.appspotmail.com>
From: "Chen Cheng" <chencheng@fnnas.com>
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <nixiao@fygo.io>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26aa38064+30c2ba+vger.kernel.org+chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from fedora ([183.34.169.131]) by smtp.feishu.cn with ESMTPS; Fri, 11 Sep 2026 12:15:31 +0800

From: Chen Cheng <chencheng@fnnas.com>

raid4 and raid5 require at least two disks, while raid6 requires at least
four disks. setup_conf() only rejects raid6 arrays with fewer than four
disks. As a result, an invalid raid4 or raid5 array can be assembled with
no data disks and later reach raid5_set_limits().

Reject such arrays before the r5conf is created. This prevents the invalid
geometry from reaching queue limit setup, where roundup_pow_of_two() can be
called with a zero stripe size.

Reported-by: syzbot+de94ddbfff0c9e6fe030@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/6a778c82.01d0871a.3a0d52.006a.GAE@google.com/
Fixes: f63f17350e53 ("md/raid5: use the atomic queue limit update APIs")
Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
v1->v2:
- Fix wrong tags
- Check raid-4 also

v2->v3:
- Keep two-disk raid5 arrays valid by rejecting raid4/5 only below two disks
---
 drivers/md/raid5.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b91545ce090d..e1f20035703b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7655,13 +7655,15 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	     && !algorithm_valid_raid6(mddev->new_layout))) {
 		pr_warn("md/raid:%s: layout %d not supported\n",
 			mdname(mddev), mddev->new_layout);
 		return ERR_PTR(-EIO);
 	}
-	if (mddev->new_level == 6 && mddev->raid_disks < 4) {
-		pr_warn("md/raid:%s: not enough configured devices (%d, minimum 4)\n",
-			mdname(mddev), mddev->raid_disks);
+	if ((mddev->new_level != 6 && mddev->raid_disks < 2) ||
+	    (mddev->new_level == 6 && mddev->raid_disks < 4)) {
+		pr_warn("md/raid:%s: not enough configured devices (%d, minimum %d)\n",
+			mdname(mddev), mddev->raid_disks,
+			mddev->new_level == 6 ? 4 : 2);
 		return ERR_PTR(-EINVAL);
 	}
 
 	if (!mddev->new_chunk_sectors ||
 	    (mddev->new_chunk_sectors << 9) % PAGE_SIZE ||
-- 
2.55.0
