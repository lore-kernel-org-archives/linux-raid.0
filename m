Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD32D3546F5
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 08:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782202802; cv=none; b=rM+hj79vkrPeBAi31Q3q8XvBuDkiOmFCSElkEol7a/vt8G1vAvHjMKYDvHlWWBk/5+JT6zq2zsmB2wTj0skqEoc8XzdAlvARUpm3lcpeEUoHcGXedVpTJojWQNNcMnhoXbnIN94p7FzZaUTLquELWP0EwFHbd9mMQ847vqzJVfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782202802; c=relaxed/simple;
	bh=AwTWWGXLicZ31JLacvWnTThyHF4GZxbey+ulG2btVvY=;
	h=Subject:To:Message-Id:Cc:From:Date:Mime-Version:Content-Type; b=mW6+UT3Y1N444ChCsLrMXsRsG3cjqj7ZNFwOvUPSob3cKJdQU630EJcaUdXqGDS/k3v42urUkh6ccsivB/PWiqnPTksy675AaSldLAtsIjNNVSlpn4X1sFeMX0XxNTIUKwcCgGMK1X7pD+wjJaF60zopcOhDzVZpM2vVnQX+JDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=sQRAm9gm; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="sQRAm9gm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782202794;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=QdeC4z/njHxihg/uKuAHOSoM+yrqrnLrhai8+YfV618=;
 b=sQRAm9gmzMXRtS1SlfjqeaVLxUiMYpG9a/NJoDfKqR6g36dY8Ane3dYdxSZrjd1meA6v5Y
 9AwZSFJDeAcd7ptMecMscl7icgAeLjaE0+FNiaZouk91RTCrj4b1I3KLIVOp/xLhe1bW+U
 id6tCdMlEyDv58VunkClclGf9qDRduRvC0lyZpEFjw5gdQ89DqO+1AwZ/bAYQbgaYbfwf5
 Ljhi3WFr3JLunRSTZCzFNoKrAlRJeKWTQ0Vn2rWQCs1BQIJNsyS9TSiHev+HHSsXMjOJYL
 dICGDTcsI4obnvVhGGR3i3QuS2oTbwiDYghM2r8wHyQSlt4pwncpwIsDWq/HFg==
Subject: [PATCH] md: use READ_ONCE() for lockless reads of sb_flags
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a3a41a9+1c84a3+vger.kernel.org+chencheng@fnnas.com>
Message-Id: <20260623081942.2488045-1-chencheng@fnnas.com>
X-Mailer: git-send-email 2.54.0
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
Date: Tue, 23 Jun 2026 16:19:42 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from localhost.localdomain ([183.34.170.156]) by smtp.feishu.cn with ESMTPS; Tue, 23 Jun 2026 16:19:52 +0800
X-Original-From: chencheng@fnnas.com
Content-Type: text/plain; charset=UTF-8

From: Chen Cheng <chencheng@fnnas.com>

sb_flags is checked without a lock in md, raid1, raid5, and raid10.
KCSAN reports these reads as data races.

The write side uses atomic bit ops.
The read side still has plain loads in a few places.

Use READ_ONCE() for the lockless reads of sb_flags.

KCSAN reports #1:
======================================

BUG: KCSAN: data-race in md_check_recovery / md_write_start

write (marked) to 0xffff8e39f897f030 of 8 bytes by task 248146 on cpu 8:
  md_write_start+0x5dd/0x910
  raid10_make_request+0x9b/0x1080
  md_handle_request+0x4a2/0xa40
  [........]

read to 0xffff8e39f897f030 of 8 bytes by task 250445 on cpu 11:
  md_check_recovery+0x574/0x900
  raid10d+0xb7/0x2950
  [........]

KCSAN reports #2:
======================================
BUG: KCSAN: data-race in md_check_recovery / md_write_start

write (marked) to 0xffff8e39e953f030 of 8 bytes by task 540091 on cpu 11:
  md_write_start+0x5dd/0x910
  raid1_make_request+0x141/0x1990
  [........]

read to 0xffff8e39e953f030 of 8 bytes by task 580822 on cpu 0:
  md_check_recovery+0x574/0x900
  raid1d+0xcc/0x3840
  [........]

value changed: 0x0000000000000002 -> 0x0000000000000006

KCSAN reports #3:
======================================
BUG: KCSAN: data-race in md_check_recovery / md_do_sync.cold

write (marked) to 0xffff8e39e9404030 of 8 bytes by task 492473 on cpu 6:
  md_do_sync.cold+0x3f6/0x1686
  [........]

read to 0xffff8e39e9404030 of 8 bytes by task 492402 on cpu 3:
  md_check_recovery+0x16d/0x900
  raid1d+0xcc/0x3840
  [........]

value changed: 0x0000000000000000 -> 0x0000000000000002

KCSAN reports #4:
======================================
BUG: KCSAN: data-race in md_do_sync.cold / raid5d

write (marked) to 0xffff8e39c35cb030 of 8 bytes by task 192196 on cpu 10:
  md_do_sync.cold+0x3f6/0x1686
  md_thread+0x15a/0x2d0
  [........]

read to 0xffff8e39c35cb030 of 8 bytes by task 190759 on cpu 5:
  raid5d+0x7f9/0xba0
  md_thread+0x15a/0x2d0
  [........]

value changed: 0x0000000000000000 -> 0x0000000000000002

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/md.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 096bb64e87bd..f83cca895f85 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6830,11 +6830,11 @@ int md_run(struct mddev *mddev)
 		 * via sysfs - until a lack of spares is confirmed.
 		 */
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 
-	if (mddev->sb_flags)
+	if (READ_ONCE(mddev->sb_flags))
 		md_update_sb(mddev, 0);
 
 	if (IS_ENABLED(CONFIG_MD_BITMAP) && !mddev->bitmap_info.file &&
 	    !mddev->bitmap_info.offset)
 		md_bitmap_set_none(mddev);
@@ -10294,11 +10294,11 @@ static bool md_should_do_recovery(struct mddev *mddev)
 	/*
 	 * MD_SB_CHANGE_PENDING indicates that the array is switching from clean to
 	 * active, and no action is needed for now.
 	 * All other MD_SB_* flags require to update the superblock.
 	 */
-	if (mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING))
+	if (READ_ONCE(mddev->sb_flags) & ~ (1<<MD_SB_CHANGE_PENDING))
 		return true;
 
 	/*
 	 * If the array is not using external metadata and there has been no data
 	 * written for some time, then the array's status needs to be set to
@@ -10423,11 +10423,11 @@ void md_check_recovery(struct mddev *mddev)
 			spin_lock(&mddev->lock);
 			set_in_sync(mddev);
 			spin_unlock(&mddev->lock);
 		}
 
-		if (mddev->sb_flags)
+		if (READ_ONCE(mddev->sb_flags))
 			md_update_sb(mddev, 0);
 
 		/*
 		 * Never start a new sync thread if MD_RECOVERY_RUNNING is
 		 * still set.
-- 
2.54.0
