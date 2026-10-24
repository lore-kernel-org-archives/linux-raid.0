Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=173.255.221.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792879725;
	b=INQXICaz5UNpWUcYV+IkyNkAD4538EBkMlQcMDhuGLcW3ukFmKeFzmKQZE30CDCfJvG+
	 PELY+UbcT3sRULHaF4MCTxJjme+xhv+/O64Gpn7trkSN/cuC8/xPPdZ+8/dqT/C1K+KnP
	 6SXZ/FuUo+jr7w3YYkc1ZFY2728ffFoSoJqAkaE0TAjQq54IpwF70sObdOV1ZAMXC6Gkg
	 zo28ghBSUABcdMOcrp8dNP3YNJASpD1vqT3m5u9NdB+wGYALpXsFQBWcxL4/fIIn6Zcfe
	 IA1o7037FzhZ5f3f5mo8a0ab9oxV9Cb3SHTYA49ldQsPrAg7xbOTb5HfJoRz+vmbNOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792879725;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DomainKey-Signature:
	 Received:Received:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=209vJ9U9uwGJfDRBlCjgg9pqAG1r/ptgh9wq9i4kRT0=;
	b=D1jeFtLui/TlOUGVIduv1ifk1QexGcjxUVMKGYe0mGdBCPsJeonI2oFwvBOjik2xBa2o
	 NQDBsiGwahzIE7gi5k8i0KA/pIyKFQA8/ds8dnHIL/A383droulnCDFMv1iOfyf/RF5dL
	 ywLnDWa2WZnLi8kHTxo9+FeyULt09qj1F5fnie8l5uzKmyEzaYnApSrkVyK8QmUPLoyGN
	 hAaMzLFnPBkS53kyjNzt4Ks8kLtYUbWFUN+J0FnFlsHfcZb5Lv4Ar1J5j27oqBAFyPcnB
	 sUdLNenszTgI7mH6sKkvLJL7T8kLH5Q3YUMazUHZ5LymPyRXL/OO7rBRM02amK7y7xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=fatooh.org;
	spf=pass smtp.mailfrom=fatooh.org;
	dkim=pass header.d=fatooh.org header.i=@fatooh.org header.a=rsa-sha1 header.s=dkim header.b=Kti9gfaI;
	arc=none smtp.remote-ip=173.255.221.30
Received: from juniper.fatooh.org (juniper.fatooh.org [173.255.221.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF12A606A31A
	for <linux-raid@vger.kernel.org>; Sat, 24 Oct 2026 22:08:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF12A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fatooh.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fatooh.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=fatooh.org header.i=@fatooh.org header.a=rsa-sha1 header.s=dkim header.b=Kti9gfaI
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by juniper.fatooh.org (Postfix) with ESMTPS id DAA2040837;
	Sat, 24 Oct 2026 15:08:43 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
	by juniper.fatooh.org (Postfix) with ESMTP id B1CBB409D0;
	Sat, 24 Oct 2026 15:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=fatooh.org; h=from:to
	:subject:date:message-id:mime-version:content-transfer-encoding;
	 s=dkim; bh=lTMGskqhD0jjYs4UfRJd9ktongg=; b=Kti9gfaIgHUdpV1ZO8Wm
	fczvt/5fGq0AsgAIUSRNggzlWVP/7LObrGcFs4v1/RLkAQhVJVYfWBipumu41i8K
	QXWfbULCRSWiDP5ZwDhdvq0GYvYpggQ2zJOb5grmNwUZCg6wyGZAIhtIlILRK4AA
	2f4JQXnamJ9u40bH9cF2cgs=
DomainKey-Signature: a=rsa-sha1; c=simple; d=fatooh.org; h=from:to
	:subject:date:message-id:mime-version:content-transfer-encoding;
	 q=dns; s=dkim; b=gZVTWpONH89rrw18aD/6CR0DFy5ZC/ax8biUVTB1dfVz/x
	eMrjw8ByZOar8kviihsDK0ZNLxJ59EnKT2u1UMF0oinI6cpXbmDh4UAy8qQoRAU+
	+/cj2A6aPl4dirk87QP18Cje5ZGIxbTo09IQpM1jEzxYMm/1ntK0oKGA/YDsA=
Received: from bugfood.local (unknown [IPv6:2600:1700:9750:59e2:62cf:84ff:fe62:f2b2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by juniper.fatooh.org (Postfix) with ESMTPSA id 9620C40837;
	Sat, 24 Oct 2026 15:08:43 -0700 (PDT)
Received: by bugfood.local (Postfix, from userid 1000)
	id 5EB80C0CC380; Sat, 24 Oct 2026 15:08:42 -0700 (PDT)
From: Corey Hickey <bugfood-ml@fatooh.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org
Subject: [PATCH v1] md/raid10: avoid resync when there is no room for redundancy
Date: Sat, 24 Oct 2026 15:08:42 -0700
Message-ID: <20261024220842.665158-1-bugfood-ml@fatooh.org>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Corey Hickey <bugfood-c@fatooh.org>

RAID-10 allows creation/assembly with missing devices. If the maximum
number of devices are missing, then a resync can do nothing--there is
nowhere to copy the data. A simple example of this is a four-device
RAID-10 with two devices missing.

In this case, the kernel spends a while on a resync that copies no data
at all. The time required for this can vary, but takes ~3 minutes for a
4x1TB RAID-10 on a Ryzen 7 7840HS, for example. Meanwhile, /proc/mdstat
reports nonsense values for finish= and speed=.

md10 : active raid10 loop1[2] loop0[0]
      2147219456 blocks super 1.2 512K chunks 2 near-copies [4/2] [U_U_]
      [==========>..........]  resync = 52.2% (1121300864/2147219456) finish=96179868.0min speed=0K/sec
      bitmap: 16/16 pages [64KB], 65536KB chunk

Neither RAID-1 nor RAID-5 do a resync when there are too few devices.
For RAID-10, Add a check that avoids the resync when possible. This
matches an equivalent (but more simple) check in raid1.c.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=222085
Link: https://www.reddit.com/r/linuxquestions/comments/1lh9to0/kernel_is_stuck_resyncing_a_4drive_raid10_array/
Signed-off-by: Corey Hickey <bugfood-c@fatooh.org>
---
 drivers/md/raid10.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1093c798d9dd..7562c7aee1e9 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4065,6 +4065,10 @@ static int raid10_run(struct mddev *mddev)
 		}
 	}
 
+	/* Do not try to resync if there is no room for redundant data. */
+	if ((conf->geo.raid_disks - mddev->degraded) * conf->copies == conf->geo.raid_disks)
+		mddev->resync_offset = MaxSector;
+
 	if (mddev->resync_offset != MaxSector)
 		pr_notice("md/raid10:%s: not clean -- starting background reconstruction\n",
 			  mdname(mddev));
-- 
2.53.0

