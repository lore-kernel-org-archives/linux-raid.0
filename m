Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F98C43334
	for <linux-raid@archiver.kernel.org>; Wed, 22 Jun 2022 20:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbiFVUZh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Jun 2022 16:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbiFVUZa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 16:25:30 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AD8369E7
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 13:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=xa6RljNsyJNqp8MFRueCol0W0ZcLp1UNWG1rmUJ1Rwo=; b=kSWhknefBhgd4rB5iBqgXqT38w
        IFI5eplhHGqyGsnQYvKMMzaHNZ2Lol5oAk4Skkb/MQpLkYmIeGbjV7+/5FX5FOiJHNYbgJRsMM9PG
        wRwRWb2XSqUcAcJsv378HRxOQgiHsEoB0xjaxFbGSB6PVSJrSmKV83dULjicyYf4UhsgIpaAINZSi
        yAnOqGL88KLbD8WZmZJk8v5s4yrtfa88340LARFNOt+s5qk4qTOxEfYXrOqcxdrfPvyWjPJ1IBvJL
        eLYMbdQ2P6lGZ+dr8eYLoF5SRlzy38Bv6TdRquWl8oaNSEQ/KyXLnLFBKtOgCG5ypxvxRbiuIX0Ve
        jYvjo+QA==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46uk-00EGyc-VL; Wed, 22 Jun 2022 14:25:28 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46uh-0009MJ-65; Wed, 22 Jun 2022 14:25:23 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>
Cc:     Song Liu <song@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Alex Wu <alexwu@synology.com>,
        BingJing Chang <bingjingc@synology.com>,
        Danny Shih <dannyshih@synology.com>,
        ChangSyun Peng <allenpeng@synology.com>
Date:   Wed, 22 Jun 2022 14:25:09 -0600
Message-Id: <20220622202519.35905-5-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220622202519.35905-1-logang@deltatee.com>
References: <20220622202519.35905-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, himanshu.madhani@oracle.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com, alexwu@synology.com, bingjingc@synology.com, dannyshih@synology.com, allenpeng@synology.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v2 04/14] mdadm/Grow: Fix use after close bug by closing after fork
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

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
---
 Grow.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index f6efbc48dafd..0e2d7181bcab 100644
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
2.30.2

