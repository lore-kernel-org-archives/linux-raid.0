Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC841227E88
	for <linux-raid@vger.kernel.org>; Thu,  8 May 2025 12:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746708541; cv=none; b=fFPudF2DaUVcKQXdgERhp605GmRMKkoPr5Wble4WHl4+DtMOj3KbPSRb1d6f8I8tEjF3VwchHJYN4e7dgjjSWjQflH/pAkz83WmbWoNi6K+77AFGIvCDH4NZoDlYVE8IA/+IBHbSx03Saf2YrCfH3G8BczyYWdPdA2BA9sXQ3Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746708541; c=relaxed/simple;
	bh=QJiuKwRfbLHW4MK1flPw6PrIfGRJmJ+IKDXYUgZ9fv8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=enENa4Xvtr8O5FuXK7VLD16GitKei023cigwt04jA+g26KQSpKi5VQTPSzU2dLd94EEDCB7ly21FMfR21dRsNxlozAfUPEmqpl1aUyodF3el5uNQw46zAEaFO3YYWk1erltb843K33HYU58SezXT8S2y3KRevlxRRKbH9kXGsek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qx0AI0WU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qx0AI0WU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746708539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1ni/I1b/7bvdhmYmFAsjzNHSzg/q5jBDOyRGAV2GvvU=;
	b=Qx0AI0WUIyLHg90oZeP3leCv4fubHCYr4vwbdjWRJIiI0W6kZ5I95o66AW9pAE1P9PWdB6
	qf+JWXxnC+XbttuKM7njb3nGgN0vn9eXP5OBFRFwBVFCwVlTWQRa9PBditir4qWipskhkp
	nKTgXXolBqev7n7GEYwQyt5wS4Jv2mE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-592-oiCFejGAOP6BUDqZZyo-1g-1; Thu,
 08 May 2025 08:48:57 -0400
X-MC-Unique: oiCFejGAOP6BUDqZZyo-1g-1
X-Mimecast-MFC-AGG-ID: oiCFejGAOP6BUDqZZyo-1g_1746708536
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D33801956089;
	Thu,  8 May 2025 12:48:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B4E5C19560B3;
	Thu,  8 May 2025 12:48:54 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mtkaczyk@kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 6/7] mdadm/tests: mark 09imsm-assemble broken
Date: Thu,  8 May 2025 20:48:30 +0800
Message-Id: <20250508124831.32742-7-xni@redhat.com>
In-Reply-To: <20250508124831.32742-1-xni@redhat.com>
References: <20250508124831.32742-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

09imsm-assemble fails sometimes. So mark it as broken.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/09imsm-assemble.broken | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 tests/09imsm-assemble.broken

diff --git a/tests/09imsm-assemble.broken b/tests/09imsm-assemble.broken
new file mode 100644
index 000000000000..a139042c99a0
--- /dev/null
+++ b/tests/09imsm-assemble.broken
@@ -0,0 +1,30 @@
+Sometimes
+
+Sometimes it fails:
+++ /usr/sbin/mdadm --remove /dev/md/container /dev/loop2
+++ rv=1
+++ case $* in
+++ cat /var/tmp/stderr
+mdadm: /dev/loop2 is still in use, cannot remove.
+++ return 1
+++ sleep 2
+++ (( i++ ))
+++ (( i<=ret ))
+++ '[' 0 -ne 1 ']'
+++ echo '/dev/loop2 removal from /dev/md/container should have succeeded'
+/dev/loop2 removal from /dev/md/container should have succeeded
+
+Sometimes it fails:
+++ imsm_check_hold /dev/md/container /dev/loop1
+++ mdadm --remove /dev/md/container /dev/loop1
+++ rm -f /var/tmp/stderr
+++ case $* in
+++ case $* in
+++ /usr/sbin/mdadm --remove /dev/md/container /dev/loop1
+++ rv=0
+++ case $* in
+++ cat /var/tmp/stderr
+mdadm: hot removed /dev/loop1 from /dev/md/container
+++ return 0
+++ echo '/dev/loop1 removal from /dev/md/container should have been blocked'
+/dev/loop1 removal from /dev/md/container should have been blocked
-- 
2.32.0 (Apple Git-132)

