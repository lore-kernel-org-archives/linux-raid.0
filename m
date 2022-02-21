Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1376C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 21 Feb 2022 12:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357289AbiBUMGR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Feb 2022 07:06:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357301AbiBUMGO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Feb 2022 07:06:14 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EF3201B6
        for <linux-raid@vger.kernel.org>; Mon, 21 Feb 2022 04:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645445151; x=1676981151;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jOkI9RF5UAX7A5VFixOjpDdXeaZmzafDSBm7FLeiuoU=;
  b=NPfQ6ZK+IXGagICeqCT8+1Aa3yIyr/PcRjHqv+nrje7sH8je5jpR76WB
   Jy5vfNCT58e2Y+zL235rRzt3wBczsjv7ZQqt6Y8Z+pAjUjQbOYw8ZIXJK
   PT2ycra4+EDrAjM6f0s4y8+BirXhNFo7ZiPm/hCizGl45dQ7wfNWLJoEs
   nOkg4AxXxwpas21K36vlov/TT1aeFpxty7AoJS6AUA2DlnQmlXMWiNISM
   87u/BMaIRTMoc0zNp4IrfPSuzzypmoo3oIbdiSh4QlCTRVUP8Aq/ZYY+r
   X2kUwA9rVFkNeusRqzYxee+nG7j+zU0VIA1Gwi3v0JA8VIXq2yQb9k6db
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="238911152"
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="238911152"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 04:05:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="547311573"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.108.83])
  by orsmga008.jf.intel.com with ESMTP; 21 Feb 2022 04:05:50 -0800
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, pmenzel@molgen.mpg.de
Subject: [PATCH 2/2] Optimize signal setting in alert() function.
Date:   Mon, 21 Feb 2022 13:05:21 +0100
Message-Id: <20220221120521.16846-3-lukasz.florczak@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220221120521.16846-1-lukasz.florczak@linux.intel.com>
References: <20220221120521.16846-1-lukasz.florczak@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Moving signal setting in Monitor.c out of the alert() function
makes it more clear as it was set to ignore SIGPIPE every time
alert() was called, but was never set back to default again.
Now SIGPIPE is ignored for whole duration of the program just once.

Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
---
 Monitor.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 40388b64..222568cb 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -159,6 +159,9 @@ int Monitor(struct mddev_dev *devlist,
 	info.mailfrom = mailfrom;
 	info.dosyslog = dosyslog;
 
+	if (info.mailaddr)
+		signal_s(SIGPIPE, SIG_IGN);
+
 	if (share){
 		if (check_one_sharer(c->scan))
 			return 1;
@@ -436,8 +439,7 @@ static void alert(char *event, char *dev, char *disc, struct alert_info *info)
 			char hname[256];
 
 			gethostname(hname, sizeof(hname));
-			signal_s(SIGPIPE, SIG_IGN);
-			
+
 			if (info->mailfrom)
 				fprintf(mp, "From: %s\n", info->mailfrom);
 			else
-- 
2.26.2

