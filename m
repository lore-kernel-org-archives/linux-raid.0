Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B49AC433E0
	for <linux-raid@archiver.kernel.org>; Mon, 15 Mar 2021 13:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9C4661606
	for <linux-raid@archiver.kernel.org>; Mon, 15 Mar 2021 13:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhCONoV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 15 Mar 2021 09:44:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229526AbhCONoL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 15 Mar 2021 09:44:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615815850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=U0sRgo+nqV57LPSEE34OAyZmLx2a2dK3RCPLt0trdTs=;
        b=etYWgxO6L15a1w09n0f6cTXWj2phHRPNCDEAaqxowWBpqtJ67++SUmx0L0uyUe2ciH0REC
        AIUPiXUsgNW0fJ66BWkOUQIKkZ5eIpJGq8cI1EihSTB5Ca/uhBUi21HOvO4sc66z/t6aM9
        mJIWEL03dgFNFgnR/Tor8HijG7S38Mw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-fLOfeqj-OPOIpxWsXUngDQ-1; Mon, 15 Mar 2021 09:44:08 -0400
X-MC-Unique: fLOfeqj-OPOIpxWsXUngDQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52227760C8;
        Mon, 15 Mar 2021 13:44:07 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-28.pek2.redhat.com [10.72.8.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A7415C8B3;
        Mon, 15 Mar 2021 13:44:04 +0000 (UTC)
To:     yuyufen@huawei.com, song@kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        Nigel Croxon <ncroxon@redhat.com>
From:   Xiao Ni <xni@redhat.com>
Subject: raid5 crash on system which PAGE_SIZE is 64KB
Cc:     Heinz Mauelshagen <heinzm@redhat.com>, kent.overstreet@gmail.com
Message-ID: <225718c0-475c-7bd7-e067-778f7097a923@redhat.com>
Date:   Mon, 15 Mar 2021 21:44:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

We encounter one raid5 crash problem on POWER system which PAGE_SIZE is 
64KB.
I can reproduce this problem 100%.  This problem can be reproduced with 
latest upstream kernel.

The steps are:
mdadm -CR /dev/md0 -l5 -n3 /dev/sda1 /dev/sdc1 /dev/sdd1
mkfs.xfs /dev/md0 -f
mount /dev/md0 /mnt/test

The error message is:
mount: /mnt/test: mount(2) system call failed: Structure needs cleaning.

We can see error message in dmesg:
[ 6455.761545] XFS (md0): Metadata CRC error detected at 
xfs_agf_read_verify+0x118/0x160 [xfs], xfs_agf block 0x2105c008
[ 6455.761570] XFS (md0): Unmount and run xfs_repair
[ 6455.761575] XFS (md0): First 128 bytes of corrupted metadata buffer:
[ 6455.761581] 00000000: fe ed ba be 00 00 00 00 00 00 00 02 00 00 00 
00  ................
[ 6455.761586] 00000010: 00 00 00 00 00 00 03 c0 00 00 00 01 00 00 00 
00  ................
[ 6455.761590] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00  ................
[ 6455.761594] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00  ................
[ 6455.761598] 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00  ................
[ 6455.761601] 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00  ................
[ 6455.761605] 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00  ................
[ 6455.761609] 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00  ................
[ 6455.761662] XFS (md0): metadata I/O error in "xfs_read_agf+0xb4/0x1a0 
[xfs]" at daddr 0x2105c008 len 8 error 74
[ 6455.761673] XFS (md0): Error -117 recovering leftover CoW allocations.
[ 6455.761685] XFS (md0): Corruption of in-memory data detected. 
Shutting down filesystem
[ 6455.761690] XFS (md0): Please unmount the filesystem and rectify the 
problem(s)

This problem doesn't happen when creating raid device with 
--assume-clean. So the crash only happens when sync and normal
I/O write at the same time.

I tried to revert the patch set "Save memory for stripe_head buffer" and 
the problem can be fixed. I'm looking at this problem,
but I haven't found the root cause. Could you have a look?

By the way, there is a place that I can't understand. Is it a bug? 
Should we do in this way:
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5d57a5b..4a5e8ae 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1479,7 +1479,7 @@ static struct page **to_addr_page(struct 
raid5_percpu *percpu, int i)
  static addr_conv_t *to_addr_conv(struct stripe_head *sh,
                                  struct raid5_percpu *percpu, int i)
  {
-       return (void *) (to_addr_page(percpu, i) + sh->disks + 2);
+       return (void *) (to_addr_page(percpu, i) + sizeof(struct 
page*)*(sh->disks + 2));
  }

  /*
@@ -1488,7 +1488,7 @@ static addr_conv_t *to_addr_conv(struct 
stripe_head *sh,
  static unsigned int *
  to_addr_offs(struct stripe_head *sh, struct raid5_percpu *percpu)
  {
-       return (unsigned int *) (to_addr_conv(sh, percpu, 0) + sh->disks 
+ 2);
+       return (unsigned int *) (to_addr_conv(sh, percpu, 0) + 
sizeof(addr_conv_t)*(sh->disks + 2));
  }

This is introduced by commit b330e6a49d (md: convert to kvmalloc)

Regards
Xiao




