Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D5C186284;
	Thu, 19 Mar 2026 05:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773899044; cv=none; b=QdoLFeCz1xGjwun13sAvFbgkGBXuL6OLfGm2d87ef+9whi0jbmYbQh1JnSiNK898CaxdqIeMY99ffJz3KZMiOh7ejSxvS+4n5Yrv06smH0MNWeQKgnqO4sDuiMiiqP27W6+e/OBxE0lWzz7J0iCYJDTaIRievZjfPz/pJDiwYrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773899044; c=relaxed/simple;
	bh=Ik+cjg/fdHvqW0bbHjAjsU5/6GaV+Nrvx8xk71mKKOg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=HM+xNeHbWMQiH9O66zjULHtoUrDOjyva4aHjEdOBZWeDCiYNLib8Ou9B6VstjCAp03qneJSnxtdTs4/UfxKmyMntGil0hdDvnr2rjgeXhGqOal5sQj1xFfuhwBHBU/4PS4xBEdVB4YNEJdEwkErd4BSRQIiAGPAB3RlAr36d1ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=uADruYkP; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="uADruYkP"
Received: from localhost.localdomain (unknown [10.17.211.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.synology.com (Postfix) with ESMTPSA id 4fbvXz2FzzzHQlm9v;
	Thu, 19 Mar 2026 13:35:15 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1773898515; bh=Ik+cjg/fdHvqW0bbHjAjsU5/6GaV+Nrvx8xk71mKKOg=;
	h=From:To:Cc:Subject:Date;
	b=uADruYkP33ok/bqt8h1eZiXHfqvoeOzvgqar/2nwwwPDVFGB/vaSN2IDzijm8xTXf
	 vrizAImjKeDNd06do12+PWhqblMnYMgP9Ljm1hLnYMewXXoXJ8D57sBK4cY2p54ceX
	 opHf1U5XlOABzWF57Er6h8BZ19J+ibYnqcIMizco=
From: FengWei Shih <dannyshih@synology.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linan122@huawei.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	FengWei Shih <dannyshih@synology.com>
Subject: [PATCH] md/raid5: skip 2-failure compute when other disk is R5_LOCKED
Date: Thu, 19 Mar 2026 13:33:51 +0800
Message-Id: <20260319053351.3676794-1-dannyshih@synology.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
Content-Type: text/plain

When skip_copy is enabled on a doubly-degraded RAID6, a device that is
being written to will be in R5_LOCKED state with R5_UPTODATE cleared.
If a new read triggers fetch_block() while the write is still in
flight, the 2-failure compute path may select this locked device as a
compute target because it is not R5_UPTODATE.

Because skip_copy makes the device page point directly to the bio page,
reconstructing data into it might be risky. Also, since the compute
marks the device R5_UPTODATE, it triggers WARN_ON in ops_run_io()
which checks that R5_SkipCopy and R5_UPTODATE are not both set.

This can be reproduced by running small-range concurrent read/write on
a doubly-degraded RAID6 with skip_copy enabled, for example:

  mdadm -C /dev/md0 -l6 -n6 -R -f /dev/loop[0-3] missing missing
  echo 1 > /sys/block/md0/md/skip_copy
  fio --filename=/dev/md0 --rw=randrw --bs=4k --numjobs=8 \
      --iodepth=32 --size=4M --runtime=30 --time_based --direct=1

Fix by checking R5_LOCKED before proceeding with the compute. The
compute will be retried once the lock is cleared on IO completion.

Signed-off-by: FengWei Shih <dannyshih@synology.com>
---
 drivers/md/raid5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bded2b86f0ef..bb493acfec29 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3916,6 +3916,8 @@ static int fetch_block(struct stripe_head *sh, struct stripe_head_state *s,
 					break;
 			}
 			BUG_ON(other < 0);
+			if (test_bit(R5_LOCKED, &sh->dev[other].flags))
+				return 0;
 			pr_debug("Computing stripe %llu blocks %d,%d\n",
 			       (unsigned long long)sh->sector,
 			       disk_idx, other);
-- 
2.25.1


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
