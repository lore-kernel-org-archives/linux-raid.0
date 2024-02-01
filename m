Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4857D4D9EC
	for <linux-raid@vger.kernel.org>; Thu,  1 Feb 2024 11:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706787178; cv=none; b=LwZkN4vCPEEvxofORNx/cLEb+9pmBaJZAL2dQ5Jajb4sZ9TpsR/qxOXiLGVnyz/ytmuW4KPwbnrA1LmZYHsHOsxd5g+RYQYYgfWbcJd+gKJYPzAtp72mPURZoY1HvTPZ0IFPmUiW2NBX9my/zuRtE2TyxtNUjsw7FXRwFBWv+Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706787178; c=relaxed/simple;
	bh=JECyO87+c5boSeYmfZ0S3cyQRyf5DT7Skz9N/BD1+DQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=OBJqpGjcYJDCTLI6VyRUHRnNGF31LGOLNjnLiRnWNexVLUYugxnUIPU7t813qnbkpTF8splyXC7PrrnfP32LtbekAfqkUs1UGP+IqreeGjFjFH0vmVE3HY0ytXEG0h6u2jw+lo8hTuwXpfE1PpBDVU5qLvq29fJVBnkjGreKZ5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nZHuTy3i; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nZHuTy3i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706787176; x=1738323176;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JECyO87+c5boSeYmfZ0S3cyQRyf5DT7Skz9N/BD1+DQ=;
  b=nZHuTy3ilVbf9AAv2s31oz/Ajfm/l1Y18pNqRMhOjYAutJraWCWB1D53
   RjO5FhLUQW5KDzleEHWApzJ05fGcEoGchFF4eU6tnMcdYahn01s1N2B/E
   58+/vELes9MU306Sfnbyv53e/7OH9s81vus/qrr1vo03GqHyxjAm0W4Y5
   eaE9YX92umBaKpS75qkrqKYn+itpyG0KaXbQmG2gvp876o+GGT+c3mpwl
   p331SYgg5eupQW9/Rj8wmvg7gjesTw9/FcHERpYlE+NA1RokOFDfkzhdo
   l8J8bWaUxwKn0bu+QqpZRniqMLartcLX3efwbFelm1/FWOOCiNRVStaMD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="2806886"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="2806886"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 03:32:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="37185482"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 03:32:53 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Stefan Fleischmann <sfle@kth.se>
Subject: [PATCH] super1: remove support for name= in config
Date: Thu,  1 Feb 2024 12:32:41 +0100
Message-Id: <20240201113241.26479-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Only super1 provides "name=" to config. It is recoreded in metadata
so there is no need to duplicate same information.
UUID is our main key.

It is not used by Incremental and Assemble handles empty name well
because other supertypes don't set it in conf.

Expectation that the name in config is same as in metadata is bug prone.
Config should be the place where use can define customized settings.

Remove printing "name=" from mdadm config creation commands. Ignore
the name in config file to keep backward compatibility. Remove
description from man mdadm.conf.

Update 00conftest because "name" is no longer accepted.
As the name is ignored, error for mdadm --detail is not printed.

Reported-by: Stefan Fleischmann <sfle@kth.se>
Fixes: e2eb503bd797 ("mdadm: Follow POSIX Portable Character Set")
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 config.c                       | 12 ++----
 mdadm.conf.5.in                |  7 ---
 super1.c                       |  8 ----
 tests/00confnames              | 79 ++++++----------------------------
 tests/templates/names_template |  7 +--
 5 files changed, 19 insertions(+), 94 deletions(-)

diff --git a/config.c b/config.c
index 9a04cae85f52..44f7dd2f316a 100644
--- a/config.c
+++ b/config.c
@@ -262,6 +262,7 @@ pass:
  * @cmdline: context dependent actions.
  *
  * If criteria passed, set name in @ident.
+ * Note: name is not used by config file, it for cmdline only.
  *
  * Return: %MDADM_STATUS_SUCCESS or %MDADM_STATUS_ERROR.
  */
