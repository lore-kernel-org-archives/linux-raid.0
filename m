Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752822F85B
	for <linux-raid@vger.kernel.org>; Wed, 11 Jun 2025 07:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749627080; cv=none; b=fqL1jGLLgh2yX2lg0Q9jzsk/pI1iUEtk/68cbKPyIjz2MaorI8nNXkaxzlndCZrDFo8+1tUtP6eL+JywCFt8zYaivgXCe+gSekzbDIRKUjcbTLHT2lOvNGXOZhMd/mFa2yrYWfuOx4AfGVuEyiiYqVIJkbOALC4eb48sggE6AYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749627080; c=relaxed/simple;
	bh=TT7ZKHekRjpwSAJiH+HshJRFo3Zw2TIuVarLj6ee2MQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=u6QvP1ss229LxKqGJik00XbjiqJy7kcNXSk5K8OURBlSgntNk/yeY/TYh3YAd+QktCvJ3hnIVmO0IFntFT130FkqYt9zlNQ47vic5wnMXK+OhVKcgb5TuKEIsL7OVXqp36LitFEviEusOxt/KHIG3Ac+Ol+xYR/F94MLqolcdyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yq1buse/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yq1buse/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749627077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5MfRp59o8Y01WyAORYOQaGHHNy714KD7SQgVr8r8H04=;
	b=Yq1buse/mquridsQBqn0y2K/Q/cLvcnqD5iKucL0ZJsATXIF10HICpvMIkBkBQMMzdQQVT
	RbAC2eErNnzmeZ49wVHMpsmJpMpPXsMnGDOo5otMR5ykx+l0024bgcU7vfl1XHENjuLQk8
	dqgZABrVbtJ5HBo6j8+FbToESaOJRBE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-369-09MVrjgaN_W15x_iDqunAg-1; Wed,
 11 Jun 2025 03:31:15 -0400
X-MC-Unique: 09MVrjgaN_W15x_iDqunAg-1
X-Mimecast-MFC-AGG-ID: 09MVrjgaN_W15x_iDqunAg_1749627074
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F32271800294;
	Wed, 11 Jun 2025 07:31:13 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.30])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 925A6180045B;
	Wed, 11 Jun 2025 07:31:10 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	ncroxon@redhat.com,
	song@kernel.org,
	yukuai1@huaweicloud.com
Subject: [PATCH V6 0/3] md: call del_gendisk in sync way
Date: Wed, 11 Jun 2025 15:31:05 +0800
Message-Id: <20250611073108.25463-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

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
v6: don't initialize ret and add reviewed-by tag

Xiao Ni (3):
  md: call del_gendisk in control path
  md: Don't clear MD_CLOSING until mddev is freed
  md: remove/add redundancy group only in level change

 drivers/md/md.c | 49 ++++++++++++++++++++++++++-----------------------
 drivers/md/md.h | 26 ++++++++++++++++++++++++--
 2 files changed, 50 insertions(+), 25 deletions(-)

-- 
2.32.0 (Apple Git-132)

