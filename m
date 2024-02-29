Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541F77D08F
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 11:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709207561; cv=none; b=ljJI8QXnZxofPO8+kn6wU9u5SvBz7kzzmidcPGuZsqzdBx+ZWpVKUQGiocVswi6NkeMHjchYC9Sm3mUMZ3APzDeMBlwG2+hbs9ZyKEs1D4IwB3XKNwvTDQu7jrZKPuaPjNpSMGSKx+4LL+8MyKllDpnc+52VDJK8kz7zFpwi2xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709207561; c=relaxed/simple;
	bh=h9gOizwth+MPJhkWRSjQ2l0unH0C3wJPxgmuuP639tc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qdw8Tr50gF2p0ADiH6MJ0Evf5c2IXlo7W4dKjaquSex2wNOCxIKwLejkgpGnHXcP1njoD0MbeRjGNICGWuIR35bXeAp2QnbgYwo/hTTjkOXSBtaYy7PM0WuyYTPSU3HR96j+VqSlUD8UR05nJziwTCKffW6yVx4Z1S4Yq88WLEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YXZNShVf; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YXZNShVf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709207560; x=1740743560;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h9gOizwth+MPJhkWRSjQ2l0unH0C3wJPxgmuuP639tc=;
  b=YXZNShVfUQL5Q+4sI7YbL16NQNOsAmKI9TzF9pMy6rM+uNwX2rq49rzb
   3i2aIjHFhYKtxzvdtg7ViMjr0mf9lPwIgJqZzHF5v931mnTts9HVfSkAV
   Fycs16AahGP7eTKJKyFqesfdiioeGIyWCZyb8ae4EJVy/7kVEavt6KyTT
   Wf7WafWU8g0X+HjcW4vAHOz4t8eIbBVc0C1E4tO4xj3fToAl9SYLuVhLw
   b5+oRcD94syC9E87xq18ol6u77Pzwj3odqkZieI55WeR0CM5cswYLBCgm
   3VDi+Vl6JQxXII3lTHfVK4Vu+eMPJfkGzLXlqgCvWjYAQcd0cbEdEy2jV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="7499459"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7499459"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7754817"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:39 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 06/13] mdadm.h: Introduce custom device policies
Date: Thu, 29 Feb 2024 12:52:10 +0100
Message-Id: <20240229115217.26543-7-mariusz.tkaczyk@linux.intel.com>
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

The approach proposed here is to test drive policies outside
validate_geometry() separately per every drive and add determined
policies to list. The implementation reuses dev_policy we have in
mdadm.

This concept addresses following problems:
- test drives if they fit together to criteria required by metadata
  handler,
- test all drives assigned to the container even if some of them are not
  target of the request, mdmon is free to use any drive in the same
  container,
- extensibility, new policies can be added to handler easy,
- fix issues related to imsm controller domain verifying.

Add superswitch function. It is used in next patches.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 mdadm.h | 54 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 18 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 39b86bd08029..889f4a0f1ecf 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -940,6 +940,23 @@ struct reshape {
 	unsigned long long new_size; /* New size of array in sectors */
 };
 
+/**
+ * struct dev_policy - Data structure for policy management.
+ * @next: pointer to next dev_policy.
+ * @name: policy name, category.
+ * @metadata: the metadata type it affects.
+ * @value: value of the policy.
+ *
+ * The functions to manipulate dev_policy lists do not free elements, so they must be statically
+ * allocated. @name and @metadata can be compared by address.
+ */
+typedef struct dev_policy {
+	struct dev_policy *next;
+	char *name;
+	const char *metadata;
+	const char *value;
+} dev_policy_t;
+
 /* A superswitch provides entry point to a metadata handler.
  *
  * The superswitch primarily operates on some "metadata" that
@@ -1168,6 +1185,25 @@ extern struct superswitch {
 				 char *subdev, unsigned long long *freesize,
 				 int consistency_policy, int verbose);
 
+	/**
+	 * test_and_add_drive_policies() - test new and add custom policies from metadata handler.
+	 * @pols: list of currently recorded policies.
+	 * @disk_fd: file descriptor of the device to check.
+	 * @verbose: verbose flag.
+	 *
+	 * Used by IMSM to verify all drives in container/array, against requirements not recored
+	 * in superblock, like controller type for IMSM. It should check all drives even if
+	 * they are not actually used, because mdmon or kernel are free to use any drive assigned to
+	 * container automatically.
+	 *
+	 * Generating and comparison methods belong to metadata handler. It is not mandatory to be
+	 * implemented.
+	 *
+	 * Return: MDADM_STATUS_SUCCESS is expected on success.
+	 */
+	mdadm_status_t (*test_and_add_drive_policies)(dev_policy_t **pols, int disk_fd,
+						      const int verbose);
+
 	/* Return a linked list of 'mdinfo' structures for all arrays
 	 * in the container.  For non-containers, it is like
 	 * getinfo_super with an allocated mdinfo.*/
@@ -1372,23 +1408,6 @@ extern int get_dev_sector_size(int fd, char *dname, unsigned int *sectsizep);
 extern int must_be_container(int fd);
 void wait_for(char *dev, int fd);
 
-/*
- * Data structures for policy management.
- * Each device can have a policy structure that lists
- * various name/value pairs each possibly with a metadata associated.
- * The policy list is sorted by name/value/metadata
- */
-struct dev_policy {
-	struct dev_policy *next;
-	char *name;	/* None of these strings are allocated.  They are
-			 * all just references to strings which are known
-			 * to exist elsewhere.
-			 * name and metadata can be compared by address equality.
-			 */
-	const char *metadata;
-	const char *value;
-};
-
 extern char pol_act[], pol_domain[], pol_metadata[], pol_auto[];
 
 /* iterate over the sublist starting at list, having the same
@@ -1430,7 +1449,6 @@ extern struct dev_policy *disk_policy(struct mdinfo *disk);
 extern struct dev_policy *devid_policy(int devid);
 extern void dev_policy_free(struct dev_policy *p);
 
-//extern void pol_new(struct dev_policy **pol, char *name, char *val, char *metadata);
 extern void pol_add(struct dev_policy **pol, char *name, char *val, char *metadata);
 extern struct dev_policy *pol_find(struct dev_policy *pol, char *name);
 
-- 
2.35.3

