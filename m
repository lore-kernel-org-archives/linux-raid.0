Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8EF45C1C
	for <linux-raid@vger.kernel.org>; Wed, 28 Aug 2024 02:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724811178; cv=none; b=irS/L0j8MF2I5r7GAXFkk6v5aoPoJH1pvMO7tUTIkJb3F7+qlepnHJXlnaSSdj3GV3iKaWGhG+ij6+nvr9Tj7xnmHXWlGkgregsl10rbYgWVyE+7BbjVBrH3Ghp1e04du5cSOZzl1bB6CA0Jb+aWyOazYFaJ/HKuL2kDhtGXM7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724811178; c=relaxed/simple;
	bh=vKFkNuEedEjjKQPRKZIOznDQ6HPCvciNpWM/fv8O0lE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z5/1+g21uY+6EW9rPlxer17gIen/I9gOmPkNYq2OjdsCnn6UCKP+DZwjx5IusxS3eg7jNz2OdAHYxoZHLDnp326X/Ui83SupnnEkTL6TGzctzEFMqpoXCQ6KrraPo3gJTMGcjjZXWhXTHIpiBZvJzEoZww4j7AVya33yqrTZ7lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gKPwvCJ1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gKPwvCJ1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724811175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wO51OinyxmL8YM6r78uSv88XCuoLuUrLG9NsHQWm1ZM=;
	b=gKPwvCJ1GXdyidhsLARs+FvZyW8oN+Fdbv1w40Msseajrx71vZ00ETm5hpZEGS3tTEFJl/
	DuLv/bgb8voXs6SHuZtFVDAukIQ4aTyCaBriQyKUXWETtBJIPz4KlFI8dqaxC5LMey5tbf
	ij6O9it7yLUAHvLJhcqdRbLYnEnVbxI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-134--rErXOyaPF6-4EK4-KzOig-1; Tue,
 27 Aug 2024 22:12:54 -0400
X-MC-Unique: -rErXOyaPF6-4EK4-KzOig-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4CABD1955F3D;
	Wed, 28 Aug 2024 02:12:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.24])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 28DF03001FF9;
	Wed, 28 Aug 2024 02:12:48 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 09/10] mdadm/tests: remove 09imsm-assemble.broken
Date: Wed, 28 Aug 2024 10:11:49 +0800
Message-Id: <20240828021150.63240-10-xni@redhat.com>
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

