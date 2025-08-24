Received: from q64jeremias.jears.at (unknown [62.240.152.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D4511CA9
	for <linux-raid@vger.kernel.org>; Sun, 24 Aug 2025 07:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.240.152.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756021946; cv=none; b=JpDXqlUanSXXeKaI3rPw6+C3BtSk/udUkmNQc2HHuO653X/fZHl2W/xKb1byjnwVdLIqXWF/Ie/R+9umbbdef7c6gu+fCXRhB5dHlFNtb2n6EHnnSU5tc3PjvDIkhSLiVMVCpYbBvBKOc8Nd7uWU9s/PwTjuQbQkwB/4BKiqV3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756021946; c=relaxed/simple;
	bh=AlvYRjv+I7snveeT+UaGchcbrewzDtGDrhyq8dWCPqk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z3k9kQF/eB16+aLOZoQp3ia6jNKZvg4li74YMnHP8mijF0UCFaVs+RU33RgxA/EbsFO3WvkLCsTI+jgrBYHidHz5U0qw4DKsiYNP6JplX3Oj8XRUtmNs+G8c4JmlfP/De5NmS6LoIqISVC5TRGAcPfLmQUbWQFY+/BjpXAZVnho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jears.at; spf=pass smtp.mailfrom=jears.at; dkim=pass (1024-bit key) header.d=jears.at header.i=@jears.at header.b=p8xFB5j1; arc=none smtp.client-ip=62.240.152.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jears.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jears.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jears.at header.i=@jears.at header.b="p8xFB5j1"
Received: from localhost.localdomain (Jeremias-PC.fritz.box [192.168.0.66])
	by q64jeremias.jears.at (Postfix) with ESMTPA id 8674DE54CF;
	Sun, 24 Aug 2025 09:43:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jears.at; s=mail;
	t=1756021426; bh=M8wOZMQTJnLjYia+mSH0FBbKumBWPlPRcgW0HMy67lw=;
	h=From:To:Cc:Subject:Date;
	b=p8xFB5j17BCvRC3ZI3XMfqAMKf7MbjWFPoG4rlmRE4qOMe2xMZ+13jQpfqXnDzb0F
	 icp985jJu4o2CZjTgYp0kJ40S5qIanWaqThTBScZOdn5P1ZT9FUowbtRO8UZZc0xSQ
	 XbI0f5sExFHeOJuMJzvWW5YPueqaeQBSxRV005Hs=
From: Jeremias Stotter <jeremias@jears.at>
To: linux-raid@vger.kernel.org
Cc: Jeremias Stotter <jeremias@jears.at>
Subject: [PATCH] md: Allow setting persistent superblock version for md= command line
Date: Sun, 24 Aug 2025 07:43:41 +0000
Message-ID: <20250824074355.1847-1-jeremias@jears.at>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This allows for setting a superblock version on the kernel command line to be
able to assemble version >=1.0 arrays. It can optionally be set like this:

md=vX.X,...

This will set the version of the array before assembly so it can be assembled
correctly.

Also updated docs accordingly.

Signed-off-by: Jeremias Stotter <jeremias@jears.at>
---
 Documentation/admin-guide/md.rst |  8 ++++
 drivers/md/md-autodetect.c       | 66 +++++++++++++++++++++++++++++++-
 2 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
index 4ff2cc291d18..7b904d73ace0 100644
--- a/Documentation/admin-guide/md.rst
+++ b/Documentation/admin-guide/md.rst
@@ -23,6 +23,14 @@ or, to assemble a partitionable array::
 
   md=d<md device no.>,dev0,dev1,...,devn
 
+if you are using superblock versions greater than 0, use the following::
+
+  md=v<superblock version no.>,<md device no.>,dev0,dev1,...,devn
+
+for example, for a raid array with superblock version 1.2 it could look like this::
+
+  md=v1.2,0,/dev/sda1,/dev/sdb1
+
 ``md device no.``
 +++++++++++++++++
 
diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 4b80165afd23..955bf370d307 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -32,6 +32,8 @@ static struct md_setup_args {
 	int partitioned;
 	int level;
 	int chunk;
+	int major_version;
+	int minor_version;
 	char *device_names;
 } md_setup_args[256] __initdata;
 
@@ -56,6 +58,9 @@ static int md_setup_ents __initdata;
  * 2001-06-03: Dave Cinege <dcinege@psychosis.com>
  *		Shifted name_to_kdev_t() and related operations to md_set_drive()
  *		for later execution. Rewrote section to make devfs compatible.
+ * 2025-08-24: Jeremias Stotter <jeremias@jears.at>
+ *              Allow setting of the superblock version:
+ *              md=vX.X,...
  */
 static int __init md_setup(char *str)
 {
@@ -63,6 +68,54 @@ static int __init md_setup(char *str)
 	char *pername = "";
 	char *str1;
 	int ent;
+	int major_i = 0, minor_i = 0;
+
+	if (*str == 'v') {
+		char *version = ++str;
+		char *version_end = strchr(str, ',');
+
+		if (!version_end) {
+			printk(KERN_WARNING
+			       "md: Version (%s) has been specified wrong, no ',' found, use like this: md=vX.X,...\n",
+			       version);
+			return 0;
+		}
+		*version_end = '\0';
+		str = version_end + 1;
+
+		char *separator = strchr(version, '.');
+
+		if (!separator) {
+			printk(KERN_WARNING
+			       "md: Version (%s) has been specified wrong, no '.' to separate major and minor version found, use like this: md=vX.X,...\n",
+			       version);
+			return 0;
+		}
+		*separator = '\0';
+		char *minor_s = separator + 1;
+
+		int ret = kstrtoint(version, 10, &major_i);
+
+		if (ret != 0) {
+			printk(KERN_WARNING
+			       "md: Version has been specified wrong, couldn't convert major '%s' to number, use like this: md=vX.X,...\n",
+			       version);
+			return 0;
+		}
+		if (major_i != 0 && major_i != 1) {
+			printk(KERN_WARNING
+			       "md: Major version %d is not valid, use 0 or 1\n",
+			       major_i);
+			return 0;
+		}
+		ret = kstrtoint(minor_s, 10, &minor_i);
+		if (ret != 0) {
+			printk(KERN_WARNING
+			       "md: Version has been specified wrong, couldn't convert minor '%s' to number, use like this: md=vX.X,...\n",
+			       minor_s);
+			return 0;
+		}
+	}
 
 	if (*str == 'd') {
 		partitioned = 1;
@@ -116,6 +169,8 @@ static int __init md_setup(char *str)
 	md_setup_args[ent].device_names = str;
 	md_setup_args[ent].partitioned = partitioned;
 	md_setup_args[ent].minor = minor;
+	md_setup_args[ent].minor_version = minor_i;
+	md_setup_args[ent].major_version = major_i;
 
 	return 1;
 }
@@ -200,6 +255,9 @@ static void __init md_setup_drive(struct md_setup_args *args)
 
 	err = md_set_array_info(mddev, &ainfo);
 
+	mddev->major_version = args->major_version;
+	mddev->minor_version = args->minor_version;
+
 	for (i = 0; i <= MD_SB_DISKS && devices[i]; i++) {
 		struct mdu_disk_info_s dinfo = {
 			.major	= MAJOR(devices[i]),
@@ -273,11 +331,15 @@ void __init md_run_setup(void)
 {
 	int ent;
 
+	/*
+	 * Assemble manually defined raids first
+	 */
+	for (ent = 0; ent < md_setup_ents; ent++)
+		md_setup_drive(&md_setup_args[ent]);
+
 	if (raid_noautodetect)
 		printk(KERN_INFO "md: Skipping autodetection of RAID arrays. (raid=autodetect will force)\n");
 	else
 		autodetect_raid();
 
-	for (ent = 0; ent < md_setup_ents; ent++)
-		md_setup_drive(&md_setup_args[ent]);
 }
-- 
2.49.1

