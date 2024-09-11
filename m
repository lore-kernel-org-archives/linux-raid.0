Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26091714A1
	for <linux-raid@vger.kernel.org>; Wed, 11 Sep 2024 08:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726044916; cv=none; b=lFpkERdafvqVLZuMfkjJuPSIrjQvUNsKK1KZH6V7hb2c1WJfzM3f3gSWWM1kp+Or60Kziecuk9qgFSyq0oaBSs1dOIXV0SJvqZ+XTTDfihitPbjWbS06wenz/2bxpEQtAg0vxzi5tSBfnL1WmJS8vymmZTjwKFKbOIXjlqhvXb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726044916; c=relaxed/simple;
	bh=vKFkNuEedEjjKQPRKZIOznDQ6HPCvciNpWM/fv8O0lE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KDXT9qhaHN8XUBbKvEbWwowt+YbE7o1TGVLjlN00v9Qd0450+9DsaUfwGbIEwzHGXhc1glrbHuWNXnwhw2sFKas7XiGOR2xxgwLFhhB4K14sv6VK6rFpLm4h3patnSji6GKVKqpxDbWFrwLb7rqGMbIU8pPspDXh3ynFNWOrmAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ahV2asOh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ahV2asOh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726044913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wO51OinyxmL8YM6r78uSv88XCuoLuUrLG9NsHQWm1ZM=;
	b=ahV2asOhWwZSUvQzUmvMiI/1TxbHkJcw3H7Qk+6piEiw8abOZJ9aGnStmj3rruM9YerGg0
	bh5xw7JdHHFs1R5HD7PR0P9+aEbik92SPx0TMiw6FpDHhaza/YttZkPE9maHTPlVbkxtVl
	gYBH3IGNmWte8CCh3Q/o0s9vUlbqBwQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-zvFk1B6tMnu3QM1k36XoQA-1; Wed,
 11 Sep 2024 04:55:10 -0400
X-MC-Unique: zvFk1B6tMnu3QM1k36XoQA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B38951955DC1;
	Wed, 11 Sep 2024 08:55:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.25])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 10D7B1956086;
	Wed, 11 Sep 2024 08:55:06 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 09/10] mdadm/tests: remove 09imsm-assemble.broken
Date: Wed, 11 Sep 2024 16:54:31 +0800
Message-Id: <20240911085432.37828-10-xni@redhat.com>
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

09imsm-assemble can run successfully.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/09imsm-assemble.broken | 6 ------
 1 file changed, 6 deletions(-)
 delete mode 100644 tests/09imsm-assemble.broken

diff --git a/tests/09imsm-assemble.broken b/tests/09imsm-assemble.broken
index a6d4d5cf911b..000000000000
--- a/tests/09imsm-assemble.broken
+++ /dev/null
@@ -1,6 +0,0 @@
-fails infrequently
-
-Fails roughly 1 in 10 runs with errors:
-
-    mdadm: /dev/loop2 is still in use, cannot remove.
-    /dev/loop2 removal from /dev/md/container should have succeeded
-- 
2.32.0 (Apple Git-132)

