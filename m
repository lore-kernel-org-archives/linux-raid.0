Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D9F44C86
	for <linux-raid@vger.kernel.org>; Wed, 28 Aug 2024 02:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724811172; cv=none; b=b02kDLzcqM7qZPVDU+J5q1OZlq5FFSjhOP3W1Ie/D5AUKHxsE9pw16OkJS+jo/QTJxx3wPNN+0YzSGzqbhp6NGm8SFJ4Wi6VqaUPirBBmQMhlM3xZr9agOc6WywQ1qiZSk1yk13Y/7BJUAFQq8jTXdzix14YjwkSjyfpAgX9+ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724811172; c=relaxed/simple;
	bh=8PqiUkFVBO/ty1x89DfvANMtc9MNw1bLGJfMq5PzzOc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ag+if3EUUQzC/I3GilmdoIvRulH86CJ5xq3Vs6y3WhOgrXTYcszT5zerofFdLkPeTN1i4xElyqa7yr+a0c+2QzHRti5nJwDbGopTBVOykC8tsGxRyhXrYgdpeeSQvtvtZoxIg+qeivGjZVyKf5bV1tBbpw793dTooH30SZLeOoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I5XDpCIl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I5XDpCIl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724811170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1hTP7jiUhayaW8uExnNuDO1aX1pMU5eDC1T6UohjVIo=;
	b=I5XDpCIlXdGZSUheaQUAK6RSb0qUzWLqR1yTTHUxkDCsNAvfnc6GaRsREIidDX9JSrhgBM
	61fAFiTFwXNDkeJlt5DEShZ/zlTBpaYB3b6IIFQdJfKfE2ixZu1JpXU6xF2RtGme31xjPV
	OBYHkQ5/RN3fPPyPmcZtJWE5DvEgFXI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-187-sEBfEvjAN6qpSR306id-bA-1; Tue,
 27 Aug 2024 22:12:49 -0400
X-MC-Unique: sEBfEvjAN6qpSR306id-bA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 372D11955D48;
	Wed, 28 Aug 2024 02:12:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.24])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 665473002240;
	Wed, 28 Aug 2024 02:12:44 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 08/10] mdadm/tests: 07testreshape5 fix
Date: Wed, 28 Aug 2024 10:11:48 +0800
Message-Id: <20240828021150.63240-9-xni@redhat.com>
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

