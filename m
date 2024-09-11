Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A25154BE4
	for <linux-raid@vger.kernel.org>; Wed, 11 Sep 2024 08:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726044886; cv=none; b=rhcAaiiLE2RsGkq0WjOUwyoRNpqnBlLn1erLofX9gw5zXNSxChChfWSNsl67+fa+99LB4CGI1PBNmBAPxULoPEYUnO4/P/oD/RQCIqoEcdcGXhgx1pkSplrko5on75824BzNuxVxSl5qA78n5nvaXEumoCqmPdIFdEKlcPTaAes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726044886; c=relaxed/simple;
	bh=FXrlms6jQUKf3yWcoeZCUxSoajFYlIypurwicWKa8VE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sZEpF+ftzJZO28sq82EOHmPDDxit7MjU8rASw9aWUAd56pRMUTuW7jSaQYV58vABgjaPtgmwJvGPTJlMJleZqTpn5pDSp86Jx0v74r4R5mxkAVKtpGwLIGj54VzL7Sljphg8Z3j5SzRqDMo+h7inoAHcDps2Bh684To1+4pGan4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ku3SOryD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ku3SOryD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726044882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1p5jNtQxGYcPfzZ0yrf4SsgYRX9L2jqCG7D3pa6J24E=;
	b=Ku3SOryDm11mvfOLVS4l5jY2HhY1ls5f3swxLv101Kv+WuJNf/h5GChvX6e7n2BjrOHKyL
	tskGu0Nn0FSTLar7Izlb09VZsF1LiQf4Qe5vGLCeJr+hK976loNVIkQPWFmAILDnk+aLgC
	yESu9URMLaZ0cws/tBL7etk4cWBzQlQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-265-AtBK0mIjNHW5KsDOxKM5dg-1; Wed,
 11 Sep 2024 04:54:39 -0400
X-MC-Unique: AtBK0mIjNHW5KsDOxKM5dg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C9C119560AD;
	Wed, 11 Sep 2024 08:54:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.25])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 073F61956086;
	Wed, 11 Sep 2024 08:54:35 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 00/10] mdadm tests fix
Date: Wed, 11 Sep 2024 16:54:22 +0800
Message-Id: <20240911085432.37828-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

This is the fourth patch set which enhance/fix mdadm regression tests.

v2: fix problems for the first patches

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

 Grow.c                       | 39 +++++++++++++++++++++++++------
 Manage.c                     |  8 ++++---
 dev/null                     |  0
 tests/05r6tor0               |  4 ++++
 tests/07changelevels         | 27 ++++++++++------------
 tests/07changelevels.broken  |  9 --------
 tests/07reshape5intr.broken  | 45 ------------------------------------
 tests/07testreshape5         |  1 +
 tests/07testreshape5.broken  | 12 ----------
 tests/09imsm-assemble.broken |  6 -----
 tests/func.sh                |  4 ++++
 11 files changed, 58 insertions(+), 97 deletions(-)
 create mode 100644 dev/null
 delete mode 100644 tests/07changelevels.broken
 delete mode 100644 tests/07reshape5intr.broken
 delete mode 100644 tests/07testreshape5.broken
 delete mode 100644 tests/09imsm-assemble.broken

-- 
2.32.0 (Apple Git-132)

