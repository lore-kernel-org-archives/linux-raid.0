Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5FFC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 21 Feb 2022 10:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354845AbiBUK1v (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Feb 2022 05:27:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354428AbiBUK10 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Feb 2022 05:27:26 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205C04090D
        for <linux-raid@vger.kernel.org>; Mon, 21 Feb 2022 01:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645436943; x=1676972943;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jOkI9RF5UAX7A5VFixOjpDdXeaZmzafDSBm7FLeiuoU=;
  b=EuqBRtdzGxpYj5Jb3Jeyc3/tvpiDYD+9VXlrtulxF68y44UM9aFQ9gfq
   9h4/ukk+B+ZMT907Fjrlb7eHW7MIElLivRM8i+xZkp5vR2UxQQCFje9M5
   itO05VFTIqe4Vdd3kJ/Vhztpn2J3P2UnLllPwl029X2m+6RED47ozpW98
   rFhoOTkEgYddJoxSRydJETdl1klxdwqB5eoft4Ihf5DAegbKzjH/6X7NM
   zJ1KWR9z/tzzAypg+z3kkvIz/sSWpCOWcMGxYyVTgbTdCKlffABcmkWCT
   zMXDAM3KKncCMZ9ky57iCTgWY30X7L3hMYTbYVjEweI24G4IywvxXUlNJ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="312221080"
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="312221080"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 01:48:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="507579684"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.108.83])
  by orsmga006.jf.intel.com with ESMTP; 21 Feb 2022 01:48:37 -0800
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, pmenzel@molgen.mpg.de
Subject: [PATCH 2/2] Optimize signal setting in alert() function.
Date:   Mon, 21 Feb 2022 10:48:36 +0100
Message-Id: <20220221094836.9586-1-lukasz.florczak@linux.intel.com>
X-Mailer: git-send-email 2.26.2
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

