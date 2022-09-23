Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08CCECAAD8
	for <linux-raid@archiver.kernel.org>; Fri, 23 Sep 2022 14:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbiIWO1O (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Sep 2022 10:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbiIWO0l (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 23 Sep 2022 10:26:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C28115BE5
        for <linux-raid@vger.kernel.org>; Fri, 23 Sep 2022 07:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663943199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=w180rBcBHN2Zcn2xdzc4KVZDpW6w9VEo6bhjsfHEXCg=;
        b=AvlOFOb6Fg+mpFVgJwGMItHUhkkIaHhRZYVmvQF2iABcrwUO53me6Owykn5zZFgLEYl6FR
        QE2iwX2JNS/Slk+WXgsoTTY5hjGakv0qXRW/uuleGoMsLADHyke/tg8X8HDD4Z//m0Rd70
        yUg9zoVXEitbGoQ2D50hHWZC5HArC6I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-7LkeCMd5MEur_H9NM96TaQ-1; Fri, 23 Sep 2022 10:26:36 -0400
X-MC-Unique: 7LkeCMd5MEur_H9NM96TaQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B842185A7AC;
        Fri, 23 Sep 2022 14:26:35 +0000 (UTC)
Received: from localhost (dhcp-17-75.bos.redhat.com [10.18.17.75])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D357C15BA4;
        Fri, 23 Sep 2022 14:26:35 +0000 (UTC)
From:   Nigel Croxon <ncroxon@redhat.com>
To:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        mariusz.tkaczyk@intel.com, kinga.tanska@intel.com
Subject: [PATCH] mdadm reshape hangs on external grow chunk
Date:   Fri, 23 Sep 2022 10:26:35 -0400
Message-Id: <20220923142635.470305-1-ncroxon@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

After creating a raid array on top of a imsm container. Try to
grow the chunk size and the reshape will hang with zero progress.
The reason is the computation of sync_max_to_set value:
if (before_data_disks <= data_disks)
        sync_max_to_set = sra->reshape_progress / data_disks;
    else
        sync_max_to_set = (sra->component_size * data_disks
                       - sra->reshape_progress) / data_disks;

Can produce a zero result. Which is then used to set the maximum
sync value, causing zero progress to the reshape.  The change is to
test if the sync_max_to_set value is zero. And if so, set the sysfs
sync_max to "max".

Steps to Reproduce:
1. Create a container and RAID0 array
mdadm -CR /dev/md/imsm -e imsm -n2 /dev/nvme0n1 /dev/nvme1n1
mdadm -CR  /dev/md/vol -l0 --chunk=16 -n2 /dev/nvme0n1 /dev/nvme1n1
2. Wait for resync
3. Try to grow the chunk size
mdadm --grow /dev/md/vol --chunk=256

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
 Grow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index 0f07a894..6c5021bc 100644
--- a/Grow.c
+++ b/Grow.c
@@ -943,7 +943,7 @@ int start_reshape(struct mdinfo *sra, int already_running,
 	if (!already_running)
 		sysfs_set_num(sra, NULL, "sync_min", sync_max_to_set);
 
-        if (st->ss->external)
+        if (sync_max_to_set)
 		err = err ?: sysfs_set_num(sra, NULL, "sync_max", sync_max_to_set);
 	else
 		err = err ?: sysfs_set_str(sra, NULL, "sync_max", "max");
-- 
2.31.1

