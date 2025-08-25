Received: from q64jeremias.jears.at (unknown [62.240.152.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CBB86250
	for <linux-raid@vger.kernel.org>; Mon, 25 Aug 2025 14:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.240.152.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756133641; cv=none; b=Vhity2AIQEFBiW5hI9W8dbq/RrG7KhC10EDlL4vm5oFMBcjN3ixLo/tX4xhbKSAysfiXB92hLfAze70sLzQVjLtAZxvpVR5dEVfoXN8ZJ1cMKOQhT6JiumSG6Zsvgiw/y+paoHdzAzCDZSqtX2xNe4aT6kWAwOiOhq2dQssEdug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756133641; c=relaxed/simple;
	bh=3Ywms1NIO7CDeMibWLSeIV/isLHWRMZflcOqCLzoMcA=;
	h=MIME-Version:Date:From:To:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=tRvbEDkM/rSiKUM5tZ3TfedtKOQQKIUYGiBVx1YWsT++BRVP0XijrWQrNcwdcuAivDZfZnsYEJMfjufCSftl0HQ7etKu8dywbI+2HM4BS9Bnoa/6rEA5gjHDcqEins4Da7zKOCgTeio0wXOGGdsh/rR+kSFg+ugK/QA9M7S/4lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jears.at; spf=pass smtp.mailfrom=jears.at; dkim=pass (1024-bit key) header.d=jears.at header.i=@jears.at header.b=QWcODt7j; arc=none smtp.client-ip=62.240.152.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jears.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jears.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jears.at header.i=@jears.at header.b="QWcODt7j"
Received: from mail.jears.at (localhost [127.0.0.1])
	by q64jeremias.jears.at (Postfix) with ESMTPA id CF8BCE56E2
	for <linux-raid@vger.kernel.org>; Mon, 25 Aug 2025 16:53:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jears.at; s=mail;
	t=1756133629; bh=5KluZyAajE7E9qnaTyudf+bYfvCGPXDBx6K9cl1zW3s=;
	h=Date:From:To:Subject:In-Reply-To:References;
	b=QWcODt7j9wSMfe8vtFanBA6BVh0aQzue97NrlArxJWJ6NKbFOGntzYX5TKg3TwjJd
	 TIf3EKF9Gg01/S5D9NrHPTdBTo8t9w5cVAB0t+0Jb4deyECd61JLnIKtkTmQWDPQAN
	 97kFVy3xnFMr2o51CQ5+FaHn/6eNIt+zowt98aws=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 25 Aug 2025 16:53:47 +0200
From: jeremias@jears.at
To: Linux Raid <linux-raid@vger.kernel.org>
Subject: [PATCH v3] md: Allow setting persistent superblock version for md=
 command line
In-Reply-To: <20250825144029.2924-1-jeremias@jears.at>
References: <20250825144029.2924-1-jeremias@jears.at>
Message-ID: <cb9539bb95a2cbfc723a96d7ff31c1dd@jears.at>
X-Sender: jeremias@jears.at
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

This allows for setting a superblock version on the kernel command line 
to be
able to assemble version >=1.0 arrays. It can optionally be set like 
this:

md=vX.X,...

This will set the version of the array before assembly so it can be 
assembled
correctly.

Also updated docs accordingly.

v2: Use pr_warn instead of printk

v3: Change order of options so it stays with past pattern

Signed-off-by: Jeremias Stotter <jeremias@jears.at>
---
  Documentation/admin-guide/md.rst |  8 +++++
  drivers/md/md-autodetect.c       | 59 ++++++++++++++++++++++++++++++--
  2 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/md.rst 
b/Documentation/admin-guide/md.rst
index 4ff2cc291d18..f57ae871c997 100644
--- a/Documentation/admin-guide/md.rst
+++ b/Documentation/admin-guide/md.rst
@@ -23,6 +23,14 @@ or, to assemble a partitionable array::

    md=d<md device no.>,dev0,dev1,...,devn

+if you are using superblock versions greater than 0, use the 
following::
+
+  md=<md device no.>,v<superblock version no.>,dev0,dev1,...,devn
+
+for example, for a raid array with superblock version 1.2 it could look 
like this::
+
+  md=0,v1.2,/dev/sda1,/dev/sdb1
+
  ``md device no.``
  +++++++++++++++++

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 4b80165afd23..67d38559ad50 100644
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

@@ -63,6 +65,7 @@ static int __init md_setup(char *str)
  	char *pername = "";
  	char *str1;
  	int ent;
+	int major_i = 0, minor_i = 0;

  	if (*str == 'd') {
  		partitioned = 1;
@@ -109,6 +112,49 @@ static int __init md_setup(char *str)
  	case 0:
  		md_setup_args[ent].level = LEVEL_NONE;
  		pername="super-block";
+
+		if (*str == 'v') { /* Superblock version */
+			char *version = ++str;
+			char *version_end = strchr(str, ',');
+
+			if (!version_end) {
+				pr_warn("md: Version (%s) has been specified wrongly, no ',' found, 
use like this: md=<md dev. no.>,X.X,...\n",
+					version);
+				return 0;
+			}
+			*version_end = '\0';
+			str = version_end + 1;
+
+			char *separator = strchr(version, '.');
+
+			if (!separator) {
+				pr_warn("md: Version (%s) has been specified wrongly, no '.' to 
separate major and minor version found, use like this: md=<md dev. 
no.>,vX.X,...\n",
+					version);
+				return 0;
+			}
+			*separator = '\0';
+			char *minor_s = separator + 1;
+
+			int ret = kstrtoint(version, 10, &major_i);
+
+			if (ret != 0) {
+				pr_warn("md: Version has been specified wrongly, couldn't convert 
major '%s' to number, use like this: md=<md dev. no.>,vX.X,...\n",
+					version);
+				return 0;
+			}
+			if (major_i != 0 && major_i != 1) {
+				pr_warn("md: Major version %d is not valid, use 0 or 1\n",
+					major_i);
+				return 0;
+			}
+			ret = kstrtoint(minor_s, 10, &minor_i);
+			if (ret != 0) {
+				pr_warn("md: Version has been specified wrongly, couldn't convert 
minor '%s' to number, use like this: md=<md dev. no.>,vX.X,...\n",
+					minor_s);
+				return 0;
+			}
+		}
+
  	}

  	printk(KERN_INFO "md: Will configure md%d (%s) from %s, below.\n",
@@ -116,6 +162,8 @@ static int __init md_setup(char *str)
  	md_setup_args[ent].device_names = str;
  	md_setup_args[ent].partitioned = partitioned;
  	md_setup_args[ent].minor = minor;
+	md_setup_args[ent].minor_version = minor_i;
+	md_setup_args[ent].major_version = major_i;

  	return 1;
  }
@@ -200,6 +248,9 @@ static void __init md_setup_drive(struct 
md_setup_args *args)

  	err = md_set_array_info(mddev, &ainfo);

+	mddev->major_version = args->major_version;
+	mddev->minor_version = args->minor_version;
+
  	for (i = 0; i <= MD_SB_DISKS && devices[i]; i++) {
  		struct mdu_disk_info_s dinfo = {
  			.major	= MAJOR(devices[i]),
@@ -273,11 +324,15 @@ void __init md_run_setup(void)
  {
  	int ent;

+	/*
+	 * Assemble manually defined raids first
+	 */
+	for (ent = 0; ent < md_setup_ents; ent++)
+		md_setup_drive(&md_setup_args[ent]);
+
  	if (raid_noautodetect)
  		printk(KERN_INFO "md: Skipping autodetection of RAID arrays. 
(raid=autodetect will force)\n");
  	else
  		autodetect_raid();

-	for (ent = 0; ent < md_setup_ents; ent++)
-		md_setup_drive(&md_setup_args[ent]);
  }
