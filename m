Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD537F7DB
	for <linux-raid@vger.kernel.org>; Fri, 19 Jul 2024 09:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721382751; cv=none; b=ilCIJarh9NfYm5gMdyHruF4pka5CGV1WhGL56Yuny/+lXFQVg5riW8jRZd5nrj9SN4c7yuCimgkjcbJvRgRU8O68Nb24UIeaUCMV9qtRXLm1ChRO+zNI/5iXr3FRkhJS3S8MBMrUYMe3NJlCkA2rwUuj/mNHbIRUrwfEFBFWFLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721382751; c=relaxed/simple;
	bh=mAXVNBETz5ILyI6C03rte0bGASKky2Ukx5z2ZNenvy0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=knDJbBvsGxCcJljkKavJEukIs0H37TI/0GDNU5MS4WBP+Uy1e9ntW335wGrwWxmSgAStR+Q+ZwJu2o1RtIEwh+OLUcPoY3VLDjQ//Kasu2cleJl0zF3eSXEzEYzHvAQihk+o70oODtKbxVnYu6yAJgV37ICsPLnuCwRXAi85vqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QV/BST8i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QV/BST8i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721382748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IDUt88c77yAafCZDTt86qhBHdubZaNzbeByVBx+egWg=;
	b=QV/BST8iNMTsrcogTVdDPerN9fCnXrSiQeDHon1jCGH+rYixr5DxWwiU8LzwfihuOBQXE4
	fXRdX/YGSTDLObM0wv5cC9CzZk6t4QoK0x3EREwCDyWIBbDUuNGx6pB7q89CexZGyBBrJP
	qZACkKqAZAMVmMeoPj4SZbv4Q6ZQKzs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-336-VvD107vsN_euG6X7WPiPRA-1; Fri,
 19 Jul 2024 05:52:26 -0400
X-MC-Unique: VvD107vsN_euG6X7WPiPRA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 96FC31955D54;
	Fri, 19 Jul 2024 09:52:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.6])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CCEC81955F6B;
	Fri, 19 Jul 2024 09:52:22 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH V2 00/14] mdadm: fix coverity issues
Date: Fri, 19 Jul 2024 17:52:05 +0800
Message-Id: <20240719095219.9705-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

V2: replace close with close_fd and use is_fd_valid

Xiao Ni (14):
  mdadm/Grow: fix coverity issue CHECKED_RETURN
  mdadm/Grow: fix coverity issue RESOURCE_LEAK
  mdadm/Grow: fix coverity issue STRING_OVERFLOW
  mdadm/Incremental: fix coverity issues.
  mdadm/mdmon: fix coverity issue CHECKED_RETURN
  mdadm/mdmon: fix coverity issue RESOURCE_LEAK
  mdadm/mdopen: fix coverity issue CHECKED_RETURN
  mdadm/mdopen: fix coverity issue STRING_OVERFLOW
  mdadm/mdstat: fix coverity issue CHECKED_RETURN
  mdadm/super0: fix coverity issue CHECKED_RETURN and EVALUATION_ORDER
  mdadm/super1: fix coverity issue CHECKED_RETURN
  mdadm/super1: fix coverity issue DEADCODE
  mdadm/super1: fix coverity issue EVALUATION_ORDER
  mdadm/super1: fix coverity issue RESOURCE_LEAK

 Grow.c        | 92 +++++++++++++++++++++++++++++++++++++++++----------
 Incremental.c | 20 +++++------
 mdmon.c       | 17 +++++++---
 mdopen.c      |  8 +++--
 mdstat.c      | 12 +++++--
 super0.c      | 10 ++++--
 super1.c      | 32 +++++++++++++-----
 7 files changed, 142 insertions(+), 49 deletions(-)

-- 
2.41.0

