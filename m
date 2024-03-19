Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5889D7C6CC
	for <linux-raid@vger.kernel.org>; Tue, 19 Mar 2024 10:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710843478; cv=none; b=BSRQ0nyPc5ZGqh1GXDMYzecrnkM6j6k2i2PlJYTy1apSGPktSDNgyL92TTBeJBaZM4/RLJ4qKksH8pesY/DHvy/bxzMSRK635VgGy8mpeTmZa6TznRsm+qayKgaNqRucVRpwpsBd+IGNtw2NWCGZ8HIp4TKJwNE+jxFdlkatVqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710843478; c=relaxed/simple;
	bh=lZpOyE5AP3t4pAWF1y7sNwGoIoPjv6dYjG+zlOUl3p8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aanl82JLqTDfcg24h/TvXuGTtbjeV5nhrkpMV2JBO9m/blgLRcC9WsluH0cuogQEmh6b8lM/lh/LXnC4fr+6H0Wj3vnDBu9cl+VcCdZAEVuXvTnR4NUbTDoGHrTKJp80LYjA1ip45jM3hg4zaIgJP2xVUdeeD5SV6CW9MrIhbEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PYGBFiDR; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PYGBFiDR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710843478; x=1742379478;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lZpOyE5AP3t4pAWF1y7sNwGoIoPjv6dYjG+zlOUl3p8=;
  b=PYGBFiDRQy+0ovuNofkIzrtcJIUJ1Xy2TNTfEfENYblvg1sdZKugbddr
   PnjveUdfwRRnWKV37t7ABzBL8xe3O8Q6+6FDGvy4/PmU0bCiaSZs8Iqoa
   iIyeUIumwrioLDUdlNtjd14TjNrk6kSDkgqKrQT4ybmcB81VofcPdDWPH
   jvnmZKBWk+DrT6+vWvK9R1zXYORGuM7HjTqMgqA8EFvrjZQFAbaeh1Gmq
   YbTrZGtx2oMyyl9GseoWNvZxX9SZETCcsavLPG1jrJ1bgIUiuYCPZ3qPM
   /nm4n0wos4GR9KugLrhFRaa0psI1yyjPXcuapegSRx+sAssPddrQDSrdd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="5551714"
X-IronPort-AV: E=Sophos;i="6.07,136,1708416000"; 
   d="scan'208";a="5551714"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 03:17:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,136,1708416000"; 
   d="scan'208";a="14145023"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by orviesa006.jf.intel.com with ESMTP; 19 Mar 2024 03:17:55 -0700
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Subject: [PATCH] Remove all "if zeros" pt.2
Date: Tue, 19 Mar 2024 11:15:29 +0100
Message-Id: <20240319101529.5098-1-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit e15e8b00cbce ("Remove all "if zeros"") did not remove all "if 0"
code blocks.

This commit is cleanup for that commit.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Build.c  |  6 ------
 Grow.c   | 13 +------------
 super1.c | 11 -----------
 3 files changed, 1 insertion(+), 29 deletions(-)

diff --git a/Build.c b/Build.c
index 1fbf8596a9dd..1be90e418ad1 100644
--- a/Build.c
+++ b/Build.c
@@ -156,12 +156,6 @@ int Build(struct mddev_ident *ident, struct mddev_dev *devlist, struct shape *s,
 		bitmap_fd = open(s->bitmap_file, O_RDWR);
 		if (bitmap_fd < 0) {
 			int major = BITMAP_MAJOR_HI;
-#if 0
-			if (s->bitmap_chunk == UnSet) {
-				pr_err("%s cannot be opened.\n", s->bitmap_file);
-				goto abort;
-			}
-#endif
 			bitmapsize = s->size >> 9; /* FIXME wrong for RAID10 */
 			if (CreateBitmap(s->bitmap_file, 1, NULL,
 					 s->bitmap_chunk, c->delay,
diff --git a/Grow.c b/Grow.c
index 5498e54fec11..97782fbc48cf 100644
--- a/Grow.c
+++ b/Grow.c
@@ -4417,19 +4417,8 @@ static void validate(int afd, int bfd, unsigned long long offset)
 		lseek64(afd, __le64_to_cpu(bsb2.arraystart)*512, 0);
 		if ((unsigned long long)read(afd, abuf, len) != len)
 			fail("read first from array failed");
-		if (memcmp(bbuf, abuf, len) != 0) {
-#if 0
-			int i;
-			printf("offset=%llu len=%llu\n",
-			       (unsigned long long)__le64_to_cpu(bsb2.arraystart)*512, len);
-			for (i=0; i<len; i++)
-				if (bbuf[i] != abuf[i]) {
-					printf("first diff byte %d\n", i);
-					break;
-				}
-#endif
+		if (memcmp(bbuf, abuf, len) != 0)
 			fail("data1 compare failed");
-		}
 	}
 	if (bsb2.length2) {
 		unsigned long long len = __le64_to_cpu(bsb2.length2)*512;
diff --git a/super1.c b/super1.c
index 871d19f0398c..0d059b4321b8 100644
--- a/super1.c
+++ b/super1.c
@@ -575,17 +575,6 @@ static void examine_super1(struct supertype *st, char *homehost)
 			inconsistent = 1;
 		}
 	}
-#if 0
-	/* This is confusing too */
-	faulty = 0;
-	for (i = 0; i < __le32_to_cpu(sb->max_dev); i++) {
-		int role = __le16_to_cpu(sb->dev_roles[i]);
-		if (role == MD_DISK_ROLE_FAULTY)
-			faulty++;
-	}
-	if (faulty)
-		printf(" %d failed", faulty);
-#endif
 	printf(" ('A' == active, '.' == missing, 'R' == replacing)");
 	printf("\n");
 	for (d = 0; d < __le32_to_cpu(sb->max_dev); d++) {
-- 
2.39.2

