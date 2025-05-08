Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556542288F7
	for <linux-raid@vger.kernel.org>; Thu,  8 May 2025 12:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746708524; cv=none; b=jol9VKJ9EgspWwV5xzmNPh64BFLw6/+D0KyJXA6/jSrub2vVo8vNmlC5pMSUwSynCZCC4VjVYPfAgbsHy24Addp2ZgYyOCLyX73EqP/99v5G7+xpz229VcX+87E+zqxsOoilKE4Aj6Gv0RxXfEopI4dJRdxXSkxyQIUkIsKB7Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746708524; c=relaxed/simple;
	bh=ZsPCoMw9KdI5Pn+nKlsBExJKsbUjb8pZSKRKXFyEpOk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BCxAc4DXs0l/SKXQO5iZeZjsR4WiNacl1/7EtJBirhwJuVuo3OGtSp8vG59hB9aInQupj7fP5EsPfrars2dNsS7va+0o2wF1EenKY8dTijBtz+g8vVeLAKTOHw2AsKH4IWajg9QGNIIE/Sm2WYF1tQeM3K0gINF2CUIJsOq5ofM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YslD3I89; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YslD3I89"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746708520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xsneX+ii4qBxW7JBTltxwtU1WilpoBGSaIFylEwKvh0=;
	b=YslD3I89cVI1jVTwctpeJjAnvqxCqbyMxitxQ74c+hwaVsgS93OMJ1egHhiSoAo8vDaOVF
	1jlbCKLPR2OIr+C3Gw9WjbAV66PP5oW0SdyNKaodu1mvo8izayG1NzWX1MUUeY/6cfCBA6
	2QgeAw+MUilPCEBvWcmU7d4shwUfivU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-384-IbQAMJykOmKLnxdXVPa36Q-1; Thu,
 08 May 2025 08:48:38 -0400
X-MC-Unique: IbQAMJykOmKLnxdXVPa36Q-1
X-Mimecast-MFC-AGG-ID: IbQAMJykOmKLnxdXVPa36Q_1746708517
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A7A981955E79;
	Thu,  8 May 2025 12:48:37 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ED52219560B3;
	Thu,  8 May 2025 12:48:34 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mtkaczyk@kernel.org,
	ncroxon@redhat.com
Subject: [PATCH v2 0/7] mdadm: minor fixes
Date: Thu,  8 May 2025 20:48:24 +0800
Message-Id: <20250508124831.32742-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

There are some building errors and regression bug.
The PR is at https://github.com/md-raid-utilities/mdadm/pull/178

v2 adds the 4 more patches.

Xiao Ni (7):
  mdadm: use standard libc nftw
  mdadm: fix building errors
  mdadm: add attribute nonstring for signature
  mdadm: give more time to wait sync thread to reap
  mdadm/tests: mark 10ddf-fail-two-spares broken
  mdadm/tests: mark 09imsm-assemble broken
  mdadm/tests: mark 10ddf-fail-readd-readonly broken

 lib.c                                  | 22 -------------------
 platform-intel.h                       |  2 +-
 super-ddf.c                            |  9 ++++----
 super-intel.c                          |  3 ++-
 tests/09imsm-assemble.broken           | 30 ++++++++++++++++++++++++++
 tests/10ddf-fail-readd-readonly.broken | 22 +++++++++++++++++++
 tests/10ddf-fail-two-spares.broken     | 11 ++++++++++
 tests/func.sh                          |  5 ++++-
 8 files changed, 75 insertions(+), 29 deletions(-)
 create mode 100644 tests/09imsm-assemble.broken
 create mode 100644 tests/10ddf-fail-readd-readonly.broken
 create mode 100644 tests/10ddf-fail-two-spares.broken

-- 
2.32.0 (Apple Git-132)

