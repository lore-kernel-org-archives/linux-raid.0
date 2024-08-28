Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030C7433A0
	for <linux-raid@vger.kernel.org>; Wed, 28 Aug 2024 02:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724811160; cv=none; b=XJPA0VM+zKFWNhBTuw8OoJ2VoIHwTKrCxzIX8wdpoR2D6cRnWkhfVqLZKLvSRfrIQ04kYHDm9IhJ5eC1GHLl1zd5ginN51kYzGHDiAUxqyqY7dvp+sDKVGk+R05sV8XloZtsiNJ/6K9PsqIY8peO7TN2nYgqYXuRA1pN0UxiNYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724811160; c=relaxed/simple;
	bh=q3mdBdhvEPP3XCQSyxUjsSgFizaFpUqhVjHpdv/xslg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u5Z7ANPYKdy/Ac4J46pA6jPAXpkQYN9WIJT5XSIjidksBOgHECCiknVQaN+xCg4oQMXiGTW/gZsGcG4ZDQHyuf4eEuh+vjusUfS3Pvu7/qxi1Vvr9yaG+Jm9Ia7mLpBO1czpvPv7n6aYCXp/ff68aY8HkK5YrNZM/ssx6SFOw+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fuB/uDi2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fuB/uDi2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724811158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a+1VjOfx8xpJDgToWYqTQnaqNxwgZ+emJVaCvXR4SzY=;
	b=fuB/uDi2+NAvSNaluVITk3Jjg7m9C9yuZeB+1VIBUwDm7utHkk4mgG4I4X5AQh4j/ywEJA
	AVyOZwiHgbvwLaEMQgL9coFUEiMnFddKgS6FmpipBdE+0ytLGtQN3wyC5CPnGCadrdLGKR
	YZGQCmzuO5CkNMAhGAUiE5Qydkv3y/U=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-tLNErWC3PwS9EWQsI0k8SQ-1; Tue,
 27 Aug 2024 22:12:36 -0400
X-MC-Unique: tLNErWC3PwS9EWQsI0k8SQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E66E1955D4C;
	Wed, 28 Aug 2024 02:12:35 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.24])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9B33C3001FF9;
	Wed, 28 Aug 2024 02:12:32 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 05/10] mdadm/tests: wait until level changes
Date: Wed, 28 Aug 2024 10:11:45 +0800
Message-Id: <20240828021150.63240-6-xni@redhat.com>
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

check wait waits reshape finishes, but it doesn't wait level changes.
The level change happens in a forked child progress. So we need to
search the child progress and monitor it.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/05r6tor0 | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/05r6tor0 b/tests/05r6tor0
index 2fd51f2ea4bb..b2685b721c2e 100644
--- a/tests/05r6tor0
+++ b/tests/05r6tor0
@@ -13,6 +13,10 @@ check raid5
 testdev $md0 3 19456 512
 mdadm -G $md0 -l0
 check wait; sleep 1
+while ps auxf | grep "mdadm -G" | grep -v grep
+do
+        sleep 1
+done
 check raid0
 testdev $md0 3 19456 512
 mdadm -G $md0 -l5 --add $dev3 $dev4
-- 
2.32.0 (Apple Git-132)

