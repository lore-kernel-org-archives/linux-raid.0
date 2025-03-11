Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084CD1EBA09
	for <linux-raid@vger.kernel.org>; Tue, 11 Mar 2025 05:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741669426; cv=none; b=oVDmrEQtRsL1q3WcGCj6p911xXH6pcA4fqiPcKA31HnrQNXqRoxQhO7yvQRjRQzXog6Aye3uFIVL5d7AggS5ViOarTwFkpk9pYBBi0k0Z5Dx6WONHRpW3YU6Y6YUBE/GNCfgxoVTZbjJ3De6OonQGvIgUMoD+Ttfk2FE9askpx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741669426; c=relaxed/simple;
	bh=OX0FYCuB2RS5/WjfQ6oeGJ1AUw7pIebp/m3Ca3G1RZ8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f1IIWs9+qrEXwKxIXqFRsC/0Zn5Zuzilmw5E7wqUE1pXgN1e2+Ql65ABkbsUFVfp7/ykXw4MXbvUdZXSLAqfX5iCDyYNoWfdtYAdC+nd6CB2HJL15T/rgEsW2OYn9OoItRyj7hYHzMRyn+J/cZ07uUfTYVjHwdun4KGTdIfhHhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HjyVYQwX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HjyVYQwX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741669423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xhAKFyVvwGCR/LHC2JCfHpBgsJjxfpPCPgibrH6FwuI=;
	b=HjyVYQwXDYf+uWfBJkfkm+LokIc33m8ekzNQ2V5KRH2MweXIRb8phlLAPFPg2aNOc7hXdm
	SCHT6okrWqEI5hi7xt4sCFGblMY45CfmS3SrRUmxbKzrfqgl3nGAW7YowoyYxkGTqWVFDm
	aLz3AnvlywelSrAGZSScChVKFb2rtbs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-R3veD_dqOxm2s3hYzKw4nw-1; Tue,
 11 Mar 2025 01:03:42 -0400
X-MC-Unique: R3veD_dqOxm2s3hYzKw4nw-1
X-Mimecast-MFC-AGG-ID: R3veD_dqOxm2s3hYzKw4nw_1741669421
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76A30180AB16;
	Tue, 11 Mar 2025 05:03:41 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.22])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AF6241800268;
	Tue, 11 Mar 2025 05:03:38 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mariusz.tkaczyk@linux.intel.com,
	ncroxon@redhat.com,
	blazej.kucman@linux.intel.com
Subject: [PATCH 2/4] mdadm/tests: Mark 20raid5journal fail
Date: Tue, 11 Mar 2025 13:03:25 +0800
Message-Id: <20250311050327.4889-3-xni@redhat.com>
In-Reply-To: <20250311050327.4889-1-xni@redhat.com>
References: <20250311050327.4889-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

20raid5journal can't run successfully

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/20raid5journal.broken | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 tests/20raid5journal.broken

diff --git a/tests/20raid5journal.broken b/tests/20raid5journal.broken
new file mode 100644
index 000000000000..c7b214af5f9f
--- /dev/null
+++ b/tests/20raid5journal.broken
@@ -0,0 +1,17 @@
+always fail
+
+++ /usr/sbin/mdadm -I /dev/loop4
+++ rv=0
+++ case $* in
+++ cat /var/tmp/stderr
+mdadm: /dev/loop4 attached to /dev/md/0_0, which has been started.
+++ return 0
+++ check raid5
+++ case $1 in
+++ grep -sq 'active raid5 ' /proc/mdstat
+++ die 'active raid5 not found'
+++ echo -e '\n\tERROR: active raid5 not found \n'
+
+        ERROR: active raid5 not found
+
+++ save_log fail
-- 
2.32.0 (Apple Git-132)

