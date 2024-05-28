Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A5D170846
	for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 13:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716904322; cv=none; b=EOMjDmn7inb4OEIMlZDngbK+o5Ko9gagZw2IhfTX4qYft9AljeWeh6qkF4DdY9T/4eZ0hBR5CBdr/fF8Q57X44DrGfTt57tBIKVg9cpXn8Q4PQYXw4J+vIFmZIWfkai43/zYyzvuD40+vnQawN6/2ZcbSq4uBY3e/WLU8bSV8CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716904322; c=relaxed/simple;
	bh=tWRPb6kKwuBB5AS+J+iupelzPyB4NPivJ1oBKDMkLtU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L+RAxlyQ8yOJy9w4AShx38uD9zS7e5pPnHbFjt43zYwB/L0mU6XmO+mnYQ+pqH4kx/hu91OCZ+kh80wb+n9sH3KnSOue7zqlGw1VxQoRGng3Ett63UsIWgizhvu4ZxKiRF5HDfajHfbsQfMBHkiLKkpsoSHNN1BBGpwUh+QAQNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Owx3f5yM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Owx3f5yM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716904319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C5dNAS5W80/1wmXExJiotcEBpRsT2VQezjjX2EyvFpg=;
	b=Owx3f5yMfierMKtUoCDz8E1MeAJU6qeCKhuPKxMfWBFLoqXhVkHsynnTdplEqJwnpvVJQ0
	G6BwSsJow+z4XmqDJ8OwKmJ1ISFlD7C5kryQYAV+MCnXpszu0Z6U9MYHoYBcjp6sL4rP56
	4WghZc3h/xVSN4mB1SSnGTEmipi3Bd0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-330-v7fix5F0M_Sxl3IEE99lhQ-1; Tue, 28 May 2024 09:51:58 -0400
X-MC-Unique: v7fix5F0M_Sxl3IEE99lhQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55B2E8008A4;
	Tue, 28 May 2024 13:51:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E5F3340005B;
	Tue, 28 May 2024 13:51:56 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org
Subject: [PATCH 2/4] mdadm/tests: 04update-uuid
Date: Tue, 28 May 2024 21:51:48 +0800
Message-Id: <20240528135150.26823-3-xni@redhat.com>
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
 tests/04update-uuid | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/04update-uuid b/tests/04update-uuid
index a4409e7895ea..25314ab5c715 100644
--- a/tests/04update-uuid
+++ b/tests/04update-uuid
@@ -25,7 +25,7 @@ mdadm -S /dev/md0
 
 # now if we have a bitmap, that needs updating too.
 rm -f $targetdir/bitmap
-mdadm -CR --assume-clean -b $targetdir/bitmap $md0 -l5 -n3 $dev0 $dev1 $dev2
+yes | mdadm -CR --assume-clean -b $targetdir/bitmap $md0 -l5 -n3 $dev0 $dev1 $dev2
 mdadm -S /dev/md0
 mdadm -A /dev/md0 -b $targetdir/bitmap --update=uuid --uuid=0123456789abcdef:fedcba9876543210 $dev0 $dev1 $dev2
 no_errors
@@ -41,7 +41,7 @@ mdadm -S /dev/md0
 
 # and bitmap for version1
 rm -f $targetdir/bitmap
-mdadm -CR --assume-clean -e1.1 -b $targetdir/bitmap $md0 -l5 -n3 $dev0 $dev1 $dev2
+yes | mdadm -CR --assume-clean -e1.1 -b $targetdir/bitmap $md0 -l5 -n3 $dev0 $dev1 $dev2
 mdadm -S /dev/md0
 mdadm -A /dev/md0 -b $targetdir/bitmap --update=uuid --uuid=0123456789abcdef:fedcba9876543210 $dev0 $dev1 $dev2
 no_errors
-- 
2.32.0 (Apple Git-132)

