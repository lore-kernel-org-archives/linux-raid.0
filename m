Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814FDC19F29
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238173AbiG1MVs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238219AbiG1MVi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:21:38 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578A86BD40
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:21:37 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 0CB701FD87;
        Thu, 28 Jul 2022 12:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U9XhzCBU05u9cSob+W3rtrj5xw/SOmzmxQ6giOUlhwE=;
        b=v4CgP91cAuS5zmXyBr3oa3/19W6W5jVcEIZUCAXqMC4pE0GR0+PejPah/px8wDGfxiXWiG
        8FmgaqPsvzhBOWw3CAahUW0daaVHG485M3D+mnqWy34bUjmT38SDKFny5ejEawo5W581D5
        NZ/Of8qTpwpBFCuavR3C5TxO288qnQE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010896;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U9XhzCBU05u9cSob+W3rtrj5xw/SOmzmxQ6giOUlhwE=;
        b=dI23la/UJCrNakhM1PnyIc9l6V9z/eN8FVTRC4IAtfqJ0zcJpYS2WVjbSDta4j1W/YAvmI
        1YIbt7ZTWbcvn2DQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 25A922C141;
        Thu, 28 Jul 2022 12:21:32 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Wu Guanghao <wuguanghao3@huawei.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 06/23] mdadm: Fix mdadm -r remove option regression
Date:   Thu, 28 Jul 2022 20:20:44 +0800
Message-Id: <20220728122101.28744-7-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

The commit noted below globally adds a parameter to the -r option but
missed the fact that -r is used for another purpose: --remove.

After that commit, a command such as:

  mdadm /dev/md0 -r /dev/loop0

will do nothing seeing the device parameter will be consumed as a
argument to the -r option; thus, there will only be one device
seen one the command line, devs_found will only be 1 and nothing will
happen.

This caused the 01r5integ and 01raid6integ tests to hang indefinitely
as mdadm did not remove the failed device. With the device not removed,
it would not be read. Then the loop waiting for the array status to
change would loop forever.

This commit was recently reverted, but the legitimate fix for the
monitor operations was still not fixed. So add specific monitor
short ops to re-fix the --monitor -r option.

[Coly Li fixes the typo in commit log from 'readded' to 'read']

Fixes: 546047688e1c ("mdadm: fix coredump of mdadm --monitor -r")
Fixes: 190dc029b141 ("Revert "mdadm: fix coredump of mdadm --monitor -r"")
Cc: Wu Guanghao <wuguanghao3@huawei.com>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 ReadMe.c | 1 +
 mdadm.c  | 1 +
 mdadm.h  | 1 +
 3 files changed, 3 insertions(+)

diff --git a/ReadMe.c b/ReadMe.c
index bec1be9a..7518a32a 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -82,6 +82,7 @@ char Version[] = "mdadm - v" VERSION " - " VERS_DATE EXTRAVERSION "\n";
  */
 
 char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
+char short_monitor_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:r:n:x:u:c:d:z:U:N:safRSow1tye:k:";
 char short_bitmap_options[]=
 		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
 char short_bitmap_auto_options[]=
diff --git a/mdadm.c b/mdadm.c
index be40686c..d0c5e6de 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -227,6 +227,7 @@ int main(int argc, char *argv[])
 			shortopt = short_bitmap_auto_options;
 			break;
 		case 'F': newmode = MONITOR;
+			shortopt = short_monitor_options;
 			break;
 		case 'G': newmode = GROW;
 			shortopt = short_bitmap_options;
diff --git a/mdadm.h b/mdadm.h
index 974415b9..163f4a49 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -419,6 +419,7 @@ enum mode {
 };
 
 extern char short_options[];
+extern char short_monitor_options[];
 extern char short_bitmap_options[];
 extern char short_bitmap_auto_options[];
 extern struct option long_options[];
-- 
2.35.3

