Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5EB7D093
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 11:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709207569; cv=none; b=t2pKcn1gdgckK151F89dR40zD6kJl5DNsZPIbuffOodL+2N3XbnNji/re4kvqU3zb1aF4iX2GfPra2FO+bcc1/u11cpINgxibhiqz2fpQHwtQQeIEtDSc8pE6CNd61TGtO66bIJ5g1htDIVPcY36qaJK55QlwtUduuCuRv4Urjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709207569; c=relaxed/simple;
	bh=ts4p6LUs0IqtA8E3ayb9P24fls8CTLXN3+19kp3yuY0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=alHZhMjt2JkgQFyP1IFlZdt2bNrid84RvWvPIva+Tb2tyJ/oYUk2eAiCAXvJ8cTMBxogbsh8J5UMRL6yN6kYvPyEQtRBL/7Ht549Dc7Rb7ckPT7t5jalu8IxVfMTrzOREIZkgMSiJv3KzKEZJI6AZoZqB5wYOEWjZUlmc3QnCJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aPddNZa4; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aPddNZa4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709207568; x=1740743568;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ts4p6LUs0IqtA8E3ayb9P24fls8CTLXN3+19kp3yuY0=;
  b=aPddNZa4ZV4lSRjWUDLV1PZMZsYoKKW5SBeQaEMQN9eaOl/GTcxRZh5G
   jtkRV+bY5PesJlPQYOGUBBxREvTmuYOn86nFfdljYM2Fg1JT7tI9lq3ep
   9F5duuApe4PLCpNyYhc0W+05C4IYZQB8W/1VFJdPWWZV7TPGlVcj9+NNF
   oxAq9xzmgelShNc+fyPoURGy5P3nfGf81Edeev8AcSWGQTPeyRgZGm4g7
   LfTBZeIAjY3ZklQ9URAS+T5ZPF/rr68EMlifpa73zZM8q65PNrMKbVhpD
   W85xC1uwy3IKAxxgS47iggsqPhhpPPXpbGgnNowAmd1X32D+bPqe8Qkwj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="7499476"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7499476"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7754836"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:47 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 10/13] Monitor, Incremental: use device policies
Date: Thu, 29 Feb 2024 12:52:14 +0100
Message-Id: <20240229115217.26543-11-mariusz.tkaczyk@linux.intel.com>
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

spare_criteria is expanded to contain policies which will be generated
by handler's get_spare_criteria() function. It provides a way to
test device for metadata specific policies earlier than during
add_do_super(), when device is already removed from previous
array/container for Monitor.

For Incremental, it ensures that all criteria are tested when trying
spare. It is not tested when device contains valid metadata.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Incremental.c |  2 +-
 Monitor.c     |  3 ++-
 mdadm.h       |  5 +++--
 util.c        | 13 +++++++++----
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 66c2cc86dc5a..958ba9ba7851 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -865,7 +865,7 @@ mdadm_status_t incremental_external_test_spare_criteria(struct supertype *st, ch
 		goto out;
 	}
 
-	if (!disk_fd_matches_criteria(disk_fd, &sc)) {
+	if (!disk_fd_matches_criteria(dup, disk_fd, &sc)) {
 		if (verbose > 1)
 			pr_err("Disk does not match spare criteria for %s\n", container_devname);
 		goto out;
diff --git a/Monitor.c b/Monitor.c
index 2167523ca3e2..caf6e79f1066 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -1042,7 +1042,7 @@ static dev_t choose_spare(struct state *from, struct state *to,
 			    test_partition_from_id(from->devid[d]))
 				continue;
 
-			if (devid_matches_criteria(from->devid[d], sc) == false)
+			if (devid_matches_criteria(to->metadata, from->devid[d], sc) == false)
 				continue;
 
 			pol = devid_policy(from->devid[d]);
@@ -1190,6 +1190,7 @@ static void try_spare_migration(struct state *statelist)
 				}
 			}
 			domain_free(domlist);
+			dev_policy_free(sc.pols);
 		}
 }
 
diff --git a/mdadm.h b/mdadm.h
index af2bc714bacb..cfa11391415a 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -433,6 +433,7 @@ struct spare_criteria {
 	bool criteria_set;
 	unsigned long long min_size;
 	unsigned int sector_size;
+	struct dev_policy *pols;
 };
 
 typedef enum mdadm_status {
@@ -1734,8 +1735,8 @@ extern int assemble_container_content(struct supertype *st, int mdfd,
 #define	INCR_ALREADY	4
 #define	INCR_YES	8
 
-extern bool devid_matches_criteria(dev_t devid, struct spare_criteria *sc);
-extern bool disk_fd_matches_criteria(int disk_fd, struct spare_criteria *sc);
+extern bool devid_matches_criteria(struct supertype *st, dev_t devid, struct spare_criteria *sc);
+extern bool disk_fd_matches_criteria(struct supertype *st, int disk_fd, struct spare_criteria *sc);
 extern struct mdinfo *container_choose_spares(struct supertype *st,
 					      struct spare_criteria *criteria,
 					      struct domainlist *domlist,
diff --git a/util.c b/util.c
index 041e78cf5426..05ad33436dfe 100644
--- a/util.c
+++ b/util.c
@@ -2056,12 +2056,13 @@ unsigned int __invalid_size_argument_for_IOC = 0;
 
 /**
  * disk_fd_matches_criteria() - check if device matches spare criteria.
+ * @st: supertype, not NULL.
  * @disk_fd: file descriptor of the disk.
  * @sc: criteria to test.
  *
  * Return: true if disk matches criteria, false otherwise.
  */
-bool disk_fd_matches_criteria(int disk_fd, struct spare_criteria *sc)
+bool disk_fd_matches_criteria(struct supertype *st, int disk_fd, struct spare_criteria *sc)
 {
 	unsigned int dev_sector_size = 0;
 	unsigned long long dev_size = 0;
@@ -2076,17 +2077,21 @@ bool disk_fd_matches_criteria(int disk_fd, struct spare_criteria *sc)
 	    sc->sector_size != dev_sector_size)
 		return false;
 
+	if (drive_test_and_add_policies(st, &sc->pols, disk_fd, 0))
+		return false;
+
 	return true;
 }
 
 /**
  * devid_matches_criteria() - check if device referenced by devid matches spare criteria.
+ * @st: supertype, not NULL.
  * @devid: devid of the device to check.
  * @sc: criteria to test.
  *
  * Return: true if disk matches criteria, false otherwise.
  */
-bool devid_matches_criteria(dev_t devid, struct spare_criteria *sc)
+bool devid_matches_criteria(struct supertype *st, dev_t devid, struct spare_criteria *sc)
 {
 	char buf[NAME_MAX];
 	bool ret;
@@ -2102,7 +2107,7 @@ bool devid_matches_criteria(dev_t devid, struct spare_criteria *sc)
 		return false;
 
 	/* Error code inherited */
-	ret = disk_fd_matches_criteria(fd, sc);
+	ret = disk_fd_matches_criteria(st, fd, sc);
 
 	close(fd);
 	return ret;
@@ -2137,7 +2142,7 @@ struct mdinfo *container_choose_spares(struct supertype *st,
 		if (d->disk.state == 0) {
 			dev_t dev = makedev(d->disk.major,d->disk.minor);
 
-			found = devid_matches_criteria(dev, criteria);
+			found = devid_matches_criteria(st, dev, criteria);
 
 			/* check if domain matches */
 			if (found && domlist) {
-- 
2.35.3

