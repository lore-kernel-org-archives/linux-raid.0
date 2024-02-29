Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6502A7CF20
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 11:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709207566; cv=none; b=HhEnJvN7lq/lf0JxansJwyCPWmqXL6gp9gI7vI7qZP5E0VAfrRJcKlmj5YEHOR1aRhEZMrxGsg7eP9H3EewfzNxKgq6A7+AJTpnp1P9esBpmnROc2AVgkaU+skl23NdHYyXK0/oxAUh4lN00JkdbD/5dyozM6h+EocT0eKYaWxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709207566; c=relaxed/simple;
	bh=u/yIiBiP8dGmr3vOfUa834I8Fi1ixb0d0Devdju7IzE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q6NfOE713qC08PMuQgKi2h/KMRtNQcUdaEIpXmEg2T8ovvd76rsJdh9Vbg0qxOxGjzihng4MHGe+Hdl7gtEP4bZD8IcceeQguVBpDRiPudqfH85ItNqXwn6r4ymYKJXoEgOA2Q07Lb/G0GPvlOakswiL8vNDdxKcECZ+6j3zkoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kdrlr1gA; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kdrlr1gA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709207564; x=1740743564;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u/yIiBiP8dGmr3vOfUa834I8Fi1ixb0d0Devdju7IzE=;
  b=kdrlr1gAfMDvX/5V9VPWqjnzHJUwABN7EU9arQCwLY/nQqCWVIyYRXuj
   rUy1+9wqm8niiPnl+Jffh46ggMdTTUVNMxQE7j31mplpk9L7dG73ZT29G
   YZcku5l2KQVWXWj4ZQZkTZ05dUBCDDTQMEaZQgt22yNDsHbebcnJfVpCr
   RztDRif/B68OUWdBhQKSWbDPKtNcM5OBOlHY1FwE+x9uttTPhtIEiFZKK
   SfkJwInKivUmaPbZKzvAV0vOoR/uDW/dDfOE+fIK2DcsIFFPfcvImlM7g
   VJ3UNVpXND1J49alD2ZbE+8qrbctkVuyWUdTtJk1YgtPkyuB5rxyVG2ua
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="7499466"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7499466"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7754827"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:43 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 08/13] Create: Use device policies
Date: Thu, 29 Feb 2024 12:52:12 +0100
Message-Id: <20240229115217.26543-9-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240229115217.26543-1-mariusz.tkaczyk@linux.intel.com>
References: <20240229115217.26543-1-mariusz.tkaczyk@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Generate and compare policies, abort if policies do not match.
It is tested for both create modes, with container and disk list
specified directly. It is used if supertype supports it.

For a case when disk list is specified, container may contain more
devices, so additional check on container is done to analyze all disks.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Create.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/Create.c b/Create.c
index 0b7762661c76..4397ff49554d 100644
--- a/Create.c
+++ b/Create.c
@@ -497,6 +497,7 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 	 */
 	int mdfd;
 	unsigned long long minsize = 0, maxsize = 0;
+	dev_policy_t *custom_pols = NULL;
 	char *mindisc = NULL;
 	char *maxdisc = NULL;
 	char *name = ident->name;
@@ -588,6 +589,9 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 				first_missing = subdevs * 2;
 				second_missing = subdevs * 2;
 				insert_point = subdevs * 2;
+
+				if (mddev_test_and_add_drive_policies(st, &custom_pols, fd, 1))
+					exit(1);
 			}
 		}
 		if (fd >= 0)
@@ -739,7 +743,7 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 			close(dfd);
 			exit(2);
 		}
-		close(dfd);
+
 		info.array.working_disks++;
 		if (dnum < s->raiddisks && dv->disposition != 'j')
 			info.array.active_disks++;
@@ -812,6 +816,11 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 			}
 		}
 
+		if (drive_test_and_add_policies(st, &custom_pols, dfd, 1))
+			exit(1);
+
+		close(dfd);
+
 		if (dv->disposition == 'j')
 			goto skip_size_check;  /* skip write journal for size check */
 
@@ -886,6 +895,7 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 			close(fd);
 		}
 	}
+
 	if (missing_disks == dnum && !have_container) {
 		pr_err("Subdevs can't be all missing\n");
 		return 1;
@@ -1140,25 +1150,30 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 		goto abort_locked;
 	}
 
-	if (did_default && c->verbose >= 0) {
+	if (did_default) {
 		if (is_subarray(info.text_version)) {
 			char devnm[MD_NAME_MAX];
 			struct mdinfo *mdi;
 
 			sysfs_get_container_devnm(&info, devnm);
 
-			mdi = sysfs_read(-1, devnm, GET_VERSION);
+			mdi = sysfs_read(-1, devnm, GET_VERSION | GET_DEVS);
 			if (!mdi) {
 				pr_err("Cannot open sysfs for container %s\n", devnm);
 				goto abort_locked;
 			}
 
-			pr_info("Creating array inside %s container /dev/%s\n", mdi->text_version,
-				devnm);
+			if (sysfs_test_and_add_drive_policies(st, &custom_pols, mdi, 1))
+				goto abort_locked;
+
+			if (c->verbose >= 0)
+				pr_info("Creating array inside %s container /dev/%s\n",
+					mdi->text_version, devnm);
 
 			sysfs_free(mdi);
-		} else
+		} else if (c->verbose >= 0) {
 			pr_info("Defaulting to version %s metadata\n", info.text_version);
+		}
 	}
 
 	map_update(&map, fd2devnm(mdfd), info.text_version,
@@ -1328,6 +1343,8 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 	udev_unblock();
 	close(mdfd);
 	sysfs_uevent(&info, "change");
+	dev_policy_free(custom_pols);
+
 	return 0;
 
  abort:
@@ -1339,5 +1356,7 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 
 	if (mdfd >= 0)
 		close(mdfd);
+
+	dev_policy_free(custom_pols);
 	return 1;
 }
-- 
2.35.3

