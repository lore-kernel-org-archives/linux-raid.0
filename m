Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB8922619
	for <linux-raid@vger.kernel.org>; Fri, 17 Jan 2025 07:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737098151; cv=none; b=eaGz06xWdVQO1j9D2tjemijiY1L+Czl9ED8DaC0RgXSxx7LqQELXQXlbYHI3/8OF0aSpPL2s+RLZbWabog5DYEi+oJ0P+hCNkeWnEnOM19H0ikXJgx2YHnxb3GRpLPm6QqtffzXAoNo3YEXPaJvg1FSLDfoCGU1F9hhztm83qLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737098151; c=relaxed/simple;
	bh=PnseoUYwAGkammnIfF3es8kMKBq/CudUIsUAjn4AmYM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=B8KjQcjSqqEWzfvxJ+5mrL9LWIK2af4Jt9FjFrgeRxFXc/W3uChA8atkFz8bPNqQyTxwwFhd/zkeDG2b1cjjSq2LJAD4cHXFbJUPpp2LXVjuxVrmKOMMX/wXbjojoxHIYzlqLUTge54tGZ6KseoPajtLiSTGrAy/5yO01elqJ2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZVbzktlp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZVbzktlp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737098148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=J11hORq/aPRTRMlTa2qyhFZMSZx2hJaQijyx81w4cCM=;
	b=ZVbzktlpDNNp1Ppizs2q9U4ZccbupwvMBQIfFIO1/XzQvBZvEExJQTFuH2y5uee+ZLiCMh
	YSLfRU5p3vKX/SlQZ+qSoSNUlFUQUXI0sC2mniLl0Ug5L2LjYcON0fG9TUWINCfFwddKCL
	xWNekPqDw/dBuQqiHZhzh3qup6B7vK0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-141-uJlRbnOHP5mPXYA0B5f9vw-1; Fri,
 17 Jan 2025 02:15:46 -0500
X-MC-Unique: uJlRbnOHP5mPXYA0B5f9vw-1
X-Mimecast-MFC-AGG-ID: uJlRbnOHP5mPXYA0B5f9vw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A21801955D52;
	Fri, 17 Jan 2025 07:15:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.10])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2A14F1955F10;
	Fri, 17 Jan 2025 07:15:42 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 1/1] mdadm/raid6check: add xmalloc.h to raid6check.c
Date: Fri, 17 Jan 2025 15:15:40 +0800
Message-Id: <20250117071540.4094-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

It reports building error:
raid6check.c:324:26: error: implicit declaration of function xmalloc

Add xmalloc.h to raid6check.c file to fix this.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 raid6check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/raid6check.c b/raid6check.c
index 99477761c640..95533f7d0836 100644
--- a/raid6check.c
+++ b/raid6check.c
@@ -23,6 +23,7 @@
  */
 
 #include "mdadm.h"
+#include "xmalloc.h"
 #include <stdint.h>
 #include <sys/mman.h>
 
-- 
2.32.0 (Apple Git-132)

