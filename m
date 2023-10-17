Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD39CDB482
	for <linux-raid@archiver.kernel.org>; Tue, 17 Oct 2023 12:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbjJQMgl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Oct 2023 08:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbjJQMgl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 Oct 2023 08:36:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC86F9
        for <linux-raid@vger.kernel.org>; Tue, 17 Oct 2023 05:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697546154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MDW3T2R5dRMiztG4VH5b0Y19QorRcBd/FLLYJuBndKA=;
        b=LSf7dqXr4u6rayZdZwF5WzTrsTqzlB2/kJmJBxZQD2gCHX+EPL0+gH7WiZR0iFE4l2Q/dD
        IugQF4tAn2AWK5dBEI/AbksWQvsYr91EOfBh9Zscxzoj2g/z88oiXAdm5kAb2R0B/35V8G
        k2/XcBXyvbccDiO6X+IhqnVpfzS+oV4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-8bQ3bOsMPNWn00uZmK92SA-1; Tue, 17 Oct 2023 08:35:51 -0400
X-MC-Unique: 8bQ3bOsMPNWn00uZmK92SA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC43B1C294B6;
        Tue, 17 Oct 2023 12:35:50 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.171])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABEAB2027019;
        Tue, 17 Oct 2023 12:35:48 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     mariusz.tkaczyk@linux.intel.com, colyli@suse.de, neilb@suse.de,
        linux-raid@vger.kernel.org
Subject: [PATCH V3 1/1] mdadm/super1: Add MD_FEATURE_RAID0_LAYOUT if kernel>=5.4
Date:   Tue, 17 Oct 2023 20:35:46 +0800
Message-Id: <20231017123546.46292-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

After and include kernel v5.4, it adds one feature bit MD_FEATURE_RAID0_LAYOUT.
It must need to specify a layout for raid0 with more than one zone. But for
raid0 with one zone, in fact it also has a defalut layout.

Now for raid0 with one zone, *unknown* layout can be seen when running mdadm -D
command. It's the reason that mdadm doesn't set MD_FEATURE_RAID0_LAYOUT for
raid0 with one zone. Then in kernel space, super_1_validate sets mddev->layout
to -1 because of no MD_FEATURE_RAID0_LAYOUT. In fact, in raid0 io path, it
uses the default layout. Set raid0_need_layout to true if kernel_version<=v5.4.

Fixes: 329dfc28debb ('Create: add support for RAID0 layouts.')
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 super1.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/super1.c b/super1.c
index 856b02082662..1da71b98d29e 100644
--- a/super1.c
+++ b/super1.c
@@ -1967,6 +1967,14 @@ fail_to_write:
 	return 1;
 }
 
+static bool has_raid0_layout(struct mdp_superblock_1 *sb)
+{
+	if (sb->level == 0 && sb->layout != 0)
+		return true;
+	else
+		return false;
+}
+
 static int write_init_super1(struct supertype *st)
 {
 	struct mdp_superblock_1 *sb = st->sb;
@@ -1978,12 +1986,17 @@ static int write_init_super1(struct supertype *st)
 	unsigned long long sb_offset;
 	unsigned long long data_offset;
 	long bm_offset;
-	int raid0_need_layout = 0;
+	bool raid0_need_layout = false;
+
+	/* Since linux kernel v5.4, raid0 always has a layout */
+	if (has_raid0_layout(sb) && get_linux_version() >= 5004000)
+		raid0_need_layout = true;
 
 	for (di = st->info; di; di = di->next) {
 		if (di->disk.state & (1 << MD_DISK_JOURNAL))
 			sb->feature_map |= __cpu_to_le32(MD_FEATURE_JOURNAL);
-		if (sb->level == 0 && sb->layout != 0) {
+		if (has_raid0_layout(sb) && !raid0_need_layout) {
+
 			struct devinfo *di2 = st->info;
 			unsigned long long s1, s2;
 			s1 = di->dev_size;
@@ -1995,7 +2008,7 @@ static int write_init_super1(struct supertype *st)
 				s2 -= di2->data_offset;
 			s2 /= __le32_to_cpu(sb->chunksize);
 			if (s1 != s2)
-				raid0_need_layout = 1;
+				raid0_need_layout = true;
 		}
 	}
 
-- 
2.32.0 (Apple Git-132)

