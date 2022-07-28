Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB2DC04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236632AbiG1MVo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238116AbiG1MVb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:21:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD3615828
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:21:30 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id C5A101FD87;
        Thu, 28 Jul 2022 12:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vx/mmBoqAypIHwax2x8g/egP2YCqHT8jB0XGM0s7Zh8=;
        b=vAwzKDKT9YAZAe4Xy1h249jqPbUV5pxDGj1C79WU+nh5WLOJDy2fayQHqoIVe+iHkRMeIc
        7RAKgA5eu5NRzczjnMLa8EjLK3ZP0jNuW/gxcqF54iNF4Rr+1kNTeEOIUT+vRuAndACFWx
        XR/k7YoZu1QF172B8A2mJciqGnBR8z0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010888;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vx/mmBoqAypIHwax2x8g/egP2YCqHT8jB0XGM0s7Zh8=;
        b=XE+I+lBkR2zz5mz6/t6QVaCp8wmibidFO4VEFQij3p7FCkDlVO79i5YHWfVcU6d4JQWLEj
        0julJX5tKGwhqRDA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 8C2882C141;
        Thu, 28 Jul 2022 12:21:24 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Alex Wu <alexwu@synology.com>,
        BingJing Chang <bingjingc@synology.com>,
        Danny Shih <dannyshih@synology.com>,
        ChangSyun Peng <allenpeng@synology.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 04/23] mdadm/Grow: Fix use after close bug by closing after fork
Date:   Thu, 28 Jul 2022 20:20:42 +0800
Message-Id: <20220728122101.28744-5-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

The test 07reshape-grow fails most of the time. But it succeeds around
1 in 5 times. When it does succeed, it causes the tests to die because
mdadm has segfaulted.

The segfault was caused by mdadm attempting to repoen a file
descriptor that was already closed. The backtrace of the segfault
was:

  #0  __strncmp_avx2 () at ../sysdeps/x86_64/multiarch/strcmp-avx2.S:101
  #1  0x000056146e31d44b in devnm2devid (devnm=0x0) at util.c:956
  #2  0x000056146e31dab4 in open_dev_flags (devnm=0x0, flags=0)
                         at util.c:1072
  #3  0x000056146e31db22 in open_dev (devnm=0x0) at util.c:1079
  #4  0x000056146e3202e8 in reopen_mddev (mdfd=4) at util.c:2244
  #5  0x000056146e329f36 in start_array (mdfd=4,
              mddev=0x7ffc55342450 "/dev/md0", content=0x7ffc55342860,
              st=0x56146fc78660, ident=0x7ffc55342f70, best=0x56146fc6f5d0,
              bestcnt=10, chosen_drive=0, devices=0x56146fc706b0, okcnt=5,
	      sparecnt=0,  rebuilding_cnt=0, journalcnt=0, c=0x7ffc55342e90,
	      clean=1,  avail=0x56146fc78720 "\001\001\001\001\001",
	      start_partial_ok=0, err_ok=0, was_forced=0)
	                  at Assemble.c:1206
  #6  0x000056146e32c36e in Assemble (st=0x56146fc78660,
               mddev=0x7ffc55342450 "/dev/md0", ident=0x7ffc55342f70,
	       devlist=0x56146fc6e2d0, c=0x7ffc55342e90)
	                 at Assemble.c:1914
  #7  0x000056146e312ac9 in main (argc=11, argv=0x7ffc55343238)
                         at mdadm.c:1510

The file descriptor was closed early in Grow_continue(). The noted commit
moved the close() call to close the fd above the fork which caused the
parent process to return with a closed fd.

This meant reshape_array() and Grow_continue() would return in the parent
with the fd forked. The fd would eventually be passed to reopen_mddev()
which returned an unhandled NULL from fd2devnm() which would then be
dereferenced in devnm2devid.

Fix this by moving the close() call below the fork. This appears to
fix the 07revert-grow test. While we're at it, switch to using
close_fd() to invalidate the file descriptor.

Fixes: 77b72fa82813 ("mdadm/Grow: prevent md's fd from being occupied during delayed time")
Cc: Alex Wu <alexwu@synology.com>
Cc: BingJing Chang <bingjingc@synology.com>
Cc: Danny Shih <dannyshih@synology.com>
Cc: ChangSyun Peng <allenpeng@synology.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 Grow.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index 8c520d42..97f22c75 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3514,7 +3514,6 @@ started:
 			return 0;
 		}
 
-	close(fd);
 	/* Now we just need to kick off the reshape and watch, while
 	 * handling backups of the data...
 	 * This is all done by a forked background process.
@@ -3535,6 +3534,9 @@ started:
 		break;
 	}
 
+	/* Close unused file descriptor in the forked process */
+	close_fd(&fd);
+
 	/* If another array on the same devices is busy, the
 	 * reshape will wait for them.  This would mean that
 	 * the first section that we suspend will stay suspended
-- 
2.35.3

