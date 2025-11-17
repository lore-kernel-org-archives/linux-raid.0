Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C203432143D;
	Mon, 17 Nov 2025 08:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763369762; cv=none; b=f9pM99WohRDfGeFeBfYVjSjXT5lKw+R0PXQmIjZpJ4i/kahFfJMpBgVp/T2fPEHwArRJ5iT8yVLuald9izHMjl4E1hyeTEk5zf2N/t96TvBy35+DFdoqVMHmb1PhP+cFkJQ4pwrDYtQv+YCHkOcqJrBh2KNkXYv1yNTdhPEwBtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763369762; c=relaxed/simple;
	bh=gSurTomTLgvatN+yJ6jG1jcwYAuNzdZwuK053kZ++2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NazMYDcswsXazSpzkS0/MjFEWoE76exCnFc0sZfrMMKg5//1KMq4Tn+FGnbBLd3gZGmQGCxt/+sQEXyOaq1dzudXnni1YCTqzPSl+kO7YVVmXz9NCssDkeMRZb3TNT+Ln7ohzKjMynAThVj02vpNutZ3bxzpgdbIw7+8v+Y5IZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CBEC4CEFB;
	Mon, 17 Nov 2025 08:56:01 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yukuai@fnnas.com
Subject: [PATCH 1/2] md: warn about updating super block failure
Date: Mon, 17 Nov 2025 16:55:56 +0800
Message-ID: <20251117085557.770572-2-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251117085557.770572-1-yukuai@fnnas.com>
References: <20251117085557.770572-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Many personalities will handle IO error from daemon thread(like raid1d,
raid10d, raid5d), and sb will require to be clean before hanlding these
failed IO. However update sb can fail, for example array is broken by
IO failure, or user config sysfs api array_state.

This patch adds warning if updating sb failed first, in case this will
be related to IO hang.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7b5c5967568f..345b1e623aba 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2788,6 +2788,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 	if (!md_is_rdwr(mddev)) {
 		if (force_change)
 			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
+		pr_err("%s: can't update sb for read-only array %s\n", __func__, mdname(mddev));
 		return;
 	}
 
-- 
2.51.0

