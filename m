Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDD513E41A
	for <linux-raid@vger.kernel.org>; Tue,  3 Jun 2025 05:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748928036; cv=none; b=Bp2/mFmABc14aUvHFwFgm9/Lx8ksUpBxbGc+E8SMJtFe/yR8y1TUL1S9X5ajahTOEKJMvjBThvMObXfeEtVxGWAM8d5ZmFuWqRBpdMhXL3oznJ5Dld4Z7bMLeq2a8kmN916k0Y//T4ID5wvdDqE9J635Bga4u94OkCPZ51apFck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748928036; c=relaxed/simple;
	bh=NagPVKyQvq6o93T1t3xNKSAfW2d/5yQFepMJCZXgxvU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fk4BGuUgYi9qJWJvYCG163TDesNJxs702CBTx3EJ4Qu+wZgnih4R3FLIMmWjkVilu3Y3HOZhqjBGDxRpzJjGazWeaqvGpvMivLoItVStjXzg6qK1awk65EPJOL5IUcU9aiQEYbCcwriVk10e8LaFPwXgabncVX8XgS2QOK+kZGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Od2POY6t; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Od2POY6t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748928033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RZW5nG2QZnu+s9iQUJqy6KO1+5A16Z/kPAh+g8AYAw0=;
	b=Od2POY6tD4Kj2LPmBa4yBw5iYqkUkK9yN6PBUkoVCVi3huscICLs3vn8tqHaTKL+IeJMWF
	f+hulDfrH7j3BWlwGjUbNXGAmr4/RN1T9RwhYBEVJj4EecJQl4lO+kB+F69sgSzMtiku/0
	qNq7T9/qovXkojIgv6EBoUGZp1qnj88=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-73-DK4QYsFjMw-ctM-StEw2FQ-1; Tue,
 03 Jun 2025 01:20:30 -0400
X-MC-Unique: DK4QYsFjMw-ctM-StEw2FQ-1
X-Mimecast-MFC-AGG-ID: DK4QYsFjMw-ctM-StEw2FQ_1748928029
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9DCE1955DB5;
	Tue,  3 Jun 2025 05:20:28 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.30])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 60B9F30002C4;
	Tue,  3 Jun 2025 05:20:25 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	song@kernel.org,
	ncroxon@redhat.com
Subject: [PATCH V3 0/2] md: call del_gendisk in sync way
Date: Tue,  3 Jun 2025 13:20:20 +0800
Message-Id: <20250603052023.7922-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Now del_gendisk is called in a queue work which has a small window
that mdadm --stop command exits but the device node still exists.
It causes trouble in regression tests. This patch set tries to resolve
this problem.

By the way, this change will cause a regression problem and which will
be fixed by https://github.com/md-raid-utilities/mdadm/pull/182

v1: replace MD_DELETED with MD_CLOSING
v2: keep MD_CLOSING
v3: call den_gendisk in mddev_unlock, and remove ->to_remove in stop path
and adjust the order of patches

Xiao Ni (3):
  md: call del_gendisk in control path
  md: Don't clear MD_CLOSING until mddev is freed
  md: remove/add redundancy group only in level change

 drivers/md/md.c | 71 +++++++++++++++++++++++++------------------------
 drivers/md/md.h | 26 ++++++++++++++++--
 2 files changed, 60 insertions(+), 37 deletions(-)

-- 
2.32.0 (Apple Git-132)

