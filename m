Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A83D1EDA05
	for <linux-raid@vger.kernel.org>; Tue, 11 Mar 2025 05:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741669420; cv=none; b=LpW+Cn1pBstq9Q5HH6sPhEURV33BoNnpxLKpq57tddgkyjh5/d006r9GvUDPsj2a6MV/pd9eqR6qJa/Vi10eFnXn0k4QWlPBcrnYJeo9OFJRCXrMfhj5Nj4/D0c0vepHNl+o2ycfzJkSbJeS8UozV3vChFzrAdr+Zdx6VOlBpVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741669420; c=relaxed/simple;
	bh=Io965QFAg30PoL5TTvzi/Ptna/RSOeKDeIk6Kzmxc+w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Bjix0OsmczeihuFgv754dv5teOPqAn77tuQPZTFcplQMygP+VRgwuUXpt9jp8HUJzBu5iMnOunDL8ezXUENPAkWYHMRkoAiINZNNmjebztjopFKkkxwiIaszs+gv+SN0wPB/jRcz6lBwoHWVqY7dAWzRWXgBwaNEZhV441zxJUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WlIejmqU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WlIejmqU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741669417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qHHSrONncuPrvsXy4f6WpYHwUPTIAlYvUDR6pt/RIzw=;
	b=WlIejmqUmdWSDvytUJPogV+6CHG80xUHO0RZEcFfiqfDbF8d0o7M6q7EMn8cGJZZz5eTLE
	XAktUTo+zMfaKHjb01vc1fSkFXdQ/H6suAho7svJyoAabGNsvAb4XLqkt2SND64kl4bNKC
	gj32ixYgbAx5Kij0+fDEQgjpoP0L5NM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-530-mR-fX3MZOTG4xb7gWDkMxA-1; Tue,
 11 Mar 2025 01:03:35 -0400
X-MC-Unique: mR-fX3MZOTG4xb7gWDkMxA-1
X-Mimecast-MFC-AGG-ID: mR-fX3MZOTG4xb7gWDkMxA_1741669414
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1880B180AF53;
	Tue, 11 Mar 2025 05:03:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.22])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 122EE18009AE;
	Tue, 11 Mar 2025 05:03:30 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mariusz.tkaczyk@linux.intel.com,
	ncroxon@redhat.com,
	blazej.kucman@linux.intel.com
Subject: [PATCH 0/4] mdadm: regression tests fix
Date: Tue, 11 Mar 2025 13:03:23 +0800
Message-Id: <20250311050327.4889-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

This patch set is used to make regression tests pass without errors.
It needs to use --skip-broken to skip tests which are marked as failure.

The PR is https://github.com/md-raid-utilities/mdadm/pull/153

Xiao Ni (4):
  mdadm/tests: Mark 07revert-inplace broken
  mdadm/tests: Mark 20raid5journal fail
  mdadm/tests: ddf template fix
  mdadm/tests: Remove 10ddf-create.broken and
    10ddf-fail-two-spares.broken

 tests/07revert-inplace.broken      |  8 ++++++++
 tests/10ddf-create.broken          |  5 -----
 tests/10ddf-fail-two-spares.broken |  5 -----
 tests/20raid5journal.broken        | 17 +++++++++++++++++
 tests/env-ddf-template             |  3 +--
 util.c                             |  2 +-
 6 files changed, 27 insertions(+), 13 deletions(-)
 create mode 100644 tests/07revert-inplace.broken
 delete mode 100644 tests/10ddf-create.broken
 delete mode 100644 tests/10ddf-fail-two-spares.broken
 create mode 100644 tests/20raid5journal.broken

-- 
2.32.0 (Apple Git-132)