@@ -571,7 +572,8 @@ void arrayline(char *line)
 					mis.super_minor = minor;
 			}
 		} else if (strncasecmp(w, "name=", 5) == 0) {
-			_ident_set_name(&mis, w + 5, false);
+			/* Ignore name in confile */
+			continue;
 		} else if (strncasecmp(w, "bitmap=", 7) == 0) {
 			if (mis.bitmap_file)
 				pr_err("only specify bitmap file once. %s ignored\n",
@@ -1279,13 +1281,7 @@ struct mddev_ident *conf_match(struct supertype *st,
 				       array_list->devname);
 			continue;
 		}
-		if (array_list->name[0] &&
-		    strcasecmp(array_list->name, info->name) != 0) {
-			if (verbose >= 2 && array_list->devname)
-				pr_err("Name differs from %s.\n",
-				       array_list->devname);
-			continue;
-		}
+
 		if (array_list->devices && devname &&
 		    !match_oneof(array_list->devices, devname)) {
 			if (verbose >= 2 && array_list->devname)
diff --git a/mdadm.conf.5.in b/mdadm.conf.5.in
index 94e23dd013ba..787e51e9e88d 100644
--- a/mdadm.conf.5.in
+++ b/mdadm.conf.5.in
@@ -133,13 +133,6 @@ The value should be a 128 bit uuid in hexadecimal, with punctuation
 interspersed if desired.  This must match the uuid stored in the
 superblock.
 .TP
-.B name=
-The value should be a simple textual name as was given to
-.I mdadm
-when the array was created.  This must match the name stored in the
-superblock on a device for that device to be included in the array.
-Not all superblock formats support names.
-.TP
 .B super\-minor=
 The value is an integer which indicates the minor number that was
 stored in the superblock when the array was created. When an array is
diff --git a/super1.c b/super1.c
index dfde4629508b..5fd2228efbd6 100644
--- a/super1.c
+++ b/super1.c
@@ -645,10 +645,6 @@ static void brief_examine_super1(struct supertype *st, int verbose)
 			printf(":");
 		printf("%02x", sb->set_uuid[i]);
 	}
-	if (sb->set_name[0]) {
-		printf(" name=");
-		print_quoted(sb->set_name);
-	}
 	printf("\n");
 }
 
@@ -875,10 +871,6 @@ static void brief_detail_super1(struct supertype *st, char *subarray)
 	struct mdp_superblock_1 *sb = st->sb;
 	int i;
 
