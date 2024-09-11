Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA3A17F500
	for <linux-raid@vger.kernel.org>; Wed, 11 Sep 2024 08:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726044913; cv=none; b=TOsrl3rFcJQBBcLOVhml9sv4Wy05K/CdUwr8MIrwp/A1dbL3lTTbBFQR8nMtLpq/B5YDljB6mn/xLHThkNVSI9dh+NrKFRWzaFwbtBsu/sFAcBxlAbSjyMUMhej4GE8iQ1g61h4s4WHdLpkBhg7UTxzUGKbbIm4W5tWqKK49t+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726044913; c=relaxed/simple;
	bh=8PqiUkFVBO/ty1x89DfvANMtc9MNw1bLGJfMq5PzzOc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KxJAQ38SKDNKolvB6kpyUb/arXEzugZw6DG6iHTdz32unSfx4qnwt9ldvWRYVtjNMX/zQXBRrpItBKk7QUq3a48BzOOvLen3qrS+0nvxrMgUU72TT1x7D522OYbOrd7kiGbDnU1aYthmtp9f+t542sRJgtEr62XViw0U6PTvkuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ReQ6g4Cu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ReQ6g4Cu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726044910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1hTP7jiUhayaW8uExnNuDO1aX1pMU5eDC1T6UohjVIo=;
	b=ReQ6g4CubCIUxIM3siDa5X0SBH6hmJErBUSbCcibGwqJyvRYkIOO9LsqK45aE6JIeQHg+x
	YYnGLWNTwE8NiTpOdHyvGv1oHqTGypW/BohTXkDlrdu5z6oV8eqJQR2gODlx1Jfi1lAHXv
	fAcIppfx3D2n5fn+sKeGf3NZAY3J8sg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-371-b65YinnBPG6Laa2r2rD2lQ-1; Wed,
 11 Sep 2024 04:55:07 -0400
X-MC-Unique: b65YinnBPG6Laa2r2rD2lQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 390951958B1D;
	Wed, 11 Sep 2024 08:55:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.25])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 909C01956086;
	Wed, 11 Sep 2024 08:55:03 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 08/10] mdadm/tests: 07testreshape5 fix
Date: Wed, 11 Sep 2024 16:54:30 +0800
Message-Id: <20240911085432.37828-9-xni@redhat.com>
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

Init dir to avoid test failure.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/07testreshape5        |  1 +
 tests/07testreshape5.broken | 12 ------------
 2 files changed, 1 insertion(+), 12 deletions(-)
 delete mode 100644 tests/07testreshape5.broken

diff --git a/tests/07testreshape5 b/tests/07testreshape5
index 0e1f25f98bc8..d90fd15e0e61 100644
--- a/tests/07testreshape5
+++ b/tests/07testreshape5
@@ -4,6 +4,7 @@
 # kernel md code to move data into and out of variously
 # shaped md arrays.
 set -x
+dir="."
 layouts=(la ra ls rs)
 for level in 5 6
 do
diff --git a/tests/07testreshape5.broken b/tests/07testreshape5.broken
index a8ce03e491b3..000000000000
--- a/tests/07testreshape5.broken
+++ /dev/null
@@ -1,12 +0,0 @@
-always fails
-
-Test seems to run 'test_stripe' at $dir directory, but $dir is never
-set. If $dir is adjusted to $PWD, the test still fails with:
-
-    mdadm: /dev/loop2 is not suitable for this array.
-    mdadm: create aborted
-    ++ return 1
-    ++ cmp -s -n 8192 /dev/md0 /tmp/RandFile
-    ++ echo cmp failed
-    cmp failed
-    ++ exit 2
-- 
2.32.0 (Apple Git-132)

