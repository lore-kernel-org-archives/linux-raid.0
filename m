Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30A8EA5
	for <linux-raid@vger.kernel.org>; Thu, 18 Jan 2024 10:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705573866; cv=none; b=bjn1/RLVFzccbcRUGqJliBLlRpFCi00Ip9TxslkESy3iwMz9SqEh9RIjw+G+4ZwGTUlb9I9n2mHRb4QhajOevDLNU6OU7s2tz+vO520M7xv6W8WpT1U1vzAWYSL03DJw2eCVWik1PqMn8cLa/JXgf9y/WRTMdmGIBx6L+l68KdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705573866; c=relaxed/simple;
	bh=bPqdCBNCtFJ6rYiCOTKYqNDBlaXmmDRJ76b5eSdNank=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding; b=qVV9ct0onWDBl5oZABsJQ2tBmzycgAdlxyyB/foEqHpL5WHU7ccvjf5VRwgJ8q2mTLiG3eKcEgd76XQ/wAZWVspIpqYnqdDvZXVosjjabq1AWRYWA9C2EtC5Gs/b1NtJ4eOpRVJeujQW/BwkiGVINSi2lEEgtgCB2lY18NwHMBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=abWeP8rU; arc=none smtp.client-ip=134.134.136.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="abWeP8rU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705573864; x=1737109864;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bPqdCBNCtFJ6rYiCOTKYqNDBlaXmmDRJ76b5eSdNank=;
  b=abWeP8rUe2g6TurQSCOrpqp06pmpWaSIfU81rZokHjiVDT1Nihve6hjf
   /UyOhbGumINfmQk6roW13b4HcG7Hn5B+k76NAPQnIpiDfvrUEfSVsj2Jb
   fEk7lZ9QsrhZyyUBcj9DmErFCqhzwJ3LANjyDVFXXWqmf0n8gABLokJKN
   Ms45oHQLFzR5t68GjfpdsByA8jbg2uEgERd0L3oVuZruVGly4o1tKAFBZ
   X0xaKG0js9Ibxgnwm+FBq6TLgkMOrspjIE13u8tVU5WlJbiZUjksJChgj
   bEK8yN2Hu7OW4xNAP7hszTA5CpVPwOutJc1rLpv6YjzpBtnmJ7TYjhIml
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="390858574"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="390858574"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2024 02:31:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="1115927098"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="1115927098"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jan 2024 02:31:02 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH v2 4/5] Grow: Move update_tail assign to Grow_reshape()
Date: Thu, 18 Jan 2024 11:30:18 +0100
Message-Id: <20240118103019.12385-5-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240118103019.12385-1-mateusz.kusiak@intel.com>
References: <20240118103019.12385-1-mateusz.kusiak@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Due to e919fb0af245 ("FIX: Enable metadata updates for raid0") code
can't enter super-intel.c:3415, resulting in checkpoint not being
saved to metadata for second volume in matrix raid array.
This results in checkpoint being stuck at last value for the
first volume.

Move st->update_tail to Grow_reshape() so it is assigned for each
volume.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Grow.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/Grow.c b/Grow.c
index f95dae82ef0d..5498e54fec11 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2085,9 +2085,10 @@ int Grow_reshape(char *devname, int fd,
 			if (!mdmon_running(st->container_devnm))
 				start_mdmon(st->container_devnm);
 			ping_monitor(container);
-			if (mdmon_running(st->container_devnm) &&
-					st->update_tail == NULL)
-				st->update_tail = &st->updates;
+			if (mdmon_running(st->container_devnm) == false) {
+				pr_err("No mdmon found. Grow cannot continue.\n");
+				goto release;
+			}
 		}
 
 		if (s->size == MAX_SIZE)
@@ -3048,6 +3049,8 @@ static int reshape_array(char *container, int fd, char *devname,
 		dprintf("Cannot get array information.\n");
 		goto release;
 	}
+	if (st->update_tail == NULL)
+		st->update_tail = &st->updates;
 	if (array.level == 0 && info->component_size == 0) {
 		get_dev_size(fd, NULL, &array_size);
 		info->component_size = array_size / array.raid_disks;
@@ -5152,9 +5155,7 @@ int Grow_continue_command(char *devname, int fd,
 			start_mdmon(container);
 		ping_monitor(container);
 
-		if (mdmon_running(container))
-			st->update_tail = &st->updates;
-		else {
+		if (mdmon_running(container) == false) {
 			pr_err("No mdmon found. Grow cannot continue.\n");
 			ret_val = 1;
 			goto Grow_continue_command_exit;
-- 
2.35.3

