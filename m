Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0852116EC1B
	for <linux-raid@vger.kernel.org>; Wed, 11 Sep 2024 08:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726044892; cv=none; b=FmmvhFt+R+Ga1Q5XtkYADNmQ1PvLy+KxwL+5/SIXvR/M02g9K0aTnOjxS5uMeFQ9DaUm36yhC4j5iZ5lAIMCmoQl16OaLQJeplmH40WdzhusTt+65FiAOfbXnsPue/4wQZjQP01R+x7tHMQRkYTQRv59dDD8Ff27Wut+2k4EFfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726044892; c=relaxed/simple;
	bh=jYMSKKeoa+ORWQeKeqzkW2dP+EEVWlS8rS6izULQ3xw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iyp61iv4Cs+4SXpu51y5hwdYMbXEZrwcYDxYelSR6RXDX+OsX1P5y8CabkO4S8YR62UUyYHyTQQdc85+fGOK4Jvb7dUVq+p97s+j+cIEtsYUuqs8lbgfp2guTstkzrs/9HYqMy2c+acCxj4r5snKnVg7TXEHLr2Sr+9RUtjM/O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JhjNaJja; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JhjNaJja"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726044889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mfxDnS7ExbPa4uvLftFRKyLdAS3ZcbvkBVeKamzO26g=;
	b=JhjNaJjaxKOm1n1MEyh/BIdAVn4dOHU9RwdMlMUL3R/k25dmbzzVhcKgZvtwOGhoFsMSc1
	LqgM3mRVrMXbXKpQopHCLj9CLusgA63jyw+82mPg/+OB/Kfo60J3VrZR/FLZPAujIbajIZ
	DFdN77RXob/IXrDHNVSOjo6/TGc+okA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-663-7VUIDpHPM2azmKlNGtRtvA-1; Wed,
 11 Sep 2024 04:54:46 -0400
X-MC-Unique: 7VUIDpHPM2azmKlNGtRtvA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 962EE1955DC4;
	Wed, 11 Sep 2024 08:54:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.25])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F0A101956086;
	Wed, 11 Sep 2024 08:54:42 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH V2 2/2] mdadm/Grow: Update reshape_progress to need_back after reshape finishes
Date: Wed, 11 Sep 2024 16:54:24 +0800
Message-Id: <20240911085432.37828-3-xni@redhat.com>
In-Reply-To: <20240911085432.37828-1-xni@redhat.com>
References: <20240911085432.37828-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

It tries to update data offset when kicking off reshape. If it can't
change data offset, it needs to use child_monitor to monitor reshape
progress and do back up job. And it needs to update reshape_progress
to need_back when reshape finishes. If not, it will be in a infinite
loop.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
v2: add empty line after declaration
 Grow.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/Grow.c b/Grow.c
index 533f301468af..3b9f994200aa 100644
--- a/Grow.c
+++ b/Grow.c
@@ -4148,8 +4148,8 @@ int progress_reshape(struct mdinfo *info, struct reshape *reshape,
 		 * waiting forever on a dead array
 		 */
 		char action[SYSFS_MAX_BUF_SIZE];
-		if (sysfs_get_str(info, NULL, "sync_action", action, sizeof(action)) <= 0 ||
-		    strncmp(action, "reshape", 7) != 0)
+
+		if (sysfs_get_str(info, NULL, "sync_action", action, sizeof(action)) <= 0)
 			break;
 		/* Some kernels reset 'sync_completed' to zero
 		 * before setting 'sync_action' to 'idle'.
@@ -4157,12 +4157,18 @@ int progress_reshape(struct mdinfo *info, struct reshape *reshape,
 		 */
 		if (completed == 0 && advancing &&
 		    strncmp(action, "idle", 4) == 0 &&
-		    info->reshape_progress > 0)
+		    info->reshape_progress > 0) {
+			info->reshape_progress = need_backup;
 			break;
+		}
 		if (completed == 0 && !advancing &&
 		    strncmp(action, "idle", 4) == 0 &&
 		    info->reshape_progress <
-		    (info->component_size * reshape->after.data_disks))
+		    (info->component_size * reshape->after.data_disks)) {
+			info->reshape_progress = need_backup;
+			break;
+		}
+		if (strncmp(action, "reshape", 7) != 0)
 			break;
 		sysfs_wait(fd, NULL);
 		if (sysfs_fd_get_ll(fd, &completed) < 0)
-- 
2.32.0 (Apple Git-132)

