Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE79220309
	for <linux-raid@vger.kernel.org>; Wed, 28 Aug 2024 02:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724811147; cv=none; b=CPJ/H+F9+CZZPR2b6Y5wcXa+Sqp5ERuwxzwUHbTV5VsG+kwslrGjOpDy8qA/UiNmGRyQqK2vBQ8GCp6NCw4AN+G2DIS1g5Hvz85yUlj88CTeF0ytYGOhJMLL4uH9nmw/lmjnIvqjnaW3Vc2YvNcrf3s6g1NtWFtwgFnh/JRsULQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724811147; c=relaxed/simple;
	bh=lqh/hc9Hzx2n9o0HIac2typvRDkAaLjv297hZr4uO3I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fAv/Abl1G05wrRNg3GU6IPK2nGYOHJUAgAVkz+6LuntmTpgaBtRfktes3jjluEJqfCbYhFr4f+V1TCD0UlBfIP4xZ2ifwZ0sq0gJYwfBLSi44/6syNUbTrfBFHXt8uOMy5CK6eGB4Sj2BcAG8xKrEwZiKi89hX9giEwS9KSceA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H/tCS0Yz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H/tCS0Yz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724811144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JKHPbuq2GYtWGqa27OUEETlYrvRxIFAn+FcJzlYKos8=;
	b=H/tCS0Yzw/pYhKrwZDfimV0H5QxBnm+yJE96W1O2ft9YNSRkOsmubkCVVA0Rg6HKgVxvmO
	KDI/0fNGoHZAR8PxssudV98bIDaxHZMKppaXe3bIb9drY4emRkEE3RrksiubYABWmYPmr5
	r1bTYsNJJu0l4r+xVlRHKLzRZSvbG1Y=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-14-dxWTmRWaOqW2R8epryLyEA-1; Tue,
 27 Aug 2024 22:12:21 -0400
X-MC-Unique: dxWTmRWaOqW2R8epryLyEA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9DAB61955D54;
	Wed, 28 Aug 2024 02:12:20 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.24])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 453503001FF9;
	Wed, 28 Aug 2024 02:12:16 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 02/10] mdadm/Grow: Update reshape_progress to need_back after reshape finishes
Date: Wed, 28 Aug 2024 10:11:42 +0800
Message-Id: <20240828021150.63240-3-xni@redhat.com>
In-Reply-To: <20240828021150.63240-1-xni@redhat.com>
References: <20240828021150.63240-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

It tries to update data offset when kicking off reshape. If it can't
change data offset, it needs to use child_monitor to monitor reshape
progress and do back up job. And it needs to update reshape_progress
to need_back when reshape finishes. If not, it will be in a infinite
loop.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Grow.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/Grow.c b/Grow.c
index 97e48d86a33f..6b621aea4ecc 100644
--- a/Grow.c
+++ b/Grow.c
@@ -4142,8 +4142,7 @@ int progress_reshape(struct mdinfo *info, struct reshape *reshape,
 		 * waiting forever on a dead array
 		 */
 		char action[SYSFS_MAX_BUF_SIZE];
-		if (sysfs_get_str(info, NULL, "sync_action", action, sizeof(action)) <= 0 ||
-		    strncmp(action, "reshape", 7) != 0)
+		if (sysfs_get_str(info, NULL, "sync_action", action, sizeof(action)) <= 0)
 			break;
 		/* Some kernels reset 'sync_completed' to zero
 		 * before setting 'sync_action' to 'idle'.
@@ -4151,12 +4150,18 @@ int progress_reshape(struct mdinfo *info, struct reshape *reshape,
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

