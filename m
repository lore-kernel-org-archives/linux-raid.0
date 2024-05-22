Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5699E7710B
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367875; cv=none; b=nrr02i2P0K8WCLktuepSlxnjl1Oaam4Zh6BY6A5Qsn3KYYIxUjPlTLhctBJD6xtfw+K9ccjFoi1d48UPxDfyXjheE2SF52f8sl+eXRseLfKIVvr48M6U3PS18X+RmfMB/j0/7+0ZhlT8KY3cQUoSlPV2LF6+zICtUhX9IwYYGHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367875; c=relaxed/simple;
	bh=p+QZAwKCqkCkvWFiz3xHlQ+LJqcMBgExQb7mKMWDfGg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H111unkpI0zd+RNGWUluiAIBAFNo3cffHlZs8GpA21MdpdJY9mClAb3G5Qr3W9saz7NWZQ52GU0eG7QyXV1lheqljnx9s94Cu/vDu6JkS3LHA7U0wCFJsq6XRP9aCmiluXOKkrsUtsp8wyAuIclPfRd7ZKdh9VDI6xINHi6Y6S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GjhKUjrj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GjhKUjrj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zY9hqlO8AHvdci9zGdscxG2InfC1+6VqbfudXccxZjw=;
	b=GjhKUjrj/SfMUWnFKX7imjuz9AtiYBnP/GRs6bM8Lan42qr5A96MnZyDKp7/QGL187O46H
	JWexqfH20F6XVaQbZgfSrJ/bYyKIkXp6IrUtgwNq45kx+kBhZOe9It8TCoP4VAEQDUpSge
	oBubTc//5KeOay+Vnfk2sySrJ1AAWEc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-70-oAbOAfY7PaqSYETpEhY0dQ-1; Wed,
 22 May 2024 04:51:10 -0400
X-MC-Unique: oAbOAfY7PaqSYETpEhY0dQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C80D3380673C;
	Wed, 22 May 2024 08:51:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8F3DFC15BB1;
	Wed, 22 May 2024 08:51:07 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	heinzm@redhat.com,
	ncroxon@redhat.com
Subject: [PATCH 03/19] Don't control reshape speed in daemon
Date: Wed, 22 May 2024 16:50:40 +0800
Message-Id: <20240522085056.54818-4-xni@redhat.com>
In-Reply-To: <20240522085056.54818-1-xni@redhat.com>
References: <20240522085056.54818-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

It tries to set the max sync speed in reshape. This should be done by
administrators by control interfaces /proc/sys/dev/raid/speed_limit_max/min.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Grow.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/Grow.c b/Grow.c
index 1923c27c4274..01bbb338cb1b 100644
--- a/Grow.c
+++ b/Grow.c
@@ -4484,7 +4484,6 @@ int child_monitor(int afd, struct mdinfo *sra, struct reshape *reshape,
 	 */
 	char *buf;
 	int degraded = -1;
-	unsigned long long speed;
 	unsigned long long suspend_point, array_size;
 	unsigned long long backup_point, wait_point;
 	unsigned long long reshape_completed;
@@ -4540,10 +4539,6 @@ int child_monitor(int afd, struct mdinfo *sra, struct reshape *reshape,
 	if (posix_memalign((void**)&buf, 4096, disks * chunk))
 		/* Don't start the 'reshape' */
 		return 0;
-	if (reshape->before.data_disks == reshape->after.data_disks) {
-		sysfs_get_ll(sra, NULL, "sync_speed_min", &speed);
-		sysfs_set_num(sra, NULL, "sync_speed_min", 200000);
-	}
 
 	if (increasing) {
 		array_size = sra->component_size * reshape->after.data_disks;
@@ -4676,8 +4671,6 @@ int child_monitor(int afd, struct mdinfo *sra, struct reshape *reshape,
 	sysfs_set_num(sra, NULL, "suspend_lo", 0);
 	sysfs_set_num(sra, NULL, "sync_min", 0);
 
-	if (reshape->before.data_disks == reshape->after.data_disks)
-		sysfs_set_num(sra, NULL, "sync_speed_min", speed);
 	free(buf);
 	return done;
 }
-- 
2.32.0 (Apple Git-132)

