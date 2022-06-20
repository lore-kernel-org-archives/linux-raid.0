Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38CA8C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 16:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240201AbiFTQL2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 12:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiFTQL0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 12:11:26 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F234F205F1
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 09:11:25 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A81D01F74D;
        Mon, 20 Jun 2022 16:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655741484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qyvzAppj1Dgyj/HKh1c1A5ezwfksOhgr3PGuHlA2rGs=;
        b=bp/u8jVG9YDjQBuxei0EQf8MckEsgKWuHWUY9ttOQ9US2znqtbva5KIMfMcWq3qLMphcYF
        UrcRyH7EbOJOuBmS5o0z5n4+mmiGJI4pBkWjpLT61p3Axr0/RuJAABNW74fyH2D48+j7mk
        Tw7QKrm2wxmFixNjLbh5FdoduvwpDnM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655741484;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qyvzAppj1Dgyj/HKh1c1A5ezwfksOhgr3PGuHlA2rGs=;
        b=MPJALvDKeQw/v0mengnVSD5CTcbB1w9q+8Yr1/P78JNbmkm3yu4cBcUkxlE5cOlMyTB3Yn
        POSyzg1thyC0oBDw==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 9944F2C141;
        Mon, 20 Jun 2022 16:11:20 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Nigel Croxon <ncroxon@redhat.com>,
        Guanghao Wu <wuguanghao3@huawei.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 1/6] Revert "mdadm: fix coredump of mdadm --monitor -r"
Date:   Tue, 21 Jun 2022 00:10:38 +0800
Message-Id: <20220620161043.3661-2-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220620161043.3661-1-colyli@suse.de>
References: <20220620161043.3661-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Nigel Croxon <ncroxon@redhat.com>

This reverts commit 546047688e1c64638f462147c755b58119cabdc8.

mdadm: fix msg when removing a device using the short arg -r

The change from commit mdadm: fix coredump of mdadm
--monitor -r broke the printing of the return message when
passing -r to mdadm --manage, the removal of a device from
an array.

If the current code reverts this commit, both issues are
still fixed.

The original problem reported that the fix tried to address
was:  The --monitor -r option requires a parameter,
otherwise a null pointer will be manipulated when
converting to integer data, and a core dump will appear.

The original problem was really fixed with:
60815698c0a Refactor parse_num and use it to parse optarg.
Which added a check for NULL in 'optarg' before moving it
to the 'increments' variable.

New issue: When trying to remove a device using the short
argument -r, instead of the long argument --remove, the
output is empty. The problem started when commit
546047688e1c was added.

Steps to Reproduce:
1. create/assemble /dev/md0 device
2. mdadm --manage /dev/md0 -r /dev/vdxx

Actual results:
Nothing, empty output, nothing happens, the device is still
connected to the array.

The output should have stated "mdadm: hot remove failed
for /dev/vdxx: Device or resource busy", if the device was
still active. Or it should remove the device and print
a message:

mdadm: set /dev/vdd faulty in /dev/md0
mdadm: hot removed /dev/vdd from /dev/md0

The following commit should be reverted as it breaks
mdadm --manage -r.

commit 546047688e1c64638f462147c755b58119cabdc8
Author: Wu Guanghao <wuguanghao3@huawei.com>
Date:   Mon Aug 16 15:24:51 2021 +0800
mdadm: fix coredump of mdadm --monitor -r

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
Cc: Guanghao Wu <wuguanghao3@huawei.com>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: Jes Sorensen <jes@trained-monkey.org>
Acked-by: Coly Li <colyli@suse.de>
---
 ReadMe.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ReadMe.c b/ReadMe.c
index 8f873c48..bec1be9a 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -81,11 +81,11 @@ char Version[] = "mdadm - v" VERSION " - " VERS_DATE EXTRAVERSION "\n";
  *     found, it is started.
  */
 
-char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:r:n:x:u:c:d:z:U:N:safRSow1tye:k";
+char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
 char short_bitmap_options[]=
-		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
+		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
 char short_bitmap_auto_options[]=
-		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
+		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
 
 struct option long_options[] = {
     {"manage",    0, 0, ManageOpt},
-- 
2.35.3

