Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89E813A26F
	for <linux-raid@vger.kernel.org>; Tue, 27 Feb 2024 14:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044643; cv=none; b=Dbzt/SXult8123+Dp8bvqd0k4cj4aHEA8TND47yk1X0tvf97SWIHnrIzmjjK7TpHC/sLANinI2dJx50RTwTpuCIuxYnvgGrotU2Zqaumo7BqBAoxw2Glqc/NJriXLPXOqi/8BSovbjCKmfoL+o2Fw/qq1V8uIFpcy9MEgCxh/rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044643; c=relaxed/simple;
	bh=TAZuETMtx59N+TZkP2u4d//zqz8LfnjMat/UV6mqhxo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a2Art3Laf3w6cChuJ0HJbVkmrK5BBBUcI2DkTkMAmBa7Kt7GlP5bV10zW5S/gjR3n/1DoEwHOxHaBymyrxzroBlZ4GNxWjcO47wbmVKhKsrD/XaWn+8H+xm95xNz93y4qdhsYbI4Bho5LP+MkL3BZt0vtDJc38K1SCxmezvrll8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R4pn/1T+; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R4pn/1T+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709044642; x=1740580642;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TAZuETMtx59N+TZkP2u4d//zqz8LfnjMat/UV6mqhxo=;
  b=R4pn/1T+Z52ACMZGZszRUXh92h/gEfcjeaH5p4K/uqzNaLGPzIXRgi9h
   sOy/VphYoa6wiKEaL8w2gdrqR08if3Bvqd4AwT1yHWB3Ow4+c64XKnJX8
   mTniZdcHQAiot3WeHADL7BTsVAfRPsyXcXUYREIVB2M79cMBYEITgcM9X
   +2jWt01DPSGNbgcAu6tn/Q+iVGBh4Lamkm3fIS+JibrD7GgIxuMa3PtUJ
   tP8fco+ysM0exawHvhQDhDY3Jo/Vbyg50JmeGX1TQSh5QDZbu/+XnU542
   HfkSwbmSg+w7EqZD0BarFxjjbX8hrIwRAMzAHlYpFAybCB77w3duRI8wY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="28824082"
X-IronPort-AV: E=Sophos;i="6.06,188,1705392000"; 
   d="scan'208";a="28824082"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 06:37:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,188,1705392000"; 
   d="scan'208";a="30232776"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by fmviesa002.fm.intel.com with ESMTP; 27 Feb 2024 06:37:19 -0800
From: Kinga Tanska <kinga.tanska@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH,v2] Detail: remove duplicated code
Date: Tue, 27 Feb 2024 03:36:14 +0100
Message-Id: <20240227023614.32386-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove duplicated code from Detail(), where MD_UUID and MD_DEVNAME
are being set. Superblock is no longer required to print system
properties. Now it tries to obtain map in two ways.

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

