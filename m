Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E942D2499
	for <linux-raid@vger.kernel.org>; Mon, 27 Oct 2025 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577517; cv=none; b=JnWSfk/ccC/5d0QUZcDP2RFXX4u3GX13fEtGVKSA6DTI1wv0KlsekRJQhpwUFsi40L3B3HRLKpxGKjNqPEFfiqDj15XRtGhVpXOmj0+yokFL32aLwz1jXr5zR3ZNpi8nyXfLUpt47FOW0T6Z4sbbGdv52iFyd0PiL+jnQUq3jn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577517; c=relaxed/simple;
	bh=htt+FZRcCwvAakH7MD0O81HhWPQ1I0Tqez3xD0GeuWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U58X9sqaNnzJnfntdtmHath8oTsaaJZ4FwXpYgOXXtRF8dYU0uksvc5mm15P68DJL71j7skpch9F2UXYjQhcOhDouI5mOezcGr//AObvtzbt1hHGXjfIBeIB03osTTeSx+45Y76lNkYbkvxdLKKje8g2VB35zpDbsj6BLQV6Sn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=Dc8XCTNU; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="Dc8XCTNU"
Received: from fedora (p3796170-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [180.53.173.170])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 59RF4hAn090988
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 28 Oct 2025 00:04:46 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=TrguO4MMM9H23L+llpMoD/+oyT7T2CY7lD8mkAEY6zs=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1761577486; v=1;
        b=Dc8XCTNUIgygFpeQgZ1OCU8ccdPQd1+9Cm5U5aeKhtf8680RmvYK/kVf0oskxtwO
         GRfW2EffTT3IJ5G6MOOJcb4MZJ4Qcnd6vWMUpLcA4epLn1KhnPtXUh0yo1W4yAoi
         Vn3liuHwFnfkfnBK8qKuUnS6cHYXHqMMFAWfMW7VG7ftJvUU2cLzi0rDO/vhR2FX
         8RbfKk80sIG5dqZw8JkiQKZH+SsTXb4EsQ6B9gIdZbPtK7/kJ3jLNEodl1YoqmvJ
         /L5p74u3uJoEQBTN9C3iyBiZwVHpGGw513W2vDPuZORForw1lPKaEZIPOvH4/i2P
         5V4JHqILzmNWEcq10CPVdg==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
        Shaohua Li <shli@fb.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v5 13/16] md/raid1: add error message when setting MD_BROKEN
Date: Tue, 28 Oct 2025 00:04:30 +0900
Message-ID: <20251027150433.18193-14-k@mgml.me>
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

Once MD_BROKEN is set on an array, no further writes can be performed.
The user must be informed that the array cannot continue operation.

Add error logging when MD_BROKEN flag is set on raid1 arrays to improve
debugging and system administration visibility.

Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/raid1.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index bf96ae78a8b1..d58a60fb5b2f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1790,6 +1790,10 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 	if (test_bit(In_sync, &rdev->flags) &&
 	    (conf->raid_disks - mddev->degraded) == 1) {
 		set_bit(MD_BROKEN, &mddev->flags);
+		pr_crit("md/raid1:%s: Disk failure on %pg, this is the last device.\n"
+			"md/raid1:%s: Cannot continue operation (%d/%d failed).\n",
+			mdname(mddev), rdev->bdev,
+			mdname(mddev), mddev->degraded + 1, conf->raid_disks);
 
 		if (!mddev->fail_last_dev) {
 			conf->recovery_disabled = mddev->recovery_disabled;
-- 
2.50.1

