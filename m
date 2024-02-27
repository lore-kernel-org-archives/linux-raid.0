Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA70413B2BF
	for <linux-raid@vger.kernel.org>; Tue, 27 Feb 2024 13:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040764; cv=none; b=n5fNePZcoIJ/xPXpBduTKLkStC17Q6ZKEVg3A7Ybotg4nebvWK01v0slF5g0N11JBgxoyI03RJIow/SBjd8Mt78Au0/fivd4mAiX56WepnUpjEfBMfm2bzvEQDnUDjuArEwKd2PTLOn7RZzVGy+4P2hbO26wZmAU3RUuPLFoQ3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040764; c=relaxed/simple;
	bh=6dkWWpZomI97txH1DEAWQCXefwRfzaIPXBG/+G81Stw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=F2oZflUowoSLala2ne+jvKGI0J6TB7cSHxNm7WUJnDQdf71sb3V3z+i62a8PWAqxaj35kQjKHFScJYQ0IgdkRaJ8y6g/GcsM1lLtT6G9Irjp12yw1CJ1hqdUhhp0O8UD0XMaSwW7XQa0wqaW+Y59WuG4HLVZfJFAHYJhSRFc/dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wzk4t5JJ; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wzk4t5JJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709040763; x=1740576763;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6dkWWpZomI97txH1DEAWQCXefwRfzaIPXBG/+G81Stw=;
  b=Wzk4t5JJrrQ8SjMXX7TdbvyJiJSahNKOWiNTUaiboUxbFiy5/jNLk6wW
   rrPLlNBb4uE1WdHx1mfL59VBj+2YhVXNXeZTeDkJbsm8X2tMz9DhfqOe5
   GAVNurz6ocS84iicq9oQ7Zwp50wsa9iwTXj7IAYhviDNlvNadqtTWo662
   23+8+9eIZ9lASXw7gF9Xgc6bDQ770eUMLwCPODMWi/eVnguXfUvzj9Dur
   EU2plWdmxAEYc6pOBydw0KQSFUNTbrV4OdLmKfV6Tr1pVebCJn1qc+0fo
   sIdUggL/6q/v95dCMJdJx+mltzOidtLZe5IE9Y5pQHHPq+jbq41bkF1gh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="14017527"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="14017527"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 05:32:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="7190172"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by fmviesa008.fm.intel.com with ESMTP; 27 Feb 2024 05:32:41 -0800
From: Kinga Tanska <kinga.tanska@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH] Detail: remove duplicated code
Date: Tue, 27 Feb 2024 07:36:56 +0100
Message-Id: <20240227063656.31511-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove duplicated code from Detail(), where MD_UUID
and MD_DEVNAME are being set. Superblock is no longer
required to print system properties. Now it tries to
obtain map in two ways.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Detail.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/Detail.c b/Detail.c
index 57ac336f..92affdc6 100644
--- a/Detail.c
+++ b/Detail.c
@@ -226,6 +226,9 @@ int Detail(char *dev, struct context *c)
 		str = map_num(pers, array.level);
 
 	if (c->export) {
+		char nbuf[64];
+		struct map_ent *mp = NULL, *map = NULL;
+
 		if (array.raid_disks) {
 			if (str)
 				printf("MD_LEVEL=%s\n", str);
@@ -247,32 +250,22 @@ int Detail(char *dev, struct context *c)
 				       array.minor_version);
 		}
 
-		if (st && st->sb && info) {
-			char nbuf[64];
-			struct map_ent *mp, *map = NULL;
-
-			fname_from_uuid(st, info, nbuf, ':');
-			printf("MD_UUID=%s\n", nbuf + 5);
+		if (info)
 			mp = map_by_uuid(&map, info->uuid);
+		if (!mp)
+			mp = map_by_devnm(&map, fd2devnm(fd));
 
-			if (mp && mp->path && strncmp(mp->path, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0)
+		if (mp) {
+			__fname_from_uuid(mp->uuid, 0, nbuf, ':');
+			printf("MD_UUID=%s\n", nbuf + 5);
+			if (mp->path && strncmp(mp->path, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0)
 				printf("MD_DEVNAME=%s\n", mp->path + DEV_MD_DIR_LEN);
+		}
 
+		map_free(map);
+		if (st && st->sb) {
 			if (st->ss->export_detail_super)
 				st->ss->export_detail_super(st);
-			map_free(map);
-		} else {
-			struct map_ent *mp, *map = NULL;
-			char nbuf[64];
-			mp = map_by_devnm(&map, fd2devnm(fd));
-			if (mp) {
-				__fname_from_uuid(mp->uuid, 0, nbuf, ':');
-				printf("MD_UUID=%s\n", nbuf+5);
-			}
-			if (mp && mp->path && strncmp(mp->path, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0)
-				printf("MD_DEVNAME=%s\n", mp->path + DEV_MD_DIR_LEN);
-
-			map_free(map);
 		}
 		if (!c->no_devices && sra) {
 			struct mdinfo *mdi;
-- 
2.26.2