-	if (sb->set_name[0]) {
-		printf(" name=");
-		print_quoted(sb->set_name);
-	}
 	printf(" UUID=");
 	for (i = 0; i < 16; i++) {
 		if ((i & 3) == 0 && i != 0)
diff --git a/tests/00confnames b/tests/00confnames
index 10823f0181cf..191a905f3379 100644
--- a/tests/00confnames
+++ b/tests/00confnames
@@ -1,10 +1,8 @@
 set -x -e
 . tests/templates/names_template
 
-# Test how <devname> and <name> from config are handled during Incremental assemblation.
-# 1-6 <devnode> only tests (no <name> in config).
-# 6-10 <devname> and <name> combinations are tested.
-# 11-13 corner cases.
+# Test how <devname> is handled during Incremental assemblation with
+# config file and ARRAYLINE specified.
 
 names_create "/dev/md/name"
 local _UUID="$(mdadm -D --export /dev/md127 | grep MD_UUID | cut -d'=' -f2)"
@@ -12,96 +10,47 @@ local _UUID="$(mdadm -D --export /dev/md127 | grep MD_UUID | cut -d'=' -f2)"
 
 
 # 1. <devname> definition consistent with metadata name.
-names_make_conf $_UUID "/dev/md/name" "empty" $config
+names_make_conf $_UUID "/dev/md/name" $config
 mdadm -S "/dev/md127"
 mdadm -I $dev0 --config=$config
 names_verify "/dev/md127" "name" "name"
 mdadm -S "/dev/md127"
 
 # 2. Same as 1, but use short name form of <devname>.
-names_make_conf $_UUID "name" "empty" $config
+names_make_conf $_UUID "name" $config
 mdadm -I $dev0 --config=$config
 names_verify "/dev/md127" "name" "name"
 mdadm -S "/dev/md127"
 
 # 3. Same as 1, but use different <devname> than metadata provides.
-names_make_conf $_UUID "/dev/md/other" "empty" $config
+names_make_conf $_UUID "/dev/md/other" $config
 mdadm -I $dev0 --config=$config
 names_verify "/dev/md127" "other" "name"
 mdadm -S "/dev/md127"
 
 # 4. Same as 3, but use short name form of <devname>.
-names_make_conf $_UUID "other" "empty" $config
+names_make_conf $_UUID "other" $config
 mdadm -I $dev0 --config=$config
 names_verify "/dev/md127" "other" "name"
 mdadm -S "/dev/md127"
 
-# 5. Force particular node creation by setting <devname> to /dev/mdX. Link is not created in this
-# case.
-names_make_conf $_UUID "/dev/md4" "empty" $config
+# 5. Force particular node creation by setting <devname> to /dev/mdX.
+# Link is not created in this case.
+names_make_conf $_UUID "/dev/md4" $config
 mdadm -I $dev0 --config=$config
 names_verify "/dev/md4" "empty" "name"
 mdadm -S "/dev/md4"
 
-# 6. <devname> set to /dev/mdX, <name> same as in metadata.
-# Metadata name and default node used - controversial. Current behavior documented.
-names_make_conf $_UUID "/dev/md22" "name" $config
-mdadm -I $dev0 --config=$config
-names_verify "/dev/md127" "name" "name"
-mdadm -S "/dev/md127"
-
-# 7. <devname> set to /dev/mdX, <name> different than in metadata.
-# Metadata name and default node used - controversial. Current behavior documented.
-names_make_conf $_UUID "/dev/md8" "other" $config
-mdadm -I $dev0 --config=$config
-names_verify "/dev/md127" "name" "name"
-mdadm -S "/dev/md127"
-
-# 8. Both <devname> and <name> different than in metadata.
-# Metadata name and default node used - controversial. Current behavior documented.
-names_make_conf $_UUID "devnode" "other_name" $config
-mdadm -I $dev0 --config=$config
-names_verify "/dev/md127" "name" "name"
-mdadm -S "/dev/md127"
-
-# 9. <devname> set to metadata name, <name> different than in metadata.
-# Metadata name and default node used - controversial. Current behavior documented.
-names_make_conf $_UUID "name" "other_name" $config
-mdadm -I $dev0 --config=$config
-names_verify "/dev/md127" "name" "name"
-mdadm -S "/dev/md127"
-
-# 10. Bad <devname> set, no <name>.
-# Metadata name and default node used - expected.
-names_make_conf $_UUID "/im/bad/devname" "empty" $config
-mdadm -I $dev0 --config=$config
-names_verify "/dev/md127" "name" "name"
-mdadm -S "/dev/md127"
-
-# 11. <devname> with some special symbols and locales, no <name>.
+# 6. <devname> with some special symbols and locales.
 # <devname> should be ignored.
-names_make_conf $_UUID "tźż-\.,<>st+-" "empty" $config
-mdadm -I $dev0 --config=$config
-names_verify "/dev/md127" "name" "name"
-mdadm -S "/dev/md127"
-
-# 12. No <devname> and <name> set.
-# Metadata name and default node used - expected.
-names_make_conf $_UUID "empty" "empty" $config
-mdadm -I $dev0 --config=$config
-names_verify "/dev/md127" "name" "name"
-mdadm -S "/dev/md127"
-
-# 13. No <devname>, <name> set to /dev/mdX.
-# Entry should be ignored, it is not ignored but result is good anyway.
-names_make_conf $_UUID "empty" "/dev/md12" $config
+names_make_conf $_UUID "tźż-\.,<>st+-" $config
 mdadm -I $dev0 --config=$config
 names_verify "/dev/md127" "name" "name"
 mdadm -S "/dev/md127"
 
-# 13. No <devname>, <name> with special symbols and locales.
-# Entry should be ignored, it is not ignored but result is good anyway.
-names_make_conf $_UUID "empty" "./\śćń#&" $config
+# 7. No <devname> set.
+# Metadata name and default node used.
+names_make_conf $_UUID "empty" $config
 mdadm -I $dev0 --config=$config
 names_verify "/dev/md127" "name" "name"
 mdadm -S "/dev/md127"
diff --git a/tests/templates/names_template b/tests/templates/names_template
index 6181bfaaaa1a..1b6cd14bf51d 100644
--- a/tests/templates/names_template
+++ b/tests/templates/names_template
@@ -63,8 +63,7 @@ function names_verify() {
 names_make_conf() {
 	local UUID="$1"
 	local WANTED_DEVNAME="$2"
-	local WANTED_NAME="$3"
-	local CONF="$4"
+	local CONF="$3"
 
 	local LINE="ARRAY metadata=1.2 UUID=$UUID"
 
@@ -72,9 +71,5 @@ names_make_conf() {
 		LINE="$LINE $WANTED_DEVNAME"
 	fi
 
-	if [[ "$WANTED_NAME" != "empty" ]]; then
-		LINE="$LINE name=$WANTED_NAME"
-	fi
-
 	echo $LINE > $CONF
 }
-- 
2.35.3

