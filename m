Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F34FDF49
	for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 02:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716863354; cv=none; b=dj0Whho9rf0YqEjtgIN1b3TrM74vMm5p0nHJVp92msIfSXBzFcF86v/HyWX5REaVAMMybKcSHm2gD5cGvs0oIzUcH4jafJ5Q0UTHtwy8T8Xxwnffz4nw3m79lCzoVGFYBiNFr/muAWqRFdFM0qtYjOH5S/OwCrPM9+Wf9JLzqlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716863354; c=relaxed/simple;
	bh=90ydmPfa9Rg4aqy5PlglsBvBt04gzSk43odj9NL+9e0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DaMv0TwqgFMD6yCF4Lfw8NROv/aTEQWt352yoVi6HqsRG8z6itzEEn2WMlDSMrIKLOVFVhBhAppLt2YKyxtV2UxkXBVjNyBfIt/5rlBfk6B5y/WFyAZZZsqen1cc8/wlHAu8ClXNO6PupZMqT01DeamGGWBtN/t/rKfvpb1pPWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OmytYdHI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OmytYdHI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716863352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HZeH2P/vNaPy5wvaOHFHnr8KtFEtrvDVdpxgYitCeFg=;
	b=OmytYdHIH0hLdJ/RtFisJDrvE/NfVxZJhHiHIuX5eBrpHtJKEEe5Vpcqb5aNSjIbThgiwh
	AnHHS+08HaoKSO2QRQXPQ3DCu8uFRWQ3e84Kkwy75THS3Nnf+AISAcX/p+rNbr33bT1DCI
	L5r2PgTH3aEAlACSPWXad6NwueFGiZU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-320-SwMTL2BxPQObQUdn_uSHDw-1; Mon, 27 May 2024 22:29:10 -0400
X-MC-Unique: SwMTL2BxPQObQUdn_uSHDw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 150AC101A525;
	Tue, 28 May 2024 02:29:10 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 208DA200A35C;
	Tue, 28 May 2024 02:29:07 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: blazej.kucman@intel.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 1/1] mdadm/platform-intel: Fix buffer overflow
Date: Tue, 28 May 2024 10:29:03 +0800
Message-Id: <20240528022903.20039-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

It reports buffer overflow detected when creating raid with big
nvme devices. In my test, the size of the nvme device is 1.5T.
It can't reproduce this with nvme device which size is smaller
than 1T.

In function get_nvme_multipath_dev_hw_path it allocs memory in a for
loop and the size it allocs is big. So if the iteration number is
large, it has a risk that the stack space is larger than the limit.
So move the memory allocation at the biginning of the funtion.

Fixes: d835518b6b53 ('imsm: nvme multipath support')
Reported-by: Guang Wu <guazhang@redhat.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 platform-intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 15a9fa5a..0732af2b 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -898,6 +898,7 @@ char *get_nvme_multipath_dev_hw_path(const char *dev_path)
 	DIR *dir;
 	struct dirent *ent;
 	char *rp = NULL;
+	char buf[PATH_MAX];
 
 	if (strncmp(dev_path, NVME_SUBSYS_PATH, strlen(NVME_SUBSYS_PATH)) != 0)
 		return NULL;
@@ -907,14 +908,13 @@ char *get_nvme_multipath_dev_hw_path(const char *dev_path)
 		return NULL;
 
 	for (ent = readdir(dir); ent; ent = readdir(dir)) {
-		char buf[strlen(dev_path) + strlen(ent->d_name) + 1];
 
 		/* Check if dir is a controller, ignore namespaces*/
 		if (!(strncmp(ent->d_name, "nvme", 4) == 0) ||
 		    (strrchr(ent->d_name, 'n') != &ent->d_name[0]))
 			continue;
 
-		sprintf(buf, "%s/%s", dev_path, ent->d_name);
+		snprintf(buf, PATH_MAX, "%s/%s", dev_path, ent->d_name);
 		rp = realpath(buf, NULL);
 		break;
 	}
-- 
2.41.0

