Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2540444C77
	for <linux-raid@vger.kernel.org>; Tue,  3 Jun 2025 05:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748928044; cv=none; b=sEHU72AgtcG9Z+fx7bUIhA7hV6N+x4bEULG67k5LQtQPXLI+qM+mslTBqg84/iTbq42SchigU0CdXXfKiSOJrstVgznmEo5VIs21YJJ55T+mkDiSZ/wVCCD+29rw06dly84A5D99UvT2dF1vKGuuPGAmF24DPRC1lAxD1N7/Nb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748928044; c=relaxed/simple;
	bh=8gzORpTggXFizcsagksGxdgrU0NS4SrcxLXBrDDejTo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RWgQCdHqLvKWR40qenWPNpSVzl/i2kQiJZHkFF1ecolaw0iNTBDuP20lyf+yOWXmePv61y7D/SkJXcjUqYjmCE97k6ERXTXwyBPvQVtpbToWlTAFIqGoDWsiL67ymQZM1vNkCDZq42wGX1BrODqvdMexl+XzYlr06dx+lwHjE5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R2XGBlVh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R2XGBlVh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748928042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q8VPD2Uh/IirCDtStSVfR1feVlgG42QEjO/4tFeiqEY=;
	b=R2XGBlVhxpkg8HXrjEW8AZLb0s4HRUyxYePEbJAAnGx9cl/0vIi0Y3EWvI/3wAbpHAbjwd
	58gblhD2ybkqbC7DFCzdLeu6VCu9BVkShRGkrnESE71Y29zCnUWyJ0mxsWvdTFEM0YXCCw
	MgcFowr7jl1zfCGRJv+8g5/AAdIcCrQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-402-Ptd4deSSMLy1gbclbRZKgw-1; Tue,
 03 Jun 2025 01:20:40 -0400
X-MC-Unique: Ptd4deSSMLy1gbclbRZKgw-1
X-Mimecast-MFC-AGG-ID: Ptd4deSSMLy1gbclbRZKgw_1748928039
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E3951956051;
	Tue,  3 Jun 2025 05:20:39 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.30])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D23EA30002C4;
	Tue,  3 Jun 2025 05:20:36 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	song@kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 3/3] md: remove/add redundancy group only in level change
Date: Tue,  3 Jun 2025 13:20:23 +0800
Message-Id: <20250603052023.7922-4-xni@redhat.com>
In-Reply-To: <20250603052023.7922-1-xni@redhat.com>
References: <20250603052023.7922-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

del_gendisk is called in synchronous way now. So it doesn't need to handle
redundancy group separately.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0913b8236471..84cd21bd85b0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -818,23 +818,16 @@ void mddev_unlock(struct mddev *mddev)
 		mddev->sysfs_active = 1;
 		mutex_unlock(&mddev->reconfig_mutex);
 
-		if (mddev->kobj.sd) {
-			if (to_remove != &md_redundancy_group)
-				sysfs_remove_group(&mddev->kobj, to_remove);
-			if (mddev->pers == NULL ||
-			    mddev->pers->sync_request == NULL) {
-				sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
-				if (mddev->sysfs_action)
-					sysfs_put(mddev->sysfs_action);
-				if (mddev->sysfs_completed)
-					sysfs_put(mddev->sysfs_completed);
-				if (mddev->sysfs_degraded)
-					sysfs_put(mddev->sysfs_degraded);
-				mddev->sysfs_action = NULL;
-				mddev->sysfs_completed = NULL;
-				mddev->sysfs_degraded = NULL;
-			}
-		}
+		sysfs_remove_group(&mddev->kobj, to_remove);
+		if (mddev->sysfs_action)
+			sysfs_put(mddev->sysfs_action);
+		if (mddev->sysfs_completed)
+			sysfs_put(mddev->sysfs_completed);
+		if (mddev->sysfs_degraded)
+			sysfs_put(mddev->sysfs_degraded);
+		mddev->sysfs_action = NULL;
+		mddev->sysfs_completed = NULL;
+		mddev->sysfs_degraded = NULL;
 		mddev->sysfs_active = 0;
 	} else
 		mutex_unlock(&mddev->reconfig_mutex);
@@ -6475,8 +6468,6 @@ static void __md_stop(struct mddev *mddev)
 	if (mddev->private)
 		pers->free(mddev, mddev->private);
 	mddev->private = NULL;
-	if (pers->sync_request && mddev->to_remove == NULL)
-		mddev->to_remove = &md_redundancy_group;
 	put_pers(pers);
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 
-- 
2.32.0 (Apple Git-132)

