Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E90225D7
	for <linux-raid@vger.kernel.org>; Fri, 26 Jul 2024 07:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721978072; cv=none; b=D5pcItCExNycn8jRTfnVABcwaz2gbKmDKtfuG4IlJRtFV9c+4+uLQAo46pFGNNKWdPo3s+F+3sGrnfYGM06v4opF3fdLRAJhxSW0s03AgdGpC9RBTD6VWZ7iSIm0syZDpEyddhN+as6bUww4v/GRDAB/pa+sIUuzkXm3IxlcWVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721978072; c=relaxed/simple;
	bh=WKKKGdF+XAKAHk2Ggpn9LL/fxwUMOQBYAxC/wZxF10k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jKAFhlzP7imAmWI7orEghS2AJuEeD/8fnN0GU2h+F03epXboRqfwtODq5W7Szs+WFTKm/2M//duThv5URzjucTxM7EykHiY60MYsXJ2I0UmIbQpVgyWfTSFoBcd00PSLxdo+0E/TyIhFQZmwHcxe4U0aIo/hS0/PWlAJgOUz6Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GPGRinvS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GPGRinvS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721978069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gxHzQerAtoi1+CaIlVn78rUVE3DgRgj1HMtAJY2vAes=;
	b=GPGRinvSTpz1iVTpZxAiYtzRbCPzTaE/z/97rVfkiyz0ZOkNdlGvgCOCDDuvOXA0atTaKk
	v4BfntSfxVfvOGiiiBCFaqRc8SW1r53wMMxpi7zA1k2RWEdhGMta+H3enFl7+6d2t50cbA
	sribvR2wkXG8dIQMDCGk9D18VlH2w9I=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-70-mqJ7UofSPQGIVkfPbgkSDA-1; Fri,
 26 Jul 2024 03:14:23 -0400
X-MC-Unique: mqJ7UofSPQGIVkfPbgkSDA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4FC271955D4A;
	Fri, 26 Jul 2024 07:14:22 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D0CA119560AE;
	Fri, 26 Jul 2024 07:14:19 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH V4 00/14] mdadm: fix coverity issues
Date: Fri, 26 Jul 2024 15:14:02 +0800
Message-Id: <20240726071416.36759-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

V2: replace close with close_fd and use is_fd_valid
V3: Fix errors reported by checkpatch
V4:
don't need check fd is valid before close_fd
replace strcat with snprintf
replace dev_name with dev_path_name

Xiao Ni (14):
  mdadm/Grow: fix coverity issue CHECKED_RETURN
  mdadm/Grow: fix coverity issue RESOURCE_LEAK
  mdadm/Grow: fix coverity issue STRING_OVERFLOW
  mdadm/Incremental: fix coverity issues.
  mdadm/mdmon: fix coverity issue CHECKED_RETURN
  mdadm/mdmon: fix coverity issue RESOURCE_LEAK
  mdadm/mdopen: fix coverity issue CHECKED_RETURN
  mdadm/mdopen: fix coverity issue STRING_OVERFLOW
  mdadm/mdstat: fix coverity issue CHECKED_RETURN
  mdadm/super0: fix coverity issue CHECKED_RETURN and EVALUATION_ORDER
  mdadm/super1: fix coverity issue CHECKED_RETURN
  mdadm/super1: fix coverity issue DEADCODE
  mdadm/super1: fix coverity issue EVALUATION_ORDER
  mdadm/super1: fix coverity issue RESOURCE_LEAK

 Grow.c        | 87 ++++++++++++++++++++++++++++++++++++++++-----------
 Incremental.c | 20 ++++++------
 mdmon.c       | 20 +++++++++---
 mdopen.c      |  8 +++--
 mdstat.c      | 12 +++++--
 super0.c      | 10 ++++--
 super1.c      | 32 ++++++++++++++-----
 7 files changed, 139 insertions(+), 50 deletions(-)

-- 
2.32.0 (Apple Git-132)

