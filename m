Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7926D199B9
	for <linux-raid@vger.kernel.org>; Wed, 28 Aug 2024 02:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724811184; cv=none; b=p23c7aFJYl5YlrwV07iLVZZAYbsf1sU3H+T99Grp+1J7m7ZSxA1o4QkSxQunhtKxA9aW2LFz5DWsfyJrvdMdy+91wPfYb/q2pURBz2dkSotcZ7XlAIgukODIjmiL9YuNkolekaKe+1LMHTaDTfX5yE7epV4KtdLbQcKxjfGoR0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724811184; c=relaxed/simple;
	bh=igfVsssIvRAX/6DmDpKDYJ/OAv6zpJBv4CpmVx5nCvw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XGU1M6NOCNDbL+kne1PMsl2S1YjyCaNBuqgJA2mHsyDTD/D9TvfKDuuG+2fB0eT9boMa0wq5KfgUL6xdjjO4ci8/Esv+nulNNBUzQIQvkZoQ5GpL/I/F+ga8quL9jn0Bf3hQC9duhbs8ViCw2dRP8FMR04upDYt/BeYl+gCs6CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jT6Az7Xl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jT6Az7Xl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724811182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wWH5gDud2ndQLIPMQhg3f5hHUoHebPVMFZppoap6NHw=;
	b=jT6Az7XlwSWT4/ADO1JVgdH+hEspfT8nz27kQDx1jXWa6rjJGmvldGF+/55dq9bVNY+k4B
	/vIS3xcwZyJsH5+GJyPZxGyzWYjOudpGd3+eU3GpcsRyTdDwOMcpfC21f0uSJO7D9WCheB
	Osyenv1z9PNd0qfOe+jambtdbNQEvPU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-540-8ugTrjfZMqiB6aMDO47aPw-1; Tue,
 27 Aug 2024 22:12:58 -0400
X-MC-Unique: 8ugTrjfZMqiB6aMDO47aPw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A2271955F3B;
	Wed, 28 Aug 2024 02:12:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.24])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 188533001FF9;
	Wed, 28 Aug 2024 02:12:53 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 10/10] mdadm/Manage: record errno
Date: Wed, 28 Aug 2024 10:11:50 +0800
Message-Id: <20240828021150.63240-11-xni@redhat.com>
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

Sometimes it reports:
mdadm: failed to stop array /dev/md0: Success
It's the reason the errno is reset. So record errno during the loop.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Manage.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Manage.c b/Manage.c
index 241de05520d6..aba97df8e122 100644
--- a/Manage.c
+++ b/Manage.c
@@ -238,13 +238,14 @@ int Manage_stop(char *devname, int fd, int verbose, int will_retry)
 					    "array_state",
 					    "inactive")) < 0 &&
 		       errno == EBUSY) {
+			err = errno;
 			sleep_for(0, MSEC_TO_NSEC(200), true);
 			count--;
 		}
 		if (err) {
 			if (verbose >= 0)
 				pr_err("failed to stop array %s: %s\n",
-				       devname, strerror(errno));
+				       devname, strerror(err));
 			rv = 1;
 			goto out;
 		}
@@ -438,14 +439,15 @@ done:
 	count = 25; err = 0;
 	while (count && fd >= 0 &&
 	       (err = ioctl(fd, STOP_ARRAY, NULL)) < 0 && errno == EBUSY) {
+		err = errno;
 		sleep_for(0, MSEC_TO_NSEC(200), true);
 		count --;
 	}
 	if (fd >= 0 && err) {
 		if (verbose >= 0) {
 			pr_err("failed to stop array %s: %s\n",
-			       devname, strerror(errno));
-			if (errno == EBUSY)
+			       devname, strerror(err));
+			if (err == EBUSY)
 				cont_err("Perhaps a running process, mounted filesystem or active volume group?\n");
 		}
 		rv = 1;
-- 
2.32.0 (Apple Git-132)

