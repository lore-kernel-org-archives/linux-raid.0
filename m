Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE3D1714D3
	for <linux-raid@vger.kernel.org>; Wed, 11 Sep 2024 08:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726044917; cv=none; b=mNCquBp2PAplP8POmy5tmNTtRcRWLFT3oQEyPQcwg9gSveGf9deTdpeuWJvrG2awqv3WdFObpS4dycCl4dyWsxZskCDsSsu8BQQBOzQaUNRnOud5iq96uRIOFQjce9XlE4+9WVu6nJsqaVVpnlA9+b/u2cXAM83Y5w9bbSS+mbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726044917; c=relaxed/simple;
	bh=igfVsssIvRAX/6DmDpKDYJ/OAv6zpJBv4CpmVx5nCvw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JWjTNuKmiNFlFoe6AshgUMyMvw/qqJrfj5BnNd1YJjSEUba/6+h7MHQJJeuy0lO2VUfyZHvocaM6djaLLqeh9DX20KzKcXuRycCXiHzCilc8RTeYcQoKsnt3VAL2RZPguT6d2IymbaVI722fr2wF6OHsgxYexIVsiU3KKCT+vhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oq8PDC6l; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oq8PDC6l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726044915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wWH5gDud2ndQLIPMQhg3f5hHUoHebPVMFZppoap6NHw=;
	b=Oq8PDC6lsvtFXH/94GHf2C3cgyX4mphpP85KkmhuxJcZ2xQjL+yBI74NXCv3C+Ck2JMqcE
	DfGWHtPnxyFWUmBrFpiP77Xheh7GyTtiCZre8xQutNtSZV80of2iMsXjEiaHp1LJGU8Cib
	SAaepMfJGWHiLfZVIjXoebEdl448F9Q=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-284-LhSId8hYMsSSMhVH24RPmg-1; Wed,
 11 Sep 2024 04:55:13 -0400
X-MC-Unique: LhSId8hYMsSSMhVH24RPmg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EEDDF1955EA2;
	Wed, 11 Sep 2024 08:55:12 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.25])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8A9EE1956096;
	Wed, 11 Sep 2024 08:55:10 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 10/10] mdadm/Manage: record errno
Date: Wed, 11 Sep 2024 16:54:32 +0800
Message-Id: <20240911085432.37828-11-xni@redhat.com>
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

