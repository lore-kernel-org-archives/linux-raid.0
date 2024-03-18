Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B624F1E3
	for <linux-raid@vger.kernel.org>; Mon, 18 Mar 2024 15:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710775225; cv=none; b=hUAfmNAP2rdUhoSjD2MvqcqXBsQl15uX88GAu2I2e+nkWsFFtniYtHgC6Q8tDy8EAsl7xFQm4h6EO+yggdlBfB3AFxInlHbb7ge25K+wwFp/pcdn1IBrH7Vzsri7xGW+ETyc526pnAuYLy7/wDQQttFFEyOk8qcsZEwmoR1T1vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710775225; c=relaxed/simple;
	bh=CrYeRcXxe9yY28ko8I+S/DDHQiiixcT7ThEkHkwI7uM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cyQbo7GLuceQ6IVGCv324VG8l3VbRKTTuoHTt0AsA5G07bacDKYH2RgZUoFugZ4XKWJ075iEXdDH1mqmEUDAAVaWHw9OGQOweLdbkh27+ZZZE+K0ZkRnHtHupxOmhBo8rhddbU5wC2qC/ztot1fJH6RkVQwy/t1m3xmERv7ErY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UCo0KV0d; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UCo0KV0d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710775224; x=1742311224;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CrYeRcXxe9yY28ko8I+S/DDHQiiixcT7ThEkHkwI7uM=;
  b=UCo0KV0dgE2JqSisbGSpnETA1Om5zIp2HjTtHDYCRzrOXcivqUgN0oS9
   HJ5n+5hZ+zhdFkFp5068+n1nqo+bHnHuo0PUWeQrmzAAEE5eFEgyPB26B
   aIRN83F7DbFsWTWEzd5iMECS0a6+GVN3WPQaUiOTLE1lbrJ/MQOPzZBD/
   SlWwvc37EfS/s9BHSs7ezpiwinrXZSDgR0kThjxhqzDT9kTszegFLfyD0
   XPdfrFK763HH7h8CgTA5V2i2q2I5/wRiMD5rrIvXxQqb9sOQ/4Ghle9hd
   vEqfY6VhSpibbBIOVkQMDVM+7gXNXscOqqNICUtqCM9f0lf6IkC+99R0Z
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="28075162"
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="28075162"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 08:20:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="18069456"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 08:20:21 -0700
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Xiao Ni <xni@redhat.com>,
	Jes Sorensen <jes@trained-monkey.org>
Subject: [PATCH 2/2] mdadm: Fix native --detail --export
Date: Mon, 18 Mar 2024 16:19:30 +0100
Message-Id: <20240318151930.8218-3-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240318151930.8218-1-mariusz.tkaczyk@linux.intel.com>
References: <20240318151930.8218-1-mariusz.tkaczyk@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mentioned commit (see Fixes) causes that UUID is not swapped as expected
for native superblock. Fix this problem.

For detail, we should avoid superblock calls, we can have information
about supertype from map, use that.

Simplify fname_from_uuid() by removing dependencies to metadata
handler, it is not needed. Decision is taken at compile time, expect
super1 but this function is not used by super1. Add warning about that.
Remove separator, it is always ':'.

Fixes: 60c19530dd7c ("Detail: remove duplicated code")
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Detail.c      | 26 +++++++++++++++++++++++++-
 mdadm.h       |  3 +--
 super-ddf.c   | 10 +++++-----
 super-intel.c | 16 ++++++++--------
 util.c        | 24 +++++++++++++-----------
 5 files changed, 52 insertions(+), 27 deletions(-)

diff --git a/Detail.c b/Detail.c
index f23ec16f81bc..55a086d3378f 100644
--- a/Detail.c
+++ b/Detail.c
@@ -49,6 +49,30 @@ static int add_device(const char *dev, char ***p_devices,
 	return n_devices + 1;
 }
 
