Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA681514DE
	for <linux-raid@vger.kernel.org>; Tue,  7 May 2024 10:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715078308; cv=none; b=qr2JOetUDQb29fu2QoNgL1hJi5iknnkX69xl8kXM6frKiBNBfnV261g0oBubo8YNeHFIVgsJ7ZjYEndEP84T1WJG05dm18XtdbxwAgsu376//M0tZsPgZntUqcsDxrxyTbTVZkMTkhy72WsK2rSVbdIpG3i/IDL8FPg1PZVhX0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715078308; c=relaxed/simple;
	bh=Ow/2ZiuYhj1D/LkiTSLPO7vB/dFcIuXBGw+Fexw1p4s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nxDFdLSVztk+oG4y1LP7DTV+9TTZ0Owl9FHHWwamutWwmao9aZknamxRbi27IK0NQu5Smy3xh1V5NXBX9WRxWq5BUdrm0+HUNQ2j7uPcu4btIkZbE0dbLIiK2U7s7CP0cxua4zNiC4KO0lMi/Daq81xYKLlhd2MX9zILMCTHXoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OHM/Nkgg; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OHM/Nkgg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715078307; x=1746614307;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ow/2ZiuYhj1D/LkiTSLPO7vB/dFcIuXBGw+Fexw1p4s=;
  b=OHM/NkggWYp9e5P2agxgngAxui1XYVvN95UiK//u0T57+kRvw5AF+ewt
   8wKwMCYVrzRaqqr6+eo1clhCSyyM+pVnXDFt0SGpiz2n4MpIl0FlfdMYg
   yx/8HWN4utYkxlzUjzbIGf3AWVMQYFHPk3xP1UDJqBZMR1/gwAgB6BmBu
   Eu8pkhSd8XMFa7mcghzK+vgQM+FftNSt3Pq3jCJKZvU+ZKxJqVNwQKwgb
   pVw6/my7HGWJfSWBC8g3JU3Uav9jRFXK/lXcwhxOeB0f0AANO05ML7sut
   l0SuZMkO9LnFKwhcPoWHpRwmvSxUb92jafkhESfgrv528B4EnmqTq9jMZ
   Q==;
X-CSE-ConnectionGUID: rJK2mfOHSLyjS/9gvTnaHw==
X-CSE-MsgGUID: 1v87zeb2TV6lfkZntZYOmQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="21416744"
X-IronPort-AV: E=Sophos;i="6.07,261,1708416000"; 
   d="scan'208";a="21416744"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 03:38:26 -0700
X-CSE-ConnectionGUID: g1m+aX2cSIqYgqM31Fn2nw==
X-CSE-MsgGUID: HSn3WwtgShG+eLlV9eAu3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,261,1708416000"; 
   d="scan'208";a="59335664"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orviesa002.jf.intel.com with ESMTP; 07 May 2024 03:38:25 -0700
From: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 2/2] Wait for mdmon when it is stared via systemd
Date: Tue,  7 May 2024 05:38:56 +0200
Message-Id: <20240507033856.2195-3-kinga.stefaniuk@intel.com>
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

When mdmon is being started it may need few seconds to start.
For now, we didn't wait for it. Introduce wait_for_mdmon()
function, which waits up to 5 seconds for mdmon to start completely.

Signed-off-by: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
---
 Assemble.c |  4 ++--
 Grow.c     |  7 ++++---
 mdadm.h    |  2 ++
 util.c     | 29 +++++++++++++++++++++++++++++
 4 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index f6c5b99e25e2..9cb1747df0a3 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -2175,8 +2175,8 @@ int assemble_container_content(struct supertype *st, int mdfd,
 			if (!mdmon_running(st->container_devnm))
 				start_mdmon(st->container_devnm);
 			ping_monitor(st->container_devnm);
-			if (mdmon_running(st->container_devnm) &&
-			    st->update_tail == NULL)
+			if (wait_for_mdmon(st->container_devnm) == MDADM_STATUS_SUCCESS &&
+			    !st->update_tail)
 				st->update_tail = &st->updates;
 		}
 
diff --git a/Grow.c b/Grow.c
index 074f19956e17..0e44fae4891e 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2085,7 +2085,7 @@ int Grow_reshape(char *devname, int fd,
 			if (!mdmon_running(st->container_devnm))
 				start_mdmon(st->container_devnm);
 			ping_monitor(container);
-			if (mdmon_running(st->container_devnm) == false) {
+			if (wait_for_mdmon(st->container_devnm) != MDADM_STATUS_SUCCESS) {
 				pr_err("No mdmon found. Grow cannot continue.\n");
 				goto release;
 			}
@@ -3176,7 +3176,8 @@ static int reshape_array(char *container, int fd, char *devname,
 			if (!mdmon_running(container))
 				start_mdmon(container);
 			ping_monitor(container);
-			if (mdmon_running(container) && st->update_tail == NULL)
+			if (wait_for_mdmon(container) == MDADM_STATUS_SUCCESS &&
+			    !st->update_tail)
 				st->update_tail = &st->updates;
 		}
 	}
@@ -5140,7 +5141,7 @@ int Grow_continue_command(char *devname, int fd,
 			start_mdmon(container);
 		ping_monitor(container);
 
-		if (mdmon_running(container) == false) {
+		if (wait_for_mdmon(container) != MDADM_STATUS_SUCCESS) {
 			pr_err("No mdmon found. Grow cannot continue.\n");
 			ret_val = 1;
 			goto Grow_continue_command_exit;
diff --git a/mdadm.h b/mdadm.h
index af4c484afdf7..9b8fb3f6f8d8 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1769,6 +1769,8 @@ extern struct superswitch *version_to_superswitch(char *vers);
 
 extern int mdmon_running(const char *devnm);
 extern int mdmon_pid(const char *devnm);
+extern mdadm_status_t wait_for_mdmon(const char *devnm);
+
 extern int check_env(char *name);
 extern __u32 random32(void);
 extern void random_uuid(__u8 *buf);
diff --git a/util.c b/util.c
index 65056a19e2cd..df12cf2bb2b1 100644
--- a/util.c
+++ b/util.c
@@ -1921,6 +1921,35 @@ int mdmon_running(const char *devnm)
 	return 0;
 }
 
+/*
+ * wait_for_mdmon() - Waits for mdmon within specified time.
+ * @devnm: Device for which mdmon should start.
+ *
+ * Function waits for mdmon to start. It may need few seconds
+ * to start, we set timeout to 5, it should be sufficient.
+ * Do not wait if mdmon has been started.
+ *
+ * Return: MDADM_STATUS_SUCCESS if mdmon is running, error code otherwise.
+ */
+mdadm_status_t wait_for_mdmon(const char *devnm)
+{
+	const time_t mdmon_timeout = 5;
+	time_t start_time = time(0);
+
+	if (mdmon_running(devnm))
+		return MDADM_STATUS_SUCCESS;
+
+	pr_info("Waiting for mdmon to start\n");
+	while (time(0) - start_time < mdmon_timeout) {
+		sleep_for(0, MSEC_TO_NSEC(200), true);
+		if (mdmon_running(devnm))
+			return MDADM_STATUS_SUCCESS;
+	};
+
+	pr_err("Timeout waiting for mdmon\n");
+	return MDADM_STATUS_ERROR;
+}
+
 int start_mdmon(char *devnm)
 {
 	int i;
-- 
2.35.3

