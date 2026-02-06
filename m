Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E2233A036
	for <linux-raid@vger.kernel.org>; Fri,  6 Feb 2026 05:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770356317; cv=none; b=i9UQYpJ0bxLFxayyFABA5Cca92QzznDECVntqzrmpPi+J+koD6HOV+UnHtxAFSG87chq68ge7JKBSlGPqBD4YHowCQJR3Mq86XwdURxb9p/SxjtOAu/PwQs3yXCcaYoj1coVHVXY1o7yeLHHHZQC2JWgbapMckHrA9wDi8X9v8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770356317; c=relaxed/simple;
	bh=7b1rroJ1oiQkx2Rki1LMX5LUFPGshKUuSI5qMRRjP4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zfu6IsPJFN0dTcqcmiv13SdqjW2FfI+F+BX1Os9Z1GnQWeD/4JahnBACKWJkMQmVW/v/6KwvZsl37h5cluV5NMI4TltWBBZ/HQ4LD5qp3DURSOlL/vYZFhGrxHnnyaeoW1EpVTQlOLcf+bFjFj5I8L4kKJm/KOFG11RdspJrKos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KNuEDzCW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KNuEDzCW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770356316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VJRa5KWLYKNarlt0llwQlmwJgB8EnDOQs3d1oK49UMk=;
	b=KNuEDzCWvGORQMJg/waU7cmAO/uboHScAwNwzgHaL46Vo1cH+tyKkmGrz4LGg1xgpn3OlT
	jcYmHJ2ZLHZ/YD9IkLT+W65W8Cq1UPV4+zmn2FrfVgYEzUFZXR097CJBvNIw2NIkk71LNu
	iygntJ8ImaBt32Pn22sxm7UFy/OvzmU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-439-8AhetHuzOBe8SJudsLLonA-1; Fri,
 06 Feb 2026 00:38:33 -0500
X-MC-Unique: 8AhetHuzOBe8SJudsLLonA-1
X-Mimecast-MFC-AGG-ID: 8AhetHuzOBe8SJudsLLonA_1770356312
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9EF7F180047F;
	Fri,  6 Feb 2026 05:38:31 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.133])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 27E3919560A7;
	Fri,  6 Feb 2026 05:38:28 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai@fnnas.com
Cc: song@kernel.org,
	linux-raid@vger.kernel.org,
	linan666@huaweicloud.com
Subject: [PATCH 0/2] md/raid1: serialize overlapped ios for writemostly device
Date: Fri,  6 Feb 2026 13:38:17 +0800
Message-ID: <20260206053826.37416-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Xiao Ni (2):
  md/raid1: fix the comparing region of interval tree
  md/raid1: serialize overlap io for writemostly disk

 drivers/md/md.c    |  1 -
 drivers/md/md.h    |  4 +++-
 drivers/md/raid1.c | 43 +++++++++++++++++++++++++++++++------------
 3 files changed, 34 insertions(+), 14 deletions(-)

-- 
2.50.1 (Apple Git-155)

