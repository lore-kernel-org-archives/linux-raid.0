Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE34516BE20
	for <linux-raid@vger.kernel.org>; Wed, 11 Sep 2024 08:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726044898; cv=none; b=Ml/xe7d1sdsYaNbaKzoxAlXqeJ6yMfFhV9+Tdl94HmTgARw+DL1UbYiPGtiLTBIolZlfid1yYEU0ev4OVHvK/OYA/UhbfTnGuIjXbAlB32fGcjMSbmqEHwSjUMm0ZhKc6J44dlOv4q1o8wBnqkmAHyDq1GPSMHIpphfvduSA/mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726044898; c=relaxed/simple;
	bh=LSvYbW9kcj+RRSVffoEa1a2vnLzAzbyaqBSrvir4zkU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L0bVUbJAkjP6tCohka0hnfzozAip/271/Y1R8AMJZC/RpVcylOeZC/qFt5gT20WrWEqA0lVN3QjLo/5QRaTpossmZjyl0kQiGvJXdJPlf72PqE8EGA250kFKBS8VJckinJ25Br1rldT9+7wGzCjkFgvsMd3VEIBQGvo9y+n5zOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cz9UzN0k; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cz9UzN0k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726044895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ooleHeqN2lGXjv0S+2TWorgSGK9FJvdY80iru/XKGaY=;
	b=cz9UzN0k1X2K+Kq6d2T4DlzYCFez4yOz5CfkuB/oEuoIPcMJ5wFpWf+pFDktnHUmIJPk1l
	GRH2dVoIIIppHQ9y4xpU0Lveo1WZlGze3Ixs/oSfoS6QD1lwyUZtGQff3z9ENXRPdNjBQe
	2NOSYRwDtakzWv8MwBQ1HQgG1tnnvR8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-290-RFaureYQPemhxFHr5XAOwA-1; Wed,
 11 Sep 2024 04:54:53 -0400
X-MC-Unique: RFaureYQPemhxFHr5XAOwA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 61E7E1955DB2;
	Wed, 11 Sep 2024 08:54:52 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.25])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C28B21956086;
	Wed, 11 Sep 2024 08:54:49 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH v2 4/4] mdadm/Grow: sleep a while after removing disk in impose_level
Date: Wed, 11 Sep 2024 16:54:26 +0800
Message-Id: <20240911085432.37828-5-xni@redhat.com>
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

It needs to remove disks when reshaping from raid456 to raid0. In
kernel space it sets MD_RECOVERY_RUNNING. And it will fail to change
level. So wait sometime to let md thread to clear this flag.

This is found by test case 05r6tor0.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
v2: add log to give friendly message
 Grow.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Grow.c b/Grow.c
index ebb53a0dfe9c..60076f56054c 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3034,6 +3034,13 @@ static int impose_level(int fd, int level, char *devname, int verbose)
 			      makedev(disk.major, disk.minor));
 			hot_remove_disk(fd, makedev(disk.major, disk.minor), 1);
 		}
+		/*
+		 * hot_remove_disk lets kernel set MD_RECOVERY_RUNNING
+		 * and it can't set level. It needs to wait sometime
+		 * to let md thread to clear the flag.
+		 */
+		pr_info("wait 5 seconds to give kernel space to finish job\n");
+		sleep_for(5, 0, true);
 	}
 	c = map_num(pers, level);
 	if (c) {
-- 
2.32.0 (Apple Git-132)

