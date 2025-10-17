Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E5B2DCF43
	for <linux-raid@vger.kernel.org>; Fri, 17 Oct 2025 09:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760692486; cv=none; b=ijdMJ/Jow5iwMmrTSJ5Lh6Lr3FtegOy8paF3bNAGRJlvDu1n5Xq/JpG5nVhqVZSWJYD4PlCddIRdzs29Z+ZG7uHH+qu0Rm2Hv5fJ56K/hJflClz2ASZi6eTuuuX7RAP+Zeis3O3Hy7CbyUVbWRFgRzfKq8hLyTdEaBI93WbvWaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760692486; c=relaxed/simple;
	bh=fHvIcX9dk2yOy1O2g3ehytBKoqt2Qh6N5f3KPU/Blfs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tBrtpTXmxbaNK9EuPpFzKNu+ZEUEC+JLvM9eviXuCjvsrp8/BTz7g2Euik5/kXA4AvBB/b3wRGgmrTRzoc+ADmgsAgamcBPsAZbc4d3164l03ME2uJhXgSAXoPSz2+/B+MVCLxkhkHjK8eZiG6cq1OyETJ60s+t5CJqyL29kJRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cnhB3Iit; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cnhB3Iit"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760692484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3qCWbwirAtaUYJPKfL63cbA73nUSsmf+JEXoaubUeTA=;
	b=cnhB3Iita1tRHoZi6Ijid53qI97tffn5uv0Itk8c49D7EeGFa/gfjyL52lveIJuqZaid91
	btqItQOijRBslL/y1P1r25TyLIBwOF2uUIFW3XGr0p1/WxzoQB24ufh9oyNKFnsO3alVTH
	Yp/mBMWcBCI0SnX1LS7OrjWtzE5mux0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-36-IbrMuuocO-u18hcvq23g_w-1; Fri,
 17 Oct 2025 05:14:42 -0400
X-MC-Unique: IbrMuuocO-u18hcvq23g_w-1
X-Mimecast-MFC-AGG-ID: IbrMuuocO-u18hcvq23g_w_1760692481
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 48258195420F;
	Fri, 17 Oct 2025 09:14:41 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.6])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E0C03300019F;
	Fri, 17 Oct 2025 09:14:38 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mtkaczyk@kernel.org,
	ncroxon@redhat.com
Subject: [PATCH V2 1/2] mdadm/Incremental: wait a while before removing a member
Date: Fri, 17 Oct 2025 17:14:32 +0800
Message-Id: <20251017091433.53602-2-xni@redhat.com>
In-Reply-To: <20251017091433.53602-1-xni@redhat.com>
References: <20251017091433.53602-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

We encountered a regression that member disk can't be removed in
incremental remove mode:
mdadm -If /dev/loop0
mdadm: Cannot remove member device loop0 from md127

It doesn't allow to remove a member if sync thread is running. mdadm -If
sets member disk faulty first, then it removes the disk. If sync thread
is running, it will be interrupted by setting a member faulty. But the sync
thread hasn't been reapped. So it needs to wait a while to let kernel to
reap sync thread.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
v2: use a loop instead sleeping 5 seconds
 Incremental.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index ba3810e6157f..089a8c74eae4 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1715,6 +1715,7 @@ int Incremental_remove(char *devname, char *id_path, int verbose)
 	struct mdstat_ent *ent;
 	struct mdinfo mdi;
 	int mdfd = -1;
+	int retry = 25;
 
 	if (strcmp(devnm, devname) != 0)
 		if (!is_devnode_path(devname)) {
@@ -1790,11 +1791,26 @@ int Incremental_remove(char *devname, char *id_path, int verbose)
 
 	/* Native arrays are handled separatelly to provide more detailed error handling */
 	rv = sysfs_set_memb_state(ent->devnm, devnm, MEMB_STATE_FAULTY);
-	if (rv && verbose >= 0)
-		pr_err("Cannot fail member device %s in array %s.\n", devnm, ent->devnm);
+	if (rv) {
+		if (verbose >= 0)
+			pr_err("Cannot fail member device %s in array %s.\n", devnm, ent->devnm);
+		goto out;
+	}
 
-	if (rv == MDADM_STATUS_SUCCESS)
+	/*
+	 * If resync/recovery is running, sync thread is interrupted by setting member faulty.
+	 * And it needs to wait sometime to let kernel to reap sync thread. If not, it will
+	 * fail to remove it.
+	 */
+	while (retry) {
 		rv = sysfs_set_memb_state(ent->devnm, devnm, MEMB_STATE_REMOVE);
+		if (rv) {
+			sleep_for(0, MSEC_TO_NSEC(200), true);
+			retry--;
+			continue;
+		}
+		break;
+	}
 
 	if (rv && verbose >= 0)
 		pr_err("Cannot remove member device %s from %s.\n", devnm, ent->devnm);
-- 
2.32.0 (Apple Git-132)

