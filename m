Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AE517DE36
	for <linux-raid@vger.kernel.org>; Fri, 18 Oct 2024 08:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729241310; cv=none; b=ChgasS31p4EAe1SgtRB+oFHyRKdLm82YPaIlOLyfvwkUNutElBCquqJQf/28JmmzGcNTrJkiBHUuqB/kCcJwnLB6q/3pSFzpYLFh5VXRhC4suaN1AVoU0S6zhGtYy2BKTFQbpi96JGc23Jc2du5MdmNqAdw8H7BvAAVTMQOX9Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729241310; c=relaxed/simple;
	bh=H23sDLzfe3RlxCt04EGm0WQm+xIatOvwK8+n2gSTN6U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sq48ctnjQWu56bDuEkWiDAUNLbuoQaEFMwBJU4wegBcM6V4QV3f5fUEpg7EwhnfyuOXvKOyqegRKHscwchDZvzmWwQR/ST2ALpfwEJDxtIrOug4HIo/3W5xJ/ktrj87umYvvUI17iVcazDvisWdkLjN21QDgQqSEbfOa9NodfMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FJAZB5sl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FJAZB5sl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729241305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=soF6xdMWaaMug8ehANVZEGKuzE3v5SxUJKGIAShRT5I=;
	b=FJAZB5slxosax0oVZSMxyOynaCPhAARFKw5W0jiZZkX4xBRSSFGpOGqbTXpgovXud3ELZw
	22A6PkYWPdvkgvAT61sXO2aUAB6teK474a8uTlRy3Vht9c5HW8IaXypRJ25juJC1bE/y3h
	J3YRGbCALecftc3kcaebr4jtzfSM6uQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-354-eUSgOkkTPEaR6IOVJJJ5xg-1; Fri,
 18 Oct 2024 04:48:23 -0400
X-MC-Unique: eUSgOkkTPEaR6IOVJJJ5xg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E4201944D07;
	Fri, 18 Oct 2024 08:48:22 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.5])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0DB0B1955F43;
	Fri, 18 Oct 2024 08:48:19 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 0/2] mdadm: minor fixes
Date: Fri, 18 Oct 2024 16:48:15 +0800
Message-Id: <20241018084817.60233-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Xiao Ni (2):
  mdadm/Manage: Clear superblock if adding new device fails
  mdadm/Grow: Check new_level interface rather than kernel version

 Grow.c   | 2 +-
 Manage.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

-- 
2.32.0 (Apple Git-132)

