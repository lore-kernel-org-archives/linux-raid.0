Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D3422EF4
	for <linux-raid@vger.kernel.org>; Mon, 15 Jul 2024 07:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721028979; cv=none; b=gXsIdGqV1kyNrrqJZxKJzBcEVdzrU3RMn6tBaGawgg/ryOHQCDgPmaMLBsj0vsTuwCWxMLjXEmPw3L8ljLOwQh9N10fwmUZdB3QC9F9iwcKjCL/F4cfcrFncGMP0JaL51vTimJDsPpxJcttrJzKCnC0Vw+dTOUdy1NgkHtQ1V6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721028979; c=relaxed/simple;
	bh=3UH09IJZIt0YJhGaVPSj185aJTX/rGHSW6YWXY8TFLM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Rte81xd2kUHx25f8vmPk5nSwAZN02VHB/CUtCfSWCWbHA3pCLape6S87AZxCALu0adJ3CsFr4GtB+VS3SN1yLVHenOuF5dNVLN4wMMTBoO5CDzJFfKkwzM5c+pZgden+etuhXXEKYFO9ihkpv79r8O8yd2xwGt9BgkAzL6DPtVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=StXVLD4r; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="StXVLD4r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721028977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+IcMNcAjpCFqPXlK6Q+JdS+fawfLdatIbaOsSew9HKE=;
	b=StXVLD4rMsvSjWNvAsvYbJR2OGeU0k2mGXFCxZAO+fe8aS7oq8V4Ddt5Q9ojZWsmY/0Fzh
	C7BQ8slCeP/pUKZ2u+ck9WT3N3ftQZwDD+WOfNexvmZRwBRRUBiZ5IIOO14Q80ZAI4Xjtd
	X1gmfH5nt+FaNnxQ/ntos34ULqpsbOU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-503-uJ2WIK6INeyy4drFrgrIcQ-1; Mon,
 15 Jul 2024 03:36:14 -0400
X-MC-Unique: uJ2WIK6INeyy4drFrgrIcQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5ADC71955BF7;
	Mon, 15 Jul 2024 07:36:13 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.27])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B0F071955D44;
	Mon, 15 Jul 2024 07:36:10 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 01/15] mdadm/Manage: 01r1fail cases fails
Date: Mon, 15 Jul 2024 15:35:50 +0800
Message-Id: <20240715073604.30307-2-xni@redhat.com>
In-Reply-To: <20240715073604.30307-1-xni@redhat.com>
References: <20240715073604.30307-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

This patch fixes a regression issue which is checked by 01r1fail case.

Fixes: 1b4b73fd535a ('mdadm: Manage.c fix coverity issues')
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Manage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Manage.c b/Manage.c
index aa5e80b2805d..f0304e1e4d3d 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1333,7 +1333,7 @@ bool is_remove_safe(mdu_array_info_t *array, const int fd, char *devname, const
 
 	char *avail = xcalloc(array->raid_disks, sizeof(char));
 
-	for (disk = mdi->devs; disk; disk = mdi->next) {
+	for (disk = mdi->devs; disk; disk = disk->next) {
 		if (disk->disk.raid_disk < 0)
 			continue;
 		if (!(disk->disk.state & (1 << MD_DISK_SYNC)))
-- 
2.32.0 (Apple Git-132)

