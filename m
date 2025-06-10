Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EAD27935F
	for <linux-raid@vger.kernel.org>; Tue, 10 Jun 2025 07:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749540038; cv=none; b=RvHeN2sD0X3n6L5JAfWFPTZiabFoVSJ3lIFNOZDvWGBkz6NIIMeH6pHPwWKxJ9T0+7EhrP6TzrqGPFzmb5xbZ0lHpU9J5MKWdp1f/SRO2hIaevPXREvPPC2zfnEJGDNbuDWYUei+Pq6C43Zlo9WVDuPBfkOQ9mp+PGP4cxFOXhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749540038; c=relaxed/simple;
	bh=r5AjF+h2ijnhSn6df2EGDiTID0XayHugvQ1sGjbAMP8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Y5RzAFzhyJZjU8fVmBDlJnhMMs2s0Lay29/9P3+iYIAIOZ5WgICzRyh+JIhwy8PAg/0+y5lRD8PKA54fCXokE34GteoPE0eFbVc59+IQcLvejL2OxlU8/fHrGyQbIQRxzzPyfkLzSZyejhoKD4USiWXe7Hc4+K8CqAOvrEQkGq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iR72mOAf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iR72mOAf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749540035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tGpIuwpMFE/RTkmK7G/r7KaE0vrGtVxQbyJMW+uO1fg=;
	b=iR72mOAfx9WHOlRsPZlLGwPkn+pfZ98TgbK98HBSFA9Efm6VSzylUy4WChMkpxF4zJNsHH
	FLXW9U9YzZtUWjZztcpgwiXXI+QAIivfAzQGXp4ULhqgD9ysFe0hDUgKfZs0+e4nSwpsqk
	RDrflzB5KFmHYyRn60ZdMzMkrz3+D40=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-602-W9KCJtujP16-IVv9IcZqzg-1; Tue,
 10 Jun 2025 03:20:29 -0400
X-MC-Unique: W9KCJtujP16-IVv9IcZqzg-1
X-Mimecast-MFC-AGG-ID: W9KCJtujP16-IVv9IcZqzg_1749540028
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E86719560B2;
	Tue, 10 Jun 2025 07:20:28 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.23])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A130D19560AB;
	Tue, 10 Jun 2025 07:20:24 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	ncroxon@redhat.com,
	song@kernel.org,
	yukuai1@huaweicloud.com
Subject: [PATCH V5 0/3] md: call del_gendisk in sync way
Date: Tue, 10 Jun 2025 15:20:19 +0800
Message-Id: <20250610072022.98907-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Now del_gendisk is called in a queue work which has a small window
that mdadm --stop command exits but the device node still exists.
It causes trouble in regression tests. This patch set tries to resolve
this problem.

v1: replace MD_DELETED with MD_CLOSING
v2: keep MD_CLOSING
v3: call den_gendisk in mddev_unlock, and remove ->to_remove in stop path
and adjust the order of patches
v4: only remove the codes in stop path.
v5: remove sysfs_remove in md_kobj_release and change EBUSY with ENODEV

Xiao Ni (3):
  md: call del_gendisk in control path
  md: Don't clear MD_CLOSING until mddev is freed
  md: remove/add redundancy group only in level change

 drivers/md/md.c | 49 ++++++++++++++++++++++++++-----------------------
 drivers/md/md.h | 26 ++++++++++++++++++++++++--
 2 files changed, 50 insertions(+), 25 deletions(-)

-- 
2.32.0 (Apple Git-132)

