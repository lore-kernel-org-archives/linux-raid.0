Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8B4170846
	for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 13:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716904325; cv=none; b=NyZYR0r8TqKWW/nob4edANwCky6wnEddsrc+i3rha87iaOB/DIJNjib3pJBN525MpQ9BOMtTziu+gKS8YCxUGti8tCqXBSwBh90LTa1VGx/qD1rKYHyAVNmBQbZckC/3GKmVlf5z/doI1cxbUU7AVpT0DefThvl+x4V7E8xy2DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716904325; c=relaxed/simple;
	bh=uhqdTgb1KeuJ1VleWoxvWSO0Qr1TNd24iN1EQbK4sx0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I4VnAx11YQW0w6TLViGsuLyrqOTr4ITxqZPkxrHxfB3LRc9DnEz4jTkN+w16C28slDMBaST9dG9lcqWfM+4dQ8Os9mnu2G+guLibBLZqqn2raFwOdYJaAK7Ep/Jk+QnoIB6RrN8pZFAwROOMZDvdJMFUAG3CWwLv2GUqnktXUWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HegV8HOe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HegV8HOe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716904323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wGCm6e3MswLsQnzcPEncwhzCDBaLKv+yoGXlc2a3xI4=;
	b=HegV8HOeyrQsvlyW7ozJgFfyquuPI949sEx0Pt9ad4IX1u3vYiLEXmfwn+fQS0Le0V7F1m
	hhM0ptqXSlaSAoLxhRB04shuDguW6yMxeZaY9ppiwhATX8+qLSbrQSWtoAFN7lP25XThVJ
	RwbuQNthO7C0wLwp8+tIxHwlHI8wvsg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-542-4PESSGxXPXawB3uqdzRR2Q-1; Tue, 28 May 2024 09:52:00 -0400
X-MC-Unique: 4PESSGxXPXawB3uqdzRR2Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 738C88025FC;
	Tue, 28 May 2024 13:52:00 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 06473400E89;
	Tue, 28 May 2024 13:51:58 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org
Subject: [PATCH 3/4] mdadm/tests: 05r1-re-add-nosuper
Date: Tue, 28 May 2024 21:51:49 +0800
Message-Id: <20240528135150.26823-4-xni@redhat.com>
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

Patch 50b100768a11('mdadm: deprecate bitmap custom file') needs to confirm when
creating raid device with bitmap file.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/05r1-re-add-nosuper | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/05r1-re-add-nosuper b/tests/05r1-re-add-nosuper
index 058d602d1623..7d41fd7be5fc 100644
--- a/tests/05r1-re-add-nosuper
+++ b/tests/05r1-re-add-nosuper
@@ -6,7 +6,7 @@
 #
 bmf=$targetdir/bitmap2
 rm -f $bmf
-mdadm -B $md0 -l1 -n2 -b$bmf -d1 $dev1 $dev2
+yes | mdadm -B $md0 -l1 -n2 -b$bmf -d1 $dev1 $dev2
 check resync
 check wait
 testdev $md0 1 $size 1
-- 
2.32.0 (Apple Git-132)

