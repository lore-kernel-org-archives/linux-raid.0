Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00DE4176F8;
	Fri,  5 Jun 2026 09:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650977; cv=none; b=mvGDYIAZiStJr2KZgZuu+SEUMEDQdrJIvl0Awp6WdqebiuunJc7QH9QrZJjIgiQv0qb320TNCgP+nIOdz0ITriBj9GiQBf/QGFAUmahOGPj0XtOgd/r4qGZraBrqL+q35Gxw9DQJd85FEpk3etRz8MgM9zqo+2NMdBsCMG/hmKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650977; c=relaxed/simple;
	bh=ELRMYTPU8gAhxV4u4ZVDRuoWiBYsiEsfGOWon/nznAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoH7ydvdDMuKF9bgWwau9prvzS9NagJj0i1zZtzPZpDobSGVsKr+4PM1O5sb3WB/+9aUl16QJAc5ySPys+WYUGkrWg5AdQHb9Vz57kk6PSJ5rEw9Hq2JqC3gVdKNsoqPWDTYkS/VJvnTJwPyxBPuvkaXHJq+rIfcAgkxgOMGE1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZJ7CYY+v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZJ7CYY+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C10B1F00898;
	Fri,  5 Jun 2026 09:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650976;
	bh=PrlGm7aeNwyYNwipQJn09/8Qa5CW03DvtiihC72MfGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZJ7CYY+v7iQJYEx51sZC9WaJu3q/ZOrcf+YGJMx/mlmcchEr3GNajvJ8iKnoBfVh1
	 UNOd66BSw5JO9/Uh06F+c8g8L4fJv/7MFy4NxPnNtnS0pLHuqAiygIDn0xAuQDELjK
	 3oH8mXNZhAgKZEq2hx/ev57XBDbUte9uqKYZOGWG4rYxaWA95SaSpwuER7q/oQRTDu
	 bem7FtDZjB3M8kekcQeNXYjEt229Fl5+3KXiA2VQ+FIKqwkqIB/drdAEGeRqaXZ3wY
	 lKMxsSBHD7egvCzloZSehPhbw6YE0fMN24kjr1TheMd2bgrXu5A4SMSf2u7+Y4zkWf
	 VtoA8EX+gL3Zw==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/raid5: split reshape bios before bitmap accounting
Date: Fri,  5 Jun 2026 17:15:27 +0800
Message-ID: <20260605091527.2463539-21-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260605091527.2463539-1-yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Use the shared mddev_bio_split_at_reshape_offset() helper so RAID5
submits only one-side bios to llbitmap during reshape.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6786f30dc59b..dde10b5b0ff5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6172,10 +6172,18 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 		make_discard_request(mddev, bi);
 		md_write_end(mddev);
 		return true;
 	}
 
+	bi = mddev_bio_split_at_reshape_offset(mddev, bi, NULL,
+					       &conf->bio_split);
+	if (!bi) {
+		if (rw == WRITE)
+			md_write_end(mddev);
+		return true;
+	}
+
 	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)RAID5_STRIPE_SECTORS(conf)-1);
 	bi->bi_next = NULL;
 
 	ctx = mempool_alloc(conf->ctx_pool, GFP_NOIO);
 	memset(ctx, 0, conf->ctx_size);
-- 
2.51.0

