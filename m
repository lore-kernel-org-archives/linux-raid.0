Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD96A13C69A
	for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 08:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716885887; cv=none; b=U7bc88ldlQvnwMK0z9vQt9LFQ+Pf+7zS4D+57L2CEIcOqWlvZ7uxqJtCZgWGoDx/rFopEkDNrgNhFjXcd+MVwXWv1GpQgx+dbn9dBTSxROqqWzSOPTsmR4ohcSCnCfKA8TtyotRFck99TWVZaGxlC4tSgc5HWuEtucPD4wgtstI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716885887; c=relaxed/simple;
	bh=bqmUYktFtSz4dx+8KRwXzg5XhojXh9fcWTnFeo0Rfj4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QZU79a/xE6UefEvN87M72sw7rv0m7Bv0SpcdfwgU94UWKz6O8+OcgGeR5005dz7EtKJ1b5yT/lUNrltUZjuvzX4QfY+C2UGE9+/N4+2r94dR1huvBl3YL2iikbYp5SiC11J48hoeNG7MuRJNobfL44/669OMiYxEAoPuyBLIgUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B4wvTQPP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B4wvTQPP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716885884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=x1H8WPSeevL+HZu/lYst9aLRTAPrBq5DFI9J/lRglKY=;
	b=B4wvTQPPK244SjCvqhe9s3fyaVY7/LWABB3AYQ64UuKn377h/wCBonc2YddoJ/HqyuqqpD
	qggbXjsKuho1NrgI0r7CmcAjaBUhK5F2Jy/rGTARJqY3mVGxugWR928QEAvNfNHglZclox
	Bsiv1apFXo2kqM1O12KjRgCdJAIOlIY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-vbvGI2U2NGWEd4meB7EREQ-1; Tue, 28 May 2024 04:44:43 -0400
X-MC-Unique: vbvGI2U2NGWEd4meB7EREQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 467668008A4;
	Tue, 28 May 2024 08:44:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 544952818;
	Tue, 28 May 2024 08:44:40 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: pmenzel@molgen.mpg.de,
	linux-raid@vger.kernel.org
Subject: [PATCH 1/1] mdadm/platform-intel: buffer overflow detected
Date: Tue, 28 May 2024 16:44:39 +0800
Message-Id: <20240528084439.23705-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

mdadm -CR /dev/md0 -l1 -n2 /dev/nvme0n1 /dev/nvme2n1
*** buffer overflow detected ***: terminated
Aborted (core dumped)

It doesn't happen 100% and it depends on the building environment.
It can be fixed by replacing sprintf with snprintf.

Fixes: d835518b6b53 ('imsm: nvme multipath support')
Reported-by: Guang Wu <guazhang@redhat.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 platform-intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 15a9fa5ac160..d6a535335ad1 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -907,14 +907,14 @@ char *get_nvme_multipath_dev_hw_path(const char *dev_path)
 		return NULL;
 
 	for (ent = readdir(dir); ent; ent = readdir(dir)) {
-		char buf[strlen(dev_path) + strlen(ent->d_name) + 1];
+		char buf[PATH_MAX];
 
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
2.32.0 (Apple Git-132)

