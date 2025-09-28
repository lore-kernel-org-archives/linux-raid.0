Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178A134BA42
	for <linux-raid@vger.kernel.org>; Sun, 28 Sep 2025 01:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759022676; cv=none; b=WkQfOF299kG1trIDjut5xci2u0WET/k20QujaON1VIpyYSeaMe3g810o5V03+4iBoMLMNZdfNNMnwJ+jm2g9MqBa3oDCqHyA8TKcgW0E3BkZEqg3KAXcRCwTaGJjmJ3uW64Duvco21P6llpHkTsu176gHkbWef9trciR7DMUmsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759022676; c=relaxed/simple;
	bh=FSnoMre/zkutV1izlIryfflqXe1krPwesbKB7gOyp8k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BhEAKGsfEGQilWFBKyqwixOOi3dAgCF56ioHL9DGHDYQLpuSyxg0ABwBF3TiL6k5oymbaXbthlliBI8o0pLia6lVaHKEvRuiPIkijy7uIKvua+UPPtEX65FWxoqMnvDSv1WTGvYAkX7rEIx97nSGE25K1043W7/HEs0UzXp9Yrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MUJfJUGY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MUJfJUGY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759022673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IUpPElgV9P3xZuxVoOp96NB056Dmak7w5YfG6ThU1lE=;
	b=MUJfJUGY5DZQDPhSSjw1PHJxTZYBiD6O+bB2Tpf0uRg9kZoyeRaMPvbG9ZXoh9IX8sQdXK
	Cl3iQcDFPVfShpM5FiWKS4tKFNB+pi0F7BHxKy5c75oH6h+RSsyaGqVxgOjtsrbczIasFF
	V7Ee5dcma91yNbtQurut41ObVm88M9U=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-637-UtaADGxEPtajS1Li6xqI3w-1; Sat,
 27 Sep 2025 21:24:31 -0400
X-MC-Unique: UtaADGxEPtajS1Li6xqI3w-1
X-Mimecast-MFC-AGG-ID: UtaADGxEPtajS1Li6xqI3w_1759022670
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8192619560B5;
	Sun, 28 Sep 2025 01:24:30 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.8])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1E05C30001A4;
	Sun, 28 Sep 2025 01:24:27 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai1@huaweicloud.com
Cc: song@kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 1/1] md: delete mddev kobj before deleting gendisk kobj
Date: Sun, 28 Sep 2025 09:24:24 +0800
Message-Id: <20250928012424.61370-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

In sync del gendisk path, it deletes gendisk first and the directory
/sys/block/md is removed. Then it releases mddev kobj in a delayed work.
If we enable debug log in sysfs_remove_group, we can see the debug log
'sysfs group bitmap not found for kobject md'. It's the reason that the
parent kobj has been deleted, so it can't find parent directory.

In creating path, it allocs gendisk first, then adds mddev kobj. So it
should delete mddev kobj before deleting gendisk.

Before commit 9e59d609763f ("md: call del_gendisk in control path"), it
releases mddev kobj first. If the kobj hasn't been deleted, it does clean
job and deletes the kobj. Then it calls del_gendisk and releases gendisk
kobj. So it doesn't need to call kobject_del to delete mddev kobj. After
this patch, in sync del gendisk path, the sequence changes. So it needs
to call kobject_del to delete mddev kobj.

After this patch, the sequence is:
1. kobject del mddev kobj
2. del_gendisk deletes gendisk kobj
3. mddev_delayed_delete releases mddev kobj
4. md_kobj_release releases gendisk kobj

Fixes: 9e59d609763f ("md: call del_gendisk in control path")
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4e033c26fdd4..07e48faa87e0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -887,8 +887,10 @@ void mddev_unlock(struct mddev *mddev)
 		 * do_md_stop. dm raid only uses md_stop to stop. So dm raid
 		 * doesn't need to check MD_DELETED when getting reconfig lock
 		 */
-		if (test_bit(MD_DELETED, &mddev->flags))
+		if (test_bit(MD_DELETED, &mddev->flags)) {
+			kobject_del(&mddev->kobj);
 			del_gendisk(mddev->gendisk);
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(mddev_unlock);
-- 
2.32.0 (Apple Git-132)

