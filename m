Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A04170818
	for <linux-raid@vger.kernel.org>; Thu,  5 Mar 2026 01:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772673529; cv=none; b=bvYc+h59yZ202lMC3arxpxNy6UvCihl+o5HIRUYPox0MCYMtSiVR3HFeOw78YF2zfhCK20e+DeIr7kBz93tpzcaPGGQM/LHK0AhTFIIl6f/Z+npiQ0i/O4BT+gx6GvIBy0V6Rk31JN6NJ2cL/+g2HIo/7oXIlb4tp+tvP+jg61E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772673529; c=relaxed/simple;
	bh=Vcw4rlARdD1959OswOXHqUCiCZOes0xs/t2Mw0FSdZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MxtSaw/q8L6P5cnu/sVzYNDQIy/eBbCl0YTpDmDeMUun3vvp3fw4Fk7NIC4BYSXmZqK3BbNvNvn2pUDgwmQIMlLEch8zFSEk89pJ1GwFo3d6gj8SMGaGTQZs5Qj9cVXOEWpLjLjSPiT6bRFw5BhQhMkyZfzhaUlcdKztuCp1A98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XCGj5wzA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XCGj5wzA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772673526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Mf2xoFwp/Rnx8FZwMbu/RgFD13wInqP81iICptnUJ4A=;
	b=XCGj5wzAqf5dfwFekSQ1Z4PE/XFDyG+GvHdSxT57KcE2+bQdJzFq+1HWFTgJlL9w8x8RGl
	GFyj6PhAX5AHVA9zRf+udZe18ixk7+hEdPFjlBNWgRMWIa1U7FHQH/KwR2VdjzxeaAw3kZ
	xIE71q466c9Oc2My6Y7I2ozUHaZyBdM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-118--DuKCwumO928JarFYMdjlw-1; Wed,
 04 Mar 2026 20:18:45 -0500
X-MC-Unique: -DuKCwumO928JarFYMdjlw-1
X-Mimecast-MFC-AGG-ID: -DuKCwumO928JarFYMdjlw_1772673525
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B96F01956059;
	Thu,  5 Mar 2026 01:18:44 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.20])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6A66D30001A1;
	Thu,  5 Mar 2026 01:18:41 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH v2 0/2] md/raid1: serialize overlapped ios for writemostly device
Date: Thu,  5 Mar 2026 09:18:32 +0800
Message-ID: <20260305011839.5118-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Xiao Ni (2):
  md/raid1: fix the comparing region of interval tree
  md/raid1: serialize overlap io for writemostly disk

 drivers/md/raid1.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

-- 
2.50.1 (Apple Git-155)

