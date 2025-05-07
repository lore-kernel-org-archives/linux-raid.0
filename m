Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA708219ED
	for <linux-raid@vger.kernel.org>; Wed,  7 May 2025 02:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746584068; cv=none; b=pxhj1nsYWe+XWqd98KDAiam25bUe5hW7KoitMFjIZ+yKSd7cKUKeQGNStkOassN9BuLj4UImVFJ9zKjjljJR+r5P0TYPLrieQ3BYREqdWe3uWUECpiJtjoeMbcdZEAhFZUstgunO6FEthvh445gm2a89+GYL0YIKjZm1n4Josfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746584068; c=relaxed/simple;
	bh=XsU6lj9OQZ09m4ED2JtvUCJKnge9qlwICxSRx5Dd8ew=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dsWWjFO+p2EpTSRXSq68IOjvMlsU5MZ3IN9hc2qrFw2TZQs4RYFRgsIZ8uT9NpzXxHGxSy39dqwVKAfursoO+Z1j3+Pfz2NYRhTse1NDwtaRr3wfQGf8AIFVkf4He7Qdn2pDqB1H2DKcq0WwcF6+OC2ZfneCoBxwTBFtpAeGmow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T+lkP+q5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T+lkP+q5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746584065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pPpq8dRnaGNt7udi9TFMBz/KDeLcyad9CfcQzNJ4aQ0=;
	b=T+lkP+q55tkEJi4I9UCpaPd4OVe4pGwr3mKoBRoQq+bawRFDhGpgV+7v9Y449NHlolLx0P
	DPENwuHNEp61+nesXl2NzdB+vFtWznxBtfm1NVue5kDwguIbtPPxNpg726XCaxI0C/lKOm
	4bJf9vpg5Wny4PRY8MP7zs82QSsjQ+U=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-304-OH8mepUuOHmTQqSOTsoMXw-1; Tue,
 06 May 2025 22:14:22 -0400
X-MC-Unique: OH8mepUuOHmTQqSOTsoMXw-1
X-Mimecast-MFC-AGG-ID: OH8mepUuOHmTQqSOTsoMXw_1746584061
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D6391955D76;
	Wed,  7 May 2025 02:14:21 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.22])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 17D7418001D5;
	Wed,  7 May 2025 02:14:17 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai1@huaweicloud.com,
	ncroxon@redhat.com
Subject: [PATCH 0/3] md: call del_gendisk in sync way
Date: Wed,  7 May 2025 10:14:12 +0800
Message-Id: <20250507021415.14874-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Now del_gendisk is called in a queue work which has a small window
that mdadm --stop command exits but the device node still exists.
It causes trouble in regression tests. This patch set tries to resolve
this problem.

Xiao Ni (3):
  md: Don't clear MD_CLOSING until mddev is freed
  md: replace MD_DELETED with MD_CLOSING
  md: call del_gendisk in sync way

 drivers/md/md.c | 38 +++++++++++++++++++-------------------
 drivers/md/md.h |  2 --
 2 files changed, 19 insertions(+), 21 deletions(-)

-- 
2.32.0 (Apple Git-132)

