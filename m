Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EA717085A
	for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 13:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716904328; cv=none; b=MrbjLDVTCLY2mwsdfiCrxruP/eYWkU/BayfknpT/r026/SgpLLIVqgZBXh5o/sPbE21YGsWSTrg7s+2rKJ9Ht2hsV/tLsBe9mLlqJmT/B9X7IVKnCAhgmo4FAxw+8v4LP6/nENDlax4PSJ2/a+o8froBetoAW8PuQ210c4yn6/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716904328; c=relaxed/simple;
	bh=uD7/azniFaS0ib6QYlCshC8A1sx51IVUEmypsvKWeFA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Dpxy+3R67zwmSMNkzXLkRXC9awN/uuB9bjjZeBW7rcQsRY/LvYAlsqEq71cUWdmjwLEiQkE+JkSJvdIvdD0lsS6NjjQ4y8HZycieFLkITzP0pDmpvGFk8pgONex6kSG6ylabZhDNxzBBDflQn/MDpSm5/LH3lnMV40neLasIr3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dhXqLSKo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dhXqLSKo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716904326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6QKm/tcpcIHkaAFytzjNc1Gn9MZzZy0u0pPg9exlKfc=;
	b=dhXqLSKoiU8p7zwfBWVQLFL4KHo0y/tu1FXrHVPkx7xKpwgRvjAeGgLqbyWKdOsug0BoKB
	pONU3BBICgMFn4kYmDoIl/aAMyac2sPX47FUdbs8SaEYDvhPwS0wZgF22t9gWQpf4q474H
	CWBp/DYErnBScXYD8E+8kGXMwtZ/rR0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-i1TCZ-AVPQigunjbbuY1KA-1; Tue, 28 May 2024 09:52:02 -0400
X-MC-Unique: i1TCZ-AVPQigunjbbuY1KA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91A11800281;
	Tue, 28 May 2024 13:52:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 25427492BC6;
	Tue, 28 May 2024 13:52:00 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org
Subject: [PATCH 4/4] mdadm/tests: remove strace test
Date: Tue, 28 May 2024 21:51:50 +0800
Message-Id: <20240528135150.26823-5-xni@redhat.com>
In-Reply-To: <20240528135150.26823-1-xni@redhat.com>
References: <20240528135150.26823-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Some tests will fail if the test env doesn't have strace
commands. So remove the dependency.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/07revert-grow    | 2 +-
 tests/07revert-inplace | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/07revert-grow b/tests/07revert-grow
index c8c4e855f628..333483dc0478 100644
--- a/tests/07revert-grow
+++ b/tests/07revert-grow
@@ -43,7 +43,7 @@ testdev $md0 2 $mdsize1 512
 mdadm -G $md0 -n 5
 sleep 3
 mdadm -S $md0
-strace -o /tmp/str ./mdadm -A $md0 --update=revert-reshape $devlist4
+mdadm -A $md0 --update=revert-reshape $devlist4
 check wait
 check raid10
 testdev $md0 2 $mdsize1 512
diff --git a/tests/07revert-inplace b/tests/07revert-inplace
index a73eb977374d..776324ac22fb 100644
--- a/tests/07revert-inplace
+++ b/tests/07revert-inplace
@@ -37,7 +37,7 @@ testdev $md0 3 $mdsize1 64
 mdadm -G $md0 -c 32
 sleep 2
 mdadm -S $md0
-strace -o /tmp/str ./mdadm -A $md0 --update=revert-reshape $devlist5
+mdadm -A $md0 --update=revert-reshape $devlist5
 check wait
 check raid10
 testdev $md0 3 $mdsize1 64
-- 
2.32.0 (Apple Git-132)

