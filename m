Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176BC421886
	for <linux-raid@vger.kernel.org>; Wed,  4 Feb 2026 14:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217162; cv=none; b=KBv26qpr3A7APJM1TpZRHjtXbDKT2T4BYcgBz5iXANUGZ5OJAIceJfPrRtULUKtwjGfZpNoCNla7nQOr6WFMfPHDIqFgqaA/SRIuUh6moYhOMybbT1pptz04Kc3kkdbxCMrch+93bPzRMVqrOQlRcelI4uy/RIV+58xhxGAiVYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217162; c=relaxed/simple;
	bh=iMT1W3W9pmtB5THV9MkcaHo03v4xioHmk1b2RA18Uvg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qxdZAoU440loqgluOgIgbA02eryz0F/SkH44KJneQ9VkpXSq2ZdMcQESha5mN6rdIGl1M5al94GaJzZM7ANOSceEuuU4E/uegZNBfUbFwVMN+e3MJK3n6JBz6XxNzdstUjGsbdiCSPnJkGrObD3W5i7JOlZlnI3RvypBM7aNbnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KYLLH8Fz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KYLLH8Fz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770217161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XRuB7wkXufuu4Pi73jzHT6zT2ITGxXCg0fjkbuRO6xw=;
	b=KYLLH8FzId9ryWQpV4NqJoz3SsFQUg9lzW0HbGVycDtglbfDikhK0ETyHyMvKoSdidwSp6
	K8CYCX5ezq4GluqGxeufT+SeSVTVnr+838SsHU1NHzQ9cYTdjgIgL/EGMR0wTNJlNy28Z5
	3fPIVghdUrT2Sz0sLHVEd4AVoRhiALg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-54-3tnBYLw6MmCU9oFJG73rXw-1; Wed,
 04 Feb 2026 09:59:17 -0500
X-MC-Unique: 3tnBYLw6MmCU9oFJG73rXw-1
X-Mimecast-MFC-AGG-ID: 3tnBYLw6MmCU9oFJG73rXw_1770217156
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A46481800579;
	Wed,  4 Feb 2026 14:59:16 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.66])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 09CDD19560A3;
	Wed,  4 Feb 2026 14:59:14 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org
Subject: [PATCH RFC 0/3] md/raid1: data corruption with serialization
Date: Wed,  4 Feb 2026 22:58:54 +0800
Message-ID: <20260204145912.9463-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

A data corruption can happen when using serialization for raid1.
Serialization is not enabled by default. But it looks like there
is a data corruption risk if serialization is closed. Because the
lower driver can't guarantee the sequence which io is written first.
So it's possible that different member disks will have different
data for nvme devices. This patch set doesn't open serialization
by default.

Xiao Ni (3):
  md: add return value of mddev_create_serial_pool
  md/raid1: fix data corruption by moving serialization to mddev level
  md/raid1: fix incorrect sector range in serialization

 drivers/md/md-bitmap.c |  28 +++++--
 drivers/md/md.c        | 171 ++++++++++++++---------------------------
 drivers/md/md.h        |  30 ++++----
 drivers/md/raid1.c     |  47 ++++++-----
 4 files changed, 115 insertions(+), 161 deletions(-)

-- 
2.50.1 (Apple Git-155)

