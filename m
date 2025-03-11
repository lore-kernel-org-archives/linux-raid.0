Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CF51D5CFB
	for <linux-raid@vger.kernel.org>; Tue, 11 Mar 2025 05:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741669436; cv=none; b=s3KpquGHx9V3LvGvVV741eDvBvJYo6PV11j4j6MqmJcwyooMxxI89vIgGy697rBtp4h1Z9G+IGHoHD1YEiV3ZrRc8OlEyFZnF3QVk71tewFIJ8ZYtVYk/zAKkU1zWl1dpZ1yYDDUALntFniy5VsoyXV1pB/BtNNSYLlIHyHolgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741669436; c=relaxed/simple;
	bh=orN7QbVcL3VOG5cDPG4En3oyKFESuTXhcX3uJ0vLTuo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BZWHHU5SNHIIH+756pYrzI7YA6OG3YukuRZblRVECVReJc805eFRfJ47yHYRawtD0QoiLq+gq4mF7AhU1hTImDcN7nuSsBA5M9rlOQOapbAA2Gj53qE5PJbCEzPNhkNFHqTyu9mgvX/TJtBAYgmw7YFg3msbCTDb1IKpvqrlEPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N8OVEZip; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N8OVEZip"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741669433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mqgLsB893Q6+O0o0tD25TmOfg08g4w20SPWFV19Ci18=;
	b=N8OVEZipggJNSIHRVezP6h00Q2Zz7qVZruikQBjAM9nwXM/PDngT8QtbFBN6/HUxfZjCEN
	9WQyEyn2mOIJhb12wgW8MYk4emkrU/r4JURnEWXmXK3XXg6L54f0DI3kOIDmPh4OmcYiA7
	ZaosX1wwusoLq599+Q5d6q0kb4Xh5sE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-182-ZI0l962LPWaAslcI-y7lnQ-1; Tue,
 11 Mar 2025 01:03:49 -0400
X-MC-Unique: ZI0l962LPWaAslcI-y7lnQ-1
X-Mimecast-MFC-AGG-ID: ZI0l962LPWaAslcI-y7lnQ_1741669429
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F39E218004A9;
	Tue, 11 Mar 2025 05:03:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.22])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 493571800268;
	Tue, 11 Mar 2025 05:03:45 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mariusz.tkaczyk@linux.intel.com,
	ncroxon@redhat.com,
	blazej.kucman@linux.intel.com
Subject: [PATCH 4/4] mdadm/tests: Remove 10ddf-create.broken and 10ddf-fail-two-spares.broken
Date: Tue, 11 Mar 2025 13:03:27 +0800
Message-Id: <20250311050327.4889-5-xni@redhat.com>
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

In env-ddf-template, it uses MDADM_NO_SYSTEMCTL=1. But in
continue_via_systemd it returns MDADM_STATUS_SUCCESS, so
mdadm doesn't start mdmon itself.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/10ddf-create.broken          | 5 -----
 tests/10ddf-fail-two-spares.broken | 5 -----
 util.c                             | 2 +-
 3 files changed, 1 insertion(+), 11 deletions(-)
 delete mode 100644 tests/10ddf-create.broken
 delete mode 100644 tests/10ddf-fail-two-spares.broken

diff --git a/tests/10ddf-create.broken b/tests/10ddf-create.broken
deleted file mode 100644
index 0f7d25e5b120..000000000000
--- a/tests/10ddf-create.broken
+++ /dev/null
@@ -1,5 +0,0 @@
-Fails due to segmentation fault at assemble.
-
-Too much effort to diagnose this now, marking as broken to make CI clear.
-	++ /usr/sbin/mdadm -A /dev/md/ddf0 /dev/loop8 /dev/loop9 /dev/loop10 /dev/loop11 /dev/loop12
-	./test: line 76: 101955 Segmentation fault      (core dumped) $mdadm "$@" 2> $targetdir/stderr
diff --git a/tests/10ddf-fail-two-spares.broken b/tests/10ddf-fail-two-spares.broken
deleted file mode 100644
index eeea56d989ff..000000000000
--- a/tests/10ddf-fail-two-spares.broken
+++ /dev/null
@@ -1,5 +0,0 @@
-fails infrequently
-
-Fails roughly 1 in 3 with error:
-
-   ERROR: /dev/md/vol1 should be optimal in meta data
diff --git a/util.c b/util.c
index 8c45f0e1feaf..9fe2d2276712 100644
--- a/util.c
+++ b/util.c
@@ -2310,7 +2310,7 @@ mdadm_status_t continue_via_systemd(char *devnm, char *service_name, char *prefi
 	dprintf("Start %s service\n", service_name);
 	/* Simply return that service cannot be started */
 	if (check_env("MDADM_NO_SYSTEMCTL"))
-		return MDADM_STATUS_SUCCESS;
+		return MDADM_STATUS_ERROR;
 
 	/* Fork in attempt to start services */
 	switch (fork()) {
-- 
2.32.0 (Apple Git-132)

