Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B4826FA6F;
	Sun,  1 Mar 2026 01:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329425; cv=none; b=KnQvBczZa6n7vEi8qxlXm0HHMoSlToYfC7tfrruZH0ywbUoTih4yWVyh2v2gYSnPB4Ltn9zmpHb+uSR6h6wNSaaxB1xYB+aJIsaLS/I4qhzXmX+KHxEQ4fBCXxdPQSrkVeUEmAiZ0IfAcs2qe0Kf9cH1qo8U01pZwv13916nKuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329425; c=relaxed/simple;
	bh=MTijXJeepNYQflIlsBqoYCNUcfakTVTaxVfg7KjqOh4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uESfGUhTg7TkUGgqV5WflcQygRalvCbt2sBDNCZA226x1n4MFfdRzjBC3tvqFQkiTuM7E7F84xXiQxAiZt2NpeYaR0MqatmTaFspKsYKhSTFo7RrD06JhvGirIZB1g+VD16eWUyD4ijTj2eXcuy2d4XdNUSJ7v40c2/VpWW2jXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t2MQlUm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t2MQlUm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08EFEC19421;
	Sun,  1 Mar 2026 01:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329425;
	bh=MTijXJeepNYQflIlsBqoYCNUcfakTVTaxVfg7KjqOh4=;
	h=From:To:Cc:Subject:Date:From;
	b=t2MQlUm7JMkrqZxPeJvdoWF1IfA0JpoTSUf5NNGg4YNAXBW89vZfW5z31l+AlqDiW
	 Pqyz01FPi7GYP+n7iDQZ+FLigzr2k338NR+JcMU/WQqKmd0nVBHRAhcvMlWklgSW0G
	 dfeMX23Td6TWH23ItEuYLqtIbEtmFVn1kMln9JjplMpiB769H+lBoLfc9tigqTmt4/
	 fP8HS5bJSwQA9bARCfEJ2Y760dn4GDAWzc65mThhvfVkeElhKmLVzST/V98Ogch/in
	 6tlUgvZrB8KvuxxHUbI/cDMNubUJgzh+OKZZRXWWBzt3XaBwT7Cu0JweCEmNdC6jvn
	 Zn3KKtx2U4wnw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	jinpu.wang@ionos.com
Cc: Yu Kuai <yukuai@fnnas.com>,
	linux-raid@vger.kernel.org
Subject: FAILED: Patch "md/bitmap: fix GPF in write_page caused by resize race" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:43:43 -0500
Message-ID: <20260301014343.1705844-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 46ef85f854dfa9d5226b3c1c46493d79556c9589 Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang@ionos.com>
Date: Tue, 20 Jan 2026 11:24:56 +0100
Subject: [PATCH] md/bitmap: fix GPF in write_page caused by resize race

A General Protection Fault occurs in write_page() during array resize:
RIP: 0010:write_page+0x22b/0x3c0 [md_mod]

This is a use-after-free race between bitmap_daemon_work() and
__bitmap_resize(). The daemon iterates over `bitmap->storage.filemap`
without locking, while the resize path frees that storage via
md_bitmap_file_unmap(). `quiesce()` does not stop the md thread,
allowing concurrent access to freed pages.

Fix by holding `mddev->bitmap_info.mutex` during the bitmap update.

Link: https://lore.kernel.org/linux-raid/20260120102456.25169-1-jinpu.wang@ionos.com
Closes: https://lore.kernel.org/linux-raid/CAMGffE=Mbfp=7xD_hYxXk1PAaCZNSEAVeQGKGy7YF9f2S4=NEA@mail.gmail.com/T/#u
Cc: stable@vger.kernel.org
Fixes: d60b479d177a ("md/bitmap: add bitmap_resize function to allow bitmap resizing.")
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md-bitmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index dbe4c4b9a1daf..1d4a050dab3ab 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2453,6 +2453,7 @@ static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		memcpy(page_address(store.sb_page),
 		       page_address(bitmap->storage.sb_page),
 		       sizeof(bitmap_super_t));
+	mutex_lock(&bitmap->mddev->bitmap_info.mutex);
 	spin_lock_irq(&bitmap->counts.lock);
 	md_bitmap_file_unmap(&bitmap->storage);
 	bitmap->storage = store;
@@ -2560,7 +2561,7 @@ static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 			set_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
 	}
 	spin_unlock_irq(&bitmap->counts.lock);
-
+	mutex_unlock(&bitmap->mddev->bitmap_info.mutex);
 	if (!init) {
 		__bitmap_unplug(bitmap);
 		bitmap->mddev->pers->quiesce(bitmap->mddev, 0);
-- 
2.51.0




