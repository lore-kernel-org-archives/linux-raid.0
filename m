Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7B020309
	for <linux-raid@vger.kernel.org>; Wed, 28 Aug 2024 02:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724811138; cv=none; b=Xz6bafJjgCVfrP4dN0T/veXLUEcGrYkRFaRKlaVwo8k32fcRlMeLlVv9MFBMTB/8WH+LDCFQWf36k60qwkUhnc/GF7IIuDsTHBrxi/K6lpec1pGJ39mWhkf3iWUHdI0ys8ByQoguuBi+1mvTfmamBESreU6YvjI+GnSKWnRaL1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724811138; c=relaxed/simple;
	bh=lJsHzT6lmXsOze73iDwm1hd6IEOCv+Cu/GepG83IpXU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PWEDYTuUL3ouwcleHrkWBxEURrg3qRZumbUMj2dzJtWBwpz0UEkbyug1zyqPk/rhHQfq+W9mA/VNu3bvLXC0zEVpQTLYjOr9P3MDOyTQUu/4IqiRyI+ItyP1DMfR8fdbzGUlydZgXTlEeVeoTIv1k2efqX9/SsWQL9yzAs41VnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VKG5mebC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VKG5mebC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724811136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kVFzHv9fjuCfBLkSREBFJL/snRg6nvfPE6x6qaLqvYk=;
	b=VKG5mebCRuARThFns8DMGyEODpYAe0zPjScngQiHBY4/I6qmZ83Afww4tq0KQwPr56zvoV
	2asgGUNxK8w30eXgfI1iS/sK6y8VQU6Lnot/MX2UFmaddHIr47Ot0lzpJtZ8YrMGU4yYVj
	ILai8waUQwZhhTf1xgyx7xmnS99OUqk=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-578-fHjipwSWMCKW5Rn8N36HdQ-1; Tue,
 27 Aug 2024 22:12:12 -0400
X-MC-Unique: fHjipwSWMCKW5Rn8N36HdQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95B771955D56;
	Wed, 28 Aug 2024 02:12:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.24])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 29D953001FF9;
	Wed, 28 Aug 2024 02:12:07 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 00/10] mdadm tests fix
Date: Wed, 28 Aug 2024 10:11:40 +0800
Message-Id: <20240828021150.63240-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

This is the fourth patch set which enhance/fix mdadm regression tests.

Xiao Ni (10):
  mdadm/Grow: Update new level when starting reshape
  mdadm/Grow: Update reshape_progress to need_back after reshape
    finishes
  mdadm/Grow: Can't open raid when running --grow --continue
  mdadm/Grow: sleep a while after removing disk in impose_level
  mdadm/tests: wait until level changes
  mdadm/tests: 07changelevels fix
  mdadm/tests: Remove 07reshape5intr.broken
  mdadm/tests: 07testreshape5 fix
  mdadm/tests: remove 09imsm-assemble.broken
  mdadm/Manage: record errno

 Grow.c                       | 31 +++++++++++++++++++------
 Manage.c                     |  8 ++++---
 tests/05r6tor0               |  4 ++++
 tests/07changelevels         | 27 ++++++++++------------
 tests/07changelevels.broken  |  9 --------
 tests/07reshape5intr.broken  | 45 ------------------------------------
 tests/07testreshape5         |  1 +
 tests/07testreshape5.broken  | 12 ----------
 tests/09imsm-assemble.broken |  6 -----
 tests/func.sh                |  4 ++++
 10 files changed, 50 insertions(+), 97 deletions(-)
 delete mode 100644 tests/07changelevels.broken
 delete mode 100644 tests/07reshape5intr.broken
 delete mode 100644 tests/07testreshape5.broken
 delete mode 100644 tests/09imsm-assemble.broken

-- 
2.32.0 (Apple Git-132)

