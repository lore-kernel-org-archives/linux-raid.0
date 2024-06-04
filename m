Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D919DC2F2
	for <linux-raid@vger.kernel.org>; Tue,  4 Jun 2024 16:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717519136; cv=none; b=TmeQjh/zz8PRgr2sS/aT6olxwy3DZgtC+RIhx5JLoMKNufp9ya4WrhsC8UjQH7Q/wh0Su4L/BpDKw3PRq52u+j9A7uBjZC+ZgOmkIXf85aKGUZ8v21VbUMnE19lI0XyclqJzV8q543o7oC19F9W6bl1YAegQ+rg3P3RqefG7wps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717519136; c=relaxed/simple;
	bh=fbH0y9pFyECgRTmhnY+QYPDk/zJYTemrrqyEXKNAF8o=;
	h=From:To:Cc:Date:Message-Id:In-Reply-To:References:MIME-Version:
	 Subject; b=slkn5Ee11r4oo1KVf8yIVOTh9zBM0ccivbBZYFSCDsZjmvXs5p+ifT8c0ypKuXXrxl4sqb0NzpVSSCwZ6CpY5x2Zz16JM4U3Di44M6Xz7TqtQTa4VBn70fo6ir0lfNYrr6uXpRYVUxy72MFdXMnVXGxN4PBcrk73MrxOSXZBD6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=OGcq/d6s; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="OGcq/d6s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Cc:To:From:content-disposition;
	bh=y+xlUNGjBvnVLkkU2ggSM13F2Pf0/n/HaBQYqzUdtG0=; b=OGcq/d6sHguiIRNMqZuMAWhimS
	dO4r+eX0ZRIFlsjCoRxNS3W+2XwsvLwj3W5QgTzak17XIXNE3M9hzzeLDx2/p9/HoZTWN8voLgyls
	2T0Jy8ATmDyiDg/iTfg/17WgCcqXa42u/04bkcvVME3K1yfCLxu37BuTNjo/WudOhD+xIhCoKWJkF
	LeC7pFVmES4GgNICRoKVoQS1VBtXkX1JT8hAYLu3Vqi/yb7Ml2ee00f8ramZHx5tkwDNJUswk+kqC
	DWV8FBjbNLCm257ISQ6T+NUY519xeiEGhkU679G92A/7xDAZYfvkF7+xHCktThnKEmJC73CiC/SbO
	7eG0VmCw==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
	by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <gunthorp@deltatee.com>)
	id 1sEXBT-000frs-0f;
	Tue, 04 Jun 2024 10:38:52 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.96)
	(envelope-from <gunthorp@deltatee.com>)
	id 1sEXBG-003Lep-1w;
	Tue, 04 Jun 2024 10:38:38 -0600
From: Logan Gunthorpe <logang@deltatee.com>
To: linux-raid@vger.kernel.org,
	Jes Sorensen <jes@trained-monkey.org>,
	Xiao Ni <xni@redhat.com>
Cc: Guoqing Jiang <guoqing.jiang@linux.dev>,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Logan Gunthorpe <logang@deltatee.com>
Date: Tue,  4 Jun 2024 10:38:36 -0600
Message-Id: <20240604163837.798219-2-logang@deltatee.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240604163837.798219-1-logang@deltatee.com>
References: <20240604163837.798219-1-logang@deltatee.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, xni@redhat.com, guoqing.jiang@linux.dev, mariusz.tkaczyk@linux.intel.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
X-Spam-Level: 
Subject: [PATCH mdadm 1/2] mdadm: Fix hang race condition in wait_for_zero_forks()
X-SA-Exim-Version: 4.2.1 (built Wed, 06 Jul 2022 17:57:39 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)

Running a create operation with --write-zeros can randomly hang
forever waiting for child processes. This happens roughly on in
ten runs with when running with small (20MB) loop devices.

The bug is caused by the fact that signals can be coallesced into
one if they are not read by signalfd quick enough. So if two children
finish at exactly the same time, only one SIGCHLD will be received
by the parent.

To fix this, wait on all processes with WNOHANG every time a SIGCHLD
is recieved and exit when all processes have been waited on.

Reported-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 Create.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/Create.c b/Create.c
index d033eb68f30c..4f992a22b7c9 100644
--- a/Create.c
+++ b/Create.c
@@ -178,6 +178,7 @@ static int wait_for_zero_forks(int *zero_pids, int count)
 	bool interrupted = false;
 	sigset_t sigset;
 	ssize_t s;
+	pid_t pid;
 
 	for (i = 0; i < count; i++)
 		if (zero_pids[i])
@@ -196,7 +197,7 @@ static int wait_for_zero_forks(int *zero_pids, int count)
 		return 1;
 	}
 
-	while (1) {
+	while (wait_count) {
 		s = read(sfd, &fdsi, sizeof(fdsi));
 		if (s != sizeof(fdsi)) {
 			pr_err("Invalid signalfd read: %s\n", strerror(errno));
@@ -209,23 +210,24 @@ static int wait_for_zero_forks(int *zero_pids, int count)
 			pr_info("Interrupting zeroing processes, please wait...\n");
 			interrupted = true;
 		} else if (fdsi.ssi_signo == SIGCHLD) {
-			if (!--wait_count)
-				break;
+			for (i = 0; i < count; i++) {
+				if (!zero_pids[i])
+					continue;
+
+				pid = waitpid(zero_pids[i], &wstatus, WNOHANG);
+				if (pid <= 0)
+					continue;
+
+				zero_pids[i] = 0;
+				if (!WIFEXITED(wstatus) || WEXITSTATUS(wstatus))
+					ret = 1;
+				wait_count--;
+			}
 		}
 	}
 
 	close(sfd);
 
-	for (i = 0; i < count; i++) {
-		if (!zero_pids[i])
-			continue;
-
-		waitpid(zero_pids[i], &wstatus, 0);
-		zero_pids[i] = 0;
-		if (!WIFEXITED(wstatus) || WEXITSTATUS(wstatus))
-			ret = 1;
-	}
-
 	if (interrupted) {
 		pr_err("zeroing interrupted!\n");
 		return 1;
-- 
2.39.2

