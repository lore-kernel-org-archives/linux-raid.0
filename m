Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3728EC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 16:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240774AbiFTQLf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 12:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241509AbiFTQLe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 12:11:34 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA678205FA
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 09:11:31 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 8A6911F8A4;
        Mon, 20 Jun 2022 16:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655741490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4TVesCTy+v61oC5jp7ukUAcoyTxz7GZTTtFsm7az5Gw=;
        b=fZsqjsHiKMJoU3AtqzzulhX1kRH0KzY/aeBtaGtwmR9lhA08n+dAXI0haNRqSQWwKIrV2F
        uHB4HcrWLp5pLlQI4VkVEZEGfGyQjMkhlMBPSnG6OjVx0Oir48PMKk4A0DYvVnGtdgW21S
        1NZ4XlQl/GkmMGhaflke+JZ2axBAJU8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655741490;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4TVesCTy+v61oC5jp7ukUAcoyTxz7GZTTtFsm7az5Gw=;
        b=QhhY8Lr+Z3WOyeDKgoZWx5bpQiSkCi+sn2wLwMeqkUiem/xASSRpYi2M6o05bX3eoOhl23
        Lf8gHmnalJtkBPCQ==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 5E12A2C141;
        Mon, 20 Jun 2022 16:11:28 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Heming Zhao <heming.zhao@suse.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 3/6] mdadm/super1: restore commit 45a87c2f31335 to fix clustered slot issue
Date:   Tue, 21 Jun 2022 00:10:40 +0800
Message-Id: <20220620161043.3661-4-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220620161043.3661-1-colyli@suse.de>
References: <20220620161043.3661-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Heming Zhao <heming.zhao@suse.com>

Commit 9d67f6496c71 ("mdadm:check the nodes when operate clustered
array") modified assignment logic for st->nodes in write_bitmap1(),
which introduced bitmap slot issue:

load_super1 didn't set up supertype.nodes, which made spare disk only
have one slot info. Then it triggered kernel md_bitmap_load_sb to get
wrong bitmap slot data.

For fixing this issue, there are two methods:

1> revert the related code of commit 9d67f6496c71. and restore the code
   from former commit 45a87c2f31335 ("super1: add more checks for
   NodeNumUpdate option").
   st->nodes value would be 0 & 1 under current code logic. i.e.
   When adding a spare disk, there is no place to init st->nodes, and
   the value is ZERO.

2> keep 9d67f6496c71, add additional ->nodes handling in load_super1(),
   let load_super1 to set st->nodes when bitmap is BITMAP_MAJOR_CLUSTERED.
   Under current mdadm code logic, load_super1 will be called many
   times, any new code in load_super1 will cost mdadm running more time.
   And more reason is I prefer as much as possible to limit clustered
   code spreading in every corner.

So I used method <1> to fix this issue.

How to trigger:

dd if=/dev/zero bs=1M count=1 oflag=direct of=/dev/sda
dd if=/dev/zero bs=1M count=1 oflag=direct of=/dev/sdb
dd if=/dev/zero bs=1M count=1 oflag=direct of=/dev/sdc
mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
mdadm -a /dev/md0 /dev/sdc
mdadm /dev/md0 --fail /dev/sda
mdadm /dev/md0 --remove /dev/sda
mdadm -Ss
mdadm -A /dev/md0 /dev/sdb /dev/sdc

the output of current "mdadm -X /dev/sdc":
(there should be (by default) 4 slot info for correct output)
```
        Filename : /dev/sdc
           Magic : 6d746962
         Version : 5
            UUID : a74642f8:a6b1fba8:58e1f8db:cfe7b082
          Events : 29
  Events Cleared : 0
           State : OK
       Chunksize : 64 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 306176 (299.00 MiB 313.52 MB)
          Bitmap : 5 bits (chunks), 5 dirty (100.0%)
```

And mdadm later operations will trigger kernel output error message:
(triggered by "mdadm -A /dev/md0 /dev/sdb /dev/sdc")
```
kernel: md0: invalid bitmap file superblock: bad magic
kernel: md_bitmap_copy_from_slot can't get bitmap from slot 1
kernel: md-cluster: Could not gather bitmaps from slot 1
kernel: md0: invalid bitmap file superblock: bad magic
kernel: md_bitmap_copy_from_slot can't get bitmap from slot 2
kernel: md-cluster: Could not gather bitmaps from slot 2
kernel: md0: invalid bitmap file superblock: bad magic
kernel: md_bitmap_copy_from_slot can't get bitmap from slot 3
kernel: md-cluster: Could not gather bitmaps from slot 3
kernel: md-cluster: failed to gather all resyn infos
kernel: md0: detected capacity change from 0 to 612352
```

Acked-by: Coly Li <colyli@suse.de>
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 super1.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/super1.c b/super1.c
index e3e2f954..3a0c69fd 100644
--- a/super1.c
+++ b/super1.c
@@ -2674,7 +2674,17 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
 		}
 
 		if (bms->version == BITMAP_MAJOR_CLUSTERED) {
-			if (__cpu_to_le32(st->nodes) < bms->nodes) {
+			if (st->nodes == 1) {
+				/* the parameter for nodes is not valid */
+				pr_err("Warning: cluster-md at least needs two nodes\n");
+				return -EINVAL;
+			} else if (st->nodes == 0) {
+				/*
+				 * parameter "--nodes" is not specified, (eg, add a disk to
+				 * clustered raid)
+				 */
+				break;
+			} else if (__cpu_to_le32(st->nodes) < bms->nodes) {
 				/*
 				 * Since the nodes num is not increased, no
 				 * need to check the space enough or not,
-- 
2.35.3

