Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63331125BA
	for <linux-raid@vger.kernel.org>; Mon, 22 Jul 2024 08:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721636273; cv=none; b=SnA95NVhE6roKSsS6ryZOrbTu0JX7wCtiFkx2/Mj9PcUBOG6xiLORxfm0fdSRT+hqqLD5YTDp4mmI2tctk9zIjRgVYdcY6+zigwf9e5nIDFOO9D4lfDv3r7OPJWD6Xp/RrP2hXocyKayzYs04BcVxh1baf9SIPOJfosyanihSMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721636273; c=relaxed/simple;
	bh=PM0QzehkQh+b6dPPxwcPYpnWXYsZxDQodT0QbgA2qW8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=elmmVazHrFDfOXRb4seFtj/S+UsZuXAcMVd37wCkxGRJQocOZpIwsvavViz9aFl6fbbCE6bs7Pz9mqvFKGDpZr4qqMPxlmaimL3QSzAbWBRA81n33Fj2i65oaS/waTc/7yBYdsjFQ3/2Wk2jsfioQYICgVcd4mNbq5da6VrXS4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e3VtqCKJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e3VtqCKJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721636270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rW6yEgL/aSqMvEagagWCqOeO//IS5t2t47oWTvI5xsU=;
	b=e3VtqCKJBKvX/9ib74CZWebf7O1KS2n1Ldj6z3ZKKCC5+5T27jS8fOMrNdWfTAghnI6fef
	dM/xzSlRoAd2/S9L8uxoAN7kq/rQSNpvqLV+rl60KZNxIedoszpncEbByRL7drAbu9opZ6
	/bbOVnUkfD8qJSa5QPRvRHm3ctxtxIc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-130-qRLueVNCNn-Z2Iez5dgS7w-1; Mon,
 22 Jul 2024 04:17:43 -0400
X-MC-Unique: qRLueVNCNn-Z2Iez5dgS7w-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7653D1955D4B;
	Mon, 22 Jul 2024 08:17:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A4E1D195605F;
	Mon, 22 Jul 2024 08:17:39 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH V3 00/14] mdadm: fix coverity issues
Date: Mon, 22 Jul 2024 16:17:22 +0800
Message-Id: <20240722081736.20439-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

V2: replace close with close_fd and use is_fd_valid
V3: Fix errors reported by checkpatch

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

 Grow.c        | 92 +++++++++++++++++++++++++++++++++++++++++----------
 Incremental.c | 20 +++++------
 mdmon.c       | 17 +++++++---
 mdopen.c      |  8 +++--
 mdstat.c      | 12 +++++--
 super0.c      | 10 ++++--
 super1.c      | 32 +++++++++++++-----
 7 files changed, 142 insertions(+), 49 deletions(-)

-- 
2.41.0

