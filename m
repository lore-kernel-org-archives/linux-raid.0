Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29BA35B62C;
	Thu,  2 Apr 2026 06:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775110518; cv=none; b=NAFym/Q57bl1s5nWRpZEUINMXXpBlNk9Csiu4B0mtHW24qBiZCu0OSQgEXziHYVUWPVu4fva1cuURrZpY+kKmvoBqoOfdSGOpq2U3vaGjtygt3eoXV9cvachUctoj+VKg+e8UnTBAejUy3zi9kFNfLfR32OyGbhrrpyxd7HyU98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775110518; c=relaxed/simple;
	bh=aYPRjL162uLqw/8iMBn+Bgh+ejJoX309C2s1Lrhz7CE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=KSczwY8pluLD5HXGe86QXqy9Blzmx0WhFoK0ZorlX8nwwAew2bU0LIFbuPs4kyPwDy896E9IrFvB91pRTKayLEHGzM+CmoCSURE9H+gUAxvTmJSmDVP118uGLjXXCzBUEg9lV2bwf+wicsT/nc9KYOAE0CifYRFR99xK9ajQgxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=jSoLwcIN; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="jSoLwcIN"
From: Chia-Ming Chang <chiamingc@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1775110508; bh=aYPRjL162uLqw/8iMBn+Bgh+ejJoX309C2s1Lrhz7CE=;
	h=From:To:Cc:Subject:Date;
	b=jSoLwcINagz1xcJg0CPXWa10aUdVs0foJqCenmdevKbDk9o8qI/GEIrE0+jMAPsVb
	 WAqJCZeNb+Vi4bHTMbfoG8yYhPkcw6xmz+vK5TJzRaNTyi4J379hD/YHHt8sf7oukY
	 3mUdZOU0PBgsOf9+rVEZMetlM+XT9bvO0Akm8QEA=
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linan122@huawei.com,
	shli@kernel.org,
	neil@brown.name,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chia-Ming Chang <chiamingc@synology.com>,
	stable@vger.kernel.org,
	FengWei Shih <dannyshih@synology.com>
Subject: [PATCH] md/raid5: fix soft lockup in retry_aligned_read()
Date: Thu,  2 Apr 2026 14:14:06 +0800
Message-Id: <20260402061406.455755-1-chiamingc@synology.com>
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

When retry_aligned_read() encounters an overlapped stripe, it releases
the stripe via raid5_release_stripe() which puts it on the lockless
released_stripes llist. In the next raid5d loop iteration,
release_stripe_list() drains the stripe onto handle_list (since
STRIPE_HANDLE is set by the original IO), but retry_aligned_read()
runs before handle_active_stripes() and removes the stripe from
handle_list via find_get_stripe() -> list_del_init(). This prevents
handle_stripe() from ever processing the stripe to resolve the
overlap, causing an infinite loop and soft lockup.

Fix this by using __release_stripe() with temp_inactive_list instead
of raid5_release_stripe() in the failure path, so the stripe does not
go through the released_stripes llist. This allows raid5d to break out
of its loop, and the overlap will be resolved when the stripe is
eventually processed by handle_stripe().

Fixes: 773ca82fa1ee ("raid5: make release_stripe lockless")
Cc: stable@vger.kernel.org
Signed-off-by: FengWei Shih <dannyshih@synology.com>
Signed-off-by: Chia-Ming Chang <chiamingc@synology.com>
---
 drivers/md/raid5.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a8e8d431071b..335d2b6b1079 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6641,7 +6641,13 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio,
 		}
 
 		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0, 0)) {
-			raid5_release_stripe(sh);
+			int hash;
+
+			spin_lock_irq(&conf->device_lock);
+			hash = sh->hash_lock_index;
+			__release_stripe(conf, sh,
+					 &conf->temp_inactive_list[hash]);
+			spin_unlock_irq(&conf->device_lock);
 			conf->retry_read_aligned = raid_bio;
 			conf->retry_read_offset = scnt;
 			return handled;
-- 
2.34.1


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
