Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97E922A4E1
	for <linux-raid@vger.kernel.org>; Thu,  8 May 2025 12:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746708545; cv=none; b=ChBybs8Dor3HCJKxaKAexDVi0ZZD+Qw05wgSFZmEmacZTGxVtR21q4fa+N7mvr+g+LYJXuz+UaEgac8+V9Dy+YVbTePbWnQnY+jIZ4Q1k5C0kXra7+cKYOWtJ2uQve/QVbMoCmElZBPpD6WcEk9UHxeb0mbcdAoNH/OLRD85LSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746708545; c=relaxed/simple;
	bh=8kCjC5yZjWnZF2sdyWXp0PUcc9M+QNBEiTDCiL88la4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LndqykUri1dYKkX/LoU70Nqqv3sLxImnGTbB7/z8eJvFFluGE2tLCBlRgO2EZQ39Tf92V1c6AFDc4XzbASCNNSYbufyIAdSyEC9sBFCMpot2MtJ3MogZqWlyQnEw4rhwhA/Q2YN4XMUEECaIby06mN4lYsQjBPfjko2UpQLNEiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ThfHSMP+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ThfHSMP+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746708542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uHW6c95/x0lnUh3PY/JLnYfrhC1Y8zohUTdOY6rPbXk=;
	b=ThfHSMP+CAQJnTyuzoUx+VwGbgPNCs2vDoKo+biYG51xFMqNcWZcB8c4REFYWt8qw9UNIf
	aW8Dm06y4og+z7s/YbtSerc8sucnabjXi/G1usO2+CVXNtDkS+eX4xyKBMCHO+c6+GJ8zZ
	sKWNp7GJU7KjYsObfx9qQ97/sY4T1Lg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-542-3ik-ylsSPemLM1B_PkHZyg-1; Thu,
 08 May 2025 08:49:01 -0400
X-MC-Unique: 3ik-ylsSPemLM1B_PkHZyg-1
X-Mimecast-MFC-AGG-ID: 3ik-ylsSPemLM1B_PkHZyg_1746708540
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3439319560AA;
	Thu,  8 May 2025 12:49:00 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D61C119560B3;
	Thu,  8 May 2025 12:48:57 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mtkaczyk@kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 7/7] mdadm/tests: mark 10ddf-fail-readd-readonly broken
Date: Thu,  8 May 2025 20:48:31 +0800
Message-Id: <20250508124831.32742-8-xni@redhat.com>
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

10ddf-fail-readd-readonly fails sometimes. Mark this case broken.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/10ddf-fail-readd-readonly.broken | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 tests/10ddf-fail-readd-readonly.broken

diff --git a/tests/10ddf-fail-readd-readonly.broken b/tests/10ddf-fail-readd-readonly.broken
new file mode 100644
index 000000000000..500343cd9814
--- /dev/null
+++ b/tests/10ddf-fail-readd-readonly.broken
@@ -0,0 +1,22 @@
+Sometimes
+
+This case fails sometimes like:
+mdadm: cannot open MISSING: No such file or directory
+++ return 1
+++ grep -q 'state\[0\] : Optimal, Consistent' /tmp/mdtest-bDoaoB
+++ echo ERROR: member 0 should be optimal in meta data on MISSING
+ERROR: member 0 should be optimal in meta data on MISSING
+++ ret=1
+++ for x in $@
+++ mdadm -E /dev/loop9
+++ rm -f /var/tmp/stderr
+++ case $* in
+++ case $* in
+++ /usr/sbin/mdadm -E /dev/loop9
+++ rv=0
+++ case $* in
+++ cat /var/tmp/stderr
+++ return 0
+++ grep -q 'state\[0\] : Optimal, Consistent' /tmp/mdtest-bDoaoB
+++ echo ERROR: member 0 should be optimal in meta data on /dev/loop9
+ERROR: member 0 should be optimal in meta data on /dev/loop9
-- 
2.32.0 (Apple Git-132)

