Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50AC18CBF1
	for <linux-raid@vger.kernel.org>; Fri, 18 Oct 2024 08:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729239739; cv=none; b=IT0FjAPdQxob3v6XmSo0gGg9tiZeM1VZ6fRjYWBg1yvU/Zw7U7EfjCBgh8D0QWahfxDGqxdYdLxwRQk/Vsrgw6ZfoF5pvdBYz7mOhC0HbQ+FC7EzSbTUzyWTFYyxn4whIafukrLsD7TACiC7iAZLzfQRpNa0xVxx6ysVRJNuOr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729239739; c=relaxed/simple;
	bh=1re99z1Oa72GA6znpJNmEShbMnc13oqagrBV2Tbd3Yw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r0aahpHWRqL4YT/xJPPsnwg+F8j5B6sWzdPiYy42Q+H98m4mZcBfhwZlFvF+/c1WAcUHTzSV0GBOQNcd/7o8o+WCHxOySifp38lj4JjSJbQoG9ednumarBeGkhNB3wIBSbO8VHO22pYf4D9joVSgnqlFC53rUlwFPK7l83c3i9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FPKb+q6h; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FPKb+q6h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729239736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GxbV10j4o/lWAcpSPHz/c1+HLXiwIvUaoM5/IA6wmHs=;
	b=FPKb+q6hDGQ3GXsltdmtaur+zN5YPLF6ymeKDc51H3IWa0MchekxQ+fz/MQP1gQe5NrUM0
	VYSO8yMZN7aKwiJ47cc3bs9Fh8Q5jysEvzFNFLZxj15vHmkeohH1mP7hknvonEm64TakzW
	cFNQC1zy9pt1bJeeZ38fePSnstCT0cU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-519-gevbfY1WPiSHICOhIklYRw-1; Fri,
 18 Oct 2024 04:22:13 -0400
X-MC-Unique: gevbfY1WPiSHICOhIklYRw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9B8D1954209;
	Fri, 18 Oct 2024 08:22:12 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5EF801955F41;
	Fri, 18 Oct 2024 08:22:09 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 1/2] mdadm/Manage: Clear superblock if adding new device fails
Date: Fri, 18 Oct 2024 16:22:02 +0800
Message-Id: <20241018082203.59963-2-xni@redhat.com>
In-Reply-To: <20241018082203.59963-1-xni@redhat.com>
References: <20241018082203.59963-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

The superblock is kept if adding new device fails. It should clear the
superblock if it fails to add a new disk.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Manage.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Manage.c b/Manage.c
index 246ef3194aaa..a1eb0d6740b4 100644
--- a/Manage.c
+++ b/Manage.c
@@ -793,6 +793,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 	int j;
 	mdu_disk_info_t disc;
 	struct map_ent *map = NULL;
+	int add_new_super = 0;
 
 	if (!get_dev_size(tfd, dv->devname, &ldsize)) {
 		if (dv->disposition == 'M')
@@ -1011,6 +1012,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 			goto unlock;
 		if (tst->ss->write_init_super(tst))
 			goto unlock;
+		add_new_super = 1;
 	} else if (dv->disposition == 'A') {
 		/*  this had better be raid1.
 		 * As we are "--re-add"ing we must find a spare slot
@@ -1078,6 +1080,8 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 	map_unlock(&map);
 	return 1;
 unlock:
+	if (add_new_super)
+		Kill(dv->devname, tst, 0, -1, 0);
 	map_unlock(&map);
 	return -1;
 }
-- 
2.32.0 (Apple Git-132)

