Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9508415CD67
	for <linux-raid@vger.kernel.org>; Thu, 18 Apr 2024 10:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713435830; cv=none; b=gEFaC9tKR1cth9/FNF8gEfH1moLZ5Ap2Ea//n2iTHw30hCJQkv0AsxKoIUoto2IwDREndmqv43te59y2APsV/SEPjK64dV54SV1sy79yKW7q+s+msGqznwX+uzF6xu5frkLEkfru0OyIKPf43gF8tO+zPgbQ1mHCKXav679+ztE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713435830; c=relaxed/simple;
	bh=YPw4zxaLkMlJKxM6W7mzdwjE0Na4uvx620o7kqBJfoo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iDvqpwYfvad5h10SoUz1N2wCOFCA7DvcGstfPrU/RJ2G1VGwvFEGoavSxVUKiW8n24xtX3gdAO/uglCRgCWxBDqeK+Ft8h5kcMESmrNtnRCdBt0qG6ttqihPWfj35tVy+OZdvctb8FIXDX0OjXjF6mxvP11DeYMvQfWQv08NoNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d+dDKpEs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d+dDKpEs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713435827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UABJySfmBfQvvblXuCekzkTrTt6OtcK9CykQLcGZD+Q=;
	b=d+dDKpEsWMnb7snoJ1jLvJZQu2pdCgbNU85Nv/IpPx6XMn9bep7jcDZisWjhja3TFn+iVN
	GxIlQN2QzlYqG+GtHEJ9CqpwWMhrO+SxVFiy4qBPyV+UrzczNIPdLySXN25jQTiOa/zeEy
	oJw7EJ9DWgZVhBvsRqOB6BOu0ZEBfCA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-662-18OUbN60O8G0kZKGGrARuA-1; Thu,
 18 Apr 2024 06:23:43 -0400
X-MC-Unique: 18OUbN60O8G0kZKGGrARuA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B93601C3F0E3;
	Thu, 18 Apr 2024 10:23:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.2])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B3BF01C060D0;
	Thu, 18 Apr 2024 10:23:39 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	song@kernel.org,
	yukuai1@huaweicloud.com,
	ncroxon@redhat.com,
	colyli@suse.de,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 4/5] tests/01r5integ.broken
Date: Thu, 18 Apr 2024 18:23:20 +0800
Message-Id: <20240418102321.95384-5-xni@redhat.com>
In-Reply-To: <20240418102321.95384-1-xni@redhat.com>
References: <20240418102321.95384-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

01r5integ can be run successfully 152 times without error with
kernel 6.9.0-rc4 and mdadm - v4.3-51-g52bead95. So remove this
one broken case.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/01r5integ.broken | 7 -------
 1 file changed, 7 deletions(-)
 delete mode 100644 tests/01r5integ.broken

diff --git a/tests/01r5integ.broken b/tests/01r5integ.broken
deleted file mode 100644
index 207376372243..000000000000
--- a/tests/01r5integ.broken
+++ /dev/null
@@ -1,7 +0,0 @@
-fails rarely
-
-Fails about 1 in every 30 runs with a sha mismatch error:
-
-    c49ab26e1b01def7874af9b8a6d6d0c29fdfafe6 /dev/md0 does not match
-    15dc2f73262f811ada53c65e505ceec9cf025cb9 /dev/md0 with /dev/loop3
-    missing
-- 
2.32.0 (Apple Git-132)

