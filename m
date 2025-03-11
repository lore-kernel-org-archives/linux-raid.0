Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD681EA7FC
	for <linux-raid@vger.kernel.org>; Tue, 11 Mar 2025 05:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741669424; cv=none; b=YYH2sXqafJqS15Q9yVxVLOw8RZRCMNRdOjkTaaPLcOWEIPXoPstBHBkYvmOlr/kWzAuT9GcrFHbx85+H9aYy/ExDKHMjroD5NgTPXqiZ7VhsfMllZZfct3mLNx+oPbz49uPGKTIbSvnADpCH8i6Ll536KKtlyeX5+WZHmOmB9ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741669424; c=relaxed/simple;
	bh=rX0cJ1pxA6bLoHomVPBelfEAFjfcUcnxHEfNW7YprTw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CVlnl5/eW0OxuaUZ6/71eFcNgJ4DehttVEd84Gytx2iTY5tzb9zmBh0XkE5DS6UGK02Y9JP0KpGQv9OJ+GYt74o8kO/a0sCFn8DIkJyww/PRNsskoqb0tBr2zmgEWkb1xpw3aNm0G/pHKDNm65HzdVpZvoc+UzINq7+wZ5hFevc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hZ0WduZV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hZ0WduZV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741669420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZjUbkys6JmLFrNrVFZgS9zWrlkTKqHU6ljkjTSWr/k4=;
	b=hZ0WduZVf32yTmprECHrXe0uiqTE7qXmqQ5cS00/9MAO1Rpw4f+06SDeabXEx3qJ5Rsv+P
	+06gSQCbUd1r2CPikUrhHxDARcT7vbEhx/N7IacQ+fpN9F42VPjJShDv5EWaCmHVzFMTLm
	W2ll+oQXYGjiDKt+8DHwdV4QTUkKdFg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-479-JrdZY82BPG2dIRs6vYW2vA-1; Tue,
 11 Mar 2025 01:03:38 -0400
X-MC-Unique: JrdZY82BPG2dIRs6vYW2vA-1
X-Mimecast-MFC-AGG-ID: JrdZY82BPG2dIRs6vYW2vA_1741669417
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D5A4A1956087;
	Tue, 11 Mar 2025 05:03:37 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.22])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 041B11800268;
	Tue, 11 Mar 2025 05:03:34 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mariusz.tkaczyk@linux.intel.com,
	ncroxon@redhat.com,
	blazej.kucman@linux.intel.com
Subject: [PATCH 1/4] mdadm/tests: Mark 07revert-inplace broken
Date: Tue, 11 Mar 2025 13:03:24 +0800
Message-Id: <20250311050327.4889-2-xni@redhat.com>
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

07revert-inplace can't run successfullly.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/07revert-inplace.broken | 8 ++++++++
 1 file changed, 8 insertions(+)
 create mode 100644 tests/07revert-inplace.broken

diff --git a/tests/07revert-inplace.broken b/tests/07revert-inplace.broken
new file mode 100644
index 000000000000..73d98a0425b4
--- /dev/null
+++ b/tests/07revert-inplace.broken
@@ -0,0 +1,8 @@
+always fails
+
+Fails with errors:
+	++ /usr/sbin/mdadm -A /dev/md0 --update=revert-reshape /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 --backup-file=/tmp/md-backup
+++ rv=1
+++ case $* in
+++ cat /var/tmp/stderr
+mdadm: failed to RUN_ARRAY /dev/md0: Invalid argument
-- 
2.32.0 (Apple Git-132)