+/**
+ * detail_fname_from_uuid() - generate uuid string with special super1 handling.
+ * @mp: map entry to parse.
+ * @buf: buf to write.
+ *
+ * Hack to workaround an issue with super1 superblocks. It swapuuid set in order for assembly
+ * to work, but can't have it set if we want this printout to match all the other uuid printouts
+ * in super1.c, so we force swapuuid to 1 to make our printout match the rest of super1.
+ *
+ * Always convert uuid if host is big endian.
+ */
+char *detail_fname_from_uuid(struct map_ent *mp, char *buf)
+{
+#if __BYTE_ORDER == BIG_ENDIAN
+	bool swap = true;
+#else
+	bool swap = false;
+#endif
+	if (strncmp(mp->metadata, "1.", 2) == 0)
+		swap = true;
+
+	return __fname_from_uuid(mp->uuid, swap, buf, ':');
+}
+
 int Detail(char *dev, struct context *c)
 {
 	/*
@@ -256,7 +280,7 @@ int Detail(char *dev, struct context *c)
 			mp = map_by_devnm(&map, fd2devnm(fd));
 
 		if (mp) {
-			__fname_from_uuid(mp->uuid, 0, nbuf, ':');
+			detail_fname_from_uuid(mp, nbuf);
 			printf("MD_UUID=%s\n", nbuf + 5);
 			if (mp->path && strncmp(mp->path, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0)
 				printf("MD_DEVNAME=%s\n", mp->path + DEV_MD_DIR_LEN);
diff --git a/mdadm.h b/mdadm.h
index 3fedca484bdd..a363708a2710 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1696,8 +1696,7 @@ extern const int uuid_zero[4];
 extern int same_uuid(int a[4], int b[4], int swapuuid);
 extern void copy_uuid(void *a, int b[4], int swapuuid);
 extern char *__fname_from_uuid(int id[4], int swap, char *buf, char sep);
-extern char *fname_from_uuid(struct supertype *st,
-			     struct mdinfo *info, char *buf, char sep);
+extern char *fname_from_uuid(struct mdinfo *info, char *buf);
 extern unsigned long calc_csum(void *super, int bytes);
 extern int enough(int level, int raid_disks, int layout, int clean,
 		   char *avail);
diff --git a/super-ddf.c b/super-ddf.c
index 94ac5ff3965a..21426c753c6d 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1617,7 +1617,7 @@ static void brief_examine_super_ddf(struct supertype *st, int verbose)
 	struct mdinfo info;
 	char nbuf[64];
 	getinfo_super_ddf(st, &info, NULL);
-	fname_from_uuid(st, &info, nbuf, ':');
+	fname_from_uuid(&info, nbuf);
 
 	printf("ARRAY metadata=ddf UUID=%s\n", nbuf + 5);
 }
@@ -1632,7 +1632,7 @@ static void brief_examine_subarrays_ddf(struct supertype *st, int verbose)
 	unsigned int i;
 	char nbuf[64];
 	getinfo_super_ddf(st, &info, NULL);
-	fname_from_uuid(st, &info, nbuf, ':');
+	fname_from_uuid(&info, nbuf);
 
 	for (i = 0; i < be16_to_cpu(ddf->virt->max_vdes); i++) {
 		struct virtual_entry *ve = &ddf->virt->entries[i];
@@ -1645,7 +1645,7 @@ static void brief_examine_subarrays_ddf(struct supertype *st, int verbose)
 		ddf->currentconf =&vcl;
 		vcl.vcnum = i;
 		uuid_from_super_ddf(st, info.uuid);
-		fname_from_uuid(st, &info, nbuf1, ':');
+		fname_from_uuid(&info, nbuf1);
 		_ddf_array_name(namebuf, ddf, i);
 		printf("ARRAY%s%s container=%s member=%d UUID=%s\n",
 		       namebuf[0] == '\0' ? "" : " " DEV_MD_DIR, namebuf,
@@ -1658,7 +1658,7 @@ static void export_examine_super_ddf(struct supertype *st)
 	struct mdinfo info;
 	char nbuf[64];
 	getinfo_super_ddf(st, &info, NULL);
-	fname_from_uuid(st, &info, nbuf, ':');
+	fname_from_uuid(&info, nbuf);
 	printf("MD_METADATA=ddf\n");
 	printf("MD_LEVEL=container\n");
 	printf("MD_UUID=%s\n", nbuf+5);
@@ -1798,7 +1798,7 @@ static void brief_detail_super_ddf(struct supertype *st, char *subarray)
 		return;
 	else
 		uuid_of_ddf_subarray(ddf, vcnum, info.uuid);
-	fname_from_uuid(st, &info, nbuf,':');
+	fname_from_uuid(&info, nbuf);
 	printf(" UUID=%s", nbuf + 5);
 }
 
diff --git a/super-intel.c b/super-intel.c
index e1754f29246c..ff2590fef63f 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2217,7 +2217,7 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 	else
 		printf("not supported\n");
 	getinfo_super_imsm(st, &info, NULL);
-	fname_from_uuid(st, &info, nbuf, ':');
+	fname_from_uuid(&info, nbuf);
 	printf("           UUID : %s\n", nbuf + 5);
 	sum = __le32_to_cpu(mpb->check_sum);
 	printf("       Checksum : %08x %s\n", sum,
@@ -2242,7 +2242,7 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 
 		super->current_vol = i;
 		getinfo_super_imsm(st, &info, NULL);
-		fname_from_uuid(st, &info, nbuf, ':');
+		fname_from_uuid(&info, nbuf);
 		print_imsm_dev(super, dev, nbuf + 5, super->disks->index);
 	}
 	for (i = 0; i < mpb->num_disks; i++) {
@@ -2267,7 +2267,7 @@ static void brief_examine_super_imsm(struct supertype *st, int verbose)
 	char nbuf[64];
 
 	getinfo_super_imsm(st, &info, NULL);
-	fname_from_uuid(st, &info, nbuf, ':');
+	fname_from_uuid(&info, nbuf);
 	printf("ARRAY metadata=imsm UUID=%s\n", nbuf + 5);
 }
 
@@ -2284,13 +2284,13 @@ static void brief_examine_subarrays_imsm(struct supertype *st, int verbose)
 		return;
 
 	getinfo_super_imsm(st, &info, NULL);
-	fname_from_uuid(st, &info, nbuf, ':');
+	fname_from_uuid(&info, nbuf);
 	for (i = 0; i < super->anchor->num_raid_devs; i++) {
 		struct imsm_dev *dev = get_imsm_dev(super, i);
 
 		super->current_vol = i;
 		getinfo_super_imsm(st, &info, NULL);
-		fname_from_uuid(st, &info, nbuf1, ':');
+		fname_from_uuid(&info, nbuf1);
 		printf("ARRAY " DEV_MD_DIR "%.16s container=%s member=%d UUID=%s\n",
 		       dev->volume, nbuf + 5, i, nbuf1 + 5);
 	}
@@ -2304,7 +2304,7 @@ static void export_examine_super_imsm(struct supertype *st)
 	char nbuf[64];
 
 	getinfo_super_imsm(st, &info, NULL);
-	fname_from_uuid(st, &info, nbuf, ':');
+	fname_from_uuid(&info, nbuf);
 	printf("MD_METADATA=imsm\n");
 	printf("MD_LEVEL=container\n");
 	printf("MD_UUID=%s\n", nbuf+5);
@@ -2324,7 +2324,7 @@ static void detail_super_imsm(struct supertype *st, char *homehost,
 		super->current_vol = strtoul(subarray, NULL, 10);
 
 	getinfo_super_imsm(st, &info, NULL);
-	fname_from_uuid(st, &info, nbuf, ':');
+	fname_from_uuid(&info, nbuf);
 	printf("\n              UUID : %s\n", nbuf + 5);
 
 	super->current_vol = temp_vol;
@@ -2341,7 +2341,7 @@ static void brief_detail_super_imsm(struct supertype *st, char *subarray)
 		super->current_vol = strtoul(subarray, NULL, 10);
 
 	getinfo_super_imsm(st, &info, NULL);
-	fname_from_uuid(st, &info, nbuf, ':');
+	fname_from_uuid(&info, nbuf);
 	printf(" UUID=%s", nbuf + 5);
 
 	super->current_vol = temp_vol;
diff --git a/util.c b/util.c
index 49a9c6e29cf7..03336d6fa24c 100644
--- a/util.c
+++ b/util.c
@@ -589,19 +589,21 @@ char *__fname_from_uuid(int id[4], int swap, char *buf, char sep)
 
 }
 
-char *fname_from_uuid(struct supertype *st, struct mdinfo *info,
-		      char *buf, char sep)
-{
-	// dirty hack to work around an issue with super1 superblocks...
-	// super1 superblocks need swapuuid set in order for assembly to
-	// work, but can't have it set if we want this printout to match
-	// all the other uuid printouts in super1.c, so we force swapuuid
-	// to 1 to make our printout match the rest of super1
+/**
+ * fname_from_uuid() - generate uuid string. Should not be used with super1.
+ * @info: info with uuid
+ * @buf: buf to fill.
+ *
+ * This routine should not be used with super1. See detail_fname_from_uuid() for details. It does
+ * not use superswitch swapuuid as it should be 0 but it has to do UUID conversion if host is big
+ * endian- left for backward compatibility.
+ */
+char *fname_from_uuid(struct mdinfo *info, char *buf)
+{
 #if __BYTE_ORDER == BIG_ENDIAN
-	return __fname_from_uuid(info->uuid, 1, buf, sep);
+	return __fname_from_uuid(info->uuid, true, buf, ':');
 #else
-	return __fname_from_uuid(info->uuid, (st->ss == &super1) ? 1 :
-				 st->ss->swapuuid, buf, sep);
+	return __fname_from_uuid(info->uuid, false, buf, ':');
 #endif
 }
 
-- 
2.35.3

