Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCC9322520;
	Mon, 17 Nov 2025 08:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763369766; cv=none; b=ZakaqQKl1z2pVSoNE6/fZ8uiinuYEhA4UEruX7a6n+46SFGucbxpVzt7/PWPPKrs/7sqtFRMiNQOvThMskABzVSn2Ph5VsixIGyQqijQHRRCCvYgJ6DSn5nbBeO+HFPyaLVEK0V/4SaZowARW8XGyE6FAmaz/XFdQu+StE1jA3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763369766; c=relaxed/simple;
	bh=72nTILW6ZN1MfcQG57n0tMrXga6UOLqJDkHMmQ/Kpdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBYgYaoMrIR3o9APlHUpUFfe2W/nYUn1XYTtto+jJrpqH8b82IYyKRlHGaqIGDJ6BFUwO2oQtH/znu6t9ivIYnTNv4czANQB138txxGtQG+mL4Q8Vn5YXvbxOqgtKlxOWeTRkdYXyoh6RgicK6DBobtRjNZSpdfLwgXl+wDPy4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94AAC2BCB1;
	Mon, 17 Nov 2025 08:56:02 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yukuai@fnnas.com
Subject: [PATCH 2/2] md/raid5: fix IO hang when array is broken with IO inflight
Date: Mon, 17 Nov 2025 16:55:57 +0800
Message-ID: <20251117085557.770572-3-yukuai@fnnas.com>
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

Following test can cause IO hang:

mdadm -CvR /dev/md0 -l10 -n4 /dev/sd[abcd] --assume-clean --chunk=64K --bitmap=none
sleep 5
echo 1 > /sys/block/sda/device/delete
echo 1 > /sys/block/sdb/device/delete
echo 1 > /sys/block/sdc/device/delete
echo 1 > /sys/block/sdd/device/delete

dd if=/dev/md0 of=/dev/null bs=8k count=1 iflag=direct

Root cause:

1) all disks removed, however all rdevs in the array is still in sync,
IO will be issued normally.

2) IO failure from sda, and set badblocks failed, sda will be faulty
and MD_SB_CHANGING_PENDING will be set.

3) error recovery try to recover this IO from other disks, IO will be
issued to sdb, sdc, and sdd.

4) IO failure from sdb, and set badblocks failed again, now array is
broken and will become read-only.

5) IO failure from sdc and sdd, however, stripe can't be handled anymore
because MD_SB_CHANGING_PENDING is set:

handle_stripe
 handle_stripe
 if (test_bit MD_SB_CHANGING_PENDING)
  set_bit STRIPE_HANDLE
  goto finish
  // skip handling failed stripe

release_stripe
 if (test_bit STRIPE_HANDLE)
  list_add_tail conf->hand_list

6) later raid5d can't handle failed stripe as well:

raid5d
 md_check_recovery
  md_update_sb
   if (!md_is_rdwr())
    // can't clear pending bit
    return
 if (test_bit MD_SB_CHANGING_PENDING)
  break;
  // can't handle failed stripe

Since MD_SB_CHANGING_PENDING can never be cleared for read-only array,
fix this problem by skip this checking for read-only array.

Fixes: d87f064f5874 ("md: never update metadata when array is read-only.")
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid5.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cdbc7eba5c54..e57ce3295292 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4956,7 +4956,8 @@ static void handle_stripe(struct stripe_head *sh)
 		goto finish;
 
 	if (s.handle_bad_blocks ||
-	    test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags)) {
+	    (md_is_rdwr(conf->mddev) &&
+	     test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags))) {
 		set_bit(STRIPE_HANDLE, &sh->state);
 		goto finish;
 	}
@@ -6768,7 +6769,8 @@ static void raid5d(struct md_thread *thread)
 		int batch_size, released;
 		unsigned int offset;
 
-		if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
+		if (md_is_rdwr(mddev) &&
+		    test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
 			break;
 
 		released = release_stripe_list(conf, conf->temp_inactive_list);
-- 
2.51.0

