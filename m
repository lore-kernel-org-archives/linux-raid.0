Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A59C433EF
	for <linux-raid@archiver.kernel.org>; Mon,  4 Apr 2022 07:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377596AbiDDHLT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Apr 2022 03:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbiDDHLS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Apr 2022 03:11:18 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7F639148
        for <linux-raid@vger.kernel.org>; Mon,  4 Apr 2022 00:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649056162; x=1680592162;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=N1v7lJ1I4XkoE6pCWwj/Z3zDIWVTiFhBD0qIb+Ys8bo=;
  b=Wkmui4yDem8HuTrXPSpmHIdpkEND5f4t7fGyPVArCH7Rp3+PXy/6jQNb
   TxRps/COBvOQxtH1t9PWTGf0o2MuI9tOcZVrxxraU+86zTMSmpQTC5XtD
   zzkp6k44EwqOLjp2Zu7N6OrsF/Ay+lGirlR8mZe0nh44Yo6fNjev5URmm
   6rcNfegO1eIvVGewZgh+bGulEGaWph8nyudb8g9jFiZtTZPTA+LM9PxnZ
   q7hRyvtNCypuXaFGP+iEg8BHYNdsb0TWdl4u4hviwK5Y7CwRAzxdbOfGf
   9bnCrUORfQV+y3ZG4qOFCiVTvsjBdNNTEFqHlvE/yUDi0oI4H0Wza4iSK
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10306"; a="259284816"
X-IronPort-AV: E=Sophos;i="5.90,233,1643702400"; 
   d="scan'208";a="259284816"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 00:09:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,233,1643702400"; 
   d="scan'208";a="548549488"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.52])
  by orsmga007.jf.intel.com with ESMTP; 04 Apr 2022 00:09:21 -0700
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH] Add RAID 1 chunksize test
Date:   Mon,  4 Apr 2022 09:08:30 +0200
Message-Id: <20220404070830.7795-1-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Specifying chunksize for raid 1 is forbidden.
Add test for blocking raid 1 creation with chunksize.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 tests/01r1create-chunk | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 tests/01r1create-chunk

diff --git a/tests/01r1create-chunk b/tests/01r1create-chunk
new file mode 100644
index 00000000..717a5e5a
--- /dev/null
+++ b/tests/01r1create-chunk
@@ -0,0 +1,15 @@
+# RAID 1 volume, 2 disks, chunk 64
+# NEGATIVE test - creating raid 1 with chunksize specified is forbidden
+
+num_disks=2
+level=1
+device_list="$dev0 $dev1"
+chunk=64
+
+# Create raid 1 with chunk 64k and fail
+if ! mdadm --create --run $md0 --auto=md --level=$level --chunk=$chunk --raid-disks=$num_disks $device_list
+then
+	exit 0
+fi
+
+exit 1
-- 
2.26.2

