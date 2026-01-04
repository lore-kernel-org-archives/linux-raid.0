Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D89E29D29C
	for <linux-raid@vger.kernel.org>; Sun,  4 Jan 2026 12:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767528820; cv=none; b=qJlfokMKuEhpKSmEYHNerp/VdDRiMM9hf9FesaQ6wEkdS/w0iXuG7bhAd61xYszut7sM4v4UCPEwdR4ZBWaoXE9jsiwkY2VmfvrMMYTXIakDyygWhkoAf0rH3yaRHe05DnzkyP7D3zt4Ro6aNf+b8CynLdPdR1WT/uvIN9K4J00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767528820; c=relaxed/simple;
	bh=Yf9i1xGuhjQkRQU/L6z+Yq8DaeRnZrgj+oix9oPsvWo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ifULbq2ZdGDRF2LNk0orWw72OipcanB6MIZofadyp0aIIseZXTHctZmAKssGt0Jm1/q5oes7pMDUPLjkiFVXmSQwA6rZrJ+g2D2BnEFB7jTBYZodksPnA0dOpWRQ44nFjq+4F/+B9sIvlzqQ26Vn6Rx+yBC1TPtytND1v/xaiHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KZdws9Bk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KZdws9Bk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767528814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fNyQ+AEerMrxsauj5qNBLJrJShf4b2luHloxWr7AwMI=;
	b=KZdws9Bk53p1ln0lB/SK837WlGi3YOjDzRoNqX5yc50jB4S2gSBXt51aLz1OgFqeO2mmqQ
	52cTeIZRZJr/f6I9EMFoD+pD+MWHu3WEar15dm8IIZwOCLoZZT89vnq0ZfHaoznAEs1w4J
	gwKK/iWE6dvzrKeSFVRUgxxWB1QP/pg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-1l8-AVb1MhWdPPat09WdhQ-1; Sun,
 04 Jan 2026 07:13:30 -0500
X-MC-Unique: 1l8-AVb1MhWdPPat09WdhQ-1
X-Mimecast-MFC-AGG-ID: 1l8-AVb1MhWdPPat09WdhQ_1767528809
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 840AD1800365;
	Sun,  4 Jan 2026 12:13:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.33])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 99DBA19560A7;
	Sun,  4 Jan 2026 12:13:27 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	mtkaczyk@kernel.org
Subject: [PATCH 1/1] mdadm: load md_mod first
Date: Sun,  4 Jan 2026 20:13:24 +0800
Message-Id: <20260104121324.62520-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Load md_mod first before setting module parameter legacy_async_del_gendisk
Everything works well if md_mod is built in kernel. If not, create and
assemble will fail.

Fixes: d354d314db86 ("mdadm: Create array with sync del gendisk mode")
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 mdadm.h  |  2 +-
 mdopen.c | 30 ++++++------------------------
 util.c   | 35 +++++++++++++++++++++++++++++++++--
 3 files changed, 40 insertions(+), 27 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index b63dded31a17..9b7052dabee4 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -860,7 +860,7 @@ extern int restore_stripes(int *dest, unsigned long long *offsets,
 			   unsigned long long start, unsigned long long length,
 			   char *src_buf);
 extern bool sysfs_is_libata_allow_tpm_enabled(const int verbose);
-extern bool init_md_mod_param(void);
+extern bool init_md_mod(void);
 
 #ifndef Sendmail
 #define Sendmail "/usr/lib/sendmail -t"
diff --git a/mdopen.c b/mdopen.c
index b685603d6de5..9af0284b6914 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -38,33 +38,15 @@ int create_named_array(char *devnm)
 	};
 
 	fd = open(new_array_file, O_WRONLY);
-	if (fd < 0 && errno == ENOENT) {
-		char buf[PATH_MAX] = {0};
-		char *env_ptr;
-
-		env_ptr = getenv("PATH");
-		/*
-		 * When called by udev worker context, path of modprobe
-		 * might not be in env PATH. Set sbin paths into PATH
-		 * env to avoid potential failure when run modprobe here.
-		 */
-		if (env_ptr)
-			snprintf(buf, PATH_MAX - 1, "%s:%s", env_ptr,
-				 "/sbin:/usr/sbin:/usr/local/sbin");
-		else
-			snprintf(buf, PATH_MAX - 1, "%s",
-				 "/sbin:/usr/sbin:/usr/local/sbin");
-
-		setenv("PATH", buf, 1);
-
-		if (system("modprobe md_mod") == 0)
-			fd = open(new_array_file, O_WRONLY);
-	}
 	if (fd >= 0) {
 		n = write(fd, devnm, strlen(devnm));
 		close(fd);
+	} else {
+		pr_err("Fail to open %s\n", new_array_file);
+		return 0;
 	}
-	if (fd < 0 || n != (int)strlen(devnm)) {
+
+	if (n != (int)strlen(devnm)) {
 		pr_err("Fail to create %s when using %s, fallback to creation via node\n",
 			devnm, new_array_file);
 		return 0;
@@ -148,7 +130,7 @@ int create_mddev(char *dev, char *name, int trustworthy,
 	char devnm[32];
 	char cbuf[400];
 
-	if (!init_md_mod_param()) {
+	if (!init_md_mod()) {
 		pr_err("init md module parameters fail\n");
 		return -1;
 	}
diff --git a/util.c b/util.c
index 146f38fddd82..cdc55435a707 100644
--- a/util.c
+++ b/util.c
@@ -2583,10 +2583,41 @@ bool set_md_mod_parameter(const char *name, const char *value)
 	return ret;
 }
 
-/* Init kernel md_mod parameters here if needed */
-bool init_md_mod_param(void)
+/* Init kernel md_mod and parameters here if needed */
+bool init_md_mod(void)
 {
 	bool ret = true;
+	char module_path[32];
+	FILE *fp;
+
+	snprintf(module_path, sizeof(module_path), "/sys/module/md_mod");
+	fp = fopen(module_path, "r");
+	if (fp == NULL) {
+
+		char buf[PATH_MAX] = {0};
+		char *env_ptr;
+
+		env_ptr = getenv("PATH");
+		/*
+		 * When called by udev worker context, path of modprobe
+		 * might not be in env PATH. Set sbin paths into PATH
+		 * env to avoid potential failure when run modprobe here.
+		 */
+		if (env_ptr)
+			snprintf(buf, PATH_MAX - 1, "%s:%s", env_ptr,
+				 "/sbin:/usr/sbin:/usr/local/sbin");
+		else
+			snprintf(buf, PATH_MAX - 1, "%s",
+				 "/sbin:/usr/sbin:/usr/local/sbin");
+
+		setenv("PATH", buf, 1);
+
+		if (system("modprobe md_mod") != 0) {
+			pr_err("Can't load kernel module md_mod\n");
+			return false;
+		}
+	} else
+		fclose(fp);
 
 	/*
 	 * In kernel 9e59d609763f calls del_gendisk in sync way. So device
-- 
2.32.0 (Apple Git-132)

