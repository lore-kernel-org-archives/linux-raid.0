Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300A180637
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367915; cv=none; b=usKxufrbzBHEm9G7EmrWNcXXta+RQwnt3DyEUOjNx2DgfuMDzhyl8y4Dr+/evjad6bEQcnYRioNNp0zJjcAnrUP9VJXjIPhx/4cfh9YcKFhT0h4OyPtIooOg6PK0H0iXrB0nMfUs6CkrK6tPl/ZO9WAwaWawhn7A+9i7WVNr7bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367915; c=relaxed/simple;
	bh=KODCxAxyro+C40Wa/RLau9+eeflC9es5Fe0phLgQDgo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BhcT0pY+wSHg/lNFBqZiySGnWGlxw+KjJJ9PMKKT/XoIrZ/5eKaJhz3OTXfye4etrKUw6q5Az9o3ocoqlFp6x6N/Lv0Z3fUb2RTOs8b0R++LSHkdCAIxAFOPcVY9wbKNkYiD8rWtAy32SIJ+yVpgdy0G4GWUAnzDbpAxwRshVMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YEQrgmb9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YEQrgmb9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pv+fONxS6DyWZERO0+2KEJrLBbRXJTHfod+eULmJWIY=;
	b=YEQrgmb9d5qMjhsLxA76W3u1fSgJ53txBrMmQaWMGXRu2a4ayThhub14MfDxZSePTX5HBF
	IygldwhdoJOpz7UrUP1V0FoWA4hgBczpEv/raq7S74sezY+tvuPb3rIV1gYZ9kyRRjZbCP
	61aWm3Hdg0dbPtUIJpWgvvzxDtLSpzU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-SJbOK5G9N5GeL7XCshqxzw-1; Wed, 22 May 2024 04:51:50 -0400
X-MC-Unique: SJbOK5G9N5GeL7XCshqxzw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD2EC8008A4;
	Wed, 22 May 2024 08:51:49 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7DE40C15BB1;
	Wed, 22 May 2024 08:51:47 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	heinzm@redhat.com,
	ncroxon@redhat.com
Subject: [PATCH 17/19] mdadm/tests: 07autodetect.broken can be removed
Date: Wed, 22 May 2024 16:50:54 +0800
Message-Id: <20240522085056.54818-18-xni@redhat.com>
In-Reply-To: <20240522085056.54818-1-xni@redhat.com>
References: <20240522085056.54818-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

07autodetect can run successfully without error in kernel 6.9.0-rc5.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/07autodetect.broken | 5 -----
 1 file changed, 5 deletions(-)
 delete mode 100644 tests/07autodetect.broken

diff --git a/tests/07autodetect.broken b/tests/07autodetect.broken
deleted file mode 100644
index 294954a1f50a..000000000000
--- a/tests/07autodetect.broken
+++ /dev/null
@@ -1,5 +0,0 @@
-always fails
-
-Fails with error:
-
-    ERROR: no resync happening
-- 
2.32.0 (Apple Git-132)

