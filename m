Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFEF13C69A
	for <linux-raid@vger.kernel.org>; Tue,  7 May 2024 10:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715078306; cv=none; b=ETTKt9yBbJRIpHk7stJxkJWEMHsaz8TI13en6caTqJVMEtjc3t4v2HiMZ2JPoc/JXXLfOuwecbaMSWjAP4j8evsVJQL+f3iV5EJnjwnArd+0Xz13M3lR/VKloEAWbAOuOlToSkOzGQTy6hnpmSV4bFvbE2jlqj++npbvza6qBCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715078306; c=relaxed/simple;
	bh=4Z8C+7rIgiHmEhxpe+vfXfat5ZrFPxkjNP2UeOfEPJ4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h2yj15AVr+KFsx8+XR9pykYMIvZYIn7ul3VUsLTsfwM5JHn3acRM0Ybn4KNFfUb8g0+FyuTtyVWLTsOCf49gMmNPFNj8I4O8KLnH2wNobQ4XutR1SbfhwMURMiSwskPst/0T/WItvM7q4Yq2TnxtNAk6B+4wVps1P0Vrm81S6hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SBx2JeE9; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SBx2JeE9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715078304; x=1746614304;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4Z8C+7rIgiHmEhxpe+vfXfat5ZrFPxkjNP2UeOfEPJ4=;
  b=SBx2JeE9YoNzBKVXI8ZZtQzElqB6tkQ/EKMvLN/E3WJ57pJX6DkZ/0YQ
   ttOrlA7uIMwv5rg1SWlDm11QzCXzPR/9uYBHaRLAk0GVerpquZjrrxsM4
   1lpm5pBdcUumUlyoDj6YX2wMW8MFJoOpTLIm4W1lxycwmsJazOkdnemod
   jV+nKgb6POKx2B2QK6jP5KVG1HbUH9rJvVOCwvhDuIwGIPCKpVoeiBar+
   imSA98LSsa/lBHfzK1CgWN21CtjYLhBuwTfiFBFHh9sFgUNe9x2qst7Kp
   hr8Wq5xSZpjBDIdVMkwQEoUd5W+PQ6LzNL57WPWDIcglJ1WqAJ+29SjE8
   g==;
X-CSE-ConnectionGUID: eYuQZlHARdS50FF3VVJkLw==
X-CSE-MsgGUID: WUoCM59dTMKdJZz7orFJGA==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="21416741"
X-IronPort-AV: E=Sophos;i="6.07,261,1708416000"; 
   d="scan'208";a="21416741"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 03:38:24 -0700
X-CSE-ConnectionGUID: 5agx1D8NSNOeIeugQG/qCA==
X-CSE-MsgGUID: WzpxPOZOQjq5mXMDZYsqVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,261,1708416000"; 
   d="scan'208";a="59335652"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orviesa002.jf.intel.com with ESMTP; 07 May 2024 03:38:23 -0700
From: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 1/2] util.c: change devnm to const in mdmon functions
Date: Tue,  7 May 2024 05:38:55 +0200
Message-Id: <20240507033856.2195-2-kinga.stefaniuk@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240507033856.2195-1-kinga.stefaniuk@intel.com>
References: <20240507033856.2195-1-kinga.stefaniuk@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Devnm shall not be changed inside mdmon_running()
and mdmon_pid() functions, change this parameter to const.

Signed-off-by: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
---
 mdadm.h | 4 ++--
 util.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index ae2106a2f28f..af4c484afdf7 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1767,8 +1767,8 @@ extern int is_subarray_active(char *subarray, char *devname);
 extern int open_subarray(char *dev, char *subarray, struct supertype *st, int quiet);
 extern struct superswitch *version_to_superswitch(char *vers);
 
-extern int mdmon_running(char *devnm);
-extern int mdmon_pid(char *devnm);
+extern int mdmon_running(const char *devnm);
+extern int mdmon_pid(const char *devnm);
 extern int check_env(char *name);
 extern __u32 random32(void);
 extern void random_uuid(__u8 *buf);
diff --git a/util.c b/util.c
index 9e8370450a8d..65056a19e2cd 100644
--- a/util.c
+++ b/util.c
@@ -1891,7 +1891,7 @@ unsigned long long min_recovery_start(struct mdinfo *array)
 	return recovery_start;
 }
 
-int mdmon_pid(char *devnm)
+int mdmon_pid(const char *devnm)
 {
 	char path[100];
 	char pid[10];
@@ -1911,7 +1911,7 @@ int mdmon_pid(char *devnm)
 	return atoi(pid);
 }
 
-int mdmon_running(char *devnm)
+int mdmon_running(const char *devnm)
 {
 	int pid = mdmon_pid(devnm);
 	if (pid <= 0)
-- 
2.35.3

