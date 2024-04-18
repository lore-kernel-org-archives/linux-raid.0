Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5544E15B96E
	for <linux-raid@vger.kernel.org>; Thu, 18 Apr 2024 10:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713435833; cv=none; b=C8JCJ1RaYJ8rImaDMApvElR1Av0aJX3N9NqKDXPQAAfQLBu/H9TLxN3Hy7uhfGiqm8s1MbrjD8uI5hoi008TaQS4/MYOAtgAn8O3RjSozD2ETUUGkJUdjTAZg7ixi9Xb9+myg696BPQZwdYR2x5O6cB6mmEZninVXTJf824eq0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713435833; c=relaxed/simple;
	bh=b00yJBd5ElmPanFG3WHzFj7GaP2dLeGpghv4xzRl3SE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EGIcefPvF/44P15GtXS9QjslLK9pcYQeEg5HZI5AUOqF1g+Ed3IiLyLHIB7fpEQ7laKiL2WVNSFhQ7B9IsvM6/nghOgfzKWvk9dXFi7ivMUC/ugHIpRQt3aza3gtl3/+6lRqK0yaVelPoRD0P9zWT+fHdUExHk0DBNt87lNgDgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IazeuIZv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IazeuIZv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713435831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1/p056Ze+BtxschA6jQBw1Sy0CfFTKY1t6vtZd7S16s=;
	b=IazeuIZv9slkWhr42bshE4QvukEGvFpAwnmSrdNN6ivR1UmOZjKzlguYlHqsCV2GUZHZO4
	Si/eeERTySr7kMA5+Y4MrvQqUphuBYJNyz/kbtSaBSPjE6rb14A7yunazz9+6tGXzWw3Jo
	dY7TsWJxA41vThSz8Ci8p3OlJVlQF1A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35-Ngil9U9lPKy5FF5IFNIjGw-1; Thu, 18 Apr 2024 06:23:47 -0400
X-MC-Unique: Ngil9U9lPKy5FF5IFNIjGw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3EB7811000;
	Thu, 18 Apr 2024 10:23:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.2])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7E42C1C0654B;
	Thu, 18 Apr 2024 10:23:43 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	song@kernel.org,
	yukuai1@huaweicloud.com,
	ncroxon@redhat.com,
	colyli@suse.de,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 5/5] tests/01raid6integ.broken can be removed
Date: Thu, 18 Apr 2024 18:23:21 +0800
Message-Id: <20240418102321.95384-6-xni@redhat.com>
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

01raid6integ can be run successfully with kernel 6.9.0-rc3.
So remove 01raid6integ.broken.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/01raid6integ.broken | 7 -------
 1 file changed, 7 deletions(-)
 delete mode 100644 tests/01raid6integ.broken

diff --git a/tests/01raid6integ.broken b/tests/01raid6integ.broken
deleted file mode 100644
index 1df735f08c8c..000000000000
--- a/tests/01raid6integ.broken
+++ /dev/null
@@ -1,7 +0,0 @@
-fails infrequently
-
-Fails about 1 in 5 with a sha mismatch:
-
-    8286c2bc045ae2cfe9f8b7ae3a898fa25db6926f /dev/md0 does not match
-    a083a0738b58caab37fd568b91b177035ded37df /dev/md0 with /dev/loop2 and
-    /dev/loop3 missing
-- 
2.32.0 (Apple Git-132)

