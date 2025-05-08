Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5E1229B35
	for <linux-raid@vger.kernel.org>; Thu,  8 May 2025 12:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746708541; cv=none; b=SzazJIAgC2HwxQt1Ua+Y8b8j+JiHWrWY+yeOVKYfZ0iUw3vzQczyGBZYGyTKCkuBTRjOaOg+yafUelhofUpnKHODo5bGHU1ZPdhxV3hTpEYMGLBP/UvdNu1sHIa8xvOE0QvFi9fvGCYEguWjxepRGL+dktInuPv3C+moWOjDroE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746708541; c=relaxed/simple;
	bh=AnuNghnAiPqqN55+HfCXnqtutRgkNJ/oRF0XK410LsI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YcoBgc01ICOiTiCTLQ5jhqxZlmC8STFvgDw2A3/32tqxEq7F/GMzIccVBR6lG24zpo8VnnYNOIE5jfCefg6vDgdlO+BfHEzFnMMA6VwTnutkB74+xVjmwrB9EJLEpe2FZgFASRKMG6wf9W0yOdHCUTlDorWZZa+HeVA/5J5tK1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CJ4uSCEn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CJ4uSCEn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746708538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VbB0iomdv9HABEEVfMaaCQIPd0EIA2hgMruwbA86LiY=;
	b=CJ4uSCEnLx7vavKTPaplbv80UDc4VMaYPW16NkOHEmyl/BY9htqi32ZQXb99ZHmieW/P3x
	8t3Hdjtc/xmaqN0EBx9vTxQxQcrt+HJnIucl+iNITadTjT8IDsPewKwLjs3iKuIw41yUsv
	biGni8Yq2C+vyL65Nh14j7/R6BRqHlg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-486-YsPEAtpeNmWcmgVtUx9bXw-1; Thu,
 08 May 2025 08:48:54 -0400
X-MC-Unique: YsPEAtpeNmWcmgVtUx9bXw-1
X-Mimecast-MFC-AGG-ID: YsPEAtpeNmWcmgVtUx9bXw_1746708534
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D945B180087B;
	Thu,  8 May 2025 12:48:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6CE1419560B3;
	Thu,  8 May 2025 12:48:51 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mtkaczyk@kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 5/7] mdadm/tests: mark 10ddf-fail-two-spares broken
Date: Thu,  8 May 2025 20:48:29 +0800
Message-Id: <20250508124831.32742-6-xni@redhat.com>
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

Sometimes 10ddf-fail-two-spares fail because:
++ grep -q 'state\[1\] : Optimal, Consistent' /tmp/mdtest-5k3MzO
++ echo ERROR: /dev/md/vol1 should be optimal in meta data
ERROR: /dev/md/vol1 should be optimal in meta data

Mark this as broken.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/10ddf-fail-two-spares.broken | 11 +++++++++++
 1 file changed, 11 insertions(+)
 create mode 100644 tests/10ddf-fail-two-spares.broken

diff --git a/tests/10ddf-fail-two-spares.broken b/tests/10ddf-fail-two-spares.broken
new file mode 100644
index 000000000000..d0158c042f22
--- /dev/null
+++ b/tests/10ddf-fail-two-spares.broken
@@ -0,0 +1,11 @@
+Sometimes
+
+++ grep -q 'state\[0\] : Optimal, Consistent' /tmp/mdtest-5k3MzO
+++ grep -q 'state\[1\] : Optimal, Consistent' /tmp/mdtest-5k3MzO
+++ echo ERROR: /dev/md/vol1 should be optimal in meta data
+ERROR: /dev/md/vol1 should be optimal in meta data
+
+if ! grep -q 'state\[1\] : Optimal, Consistent' $tmp; then
+    echo ERROR: $member1 should be optimal in meta data
+    ret=1
+fi
-- 
2.32.0 (Apple Git-132)

